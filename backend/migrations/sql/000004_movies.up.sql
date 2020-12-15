INSERT INTO "users" (username, name, email, password, liked, superliked, disliked, friendids, picture)
VALUES ('caspn','Casper Majgaard Nielsen','caspn18@student.sdu.dk','12345','{"liked":[]}','{"superliked":[]}','{"disliked":[]}','{"friendids":[]}','') ON CONFLICT DO NOTHING;
