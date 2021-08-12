
/*==============================================================*/
/* SCRIPT : TP_BD_1                                             */
/*==============================================================*/

/*==============================================================*/
/* USER : etudiant1                                              */
/*==============================================================*/


DROP USER etudiant1 CASCADE;
CREATE USER etudiant1 IDENTIFIED BY pwd;
GRANT CONNECT, RESOURCE, DBA to etudiant1;

CONNECT etudiant1/pwd

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
      prixcomp  NUMBER(7)    NOT NULL ,
	  CONSTRAINT PK_NCOMP PRIMARY KEY (ncomp)
);

/*==============================================================*/
/* Table : COURSES                                              */
/*==============================================================*/
CREATE TABLE COURSES (
	nbat  NUMBER(3)  NOT NULL ,
	ncomp NUMBER(3)  NOT NULL ,
	score NUMBER(3)   NOT NULL ,
	CONSTRAINT PK_NBAT_NCOMP PRIMARY KEY (nbat , ncomp) ,
	CONSTRAINT FK_NBAT_COURSES_BATEAU FOREIGN KEY (nbat)
	REFERENCES BATEAU (nbat) ,
	CONSTRAINT FK_NCOMP_COURSES_COMPETITION FOREIGN KEY (ncomp) 
	REFERENCES COMPETITION (ncomp) 
);

/*==============================================================*/
/* Table : PARTICIPANTS                                               */
/*==============================================================*/
CREATE TABLE PARTICIPANTS (
    npart   NUMBER(3)   NOT NULL ,
    nompart VARCHAR2(40) NOT NULL ,
    nbat    NUMBER(3)   NOT NULL ,
	CONSTRAINT PK_NPART PRIMARY KEY (npart) ,
	CONSTRAINT FK_NBAT_PARTICIPANTS_BATEAU FOREIGN KEY (nbat) 
    REFERENCES BATEAU (nbat)	
);

/*==============================================================*/
/* Ajout : NbC                                               */
/*==============================================================*/

ALTER TABLE BATEAU ADD (NbC INTEGER) ;

/*==============================================================*/
/* Supprimer Attribut : Sponsor                                               */
/*==============================================================*/
	  
ALTER TABLE BATEAU DROP COLUMN sponsor ;

/*==============================================================*/
/* Rajout d'Attribut : Sponsor                                               */
/*==============================================================*/

ALter TABLE BATEAU ADD (sponsor VARCHAR2(40));

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
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (240 , 'COURSE DE LA LIBERTE' , '10/05/2007' , 1500000) ;
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
/* SUpprimer les Competitions effectuées avant 2003                                               */
/*==============================================================*/
DELETE FROM COMPETITION
WHERE datcomp<'01/01/2003';

/*==============================================================*/
/* Modification du Prix de la Competition N 210 + 50 000                                               */
/*==============================================================*/
UPDATE COMPETITION 
SET prixcomp = prixcomp + 50000
WHERE (ncomp = 210 );

/*==============================================================*/
/* Noms des Compétitions ayant le plus petit nombre de Bateaux                                               */
/*==============================================================*/
SELECT nomcomp 
FROM COMPETITION
WHERE ncomp IN
(SELECT ncomp
 FROM COURSES
 GROUP BY ncomp
 HAVING COUNT(nbat) =
 (SELECT MIN(COUNT(nbat))
  FROM COURSES
  GROUP BY ncomp
 )
);

/*==============================================================*/
/* Num Competition dansles quelles ont participé tous les Bateaux                                               */
/*==============================================================*/
SELECT ncomp
FROM COMPETITION
WHERE ncomp IN
(SELECT ncomp
 FROM COURSES
 GROUP BY ncomp
 HAVING COUNT(nbat) =
 (SELECT COUNT(*)
  FROM BATEAU
  )
 );
 
/*==============================================================*/
/* Noms des Bateaux Ayant gagné des courses                                               */
/*==============================================================*/
 SELECT u.nombat , v.nomcomp , v.datcomp , v.prixcomp
 FROM  BATEAU u , COMPETITION v , COURSES q
 WHERE u.nbat = q.nbat
 AND   v.ncomp = q.ncomp
 AND   q.score = 1 ;
 