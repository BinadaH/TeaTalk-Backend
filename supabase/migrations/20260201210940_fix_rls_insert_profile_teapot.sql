drop policy "Only users in a teapot can see connections" on "public"."profile_teapot";

drop policy "Only users inside a teapot can insert new users into it" on "public"."profile_teapot";

drop function if exists "public"."get_my_groups_ids"();

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.get_my_teapot_ids()
 RETURNS SETOF uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$BEGIN
  RETURN QUERY
  SELECT id_teapot 
  FROM profile_teapot 
  WHERE id_profile = (select id_profile from profile where id_user = auth.uid());
END;$function$
;


  create policy "Only users in a teapot can see connections"
  on "public"."profile_teapot"
  as permissive
  for select
  to authenticated
using ((id_teapot IN ( SELECT public.get_my_teapot_ids() AS get_my_groups_ids)));



  create policy "Only users inside a teapot can insert new users into it"
  on "public"."profile_teapot"
  as permissive
  for insert
  to authenticated
with check ((id_teapot IN ( SELECT public.get_my_teapot_ids() AS get_my_teapot_ids)));



