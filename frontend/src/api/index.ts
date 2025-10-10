import type { QueryResponse, HealthResponse } from '@/types'

const API_BASE = import.meta.env.VITE_API_BASE || ''

export async function queryAccount(account: string): Promise<QueryResponse> {
  const response = await fetch(`${API_BASE}/api/query`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ account }),
  })

  if (!response.ok) {
    const error = await response.json()
    throw new Error(error.detail || '查询失败')
  }

  return response.json()
}

export async function checkHealth(): Promise<HealthResponse> {
  const response = await fetch(`${API_BASE}/health`)
  return response.json()
}
