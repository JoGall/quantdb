CREATE TABLE IF NOT EXISTS ss_stg.staging
    (dt             date
    ,Ticker         varchar(10)
    ,Open           decimal(15,5)
    ,High           decimal(15,5)
    ,Close          decimal(15,5)
    ,Volume         integer
    ,Adjusted       decimal(15,5)
    ,unique_id      varchar(50)
);