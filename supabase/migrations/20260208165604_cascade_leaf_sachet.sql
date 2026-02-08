alter table "public"."leaf_sachet" drop constraint "leaf_sachet_id_leaf_fkey";

alter table "public"."leaf_sachet" drop constraint "leaf_sachet_id_sachet_fkey";

alter table "public"."leaf_sachet" add constraint "leaf_sachet_id_leaf_fkey" FOREIGN KEY (id_leaf) REFERENCES public.leaf(id_leaf) ON DELETE CASCADE not valid;

alter table "public"."leaf_sachet" validate constraint "leaf_sachet_id_leaf_fkey";

alter table "public"."leaf_sachet" add constraint "leaf_sachet_id_sachet_fkey" FOREIGN KEY (id_sachet) REFERENCES public.sachet(id_sachet) ON DELETE CASCADE not valid;

alter table "public"."leaf_sachet" validate constraint "leaf_sachet_id_sachet_fkey";


