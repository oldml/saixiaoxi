import { ref, nextTick } from 'vue'

export interface FlyingAnimationOptions {
  duration?: number // 动画持续时间（ms）
  onComplete?: () => void
}

export function useFlyingAnimation() {
  const isAnimating = ref(false)
  const animatingElement = ref<HTMLElement | null>(null)

  async function animateFromTo(
    fromElement: HTMLElement,
    toElement: HTMLElement,
    content: string,
    options: FlyingAnimationOptions = {}
  ) {
    const { duration = 800, onComplete } = options

    // 获取起点和终点的位置
    const fromRect = fromElement.getBoundingClientRect()
    const toRect = toElement.getBoundingClientRect()

    // 创建飞行元素（简单的文字）
    const flyingEl = document.createElement('div')
    flyingEl.textContent = content

    // 使用内联样式确保样式生效
    Object.assign(flyingEl.style, {
      position: 'fixed',
      zIndex: '9999',
      left: `${fromRect.left}px`,
      top: `${fromRect.top}px`,
      padding: '0.5rem 1rem',
      backgroundColor: 'hsl(var(--primary, 222.2 47.4% 11.2%))',
      color: 'hsl(var(--primary-foreground, 210 40% 98%))',
      borderRadius: '0.375rem',
      fontWeight: '500',
      fontSize: '0.875rem',
      boxShadow: '0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1)',
      pointerEvents: 'none',
      transition: `all ${duration}ms cubic-bezier(0.4, 0, 0.2, 1)`,
      opacity: '1',
      transform: 'scale(1)'
    })

    document.body.appendChild(flyingEl)
    isAnimating.value = true
    animatingElement.value = flyingEl

    // 触发动画
    await nextTick()

    // 计算目标位置（飞向目标元素的中心偏上位置）
    const targetX = toRect.left + toRect.width / 2 - flyingEl.offsetWidth / 2
    const targetY = toRect.top - 20 // 稍微在目标上方

    flyingEl.style.left = `${targetX}px`
    flyingEl.style.top = `${targetY}px`
    flyingEl.style.opacity = '0'
    flyingEl.style.transform = 'scale(0.5) translateY(-10px)'

    // 等待动画完成
    setTimeout(() => {
      if (document.body.contains(flyingEl)) {
        document.body.removeChild(flyingEl)
      }
      isAnimating.value = false
      animatingElement.value = null
      onComplete?.()
    }, duration)
  }

  return {
    isAnimating,
    animateFromTo
  }
}
