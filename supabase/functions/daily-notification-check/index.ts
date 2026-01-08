import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.0.0'
import { format, zonedTimeToUtc } from 'https://esm.sh/date-fns-tz@2.0.0'
import { differenceInDays } from 'https://esm.sh/date-fns@2.29.3'

const JST_TIMEZONE = 'Asia/Tokyo'

// Helper to treat a yyyy-mm-dd date string as a date in JST
function dateStringToJstDate(dateString: string): Date {
  // Append a time part to make it a full ISO-like string, then specify JST
  return zonedTimeToUtc(`${dateString}T00:00:00`, JST_TIMEZONE);
}

serve(async (req) => {
  try {
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    const now = new Date()
    const todayInJST = zonedTimeToUtc(format(now, 'yyyy-MM-dd', { timeZone: JST_TIMEZONE }), JST_TIMEZONE)

    const { data: benefits, error } = await supabase
      .from('users_yuutai')
      .select('*')
      .eq('status', 'active')
      .eq('alert_enabled', true)

    if (error) {
      throw error
    }

    for (const benefit of benefits) {
        if (!benefit.expiry_date) continue

        const expiryDateJST = dateStringToJstDate(benefit.expiry_date);
        const daysUntilExpiry = differenceInDays(expiryDateJST, todayInJST);

        if (benefit.notify_days_before.includes(daysUntilExpiry)) {
            const { data: tokens, error: tokenError } = await supabase
                .from('fcm_tokens')
                .select('token')
                .eq('user_id', benefit.user_id)

            if (tokenError) {
                console.error(`Error fetching FCM tokens for user ${benefit.user_id}:`, tokenError)
                continue
            }

            const fcmServerKey = Deno.env.get('FCM_SERVER_KEY')
            if (!fcmServerKey) {
                console.error('FCM_SERVER_KEY is not set.')
                continue
            }
            
            for (const { token } of tokens) {
                const message = {
                    to: token,
                    notification: {
                        title: '優待の有効期限が近づいています',
                        body: `${benefit.company_name}の優待の有効期限が${daysUntilExpiry}日後です。`,
                    },
                }

                await fetch('https://fcm.googleapis.com/fcm/send', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `key=${fcmServerKey}`,
                    },
                    body: JSON.stringify(message),
                })
            }
        }
    }

    return new Response(JSON.stringify({ message: 'OK' }), {
      headers: { 'Content-Type': 'application/json' },
    })
  } catch (err) {
    return new Response(String(err?.message ?? err), { status: 500 })
  }
})
