create or replace function create_teapot(
    teapot_name text, teapot_description text,
    profile_usernames text[]
)
returns uuid as $$

declare new_teapot_id UUID;
begin

-- Create Teapot
insert into public.teapot (name, description)
values (teapot_name, teapot_description)
returning id_teapot into new_teapot_id;

insert into public.profile_teapot (id_profile, id_teapot)
select p.id_profile, new_teapot_id
from public.profile p
where p.username == any(profile_usernames);

return new_teapot_id;
end;
$$ language plpgsql;


create or replace function add_user_to_teapot(
    id_teapot UUID, new_user_username text
)
returns void as $$
begin

-- insert into public.profile_teapot (id_profile, id_teapot)
-- select p.id_user


end;
$$ language plpgsql