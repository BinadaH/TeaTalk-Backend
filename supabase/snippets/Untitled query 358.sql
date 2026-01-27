CREATE TABLE Profile
(
  id_profile uuid NOT NULL,
  id_user uuid NOT NULL,
  PRIMARY KEY (id_profile),
  FOREIGN KEY (id_user) REFERENCES auth.users(id)
);

CREATE TABLE Leaf
(
  id_leaf uuid NOT NULL,
  description text,
  id_profile uuid NOT NULL,
  PRIMARY KEY (id_leaf),
  FOREIGN KEY (id_profile) REFERENCES Profile(id_profile)
);

CREATE TABLE Teapot
(
  id_teapot uuid NOT NULL,
  name text NOT NULL,
  description text,
  PRIMARY KEY (id_teapot)
);

CREATE TABLE Sachet
(
  id_sachet uuid NOT NULL,
  date DATE NOT NULL,
  id_teapot uuid NOT NULL,
  PRIMARY KEY (id_sachet),
  FOREIGN KEY (id_teapot) REFERENCES Teapot(id_teapot)
);

CREATE TABLE Profile_Group
(
  id_profile uuid NOT NULL,
  id_teapot uuid NOT NULL,
  PRIMARY KEY (id_profile, id_teapot),
  FOREIGN KEY (id_profile) REFERENCES Profile(id_profile),
  FOREIGN KEY (id_teapot) REFERENCES Teapot(id_teapot)
);

CREATE TABLE Leaf_Sachet
(
  id_leaf uuid NOT NULL,
  id_sachet uuid NOT NULL,
  PRIMARY KEY (id_leaf, id_sachet),
  FOREIGN KEY (id_leaf) REFERENCES Leaf(id_leaf),
  FOREIGN KEY (id_sachet) REFERENCES Sachet(id_sachet)
);