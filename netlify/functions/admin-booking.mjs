import { createClient } from '@supabase/supabase-js';
import PDFDocument from 'pdfkit';

const db=()=>createClient(process.env.SUPABASE_URL,process.env.SUPABASE_SERVICE_ROLE_KEY,{auth:{autoRefreshToken:false,persistSession:false}});
const json=(b,s=200)=>new Response(JSON.stringify(b),{status:s,headers:{'content-type':'application/json'}});
const authorized=req=>{
  const key=process.env.ADMIN_KEY;
  if(!key) return false;
  return (req.headers.get('authorization')||'')===`Bearer ${key}`;
};
const esc=v=>String(v??'').replace(/[&<>\"]/g,m=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[m]));

function makePdf(b){
  return new Promise((resolve,reject)=>{
    const doc=new PDFDocument({size:'A4',margin:50});
    const chunks=[];
    doc.on('data',c=>chunks.push(c));
    doc.on('end',()=>resolve(Buffer.concat(chunks).toString('base64')));
    doc.on('error',reject);
    doc.fontSize(24).font('Helvetica-Bold').text('PURE & POWER');
    doc.moveDown(0.3).fontSize(11).font('Helvetica').fillColor('#2F6B4F').text('CONTRAT DE PRESTATION — PROPOSITION');
    doc.moveDown(1).fillColor('#111827').fontSize(12).font('Helvetica-Bold').text('Informations client');
    doc.font('Helvetica').fontSize(11).text(`Nom : ${b.client_first_name||''} ${b.client_last_name||''}`);
    doc.text(`Email : ${b.email||''}`);
    doc.text(`Téléphone : ${b.phone||''}`);
    doc.text(`Adresse : ${b.address||''}`);
    doc.moveDown(0.8).font('Helvetica-Bold').text('Prestation');
    doc.font('Helvetica').text(`Service : ${b.service||''}`);
    doc.text(`Date souhaitée : ${b.booking_date||''}`);
    doc.text(`Horaire : ${b.booking_time||''}`);
    doc.text(`Quantité / durée : ${b.quantity||1}`);
    doc.moveDown(0.8).font('Helvetica-Bold').text('Montant proposé');
    doc.fontSize(18).fillColor('#2F6B4F').text(`${Number(b.total_price||0).toFixed(2)} €`);
    doc.fontSize(10).fillColor('#374151').font('Helvetica').text(`Tarif unitaire : ${Number(b.unit_price||0).toFixed(2)} €`);
    if(b.needs){doc.moveDown(0.8).fontSize(11).font('Helvetica-Bold').fillColor('#111827').text('Informations complémentaires');doc.font('Helvetica').text(b.needs);}
    doc.moveDown(2).fontSize(10).fillColor('#6B7280').text('Ce document constitue une proposition de contrat. La prestation devient définitive après confirmation du client depuis le lien sécurisé envoyé par email.');
    doc.moveDown(1).text(`Référence : ${b.id}`);
    doc.text(`Émis le : ${new Date().toLocaleDateString('fr-FR')}`);
    doc.end();
  });
}

export default async req=>{
  if(req.method!=='POST') return json({error:'Method not allowed'},405);
  if(!authorized(req)) return json({error:'Accès administrateur requis.'},401);
  try{
    const body=await req.json();
    if(!body.id || !['approve','reject'].includes(body.action)) return json({error:'Paramètres invalides.'},400);
    const supabase=db();
    const {data:booking,error:readError}=await supabase.from('bookings').select('*').eq('id',body.id).eq('status','pending').single();
    if(readError||!booking) return json({error:'Demande introuvable ou déjà traitée.'},409);

    if(body.action==='reject'){
      const {data,error}=await supabase.from('bookings').update({status:'rejected'}).eq('id',body.id).eq('status','pending').select('id,status').single();
      if(error) throw error;
      return json({ok:true,booking:data,emailSent:false});
    }

    const contractPdf=await makePdf(booking);
    const site=process.env.SITE_URL || 'https://pure-powe.netlify.app';
    const link=`${site}/contract-confirmation.html?token=${booking.contract_token}`;
    let emailSent=false;
    let emailError=null;

    if(process.env.RESEND_API_KEY && process.env.MAIL_FROM){
      const html=`<div style="font-family:Arial,sans-serif;max-width:620px;margin:auto;color:#172A3D"><div style="padding:24px;background:#F4F7F4;border-radius:18px"><h1 style="margin:0;color:#2F6B4F">Pure & Power</h1><p>Bonjour ${esc(booking.client_first_name)},</p><p>Votre demande de prestation a été validée par notre équipe.</p><p>Vous trouverez votre <strong>contrat PDF</strong> en pièce jointe.</p><p><strong>Montant proposé : ${Number(booking.total_price).toFixed(2)} €</strong></p><p><a href="${link}" style="display:inline-block;padding:14px 20px;background:#2F6B4F;color:#fff;text-decoration:none;border-radius:10px">Consulter et confirmer</a></p><p style="font-size:13px;color:#64748B">Vous pouvez accepter ou refuser la proposition depuis cette page sécurisée.</p></div></div>`;
      const r=await fetch('https://api.resend.com/emails',{method:'POST',headers:{Authorization:`Bearer ${process.env.RESEND_API_KEY}`,'Content-Type':'application/json'},body:JSON.stringify({from:process.env.MAIL_FROM,to:[booking.email],subject:'Votre contrat Pure & Power',html,attachments:[{filename:`contrat-pure-power-${booking.id}.pdf`,content:contractPdf,content_type:'application/pdf'}]})});
      const result=await r.json();
      emailSent=r.ok;
      if(!r.ok) emailError=result;
    }else emailError={message:'RESEND_API_KEY ou MAIL_FROM manquant'};

    const update={status:'approved',contract_status:'sent',contract_sent_at:new Date().toISOString()};
    const {data,error}=await supabase.from('bookings').update(update).eq('id',body.id).eq('status','pending').select('id,contract_token,email,status,contract_status,total_price,client_first_name,client_last_name,booking_date,booking_time').single();
    if(error) throw error;
    return json({ok:true,booking:data,emailSent,emailError,contractUrl:`${site}/contract-confirmation.html?token=${data.contract_token}`});
  }catch(e){console.error(e);return json({error:'Erreur serveur.'},500)}
};
