<template>
    <div style="overflow: hidden;"></div>
</template>

<script>
import CodeMirror from "codemirror";
import "codemirror/lib/codemirror.css";

function initEditor(vm) {
    const editor = CodeMirror(vm.$el, {
        mode: "rhai",
        lineNumbers: true,
        indentUnit: 4,
    });

    editor.on("change", (editor, changes) => {
        vm.change(editor, changes);
    })

    return editor;
}

export default {
    methods: {
        change(editor, changes) {
            this.$emit("change", editor, changes);
        },
        requestRun() {
            this.$emit("requestRun", this.$_cm);
        },
        getEditor() {
            return this.$_cm;
        }
    },
    mounted() {
        this.$_cm = initEditor(this);
    }
}
</script>