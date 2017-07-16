DROP TABLE IF EXISTS ss.audit;

CREATE TABLE ss.audit (
    dt                  date
    ,rows_staged        integer
    ,rows_loaded        integer
    ,new_target         integer
    ,date_loaded        date
    ,file_name          varchar(100)
);
