ZAD 1
CREATE TABLE movies AS SELECT * FROM ZTPD.MOVIES;

ZAD 2
DESC movies;
SELECT * FROM movies;

ZAD 3
SELECT id, title FROM movies WHERE cover IS NULL;

ZAD 4
SELECT id, title, dbms_lob.getlength(cover) AS FILESIZE FROM movies WHERE cover IS NOT NULL;

ZAD 5
SELECT id, title, dbms_lob.getlength(cover) AS FILESIZE FROM movies WHERE cover IS NULL;

ZAD 6
SELECT DIRECTORY_NAME, DIRECTORY_PATH FROM ALL_DIRECTORIES WHERE DIRECTORY_NAME = 'TPD_DIR';

ZAD 7
UPDATE movies SET cover = EMPTY_BLOB(), mime_type = 'image/jpeg' WHERE id = 66;

ZAD 8
SELECT id, title, dbms_lob.getlength(cover) AS FILESIZE FROM movies WHERE id IN (65, 66);

ZAD 9
DECLARE

    fil BFILE := BFILENAME('TPD_DIR', 'escape.jpg');
    bl BLOB;

BEGIN

    SELECT cover INTO bl
    FROM movies
    WHERE id = 66
    FOR UPDATE;

    dbms_lob.fileopen(fil);
    dbms_lob.loadfromfile(bl, fil, dbms_lob.getlength(fil));    
    dbms_lob.fileclose(fil);

    COMMIT;
END;

ZAD 10
CREATE TABLE TEMP_COVERS (
    movie_id NUMBER(12),
    image BFILE,
    mime_type VARCHAR2(50)
);

ZAD 11
INSERT INTO TEMP_COVERS VALUES(65, BFILENAME('TPD_DIR', 'escape.jpg'), 'image/jpeg');
COMMIT;

ZAD 12
SELECT movie_id, dbms_lob.getlength(image) AS FILESIZE FROM TEMP_COVERS;

ZAD 13
DECLARE

    fil BFILE;
    bl BLOB;
    mime VARCHAR2(50);

BEGIN

    SELECT mime_type, image INTO mime, fil
    FROM TEMP_COVERS
    WHERE movie_id = 65; 

    dbms_lob.createtemporary(bl, TRUE);

    dbms_lob.fileopen(fil);
    dbms_lob.loadfromfile(bl, fil, dbms_lob.getlength(fil));    
    dbms_lob.fileclose(fil);

    UPDATE movies SET cover = bl, mime_type = mime WHERE id = 65; 

    dbms_lob.freetemporary(bl);

    COMMIT;
END;

ZAD 14
SELECT id AS MOVIE_ID, dbms_lob.getlength(cover) AS FILESIZE FROM movies WHERE id IN (65, 66);

ZAD 15
DROP TABLE movies;