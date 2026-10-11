<template>
  <div class="app-shell">
    <SiteHeader />
    <div class="app-content">
      <ExamSidebar />
      <div class="main-column">
        <main><slot /></main>
        <SiteFooter />
      </div>
    </div>
  </div>
</template>

<style scoped>
.app-shell { min-height: 100vh; display: flex; flex-direction: column; }
.app-content { flex: 1; display: grid; grid-template-columns: 260px minmax(0, 1fr); align-items: start; }
.main-column { min-width: 0; min-height: calc(100vh - var(--header-height)); display: flex; flex-direction: column; }
main { flex: 1; }

@media (max-width: 760px) {
  .app-content { grid-template-columns: 1fr; }
  .main-column { min-height: auto; }
}
</style>
