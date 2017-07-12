DELETE FROM ss_stg.staging
;

INSERT INTO ss_stg.staging
    (dt
    ,Ticker
    ,Open
    ,High
    ,Close
    ,Volume
    ,Adjusted
    ,unique_id
    )

SELECT
    CAST(dt AS date)
    ,Ticker
    ,CAST(Open AS decimal(15,5))
    ,CAST(High AS decimal(15,5))
    ,CAST(Close AS decimal(15,5))
    ,CAST(Volume AS integer)
    ,CAST(Adjusted AS decimal(15,5))
    ,Ticker||CAST(EXTRACT(epoch FROM CAST(dt AS date)) AS integer)
    
FROM ss_ext.external
;