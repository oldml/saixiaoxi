<template>
  <div class="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 dark:from-gray-900 dark:to-gray-800 flex items-center justify-center py-8 px-4">
    <div class="w-full max-w-md space-y-6">
      <!-- Query Form -->
      <QueryForm
        v-model:loading="isLoading"
        @query="handleQuery"
        @clear="handleClear"
      />

      <!-- Status Alert -->
      <Transition
        enter-active-class="transition-all duration-300 ease-out"
        enter-from-class="opacity-0 -translate-y-4"
        enter-to-class="opacity-100 translate-y-0"
        leave-active-class="transition-all duration-200 ease-in"
        leave-from-class="opacity-100 translate-y-0"
        leave-to-class="opacity-0 -translate-y-4"
      >
        <Alert
          v-if="status.show"
          :variant="status.type"
        >
          {{ status.message }}
        </Alert>
      </Transition>
    </div>

    <!-- Results Dialog -->
    <Dialog v-model:open="dialogOpen" @close="handleCloseDialog">
      <DialogHeader>
        <DialogTitle>查询结果</DialogTitle>
      </DialogHeader>
      <DialogContent>
        <div
          v-if="queryResult"
          class="grid grid-cols-1 lg:grid-cols-4 gap-6"
        >
          <!-- User Profile Sidebar -->
          <div class="lg:col-span-1">
            <UserProfile
              :userinfo="queryResult.userinfo"
              :show-user-id="showUserId"
              :animate="animateProfile"
            />
          </div>

          <!-- User Details Main Content -->
          <div class="lg:col-span-3">
            <UserDetails
              :userinfo="queryResult.userinfo"
              :animate="animateDetails"
            />
          </div>
        </div>
      </DialogContent>
    </Dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, nextTick } from 'vue'
import QueryForm from './components/QueryForm.vue'
import UserProfile from './components/UserProfile.vue'
import UserDetails from './components/UserDetails.vue'
import Alert from './components/ui/Alert.vue'
import Dialog from './components/ui/Dialog.vue'
import DialogHeader from './components/ui/DialogHeader.vue'
import DialogTitle from './components/ui/DialogTitle.vue'
import DialogContent from './components/ui/DialogContent.vue'
import { queryAccount, checkHealth } from './api'
import type { QueryResponse } from './types'

const isLoading = ref(false)
const queryResult = ref<QueryResponse['data'] | null>(null)
const dialogOpen = ref(false)
const showUserId = ref(false)
const animateProfile = ref(false)
const animateDetails = ref(false)

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

function handleCloseDialog() {
  dialogOpen.value = false
  showUserId.value = false
  animateProfile.value = false
  animateDetails.value = false
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
