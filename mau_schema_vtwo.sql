-- Capture run of script in file called mau_schema_vtwo_output.txt
set echo on
SPOOL mau_schema_vtwo_output.txt

-- Generated by Oracle SQL Developer Data Modeler 23.1.0.087.0806
--   at:        2024-02-05 13:54:43 AEDT
--   site:      Oracle Database 12c
--   type:      Oracle Database 12c
--   name:      Ethan Neyland


DROP TABLE address CASCADE CONSTRAINTS;

DROP TABLE artist CASCADE CONSTRAINTS;

DROP TABLE artwork CASCADE CONSTRAINTS;

DROP TABLE artwork_media_desc CASCADE CONSTRAINTS;

DROP TABLE artwork_status CASCADE CONSTRAINTS;

DROP TABLE artwork_style CASCADE CONSTRAINTS;

DROP TABLE customer CASCADE CONSTRAINTS;

DROP TABLE exhibit CASCADE CONSTRAINTS;

DROP TABLE gallery CASCADE CONSTRAINTS;

DROP TABLE sale CASCADE CONSTRAINTS;

-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE address (
    address_id       NUMBER(7) NOT NULL,
    address_number   VARCHAR2(20 CHAR) NOT NULL,
    address_street   VARCHAR2(50 CHAR) NOT NULL,
    address_city     VARCHAR2(50 CHAR) NOT NULL,
    address_state    VARCHAR2(3 CHAR) NOT NULL,
    address_postcode CHAR(4 CHAR) NOT NULL
);

ALTER TABLE address
    ADD CHECK ( address_state IN ( 'ACT', 'NSW', 'NT', 'QLD', 'SA',
                                   'TAS', 'VIC', 'WA' ) );

COMMENT ON COLUMN address.address_id IS
    'Address ID Number';

COMMENT ON COLUMN address.address_number IS
    'Address House/Property Number of Street Address.
    Can contain numbers, letters, special characters.
    E.g.  U5/12 123-125 (Thomsons Road)';

COMMENT ON COLUMN address.address_street IS
    'Address Street Name and Street Type, e.g. Thomson Avenue';

COMMENT ON COLUMN address.address_city IS
    'Address City/Town/Suburb Name, respective to the provided postcode';

COMMENT ON COLUMN address.address_state IS
    'Address State within AUSTRALIA, 2-3 Chars representing full-name. 
    States: VIC, TAS, NSW, SA, WA, NT, QLD, ACT.';

COMMENT ON COLUMN address.address_postcode IS
    'Address Postcode (4 numeric chars) e.g. 3095';

ALTER TABLE address ADD CONSTRAINT address_pk PRIMARY KEY ( address_id );

CREATE TABLE artist (
    artist_id             NUMBER(7) NOT NULL,
    address_id            NUMBER(7) NOT NULL,
    artist_givname        VARCHAR2(50 CHAR) NOT NULL,
    artist_famname        VARCHAR2(50 CHAR) NOT NULL,
    artist_phone          CHAR(10 CHAR) DEFAULT NULL,
    artist_total_stock    NUMBER(5),
    artist_recommended_by NUMBER(7)
);

COMMENT ON COLUMN artist.artist_id IS
    'Artist ID Number';

COMMENT ON COLUMN artist.address_id IS
    'Address ID Number';

COMMENT ON COLUMN artist.artist_givname IS
    'Artist First/Given Name';

COMMENT ON COLUMN artist.artist_famname IS
    'Artist Family/Last Name';

COMMENT ON COLUMN artist.artist_phone IS
    'Artist Phone Number (optional)
    Requires exactly 10 Numeric Chars
    e.g. 0423456789 or 6123456789';

COMMENT ON COLUMN artist.artist_total_stock IS
    'Artist''s Total no. of Artworks in MAU Stock';

COMMENT ON COLUMN artist.artist_recommended_by IS
    'Artist ID Number';

ALTER TABLE artist ADD CONSTRAINT artist_pk PRIMARY KEY ( artist_id );

CREATE TABLE artwork (
    artwork_id            NUMBER(7) NOT NULL,
    artist_id             NUMBER(7) NOT NULL,
    artwork_no            NUMBER(3) NOT NULL,
    artstyle_id           NUMBER(7) NOT NULL,
    artmedia_id           NUMBER(7) NOT NULL,
    artwork_title         VARCHAR2(50 CHAR) NOT NULL,
    artwork_date_accepted DATE NOT NULL
);

COMMENT ON COLUMN artwork.artwork_id IS
    'Artwork ID Number';

COMMENT ON COLUMN artwork.artist_id IS
    'Artist ID Number';

COMMENT ON COLUMN artwork.artwork_no IS
    'Artwork Number (relative to Artist''s Artworks registered with MAU)
    e.g. 1, 2, 3, .. , 10, .. , 100';

COMMENT ON COLUMN artwork.artwork_title IS
    'Artwork Title';

COMMENT ON COLUMN artwork.artwork_date_accepted IS
    'Date Artwork Accepted into MAU';

ALTER TABLE artwork ADD CONSTRAINT artwork_pk PRIMARY KEY ( artwork_id );

ALTER TABLE artwork ADD CONSTRAINT artwork_nk UNIQUE ( artist_id,
                                                       artwork_no );

CREATE TABLE artwork_media_desc (
    artmedia_id   NUMBER(7) NOT NULL,
    artmedia_name VARCHAR2(50 CHAR) NOT NULL
);

ALTER TABLE artwork_media_desc ADD CONSTRAINT artwork_media_desc_pk PRIMARY KEY ( artmedia_id
);

CREATE TABLE artwork_status (
    art_status_id   NUMBER(7) NOT NULL,
    art_status_date DATE NOT NULL,
    art_status_cat  NUMBER(1) NOT NULL,
    artwork_id      NUMBER(7) NOT NULL,
    gallery_id      NUMBER(7) DEFAULT NULL
);

ALTER TABLE artwork_status
    ADD CHECK ( art_status_cat IN ( 'd', 'r', 's', 't', 'w' ) );

COMMENT ON COLUMN artwork_status.art_status_id IS
    'Art Status ID Number';

COMMENT ON COLUMN artwork_status.art_status_date IS
    'Art Status Date';

COMMENT ON COLUMN artwork_status.art_status_cat IS
    'Status Category of Artwork (1 CHAR: Status Cat.): 
    W for in MAU Warehouse, 
    T for in Transit to Gallery,
    D for on Display by a Gallery,
    S for Sold,
    R for Returned to Artist';

COMMENT ON COLUMN artwork_status.artwork_id IS
    'Artwork ID Number';

COMMENT ON COLUMN artwork_status.gallery_id IS
    'Gallery ID Number';

ALTER TABLE artwork_status ADD CONSTRAINT artwork_status_pk PRIMARY KEY ( art_status_id
);

ALTER TABLE artwork_status
    ADD CONSTRAINT artwork_status_nk UNIQUE ( art_status_date,
                                              art_status_cat,
                                              artwork_id );

CREATE TABLE artwork_style (
    artstyle_id   NUMBER(7) NOT NULL,
    artstyle_name VARCHAR2(50 CHAR) NOT NULL
);

ALTER TABLE artwork_style ADD CONSTRAINT artwork_style_pk PRIMARY KEY ( artstyle_id )
;

CREATE TABLE customer (
    customer_id       NUMBER(7) NOT NULL,
    address_id        NUMBER(7) NOT NULL,
    customer_givname  VARCHAR2(50 CHAR) NOT NULL,
    customer_famname  VARCHAR2(50 CHAR) NOT NULL,
    customer_phone    CHAR(10 CHAR) NOT NULL,
    customer_business VARCHAR2(50 CHAR) DEFAULT NULL
);

COMMENT ON COLUMN customer.customer_id IS
    'Customer ID Number';

COMMENT ON COLUMN customer.address_id IS
    'Address ID Number';

COMMENT ON COLUMN customer.customer_givname IS
    'Customer Given Name';

COMMENT ON COLUMN customer.customer_famname IS
    'Customer Family Name';

COMMENT ON COLUMN customer.customer_phone IS
    'Customer Phone No (limited/fixed to 10 characters length)';

COMMENT ON COLUMN customer.customer_business IS
    'Customer Business Name (NULLABLE)';

ALTER TABLE customer ADD CONSTRAINT customer_pk PRIMARY KEY ( customer_id );

CREATE TABLE exhibit (
    exhibit_id           NUMBER(7) NOT NULL,
    gallery_id           NUMBER(7) NOT NULL,
    artwork_id           NUMBER(7) NOT NULL,
    exhibit_start_date   DATE NOT NULL,
    exhibit_end_date     DATE NOT NULL,
    exhibit_catalog_feat CHAR(1 CHAR) NOT NULL
);

ALTER TABLE exhibit
    ADD CHECK ( exhibit_catalog_feat IN ( 'N', 'Y' ) );

COMMENT ON COLUMN exhibit.exhibit_id IS
    'Exhibit ID Number';

COMMENT ON COLUMN exhibit.gallery_id IS
    'Gallery ID Number';

COMMENT ON COLUMN exhibit.artwork_id IS
    'Artwork ID Number';

COMMENT ON COLUMN exhibit.exhibit_start_date IS
    'Exhibit Start Date';

COMMENT ON COLUMN exhibit.exhibit_end_date IS
    'Exhibit End Date';

COMMENT ON COLUMN exhibit.exhibit_catalog_feat IS
    'Exhibit Catalogue Feature (1CHAR: Y/N)';

ALTER TABLE exhibit ADD CONSTRAINT exhibit_pk PRIMARY KEY ( exhibit_id );

ALTER TABLE exhibit
    ADD CONSTRAINT exhibit_nk UNIQUE ( gallery_id,
                                       exhibit_start_date,
                                       artwork_id );

CREATE TABLE gallery (
    gallery_id              NUMBER(7) NOT NULL,
    address_id              NUMBER(7) NOT NULL,
    gallery_name            VARCHAR2(50 CHAR) NOT NULL,
    gallery_manager_givname VARCHAR2(50 CHAR) NOT NULL,
    gallery_manager_famname VARCHAR2(50 CHAR) NOT NULL,
    gallery_phone           VARCHAR2(10 CHAR) NOT NULL,
    gallery_comm_percent    NUMBER(5, 2) NOT NULL,
    gallery_opentime        CHAR(5 CHAR) NOT NULL,
    gallery_closetime       CHAR(5 CHAR) NOT NULL
);

COMMENT ON COLUMN gallery.gallery_id IS
    'Gallery ID Number';

COMMENT ON COLUMN gallery.address_id IS
    'Address ID Number';

COMMENT ON COLUMN gallery.gallery_name IS
    'Gallery Name';

COMMENT ON COLUMN gallery.gallery_manager_givname IS
    'Gallery Manager''s Given/First Name';

COMMENT ON COLUMN gallery.gallery_manager_famname IS
    'Gallery Manager''s Family Name/Surname';

COMMENT ON COLUMN gallery.gallery_phone IS
    'Gallery Phone Number
    Requires exactly 10 Numeric Chars
    e.g. 0423456789 or 6123456789';

COMMENT ON COLUMN gallery.gallery_comm_percent IS
    'Gallery Commission Percent.
    Up to 100.00% (5 digits, 2dp)';

COMMENT ON COLUMN gallery.gallery_opentime IS
    'Time in the format HH:MM (24-hour time)';

COMMENT ON COLUMN gallery.gallery_closetime IS
    'Time in the format HH:MM (24-hour time)';

ALTER TABLE gallery ADD CONSTRAINT gallery_pk PRIMARY KEY ( gallery_id );

CREATE TABLE sale (
    sale_id     NUMBER(7) NOT NULL,
    customer_id NUMBER(7) NOT NULL,
    exhibit_id  NUMBER(7) NOT NULL,
    sale_date   DATE NOT NULL,
    sale_price  NUMBER(7) NOT NULL
);

COMMENT ON COLUMN sale.sale_id IS
    'Sale ID Number';

COMMENT ON COLUMN sale.customer_id IS
    'Customer ID Number';

COMMENT ON COLUMN sale.exhibit_id IS
    'Exhibit ID Number';

COMMENT ON COLUMN sale.sale_date IS
    'Date of Sale';

COMMENT ON COLUMN sale.sale_price IS
    'Price of Sale';

CREATE UNIQUE INDEX sale__idx ON
    sale (
        exhibit_id
    ASC );

ALTER TABLE sale ADD CONSTRAINT sale_pk PRIMARY KEY ( sale_id );

ALTER TABLE artist
    ADD CONSTRAINT address_artist FOREIGN KEY ( address_id )
        REFERENCES address ( address_id );

ALTER TABLE customer
    ADD CONSTRAINT address_customer FOREIGN KEY ( address_id )
        REFERENCES address ( address_id );

ALTER TABLE gallery
    ADD CONSTRAINT address_gallery FOREIGN KEY ( address_id )
        REFERENCES address ( address_id );

ALTER TABLE artist
    ADD CONSTRAINT artist_artist FOREIGN KEY ( artist_recommended_by )
        REFERENCES artist ( artist_id );

ALTER TABLE artwork
    ADD CONSTRAINT artist_artwork FOREIGN KEY ( artist_id )
        REFERENCES artist ( artist_id );

ALTER TABLE artwork
    ADD CONSTRAINT artmedia_artwork FOREIGN KEY ( artmedia_id )
        REFERENCES artwork_media_desc ( artmedia_id );

ALTER TABLE artwork
    ADD CONSTRAINT artstyle_artwork FOREIGN KEY ( artstyle_id )
        REFERENCES artwork_style ( artstyle_id );

ALTER TABLE artwork_status
    ADD CONSTRAINT artwork_artstatus FOREIGN KEY ( artwork_id )
        REFERENCES artwork ( artwork_id );

ALTER TABLE exhibit
    ADD CONSTRAINT artwork_exhibit FOREIGN KEY ( artwork_id )
        REFERENCES artwork ( artwork_id );

ALTER TABLE sale
    ADD CONSTRAINT customer_sale FOREIGN KEY ( customer_id )
        REFERENCES customer ( customer_id );

ALTER TABLE sale
    ADD CONSTRAINT exhibit_sale FOREIGN KEY ( exhibit_id )
        REFERENCES exhibit ( exhibit_id );

ALTER TABLE artwork_status
    ADD CONSTRAINT gallery_artstatus FOREIGN KEY ( gallery_id )
        REFERENCES gallery ( gallery_id );

ALTER TABLE exhibit
    ADD CONSTRAINT gallery_exhibit FOREIGN KEY ( gallery_id )
        REFERENCES gallery ( gallery_id );



-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                            10
-- CREATE INDEX                             1
-- ALTER TABLE                             29
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- TSDP POLICY                              0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0

SPOOL off
set echo off