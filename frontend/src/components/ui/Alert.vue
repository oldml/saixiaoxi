<template>
  <div
    :class="cn(alertVariants({ variant }), props.class)"
    role="alert"
  >
    <slot />
  </div>
</template>

<script setup lang="ts">
import { cn } from '@/lib/utils'
import { cva, type VariantProps } from 'class-variance-authority'

const alertVariants = cva(
  'relative w-full rounded-lg border px-4 py-3 text-sm',
  {
    variants: {
      variant: {
        default: 'bg-background text-foreground',
        success: 'border-green-500/50 text-green-900 bg-green-50 dark:border-green-500 dark:text-green-100 dark:bg-green-950',
        error: 'border-destructive/50 text-destructive bg-red-50 dark:border-destructive dark:bg-red-950',
        warning: 'border-yellow-500/50 text-yellow-900 bg-yellow-50 dark:border-yellow-500 dark:text-yellow-100 dark:bg-yellow-950',
      },
    },
    defaultVariants: {
      variant: 'default',
    },
  }
)

type AlertVariants = VariantProps<typeof alertVariants>

interface Props {
  variant?: AlertVariants['variant']
  class?: string
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'default',
})
</script>
