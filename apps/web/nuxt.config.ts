// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  devtools: { enabled: true },
  css: [
    'primevue/resources/themes/md-dark-indigo/theme.css',
    "primevue/resources/primevue.min.css",
  ],
  modules: ['@nuxtjs/tailwindcss', '@pinia/nuxt', 'nuxt-icon'],
  build: {
    transpile: ["primevue"],
  },
})
