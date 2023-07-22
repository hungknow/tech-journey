import React, { useCallback, useEffect, useState } from "react";
import { mapUINode, oryClient, useOrySdk } from "../orySdk";
import {
  LoginFlow,
  UpdateLoginFlowBody,
  UpdateLoginFlowWithOidcMethod,
} from "@ory/client";
import { filterNodesByGroups } from "@ory/integrations/ui";
import { FlowUiMessage } from "./FlowUiMessage";
import { Link, useNavigate } from "react-router-dom";

export interface LoginProps {
  flowId?: string | null;
  aal2?: string | null;
}

// If flow is existing, getFlow with Flow ID to get the flow data structure
// If flow not existing, create new flow
// After receiving the flow, depending on the UINode, create the corresponding UI
export const Login: React.FC<LoginProps> = ({ flowId, aal2 }) => {
  const [flow, setFlow] = useState<LoginFlow | null>(null);
  const navigate = useNavigate();

  const getFlow = useCallback(
    (flowId: string) =>
      oryClient
        .getLoginFlow({ id: flowId })
        .then(({ data: flow }) => setFlow(flow))
        .catch(sdkErrorHandler),
    []
  );

  const sdkErrorHandler = useOrySdk(getFlow, setFlow, "/login", true);

  const createFlow = () =>
    oryClient
      .createBrowserLoginFlow({ refresh: true, aal: aal2 ? "aal2" : "aal1" })
      .then(({ data: flow }) => {
        setFlow(flow);
      })
      .catch(sdkErrorHandler);

  const submitFlow = (body: UpdateLoginFlowBody) => {
    if (!flow) return navigate("/login", { replace: true });
    oryClient
      .updateLoginFlow({
        flow: flow.id,
        updateLoginFlowBody: body,
      })
      .then(() => {
        navigate("/", { replace: true });
      })
      .catch(sdkErrorHandler);
  };

  const submitFlowByForm = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();

    let body: UpdateLoginFlowBody = {} as UpdateLoginFlowBody;

    const formData = new FormData(event.currentTarget);
    formData.forEach((value, key) => {
      body = {
        ...body,
        [key]: value,
      };
    });

    if ("submitter" in event.nativeEvent) {
      const submitter = (
        event.nativeEvent as unknown as { submitter: HTMLInputElement }
      ).submitter;
      body = {
        ...body,
        ...{ [submitter.name]: submitter.value },
      };
    }

    submitFlow(body);
  };

  const submitFlowOidc = (oidcProvider: string) => {
    const updateLoginFlowOidc: UpdateLoginFlowWithOidcMethod = {
      method: "oidc",
      provider: oidcProvider,
    };
    submitFlow(updateLoginFlowOidc);
  };

  // Fetch the flow
  useEffect(() => {
    if (flowId) {
      getFlow(flowId).catch(createFlow);
    } else {
      console.log("second time");
      createFlow();
    }
  }, []);

  if (!flow) {
    return <div>Loading</div>;
  }

  return (
    <div>
      <FlowUiMessage uiMessages={flow.ui.messages} />
      <form
        action={flow.ui.action}
        method={flow.ui.method}
        onSubmit={submitFlowByForm}
      >
        {filterNodesByGroups({
          nodes: flow.ui.nodes,
          // we will also map default fields here such as csrf_token
          // this only maps the `password` method
          // other methods can also be mapped such as `oidc` or `webauthn`
          groups: ["default", "password"],
        }).map((node, idx) => mapUINode(node, idx))}

        {/* {filterNodesByGroups({
        nodes: flow.ui.nodes,
        groups: ["oidc"],
      }).map((node, idx) => mapUINode(node, idx))} */}
      </form>

      <button
        type="submit"
        value="google"
        onClick={() => {
          submitFlowOidc("google");
        }}
      >
        Sign in with Google
      </button>
      <button type="submit" value="facebook">
        Sign in with Facebook
      </button>
      <button
        type="submit"
        value="github"
        onClick={() => {
          submitFlowOidc("github");
        }}
      >
        Sign in with Github
      </button>
      <Link to="/registration">Register</Link>
    </div>
  );
};
