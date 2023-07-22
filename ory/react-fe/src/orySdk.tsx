import { Configuration, FrontendApi, UiNode, UiNodeInputAttributes, UiNodeMeta } from "@ory/client";
import React, { useCallback } from "react";
import { AxiosError } from "axios";
import { useNavigate } from "react-router-dom";
import { isUiNodeInputAttributes } from "@ory/integrations/ui";

export const oryClient = new FrontendApi(
  new Configuration({
    basePath: process.env.REACT_APP_ORY_URL,
    baseOptions: {
      withCredentials: true,
    },
  })
);

export const useOrySdk = (
  getFlow: ((flowId: string) => Promise<void | AxiosError>) | undefined,
  setFlow: React.Dispatch<React.SetStateAction<any>> | undefined,
  defaultNav: string | undefined,
  fatalToDash = false
) => {
  const navigate = useNavigate();
  return useCallback(
    (error: AxiosError): Promise<AxiosError | void> => {
      const responseData = error.response?.data || {};
      switch (error.response?.status) {
        case 400: {
          if (error.response.data?.error?.id === "session_already_available") {
            console.warn(
              "sdkError 400: `session_already_available`. Navigate to /",
            )
            navigate("/", { replace: true })
            return Promise.resolve()
          }
          // the request could contain invalid parameters which would set error messages in the flow
          if (setFlow !== undefined) {
            console.warn("sdkError 400: update flow data")
            setFlow(responseData)
            return Promise.resolve()
          }
          break
        }
        case 401: {
          console.warn("sdkError 401: Navigate to /login")
          navigate("/login", { replace: true })
          return Promise.resolve()
        }
        case 403: {
          break;
        }
        case 404: {
          break;
        }
        case 410: {
          break;
        }
        case 422: {
          // For OIDC, we need to redirect to the provider login page
          if (responseData.redirect_browser_to !== undefined) {
            const currentUrl = new URL(window.location.href);
            const redirect = new URL(responseData.redirect_browser_to, window.location.origin);
            if (currentUrl.pathname != redirect.pathname) {
              // remove /ui prefix from the path in case it is present (not setup correctly inside the project config)
              // since this is an SPA we don't need to redirect to the Account Experience.
              redirect.pathname = redirect.pathname.replace("/ui", "")
              console.log('redirect.pathname ', redirect.pathname );
              navigate(redirect.pathname + redirect.search, {
                replace: true,
              });
              return Promise.resolve();
            }
          }
          break;
        }
      }

      // error.response?.data?.ui.messages.forEach((message) => {
      //   console.log(message)
      // })

      // console.error(error);

      if (error.response?.status === 400) {
        // method level error
        // messages is an array of error messages
        error.response?.data?.ui?.messages?.forEach((message: any) => {
          console.log(message);
        });

        // field level error
        error.response?.data?.ui?.nodes?.forEach(
          ({ messages }: { messages: string[] }) => {
            // messages is an array of error messages
            messages.forEach((message) => {
              console.log(message);
            });
          }
        );
      } else {
        // request level error
        if (error.response?.data?.error) {
          console.log(error.response.data.error);
        }
      }

      throw error;
    },
    [getFlow, navigate]
  );
};


// From the UiNode data structure, display the corresponding UI
export const mapUINode = (node: UiNode, key: number) => {
  if (isUiNodeInputAttributes(node.attributes)) {
    const meta = node.meta as UiNodeMeta;
    const attrs = node.attributes as UiNodeInputAttributes;
    const nodeType = attrs.type;

    switch (nodeType) {
      case "button":
      case "submit":
        return (
          <button
            type={attrs.type as "submit" | "reset" | "button" | undefined}
            name={attrs.name}
            value={attrs.value}
            key={key}
          >
            {meta && meta.label && meta.label.text}
          </button>
        );
      default:
        if (attrs.name === 'provider') {
          return <button
            type={attrs.type as "submit" | undefined}
            name={attrs.name}
            value={attrs.value}
            key={key}
          >
            {meta && meta.label && meta.label.text}
          </button>
        }
        return (
          <div>
            {meta && meta.label && (
              <label key={meta.label.id} htmlFor={attrs.name}>{meta.label.text}: </label>
            )}
            <input
              name={attrs.name}
              type={attrs.type}
              autoComplete={
                attrs.autocomplete || attrs.name === "identifier"
                  ? "username"
                  : ""
              }
              defaultValue={attrs.value}
              required={attrs.required}
              disabled={attrs.disabled}
              key={key}
            />
          </div>
        );
    }
  }
};
