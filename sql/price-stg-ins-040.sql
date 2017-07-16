INSERT INTO ss_stg.stg_price
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
    CAST(dt AS date)
    ,symbol
    ,CAST(open AS decimal(15,5))
    ,CAST(high AS decimal(15,5))
    ,CAST(close AS decimal(15,5))
    ,CAST(volume AS integer)
    ,CAST(adjusted AS decimal(15,5))
    ,current_date
    ,symbol||CAST(EXTRACT(epoch FROM CAST(dt AS date)) AS integer)
    
FROM ss_ext.ext_price
;