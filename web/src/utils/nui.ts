export const fetchNui = async <T = unknown>(eventName: string, data: unknown = {}): Promise<T | null> => {
  const resourceName = (window as any).GetParentResourceName?.() || 'wasteland_admin'
  
  try {
    const resp = await fetch(`https://${resourceName}/${eventName}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    })
    
    const text = await resp.text()
    if (!text || text === 'ok') return null
    
    try {
      return JSON.parse(text)
    } catch {
      return null
    }
  } catch {
    return null
  }
}

export const isEnvBrowser = (): boolean => !(window as any).invokeNative
