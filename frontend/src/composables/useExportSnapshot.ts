import { ref } from 'vue'
import { toPng } from 'html-to-image'
import type { StatusType } from './useStatusBanner'

type StyleKey = 'overflow' | 'overflowX' | 'overflowY' | 'maxHeight' | 'height'

interface ExportSnapshotOptions {
  filename: string
  target?: HTMLElement | null
}

interface ExportSnapshotDependencies {
  showStatus: (message: string, type?: StatusType, duration?: number) => void
}

export function useExportSnapshot({ showStatus }: ExportSnapshotDependencies) {
  const captureTargetRef = ref<HTMLElement | null>(null)
  const isCapturing = ref(false)

  const exportSnapshot = async ({ filename, target }: ExportSnapshotOptions) => {
    const element = target ?? captureTargetRef.value
    if (!element) {
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

      restoreLayout = adjustLayoutForCapture(element)

      const pixelRatio = Math.min(window.devicePixelRatio || 1, 2)
      const dataUrl = await toPng(element, {
        cacheBust: true,
        backgroundColor: '#020617',
        pixelRatio,
        filter: node => {
          if (!(node instanceof HTMLElement)) {
            return true
          }
          return node.dataset.exportIgnore !== 'true'
        },
      })

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

  return {
    captureTargetRef,
    isCapturing,
    exportSnapshot,
  }
}

function downloadDataUrl(dataUrl: string, filename: string) {
  const link = document.createElement('a')
  link.href = dataUrl
  link.download = filename
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
}

function adjustLayoutForCapture(target: HTMLElement) {
  const originalInlineStyles = new Map<HTMLElement, string | null>()
  const STYLE_PROPERTY_MAP: Record<StyleKey, string> = {
    overflow: 'overflow',
    overflowX: 'overflow-x',
    overflowY: 'overflow-y',
    maxHeight: 'max-height',
    height: 'height',
  }

  const rememberStyle = (el: HTMLElement) => {
    if (!originalInlineStyles.has(el)) {
      originalInlineStyles.set(el, el.getAttribute('style'))
    }
  }

  const rememberAndSet = (el: HTMLElement, key: StyleKey, value: string) => {
    rememberStyle(el)
    const property = STYLE_PROPERTY_MAP[key]
    el.style.setProperty(property, value)
  }

  const restoreOverflow = (el: HTMLElement) => {
    rememberAndSet(el, 'overflow', 'visible')
    rememberAndSet(el, 'overflowX', 'visible')
    rememberAndSet(el, 'overflowY', 'visible')
  }

  let ancestor: HTMLElement | null = target
  while (ancestor && ancestor !== document.body) {
    const styles = window.getComputedStyle(ancestor)
    if (
      styles.overflow !== 'visible' ||
      styles.overflowX !== 'visible' ||
      styles.overflowY !== 'visible'
    ) {
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
    originalInlineStyles.forEach((originalStyle, element) => {
      if (originalStyle && originalStyle.length > 0) {
        element.setAttribute('style', originalStyle)
      } else {
        element.removeAttribute('style')
      }
    })
  }
}
