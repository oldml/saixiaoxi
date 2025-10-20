<template>
  <div
    class="flex items-center justify-between gap-4 rounded-xl border border-white/10 bg-white/5 px-4 py-3 text-sm text-white/85 backdrop-blur"
  >
    <span class="text-xs font-medium uppercase tracking-[0.24em] text-slate-300/75">
      {{ label }}
    </span>
    <span
      v-if="!$slots.value"
      class="text-sm font-semibold text-white/90"
    >
      {{ value }}
    </span>
    <div
      v-else
      class="text-sm font-semibold text-white/90"
    >
      <slot name="value" />
    </div>
  </div>
</template>

<script setup lang="ts">
interface Props {
  label: string
  value?: string | number
}

defineProps<Props>()
</script>
