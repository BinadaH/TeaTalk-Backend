drop policy "Anyone can invite into a teapot they are already in" on "public"."request";


  create policy "Anyone can invite into a teapot they are already in"
  on "public"."request"
  as permissive
  for insert
  to authenticated
with check (((id_teapot IN ( SELECT teapot.id_teapot
   FROM public.teapot)) AND (id_sender <> id_receiver)));



