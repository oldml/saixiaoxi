<template>
  <Card>
    <CardContent class="pt-6">
      <div class="space-y-1">
        <p class="text-sm text-muted-foreground">{{ label }}</p>
        <p :class="['text-lg font-semibold', highlight && 'text-primary']">{{ value }}</p>
      </div>
    </CardContent>
  </Card>
</template>

<script setup lang="ts">
import Card from './ui/Card.vue'
import CardContent from './ui/CardContent.vue'

interface Props {
  label: string
  value: string
  highlight?: boolean
}

defineProps<Props>()
</script>
