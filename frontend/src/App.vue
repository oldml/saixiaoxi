<template>
  <div class="relative min-h-screen overflow-hidden bg-gradient-to-br from-slate-950 via-slate-900 to-slate-950 text-slate-100">
    <a
      class="github-corner pointer-events-auto"
      href="https://github.com/oldml/saixiaoxi"
      aria-label="View source on GitHub"
      target="_blank"
      rel="noopener noreferrer"
    >
      <svg width="80" height="80" viewBox="0 0 250 250" aria-hidden="true">
        <path d="M0,0 L115,115 L130,115 L142,142 L250,250 L250,0 Z" />
        <path
          class="octo-arm"
          d="M128.3,109.0 C113.8,99.7 119.0,89.6 119.0,89.6 C122.0,82.7 120.5,78.6 120.5,78.6 C119.2,72.0 123.4,76.3 123.4,76.3 C127.3,80.9 125.5,87.3 125.5,87.3 C122.9,97.6 130.6,101.9 134.4,103.2"
          fill="currentColor"
        />
        <path
          class="octo-body"
          d="M115.0,115.0 C114.9,115.1 118.7,116.5 119.8,115.4 L133.7,101.6 C136.9,99.2 139.9,98.4 142.2,98.6 C133.8,88.0 127.5,74.4 143.8,58.0 C148.5,53.4 154.0,51.2 159.7,51.0 C160.3,49.4 163.2,43.6 171.4,40.1 C171.4,40.1 176.1,42.5 178.8,56.2 C183.1,58.6 187.2,61.8 190.9,65.4 C194.5,69.0 197.7,73.2 200.1,77.6 C213.8,80.2 216.3,84.9 216.3,84.9 C212.7,93.1 206.9,96.0 205.4,96.6 C205.1,102.4 203.0,107.8 198.3,112.5 C181.9,128.9 168.3,122.5 157.7,114.1 C157.9,116.9 156.7,120.9 152.7,124.9 L141.0,136.5 C139.8,137.7 141.6,141.9 141.8,141.8 Z"
          fill="currentColor"
        />
      </svg>
    </a>
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

              <HighlightTiles :tiles="highlightTiles" />

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

    <AccountResultDialog
      v-model:open="dialogOpen"
      :query-result="queryResult"
      :show-user-id="showUserId"
      :animate-profile="animateProfile"
      :animate-details="animateDetails"
      :is-capturing="isCapturing"
      @close="handleCloseDialog"
      @export="handleExportSnapshot"
      @register-capture-target="registerCaptureTarget"
    />
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted } from 'vue'
import QueryForm from './components/QueryForm.vue'
import HighlightTiles from './components/HighlightTiles.vue'
import Alert from './components/ui/Alert.vue'
import AccountResultDialog from './components/AccountResultDialog.vue'
import { checkHealth } from './api'
import { HIGHLIGHT_TILES } from './constants/highlightTiles'
import { useStatusBanner } from './composables/useStatusBanner'
import { useAccountQuery } from './composables/useAccountQuery'
import { useExportSnapshot } from './composables/useExportSnapshot'

const highlightTiles = HIGHLIGHT_TILES

const { status, alertTone, showStatus, hideStatus } = useStatusBanner()

const {
  isLoading,
  queryResult,
  dialogOpen,
  showUserId,
  animateProfile,
  animateDetails,
  handleQuery,
  handleClear,
  handleValidationError,
  handleCloseDialog,
} = useAccountQuery({ showStatus, hideStatus })

const { captureTargetRef, isCapturing, exportSnapshot } = useExportSnapshot({ showStatus })

const registerCaptureTarget = (element: HTMLElement | null) => {
  captureTargetRef.value = element
}

const placeholderState = computed(() => {
  if (queryResult.value) {
    return {
      title: '结果已准备就绪',
      description:
        '刚刚完成的账号档案已缓存，可继续检索新的米米号或重新打开弹窗查看详情。',
    }
  }
  return {
    title: '等待查询',
    description:
      '输入合法的米米号并点击「立即查询」，系统会在此展示战斗记录、精灵数据与账号健康状态。',
  }
})

const buildExportFileName = () => {
  const defaultName = 'saixiaoxi-result.png'
  const userinfo = queryResult.value?.userinfo
  if (!userinfo) {
    return defaultName
  }

  const nick = (userinfo.nick || '').trim()
  const sanitizedNick = nick
    .replace(/[<>:"/\\|?*\u0000-\u001F]+/g, '')
    .replace(/\s+/g, '')
  const suffix = sanitizedNick ? `${sanitizedNick}-${userinfo.userID}` : `${userinfo.userID}`

  return `saixiaoxi-${suffix}.png`
}

const handleExportSnapshot = async () => {
  if (!queryResult.value) {
    showStatus('暂无可导出的查询结果', 'warning')
    return
  }

  await exportSnapshot({
    filename: buildExportFileName(),
  })
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
