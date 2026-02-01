alter table "public"."profile" drop constraint "profile_id_user_fkey";

CREATE OR REPLACE FUNCTION public.get_profile_id()
 RETURNS uuid
 LANGUAGE plpgsql
AS $function$begin
return (select public.profile.id_profile from public.profile where public.profile.id_user = auth.uid());
end;$function$
;

  create table "public"."request" (
    "id_request" uuid not null default gen_random_uuid(),
    "id_sender" uuid not null default get_profile_id(),
    "id_teapot" uuid not null,
    "id_receiver" uuid not null,
    "status" text default 'pending'::text,
    "created_at" timestamp with time zone default now()
      );


alter table "public"."request" enable row level security;

CREATE UNIQUE INDEX profile_username_key ON public.profile USING btree (username);

CREATE UNIQUE INDEX requests_id_sender_id_receiver_id_teapot_key ON public.request USING btree (id_sender, id_receiver, id_teapot);

CREATE UNIQUE INDEX requests_pkey ON public.request USING btree (id_request);

alter table "public"."request" add constraint "requests_pkey" PRIMARY KEY using index "requests_pkey";

alter table "public"."profile" add constraint "profile_username_key" UNIQUE using index "profile_username_key";

alter table "public"."request" add constraint "request_id_receiver_fkey" FOREIGN KEY (id_receiver) REFERENCES public.profile(id_profile) ON DELETE CASCADE not valid;

alter table "public"."request" validate constraint "request_id_receiver_fkey";

alter table "public"."request" add constraint "request_id_sender_fkey" FOREIGN KEY (id_sender) REFERENCES public.profile(id_profile) ON DELETE CASCADE not valid;

alter table "public"."request" validate constraint "request_id_sender_fkey";

alter table "public"."request" add constraint "request_id_teapot_fkey" FOREIGN KEY (id_teapot) REFERENCES public.teapot(id_teapot) ON DELETE CASCADE not valid;

alter table "public"."request" validate constraint "request_id_teapot_fkey";

alter table "public"."request" add constraint "requests_id_sender_id_receiver_id_teapot_key" UNIQUE using index "requests_id_sender_id_receiver_id_teapot_key";

alter table "public"."request" add constraint "requests_status_check" CHECK ((status = ANY (ARRAY['pending'::text, 'accepted'::text, 'declined'::text]))) not valid;

alter table "public"."request" validate constraint "requests_status_check";

alter table "public"."request" add constraint "sender_not_receiver" CHECK ((id_sender <> id_receiver)) not valid;

alter table "public"."request" validate constraint "sender_not_receiver";

alter table "public"."profile" add constraint "profile_id_user_fkey" FOREIGN KEY (id_user) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."profile" validate constraint "profile_id_user_fkey";

set check_function_bodies = off;



CREATE OR REPLACE FUNCTION public.handle_receiver_request()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$begin
  -- If the status was changed to 'accepted'
  if new.status = 'accepted' then
    -- Insert into the profile_teapot table
    insert into profile_teapot (id_profile, id_teapot)
    values (new.id_receiver, new.id_teapot);
    
    -- Delete the request row now that it's a friendship
    delete from requests where id_request = new.id_request;
  
  -- If the status was changed to 'declined'
  elsif new.status = 'declined' then
    -- Simply delete the row to clear the user's inbox
    delete from requests where id_request = new.id_request;
  end if;

  return null; -- Since the row is deleted, we return null
end;$function$
;

grant delete on table "public"."request" to "anon";

grant insert on table "public"."request" to "anon";

grant references on table "public"."request" to "anon";

grant select on table "public"."request" to "anon";

grant trigger on table "public"."request" to "anon";

grant truncate on table "public"."request" to "anon";

grant update on table "public"."request" to "anon";

grant delete on table "public"."request" to "authenticated";

grant insert on table "public"."request" to "authenticated";

grant references on table "public"."request" to "authenticated";

grant select on table "public"."request" to "authenticated";

grant trigger on table "public"."request" to "authenticated";

grant truncate on table "public"."request" to "authenticated";

grant update on table "public"."request" to "authenticated";

grant delete on table "public"."request" to "postgres";

grant insert on table "public"."request" to "postgres";

grant references on table "public"."request" to "postgres";

grant select on table "public"."request" to "postgres";

grant trigger on table "public"."request" to "postgres";

grant truncate on table "public"."request" to "postgres";

grant update on table "public"."request" to "postgres";

grant delete on table "public"."request" to "service_role";

grant insert on table "public"."request" to "service_role";

grant references on table "public"."request" to "service_role";

grant select on table "public"."request" to "service_role";

grant trigger on table "public"."request" to "service_role";

grant truncate on table "public"."request" to "service_role";

grant update on table "public"."request" to "service_role";


  create policy "Anyone can invite into a teapot they are already in"
  on "public"."request"
  as permissive
  for insert
  to authenticated
with check ((id_teapot IN ( SELECT teapot.id_teapot
   FROM public.teapot)));



  create policy "Both receiver and sender can delete a request"
  on "public"."request"
  as permissive
  for delete
  to authenticated
using (((id_sender = public.get_profile_id()) OR (id_receiver = public.get_profile_id())));



  create policy "Only receiver can update request status"
  on "public"."request"
  as permissive
  for update
  to authenticated
using ((id_receiver = public.get_profile_id()))
with check ((id_receiver = public.get_profile_id()));



  create policy "You can only see your requests"
  on "public"."request"
  as permissive
  for select
  to authenticated
using (((id_sender = public.get_profile_id()) OR (id_receiver = public.get_profile_id())));


CREATE TRIGGER trigger_handle_receiver_request AFTER UPDATE ON public.request FOR EACH ROW EXECUTE FUNCTION public.handle_receiver_request();


