drop policy "Only receiver can update request status" on "public"."request";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.add_users_to_teapot(id_teapot uuid, to_add_username text[])
 RETURNS void
 LANGUAGE plpgsql
AS $function$begin

--insert into public.profile_teapot (id_profile, id_teapot)
--select (p.id_profile, id_teapot)
--from public.profile p
--where p.username = any(to_add_username);

insert into public.request (id_receiver, id_sender, id_teapot)
select p.id_profile, (select get_profile_id()), id_teapot
from public.profile p
where p.username = any(to_add_username) and p.id_user != auth.uid();

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
values((select get_profile_id()), new_teapot_id);

perform add_users_to_teapot(new_teapot_id, profile_usernames);

return new_teapot_id;
end;$function$
;

CREATE OR REPLACE FUNCTION public.handle_receiver_request()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$begin
  -- If the status was changed to 'accepted'
  if new.status = 'accepted' then
    -- Insert into the profile_teapot table
    insert into profile_teapot (id_profile, id_teapot)
    values (new.id_receiver, new.id_teapot);
    
    -- Delete the request row now that it's a friendship
    delete from request where id_request = new.id_request;
  
  -- If the status was changed to 'declined'
  elsif new.status = 'declined' then
    -- Simply delete the row to clear the user's inbox
    delete from request where id_request = new.id_request;
  end if;

  return null; -- Since the row is deleted, we return null
end;$function$
;


  create policy "Only receiver can update request status"
  on "public"."request"
  as permissive
  for update
  to authenticated
using ((id_receiver = ( SELECT public.get_profile_id() AS get_profile_id)))
with check ((id_receiver = ( SELECT public.get_profile_id() AS get_profile_id)));



