
  create table "public"."leaf" (
    "id_leaf" uuid not null,
    "description" text,
    "id_profile" uuid not null
      );



  create table "public"."leaf_sachet" (
    "id_leaf" uuid not null,
    "id_sachet" uuid not null
      );



  create table "public"."profile" (
    "id_profile" uuid not null,
    "id_user" uuid not null
      );



  create table "public"."profile_group" (
    "id_profile" uuid not null,
    "id_teapot" uuid not null
      );



  create table "public"."sachet" (
    "id_sachet" uuid not null,
    "date" date not null,
    "id_teapot" uuid not null
      );



  create table "public"."teapot" (
    "id_teapot" uuid not null,
    "name" text not null,
    "description" text
      );


CREATE UNIQUE INDEX leaf_pkey ON public.leaf USING btree (id_leaf);

CREATE UNIQUE INDEX leaf_sachet_pkey ON public.leaf_sachet USING btree (id_leaf, id_sachet);

CREATE UNIQUE INDEX profile_group_pkey ON public.profile_group USING btree (id_profile, id_teapot);

CREATE UNIQUE INDEX profile_pkey ON public.profile USING btree (id_profile);

CREATE UNIQUE INDEX sachet_pkey ON public.sachet USING btree (id_sachet);

CREATE UNIQUE INDEX teapot_pkey ON public.teapot USING btree (id_teapot);

alter table "public"."leaf" add constraint "leaf_pkey" PRIMARY KEY using index "leaf_pkey";

alter table "public"."leaf_sachet" add constraint "leaf_sachet_pkey" PRIMARY KEY using index "leaf_sachet_pkey";

alter table "public"."profile" add constraint "profile_pkey" PRIMARY KEY using index "profile_pkey";

alter table "public"."profile_group" add constraint "profile_group_pkey" PRIMARY KEY using index "profile_group_pkey";

alter table "public"."sachet" add constraint "sachet_pkey" PRIMARY KEY using index "sachet_pkey";

alter table "public"."teapot" add constraint "teapot_pkey" PRIMARY KEY using index "teapot_pkey";

alter table "public"."leaf" add constraint "leaf_id_profile_fkey" FOREIGN KEY (id_profile) REFERENCES public.profile(id_profile) not valid;

alter table "public"."leaf" validate constraint "leaf_id_profile_fkey";

alter table "public"."leaf_sachet" add constraint "leaf_sachet_id_leaf_fkey" FOREIGN KEY (id_leaf) REFERENCES public.leaf(id_leaf) not valid;

alter table "public"."leaf_sachet" validate constraint "leaf_sachet_id_leaf_fkey";

alter table "public"."leaf_sachet" add constraint "leaf_sachet_id_sachet_fkey" FOREIGN KEY (id_sachet) REFERENCES public.sachet(id_sachet) not valid;

alter table "public"."leaf_sachet" validate constraint "leaf_sachet_id_sachet_fkey";

alter table "public"."profile" add constraint "profile_id_user_fkey" FOREIGN KEY (id_user) REFERENCES auth.users(id) not valid;

alter table "public"."profile" validate constraint "profile_id_user_fkey";

alter table "public"."profile_group" add constraint "profile_group_id_profile_fkey" FOREIGN KEY (id_profile) REFERENCES public.profile(id_profile) not valid;

alter table "public"."profile_group" validate constraint "profile_group_id_profile_fkey";

alter table "public"."profile_group" add constraint "profile_group_id_teapot_fkey" FOREIGN KEY (id_teapot) REFERENCES public.teapot(id_teapot) not valid;

alter table "public"."profile_group" validate constraint "profile_group_id_teapot_fkey";

alter table "public"."sachet" add constraint "sachet_id_teapot_fkey" FOREIGN KEY (id_teapot) REFERENCES public.teapot(id_teapot) not valid;

alter table "public"."sachet" validate constraint "sachet_id_teapot_fkey";

grant delete on table "public"."leaf" to "anon";

grant insert on table "public"."leaf" to "anon";

grant references on table "public"."leaf" to "anon";

grant select on table "public"."leaf" to "anon";

grant trigger on table "public"."leaf" to "anon";

grant truncate on table "public"."leaf" to "anon";

grant update on table "public"."leaf" to "anon";

grant delete on table "public"."leaf" to "authenticated";

grant insert on table "public"."leaf" to "authenticated";

grant references on table "public"."leaf" to "authenticated";

grant select on table "public"."leaf" to "authenticated";

grant trigger on table "public"."leaf" to "authenticated";

grant truncate on table "public"."leaf" to "authenticated";

grant update on table "public"."leaf" to "authenticated";

grant delete on table "public"."leaf" to "postgres";

grant insert on table "public"."leaf" to "postgres";

grant references on table "public"."leaf" to "postgres";

grant select on table "public"."leaf" to "postgres";

grant trigger on table "public"."leaf" to "postgres";

grant truncate on table "public"."leaf" to "postgres";

grant update on table "public"."leaf" to "postgres";

grant delete on table "public"."leaf" to "service_role";

grant insert on table "public"."leaf" to "service_role";

grant references on table "public"."leaf" to "service_role";

grant select on table "public"."leaf" to "service_role";

grant trigger on table "public"."leaf" to "service_role";

grant truncate on table "public"."leaf" to "service_role";

grant update on table "public"."leaf" to "service_role";

grant delete on table "public"."leaf_sachet" to "anon";

grant insert on table "public"."leaf_sachet" to "anon";

grant references on table "public"."leaf_sachet" to "anon";

grant select on table "public"."leaf_sachet" to "anon";

grant trigger on table "public"."leaf_sachet" to "anon";

grant truncate on table "public"."leaf_sachet" to "anon";

grant update on table "public"."leaf_sachet" to "anon";

grant delete on table "public"."leaf_sachet" to "authenticated";

grant insert on table "public"."leaf_sachet" to "authenticated";

grant references on table "public"."leaf_sachet" to "authenticated";

grant select on table "public"."leaf_sachet" to "authenticated";

grant trigger on table "public"."leaf_sachet" to "authenticated";

grant truncate on table "public"."leaf_sachet" to "authenticated";

grant update on table "public"."leaf_sachet" to "authenticated";

grant delete on table "public"."leaf_sachet" to "postgres";

grant insert on table "public"."leaf_sachet" to "postgres";

grant references on table "public"."leaf_sachet" to "postgres";

grant select on table "public"."leaf_sachet" to "postgres";

grant trigger on table "public"."leaf_sachet" to "postgres";

grant truncate on table "public"."leaf_sachet" to "postgres";

grant update on table "public"."leaf_sachet" to "postgres";

grant delete on table "public"."leaf_sachet" to "service_role";

grant insert on table "public"."leaf_sachet" to "service_role";

grant references on table "public"."leaf_sachet" to "service_role";

grant select on table "public"."leaf_sachet" to "service_role";

grant trigger on table "public"."leaf_sachet" to "service_role";

grant truncate on table "public"."leaf_sachet" to "service_role";

grant update on table "public"."leaf_sachet" to "service_role";

grant delete on table "public"."profile" to "anon";

grant insert on table "public"."profile" to "anon";

grant references on table "public"."profile" to "anon";

grant select on table "public"."profile" to "anon";

grant trigger on table "public"."profile" to "anon";

grant truncate on table "public"."profile" to "anon";

grant update on table "public"."profile" to "anon";

grant delete on table "public"."profile" to "authenticated";

grant insert on table "public"."profile" to "authenticated";

grant references on table "public"."profile" to "authenticated";

grant select on table "public"."profile" to "authenticated";

grant trigger on table "public"."profile" to "authenticated";

grant truncate on table "public"."profile" to "authenticated";

grant update on table "public"."profile" to "authenticated";

grant delete on table "public"."profile" to "postgres";

grant insert on table "public"."profile" to "postgres";

grant references on table "public"."profile" to "postgres";

grant select on table "public"."profile" to "postgres";

grant trigger on table "public"."profile" to "postgres";

grant truncate on table "public"."profile" to "postgres";

grant update on table "public"."profile" to "postgres";

grant delete on table "public"."profile" to "service_role";

grant insert on table "public"."profile" to "service_role";

grant references on table "public"."profile" to "service_role";

grant select on table "public"."profile" to "service_role";

grant trigger on table "public"."profile" to "service_role";

grant truncate on table "public"."profile" to "service_role";

grant update on table "public"."profile" to "service_role";

grant delete on table "public"."profile_group" to "anon";

grant insert on table "public"."profile_group" to "anon";

grant references on table "public"."profile_group" to "anon";

grant select on table "public"."profile_group" to "anon";

grant trigger on table "public"."profile_group" to "anon";

grant truncate on table "public"."profile_group" to "anon";

grant update on table "public"."profile_group" to "anon";

grant delete on table "public"."profile_group" to "authenticated";

grant insert on table "public"."profile_group" to "authenticated";

grant references on table "public"."profile_group" to "authenticated";

grant select on table "public"."profile_group" to "authenticated";

grant trigger on table "public"."profile_group" to "authenticated";

grant truncate on table "public"."profile_group" to "authenticated";

grant update on table "public"."profile_group" to "authenticated";

grant delete on table "public"."profile_group" to "postgres";

grant insert on table "public"."profile_group" to "postgres";

grant references on table "public"."profile_group" to "postgres";

grant select on table "public"."profile_group" to "postgres";

grant trigger on table "public"."profile_group" to "postgres";

grant truncate on table "public"."profile_group" to "postgres";

grant update on table "public"."profile_group" to "postgres";

grant delete on table "public"."profile_group" to "service_role";

grant insert on table "public"."profile_group" to "service_role";

grant references on table "public"."profile_group" to "service_role";

grant select on table "public"."profile_group" to "service_role";

grant trigger on table "public"."profile_group" to "service_role";

grant truncate on table "public"."profile_group" to "service_role";

grant update on table "public"."profile_group" to "service_role";

grant delete on table "public"."sachet" to "anon";

grant insert on table "public"."sachet" to "anon";

grant references on table "public"."sachet" to "anon";

grant select on table "public"."sachet" to "anon";

grant trigger on table "public"."sachet" to "anon";

grant truncate on table "public"."sachet" to "anon";

grant update on table "public"."sachet" to "anon";

grant delete on table "public"."sachet" to "authenticated";

grant insert on table "public"."sachet" to "authenticated";

grant references on table "public"."sachet" to "authenticated";

grant select on table "public"."sachet" to "authenticated";

grant trigger on table "public"."sachet" to "authenticated";

grant truncate on table "public"."sachet" to "authenticated";

grant update on table "public"."sachet" to "authenticated";

grant delete on table "public"."sachet" to "postgres";

grant insert on table "public"."sachet" to "postgres";

grant references on table "public"."sachet" to "postgres";

grant select on table "public"."sachet" to "postgres";

grant trigger on table "public"."sachet" to "postgres";

grant truncate on table "public"."sachet" to "postgres";

grant update on table "public"."sachet" to "postgres";

grant delete on table "public"."sachet" to "service_role";

grant insert on table "public"."sachet" to "service_role";

grant references on table "public"."sachet" to "service_role";

grant select on table "public"."sachet" to "service_role";

grant trigger on table "public"."sachet" to "service_role";

grant truncate on table "public"."sachet" to "service_role";

grant update on table "public"."sachet" to "service_role";

grant delete on table "public"."teapot" to "anon";

grant insert on table "public"."teapot" to "anon";

grant references on table "public"."teapot" to "anon";

grant select on table "public"."teapot" to "anon";

grant trigger on table "public"."teapot" to "anon";

grant truncate on table "public"."teapot" to "anon";

grant update on table "public"."teapot" to "anon";

grant delete on table "public"."teapot" to "authenticated";

grant insert on table "public"."teapot" to "authenticated";

grant references on table "public"."teapot" to "authenticated";

grant select on table "public"."teapot" to "authenticated";

grant trigger on table "public"."teapot" to "authenticated";

grant truncate on table "public"."teapot" to "authenticated";

grant update on table "public"."teapot" to "authenticated";

grant delete on table "public"."teapot" to "postgres";

grant insert on table "public"."teapot" to "postgres";

grant references on table "public"."teapot" to "postgres";

grant select on table "public"."teapot" to "postgres";

grant trigger on table "public"."teapot" to "postgres";

grant truncate on table "public"."teapot" to "postgres";

grant update on table "public"."teapot" to "postgres";

grant delete on table "public"."teapot" to "service_role";

grant insert on table "public"."teapot" to "service_role";

grant references on table "public"."teapot" to "service_role";

grant select on table "public"."teapot" to "service_role";

grant trigger on table "public"."teapot" to "service_role";

grant truncate on table "public"."teapot" to "service_role";

grant update on table "public"."teapot" to "service_role";


