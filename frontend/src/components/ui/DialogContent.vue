<template>
  <div :class="cn(baseClasses, props.class)">
    <slot />
  </div>
</template>

<script setup lang="ts">
import { cn } from '@/lib/utils'

const baseClasses =
  'scroll-area relative max-h-[70vh] overflow-y-auto pr-4 pt-4 -mr-2 sm:-mr-3 [scrollbar-gutter:stable] [mask-image:linear-gradient(to_bottom,rgba(15,23,42,0.85),rgba(15,23,42,0.96) 6%,rgba(15,23,42,0.98) 94%,rgba(15,23,42,0.4))]'

interface Props {
  class?: string
}

const props = defineProps<Props>()
</script>

<style scoped>
.scroll-area {
  -webkit-overflow-scrolling: touch;
}

.scroll-area::before,
.scroll-area::after {
  content: '';
  position: sticky;
  pointer-events: none;
  left: 0;
  right: 0;
  height: 22px;
  z-index: 1;
}

.scroll-area::before {
  top: 0;
  background: linear-gradient(to bottom, rgba(15, 23, 42, 0.9), rgba(15, 23, 42, 0));
}

.scroll-area::after {
  bottom: 0;
  background: linear-gradient(to top, rgba(15, 23, 42, 0.9), rgba(15, 23, 42, 0));
}

.scroll-area::-webkit-scrollbar {
  width: 6px;
}

.scroll-area::-webkit-scrollbar-track {
  background: transparent;
}

.scroll-area::-webkit-scrollbar-thumb {
  background: rgba(148, 163, 184, 0.45);
  border-radius: 12px;
  border: 1px solid rgba(30, 41, 59, 0.55);
  box-shadow: inset 0 0 6px rgba(15, 23, 42, 0.3);
  transition: background 0.2s ease;
}

.scroll-area::-webkit-scrollbar-thumb:hover {
  background: rgba(94, 141, 209, 0.65);
}

.dark .scroll-area::-webkit-scrollbar-thumb {
  background: rgba(94, 141, 209, 0.55);
  border-color: rgba(148, 163, 184, 0.35);
}

.dark .scroll-area::-webkit-scrollbar-thumb:hover {
  background: rgba(125, 211, 252, 0.65);
}

.scroll-area {
  scrollbar-width: thin;
  scrollbar-color: rgba(148, 163, 184, 0.45) transparent;
}
</style>
