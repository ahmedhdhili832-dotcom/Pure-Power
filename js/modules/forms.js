/* PURE & POWER — Form safety and UX */
export function initForms() {
  document.querySelectorAll('form').forEach(form => {
    form.addEventListener('submit', event => {
      if (form.checkValidity()) return;
      event.preventDefault();
      form.reportValidity();
    });

    form.querySelectorAll('input,select,textarea').forEach(field => {
      field.addEventListener('blur', () => {
        field.classList.toggle('is-invalid', !field.checkValidity());
      });
      field.addEventListener('input', () => {
        if (field.checkValidity()) field.classList.remove('is-invalid');
      });
    });
  });
}
