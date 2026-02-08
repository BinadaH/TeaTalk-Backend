alter table "public"."teapot" add column "id_admin" uuid not null;

alter table "public"."teapot" add constraint "teapot_id_admin_fkey" FOREIGN KEY (id_admin) REFERENCES public.profile(id_profile) not valid;

alter table "public"."teapot" validate constraint "teapot_id_admin_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.create_teapot(teapot_name text, teapot_description text, profile_usernames text[])
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$declare new_teapot_id UUID;
begin

-- Create Teapot
insert into public.teapot (name, description, id_admin)
values (teapot_name, teapot_description, (select get_profile_id()))
returning id_teapot into new_teapot_id;

-- Insert users
insert into public.profile_teapot (id_profile, id_teapot)
values((select get_profile_id()), new_teapot_id);

perform add_users_to_teapot(new_teapot_id, profile_usernames);

return new_teapot_id;
end;$function$
;


  create policy "Only you can decide to exit the group "
  on "public"."profile_teapot"
  as permissive
  for delete
  to public
using ((id_profile = ( SELECT public.get_profile_id() AS get_profile_id)));



