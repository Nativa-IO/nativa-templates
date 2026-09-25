import { useEffect, useState } from 'react'

// Pantalla de bienvenida de Nativa: placeholder autocontenido que el primer
// build del proyecto reemplaza. Todo vive en este archivo a propósito.

const API_URL = import.meta.env.VITE_API_URL ?? ''
const PROJECT_NAME = import.meta.env.VITE_PROJECT_NAME || 'Tu proyecto Nativa'

const colors = {
  bg: '#090909',
  surface: '#101010',
  text: '#E6EDF3',
  muted: '#8A919C',
  violet: '#A78BFA',
  green: '#3FB950',
}

function useBackendHealth() {
  const [ok, setOk] = useState(false)

  useEffect(() => {
    let cancelled = false
    let timer: number | undefined

    const check = async () => {
      let alive = false
      try {
        alive = (await fetch(`${API_URL}/health`)).ok
      } catch {
        // Sin CORS en el backend, el fetch cross-origin truena aunque esté
        // arriba; un ping opaco distingue "sin CORS" de "caído".
        try {
          await fetch(`${API_URL}/health`, { mode: 'no-cors' })
          alive = true
        } catch {
          // backend aún no responde
        }
      }
      if (cancelled) return
      if (alive) {
        setOk(true)
      } else {
        timer = window.setTimeout(check, 3000)
      }
    }

    check()
    return () => {
      cancelled = true
      window.clearTimeout(timer)
    }
  }, [])

  return ok
}

function App() {
  const backendOk = useBackendHealth()

  useEffect(() => {
    document.title = PROJECT_NAME
  }, [])

  return (
    <main
      style={{
        minHeight: '100svh',
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'center',
        gap: 28,
        padding: 24,
        textAlign: 'center',
        background: `radial-gradient(rgba(120,128,140,.10) .7px, transparent .7px) 0 0 / 24px 24px, ${colors.bg}`,
        color: colors.text,
        fontFamily:
          "-apple-system, BlinkMacSystemFont, 'Inter', 'Segoe UI', Roboto, sans-serif",
        WebkitFontSmoothing: 'antialiased',
      }}
    >
      <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
        <div
          style={{
            width: 56,
            height: 56,
            display: 'grid',
            placeItems: 'center',
            background: colors.surface,
            border: '1px solid rgba(255,255,255,.08)',
            borderRadius: 14,
            fontSize: 26,
            fontWeight: 700,
            color: colors.violet,
          }}
        >
          N
        </div>
        <span style={{ fontSize: 24, fontWeight: 600, letterSpacing: '-0.02em' }}>
          Nativa
        </span>
      </div>

      <h1
        style={{
          margin: 0,
          fontSize: 'clamp(28px, 5vw, 44px)',
          fontWeight: 600,
          letterSpacing: '-0.03em',
        }}
      >
        {PROJECT_NAME}
      </h1>

      <div
        style={{
          display: 'inline-flex',
          alignItems: 'center',
          gap: 8,
          padding: '6px 14px',
          borderRadius: 999,
          fontSize: 14,
          background: backendOk ? 'rgba(63,185,80,.12)' : colors.surface,
          border: `1px solid ${backendOk ? 'rgba(63,185,80,.4)' : 'rgba(255,255,255,.08)'}`,
          color: backendOk ? colors.green : colors.muted,
        }}
      >
        <span
          style={{
            width: 7,
            height: 7,
            borderRadius: '50%',
            background: backendOk ? colors.green : colors.muted,
          }}
        />
        {backendOk ? 'Backend conectado ✓' : 'Backend arrancando…'}
      </div>

      <p style={{ margin: 0, maxWidth: 420, lineHeight: 1.6, color: colors.muted }}>
        Tu proyecto está vivo. Pide tu primer cambio desde el chat de la sesión
        en Nativa.
      </p>
    </main>
  )
}

export default App
