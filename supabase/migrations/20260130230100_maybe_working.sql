alter table "public"."leaf" alter column "id_profile" set default gen_random_uuid();

alter table "public"."leaf" enable row level security;

alter table "public"."leaf_sachet" enable row level security;

alter table "public"."profile" enable row level security;

alter table "public"."profile_teapot" enable row level security;

alter table "public"."sachet" enable row level security;

alter table "public"."teapot" enable row level security;

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.set_id_profile()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$begin
new.id_profile = (select public.profile.id_profile from public.profile where public.profile.id_user = auth.uid());
return new;
end;$function$
;

CREATE OR REPLACE FUNCTION public.create_teapot(teapot_name text, teapot_description text, profile_usernames text[])
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$declare new_teapot_id UUID;
begin

-- Create Teapot
insert into public.teapot (name, description)
values (teapot_name, teapot_description)
returning id_teapot into new_teapot_id;

-- Insert users
insert into public.profile_teapot (id_profile, id_teapot)
select public.profile.id_profile, new_teapot_id
from public.profile
where public.profile.username = any(profile_usernames) or public.profile.id_user = auth.uid();


return new_teapot_id;
end;$function$
;


  create policy "Can select, insert, update, delete only your leaves"
  on "public"."leaf"
  as permissive
  for all
  to authenticated
using ((id_profile = ( SELECT profile.id_profile
   FROM public.profile
  WHERE (profile.id_user = auth.uid()))))
with check ((id_profile = ( SELECT profile.id_profile
   FROM public.profile
  WHERE (profile.id_user = auth.uid()))));



  create policy "Can select, insert, update, delete leaf_sachet on if owned"
  on "public"."leaf_sachet"
  as permissive
  for all
  to authenticated
using (((id_leaf IN ( SELECT leaf.id_leaf
   FROM public.leaf)) AND (id_sachet IN ( SELECT sachet.id_sachet
   FROM public.sachet))))
with check (((id_leaf IN ( SELECT leaf.id_leaf
   FROM public.leaf)) AND (id_sachet IN ( SELECT sachet.id_sachet
   FROM public.sachet))));



  create policy "Any auth user can see a profile"
  on "public"."profile"
  as permissive
  for select
  to authenticated
using (true);



  create policy "Only owner can change their profile"
  on "public"."profile"
  as permissive
  for update
  to authenticated
using ((auth.uid() = id_user))
with check ((auth.uid() = id_user));



  create policy "Only users in a teapot can see connections"
  on "public"."profile_teapot"
  as permissive
  for select
  to authenticated
using ((id_profile = ( SELECT profile.id_profile
   FROM public.profile
  WHERE (profile.id_user = auth.uid()))));



  create policy "Only users inside a teapot can insert new users into it"
  on "public"."profile_teapot"
  as permissive
  for insert
  to authenticated
with check ((id_teapot IN ( SELECT profile_teapot_1.id_teapot
   FROM public.profile_teapot profile_teapot_1
  WHERE (profile_teapot_1.id_profile = ( SELECT profile.id_profile
           FROM public.profile
          WHERE (profile.id_user = auth.uid()))))));



  create policy "Can only add sachet's to teapots you are part of"
  on "public"."sachet"
  as permissive
  for insert
  to authenticated
with check ((id_teapot IN ( SELECT teapot.id_teapot
   FROM public.teapot)));



  create policy "Can only view sachet's of a teapot you are part of"
  on "public"."sachet"
  as permissive
  for select
  to authenticated
using ((id_teapot IN ( SELECT teapot.id_teapot
   FROM public.teapot)));



  create policy "Only users inside a teapot must be able to view them "
  on "public"."teapot"
  as permissive
  for select
  to authenticated
using ((id_teapot IN ( SELECT profile_teapot.id_teapot
   FROM public.profile_teapot
  WHERE (profile_teapot.id_profile = ( SELECT profile.id_profile
           FROM public.profile
          WHERE (profile.id_user = auth.uid()))))));


CREATE TRIGGER leaf_set_id_profile BEFORE INSERT ON public.leaf FOR EACH ROW EXECUTE FUNCTION public.set_id_profile();


