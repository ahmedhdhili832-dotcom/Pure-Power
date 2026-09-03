exports.handler = async (event) => {
  if (event.httpMethod !== 'POST') return { statusCode: 405, body: 'Method Not Allowed' };
  try {
    const { booking } = JSON.parse(event.body || '{}');
    if (!booking?.email) return { statusCode: 400, body: JSON.stringify({ error: 'Email client manquant' }) };
    const apiKey = process.env.SENDGRID_API_KEY;
    const from = process.env.PP_FROM_EMAIL;
    if (!apiKey || !from) return { statusCode: 503, body: JSON.stringify({ error: 'Email provider non configuré' }) };
    const amount = Number(booking.price || 0).toLocaleString('fr-FR');
    const html = `<div style="font-family:Arial,sans-serif;max-width:680px;margin:auto;padding:32px;color:#102A43"><h1 style="color:#2F6B4F">Pure &amp; Power</h1><h2>Contrat de prestation</h2><p>Bonjour <strong>${escapeHtml(booking.name || 'Client')}</strong>,</p><p>Votre demande a été acceptée. Voici le récapitulatif de votre prestation :</p><table style="width:100%;border-collapse:collapse"><tr><td><b>Prestation</b></td><td>${escapeHtml(booking.service || '—')}</td></tr><tr><td><b>Date</b></td><td>${escapeHtml(booking.date || '—')}</td></tr><tr><td><b>Horaire</b></td><td>${escapeHtml(booking.time || '—')}</td></tr><tr><td><b>Adresse</b></td><td>${escapeHtml(booking.address || '—')}</td></tr><tr><td><b>Montant</b></td><td><strong>${amount} €</strong></td></tr></table><p style="margin-top:28px">Merci de confirmer ou refuser ce contrat depuis votre espace client.</p><p><a href="${process.env.URL || ''}/confirmation.html?id=${encodeURIComponent(booking.id || '')}" style="display:inline-block;background:#2F6B4F;color:white;padding:13px 20px;border-radius:10px;text-decoration:none">Consulter et confirmer</a></p><hr><small>Pure &amp; Power — Contrat généré automatiquement</small></div>`;
    const response = await fetch('https://api.sendgrid.com/v3/mail/send', { method:'POST', headers:{Authorization:`Bearer ${apiKey}`,'Content-Type':'application/json'}, body:JSON.stringify({personalizations:[{to:[{email:booking.email,name:booking.name||'Client'}]}],from:{email:from,name:'Pure & Power'},subject:'Contrat de prestation — Pure & Power',content:[{type:'text/html',value:html}]})});
    if (!response.ok) return { statusCode: 502, body: JSON.stringify({ error: 'Envoi email impossible' }) };
    return { statusCode: 200, body: JSON.stringify({ ok:true }) };
  } catch (error) { return { statusCode:500, body:JSON.stringify({error:'Erreur serveur'}) }; }
};
function escapeHtml(value=''){return String(value).replace(/[&<>"']/g,m=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#039;'}[m]));}
