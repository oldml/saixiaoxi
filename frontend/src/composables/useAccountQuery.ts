import { nextTick, ref } from 'vue'
import { queryAccount } from '@/api'
import type { QueryResponse } from '@/types'
import type { StatusType } from './useStatusBanner'

interface AccountQueryOptions {
  showStatus: (message: string, type?: StatusType, duration?: number) => void
  hideStatus: () => void
}

export function useAccountQuery({ showStatus, hideStatus }: AccountQueryOptions) {
  const isLoading = ref(false)
  const queryResult = ref<QueryResponse['data'] | null>(null)
  const dialogOpen = ref(false)
  const showUserId = ref(false)
  const animateProfile = ref(false)
  const animateDetails = ref(false)

  const resetAnimations = () => {
    showUserId.value = false
    animateProfile.value = false
    animateDetails.value = false
  }

  const handleQuery = async (account: string) => {
    isLoading.value = true
    hideStatus()
    queryResult.value = null
    dialogOpen.value = false
    resetAnimations()

    try {
      showStatus('正在查询用户信息...', 'default', 0)
      const result = await queryAccount(account)

      if (!result.success || !result.data) {
        throw new Error(result.message || '查询失败')
      }

      queryResult.value = result.data
      showStatus('查询成功！', 'success')
      dialogOpen.value = true

      await nextTick()
      await new Promise(resolve => setTimeout(resolve, 150))

      showUserId.value = true
      await nextTick()
      animateProfile.value = true

      window.setTimeout(() => {
        animateDetails.value = true
      }, 200)
    } catch (error) {
      const message =
        error instanceof Error ? error.message : '查询失败'
      showStatus(`查询失败: ${message}`, 'error')
      console.error('Query error:', error)
    } finally {
      isLoading.value = false
    }
  }

  const handleClear = () => {
    queryResult.value = null
    dialogOpen.value = false
    resetAnimations()
    hideStatus()
  }

  const handleValidationError = (message: string) => {
    showStatus(message, 'error')
  }

  const handleCloseDialog = () => {
    dialogOpen.value = false
    resetAnimations()
  }

  return {
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
  }
}

