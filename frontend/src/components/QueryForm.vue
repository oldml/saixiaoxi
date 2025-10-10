<template>
  <Card class="w-full">
    <CardHeader>
      <CardTitle class="text-2xl text-center">小赛尔账号信息查询助手</CardTitle>
      <p class="text-sm text-muted-foreground text-center">Saixiaoxi Account Query Service</p>
    </CardHeader>
    <CardContent class="space-y-4">
      <div class="space-y-2">
        <label for="account" class="text-sm font-medium">米米号</label>
        <Input
          ref="accountInputRef"
          id="account"
          v-model="account"
          placeholder="请输入米米号（50000 - 2000000000）"
          :disabled="loading"
          @keypress.enter="handleQuery"
          autocomplete="off"
        />
      </div>
      <div class="flex gap-2">
        <Button
          class="flex-1"
          :disabled="loading"
          @click="handleQuery"
        >
          <Loader2 v-if="loading" class="w-4 h-4 animate-spin" />
          {{ loading ? '查询中...' : '查询' }}
        </Button>
        <Button
          variant="secondary"
          @click="handleClear"
        >
          清空
        </Button>
      </div>
    </CardContent>
  </Card>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import Card from './ui/Card.vue'
import CardHeader from './ui/CardHeader.vue'
import CardContent from './ui/CardContent.vue'
import CardTitle from './ui/CardTitle.vue'
import Input from './ui/Input.vue'
import Button from './ui/Button.vue'
import { Loader2 } from 'lucide-vue-next'

const emit = defineEmits<{
  query: [account: string]
  clear: []
}>()

const account = ref('')
const loading = defineModel<boolean>('loading', { default: false })
const accountInputRef = ref<any>(null)

// 暴露方法给父组件
function getInputElement(): HTMLElement | null {
  if (!accountInputRef.value) return null
  return accountInputRef.value.$el || accountInputRef.value
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
    alert(error)
    return
  }

  emit('query', account.value.trim())
}

function handleClear() {
  account.value = ''
  emit('clear')
}
</script>
