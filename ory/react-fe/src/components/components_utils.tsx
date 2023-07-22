import { UiNode, UiNodeInputAttributes } from "@ory/client";
import { isUiNodeInputAttributes } from "@ory/integrations/ui";

// From the UiNode data structure, display the corresponding UI
export const mapUINode = (node: UiNode, key: number) => {
    if (isUiNodeInputAttributes(node.attributes)) {
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
            />
          );
        default:
          return (
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
          );
      }
    } else {
      // return (
      //     <button
      //         type="button"
      //         value={node.attributes.}
      //     />
      // )
    }
  }