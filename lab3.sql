set serveroutput on size 30000;

ZAD 1
CREATE TABLE DOKUMENTY (
    ID NUMBER(12) PRIMARY KEY,
    DOKUMENT CLOB
);

ZAD 2
DECLARE
    tekst CLOB;
BEGIN
    tekst := '';
    FOR i IN 1..10000 LOOP
        tekst := tekst || 'Oto tekst. ';
    END LOOP;
    INSERT INTO DOKUMENTY VALUES (1, tekst);
END;

ZAD 3
A
SELECT * FROM DOKUMENTY;
B
SELECT UPPER(DOKUMENT) FROM DOKUMENTY;
C
SELECT LENGTH(DOKUMENT) FROM DOKUMENTY;
D
SELECT dbms_lob.getlength(DOKUMENT) FROM DOKUMENTY;
E
SELECT SUBSTR(DOKUMENT, 5, 1000) FROM DOKUMENTY;
F
SELECT dbms_lob.substr(DOKUMENT, 1000, 5) FROM DOKUMENTY;

ZAD 4
INSERT INTO DOKUMENTY VALUES (2, EMPTY_CLOB());

ZAD 5
INSERT INTO DOKUMENTY VALUES (3, NULL);
COMMIT;

ZAD 6
A
SELECT * FROM DOKUMENTY;
B
SELECT UPPER(DOKUMENT) FROM DOKUMENTY;
C
SELECT LENGTH(DOKUMENT) FROM DOKUMENTY;
D
SELECT dbms_lob.getlength(DOKUMENT) FROM DOKUMENTY;
E
SELECT SUBSTR(DOKUMENT, 5, 1000) FROM DOKUMENTY;
F
SELECT dbms_lob.substr(DOKUMENT, 1000, 5) FROM DOKUMENTY;

ZAD 7
DECLARE

    fil BFILE := BFILENAME('TPD_DIR', 'dokument.txt');
    clo CLOB;
    dest_offset NUMBER := 1;
    src_offset NUMBER := 1;
    bfile_csid NUMBER := 0;
    lang_contex NUMBER := 0;
    warn NUMBER := null;

BEGIN

    SELECT DOKUMENT INTO clo
    FROM DOKUMENTY
    WHERE ID = 2
    FOR UPDATE;

    dbms_lob.fileopen(fil);
    dbms_lob.loadclobfromfile(clo, fil, dbms_lob.getlength(fil), dest_offset, src_offset, bfile_csid, lang_contex, warn);    
    dbms_lob.fileclose(fil);

    COMMIT;

    dbms_output.put_line(warn);
END;

ZAD 8
UPDATE DOKUMENTY SET DOKUMENT = TO_CLOB(BFILENAME('TPD_DIR', 'dokument.txt')) WHERE ID = 3;

ZAD 9
SELECT * FROM DOKUMENTY;

ZAD 10
SELECT ID, dbms_lob.getlength(DOKUMENT) FROM DOKUMENTY;

ZAD 11
DROP TABLE DOKUMENTY;

ZAD 12
CREATE OR REPLACE PROCEDURE clob_censor (
    p_clob IN OUT NOCOPY CLOB,
    p_bad  IN            VARCHAR2
) IS
    v_pos        PLS_INTEGER;
    v_bad_len    PLS_INTEGER;
    v_mask       VARCHAR2(32767);
    v_clob_len   PLS_INTEGER;
BEGIN
    IF p_clob IS NULL OR p_bad IS NULL OR LENGTH(p_bad) = 0 THEN
        RETURN;
    END IF;

    v_bad_len  := LENGTH(p_bad);
    v_clob_len := DBMS_LOB.GETLENGTH(p_clob);
    v_mask     := RPAD('.', v_bad_len, '.');

    v_pos := INSTR(p_clob, p_bad, 1, 1);

    WHILE v_pos > 0 LOOP
        DBMS_LOB.WRITE(
            lob_loc => p_clob,
            amount  => v_bad_len,
            offset  => v_pos,
            buffer  => v_mask
        );

        v_pos := INSTR(p_clob, p_bad, v_pos + v_bad_len, 1);
    END LOOP;
END clob_censor;

DECLARE
    v_c CLOB;
BEGIN
    v_c := 'To jest tajne. To są tajne dane. Mega TAJNE!!! tajne';
    clob_censor(v_c, 'tajne');
    DBMS_OUTPUT.PUT_LINE(v_c);
END;

ZAD 13
CREATE TABLE BIOGRAPHIES AS SELECT * FROM ZTPD.BIOGRAPHIES;
SELECT * FROM BIOGRAPHIES;

DECLARE
    bio CLOB;
BEGIN
    SELECT BIO INTO bio
    FROM BIOGRAPHIES
    FOR UPDATE;

    CLOB_CENSOR(bio, 'Cimrman');
    COMMIT;
END;

SELECT * FROM BIOGRAPHIES;

ZAD 14
DROP TABLE BIOGRAPHIES;