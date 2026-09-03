/* PURE & POWER — Shared metadata helpers */
export function initSiteMeta() {
  document.querySelectorAll('[data-current-year]').forEach(el => {
    el.textContent = String(new Date().getFullYear());
  });

  document.body.classList.add('page-loaded');
}
