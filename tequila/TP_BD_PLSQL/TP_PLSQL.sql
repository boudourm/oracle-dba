/*==============================================================*/
/* SCRIPT : TP PL/SQL                                      */
/*==============================================================*/

--1)
CONNECT SYSTEM/pwd ;

DROP USER ALILAPOINTE CASCADE ;

CREATE USER ALILAPOINTE IDENTIFIED BY pwd ;
GRANT ALL PRIVILEGES TO ALILAPOINTE ;
CONNECT ALILAPOINTE/pwd ;

/*==============================================================*/
/* Table : BATEAU                                               */
/*==============================================================*/

CREATE TABLE BATEAU (
    nbat    NUMBER(3)   NOT NULL ,
	nombat  VARCHAR2(40) NOT NULL,
	sponsor VARCHAR2(40) NOT NULL ,
	CONSTRAINT PK_NBAT PRIMARY KEY (nbat)
);

/*==============================================================*/
/* Table : COMPETITION                                              */
/*==============================================================*/
CREATE TABLE COMPETITION (
      ncomp     NUMBER(3)   NOT NULL ,
	  nomcomp   VARCHAR2(40) NOT NULL ,
      datcomp   DATE         NOT NULL ,
      prixcomp  NUMBER(10)    NOT NULL ,
	  CONSTRAINT PK_NCOMP PRIMARY KEY (ncomp)
);

/*==============================================================*/
/* BATEAU                                        */
/*==============================================================*/
INSERT INTO BATEAU (nbat , nombat , sponsor) VALUES (102 , 'TASSILI' , 'DJEZZY') ;
INSERT INTO BATEAU (nbat , nombat , sponsor) VALUES (103 , 'El BAHDJA' , 'BNA') ;
INSERT INTO BATEAU (nbat , nombat , sponsor) VALUES (104 , 'LA COLOMBE' , 'OOREDOO') ;
INSERT INTO BATEAU (nbat , nombat , sponsor) VALUES (105 , 'HOGGAR' , 'BNA') ;


/*==============================================================*/
/* COMPETITION                                               */
/*==============================================================*/
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (200 , 'LE GRAND TOUR' , '21/03/200' , 1000000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (210 , 'COURSE DE LA LIBERTE' , '05/05/2004' , 1000000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (215 , 'LE GRAND TOUR' , '20/03/2005' , 1100000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (220 , 'TROPHEE BARBEROUSSE' , '01/08/2005' , 1500000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (240 , 'COURSE DE LA LIBERTE' , '10/05/2007' , 1500000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (260 , 'TROPHEE BARBEROUSSE' , '01/08/2009' , 2000000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (265 , 'LE GRAND TOUR' , '21/03/2010' , 2000000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (270 , 'COURSE DE LA LIBERTE' , '08/05/2010' , 1800000) ;


--2) 
SET SERVEROUTPUT ON ;
DECLARE 

CURSOR cr IS SELECT * FROM COMPETITION ;
c cr%ROWTYPE ;

BEGIN 
     FOR c IN cr LOOP
	     DBMS_OUTPUT.PUT_LINE('La Competition N° '||c.ncomp||' nommée '||c.nomcomp||'	 s"est produit le '||c.datcomp);
         EXIT WHEN cr%NOTFOUND ;
     END LOOP ;
END;
/











































