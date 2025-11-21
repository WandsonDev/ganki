const base91Table =
    'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!#\$%&()*+,-./:;<=>?@[]^_`{|}~';

const sqlSchema = """
CREATE TABLE cards (
    id integer primary key, nid integer, did integer, ord integer, mod integer,
    usn integer, type integer, queue integer, due integer, ivl integer, factor integer,
    reps integer, laps integer, left integer, odue integer, odid integer, flags integer, data text
);
CREATE TABLE col (
    id integer primary key, crt integer, mod integer, scm integer, ver integer,
    dty integer, usn integer, ls integer, conf text, models text, decks text,
    dconf text, tags text
);
CREATE TABLE notes (
    id integer primary key, guid text, mid integer, mod integer, usn integer,
    tags text, flds text, sfld text, csum integer, flags integer, data text
);
INSERT INTO col VALUES(1,1400000000,1400000000,1400000000,11,0,0,0,'{}','{}','{}','{}','{}');
""";
