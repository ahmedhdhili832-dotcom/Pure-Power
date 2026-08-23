(() => {
  'use strict';
  const BOOKINGS_KEY='purePowerBooking';
  const USERS_KEY='pp_users';
  const read=(key,fallback)=>{try{const v=localStorage.getItem(key);return v?JSON.parse(v):fallback}catch{return fallback}};
  const esc=s=>String(s??'').replace(/[&<>"']/g,m=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#039;'}[m]));
  const money=n=>`${Number(n||0).toLocaleString('fr-FR')} €`;
  const date=v=>v?new Date(`${v}T00:00:00`).toLocaleDateString('fr-FR'):'—';
  const users=read(USERS_KEY,[]);
  const current=read(BOOKINGS_KEY,null);
  const bookings=Array.isArray(read('purePowerBookings',null))?read('purePowerBookings',[]):(current?[current]:[]);
  const revenueMap={'Ménage courant — 20 €/h':20,'Ménage approfondi — 25 €/h':25,'Forfait Studio — dès 35 €':35,'Forfait T2 — dès 45 €':45,'Forfait T3 — dès 60 €':60};
  const revenue=bookings.reduce((s,b)=>s+(revenueMap[b.service]||0),0);
  const pending=bookings.filter(b=>!b.status||b.status==='En attente').length;
  const set=(id,v)=>{const e=document.getElementById(id);if(e)e.textContent=v};
  set('statClients',users.length);set('statBookings',bookings.length);set('statPending',pending);set('statRevenue',money(revenue));set('year',new Date().getFullYear());
  const body=document.getElementById('recentBookings');
  if(body&&bookings.length){body.innerHTML=bookings.slice(-6).reverse().map(b=>`<tr><td>${esc(b.name||`${b.firstName||''} ${b.lastName||''}`.trim()||'Client')}</td><td>${esc(b.service||'—')}</td><td>${esc(date(b.date))}</td><td><span class="badge">${esc(b.status||'En attente')}</span></td></tr>`).join('')}
  const logout=document.getElementById('logout');
  if(logout)logout.addEventListener('click',()=>{localStorage.removeItem('pp_admin_session');window.location.href='../index.html'});
})();