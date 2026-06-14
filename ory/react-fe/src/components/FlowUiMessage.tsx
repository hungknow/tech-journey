import { UiText } from "@ory/client";
import React from "react";

export interface NodeMessagesProps {
    nodes?: any
    uiMessages?: Array<UiText>
}
export const FlowUiMessage: React.FC<NodeMessagesProps> = ( { uiMessages }) => {
    if (!uiMessages) {
        return (<></>)

    }

    if (uiMessages) {
        console.error(uiMessages);
    }
    return (<></>)
}