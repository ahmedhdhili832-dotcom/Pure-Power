/* PURE & POWER — Media resilience */
export function initMediaFallbacks() {
  const heroImage = document.querySelector('.hero-image img');
  const placeholder = document.querySelector('.image-placeholder');
  if (!heroImage || !placeholder) return;

  const refresh = () => {
    const loaded = heroImage.complete && heroImage.naturalWidth > 0;
    heroImage.style.display = loaded ? 'block' : 'none';
    placeholder.style.display = loaded ? 'none' : 'flex';
  };

  heroImage.addEventListener('load', refresh);
  heroImage.addEventListener('error', refresh);
  refresh();
}
