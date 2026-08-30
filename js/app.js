/* PURE & POWER — Production-ready site JavaScript */

(() => {
  'use strict';

  const menuToggle = document.getElementById('menuToggle');
  const mainNav = document.getElementById('mainNav');
  const header = document.getElementById('header');

  // Mobile navigation
  if (menuToggle && mainNav) {
    menuToggle.addEventListener('click', () => {
      const open = mainNav.classList.toggle('active');
      menuToggle.setAttribute('aria-expanded', String(open));
      menuToggle.setAttribute('aria-label', open ? 'Fermer le menu' : 'Ouvrir le menu');
      menuToggle.textContent = open ? '✕' : '☰';
      document.body.classList.toggle('menu-open', open);
    });

    mainNav.querySelectorAll('a').forEach(link => {
      link.addEventListener('click', () => {
        mainNav.classList.remove('active');
        menuToggle.setAttribute('aria-expanded', 'false');
        menuToggle.setAttribute('aria-label', 'Ouvrir le menu');
        menuToggle.textContent = '☰';
        document.body.classList.remove('menu-open');
      });
    });
  }

  // Header elevation on scroll
  const updateHeader = () => {
    if (header) header.classList.toggle('scrolled', window.scrollY > 30);
  };
  window.addEventListener('scroll', updateHeader, { passive: true });
  updateHeader();

  // Convert supported homepage section links into real pages.
  const pageMap = {
    '#services': 'services.html',
    '#tarifs': 'tarifs.html',
    '#experience': 'experience.html',
    '#contact': 'contact.html'
  };

  document.querySelectorAll('a[href^="#"]').forEach(link => {
    link.addEventListener('click', event => {
      const target = pageMap[link.getAttribute('href')];
      if (target) {
        event.preventDefault();
        window.location.assign(target);
      }
    });
  });

  // Scroll reveal animations.
  const animated = document.querySelectorAll(
    '.service-card,.price-card,.experience-box,.contact-card,.package,.hero-content,.hero-visual'
  );

  if ('IntersectionObserver' in window) {
    const observer = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add('is-visible');
          observer.unobserve(entry.target);
        }
      });
    }, { threshold: 0.12, rootMargin: '0px 0px -40px 0px' });

    animated.forEach(el => {
      el.classList.add('animate-on-scroll');
      observer.observe(el);
    });
  } else {
    animated.forEach(el => el.classList.add('is-visible'));
  }

  // Hero image fallback.
  const heroImage = document.querySelector('.hero-image img');
  const placeholder = document.querySelector('.image-placeholder');
  if (heroImage && placeholder) {
    const refreshHeroImage = () => {
      const loaded = heroImage.complete && heroImage.naturalWidth > 0;
      heroImage.style.display = loaded ? 'block' : 'none';
      placeholder.style.display = loaded ? 'none' : 'flex';
    };
    heroImage.addEventListener('load', refreshHeroImage);
    heroImage.addEventListener('error', refreshHeroImage);
    refreshHeroImage();
  }

  // Native browser form validation with a guard against invalid submit.
  document.querySelectorAll('form').forEach(form => {
    form.addEventListener('submit', event => {
      if (!form.checkValidity()) {
        event.preventDefault();
        form.reportValidity();
      }
    });
  });

  // Current year placeholders.
  document.querySelectorAll('[data-current-year]').forEach(el => {
    el.textContent = String(new Date().getFullYear());
  });

  document.body.classList.add('page-loaded');
  console.log('PURE & POWER — site prêt.');
})();