<template>
    <div style="overflow: hidden;"></div>
</template>

<script>
import CodeMirror from "codemirror";
import "codemirror/lib/codemirror.css";


function initEditor(vm) {
    const editor = CodeMirror(vm.$el, {
        mode: "rhai"
    });

    return editor;
}

export default {
    mounted() {
        this.$_cm = initEditor(this);
    }
}
</script>