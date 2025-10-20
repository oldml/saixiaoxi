<template>
  <Teleport to="body">
    <Transition
      enter-active-class="transition-all duration-200 ease-out"
      enter-from-class="opacity-0"
      enter-to-class="opacity-100"
      leave-active-class="transition-all duration-150 ease-in"
      leave-from-class="opacity-100"
      leave-to-class="opacity-0"
    >
      <div
        v-if="open"
        class="fixed inset-0 z-50 bg-black/80"
        @click="handleBackdropClick"
      />
    </Transition>

    <Transition
      enter-active-class="transition-all duration-300 ease-out"
      enter-from-class="opacity-0 scale-90 -translate-y-8"
      enter-to-class="opacity-100 scale-100 translate-y-0"
      leave-active-class="transition-all duration-200 ease-in"
      leave-from-class="opacity-100 scale-100 translate-y-0"
      leave-to-class="opacity-0 scale-95 translate-y-4"
    >
      <div
        v-if="open"
        class="fixed left-[50%] top-[50%] z-50 w-full max-w-7xl translate-x-[-50%] translate-y-[-50%] px-4"
      >
        <div
          :class="cn(
            'relative grid gap-4 border bg-background p-6 shadow-lg rounded-3xl max-h-[90vh] overflow-hidden',
            props.class
          )"
        >
          <slot />
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup lang="ts">
import { cn } from '@/lib/utils'

interface Props {
  open?: boolean
  class?: string
}

const props = withDefaults(defineProps<Props>(), {
  open: false
})

const emit = defineEmits<{
  'update:open': [value: boolean]
  close: []
}>()

function handleBackdropClick() {
  emit('update:open', false)
  emit('close')
}
</script>
