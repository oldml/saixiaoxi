<template>
  <Dialog
    :open="open"
    class="rounded-3xl border-white/15 bg-slate-950/80 p-0 text-slate-100 shadow-[0_40px_120px_rgba(2,6,23,0.45)] backdrop-blur-2xl"
    @update:open="handleOpenUpdate"
    @close="handleClose"
  >
    <div :ref="setCaptureTarget" class="flex flex-col">
      <DialogHeader class="border-b border-white/10 bg-white/5 px-8 py-6 backdrop-blur-lg">
        <div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
          <DialogTitle class="text-2xl font-semibold text-white/90">查询结果</DialogTitle>
          <div class="flex items-center gap-2" data-export-ignore="true">
            <Button
              class="rounded-xl border border-white/20 bg-white/10 px-4 py-2 text-sm font-medium text-slate-100 transition-colors duration-200 hover:bg-white/16 focus-visible:ring-2 focus-visible:ring-sky-300/70 disabled:cursor-not-allowed"
              size="sm"
              :disabled="isCapturing || !queryResult"
              @click="handleExport"
            >
              <Loader2 v-if="isCapturing" class="h-4 w-4 animate-spin" />
              <Download v-else class="h-4 w-4 text-slate-200" />
              {{ isCapturing ? '生成中...' : '导出截图' }}
            </Button>
          </div>
        </div>
      </DialogHeader>
      <DialogContent class="px-8 py-8">
        <div
          v-if="queryResult"
          class="grid gap-6 lg:grid-cols-[320px_1fr] xl:grid-cols-[360px_1fr]"
        >
          <div class="lg:self-start">
            <UserProfile
              :userinfo="queryResult.userinfo"
              :show-user-id="showUserId"
              :animate="animateProfile"
            />
          </div>

          <div>
            <UserDetails
              :userinfo="queryResult.userinfo"
              :animate="animateDetails"
            />
          </div>
        </div>
      </DialogContent>
    </div>
  </Dialog>
</template>

<script setup lang="ts">
import { toRefs, type PropType, type ComponentPublicInstance } from 'vue'
import type { QueryResponse } from '@/types'
import Dialog from './ui/Dialog.vue'
import DialogHeader from './ui/DialogHeader.vue'
import DialogTitle from './ui/DialogTitle.vue'
import DialogContent from './ui/DialogContent.vue'
import Button from './ui/Button.vue'
import UserProfile from './UserProfile.vue'
import UserDetails from './UserDetails.vue'
import { Download, Loader2 } from 'lucide-vue-next'

const props = defineProps({
  open: {
    type: Boolean,
    default: false,
  },
  queryResult: {
    type: Object as PropType<QueryResponse['data'] | null>,
    default: null,
  },
  showUserId: {
    type: Boolean,
    default: false,
  },
  animateProfile: {
    type: Boolean,
    default: false,
  },
  animateDetails: {
    type: Boolean,
    default: false,
  },
  isCapturing: {
    type: Boolean,
    default: false,
  },
})

const emit = defineEmits<{
  (e: 'update:open', value: boolean): void
  (e: 'close'): void
  (e: 'export'): void
  (e: 'register-capture-target', element: HTMLElement | null): void
}>()

const { open, queryResult, showUserId, animateProfile, animateDetails, isCapturing } = toRefs(props)

const setCaptureTarget = (element: Element | ComponentPublicInstance | null) => {
  if (element instanceof HTMLElement) {
    emit('register-capture-target', element)
  } else {
    emit('register-capture-target', null)
  }
}

const handleOpenUpdate = (value: boolean) => {
  emit('update:open', value)
}

const handleClose = () => {
  emit('close')
}

const handleExport = () => {
  emit('export')
}
</script>
