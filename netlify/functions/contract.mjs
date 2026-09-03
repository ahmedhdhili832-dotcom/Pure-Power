import { createClient } from '@supabase/supabase-js';

const db = () => createClient(process.env.SUPABASE_URL, process.env.SUPABASE_SERVICE_ROLE_KEY, { auth: { autoRefreshToken: false, persistSession: false } });
const json = (body, status = 200) => new Response(JSON.stringify(body), { status, headers: { 'content-type': 'application/json; charset=utf-8' } });

export default async (req) => {
  try {
    const url = new URL(req.url);
    const token = url.searchParams.get('token');
    if (!token) return json({ error: 'Token manquant.' }, 400);
    const supabase = db();

    if (req.method === 'GET') {
      const { data, error } = await supabase.from('bookings').select('id,client_first_name,client_last_name,email,phone,service,quantity,unit_price,total_price,booking_date,booking_time,address,needs,status,contract_status,payment_status,contract_token,created_at').eq('contract_token', token).single();
      if (error || !data) return json({ error: 'Contrat introuvable.' }, 404);
      return json({ ok: true, booking: data });
    }

    if (req.method !== 'POST') return json({ error: 'Method not allowed' }, 405);
    const body = await req.json();
    if (body.decision === 'confirm') {
      const { data, error } = await supabase.from('bookings').update({ status: 'client_confirmed', contract_status: 'client_confirmed', client_decision_at: new Date().toISOString() }).eq('contract_token', token).eq('status', 'approved').select('id,status,contract_status,payment_status').single();
      if (error || !data) return json({ error: 'Ce contrat ne peut pas être confirmé dans son état actuel.' }, 409);
      return json({ ok: true, booking: data });
    }
    if (body.decision === 'refuse') {
      const { data, error } = await supabase.from('bookings').update({ status: 'client_refused', contract_status: 'client_refused', client_decision_at: new Date().toISOString() }).eq('contract_token', token).eq('status', 'approved').select('id,status,contract_status').single();
      if (error || !data) return json({ error: 'Ce contrat ne peut pas être refusé dans son état actuel.' }, 409);
      return json({ ok: true, booking: data });
    }
    return json({ error: 'Décision invalide.' }, 400);
  } catch (error) {
    return json({ error: 'Erreur serveur.' }, 500);
  }
};
