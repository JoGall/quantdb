DELETE FROM ss.stock_price
;

INSERT INTO ss.stock_price
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
    dt
    ,Ticker
    ,Open
    ,High
    ,Close
    ,Volume
    ,Adjusted
    ,unique_id
    
FROM ss_stg.staging

WHERE (Ticker, dt) NOT IN
    (SELECT Ticker, dt FROM ss.stock_price
    WHERE Ticker IS NOT NULL
    AND dt IS NOT NULL)
;