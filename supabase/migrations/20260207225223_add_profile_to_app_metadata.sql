set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$declare
generated_id uuid;
BEGIN
  INSERT INTO public.profile (id_user, username)
  VALUES (
    new.id, 
    new.raw_user_meta_data->>'username'
  )
  returning id_profile into generated_id;

UPDATE auth.users
  SET raw_app_meta_data = jsonb_set(
    COALESCE(raw_app_meta_data, '{}')::jsonb,
    '{id_profile}',
    to_jsonb(generated_id)
  )
  WHERE id = new.id;

  RETURN new;
END;$function$
;


