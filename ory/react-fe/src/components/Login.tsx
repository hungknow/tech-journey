import React, { useCallback, useEffect, useState } from "react";
import { oryClient, useOrySdk } from "../orySdk";
import { LoginFlow, UiNode, UiNodeInputAttributes } from "@ory/client";
import {
  filterNodesByGroups,
  isUiNodeInputAttributes,
} from "@ory/integrations/ui";
import { FlowUiMessage } from "./FlowUiMessage";
import { Link } from "react-router-dom";
import { mapUINode } from "./components_utils";

export interface LoginProps {
  flowId?: string | null;
  aal2?: string | null;
}

// If flow is existing, getFlow with Flow ID to get the flow data structure
// If flow not existing, create new flow
// After receiving the flow, depending on the UINode, create the corresponding UI
export const Login: React.FC<LoginProps> = ({ flowId, aal2 }) => {
  const [flow, setFlow] = useState<LoginFlow | null>(null);

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
  // Fetch the flow
  useEffect(() => {
    if (flowId) {
      getFlow(flowId).catch(createFlow);
    } else {
      createFlow();
    }
  }, [flowId]);

  if (!flow) {
    return <div>Loading</div>;
  }

  return (
    <div>
      <FlowUiMessage uiMessages={flow.ui.messages} />
      <form action={flow.ui.action} method={flow.ui.method}>
        {filterNodesByGroups({
          nodes: flow.ui.nodes,
          // we will also map default fields here such as csrf_token
          // this only maps the `password` method
          // other methods can also be mapped such as `oidc` or `webauthn`
          groups: ["default", "password"],
        }).map((node, idx) => mapUINode(node, idx))}

        {/* {filterNodesByGroups({
        nodes: flow.ui.nodes,
        groups: ["iodc"],
      }).map((node, idx) => mapUINode(node, idx))} */}

        <button type="submit" value="google">
          Sign in with Google
        </button>
        <button type="submit" value="facebook">
          Sign in with Facebook
        </button>
        <button type="submit" value="github">
          Sign in with Github
        </button>
        <Link to="/registration">Register</Link>
      </form>
    </div>
  );
};
