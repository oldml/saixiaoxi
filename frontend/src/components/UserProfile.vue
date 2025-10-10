<template>
  <Card class="h-fit sticky top-4">
    <CardContent class="pt-6 space-y-6">
      <!-- Avatar Section -->
      <div class="flex flex-col items-center space-y-2">
        <div class="w-24 h-24 rounded-full overflow-hidden">
          <img src="@/assets/images/avatar.png" alt="Avatar" class="w-full h-full object-cover" />
        </div>
        <div class="text-center">
          <h3 class="font-bold text-lg">{{ userinfo.nick || '未知' }}</h3>
          <Transition
            enter-active-class="transition-all duration-500 ease-out"
            enter-from-class="opacity-0 scale-90"
            enter-to-class="opacity-100 scale-100"
          >
            <p v-if="showUserId" class="text-sm text-muted-foreground">ID: {{ userinfo.userID || '--' }}</p>
          </Transition>
        </div>
      </div>

      <!-- Basic Information -->
      <div class="space-y-3">
        <h4 class="font-semibold text-sm border-b pb-2">基本信息</h4>
        <div class="space-y-2 text-sm">
          <Transition
            enter-active-class="transition-all duration-300 ease-out"
            enter-from-class="opacity-0 translate-x-4"
            enter-to-class="opacity-100 translate-x-0"
          >
            <InfoRow v-if="isVisible(0)" label="米米号" :value="formatValue(userinfo.userID)" />
          </Transition>
          <Transition
            enter-active-class="transition-all duration-300 ease-out"
            enter-from-class="opacity-0 translate-x-4"
            enter-to-class="opacity-100 translate-x-0"
          >
            <InfoRow v-if="isVisible(1)" label="昵称" :value="userinfo.nick || '未知'" />
          </Transition>
          <Transition
            enter-active-class="transition-all duration-300 ease-out"
            enter-from-class="opacity-0 translate-x-4"
            enter-to-class="opacity-100 translate-x-0"
          >
            <InfoRow v-if="isVisible(2)" label="VIP状态" :value="userinfo.vip ? '是' : '否'" />
          </Transition>
          <Transition
            enter-active-class="transition-all duration-300 ease-out"
            enter-from-class="opacity-0 translate-x-4"
            enter-to-class="opacity-100 translate-x-0"
          >
            <InfoRow v-if="isVisible(3)" label="VIP等级" :value="formatValue(userinfo.vipLevel)" />
          </Transition>
          <Transition
            enter-active-class="transition-all duration-300 ease-out"
            enter-from-class="opacity-0 translate-x-4"
            enter-to-class="opacity-100 translate-x-0"
          >
            <InfoRow v-if="isVisible(4)" label="VIP徽章">
              <template #value>
                <span :class="userinfo.vip ? 'text-yellow-600 font-semibold' : 'text-muted-foreground'">
                  {{ userinfo.vip ? `VIP ${userinfo.vipLevel}` : '普通用户' }}
                </span>
              </template>
            </InfoRow>
          </Transition>
          <Transition
            enter-active-class="transition-all duration-300 ease-out"
            enter-from-class="opacity-0 translate-x-4"
            enter-to-class="opacity-100 translate-x-0"
          >
            <InfoRow v-if="isVisible(5)" label="至尊NONO" :value="userinfo.isExtremeNono ? '是' : '否'" />
          </Transition>
          <Transition
            enter-active-class="transition-all duration-300 ease-out"
            enter-from-class="opacity-0 translate-x-4"
            enter-to-class="opacity-100 translate-x-0"
          >
            <InfoRow v-if="isVisible(6)" label="账号状态">
              <template #value>
                <span :class="getStatusClass(userinfo.status)">
                  {{ getStatusText(userinfo.status) }}
                </span>
              </template>
            </InfoRow>
          </Transition>
          <Transition
            enter-active-class="transition-all duration-300 ease-out"
            enter-from-class="opacity-0 translate-x-4"
            enter-to-class="opacity-100 translate-x-0"
          >
            <InfoRow v-if="isVisible(7)" label="注册时间" :value="formatTimestamp(userinfo.regTime)" />
          </Transition>
          <Transition
            enter-active-class="transition-all duration-300 ease-out"
            enter-from-class="opacity-0 translate-x-4"
            enter-to-class="opacity-100 translate-x-0"
          >
            <InfoRow v-if="isVisible(8)" label="最后登录时间" :value="formatTimestamp(userinfo.loginTime)" />
          </Transition>
          <Transition
            enter-active-class="transition-all duration-300 ease-out"
            enter-from-class="opacity-0 translate-x-4"
            enter-to-class="opacity-100 translate-x-0"
          >
            <InfoRow v-if="isVisible(9)" label="上一次离线时间" :value="formatTimestamp(userinfo.lastOfflineTime)" />
          </Transition>
          <Transition
            enter-active-class="transition-all duration-300 ease-out"
            enter-from-class="opacity-0 translate-x-4"
            enter-to-class="opacity-100 translate-x-0"
          >
            <InfoRow v-if="isVisible(10)" label="战队ID" :value="formatValue(userinfo.teamID) || '无'" />
          </Transition>
        </div>
      </div>
    </CardContent>
  </Card>
</template>

<script setup lang="ts">
import { watch } from 'vue'
import Card from './ui/Card.vue'
import CardContent from './ui/CardContent.vue'
import InfoRow from './InfoRow.vue'
import type { UserInfo } from '@/types'
import { formatTimestamp, formatValue } from '@/lib/utils'
import { useSequentialTypewriter } from '@/composables/useTypewriter'

interface Props {
  userinfo: UserInfo
  showUserId?: boolean
  animate?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  showUserId: false,
  animate: false
})

const { isVisible, startSequence } = useSequentialTypewriter()

// 监听animate变化，启动逐条显示动画
watch(() => props.animate, (newValue) => {
  if (newValue) {
    startSequence(11, 50) // 11个信息项，每项间隔50ms
  }
}, { immediate: true })

function getStatusText(status: number): string {
  const statusMap: Record<number, string> = {
    0: '正常',
    1: '封禁',
    2: '冻结'
  }
  return statusMap[status] || '未知'
}

function getStatusClass(status: number): string {
  if (status === 0) return 'text-green-600'
  if (status === 1) return 'text-red-600'
  if (status === 2) return 'text-yellow-600'
  return 'text-muted-foreground'
}
</script>
