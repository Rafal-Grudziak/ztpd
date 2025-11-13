ZAD 1
CREATE OR REPLACE TYPE samochod as OBJECT (
    MARKA VARCHAR2(20), 
    MODEL VARCHAR2(20), 
    KILOMETRY NUMBER, 
    DATA_PRODUKCJI DATE, 
    CENA NUMBER(10, 2) 
);

DESC samochod;

CREATE TABLE samochody OF SAMOCHOD;

INSERT INTO samochody VALUES ('FIAT', 'BRAVA', 60000, TO_DATE('30-11-1999', 'dd-MM-yyyy'), 25000);
INSERT INTO samochody VALUES ('FORD', 'MONDEO', 80000, TO_DATE('10-05-1997', 'dd-MM-yyyy'), 45000);
INSERT INTO samochody VALUES ('MAZDA', '323', 12000, TO_DATE('22-09-2000', 'dd-MM-yyyy'), 52000);

SELECT * FROM samochody;

ZAD 2
CREATE TABLE wlasciciele (
    IMIE VARCHAR2(100), 
    NAZWISKO VARCHAR2(100), 
    AUTO SAMOCHOD
);

DESC wlasciciele;

INSERT INTO wlasciciele VALUES ('JAN', 'KOWALSKI', NEW SAMOCHOD('FIAT', 'SEICENTO', 30000, TO_DATE('02-12-0010', 'dd-MM-yyyy'), 19500));
INSERT INTO wlasciciele VALUES ('ADAM', 'NOWAK', NEW SAMOCHOD('OPEL', 'ASTRA', 34000, TO_DATE('01-06-0009', 'dd-MM-yyyy'), 33700));

SELECT * FROM wlasciciele;

ZAD 3
ALTER TYPE samochod ADD MEMBER FUNCTION wartosc 
    RETURN NUMBER CASCADE INCLUDING TABLE DATA;  

CREATE OR REPLACE TYPE BODY samochod AS
    MEMBER FUNCTION wartosc RETURN NUMBER IS
        years NUMBER;  
    BEGIN
        years := FLOOR(EXTRACT (YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM DATA_PRODUKCJI));
        RETURN ROUND(CENA * POWER(0.9, years), 2);
    END wartosc;
END;

SELECT s.marka, s.cena, s.wartosc() FROM SAMOCHODY s;

ZAD 4
ALTER TYPE samochod ADD MAP MEMBER FUNCTION odwzoruj
    RETURN NUMBER CASCADE INCLUDING TABLE DATA;

CREATE OR REPLACE TYPE BODY samochod AS
    MEMBER FUNCTION wartosc RETURN NUMBER IS
        years NUMBER;  
    BEGIN
        years := FLOOR(EXTRACT (YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM DATA_PRODUKCJI));
        RETURN ROUND(CENA * POWER(0.9, years), 2);
    END wartosc;

    MAP MEMBER FUNCTION odwzoruj RETURN NUMBER IS
        BEGIN
            RETURN EXTRACT (YEAR FROM CURRENT_DATE) -EXTRACT (YEAR FROM DATA_PRODUKCJI) + KILOMETRY/10000;
        END odwzoruj;
END;

SELECT * FROM SAMOCHODY s ORDER BY VALUE(s);

ZAD 5
drop table wlasciciele;

CREATE OR REPLACE TYPE wlasciciel AS OBJECT (
    IMIE VARCHAR2(100), 
    NAZWISKO VARCHAR2(100));

ALTER TYPE samochod ADD ATTRIBUTE wlasciciel_ref REF wlasciciel CASCADE;

CREATE TABLE wlasciciele of wlasciciel;
INSERT INTO wlasciciele VALUES (NEW wlasciciel('Rafal','Grudziak'));

UPDATE samochody s
SET s.wlasciciel_ref = (
    SELECT REF(w) FROM wlasciciele w WHERE w.nazwisko='Grudziak'
);

ZAD 6
DECLARE
    TYPE t_przedmioty IS VARRAY(10) OF VARCHAR2(20);
    moje_przedmioty t_przedmioty := t_przedmioty('');
BEGIN
    moje_przedmioty(1) := 'MATEMATYKA';
    moje_przedmioty.EXTEND(9);

    FOR i IN 2..10 LOOP
        moje_przedmioty(i) := 'PRZEDMIOT_' || i;
    END LOOP;

    FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
    END LOOP;

    moje_przedmioty.TRIM(2);

    FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
    
    moje_przedmioty.EXTEND();
    moje_przedmioty(9) := 9;
    
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
    
    moje_przedmioty.DELETE();
    
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
END;

ZAD 7
DECLARE
    TYPE t_ksiazki IS VARRAY(10) OF VARCHAR2(20);
    ksiazki t_ksiazki := t_ksiazki('');
BEGIN
    ksiazki(1) := 'Balladyna';
    ksiazki.EXTEND(3);

    FOR i IN 2..4 LOOP
        ksiazki(i) := 'Ksiazka_' || i;
    END LOOP;

    FOR i IN ksiazki.FIRST()..ksiazki.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(ksiazki(i));
    END LOOP;

    ksiazki.TRIM(2);
    DBMS_OUTPUT.PUT_LINE('Limit: ' || ksiazki.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || ksiazki.COUNT());
    
    ksiazki.DELETE();    
    DBMS_OUTPUT.PUT_LINE('Limit: ' || ksiazki.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || ksiazki.COUNT());
END;

ZAD 8
DECLARE
    TYPE t_wykladowcy IS TABLE OF VARCHAR2(20);
    moi_wykladowcy t_wykladowcy := t_wykladowcy();
BEGIN
    moi_wykladowcy.EXTEND(2);
    
    moi_wykladowcy(1) := 'MORZY';
    moi_wykladowcy(2) := 'WOJCIECHOWSKI';
    
    moi_wykladowcy.EXTEND(8);
    
    FOR i IN 3..10 LOOP
        moi_wykladowcy(i) := 'WYKLADOWCA_' || i;
    END LOOP;
    
    FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
    END LOOP;
    
    moi_wykladowcy.TRIM(2);
    
    FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
    END LOOP;
    
    moi_wykladowcy.DELETE(5,7);
    
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
    
    FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
        IF moi_wykladowcy.EXISTS(i) THEN
            DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
        END IF;
    END LOOP;
    
    moi_wykladowcy(5) := 'ZAKRZEWICZ';
    moi_wykladowcy(6) := 'KROLIKOWSKI';
    moi_wykladowcy(7) := 'KOSZLAJDA';
    
    FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
        IF moi_wykladowcy.EXISTS(i) THEN
            DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
        END IF;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
END;

ZAD 9
DECLARE
    TYPE t_miesiace IS TABLE OF VARCHAR2(20);
    miesiace t_miesiace := t_miesiace();
BEGIN
    miesiace.EXTEND(12);

    FOR i IN 1..12 LOOP 
        miesiace(i) := TO_CHAR(TO_DATE(i, 'MM'), 'MONTH');
    END LOOP;
    
    miesiace.DELETE(2, 4);

    FOR i IN miesiace.first()..miesiace.last() LOOP 
        IF miesiace.EXISTS(i) THEN
            DBMS_OUTPUT.PUT_LINE(miesiace(i));
        END IF;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Limit: ' || miesiace.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || miesiace.COUNT());
END;

ZAD 10
CREATE TYPE jezyki_obce AS VARRAY(10) OF VARCHAR2(20);

CREATE TYPE stypendium AS OBJECT (
    nazwa VARCHAR2(50),
    kraj  VARCHAR2(30),
    jezyki jezyki_obce
);

CREATE TABLE stypendia OF stypendium;

INSERT INTO stypendia VALUES
('SOKRATES','FRANCJA',jezyki_obce('ANGIELSKI','FRANCUSKI','NIEMIECKI'));
INSERT INTO stypendia VALUES
('ERASMUS','NIEMCY',jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI'));

SELECT * FROM stypendia;

SELECT s.jezyki FROM stypendia s;

UPDATE STYPENDIA
SET jezyki = jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI','FRANCUSKI')
WHERE nazwa = 'ERASMUS';

CREATE TYPE lista_egzaminow AS TABLE OF VARCHAR2(20);

CREATE TYPE semestr AS OBJECT (
    numer NUMBER,
    egzaminy lista_egzaminow
);

CREATE TABLE semestry OF semestr
NESTED TABLE egzaminy STORE AS tab_egzaminy;

INSERT INTO semestry VALUES
(semestr(1,lista_egzaminow('MATEMATYKA','LOGIKA','ALGEBRA')));
INSERT INTO semestry VALUES
(semestr(2,lista_egzaminow('BAZY DANYCH','SYSTEMY OPERACYJNE')));

SELECT s.numer, e.*
FROM semestry s, TABLE(s.egzaminy) e;

SELECT e.*
FROM semestry s, TABLE ( s.egzaminy ) e;

SELECT * FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=1 );

INSERT INTO TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 )
VALUES ('METODY NUMERYCZNE');

UPDATE TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
SET e.column_value = 'SYSTEMY ROZPROSZONE'
WHERE e.column_value = 'SYSTEMY OPERACYJNE';

DELETE FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
WHERE e.column_value = 'BAZY DANYCH';

ZAD 11
CREATE TYPE koszyk_produktow AS TABLE OF VARCHAR2(20);

CREATE TYPE zakup AS OBJECT (
    klient VARCHAR(50),
    koszyk koszyk_produktow
);

CREATE TABLE zakupy OF zakup NESTED TABLE koszyk STORE AS tab_koszyki;

INSERT INTO zakupy VALUES(zakup('A', koszyk_produktow('papier','banan','piwo')));
INSERT INTO zakupy VALUES(zakup('B', koszyk_produktow('papier','woda')));
INSERT INTO zakupy VALUES(zakup('C', koszyk_produktow('woda','piwo')));

SELECT * from zakupy;

delete from zakupy where 'piwo' member of koszyk;
select * from zakupy;

ZAD 12
CREATE TYPE instrument AS OBJECT (
    nazwa VARCHAR2(20),
    dzwiek VARCHAR2(20),
    MEMBER FUNCTION graj RETURN VARCHAR2
) NOT FINAL;

CREATE TYPE BODY instrument AS
    MEMBER FUNCTION graj RETURN VARCHAR2 IS
        BEGIN
            RETURN dzwiek;
        END;
END;

CREATE TYPE instrument_dety UNDER instrument (
    material VARCHAR2(20),
    OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2,
    MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2
);

CREATE OR REPLACE TYPE BODY instrument_dety AS
    OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
        BEGIN
            RETURN 'dmucham: '||dzwiek;
        END;
    
    MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 IS
        BEGIN
            RETURN glosnosc||':'||dzwiek;
        END;
END;

CREATE TYPE instrument_klawiszowy UNDER instrument (
    producent VARCHAR2(20),
    OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2
);

CREATE OR REPLACE TYPE BODY instrument_klawiszowy AS
    OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
        BEGIN
            RETURN 'stukam w klawisze: '||dzwiek;
        END;
END;

DECLARE
    tamburyn instrument := instrument('tamburyn','brzdek-brzdek');
    trabka instrument_dety := instrument_dety('trabka','tra-ta-ta','metalowa');
    fortepian instrument_klawiszowy := instrument_klawiszowy('fortepian','pingping','steinway');
BEGIN
    dbms_output.put_line(tamburyn.graj);
    dbms_output.put_line(trabka.graj);
    dbms_output.put_line(trabka.graj('glosno'));
    dbms_output.put_line(fortepian.graj);
END;

ZAD 13
CREATE TYPE istota AS OBJECT (
    nazwa VARCHAR2(20),
    NOT INSTANTIABLE MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR
) NOT INSTANTIABLE NOT FINAL;

CREATE TYPE lew UNDER istota (
    liczba_nog NUMBER,
    OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR
);

CREATE OR REPLACE TYPE BODY lew AS
    OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR IS
        BEGIN
            RETURN 'upolowana ofiara: '||ofiara;
        END;
END;

DECLARE
    KrolLew lew := lew('LEW',4);
    InnaIstota istota := istota('JAKIES ZWIERZE'); -- próba utworzenia obiektu klasy abstrakcyjnej
BEGIN
    DBMS_OUTPUT.PUT_LINE( KrolLew.poluj('antylopa') );
END;

ZAD 14
DECLARE
    tamburyn instrument;
    cymbalki instrument;
    trabka instrument_dety;
    saksofon instrument_dety;
BEGIN
    tamburyn := instrument('tamburyn','brzdek-brzdek');
    cymbalki := instrument_dety('cymbalki','ding-ding','metalowe');
    trabka := instrument_dety('trabka','tra-ta-ta','metalowa');
    -- saksofon := instrument('saksofon','tra-taaaa'); --wyrażenie niewłaściwego typu
    -- saksofon := TREAT( instrument('saksofon','tra-taaaa') AS instrument_dety); --błąd liczby lub wartości: nie można przypisac instancji supertypu do podtypu
END;

ZAD 15
CREATE TABLE instrumenty OF instrument;
INSERT INTO instrumenty VALUES ( instrument('tamburyn','brzdek-brzdek') );
INSERT INTO instrumenty VALUES ( instrument_dety('trabka','tra-ta-ta','metalowa') );
INSERT INTO instrumenty VALUES ( instrument_klawiszowy('fortepian','pingping','steinway') );

SELECT i.nazwa, i.graj() FROM instrumenty i;