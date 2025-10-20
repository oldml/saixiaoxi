<template>
  <div class="relative min-h-screen overflow-hidden bg-gradient-to-br from-slate-950 via-slate-900 to-slate-950 text-slate-100">
    <div class="pointer-events-none absolute inset-0 bg-[radial-gradient(circle_at_top,_rgba(148,163,184,0.12),_transparent_60%)]"></div>

    <div class="relative flex min-h-screen items-center justify-center py-16 px-4 sm:px-6 lg:px-8">
      <div class="w-full max-w-6xl">
        <div class="rounded-3xl border border-white/10 bg-white/10 shadow-[0_30px_100px_rgba(15,23,42,0.55)] backdrop-blur-3xl">
          <div class="flex flex-col gap-10 p-6 sm:p-8 lg:p-12">
            <header class="flex flex-col gap-2">
              <p class="text-xs uppercase tracking-[0.35em] text-slate-300/70">Saixiaoxi</p>
              <h1 class="text-3xl font-semibold sm:text-4xl">小赛尔账号信息查询助手</h1>
              <p class="text-sm text-slate-300/80 sm:max-w-3xl">
                输入米米号即可唤起账号档案。
              </p>
            </header>

            <section class="flex flex-col gap-6">
              <QueryForm
                v-model:loading="isLoading"
                @query="handleQuery"
                @clear="handleClear"
                @validation-error="handleValidationError"
              />

              <div class="grid gap-3 sm:grid-cols-3">
                <div
                  v-for="tile in highlightTiles"
                  :key="tile.title"
                  class="rounded-xl border border-white/10 bg-transparent text-xs uppercase tracking-[0.28em] text-slate-300/70 transition-colors duration-200 hover:border-white/12 hover:shadow-[0_14px_28px_rgba(2,6,23,0.4)]"
                >
                  <div class="flex flex-col gap-1.5 px-5 py-4">
                    <span class="text-[11px] text-slate-300/70">{{ tile.title }}</span>
                    <span class="text-sm font-semibold tracking-normal text-white">{{ tile.value }}</span>
                  </div>
                </div>
              </div>

              <Transition
                enter-active-class="transition-all duration-300 ease-out"
                enter-from-class="opacity-0 -translate-y-3"
                enter-to-class="opacity-100 translate-y-0"
                leave-active-class="transition-all duration-200 ease-in"
                leave-from-class="opacity-100 translate-y-0"
                leave-to-class="opacity-0 -translate-y-3"
              >
                <Alert
                  v-if="status.show"
                  :variant="status.type"
                  :class="alertTone"
                >
                  {{ status.message }}
                </Alert>
              </Transition>
            </section>

            <Transition
              enter-active-class="transition-all duration-400 ease-out"
              enter-from-class="opacity-0 translate-y-3"
              enter-to-class="opacity-100 translate-y-0"
              leave-active-class="transition-all duration-200 ease-in"
              leave-from-class="opacity-100 translate-y-0"
              leave-to-class="opacity-0 translate-y-3"
            >
              <div
                v-if="!dialogOpen"
                class="flex flex-col items-center justify-center rounded-2xl border border-white/10 bg-white/5 p-10 text-center text-slate-300/80 shadow-[0_18px_40px_rgba(2,6,23,0.3)] backdrop-blur-xl"
              >
                <span class="text-lg font-medium text-white/90">{{ placeholderState.title }}</span>
                <p class="mt-2 max-w-md text-sm text-slate-300/75">
                  {{ placeholderState.description }}
                </p>
              </div>
            </Transition>
          </div>
        </div>
      </div>
    </div>

    <Dialog
      v-model:open="dialogOpen"
      class="rounded-3xl border-white/15 bg-slate-950/80 p-0 text-slate-100 shadow-[0_40px_120px_rgba(2,6,23,0.45)] backdrop-blur-2xl"
      @close="handleCloseDialog"
    >
      <div ref="captureTargetRef" class="flex flex-col">
        <DialogHeader class="border-b border-white/10 bg-white/5 px-8 py-6 backdrop-blur-lg">
          <div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
            <DialogTitle class="text-2xl font-semibold text-white/90">查询结果</DialogTitle>
            <div class="flex items-center gap-2" data-export-ignore="true">
              <Button
                class="rounded-xl border border-white/20 bg-white/10 px-4 py-2 text-sm font-medium text-slate-100 transition-colors duration-200 hover:bg-white/16 focus-visible:ring-2 focus-visible:ring-sky-300/70 disabled:cursor-not-allowed"
                size="sm"
                :disabled="isCapturing || !queryResult"
                @click="handleExportSnapshot"
              >
                <Loader2 v-if="isCapturing" class="h-4 w-4 animate-spin" />
                <Download v-else class="h-4 w-4 text-slate-200" />
                {{ isCapturing ? '生成中...' : '导出截图' }}
              </Button>
            </div>
          </div>
        </DialogHeader>
        <DialogContent class="px-8 py-8">
          <div v-if="queryResult" class="grid gap-6 lg:grid-cols-[320px_1fr] xl:grid-cols-[360px_1fr]">
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
  </div>
</template>

<script setup lang="ts">
import { computed, ref, onMounted, nextTick } from 'vue'
import QueryForm from './components/QueryForm.vue'
import UserProfile from './components/UserProfile.vue'
import UserDetails from './components/UserDetails.vue'
import Alert from './components/ui/Alert.vue'
import Button from './components/ui/Button.vue'
import Dialog from './components/ui/Dialog.vue'
import DialogHeader from './components/ui/DialogHeader.vue'
import DialogTitle from './components/ui/DialogTitle.vue'
import DialogContent from './components/ui/DialogContent.vue'
import { queryAccount, checkHealth } from './api'
import type { QueryResponse } from './types'
import { toPng } from 'html-to-image'
import { Download, Loader2 } from 'lucide-vue-next'

const isLoading = ref(false)
const queryResult = ref<QueryResponse['data'] | null>(null)
const dialogOpen = ref(false)
const showUserId = ref(false)
const animateProfile = ref(false)
const animateDetails = ref(false)
const captureTargetRef = ref<HTMLElement | null>(null)
const isCapturing = ref(false)

interface Status {
  show: boolean
  message: string
  type: 'success' | 'error' | 'warning' | 'default'
}

const status = ref<Status>({
  show: false,
  message: '',
  type: 'default',
})

const highlightTiles = [
  { title: '合法区间', value: '50000 ~ 2,000,000,000' },
  { title: '可查询状态', value: '正式服 · 账号档案' },
  { title: '数据刷新', value: '实时请求 · ~3 秒' },
]

const alertTone = computed(() => {
  const base = 'rounded-xl border px-5 py-4 text-sm shadow-[0_10px_40px_rgba(15,23,42,0.35)] backdrop-blur-xl'
  const map: Record<Status['type'], string> = {
    default: 'border-white/15 bg-white/10 text-slate-100/90',
    success: 'border-emerald-400/60 bg-emerald-500/10 text-emerald-100',
    error: 'border-rose-400/60 bg-rose-500/10 text-rose-100',
    warning: 'border-amber-300/60 bg-amber-400/10 text-amber-100',
  }
  return `${base} ${map[status.value.type]}`
})

const placeholderState = computed(() => {
  if (queryResult.value) {
    return {
      title: '结果已准备就绪',
      description: '刚刚完成的账号档案已缓存，可继续检索新的米米号或重新打开弹窗查看详情。'
    }
  }
  return {
    title: '等待查询',
    description: '输入合法的米米号并点击「立即查询」，系统会在此展示战斗记录、精灵数据与账号健康状态。'
  }
})

let statusTimeout: number | null = null

function showStatus(message: string, type: Status['type'] = 'default', duration = 5000) {
  if (statusTimeout) {
    clearTimeout(statusTimeout)
  }

  status.value = {
    show: true,
    message,
    type,
  }

  if (duration > 0) {
    statusTimeout = setTimeout(() => {
      status.value.show = false
    }, duration) as unknown as number
  }
}

function hideStatus() {
  status.value.show = false
  if (statusTimeout) {
    clearTimeout(statusTimeout)
    statusTimeout = null
  }
}

async function handleQuery(account: string) {
  isLoading.value = true
  hideStatus()
  queryResult.value = null
  dialogOpen.value = false
  showUserId.value = false
  animateProfile.value = false
  animateDetails.value = false

  try {
    showStatus('正在查询用户信息...', 'default', 0)
    const result = await queryAccount(account)

    if (result.success && result.data) {
      queryResult.value = result.data
      showStatus('查询成功！', 'success')

      // 打开弹窗
      dialogOpen.value = true

      // 等待DOM更新后显示内容
      await nextTick()
      await new Promise(resolve => setTimeout(resolve, 150))

      // 显示账号ID
      showUserId.value = true

      // 启动逐条显示动画
      await nextTick()
      animateProfile.value = true

      // 延迟启动详情动画
      setTimeout(() => {
        animateDetails.value = true
      }, 200)
    } else {
      throw new Error(result.message || '查询失败')
    }
  } catch (error) {
    const message = error instanceof Error ? error.message : '查询失败'
    showStatus(`查询失败: ${message}`, 'error')
    console.error('Query error:', error)
  } finally {
    isLoading.value = false
  }
}

function handleClear() {
  queryResult.value = null
  dialogOpen.value = false
  showUserId.value = false
  animateProfile.value = false
  animateDetails.value = false
  hideStatus()
}

function handleValidationError(message: string) {
  showStatus(message, 'error')
}

function handleCloseDialog() {
  dialogOpen.value = false
  showUserId.value = false
  animateProfile.value = false
  animateDetails.value = false
}

function buildExportFileName(): string {
  const defaultName = 'saixiaoxi-result.png'
  const userinfo = queryResult.value?.userinfo
  if (!userinfo) {
    return defaultName
  }

  const nick = (userinfo.nick || '').trim()
  const sanitizedNick = nick
    .replace(/[<>:"/\\|?*\u0000-\u001F]+/g, '')
    .replace(/\s+/g, '')
  const suffix = sanitizedNick
    ? `${sanitizedNick}-${userinfo.userID}`
    : `${userinfo.userID}`

  return `saixiaoxi-${suffix}.png`
}

function downloadDataUrl(dataUrl: string, filename: string) {
  const link = document.createElement('a')
  link.href = dataUrl
  link.download = filename
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
}

type StyleKey = 'overflow' | 'overflowX' | 'overflowY' | 'maxHeight' | 'height'

function adjustLayoutForCapture(target: HTMLElement) {
  const styleSnapshots = new Map<HTMLElement, Partial<Record<StyleKey, string>>>()

  const rememberAndSet = (el: HTMLElement, key: StyleKey, value: string) => {
    if (!styleSnapshots.has(el)) {
      styleSnapshots.set(el, {})
    }
    const record = styleSnapshots.get(el)!
    if (!(key in record)) {
      record[key] = el.style[key as any]
    }
    el.style[key as any] = value
  }

  const restoreOverflow = (el: HTMLElement) => {
    rememberAndSet(el, 'overflow', 'visible')
    rememberAndSet(el, 'overflowX', 'visible')
    rememberAndSet(el, 'overflowY', 'visible')
  }

  let ancestor: HTMLElement | null = target
  while (ancestor && ancestor !== document.body) {
    const styles = window.getComputedStyle(ancestor)
    if (styles.overflow !== 'visible' || styles.overflowX !== 'visible' || styles.overflowY !== 'visible') {
      restoreOverflow(ancestor)
    }
    if (styles.maxHeight !== 'none') {
      rememberAndSet(ancestor, 'maxHeight', 'none')
    }
    ancestor = ancestor.parentElement
  }

  const scrollPositions: Array<{ element: HTMLElement; scrollTop: number }> = []
  const scrollSelectors = ['.scroll-area', '[data-export-scrollable="true"]']
  scrollSelectors.forEach(selector => {
    target.querySelectorAll<HTMLElement>(selector).forEach(element => {
      scrollPositions.push({ element, scrollTop: element.scrollTop })
      element.scrollTop = 0
      restoreOverflow(element)
      const styles = window.getComputedStyle(element)
      if (styles.maxHeight !== 'none') {
        rememberAndSet(element, 'maxHeight', 'none')
      }
      if (styles.height !== 'auto' && element.scrollHeight > element.clientHeight) {
        rememberAndSet(element, 'height', 'auto')
      }
    })
  })

  return () => {
    scrollPositions.forEach(({ element, scrollTop }) => {
      element.scrollTop = scrollTop
    })
    styleSnapshots.forEach((record, element) => {
      (Object.keys(record) as StyleKey[]).forEach(key => {
        const value = record[key]
        element.style[key as any] = value ?? ''
      })
    })
  }
}

async function handleExportSnapshot() {
  if (!queryResult.value) {
    showStatus('暂无可导出的查询结果', 'warning')
    return
  }

  const target = captureTargetRef.value
  if (!target) {
    showStatus('未找到可截图的区域', 'error')
    return
  }

  if (isCapturing.value) {
    return
  }

  let restoreLayout: (() => void) | null = null

  try {
    isCapturing.value = true
    showStatus('正在生成截图...', 'default')

    restoreLayout = adjustLayoutForCapture(target)

    const pixelRatio = Math.min(window.devicePixelRatio || 1, 2)
    const dataUrl = await toPng(target, {
      cacheBust: true,
      backgroundColor: '#020617',
      pixelRatio,
      filter: (node) => {
        if (!(node instanceof HTMLElement)) {
          return true
        }
        return node.dataset.exportIgnore !== 'true'
      },
    })

    const filename = buildExportFileName()
    downloadDataUrl(dataUrl, filename)
    showStatus('截图已下载，可分享给好友', 'success')
  } catch (error) {
    console.error('Export error:', error)
    showStatus('导出截图失败，请重试', 'error')
  } finally {
    restoreLayout?.()
    isCapturing.value = false
  }
}

onMounted(async () => {
  try {
    const health = await checkHealth()
    if (!health.service_connected) {
      showStatus('服务未连接，请检查后端配置', 'warning', 0)
    }
  } catch (error) {
    showStatus('无法连接到后端服务', 'error', 0)
  }
})
</script>
