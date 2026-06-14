import React, { useEffect, useState } from "react";
import { FlowUiMessage } from "./FlowUiMessage";
import { filterNodesByGroups } from "@ory/integrations/ui";
import { Link, useNavigate } from "react-router-dom";
import { RegistrationFlow, UpdateRegistrationFlowBody } from "@ory/client";
import { mapUINode, oryClient, useOrySdk } from "../orySdk";

export interface RegistrationProps {
  flowID?: string;
}

export const Registration: React.FC<RegistrationProps> = ({ flowID }) => {
  const [flow, setFlow] = useState<RegistrationFlow | null>(null);
  const navigate = useNavigate();

  const getFlow = (flowId: string) =>
    oryClient
      .getRegistrationFlow({
        id: flowId,
      })
      .then(({ data: flow }) => {
        // set the flow data
        setFlow(flow);
      })
      .catch(sdkErrorHandler);

  const sdkErrorHandler = useOrySdk(getFlow, setFlow, "/");

  const createFlow = () =>
    oryClient
      .createBrowserRegistrationFlow({})
      .then((response) => setFlow(response.data))
      .catch(sdkErrorHandler);

  const submitFlow = (body: UpdateRegistrationFlowBody) => {
    if (!flow) {
      navigate("/registration");
      return;
    }
    oryClient
      .updateRegistrationFlow({
        flow: flow.id,
        updateRegistrationFlowBody: body
      })
      .then(() => {
        navigate("/");
      })
      .catch(sdkErrorHandler);
  }

  const submitFlowByForm = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault(); 

    let body: UpdateRegistrationFlowBody =  {} as UpdateRegistrationFlowBody;

    const formData = new FormData(event.currentTarget);
    formData.forEach((value, key) => {
      body = {
        ...body,
        [key]: value,
      }
    });

    const submitter = event.nativeEvent as unknown as { submitter: HTMLInputElement }
    body.method = submitter.submitter.value;

    submitFlow(body);
  }

  useEffect(() => {
    if (flowID) {
      getFlow(flowID).catch(createFlow);
    } else {
      createFlow();
    }
  }, []);

  if (!flow) {
    return <>Loading</>;
  }

  return (
    <>
      <h1>Registration</h1>
      <div>
        <FlowUiMessage uiMessages={flow.ui.messages} />
        <form action={flow.ui.action} method={flow.ui.method} onSubmit={submitFlowByForm}>
          {filterNodesByGroups({
            nodes: flow.ui.nodes,
            groups: ["default", "password"],
          }).map((node, idx) => mapUINode(node, idx))}
        </form>
        <Link to="/login">Login</Link>
      </div>
    </>
  );
};
