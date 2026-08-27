import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    allowedHosts: true,
    // Sin config de hmr: el cliente usa el origen de la página (wss:443
    // detrás del preview público, ws:3000 en local). Fijar host/clientPort
    // aquí rompe uno de los dos accesos.
  },
  preview: {
    allowedHosts: true,
  },
})
