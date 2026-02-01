
//SignUp
const { data, error } = await supabase.auth.signUp({
  email: "esempio@email.it",
  password: "password-sicura-123",
  options: {
    data: {
      username: "mario_rossi",
    },
  },
});


//Login
const { data, error } = await supabase.auth.signInWithPassword({
  email: 'esempio@email.it',
  password: 'password-sicura-123'
})



VITE_SUPABASE_URL=https://tuo-id.supabase.co
VITE_SUPABASE_ANON_KEY=la-tua-chiave-anonima

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY

export const supabase = createClient(supabaseUrl, supabaseAnonKey)