/* PURE & POWER — Navigation module */
export function initNavigation() {
  const menuToggle = document.getElementById('menuToggle');
  const mainNav = document.getElementById('mainNav');

  if (!menuToggle || !mainNav) return;

  const setState = open => {
    mainNav.classList.toggle('active', open);
    menuToggle.setAttribute('aria-expanded', String(open));
    menuToggle.setAttribute('aria-label', open ? 'Fermer le menu' : 'Ouvrir le menu');
    menuToggle.textContent = open ? '✕' : '☰';
    document.body.classList.toggle('menu-open', open);
  };

  menuToggle.addEventListener('click', () => setState(!mainNav.classList.contains('active')));
  mainNav.querySelectorAll('a').forEach(link => link.addEventListener('click', () => setState(false)));

  const pageMap = {
    '#services': 'services.html',
    '#tarifs': 'tarifs.html',
    '#experience': 'experience.html',
    '#contact': 'contact.html'
  };

  document.querySelectorAll('a[href^="#"]').forEach(link => {
    const target = pageMap[link.getAttribute('href')];
    if (!target) return;
    link.addEventListener('click', event => {
      event.preventDefault();
      window.location.assign(target);
    });
  });
}
