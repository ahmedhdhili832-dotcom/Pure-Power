import { createClient } from '@supabase/supabase-js';

const json=(body,status=200)=>new Response(JSON.stringify(body),{status,headers:{'content-type':'application/json'}});
const db=()=>createClient(process.env.SUPABASE_URL,process.env.SUPABASE_SERVICE_ROLE_KEY,{auth:{autoRefreshToken:false,persistSession:false}});
const authorized=req=>{
  const key=process.env.ADMIN_KEY;
  if(!key) return false;
  const auth=req.headers.get('authorization')||'';
  return auth===`Bearer ${key}`;
};

export default async req=>{
  if(req.method!=='GET') return json({error:'Method not allowed'},405);
  if(!authorized(req)) return json({error:'Accès administrateur requis.'},401);
  try{
    const {data,error}=await db().from('bookings').select('*').order('created_at',{ascending:false}).limit(200);
    if(error) throw error;
    return json({bookings:data||[]});
  }catch(e){
    console.error(e);
    return json({error:'Impossible de charger les demandes.'},500);
  }
};
