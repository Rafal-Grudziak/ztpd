ZAD 1A
CREATE TABLE FIGURY (
    ID NUMBER(1) PRIMARY KEY, 
    KSZTALT MDSYS.SDO_GEOMETRY
);

ZAD 1B
INSERT INTO FIGURY VALUES (
    1, 
    MDSYS.SDO_GEOMETRY(
        2003, 
        NULL, 
        NULL,
        MDSYS.SDO_ELEM_INFO_ARRAY(1, 1003, 4),
        MDSYS.SDO_ORDINATE_ARRAY(
            5, 7, 
            7, 5, 
            5, 3
        )
    )
);

INSERT INTO FIGURY VALUES (
    2, 
    MDSYS.SDO_GEOMETRY(
        2003, 
        NULL, 
        NULL,
        MDSYS.SDO_ELEM_INFO_ARRAY(1, 1003, 3),
        MDSYS.SDO_ORDINATE_ARRAY(
            1, 1, 
            5, 5
        )
    )
);

INSERT INTO FIGURY VALUES (
    3, 
    MDSYS.SDO_GEOMETRY(
        2002, 
        NULL, 
        NULL,
        MDSYS.SDO_ELEM_INFO_ARRAY(
            1, 4, 2, 
            1, 2, 1, 
            5, 2, 2
        ),
        MDSYS.SDO_ORDINATE_ARRAY(
            3, 2, 
            6, 2, 
            7, 3, 
            8, 2, 
            7, 1
        )
    )
);

ZAD 1C
INSERT INTO FIGURY VALUES (
    4,
    MDSYS.SDO_GEOMETRY(
        2003,
        NULL,
        NULL,
        MDSYS.SDO_ELEM_INFO_ARRAY(1, 1003, 1),
        MDSYS.SDO_ORDINATE_ARRAY(
            1, 4,
            3, 6,
            6, 6,
            8, 4
        )
    )
);

ZAD 1D
SELECT ID, SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(KSZTALT, 0.1) AS VAL FROM FIGURY;
13348 [Element <1>] [Ring <1>]

ZAD 1E
DELETE FROM FIGURY 
WHERE SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(KSZTALT, 0.1) <> 'TRUE';

SELECT
    ID,
    SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(KSZTALT, 0.005) AS VAL
FROM FIGURY
ORDER BY ID;

ZAD 1F
COMMIT;