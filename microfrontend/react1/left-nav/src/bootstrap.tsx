import React from "react";
import {createRoot} from "react-dom/client";

import LeftNav from "./LeftNav";

const container = document.getElementById("root");
const root = createRoot(container);

root.render(<LeftNav />, );