<template>
  <div
    :class="cn(
      'rounded-2xl border border-white/12 bg-white/8 text-slate-100 shadow-[0_18px_50px_rgba(2,6,23,0.4)] backdrop-blur-xl',
      props.class
    )"
  >
    <slot />
  </div>
</template>

<script setup lang="ts">
import { cn } from '@/lib/utils'

interface Props {
  class?: string
}

const props = defineProps<Props>()
</script>
