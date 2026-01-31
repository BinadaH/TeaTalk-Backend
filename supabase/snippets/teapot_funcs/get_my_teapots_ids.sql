CREATE OR REPLACE FUNCTION get_my_groups_ids()
RETURNS SETOF uuid 
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  RETURN QUERY
  SELECT id_teapot 
  FROM profile_teapot 
  WHERE id_profile = (select id_profile from profile where id_user = auth.uid());
END;
$$;