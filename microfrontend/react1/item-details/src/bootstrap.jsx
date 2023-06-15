import React from "react";
import {createRoot} from "react-dom/client";

import ItemDetails from "./ItemDetails";

const container = document.getElementById("root");
const root = createRoot(container);

root.render(<ItemDetails />, );