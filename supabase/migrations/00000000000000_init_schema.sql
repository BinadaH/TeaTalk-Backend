


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE EXTENSION IF NOT EXISTS "pg_net" WITH SCHEMA "extensions";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE OR REPLACE FUNCTION "public"."add_users_to_teapot"("id_teapot" "uuid", "to_add_username" "text"[]) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
begin

insert into public.profile_teapot (id_profile, id_teapot)
select (p.id_profile, id_teapot)
from public.profile p
where p.username = any(to_add_username);

end;
$$;


ALTER FUNCTION "public"."add_users_to_teapot"("id_teapot" "uuid", "to_add_username" "text"[]) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_teapot"("teapot_name" "text", "teapot_description" "text", "profile_usernames" "text"[]) RETURNS "uuid"
    LANGUAGE "plpgsql"
    AS $$

declare new_teapot_id UUID;
begin

insert into public.teapot (name, description)
values (teapot_name, teapot_description)
returning id_teapot into new_teapot_id;

insert into public.profile_teapot (id_profile, id_teapot)
select p.id_profile, new_teapot_id
from public.profile p
where p.username = any(profile_usernames);

return new_teapot_id;
end;
$$;


ALTER FUNCTION "public"."create_teapot"("teapot_name" "text", "teapot_description" "text", "profile_usernames" "text"[]) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."handle_new_user"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
  INSERT INTO public.profile (id_user, username)
  VALUES (
    new.id, 
    new.raw_user_meta_data->>'username'
  );
  RETURN new;
END;
$$;


ALTER FUNCTION "public"."handle_new_user"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."leaf" (
    "id_leaf" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "description" "text",
    "id_profile" "uuid" NOT NULL
);


ALTER TABLE "public"."leaf" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."leaf_sachet" (
    "id_leaf" "uuid" NOT NULL,
    "id_sachet" "uuid" NOT NULL
);


ALTER TABLE "public"."leaf_sachet" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."profile" (
    "id_profile" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "id_user" "uuid" NOT NULL,
    "username" "text"
);


ALTER TABLE "public"."profile" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."profile_teapot" (
    "id_profile" "uuid" NOT NULL,
    "id_teapot" "uuid" NOT NULL
);


ALTER TABLE "public"."profile_teapot" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."sachet" (
    "id_sachet" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "date" "date" NOT NULL,
    "id_teapot" "uuid" NOT NULL
);


ALTER TABLE "public"."sachet" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."teapot" (
    "id_teapot" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL,
    "description" "text"
);


ALTER TABLE "public"."teapot" OWNER TO "postgres";


ALTER TABLE ONLY "public"."leaf"
    ADD CONSTRAINT "leaf_pkey" PRIMARY KEY ("id_leaf");



ALTER TABLE ONLY "public"."leaf_sachet"
    ADD CONSTRAINT "leaf_sachet_pkey" PRIMARY KEY ("id_leaf", "id_sachet");



ALTER TABLE ONLY "public"."profile_teapot"
    ADD CONSTRAINT "profile_group_pkey" PRIMARY KEY ("id_profile", "id_teapot");



ALTER TABLE ONLY "public"."profile"
    ADD CONSTRAINT "profile_pkey" PRIMARY KEY ("id_profile");



ALTER TABLE ONLY "public"."sachet"
    ADD CONSTRAINT "sachet_pkey" PRIMARY KEY ("id_sachet");



ALTER TABLE ONLY "public"."teapot"
    ADD CONSTRAINT "teapot_pkey" PRIMARY KEY ("id_teapot");



ALTER TABLE ONLY "public"."leaf"
    ADD CONSTRAINT "leaf_id_profile_fkey" FOREIGN KEY ("id_profile") REFERENCES "public"."profile"("id_profile");



ALTER TABLE ONLY "public"."leaf_sachet"
    ADD CONSTRAINT "leaf_sachet_id_leaf_fkey" FOREIGN KEY ("id_leaf") REFERENCES "public"."leaf"("id_leaf");



ALTER TABLE ONLY "public"."leaf_sachet"
    ADD CONSTRAINT "leaf_sachet_id_sachet_fkey" FOREIGN KEY ("id_sachet") REFERENCES "public"."sachet"("id_sachet");



ALTER TABLE ONLY "public"."profile_teapot"
    ADD CONSTRAINT "profile_group_id_profile_fkey" FOREIGN KEY ("id_profile") REFERENCES "public"."profile"("id_profile");



ALTER TABLE ONLY "public"."profile_teapot"
    ADD CONSTRAINT "profile_group_id_teapot_fkey" FOREIGN KEY ("id_teapot") REFERENCES "public"."teapot"("id_teapot");



ALTER TABLE ONLY "public"."profile"
    ADD CONSTRAINT "profile_id_user_fkey" FOREIGN KEY ("id_user") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."sachet"
    ADD CONSTRAINT "sachet_id_teapot_fkey" FOREIGN KEY ("id_teapot") REFERENCES "public"."teapot"("id_teapot");





ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";





GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";































































































































































GRANT ALL ON FUNCTION "public"."add_users_to_teapot"("id_teapot" "uuid", "to_add_username" "text"[]) TO "anon";
GRANT ALL ON FUNCTION "public"."add_users_to_teapot"("id_teapot" "uuid", "to_add_username" "text"[]) TO "authenticated";
GRANT ALL ON FUNCTION "public"."add_users_to_teapot"("id_teapot" "uuid", "to_add_username" "text"[]) TO "service_role";



GRANT ALL ON FUNCTION "public"."create_teapot"("teapot_name" "text", "teapot_description" "text", "profile_usernames" "text"[]) TO "anon";
GRANT ALL ON FUNCTION "public"."create_teapot"("teapot_name" "text", "teapot_description" "text", "profile_usernames" "text"[]) TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_teapot"("teapot_name" "text", "teapot_description" "text", "profile_usernames" "text"[]) TO "service_role";



GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "service_role";


















GRANT ALL ON TABLE "public"."leaf" TO "anon";
GRANT ALL ON TABLE "public"."leaf" TO "authenticated";
GRANT ALL ON TABLE "public"."leaf" TO "service_role";



GRANT ALL ON TABLE "public"."leaf_sachet" TO "anon";
GRANT ALL ON TABLE "public"."leaf_sachet" TO "authenticated";
GRANT ALL ON TABLE "public"."leaf_sachet" TO "service_role";



GRANT ALL ON TABLE "public"."profile" TO "anon";
GRANT ALL ON TABLE "public"."profile" TO "authenticated";
GRANT ALL ON TABLE "public"."profile" TO "service_role";



GRANT ALL ON TABLE "public"."profile_teapot" TO "anon";
GRANT ALL ON TABLE "public"."profile_teapot" TO "authenticated";
GRANT ALL ON TABLE "public"."profile_teapot" TO "service_role";



GRANT ALL ON TABLE "public"."sachet" TO "anon";
GRANT ALL ON TABLE "public"."sachet" TO "authenticated";
GRANT ALL ON TABLE "public"."sachet" TO "service_role";



GRANT ALL ON TABLE "public"."teapot" TO "anon";
GRANT ALL ON TABLE "public"."teapot" TO "authenticated";
GRANT ALL ON TABLE "public"."teapot" TO "service_role";









ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";































