<style scoped>
</style>

<template>
    <div class="playgroundRoot">
        <header class="header">

        </header>
        <splittable-tabs
            :layout="splitLayout"
        >
        <tab-item label="Code" ref="codeTab" splittable></tab-item>
    </splittable-tabs>
    </div>
</template>

<script>
import SplittableTabs from "./components/SplittableTabs.vue";
import TabItem from "./components/TabItem.vue";

export default {
    data() {
        return {
            splitLayout: "auto",
        }
    },
    mounted() {

    },
    components: { SplittableTabs, TabItem }
}
</script>