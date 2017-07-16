INSERT INTO ss.audit
    (dt
    ,rows_staged
    ,rows_loaded
    ,date_loaded
    ,file_name
)

SELECT
    t1.dt
    ,t1.rows_staged
    ,t2.rows_loaded
    ,t2.date_loaded
    ,t2.file_name
    
FROM (
    SELECT
        COUNT(*) AS rows_staged
        ,dt
    FROM ss_stg.stg_price
    GROUP BY dt
) AS t1

LEFT OUTER JOIN (
    SELECT
        COUNT(*) AS rows_loaded
        ,dt
        ,current_date AS date_loaded
        ,:'filename' AS file_name
    FROM ss.price
        WHERE dt IN (SELECT dt FROM ss_stg.stg_price)
        GROUP BY dt
) AS t2

ON t1.dt = t2.dt

WHERE NOT EXISTS 

      ( SELECT 1 FROM ss.audit AS t0
        WHERE t0.dt = t1.dt
          AND t0.date_loaded = t2.date_loaded
      ) 
;
