<template>
  <div class="flex justify-between items-center">
    <span class="text-muted-foreground">{{ label }}</span>
    <span v-if="!$slots.value" class="font-medium">{{ value }}</span>
    <slot v-else name="value" />
  </div>
</template>

<script setup lang="ts">
interface Props {
  label: string
  value?: string | number
}

defineProps<Props>()
</script>
