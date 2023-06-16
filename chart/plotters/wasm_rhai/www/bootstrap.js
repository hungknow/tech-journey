async function init() {
    if (typeof process == "object") {
        const [{Chart}, {main, setup}] = await Promise.all([
            import("plotter-wasm"),
            import("./index.js")
        ]);
        setup(Chart);
        main();
    } else {
        const [{Chart, default: init}, { main, setup } ] = await Promise.all([
            import("../pkg/plotter_wasm.js"),
            import("./index.js")
        ]);
        // await init();
        setup(Chart);
        main();
    }
}

init();