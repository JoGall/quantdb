INSERT INTO ss.info
    (symbol
    ,name
    ,last_sale
    ,market_cap
    ,IPO_year
    ,sector
    ,industry
    ,exchange
    )

SELECT
    symbol
    ,name
    ,last_sale
    ,market_cap
    ,IPO_year
    ,sector
    ,industry
    ,exchange
    
FROM ss_ext.ext_info
;