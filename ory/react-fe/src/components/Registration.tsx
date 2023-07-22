import React, { useState } from "react";
import { FlowUiMessage } from "./FlowUiMessage";
import { filterNodesByGroups } from "@ory/integrations/ui";
import { mapUINode } from "./components_utils";
import { Link } from "react-router-dom";
import { RegistrationFlow } from "@ory/client";

export const Registration = () => {
  const [flow, setFlow] = useState<RegistrationFlow | null>(null );

  if (!flow) {
    return <>Loading</>
  }

  return (
    <>
      Registration
      <div>
        <FlowUiMessage uiMessages={flow.ui.messages} />
        <form action={flow.ui.action} method={flow.ui.method}>
          {filterNodesByGroups({
            nodes: flow.ui.nodes,
            groups: ["default", "password"],
          }).map((node, idx) => mapUINode(node, idx))}

          <Link to="/login">Login</Link>
        </form>
      </div>
    </>
  );
};
