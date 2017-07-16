DROP TABLE IF EXISTS ss_ext.ext_price;

CREATE TABLE ss_ext.ext_price
    (dt             varchar(30)
    ,symbol         varchar(10)
    ,open           varchar(20)
    ,high           varchar(20)
    ,close          varchar(20)
    ,volume         varchar(20)
    ,adjusted       varchar(20)
);