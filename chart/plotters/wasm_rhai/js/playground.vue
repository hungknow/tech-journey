<style scoped>
.playgroundRoot {
    height: 100%;
    max-height: 100%;
    display: grid;
    grid-template-columns: 100vw;
    grid-template-rows: auto minmax(0, 1fr);
}

.header {
    padding: 0.75rem;
}

.outputPanel {
    display: flex;
    flex-direction: column;
}

.result {
    border: 0;
    margin: 4px 8px;
    resize: none;
    font-family: monospace;
    flex-grow: 1;
}
</style>

<style>
.CodeMirror {
    border: 1px solid #ccc;
    height: 100% !important;
    box-sizing: border-box;
    font-size: 0.95em;
    line-height: initial;
}
</style>

<template>
    <div class="playgroundRoot">
        <header class="header">
            <b-field grouped group-multiline>
                <b-field>
                    <p class="control">
                        <b-button type="is-success" native-type="button" icon-left="play" @click="requestRun"
                            :loading="isScriptRunning" :disabled="runDisabled">Run</b-button>
                    </p>
                </b-field>
            </b-field>
            <b-field style="margin-bottom: 0.75rem;">
                <p class="control" v-if="isRunScriptOnWorker">
                    <b-toolip
                        position="is-bottom"
                        :label="(isScriptRunning ? (runningOps !== null ? 'Running' : 'Loading...') : 'Idle') + (runningOps ? ` / Ops : ${runningOpsDIsplay}` : '')"
                        :always="isScriptRunning && runningOps !== null && runningOps > 0">
                        <b-button type="is-danger"
                            native-type="button"
                            icon-left="stop"
                            @click="stopSript"
                            :disabled="stopDisabled">
                            Stop
                        </b-button> 
                    </b-toolip>
                </p>
            </b-field>
            <b-field style="margin-bottom: 0.75rem;">
                <p class="control" v-if="!$data._isEmbedded">
                    <b-dropdown
                        aria-role="menu"
                        :disabled="exampleScriptChangePromise !== null || isScriptRunning"
                        >
                        <button
                            class="button"
                            position="is-bottom-left"
                            slot="trigger"
                            role="button"
                            type="button"
                            >
                            <span>Example Scripts</span>
                            <b-icon icon="menu-down" />
                        </button>
                        <b-dropdown-item
                            aria-role="menu-item"
                            v-for="i in exampleScriptList"
                            :key="i.value"
                            @click.native.prevent="loadExampleScript(i.value)"
                            href="#"
                            >
                            {{ i.text }}
                        </b-dropdown-item>
                    </b-dropdown>
                </p>
            </b-field>
        </header>
        <splittable-tabs :layout="splitLayout">
            <tab-item label="Code" ref="codeTab" splittable>
                <editor style="overflow: hidden; height: 100%;" ref="editor" @change="codeChange" @requestRun="requestRun">
                </editor>
            </tab-item>
            <tab-item label="Output" ref="outputTab" class="outputPanel">
                <textarea ref="result" class="result" readonly autocomplete="off"></textarea>
            </tab-item>
            <tab-item label="AST">

            </tab-item>
        </splittable-tabs>
        <canvas id="canvas" width="300" height="250"></canvas>
    </div>
</template>

<script>
import SplittableTabs from "./components/SplittableTabs.vue";
import TabItem from "./components/TabItem.vue";
import Editor from "./components/Editor.vue";
import CodeMirror from "codemirror";
// import * as Wasm from "plotter-wasm";
import * as Runner from "./playground-runner";
import { wasm } from "./wasm_loader";

const initialCode = `\
fn run(a) {
    let b = a + 1;
    print("Hello world! a = " + b);
}
run(10);
`;

function initEditor(vm) {
    let lastErrorMarker = null;

    function tryCompileScript(editor) {

    }

    const tryCompileDebounced = {
        delayMsec: 500,
        timeout: null,
        cancel() {
            if (this.timeout !== null) {
                window.clearTimeout(this.timeout);
            }
        },
        trigger(arg) {
            this.cancel();
            this.timeout = window.setTimeout(
                () => this._fire(arg),
                this.delayMsec
            );
        },
        _fire(editor) {
            vm.astText = tryCompileScript(editor) || "";
        }
    };

    function doRunScriptSync(editor, resultEl) {
        let script = editor.getValue();
        resultEl.value = "";

        function appendOutput(line) {
            let v = resultEl.value + line + "\n";
            if (v.length > 10000) {
                v = v.substr(v.length - 10000);
            }
            resultEl.value = v;
        }
        appendOutput(`Running script at ${new Date().toISOString()}\n`);
        return new Promise((resolve, reject) => {
            setTimeout(() => {
                try {
                    let result = wasm.run_script(
                        script,
                        s => {
                            appendOutput(`[PRINT] ${s}`);
                        },
                        s => {
                            appendOutput(`[DEBUG] ${s}`);
                        },);
                    appendOutput(`\nScript returned: "${result}"`);
                } catch (ex) {
                    appendOutput(`\nEXCEPTION: "${ex}"`);
                }
                appendOutput(`\nFinished at ${new Date().toISOString()}`);
                // Scroll to bottom
                resultEl.scrollTop = resultEl.scrollHeight - resultEl.clientHeight;
                resolve();
            }, 10);
        });

    }

    let runScriptPromise = null;
    async function doRunScriptAsync(editor, resultEl, updateOps) {
        if (runScriptPromise) {
            console.log(
                "Blocked run script request as another script is already running."
            );
            return;
        }
        let script = editor.getValue();
        resultEl.value = "";
        let appendBuffer = "";
        let appendBufferTimeout = null;
        let lastUpdateTime = null;
        function appendOutput(line) {
            appendBuffer += line + "\n";
            if (appendBufferTimeout === null) {
                const animFn = ts => {
                    let elapsed = ts - lastUpdateTime;
                    if (elapsed < 32) {
                        appendBufferTimeout = requestAnimationFrame(animFn);
                        return;
                    }
                    lastUpdateTime = ts;
                    const scroll = resultEl.scrollTop >= resultEl.scrollHeight - resultEl.clientHeight - 2;
                    let v = resultEl.value;
                    const totalLen = v.length + appendBuffer.length;
                    if (totalLen > 10000) {
                        v = v.substr(totalLen - 10000);
                    }
                    v += appendBuffer;
                    resultEl.value = v;
                    if (scroll) {
                        resultEl.scrollTop = resultEl.scrollHeight - resultEl.clientHeight;
                    }
                    appendBuffer = "";
                    appendBufferTimeout = null;
                }
                appendBufferTimeout = requestAnimationFrame(animFn);
            }
        }

        try {
            await (runScriptPromise = Runner.runScript(script, appendOutput, updateOps));
        } catch (ex) {
            appendOutput(`\nEXCEPTION: "${ex}"`);
        } finally {
            runScriptPromise = null;
        }
    }

    let isScriptRunning = false;
    async function doRunScript(editor, isAsync, resultEl, updateOps) {
        if (isScriptRunning) {
            console.log("Blocked run script rquest as another script is already running.");
            return;
        }

        isScriptRunning = true;
        if (isAsync) {
            await doRunScriptAsync(editor, resultEl, updateOps);
        } else {
            await doRunScriptSync(editor, resultEl);
        }

        isScriptRunning = false;
    }

    return {
        tryCompileDebounced,
        doRunScript,
    }
}

// With the help of webpack, we can get a list of all the example script files
// and the ability to lazily load them on demand:
const exampleScriptsImport = require.context("!raw-loader!../example-scripts/", false, /\.rhai$/, "lazy");

let exampleScriptList = [];
for (let key of exampleScriptsImport.keys()) {
    const value = key;
    if (key.startsWith("./")) {
        key = key.substr(2);
    }
    const text = key;
    exampleScriptList.push({ value, text });
}
Object.freeze(exampleScriptList);

export default {
    props: {
        initialCode: {
            type: String,
            default: initialCode
        },
        isEmbedded: {
            type: Boolean,
            default: false
        }
    },
    data() {
        return {
            exampleScriptList,
            exampleScriptChangePromise: null,
            selectedCmTheme: "default",
            isRunScriptOnWorker: false,
            isScriptRunning: false,
            runningOps: null,
            stopDisabled: true,
            splitLayout: "auto",
            _isEmbedded: this.isEmbedded,
        }
    },
    computed: {
        runDisabled() {
            return this.isScriptRunning || this.exampleScriptChangePromise !== null;
        }
    },
    methods: {
        codeChange(editor, changes) {
            this.$_r.tryCompileDebounced.trigger(editor);
        },
        async requestRun() {
            if (this.runDisabled) {
                return;
            }

            this.$refs.outputTab.makeTabActive();
            this.isScriptRunnning = true;
            if (this.isRunScriptOnWorker) {
                this.stopDisabled = false;
            }
            this.runningOps = null;
            await this.$_r.doRunScript(
                this.$refs.editor.getEditor(),
                this.isRunScriptOnWorker,
                this.$refs.result,
                ops => {
                    this.runningOps = ops;
                }
            )

            this.stopDisabled = true;
            this.isScriptRunnning = false;
        },
        getEditor() {
            return this.$refs.editor.getEditor();
        },
        stopScript() {
            Runner.stopScript();
        },
        loadExampleScript(key) {
            const cm = this.getEditor();
            this.$_r.tryCompileDebounced.cancel();
            cm.setOption("readOnly", true);
            this.exampleScriptChangePromise = exampleScriptsImport(key)
                .then(module => {
                    cm.setValue(module.default);
                    this.$refs.codeTab.makeTabActive();
                    this.$nextTick(() => {
                        cm.focus();
                    })
                })
                .catch(e => {
                    console.error("Error loading script", e);
                })
                .finally(() => {
                    cm.setOption("readOnly", true);
                    this.exampleScriptChangePromise = null;
                });
        }
    },
    mounted() {
        const cm = this.getEditor();
        const r = initEditor(this);
        r.tryCompileDebounced.trigger(cm);
        this.$_r = r;
        this.$nextTick(() => {
            cm.refresh();
            cm.setValue(this.initialCode);
            cm.focus(); ``
        })
    },
    components: { Editor, SplittableTabs, TabItem }
}
</script>