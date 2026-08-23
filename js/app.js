/* PURE & POWER — Main JavaScript */

const menuToggle = document.getElementById('menuToggle');
const mainNav = document.getElementById('mainNav');
const header = document.getElementById('header');

/* Mobile menu */
if (menuToggle && mainNav) {
  menuToggle.addEventListener('click', () => {
    const open = mainNav.classList.toggle('active');
    menuToggle.setAttribute('aria-expanded', String(open));
    menuToggle.textContent = open ? '✕' : '☰';
  });
  mainNav.querySelectorAll('a').forEach(a => a.addEventListener('click', () => {
    mainNav.classList.remove('active');
    menuToggle.setAttribute('aria-expanded', 'false');
    menuToggle.textContent = '☰';
  }));
}

/* Header scroll */
function updateHeader(){
  if (!header) return;
  header.classList.toggle('scrolled', window.scrollY > 30);
}
window.addEventListener('scroll', updateHeader, {passive:true});
updateHeader();

/* Homepage section links become real pages */
const pageMap = {
  '#services': 'services.html',
  '#tarifs': 'tarifs.html',
  '#experience': 'experience.html',
  '#contact': 'contact.html'
};

document.querySelectorAll('.main-nav a[href^="#"]').forEach(link => {
  link.addEventListener('click', event => {
    const href = link.getAttribute('href');
    if (pageMap[href]) {
      event.preventDefault();
      window.location.href = pageMap[href];
    }
  });
});

/* Animate cards and hero */
const animated = document.querySelectorAll('.service-card,.price-card,.experience-box,.contact-card,.package,.hero-content,.hero-visual');
if ('IntersectionObserver' in window) {
  const observer = new IntersectionObserver(entries => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('is-visible');
        observer.unobserve(entry.target);
      }
    });
  }, {threshold:.12, rootMargin:'0px 0px -40px 0px'});
  animated.forEach(el => {
    el.classList.add('animate-on-scroll');
    observer.observe(el);
  });
}

/* Telephone links */
document.querySelectorAll('a[href^="tel:"]').forEach(link => {
  link.addEventListener('click', () => console.log('Appel :', link.href));
});

/* Hero image fallback */
const heroImage = document.querySelector('.hero-image img');
const placeholder = document.querySelector('.image-placeholder');
if (heroImage && placeholder) {
  const check = () => {
    placeholder.style.display = heroImage.complete && heroImage.naturalWidth ? 'none' : 'flex';
  };
  heroImage.addEventListener('load', check);
  heroImage.addEventListener('error', () => {
    heroImage.style.display = 'none';
    placeholder.style.display = 'flex';
  });
  check();
}

/* Current year */
document.querySelectorAll('[data-current-year]').forEach(el => el.textContent = new Date().getFullYear());

document.body.classList.add('page-loaded');
console.log('PURE & POWER — Navigation multi-pages activée.');