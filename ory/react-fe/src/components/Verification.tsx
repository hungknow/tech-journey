import React, { useState } from "react";
import { oryClient } from "../orySdk";
import { UpdateVerificationFlowBody, VerificationFlow } from "@ory/client";

export interface VerificationProps {
    flowID?: string
}

const Verification: React.FC<VerificationProps> = ({ flowID }) => {
    const [flow, setFlow] = useState<VerificationFlow | null>(null);
    
    const createFlow = () => oryClient
        .createBrowserVerificationFlow()
        .then((response) => {
            setFlow(response.data);
        });

    const updateFlow = (flowID: string, updateVerificationFlowBody: UpdateVerificationFlowBody) =>
        oryClient.updateVerificationFlow({
            flow: flowID,
            updateVerificationFlowBody,
        }).then(() => {})

    return (
        <div></div>
    )
}