CREATE TABLE IF NOT EXISTS users (
id SERIAL NOT NULL PRIMARY KEY,
username TEXT NOT NULL,
name TEXT NOT NULL,
email TEXT NOT NULL,
password TEXT NOT NULL,
liked TEXT NOT NULL,
superliked TEXT NOT NULL,
disliked TEXT NOT NULL,
friendids TEXT NOT NULL,
picture TEXT,
UNIQUE(username)
	);

INSERT INTO "users" (username, name, email, password, liked, superliked, disliked, friendids, picture)
VALUES ('chboe','Christoffer Falk Boegebjerg','chboe17@student.sdu.dk','12345','{"liked":[]}','{"superliked":[]}','{"disliked":[]}','{"friendids":[]}','') ON CONFLICT DO NOTHING;
