(()=>{
  const form=document.getElementById('bookingForm');
  if(!form)return;
  form.addEventListener('submit',e=>e.stopImmediatePropagation(),true);
})();
