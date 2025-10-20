<template>
  <section
    class="rounded-2xl border border-white/12 bg-slate-900/55 p-5 md:p-6 shadow-[0_6px_18px_rgba(15,23,42,0.28)] backdrop-blur-xl"
  >
    <div class="flex flex-col gap-4 md:flex-row md:items-center">
      <div class="relative flex-1">
        <div class="pointer-events-none absolute left-4 top-1/2 -translate-y-1/2 text-slate-300/60">
          <Search class="h-5 w-5" />
        </div>

        <input
          ref="accountInputRef"
          id="account"
          v-model="account"
          type="text"
          autocomplete="off"
          placeholder="输入米米号，示例：123456789"
          :disabled="loading"
          class="flex h-12 w-full rounded-2xl border border-white/10 bg-white/10 px-5 text-base text-slate-100 shadow-[inset_0_1px_0_rgba(255,255,255,0.15)] transition-all duration-200 placeholder:text-slate-300/60 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-sky-300/70 focus-visible:border-white/40 disabled:cursor-not-allowed disabled:opacity-60 backdrop-blur pl-12"
          @keypress.enter="handleQuery"
        />
      </div>

      <div class="flex flex-col gap-3 sm:flex-row md:flex-none md:flex-row md:items-center md:gap-3">
        <Button
          class="h-11 w-full px-6 sm:flex-1 md:flex-none md:w-auto rounded-xl border border-sky-300/50 bg-sky-400/85 text-slate-950 shadow-[0_6px_18px_rgba(56,189,248,0.18)] transition-transform duration-200 hover:bg-sky-300/85 active:scale-[0.99]"
          :disabled="loading"
          @click="handleQuery"
        >
          <Loader2 v-if="loading" class="h-4 w-4 animate-spin" />
          {{ loading ? '查询中...' : '立即查询' }}
        </Button>
        <Button
          class="h-11 w-full px-6 sm:flex-1 md:flex-none md:w-auto rounded-xl border border-white/15 bg-white/10 text-slate-100 shadow-[0_6px_16px_rgba(15,23,42,0.2)] transition-transform duration-200 hover:bg-white/16 active:scale-[0.99]"
          variant="secondary"
          @click="handleClear"
        >
          清空
        </Button>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import Button from './ui/Button.vue'
import { Loader2, Search } from 'lucide-vue-next'

const emit = defineEmits<{
  query: [account: string]
  clear: []
  'validation-error': [message: string]
}>()

const account = ref('')
const loading = defineModel<boolean>('loading', { default: false })
const accountInputRef = ref<HTMLInputElement | null>(null)

// 暴露方法给父组件
function getInputElement(): HTMLElement | null {
  return accountInputRef.value
}

defineExpose({
  getInputElement
})

function validateAccount(): string | null {
  const value = account.value.trim()

  if (!value) {
    return '米米号不能为空'
  }

  if (!/^\d+$/.test(value)) {
    return '米米号必须是纯数字'
  }

  // 转换为数字进行范围校验
  const accountNum = parseInt(value, 10)

  if (isNaN(accountNum)) {
    return '米米号格式无效'
  }

  // 严格的米米号范围：50000 - 2000000000
  if (accountNum < 50000) {
    return '米米号必须大于等于 50000'
  }

  if (accountNum > 2000000000) {
    return '米米号不能超过 2000000000'
  }

  return null
}

function handleQuery() {
  if (loading.value) return

  const error = validateAccount()
  if (error) {
    emit('validation-error', error)
    return
  }

  emit('query', account.value.trim())
}

function handleClear() {
  account.value = ''
  emit('clear')
}
</script>
