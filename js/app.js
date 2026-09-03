/* PURE & POWER — Application bootstrap
   Modules are intentionally separated so each feature can evolve independently. */
(() => {
  'use strict';

  const modules = [
    './modules/navigation.js',
    './modules/header.js',
    './modules/reveal.js',
    './modules/media.js',
    './modules/forms.js',
    './modules/site-meta.js'
  ];

  Promise.all(modules.map(path => import(path)))
    .then(([navigation, header, reveal, media, forms, meta]) => {
      navigation.initNavigation();
      header.initHeader();
      reveal.initReveal();
      media.initMediaFallbacks();
      forms.initForms();
      meta.initSiteMeta();
    })
    .catch(error => {
      console.error('PURE & POWER — module initialisation failed:', error);
      document.body.classList.add('page-loaded');
    });
})();
