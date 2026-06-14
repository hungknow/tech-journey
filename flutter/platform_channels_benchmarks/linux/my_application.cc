#include "my_application.h"

#include <flutter_linux/flutter_linux.h>
#ifdef GDK_WINDOWING_X11
#include <gdk/gdkx.h>
#endif

#include "flutter/generated_plugin_registrant.h"

struct _MyApplication
{
  GtkApplication parent_instance;
  char **dart_entrypoint_arguments;
};

G_DEFINE_TYPE(MyApplication, my_application, GTK_TYPE_APPLICATION)

// FlMethodChannel *binaryChannel;
FlBasicMessageChannel *resetStandardMessageChannel;
FlBasicMessageChannel *standardMessageChannel;
FlBasicMessageChannel *binaryMessageChannel;
FlValue *byteBufferCache; 

void resetBasicMessageChannelSetMessageHandler(
    FlBasicMessageChannel* channel,
    FlValue* message,
    FlBasicMessageChannelResponseHandle* response_handle,
    gpointer user_data)
{
  if (byteBufferCache != NULL) {
    fl_value_unref(byteBufferCache);
    byteBufferCache = NULL;
  }
  g_autoptr(GError) error = NULL;
  fl_basic_message_channel_respond(channel, response_handle, NULL, &error);
}

void standardBasicMessageChannelSetMessageHandler(
    FlBasicMessageChannel* channel,
    FlValue* message,
    FlBasicMessageChannelResponseHandle* response_handle,
    gpointer user_data)
{
  // printf("standardBasicMessageChannelSetMessageHandler called\n");
  g_autoptr(GError) error = NULL;
  fl_basic_message_channel_respond(channel, response_handle, message, &error);
}

void binaryBasicMessageChannelSetMessageHandler(
    FlBasicMessageChannel* channel,
    FlValue* message,
    FlBasicMessageChannelResponseHandle* response_handle,
    gpointer user_data)
{
  g_autoptr(GError) error = NULL;
  // printf("length: %lu\n", fl_value_get_length(message));
  if (byteBufferCache == NULL) {
    byteBufferCache = fl_value_new_uint8_list(fl_value_get_uint8_list(message), fl_value_get_length(message));
  }
  fl_basic_message_channel_respond(channel, response_handle, byteBufferCache, &error);
}

void registerPlatformChannel(FlView *view)
{
  FlEngine *engine = fl_view_get_engine(view);

  g_autoptr(FlStandardMessageCodec) standardMessageCodec = fl_standard_message_codec_new();
  g_autoptr(FlBinaryCodec) binaryCodec = fl_binary_codec_new();
  g_autoptr(FlBinaryMessenger) binaryMessage = fl_engine_get_binary_messenger(engine);

  resetStandardMessageChannel = fl_basic_message_channel_new(binaryMessage, "hungknow.reset", FL_MESSAGE_CODEC(standardMessageCodec));
  standardMessageChannel = fl_basic_message_channel_new(binaryMessage, "hungknow.basic.standard", FL_MESSAGE_CODEC(standardMessageCodec));
  binaryMessageChannel = fl_basic_message_channel_new(binaryMessage, "hungknow.basic.binary", FL_MESSAGE_CODEC(binaryCodec));

  fl_basic_message_channel_set_message_handler(resetStandardMessageChannel, resetBasicMessageChannelSetMessageHandler, g_object_ref(view), g_object_unref);
  fl_basic_message_channel_set_message_handler(standardMessageChannel, standardBasicMessageChannelSetMessageHandler, g_object_ref(view), g_object_unref);
  fl_basic_message_channel_set_message_handler(binaryMessageChannel, binaryBasicMessageChannelSetMessageHandler, g_object_ref(view), g_object_unref);
}

// Implements GApplication::activate.
static void my_application_activate(GApplication *application)
{
  MyApplication *self = MY_APPLICATION(application);
  GtkWindow *window =
      GTK_WINDOW(gtk_application_window_new(GTK_APPLICATION(application)));

  // Use a header bar when running in GNOME as this is the common style used
  // by applications and is the setup most users will be using (e.g. Ubuntu
  // desktop).
  // If running on X and not using GNOME then just use a traditional title bar
  // in case the window manager does more exotic layout, e.g. tiling.
  // If running on Wayland assume the header bar will work (may need changing
  // if future cases occur).
  gboolean use_header_bar = TRUE;
#ifdef GDK_WINDOWING_X11
  GdkScreen *screen = gtk_window_get_screen(window);
  if (GDK_IS_X11_SCREEN(screen))
  {
    const gchar *wm_name = gdk_x11_screen_get_window_manager_name(screen);
    if (g_strcmp0(wm_name, "GNOME Shell") != 0)
    {
      use_header_bar = FALSE;
    }
  }
#endif
  if (use_header_bar)
  {
    GtkHeaderBar *header_bar = GTK_HEADER_BAR(gtk_header_bar_new());
    gtk_widget_show(GTK_WIDGET(header_bar));
    gtk_header_bar_set_title(header_bar, "platform_channels_benchmarks");
    gtk_header_bar_set_show_close_button(header_bar, TRUE);
    gtk_window_set_titlebar(window, GTK_WIDGET(header_bar));
  }
  else
  {
    gtk_window_set_title(window, "platform_channels_benchmarks");
  }

  gtk_window_set_default_size(window, 1280, 720);
  gtk_widget_show(GTK_WIDGET(window));

  g_autoptr(FlDartProject) project = fl_dart_project_new();
  fl_dart_project_set_dart_entrypoint_arguments(project, self->dart_entrypoint_arguments);

  FlView *view = fl_view_new(project);
  gtk_widget_show(GTK_WIDGET(view));
  gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(view));

  fl_register_plugins(FL_PLUGIN_REGISTRY(view));

  registerPlatformChannel(view);

  gtk_widget_grab_focus(GTK_WIDGET(view));
}

// Implements GApplication::local_command_line.
static gboolean my_application_local_command_line(GApplication *application, gchar ***arguments, int *exit_status)
{
  MyApplication *self = MY_APPLICATION(application);
  // Strip out the first argument as it is the binary name.
  self->dart_entrypoint_arguments = g_strdupv(*arguments + 1);

  g_autoptr(GError) error = nullptr;
  if (!g_application_register(application, nullptr, &error))
  {
    g_warning("Failed to register: %s", error->message);
    *exit_status = 1;
    return TRUE;
  }

  g_application_activate(application);
  *exit_status = 0;

  return TRUE;
}

// Implements GObject::dispose.
static void my_application_dispose(GObject *object)
{
  MyApplication *self = MY_APPLICATION(object);
  g_clear_pointer(&self->dart_entrypoint_arguments, g_strfreev);
  G_OBJECT_CLASS(my_application_parent_class)->dispose(object);
}

static void my_application_class_init(MyApplicationClass *klass)
{
  G_APPLICATION_CLASS(klass)->activate = my_application_activate;
  G_APPLICATION_CLASS(klass)->local_command_line = my_application_local_command_line;
  G_OBJECT_CLASS(klass)->dispose = my_application_dispose;
}

static void my_application_init(MyApplication *self) {}

MyApplication *my_application_new()
{
  return MY_APPLICATION(g_object_new(my_application_get_type(),
                                     "application-id", APPLICATION_ID,
                                     "flags", G_APPLICATION_NON_UNIQUE,
                                     nullptr));
}
