CREATE TABLE IF NOT EXISTS ss_ext.external
    (dt             varchar(30)
    ,Ticker         varchar(10)
    ,Open           varchar(20)
    ,High           varchar(20)
    ,Close          varchar(20)
    ,Volume         varchar(20)
    ,Adjusted       varchar(20)
);

COPY ss_ext.external FROM :'filepath' DELIMITER ',' CSV HEADER
;