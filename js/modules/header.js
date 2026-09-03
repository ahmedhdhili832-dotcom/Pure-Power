/* PURE & POWER — Header behaviour */
export function initHeader() {
  const header = document.getElementById('header');
  if (!header) return;

  const update = () => header.classList.toggle('scrolled', window.scrollY > 30);
  window.addEventListener('scroll', update, { passive: true });
  update();
}
