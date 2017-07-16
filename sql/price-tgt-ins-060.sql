INSERT INTO ss.price
    (dt
    ,symbol
    ,open
    ,high
    ,close
    ,volume
    ,adjusted
    ,updated_ts
    ,unique_id
    )

SELECT
    dt
    ,symbol
    ,open
    ,high
    ,close
    ,volume
    ,adjusted
    ,updated_ts
    ,unique_id
    
FROM ss_stg.stg_price

WHERE (symbol, dt) NOT IN
    (SELECT symbol, dt FROM ss.price
    WHERE symbol IS NOT NULL
    AND dt IS NOT NULL)
;