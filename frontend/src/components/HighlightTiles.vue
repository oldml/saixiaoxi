<template>
  <div class="grid gap-3 sm:grid-cols-3">
    <div
      v-for="tile in tiles"
      :key="tile.title"
      class="rounded-xl border border-white/10 bg-transparent text-xs uppercase tracking-[0.28em] text-slate-300/70 transition-colors duration-200 hover:border-white/12 hover:shadow-[0_14px_28px_rgba(2,6,23,0.4)]"
    >
      <div class="flex flex-col gap-1.5 px-5 py-4">
        <span class="text-[11px] text-slate-300/70">{{ tile.title }}</span>
        <span class="text-sm font-semibold tracking-normal text-white">{{ tile.value }}</span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { HighlightTile } from '@/constants/highlightTiles'

defineProps<{
  tiles: HighlightTile[]
}>()
</script>

