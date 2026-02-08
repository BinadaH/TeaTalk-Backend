drop policy "Only users inside a teapot must be able to view them " on "public"."teapot";


  create policy "Only users inside a teapot and who is invited must be able to v"
  on "public"."teapot"
  as permissive
  for select
  to authenticated
using (((id_teapot IN ( SELECT public.get_my_teapot_ids() AS get_my_teapot_ids)) OR (id_teapot IN ( SELECT request.id_teapot
   FROM public.request
  WHERE (request.id_receiver = ( SELECT public.get_profile_id() AS get_profile_id))))));



