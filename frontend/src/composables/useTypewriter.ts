import { ref, onUnmounted } from 'vue'

export interface TypewriterOptions {
  speed?: number // 每个字符的延迟时间（ms）
  startDelay?: number // 开始前的延迟时间（ms）
  onComplete?: () => void
}

export function useTypewriter() {
  const displayedText = ref('')
  const isTyping = ref(false)
  let timeoutIds: number[] = []

  function typeText(text: string, options: TypewriterOptions = {}) {
    const {
      speed = 30,
      startDelay = 0,
      onComplete
    } = options

    // 清除之前的动画
    stop()
    displayedText.value = ''
    isTyping.value = true

    const startTimeout = setTimeout(() => {
      let currentIndex = 0

      const typeNextChar = () => {
        if (currentIndex < text.length) {
          displayedText.value += text[currentIndex]
          currentIndex++

          const charTimeout = setTimeout(typeNextChar, speed) as unknown as number
          timeoutIds.push(charTimeout)
        } else {
          isTyping.value = false
          onComplete?.()
        }
      }

      typeNextChar()
    }, startDelay) as unknown as number

    timeoutIds.push(startTimeout)
  }

  function stop() {
    timeoutIds.forEach(id => clearTimeout(id))
    timeoutIds = []
    isTyping.value = false
  }

  function reset() {
    stop()
    displayedText.value = ''
  }

  onUnmounted(() => {
    stop()
  })

  return {
    displayedText,
    isTyping,
    typeText,
    stop,
    reset
  }
}

// 用于多个元素的序列化打字机效果
export function useSequentialTypewriter() {
  const visibleItems = ref<Set<number>>(new Set())
  const typingQueue = ref<number[]>([])
  let currentIndex = 0
  let timeoutId: number | null = null

  function startSequence(totalItems: number, delayBetween = 100) {
    reset()
    typingQueue.value = Array.from({ length: totalItems }, (_, i) => i)
    currentIndex = 0
    showNext(delayBetween)
  }

  function showNext(delay: number) {
    if (currentIndex < typingQueue.value.length) {
      visibleItems.value.add(typingQueue.value[currentIndex])
      currentIndex++

      timeoutId = setTimeout(() => {
        showNext(delay)
      }, delay) as unknown as number
    }
  }

  function reset() {
    if (timeoutId) {
      clearTimeout(timeoutId)
      timeoutId = null
    }
    visibleItems.value.clear()
    currentIndex = 0
  }

  function isVisible(index: number): boolean {
    return visibleItems.value.has(index)
  }

  onUnmounted(() => {
    reset()
  })

  return {
    visibleItems,
    isVisible,
    startSequence,
    reset
  }
}
