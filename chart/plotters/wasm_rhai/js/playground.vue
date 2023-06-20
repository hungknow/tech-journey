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
                        <b-button
                            type="is-success"
                            native-type="button"
                            icon-left="play"

                        >Run</b-button>
                    </p>
                </b-field>
            </b-field>
        </header>
        <splittable-tabs
            :layout="splitLayout"
        >
            <tab-item label="Code" ref="codeTab" splittable>
                <editor
                    style="overflow: hidden; height: 100%;"
                    ref="editor"
                    @change="codeChange"
                    @requestRun="requestRun"
                ></editor>
            </tab-item>
            <tab-item label="Output" ref="outputTab" class="outputPanel">
                <textarea ref="result" class="result" readonly autocomplete="off"></textarea>
            </tab-item>
            <tab-item label="AST">

            </tab-item>
        </splittable-tabs>
    </div>
</template>

<script>
import SplittableTabs from "./components/SplittableTabs.vue";
import TabItem from "./components/TabItem.vue";
import Editor from "./components/Editor.vue";

import CodeMirror from "codemirror";


const initialCode = `\
fn run(a) {
    let b = a + 1;
    print("Hello world! a = " + a);
}
run(10);
`;

function initEditor(vm) {
    const tryCompileDebounced = {
        trigger(arg) {

        }
    };

    return {
        tryCompileDebounced,
    }
}

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
            exampleScriptChangePromise: null,
            selectedCmTheme: "default",
            isScriptRunnning: false,
            splitLayout: "auto",
            _isEmbedded: this.isEmbedded,
        }
    },
    computed: {
        runDisabled() {
            return this.isScriptRunning | this.exampleScriptChangePromise !== null;
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
        },
        getEditor() {
            return this.$refs.editor.getEditor();
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
            cm.focus();``
        })
    },
    components: { Editor, SplittableTabs, TabItem }
}
</script>