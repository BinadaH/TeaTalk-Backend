drop policy "Can select, insert, update, delete only your leaves" on "public"."leaf";

drop policy "Can select, insert, update, delete leaf_sachet on if owned" on "public"."leaf_sachet";


  create policy "Only owner and users in a teapot..."
  on "public"."leaf"
  as permissive
  for select
  to authenticated
using (((id_profile = ( SELECT public.get_profile_id() AS get_profile_id)) OR (id_leaf IN ( SELECT s.id_leaf
   FROM public.leaf_sachet s))));



  create policy "Owner can modify leaf"
  on "public"."leaf"
  as permissive
  for all
  to public
using ((id_profile = ( SELECT public.get_profile_id() AS get_profile_id)))
with check ((id_profile = ( SELECT public.get_profile_id() AS get_profile_id)));



  create policy "Can select, insert, update, delete leaf_sachet on if owned"
  on "public"."leaf_sachet"
  as permissive
  for all
  to authenticated
using ((id_sachet IN ( SELECT sachet.id_sachet
   FROM public.sachet)))
with check ((id_sachet IN ( SELECT sachet.id_sachet
   FROM public.sachet)));



