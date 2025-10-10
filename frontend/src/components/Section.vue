<template>
  <div class="space-y-4">
    <h2 class="text-xl font-semibold border-b pb-2">{{ title }}</h2>
    <slot />
  </div>
</template>

<script setup lang="ts">
interface Props {
  title: string
}

defineProps<Props>()
</script>
