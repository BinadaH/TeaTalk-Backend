set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.add_users_to_teapot(id_teapot uuid, to_add_username text[])
 RETURNS void
 LANGUAGE plpgsql
 SET search_path TO 'public'
AS $function$begin

--insert into public.profile_teapot (id_profile, id_teapot)
--select (p.id_profile, id_teapot)
--from public.profile p
--where p.username = any(to_add_username);

insert into public.request (id_receiver, id_sender, id_teapot)
select p.id_profile, (select get_profile_id()), add_users_to_teapot.id_teapot
from public.profile p
where p.username = any(to_add_username) 
      and p.id_user != auth.uid()
      and not exists (
          select 1 from public.profile_teapot where public.profile_teapot.id_teapot = add_users_to_teapot.id_teapot and public.profile_teapot.id_profile = p.id_profile
        )
      and not exists (
          select 1 from public.request r where r.id_teapot = add_users_to_teapot.id_teapot and r.id_receiver = p.id_profile
      )

;

end;$function$
;


