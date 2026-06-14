package com.example.platform_channels_benchmarks

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryCodec
import io.flutter.plugin.common.StandardMessageCodec
import java.nio.ByteBuffer

class MainActivity: FlutterActivity() {
    // We allow for the caching of a response in the binary channel case since
    // the reply requires a direct buffer, but the input is not a direct buffer.
    // We can't directly send the input back to the reply currently.
    private var byteBufferCache: ByteBuffer? = null;

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        val reset = BasicMessageChannel(flutterEngine.dartExecutor, "hungknow.reset", StandardMessageCodec.INSTANCE)
        reset.setMessageHandler { message, reply -> run {
            byteBufferCache = null
        }}
        val basicChannel = BasicMessageChannel(flutterEngine.dartExecutor, "hungknow.basic.standard", StandardMessageCodec.INSTANCE)
        basicChannel.setMessageHandler { message, reply -> reply.reply(message) }
        super.configureFlutterEngine(flutterEngine)

        val binaryChannel = BasicMessageChannel(flutterEngine.dartExecutor, "hungknow.basic.binary", BinaryCodec.INSTANCE)
        binaryChannel.setMessageHandler { message, reply -> run {
            if (byteBufferCache == null) {
                byteBufferCache = ByteBuffer.allocateDirect(message!!.capacity())
                byteBufferCache!!.put(message)
            }
            reply.reply(byteBufferCache)
        }}
    }
}
