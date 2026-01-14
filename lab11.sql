ZAD 1
CREATE TABLE CYTATY AS
SELECT * FROM ZTPD.CYTATY;

ZAD 2
SELECT autor, tekst
FROM CYTATY
WHERE LOWER(tekst) LIKE '%optymista%'
AND LOWER(tekst) LIKE '%pesymista%';

ZAD 3
CREATE INDEX cytaty_ctx
ON CYTATY(tekst)
INDEXTYPE IS CTXSYS.CONTEXT;

ZAD 4
SELECT autor, tekst
FROM CYTATY
WHERE CONTAINS(tekst, 'optymista AND pesymista', 1) > 0;

ZAD 5
SELECT autor, tekst
FROM CYTATY
WHERE CONTAINS(tekst, 'optymista - pesymista', 1) > 0;

ZAD 6
SELECT autor, tekst
FROM CYTATY
WHERE CONTAINS(tekst, 'NEAR((optymista, pesymista), 3)', 1) > 0;

ZAD 7
SELECT autor, tekst
FROM CYTATY
WHERE CONTAINS(tekst, 'NEAR((optymista, pesymista), 10)', 1) > 0;

ZAD 8 
SELECT autor, tekst
FROM CYTATY
WHERE CONTAINS(tekst, 'życi%', 1) > 0;

ZAD 9
SELECT autor, tekst, SCORE(1) AS dopasowanie
FROM CYTATY
WHERE CONTAINS(tekst, 'życi%', 1) > 0;

ZAD 10
SELECT autor, tekst, SCORE(1) AS dopasowanie
FROM CYTATY
WHERE CONTAINS(tekst, 'życi%', 1) > 0
ORDER BY SCORE(1) DESC
FETCH FIRST 1 ROW ONLY;

ZAD 11
SELECT autor, tekst
FROM CYTATY
WHERE CONTAINS(tekst, 'FUZZY(probelm)', 1) > 0;

ZAD 12
INSERT INTO CYTATY (id, autor, tekst)
SELECT NVL(MAX(id), 0) + 1,
       'Bertrand Russell',
       'To smutne, że głupcy są tacy pewni siebie, a ludzie rozsądni tacy pełni wątpliwości.'
FROM CYTATY;

COMMIT;

ZAD 13
SELECT autor, tekst
FROM CYTATY
WHERE CONTAINS(tekst, 'głupcy', 1) > 0;

ZAD 14
SELECT token_text
FROM DR$CYTATY_CTX$I
WHERE token_text LIKE 'głup%';

ZAD 15
DROP INDEX cytaty_ctx;

CREATE INDEX cytaty_ctx
ON CYTATY(tekst)
INDEXTYPE IS CTXSYS.CONTEXT;

ZAD 16
SELECT autor, tekst
FROM CYTATY
WHERE CONTAINS(tekst, 'głupcy', 1) > 0;

ZAD 17
DROP INDEX cytaty_text_idx;
DROP TABLE cytaty;


Zaawansowane indeksowanie i wyszukiwanie

ZAD 1
CREATE TABLE QUOTES AS
SELECT * FROM ZTPD.QUOTES;

ZAD 2
CREATE INDEX quotes_ctx
ON QUOTES(text)
INDEXTYPE IS CTXSYS.CONTEXT;

ZAD 3
SELECT author, text
FROM quotes
WHERE CONTAINS(text, 'work', 1) > 0;

SELECT author, text
FROM quotes
WHERE CONTAINS(text, '$work', 1) > 0;

SELECT author, text
FROM quotes
WHERE CONTAINS(text, 'working', 1) > 0;

SELECT author, text
FROM quotes
WHERE CONTAINS(text, '$working', 1) > 0;

ZAD 4
SELECT author, text
FROM quotes
WHERE CONTAINS(text, 'it', 1) > 0;

ZAD 5
SELECT spl_name, spl_type, spl_count, spl_owner
FROM ctx_stoplists
ORDER BY spl_name;

ZAD 6
SELECT spw_word
FROM ctx_stopwords
WHERE spw_stoplist = 'DEFAULT_STOPLIST'
ORDER BY spw_word;

ZAD 7
DROP INDEX quotes_ctx;

SELECT spl_name, spl_type, spl_count
FROM ctx_stoplists
WHERE spl_count = 0;

CREATE INDEX quotes_ctx
ON quotes(text)
INDEXTYPE IS CTXSYS.CONTEXT
PARAMETERS ('STOPLIST CTXSYS.EMPTY_STOPLIST');

ZAD 8
SELECT author, text
FROM quotes
WHERE CONTAINS(text, 'fool AND humans', 1) > 0;

ZAD 9
SELECT author, text
FROM quotes
WHERE CONTAINS(text, 'fool AND humans', 1) > 0;

ZAD 10
SELECT author, text
FROM quotes
WHERE CONTAINS(text, 'fool AND computer', 1) > 0;

ZAD 11
SELECT author, text
FROM quotes
WHERE CONTAINS(text, '(fool AND humans) WITHIN sentence', 1) > 0;
Błąd pojawia się, ponieważ indeks CONTEXT utworzony domyślnie nie ma zdefiniowanej grupy sekcji (SECTION GROUP) obsługującej zdania

ZAD 12
DROP INDEX quotes_ctx;

ZAD 13
BEGIN
  CTX_DDL.CREATE_SECTION_GROUP('QUOTES_SG', 'NULL_SECTION_GROUP');
  CTX_DDL.ADD_SPECIAL_SECTION('QUOTES_SG', 'SENTENCE');
  CTX_DDL.ADD_SPECIAL_SECTION('QUOTES_SG', 'PARAGRAPH');
END;

ZAD 14
CREATE INDEX quotes_ctx
ON quotes(text)
INDEXTYPE IS CTXSYS.CONTEXT
PARAMETERS ('STOPLIST CTXSYS.EMPTY_STOPLIST SECTION GROUP QUOTES_SG');

ZAD 15
SELECT author, text
FROM quotes
WHERE CONTAINS(text, '(fool AND humans) WITHIN sentence', 1) > 0;

SELECT author, text
FROM quotes
WHERE CONTAINS(text, '(fool AND computer) WITHIN sentence', 1) > 0;

ZAD 16
SELECT author, text
FROM quotes
WHERE CONTAINS(text, 'humans', 1) > 0;

ZAD 17
DROP INDEX quotes_ctx;

BEGIN
  CTX_DDL.CREATE_PREFERENCE('QUOTES_LEX', 'BASIC_LEXER');
  CTX_DDL.SET_ATTRIBUTE('QUOTES_LEX', 'PRINTJOINS', '-');
END;

CREATE INDEX quotes_ctx
ON QUOTES(text)
INDEXTYPE IS CTXSYS.CONTEXT
PARAMETERS ('LEXER QUOTES_LEX SECTION GROUP QUOTES_SG');

ZAD 18
SELECT author, text
FROM quotes
WHERE CONTAINS(text, 'humans', 1) > 0;

ZAD 19
SELECT author, text
FROM quotes
WHERE CONTAINS(text, 'non\-humans', 1) > 0;

ZAD 20
DROP INDEX quotes_ctx;
DROP TABLE quotes;

BEGIN
  CTX_DDL.DROP_PREFERENCE('QUOTES_LEX');
  CTX_DDL.DROP_SECTION_GROUP('QUOTES_SG');
END;