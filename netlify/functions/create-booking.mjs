import { createClient } from '@supabase/supabase-js';

const json = (body, status = 200) => new Response(JSON.stringify(body), {
  status,
  headers: { 'content-type': 'application/json; charset=utf-8' }
});

export default async (req) => {
  if (req.method !== 'POST') return json({ error: 'Method not allowed' }, 405);
  try {
    const body = await req.json();
    const required = ['firstName','lastName','email','phone','service','quantity','unitPrice','totalPrice','date','time','address'];
    const missing = required.filter(k => body[k] === undefined || body[k] === '');
    if (missing.length) return json({ error: `Champs manquants: ${missing.join(', ')}` }, 400);

    const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_SERVICE_ROLE_KEY, {
      auth: { autoRefreshToken: false, persistSession: false }
    });

    const { data, error } = await supabase.from('bookings').insert({
      client_first_name: String(body.firstName).trim(),
      client_last_name: String(body.lastName).trim(),
      email: String(body.email).trim().toLowerCase(),
      phone: String(body.phone).trim(),
      service: String(body.service),
      quantity: Number(body.quantity),
      unit_price: Number(body.unitPrice),
      total_price: Number(body.totalPrice),
      booking_date: body.date,
      booking_time: body.time,
      address: String(body.address).trim(),
      needs: String(body.needs || '').trim(),
      status: 'pending',
      contract_status: 'draft',
      payment_status: 'pending'
    }).select('id,contract_token,status,created_at').single();

    if (error) return json({ error: error.message }, 500);
    return json({ ok: true, booking: data }, 201);
  } catch (error) {
    return json({ error: 'Impossible de créer la demande.' }, 500);
  }
};
