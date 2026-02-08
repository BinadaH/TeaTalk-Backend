alter table "public"."sachet" drop constraint "sachet_id_teapot_fkey";

alter table "public"."sachet" add constraint "sachet_id_teapot_fkey" FOREIGN KEY (id_teapot) REFERENCES public.teapot(id_teapot) ON DELETE CASCADE not valid;

alter table "public"."sachet" validate constraint "sachet_id_teapot_fkey";


