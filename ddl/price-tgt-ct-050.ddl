DROP TABLE IF EXISTS ss.price;

CREATE TABLE ss.price
    (dt             date
    ,symbol         varchar(10)
    ,open           decimal(15,5)
    ,high           decimal(15,5)
    ,close          decimal(15,5)
    ,volume         integer
    ,adjusted       decimal(15,5)
    ,updated_ts     varchar(30)
    ,unique_id      varchar(50)
);