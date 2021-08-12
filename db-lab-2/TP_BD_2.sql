/*==============================================================*/
/* System                      */
/*==============================================================*/
CONNECT system/pwd;	


/*==============================================================*/
/* SCRIPT : TP_BD_2                                            */
/*==============================================================*/

/*==============================================================*/
/* USER : etudiant2                                              */
/*==============================================================*/


DROP USER etudiant2 CASCADE;
CREATE USER etudiant2 IDENTIFIED BY pwd;
GRANT CONNECT, RESOURCE, DBA to etudiant2;

CONNECT etudiant2/pwd

/*==============================================================*/
/*  Création du Modèle de Données                      */
/*==============================================================*/


/*
DROP TABLE BATEAU CASCADE CONSTRAINTS ;
DROP TABLE COMPETITION CASCADE CONSTRAINTS ; 
DROP TABLE COURSES CASCADE CONSTRAINTS   ;
DROP TABLE PARTICIPANTS CASCADE CONSTRAINTS  ;
*/
/*==============================================================*/
/* Table : BATEAU                                               */
/*==============================================================*/

CREATE TABLE BATEAU (
    nbat    NUMBER(3)    PRIMARY KEY,
	nombat  VARCHAR2(40) ,
	sponsor VARCHAR2(40)  
);

/*==============================================================*/
/* Table : COMPETITION                                              */
/*==============================================================*/
CREATE TABLE COMPETITION (
      ncomp     NUMBER(3)    PRIMARY KEY,
	  nomcomp   VARCHAR2(40)  ,
      datcomp   DATE          ,
      prixcomp  NUMBER(7)     
);

/*==============================================================*/
/* Table : COURSES                                              */
/*==============================================================*/
CREATE TABLE COURSES (
	nbat  NUMBER(3)   ,
	ncomp NUMBER(3)   ,
	score NUMBER(3)   ,
    CONSTRAINT PK_NBAT_NCOMP PRIMARY KEY (nbat , ncomp)  	
);

/*==============================================================*/
/* Table : PARTICIPANTS                                               */
/*==============================================================*/
CREATE TABLE PARTICIPANTS (
    npart   NUMBER(3)   PRIMARY KEY ,
    nompart VARCHAR2(40)  ,
    nbat    NUMBER(3)    
);


/*==============================================================*/
/* INSERTION : tuples des Tables                                               */
/*==============================================================*/

/*==============================================================*/
/* BATEAU                                        */
/*==============================================================*/
INSERT INTO BATEAU (nbat , nombat , sponsor) VALUES (102 , 'TASSILI' , 'DJEZZY') ;
INSERT INTO BATEAU (nbat , nombat , sponsor) VALUES (103 , 'El BAHDJA' , 'BNA') ;
INSERT INTO BATEAU (nbat , nombat , sponsor) VALUES (104 , 'LA COLOMBE' , 'NEDJMA') ;
INSERT INTO BATEAU (nbat , nombat , sponsor) VALUES (105 , 'HOGGAR' , 'BNA') ;


/*==============================================================*/
/* COMPETITION                                               */
/*==============================================================*/
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (200 , 'LE GRAND TOUR' , '21/03/200' , 1000000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (210 , 'COURSE DE LA LIBERTE' , '05/05/2004' , 1000000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (215 , 'LE GRAND TOUR' , '20/03/2005' , 1100000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (220 , 'TROPHEE BARBEROUSSE' , '01/08/2005' , 1500000) ;
INSERT INTO COMPETITION 	(ncomp , nomcomp , datcomp , prixcomp) VALUES (240 , 'COURSE DE LA LIBERTE' , '10/05/2007' , 1500000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (260 , 'TROPHEE BARBEROUSSE' , '01/08/2009' , 2000000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (265 , 'LE GRAND TOUR' , '21/03/2010' , 2000000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp)VALUES (270 , 'COURSE DE LA LIBERTE' , '08/05/2010' , 1800000) ;

/*==============================================================*/
/* COURSES                                               */
/*==============================================================*/
INSERT INTO COURSES (nbat , ncomp , score) VALUES (102 , 210 , 2) ;
INSERT INTO COURSES (nbat , ncomp , score) VALUES (102 , 240 , 1) ;
INSERT INTO COURSES (nbat , ncomp , score) VALUES (102 , 270 , 4) ;
INSERT INTO COURSES (nbat , ncomp , score) VALUES (103 , 210 , 4) ;
INSERT INTO COURSES (nbat , ncomp , score) VALUES (103 , 215 , 3) ;
INSERT INTO COURSES (nbat , ncomp , score) VALUES (104 , 210 , 1) ;
INSERT INTO COURSES (nbat , ncomp , score) VALUES (104 , 215 , 2) ;
INSERT INTO COURSES (nbat , ncomp , score) VALUES (104 , 220 , 4) ;
INSERT INTO COURSES (nbat , ncomp , score) VALUES (104 , 240 , 3) ;
INSERT INTO COURSES (nbat , ncomp , score) VALUES (104 , 260 , 5) ;
INSERT INTO COURSES (nbat , ncomp , score) VALUES (104 , 265 , 1) ;
INSERT INTO COURSES (nbat , ncomp , score) VALUES (104 , 270 , 3) ;
INSERT INTO COURSES (nbat , ncomp , score) VALUES (105 , 210 , 3) ;
INSERT INTO COURSES (nbat , ncomp , score) VALUES (105 , 215 , 1) ;

/*==============================================================*/
/* PARTICIPANTS                                               */
/*==============================================================*/
INSERT INTO PARTICIPANTS VALUES (320 , 'MOHAMMED' , 104) ;
INSERT INTO PARTICIPANTS VALUES (470 , 'ALI' , 103) ;
INSERT INTO PARTICIPANTS VALUES (601 , 'OMAR' , 102) ;
INSERT INTO PARTICIPANTS VALUES (720 , 'MUSTAFA' , 105) ;

/*==============================================================*/
/* COMMIT                                                       */
/*==============================================================*/

COMMIT ;

/*==============================================================*/
/* CREATION des VUES                      */
/*==============================================================*/

CREATE VIEW ListeBateaux (nbat , nombat ) AS (
SELECT nbat , nombat 
FROM BATEAU 
);

SELECT * FROM ListeBateaux ;

INSERT INTO BATEAU VALUES (106 , 'SIRTA' , 'CEVITAL');

SELECT * FROM ListeBateaux ;

/*==============================================================*/
/* Remarque :                      */
/*==============================================================*/

CREATE VIEW ListeNomsBateaux (nombat) AS (
SELECT Nombat 
FROM BATEAU
);

SELECT * FROM ListeNomsBateaux ;

CREATE VIEW CompBateau (Ncomp , NbBat) As (
SELECT Ncomp , COUNT(Nbat)
FROM COURSES
GROUP BY (Ncomp) 
);

SELECT * FROM CompBateau ;

INSERT INTO COURSES VALUES (102 , 220 , 3);
INSERT INTO COURSES VALUES (102 , 265 , 2);

SELECT * FROM CompBateau ;

SELECT u.Nomcomp  
FROM CompBateau v , COMPETITION u
WHERE u.Ncomp = v.ncomp
AND NbBat = 
(
SELECT MIN(NbBat)
FROM CompBateau
);

SELECT Ncomp 
FROM CompBateau
WHERE NbBat = 
(
SELECT COUNT(*)
FROM BATEAU
);



/*==============================================================*/
/* MAJ au travers des VIEW                      */
/*==============================================================*/
INSERT INTO ListeBateaux VALUES (107 , 'TOUTAREG'  );



SELECT * FROM ListeBateaux ;

SELECT * FROM BATEAU ;

DELETE FROM ListeBateaux WHERE (nbat = 107);
INSERT INTO ListeBateaux VALUES (107 , 'TOUTAREG'  );

UPDATE ListeBateaux SET nombat = 'Modification' WHERE (nbat = 107);
UPDATE ListeBateaux SET nombat = 'TOUTAREG' WHERE (nbat = 107);


INSERT INTO LISTENOMSBATEAUX VALUES ('ILLUSION');

/*==============================================================*/
/* Remarque :                                                   */
/*==============================================================*/


CREATE TABLE COURSES2 (
	nbat  NUMBER(3)   ,
	ncomp NUMBER(3)  ,
	score NUMBER(3)   
);

INSERT INTO COURSES2 (SELECT * FROM COURSES) ;

CREATE VIEW VBateau AS SELECT nbat FROM COURSES2 GROUP BY nbat ;

INSERT INTO VBateau VALUES (103);
INSERT INTO VBateau VALUES (109);

SELECT * FROM COURSES2 ;

/*==============================================================*/
/* REMARQUE :                      */
/*==============================================================*/

CREATE OR REPLACE VIEW VBateau (nbat , nbr) AS (SELECT nbat , COUNT(*) FROM COURSES2 GROUP BY nbat );

SELECT * FROM VBateau ;

CREATE OR REPLACE VIEW VBateau (nbat , nbr) AS
SELECT nbat , COUNT(*) 
FROM COURSES2 
WHERE ncomp IS NOT NULL
GROUP BY nbat ;

SELECT * FROM VBateau ;


INSERT INTO VBateau VALUES (108,3);

INSERT INTO CompBateau VALUES (103,2) ;


CREATE VIEW VueJointure (Nombat , Ncomp) AS (
SELECT u.Nombat , v.Ncomp
FROM  BATEAU u , COURSES v
WHERE u.nbat = v.nbat 
);

SELECT * FROM VueJointure ;
INSERT INTO VueJointure VALUES ('BATEAU INSERÉ' , 800);

/*==============================================================*/
/* Parie 3                      */
/*==============================================================*/
		
CREATE NO FORCE VIEW VNoForce 
       AS SELECT nbat , nomP FROM bateau x , proprietaire y WHERE x.nbat = y.nbat;
	   
CREATE FORCE VIEW VForce 
       AS SELECT nbat , nomP FROM bateau x , proprietaire y WHERE x.nbat = y.nbat ;

CREATE OR REPLACE VIEW ListeBateaux (nbat , nombat ) AS (
SELECT nbat , nombat 
FROM BATEAU )	   
WITH READ ONLY 
;
	   
INSERT INTO ListeBateaux VALUES (108 , 'TOUAREG2');

CREATE VIEW Comp_Apres_2006 (Ncomp , Nomcomp , Datcomp) AS (
SELECT Ncomp , Nomcomp , Datcomp
FROM COMPETITION
WHERE Datcomp > '31/12/2006'
);

SELECT * FROM Comp_Apres_2006 ;

INSERT INTO Comp_Apres_2006 VALUES (211 , 'LE GRAND TOUR' , '20/03/2003');

CREATE OR REPLACE VIEW Comp_Apres_2006 (Ncomp , Nomcomp , Datcomp) AS (
SELECT Ncomp , Nomcomp , Datcomp
FROM COMPETITION
WHERE Datcomp > '31/12/2006'
)
WITH CHECK OPTION;

SELECT * FROM Comp_Apres_2006;

INSERT INTO Comp_Apres_2006 VALUES (212 , 'LE GRAND TOUR' , '20/03/2004');


/*==============================================================*/
/* System                      */
/*==============================================================*/
CONNECT system/pwd;	