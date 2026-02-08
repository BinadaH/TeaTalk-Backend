set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.handle_user_leave_teapot()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$begin

if not exists (select id_teapot from public.profile_teapot where public.profile_teapot.id_teapot = old.id_teapot) then
delete from public.teapot where public.teapot.id_teapot = old.id_teapot;
end if;

return old;
end;$function$
;

CREATE TRIGGER trigger_handle_user_leave_teapot AFTER DELETE ON public.profile_teapot FOR EACH ROW EXECUTE FUNCTION public.handle_user_leave_teapot();


