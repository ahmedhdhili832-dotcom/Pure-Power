import { createClient } from '@supabase/supabase-js';
const db=()=>createClient(process.env.SUPABASE_URL,process.env.SUPABASE_SERVICE_ROLE_KEY,{auth:{autoRefreshToken:false,persistSession:false}});
const json=(b,s=200)=>new Response(JSON.stringify(b),{status:s,headers:{'content-type':'application/json'}});

export default async(req)=>{
  if(req.method!=='POST') return json({error:'Method not allowed'},405);
  try{
    const body=await req.json();
    if(!body.id || !['approve','reject'].includes(body.action)) return json({error:'Paramètres invalides.'},400);
    const supabase=db();
    const update=body.action==='approve'
      ? {status:'approved',contract_status:'sent',contract_sent_at:new Date().toISOString()}
      : {status:'rejected'};
    const {data,error}=await supabase.from('bookings').update(update).eq('id',body.id).eq('status','pending').select('id,contract_token,email,status,contract_status,total_price').single();
    if(error||!data) return json({error:'Demande introuvable ou déjà traitée.'},409);

    let emailResult=null;
    if(body.action==='approve' && process.env.RESEND_API_KEY){
      const link=`${process.env.SITE_URL || ''}/contract-confirmation.html?token=${data.contract_token}`;
      const html=`<div style="font-family:Arial,sans-serif;max-width:620px;margin:auto"><h1>Pure & Power</h1><p>Votre demande a été validée.</p><p>Montant proposé : <strong>${Number(data.total_price).toFixed(2)} €</strong></p><p>Consultez le contrat et confirmez votre demande :</p><p><a href="${link}" style="display:inline-block;padding:14px 20px;background:#2F6B4F;color:#fff;text-decoration:none;border-radius:10px">Consulter et confirmer</a></p></div>`;
      const r=await fetch('https://api.resend.com/emails',{method:'POST',headers:{Authorization:`Bearer ${process.env.RESEND_API_KEY}`,'Content-Type':'application/json'},body:JSON.stringify({from:process.env.MAIL_FROM,to:[data.email],subject:'Votre contrat Pure & Power',html})});
      emailResult=await r.json();
      if(!r.ok) return json({ok:true,booking:data,emailSent:false,emailError:emailResult},200);
    }
    return json({ok:true,booking:data,emailSent:!!emailResult});
  }catch(e){return json({error:'Erreur serveur.'},500)}
};
