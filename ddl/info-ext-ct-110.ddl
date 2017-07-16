DROP TABLE IF EXISTS ss_ext.ext_info;

CREATE TABLE ss_ext.ext_info
    (symbol         varchar(10)
    ,name           varchar(100)
    ,last_sale      varchar(30)
    ,market_cap     varchar(30)
    ,IPO_year       varchar(20)
    ,sector         varchar(100)
    ,industry       varchar(100)
    ,exchange       varchar(20)
);