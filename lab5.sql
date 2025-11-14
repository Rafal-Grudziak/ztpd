ZAD 1A
INSERT INTO VALUES (
    'FIGURY',
    'KSZTALT',
    MDSYS.SDO_DIM_ARRAY(
        MDSYS.SDO_DIM_ELEMENT('X', 1, 9, 0.01),
        MDSYS.SDO_DIM_ELEMENT('Y', 1, 8, 0.01)
    ),
    NULL
);


ZAD 1B
SELECT SDO_TUNE.ESTIMATE_RTREE_INDEX_SIZE(
           3000000,  -- docelowa liczba wierszy
           8192,     -- rozmiar bloku
           10,       -- SDO_RTR_PCTFREE
           2,        -- liczba wymiarów
           0         -- indeks niegeodezyjny
       ) AS szacowana_liczba_blokow
FROM dual;


ZAD 1C
CREATE INDEX FIGURY_SIDX
ON FIGURY (KSZTALT)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS (
  'SDO_INDX_DIMS=2'
);


ZAD 1D
SELECT ID
FROM FIGURY
WHERE SDO_FILTER(
    KSZTALT,
    MDSYS.SDO_GEOMETRY(
        2001,
        NULL,
        MDSYS.SDO_POINT_TYPE(3, 3, NULL),
        NULL,
        NULL
    ),
    'querytype=WINDOW'
) = 'TRUE';


ZAD 1E
SELECT ID
FROM FIGURY
WHERE SDO_RELATE(
    KSZTALT,
    MDSYS.SDO_GEOMETRY(
        2001,
        NULL,
        MDSYS.SDO_POINT_TYPE(3, 3, NULL),
        NULL,
        NULL
    ),
    'mask=ANYINTERACT querytype=WINDOW'
) = 'TRUE';


ZAD 2A
SELECT
    c2.city_name AS miasto,
    SDO_NN_DISTANCE(1) AS odl
FROM MAJOR_CITIES c2
WHERE SDO_NN(
    c2.geom,
    (SELECT geom
    FROM MAJOR_CITIES
    WHERE city_name = 'Warsaw'),
    'sdo_num_res=10 unit=KM',
    1
) = 'TRUE'
AND c2.city_name <> 'Warsaw';


ZAD 2B
SELECT
    c2.city_name AS miasto
FROM MAJOR_CITIES c2
WHERE SDO_WITHIN_DISTANCE(
    c2.geom,
    (
        SELECT geom
        FROM MAJOR_CITIES
        WHERE city_name = 'Warsaw'
    ),
    'distance=100 unit=KM'
) = 'TRUE'
  AND c2.city_name <> 'Warsaw';


ZAD 2C
SELECT
    cb.cntry_name AS kraj,
    mc.city_name  AS miasto
FROM COUNTRY_BOUNDARIES cb
JOIN MAJOR_CITIES mc
ON SDO_RELATE(
    mc.geom,
    cb.geom,
    'mask=INSIDE'
) = 'TRUE'
WHERE cb.cntry_name = 'Slovakia';


ZAD 2D 
SELECT B.CNTRY_NAME AS PANSTWO, SDO_GEOM.SDO_DISTANCE(A.GEOM, B.GEOM, 1, 'unit=km') ODL
FROM COUNTRY_BOUNDARIES A, COUNTRY_BOUNDARIES B
WHERE A.CNTRY_NAME = 'Poland' 
AND B.CNTRY_NAME <> 'Poland'
AND NOT SDO_RELATE(A.GEOM, B.GEOM, 'mask=TOUCH') = 'TRUE';


ZAD 3A 
WITH poland AS (
    SELECT geom
    FROM COUNTRY_BOUNDARIES
    WHERE cntry_name = 'Poland'
)
SELECT
    cb.cntry_name,
    SDO_GEOM.SDO_LENGTH(
        SDO_GEOM.SDO_INTERSECTION(
            cb.geom,
            (SELECT geom FROM poland),
            0.005
        ),
        0.005,
        'unit=KM'
    ) AS odleglosc
FROM COUNTRY_BOUNDARIES cb
WHERE cb.cntry_name <> 'Poland'
AND SDO_RELATE(
    cb.geom,
    (SELECT geom FROM poland),
    'mask=TOUCH'
) = 'TRUE';


ZAD 3B
SELECT cntry_name
FROM COUNTRY_BOUNDARIES
ORDER BY SDO_GEOM.SDO_AREA(
    geom,
    0.005,
    'unit=SQ_KM'
) DESC FETCH FIRST 1 ROW ONLY;


ZAD 3C
WITH w AS (
    SELECT geom
    FROM MAJOR_CITIES
    WHERE city_name = 'Warsaw'
),
l AS (
    SELECT geom
    FROM MAJOR_CITIES
    WHERE city_name = 'Lodz'
),
polacz AS (
    SELECT SDO_GEOM.SDO_UNION(
               (SELECT geom FROM w),
               (SELECT geom FROM l),
               0.005
           ) AS g
    FROM dual
)
SELECT SDO_GEOM.SDO_AREA(
    SDO_GEOM.SDO_MBR(g),
    0.005,
    'unit=SQ_KM'
) AS sq_km
FROM polacz;


ZAD 3D
WITH poland AS (
    SELECT geom
    FROM COUNTRY_BOUNDARIES
    WHERE cntry_name = 'Poland'
),
prague AS (
    SELECT geom
    FROM MAJOR_CITIES
    WHERE city_name = 'Prague'
)
SELECT SDO_GEOM.SDO_UNION(
    (SELECT geom FROM poland),
    (SELECT geom FROM prague),
    0.005
).sdo_gtype AS gtype
FROM dual;


ZAD 3E
SELECT C.CITY_NAME, B.CNTRY_NAME
FROM COUNTRY_BOUNDARIES B, MAJOR_CITIES C
ORDER BY ROUND(SDO_GEOM.SDO_DISTANCE(SDO_GEOM.SDO_CENTROID(B.GEOM,1), C.GEOM, 1, 'unit=km'))
FETCH FIRST 1 ROWS ONLY;


ZAD 3F
SELECT C.NAME, SUM(SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(B.GEOM, C.GEOM, 1), 1, 'unit=km')) AS DLUGOSC
FROM COUNTRY_BOUNDARIES B, RIVERS C
WHERE SDO_RELATE(
    C.GEOM, B.GEOM,
    'mask=ANYINTERACT'
) = 'TRUE'
AND B.CNTRY_NAME = 'Poland'
GROUP BY C.NAME;