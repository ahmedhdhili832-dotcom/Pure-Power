/* PURE & POWER — Scroll and visual reveal module */
export function initReveal() {
  const animated = document.querySelectorAll(
    '.service-card,.price-card,.experience-box,.contact-card,.package,.hero-content,.hero-visual'
  );

  if (!animated.length) return;

  if (!('IntersectionObserver' in window)) {
    animated.forEach(el => el.classList.add('is-visible'));
    return;
  }

  const observer = new IntersectionObserver(entries => {
    entries.forEach(entry => {
      if (!entry.isIntersecting) return;
      entry.target.classList.add('is-visible');
      observer.unobserve(entry.target);
    });
  }, { threshold: 0.12, rootMargin: '0px 0px -40px 0px' });

  animated.forEach(el => {
    el.classList.add('animate-on-scroll');
    observer.observe(el);
  });
}
