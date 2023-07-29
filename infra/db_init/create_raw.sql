CREATE SCHEMA IF NOT EXISTS raw;

CREATE TABLE IF NOT EXISTS raw.raw__weight_daily (
    record__ts        VARCHAR,
    weight            VARCHAR,

    CONSTRAINT raw_weight_prim_key PRIMARY KEY (record__ts) 
);