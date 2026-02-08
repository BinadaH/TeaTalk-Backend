drop policy "Can select, insert, update, delete only your leaves" on "public"."leaf";

drop policy "Can only view sachet's of a teapot you are part of" on "public"."sachet";


  create policy "Can select, insert, update, delete only your leaves"
  on "public"."leaf"
  as permissive
  for all
  to authenticated
using ((id_profile = ( SELECT public.get_profile_id() AS get_profile_id)))
with check ((id_profile = ( SELECT public.get_profile_id() AS get_profile_id)));



  create policy "Can only view sachet's of a teapot you are part of"
  on "public"."sachet"
  as permissive
  for select
  to authenticated
using ((id_teapot IN ( SELECT public.get_my_teapot_ids() AS get_my_teapot_ids)));



