<template>
  <div class="space-y-6">
    <!-- Equipment & Appearance -->
    <Transition
      enter-active-class="transition-all duration-400 ease-out"
      enter-from-class="opacity-0 translate-y-4"
      enter-to-class="opacity-100 translate-y-0"
    >
      <Section v-if="isVisible(0)" title="装备与外观">
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        <InfoCard label="称号" :value="formatClothes(userinfo.clothes?.[0])" />
        <InfoCard label="头盔" :value="formatClothes(userinfo.clothes?.[1])" />
        <InfoCard label="武器" :value="formatClothes(userinfo.clothes?.[2])" />
        <InfoCard label="护腰" :value="formatClothes(userinfo.clothes?.[3])" />
        <InfoCard label="其他装备" :value="formatClothes(userinfo.clothes?.[4])" />
      </div>
      </Section>
    </Transition>

    <!-- Pet Information -->
    <Transition
      enter-active-class="transition-all duration-400 ease-out"
      enter-from-class="opacity-0 translate-y-4"
      enter-to-class="opacity-100 translate-y-0"
    >
      <Section v-if="isVisible(1)" title="精灵信息">
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <InfoCard label="精灵总数" :value="formatValue(userinfo.petAllNum, '只')" highlight />
        <InfoCard label="最高等级" :value="formatValue(userinfo.petMaxLev, '级')" highlight />
      </div>
      </Section>
    </Transition>

    <!-- Achievements -->
    <Transition
      enter-active-class="transition-all duration-400 ease-out"
      enter-from-class="opacity-0 translate-y-4"
      enter-to-class="opacity-100 translate-y-0"
    >
      <Section v-if="isVisible(2)" title="成就信息">
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        <InfoCard label="总成就" :value="formatValue(userinfo.totalAchieve)" highlight />
        <InfoCard label="成就闪耀" :value="formatValue(userinfo.achieShine)" />
        <InfoCard label="成就排名" :value="formatValue(userinfo.achieRank)" />
        <InfoCard label="当前称号" :value="formatValue(userinfo.curTitle)" />
        <InfoCard label="Boss成就" :value="formatBossAchievement(userinfo.bossAchievement)" />
      </div>
      </Section>
    </Transition>

    <!-- Tower Progress -->
    <Transition
      enter-active-class="transition-all duration-400 ease-out"
      enter-from-class="opacity-0 translate-y-4"
      enter-to-class="opacity-100 translate-y-0"
    >
      <Section v-if="isVisible(3)" title="赛尔闯关">
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        <InfoCard label="试炼之塔" :value="formatValue(userinfo.maxFreshStage, '层')" />
        <InfoCard label="勇者之塔" :value="formatValue(userinfo.maxStage, '层')" />
        <InfoCard label="战斗阶梯" :value="formatValue(userinfo.maxLadderState, '层')" />
        <InfoCard label="王者之塔" :value="formatValue(userinfo.maxKingStage, '层')" />
        <InfoCard label="王者英雄塔" :value="formatValue(userinfo.maxKingHeroStage, '层')" />
        <InfoCard label="命运之轮" :value="formatValue(userinfo.maxFortuneState, '层')" />
        <InfoCard label="高阶战斗" :value="formatValue(userinfo.highFightWin, '层')" />
        <InfoCard label="极限法则" :value="formatValue(userinfo.extremeLawLevel, '层')" />
        <InfoCard label="作战实验室" :value="formatValue(userinfo.battleLabInfo, '层')" />
      </div>
      </Section>
    </Transition>

    <!-- Battle Stats -->
    <Transition
      enter-active-class="transition-all duration-400 ease-out"
      enter-from-class="opacity-0 translate-y-4"
      enter-to-class="opacity-100 translate-y-0"
    >
      <Section v-if="isVisible(4)" title="赛尔对抗">
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        <InfoCard label="精灵王之战" :value="formatValue(userinfo.totalClassWins, '胜')" highlight />
        <InfoCard label="君主王之战" :value="formatValue(userinfo.monKingWin, '胜')" />
        <InfoCard label="战队Boss" :value="formatValue(userinfo.teamBoss, '次')" />
        <InfoCard label="精灵大乱斗" :value="formatValue(userinfo.messWin, '胜')" />
        <InfoCard label="幸运大作战" :value="formatValue(userinfo.luckyFightWin, '胜')" />
        <InfoCard label="圣地角斗场" :value="formatValue(userinfo.fightArenaWin, '胜')" />
        <InfoCard label="精灵大逃杀" :value="formatValue(userinfo.royaleWin, '胜')" />
        <InfoCard label="暗黑武道场" :value="formatValue(userinfo.darkFightWin, '胜')" />
        <InfoCard label="星际擂台" :value="formatValue(userinfo.maxArenaWins, '胜')" />
        <InfoCard label="星空擂台" :value="formatValue(userinfo.maxSpaceArenaWins, '胜')" />
        <InfoCard label="折光幻阵" :value="formatValue(userinfo.zheguangWinTimes, '胜')" />
        <InfoCard label="梦幻大乱斗" :value="formatValue(userinfo.dreamMessWins, '胜')" />
        <InfoCard label="战神联盟" :value="formatValue(userinfo.aresUnionTeam)" />
      </div>
      </Section>
    </Transition>

    <!-- Peak Battle -->
    <Transition
      enter-active-class="transition-all duration-400 ease-out"
      enter-from-class="opacity-0 translate-y-4"
      enter-to-class="opacity-100 translate-y-0"
    >
      <Section v-if="isVisible(5)" title="巅峰战斗">
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        <InfoCard label="当前荣誉" :value="formatValue(userinfo.curTopHonour)" highlight />
        <InfoCard label="荣誉变化" :value="formatValue(userinfo.deltaTopHonour)" />
        <InfoCard label="巅峰等级" :value="formatValue(userinfo.deltaTopLv, '级')" />
        <InfoCard label="巅峰胜场" :value="formatValue(userinfo.topWinCount, '胜')" />
        <InfoCard label="巅峰败场" :value="formatValue(userinfo.topLossCount, '败')" />
        <InfoCard label="最大连胜" :value="formatValue(userinfo.maxTopWinSucc, '连胜')" />
        <InfoCard label="当前连胜" :value="formatValue(userinfo.curTopWinSucc, '连胜')" />
      </div>
      </Section>
    </Transition>

    <!-- Activities -->
    <Transition
      enter-active-class="transition-all duration-400 ease-out"
      enter-from-class="opacity-0 translate-y-4"
      enter-to-class="opacity-100 translate-y-0"
    >
      <Section v-if="isVisible(6)" title="活动统计">
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        <InfoCard label="训练营" :value="formatValue(userinfo.trainerDoor_num)" />
        <InfoCard label="嘉年华积分" :value="formatValue(userinfo.carnival_total_score)" />
        <InfoCard label="跨栏胜场" :value="formatValue(userinfo.hurdles_win_num, '胜')" />
        <InfoCard label="拔河胜场" :value="formatValue(userinfo.tug_win_num, '胜')" />
        <InfoCard label="跳跃次数" :value="formatValue(userinfo.jump_num, '次')" />
      </div>
      </Section>
    </Transition>

    <!-- Debug Info -->
    <Transition
      enter-active-class="transition-all duration-400 ease-out"
      enter-from-class="opacity-0 translate-y-4"
      enter-to-class="opacity-100 translate-y-0"
    >
      <Card v-if="isVisible(7)">
      <CardContent class="pt-6">
        <button
          @click="debugVisible = !debugVisible"
          class="w-full flex items-center justify-between text-sm font-medium hover:text-primary transition-colors"
        >
          <span>调试信息</span>
          <ChevronDown :class="['w-4 h-4 transition-transform', debugVisible && 'rotate-180']" />
        </button>
        <div
          v-show="debugVisible"
          class="mt-4 p-4 bg-muted rounded-md overflow-auto max-h-96"
        >
          <pre class="text-xs">{{ JSON.stringify(userinfo, null, 2) }}</pre>
        </div>
      </CardContent>
      </Card>
    </Transition>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import { ChevronDown } from 'lucide-vue-next'
import Card from './ui/Card.vue'
import CardContent from './ui/CardContent.vue'
import Section from './Section.vue'
import InfoCard from './InfoCard.vue'
import type { UserInfo, ClothesItem } from '@/types'
import { formatValue } from '@/lib/utils'
import { useSequentialTypewriter } from '@/composables/useTypewriter'

interface Props {
  userinfo: UserInfo
  animate?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  animate: false
})

const debugVisible = ref(false)
const { isVisible, startSequence } = useSequentialTypewriter()

// 监听animate变化，启动逐section显示动画
watch(() => props.animate, (newValue) => {
  if (newValue) {
    startSequence(8, 120) // 8个section，每个间隔120ms
  }
}, { immediate: true })

function formatClothes(item: ClothesItem | undefined): string {
  if (!item || !item.id) return '--'
  return `ID: ${item.id}`
}

function formatBossAchievement(achievements: boolean[] | undefined): string {
  if (!achievements) return '--'
  const count = achievements.filter(x => x).length
  return `${count}/199`
}
</script>
