import Vue from "vue";
import { Button, Dropdown, Field, Icon, Select, Switch, Tooltip } from "buefy";

import playground from "./playground.vue";

Vue.use(Button);
Vue.use(Dropdown);
Vue.use(Field);
Vue.use(Icon);
Vue.use(Select);
Vue.use(Switch);
Vue.use(Tooltip);

export default function(el, embedInit) {
    const initialCode = embedInit ? embedInit.code : undefined;
    const isEmbedded = embedInit ? true : false; 

    new Vue({
        el,
        render(h) {
            return h(playground, {
                props: {
                    initialCode,
                    isEmbedded,
                }
            })
        }
    })
}

// async function init() {
//     if (typeof process == "object") {
//         const [{Chart}, {main, setup}] = await Promise.all([
//             import("plotter-wasm"),
//             import("./index.js")
//         ]);
//         // setup(Chart);
//         main();
//     } else {
//         const [{Chart, default: init}, { main, setup } ] = await Promise.all([
//             import("../pkg/plotter_wasm.js"),
//             import("./index.js")
//         ]);
//         // await init();
//         // setup(Chart);
//         main();
//     }
// }

// init();