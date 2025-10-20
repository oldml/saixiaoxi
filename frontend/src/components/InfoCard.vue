<template>
  <div
    :class="[
      'flex flex-col gap-1 border-l-2 border-white/15 pl-4 text-slate-100 transition-colors',
      highlight && 'border-sky-300/70 text-sky-200'
    ]"
  >
    <span class="text-[11px] font-semibold uppercase tracking-[0.3em] text-slate-300/70">
      {{ label }}
    </span>
    <span :class="['text-sm font-medium leading-5 text-white/90', highlight && 'text-sky-100']">
      {{ value }}
    </span>
  </div>
</template>

<script setup lang="ts">
interface Props {
  label: string
  value: string
  highlight?: boolean
}

defineProps<Props>()
</script>
