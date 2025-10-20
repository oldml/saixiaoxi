import { computed, onBeforeUnmount, ref } from 'vue'

export type StatusType = 'success' | 'error' | 'warning' | 'default'

export interface StatusState {
  show: boolean
  message: string
  type: StatusType
}

export function useStatusBanner() {
  const status = ref<StatusState>({
    show: false,
    message: '',
    type: 'default',
  })

  let statusTimeout: number | null = null

  const alertTone = computed(() => {
    const baseClass =
      'rounded-xl border px-5 py-4 text-sm shadow-[0_10px_40px_rgba(15,23,42,0.35)] backdrop-blur-xl'
    const toneMap: Record<StatusType, string> = {
      default: 'border-white/15 bg-white/10 text-slate-100/90',
      success: 'border-emerald-400/60 bg-emerald-500/10 text-emerald-100',
      error: 'border-rose-400/60 bg-rose-500/10 text-rose-100',
      warning: 'border-amber-300/60 bg-amber-400/10 text-amber-100',
    }

    return `${baseClass} ${toneMap[status.value.type]}`
  })

  const clearStatusTimeout = () => {
    if (statusTimeout) {
      clearTimeout(statusTimeout)
      statusTimeout = null
    }
  }

  const showStatus = (
    message: string,
    type: StatusType = 'default',
    duration = 5000,
  ) => {
    clearStatusTimeout()

    status.value = {
      show: true,
      message,
      type,
    }

    if (duration > 0) {
      statusTimeout = window.setTimeout(() => {
        status.value.show = false
        statusTimeout = null
      }, duration)
    }
  }

  const hideStatus = () => {
    status.value.show = false
    clearStatusTimeout()
  }

  onBeforeUnmount(() => {
    clearStatusTimeout()
  })

  return {
    status,
    alertTone,
    showStatus,
    hideStatus,
  }
}

