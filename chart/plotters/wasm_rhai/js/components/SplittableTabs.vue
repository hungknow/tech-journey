<style scoped>
</style>
<template>
    <div class="tabsContainer" :class="{ splitted: isSplitted, vertical: isVerticalSplit }">
        <nav class="tabs">
            <ul>
                <li
                    v-for="(tab, i) in tabItems"
                    :key="i"
                    v-show="!tab.splittable || !isSplitted"
                    :class="{ 'is-active': tab.isActive, 'is-disabled': tab.disabled }"
                    >
                    <a href="#" @click.prevent="makeTabActive(i)">
                        <span>{{ tab.label }}</span>
                    </a>
                </li>
            </ul>
        </nav>
        <slot></slot>
    </div>
</template>

<script>
import TabItem from "./TabItem.vue";

export default {
    props: {
        layout: {
            type: String,
            required: true,
            validator(val) {
                return ['auto', 'h', 'v', 'tabbed'].includes(val);
            }
        }
    },
    computed: {
        isSplitted() {
            if (this.layout === "auto") {
                return this.$data._autoIsSplitted;
            } else {
                return this.layout === "h" || this.layout === "v";
            }
        },
        isVerticalSplit() {
            return this.layout === "v";
        }
    },
    watch: {
        isSplitted(newValue) {

        }
    },
    data() {
        return {
            _autoIsSplitted: false,
            tabItems: [],
            activeTab: -1,
        }
    },
    methods: {
        refreshSlots() {
            if (this.$slots.default && this.$slots.default.length > 0) {
                this.tabItems = this.$slots.default
                    .filter(vnode => vnode.componentInstance)
                    .map(vnode => vnode.componentInstance);
            } else {
                this.tabItems = [];
            }
        },
        makeTabActive(idx) {
            if (typeof idx !== "number") {
                idx = this.tabItems.findIndex(tab => tab === idx);
                if (idx < 0) {
                    return;
                }
            }

            // When a tab is explicitly made active, we no longer need to revert
            // to the last active tab
            this._unsplittedActiveTab = idx;
            if (!this.tabItems[idx].isSplitted) {
                this.activeTab = idx;
            }
        }
    }
}
</script>