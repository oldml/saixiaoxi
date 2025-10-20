<template>
  <section class="space-y-3">
    <div class="flex items-center gap-3">
      <h2 class="text-xs font-semibold uppercase tracking-[0.3em] text-slate-300/75">
        {{ title }}
      </h2>
      <span class="h-px flex-1 bg-white/12"></span>
    </div>
    <slot />
  </section>
</template>

<script setup lang="ts">
interface Props {
  title: string
}

defineProps<Props>()
</script>
