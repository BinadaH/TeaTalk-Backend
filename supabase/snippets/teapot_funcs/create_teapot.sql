create or replace function create_teapot(
    teapot_name text, 
    teapot_description text,
    profile_usernames text[]
)
returns uuid 
language plpgsql
security definer 
set search_path = public
as $$
declare new_teapot_id UUID;
begin

-- Create Teapot
insert into public.teapot (name, description)
values (teapot_name, teapot_description)
returning id_teapot into new_teapot_id;

-- Insert users
insert into public.profile_teapot (id_profile, id_teapot)
select p.id_profile, new_teapot_id
from public.profile p
where p.username = any(profile_usernames) or p.id_user = auth.uid();


return new_teapot_id;
end;
$$;