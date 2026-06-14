import React, { PropsWithChildren } from "react";
import cn from "classnames"

const SeverityTypes = [
    "error",
    "success",
    "info",
    "disabled",
    "default",
  ] as const
export type Severity = (typeof SeverityTypes)[number]

export const Message: React.FC<PropsWithChildren<{}>> = ({
    children,
    ...props
}) => (
    <div
        // className={}
        {...props}
    >{children}</div>
)