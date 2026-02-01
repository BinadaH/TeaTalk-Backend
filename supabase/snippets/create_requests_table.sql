create table requests (
  id uuid primary key default uuid_generate_v4(),
  id_sender uuid not null,
  id_teapot uuid not null,
  id_receiver uuid not null,
  status text check (status in ('pending', 'accepted', 'declined')) default 'pending',
  created_at timestamp with time zone default now(),
  
  -- Prevent duplicate requests between the same two people
  unique(id_sender, id_receiver, id_teapot),

  constraint sender_not_receiver check (id_sender <> id_receiver)
);