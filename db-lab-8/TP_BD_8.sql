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

--3)
DECLARE
CURSOR cr1 IS SELECT nbat ,nombat  FROM BATEAU  WHERE sponsor = 'DJEZZY'  ;
b cr1%ROWTYPE ;
CURSOR cr2 IS SELECT ncomp ,nomcomp  FROM COMPETITION  WHERE datcomp<='31/12/2010' AND datcomp >= '01/01/2010';
c cr1%ROWTYPE ;
BEGIN 
DBMS_OUTPUT.PUT_LINE('Voici les bateaux sponsorisés par DJEZZY : ');
FOR b IN cr1 LOOP
	     DBMS_OUTPUT.PUT_LINE('N° : '||b.nbat||' Nom : '||b.nombat||' .');
         EXIT WHEN cr1%NOTFOUND ;
     END LOOP ;
	 
DBMS_OUTPUT.PUT_LINE('Voici les Competition de  de l"année 2010 : ');
FOR c IN cr2 LOOP
	     DBMS_OUTPUT.PUT_LINE('N° : '||c.ncomp||' Nom : '||c.nomcomp|| ' .');
         EXIT WHEN cr2%NOTFOUND ;
     END LOOP ; 
END;
/




--5)
ALTER TABLE COMPETITION
ADD PREMIER NUMBER(3)  ;

--6)
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

--7)
CREATE OR REPLACE TRIGGER  TRIG_COURSES 
AFTER INSERT OR DELETE OR UPDATE OF Score ON COURSES 
FOR EACH ROW
BEGIN
     IF INSERTING THEN
         UPDATE COMPETITION
		 SET PREMIER = :New.nbat
		 WHERE :New.Score = 1 
		 AND   :New.Ncomp = Ncomp ; 
	 END IF;
	 IF DELETING THEN
		 UPDATE COMPETITION 
		 SET PREMIER = NULL
		 WHERE ncomp = :Old.ncomp
		 AND   PREMIER = :Old.nbat ;	 
	 END IF;
	 IF UPDATING THEN
		 UPDATE COMPETITION
		 SET PREMIER = :Old.nbat
		 WHERE :Old.score <> 1
		 AND   :New.score = 1
		 AND   :Old.ncomp = ncomp ;
		 
		 UPDATE COMPETITION
		 SET PREMIER = NULL 
		 WHERE :Old.score = 1
		 AND   :New.score <> 1
		 AND   :New.ncomp = ncomp;	 
	 END IF;
END;
/ 

--TESTS
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

SELECT * FROM COMPETITION ;

UPDATE COURSES
SET score = 1 
WHERE ncomp = 270 AND nbat = 102 ;

SELECT * FROM COMPETITION ;

UPDATE COURSES
SET score = 10 
WHERE ncomp = 240 AND nbat = 102 ;

SELECT * FROM COMPETITION ;

DELETE FROM COURSES
WHERE ncomp = 215 AND nbat = 105 ;

SELECT * FROM COMPETITION ;

--4)
CREATE OR REPLACE  PROCEDURE BateauCourse(x IN INTEGER) IS

CURSOR cr IS SELECT u.nbat ,u.nombat
             FROM BATEAU u , COURSES v  
			 WHERE u.nbat = v.nbat  
			 GROUP BY u.nbat ,u.nombat
			 HAVING COUNT(*) > x;
b cr%ROWTYPE ;
BEGIN
     DBMS_OUTPUT.PUT_LINE('Voici les Bateaux Ayant fait plus de '||x||' courses : ');
     FOR b IN cr LOOP
	     DBMS_OUTPUT.PUT_LINE('N° : '||b.nbat||' Nom : '||b.nombat||' .');
         EXIT WHEN cr%NOTFOUND ;
     END LOOP ;
END ;
/
--TESTS
EXECUTE BateauCourse(2);


--8)
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
/* PARTICIPANTS                                               */
/*==============================================================*/
INSERT INTO PARTICIPANTS VALUES (320 , 'MOHAMMED' , 104) ;
INSERT INTO PARTICIPANTS VALUES (470 , 'ALI' , 103) ;
INSERT INTO PARTICIPANTS VALUES (601 , 'OMAR' , 102) ;
INSERT INTO PARTICIPANTS VALUES (720 , 'MUSTAFA' , 105) ;

-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------SCREEN SHOTS
-----------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE  PROCEDURE ParticipantBateau (s IN BATEAU.sponsor%TYPE) IS
--CURSOR
CURSOR cr IS SELECT u.npart , u.nompart  
             FROM PARTICIPANTS u , BATEAU v  
			 WHERE u.nbat = v.nbat 
			 AND      v.sponsor = s  ;
p cr%ROWTYPE ;
--EXCEPTIONS
NBR_SELECTION INTEGER ;
AUCUN_BATEAU_SPOSORISE_PAR_S EXCEPTION ;
PARTICIPANT_INEXISTANT EXCEPTION ;
AUCUN_BATEAU_POUR_CE_PART EXCEPTION ;
BEGIN
     SELECT COUNT(*) INTO NBR_SELECTION
     FROM  BATEAU
	 WHERE sponsor = s ;
     IF(NBR_SELECTION = 0 ) THEN RAISE AUCUN_BATEAU_SPOSORISE_PAR_S ; END IF ;
	 
	 SELECT COUNT(*) INTO NBR_SELECTION
	 FROM PARTICIPANTS 
	 WHERE nbat IN
	 (SELECT nbat 
	  FROM BATEAU
	  WHERE sponsor = s);
	  IF(NBR_SELECTION = 0) THEN RAISE PARTICIPANT_INEXISTANT ; END IF ;
	  
	  
     DBMS_OUTPUT.PUT_LINE('Voici les Participants des  Bateaux sponsorisés par '||s||' : ');
     FOR p IN cr LOOP
	     DBMS_OUTPUT.PUT_LINE('N° : '||p.npart||' Nom : '||p.nompart||' .');
         EXIT WHEN cr%NOTFOUND ;
     END LOOP ;
EXCEPTION 
    WHEN AUCUN_BATEAU_SPOSORISE_PAR_S THEN  
    DBMS_OUTPUT.PUT_LINE('Aucun Bateau sponsorisé par ce Sponsor .');	
	WHEN PARTICIPANT_INEXISTANT THEN  
    DBMS_OUTPUT.PUT_LINE('Participant inexistant .');	
END ;
/
--TESTS
EXECUTE ParticipantBateau('BNA');

UPDATE PARTICIPANTS SET nbat = 104 WHERE nbat = 102 ;

EXECUTE ParticipantBateau('DJEZZY');

--9)
CREATE OR REPLACE PROCEDURE BateauCourse(nomb IN BATEAU.nombat%TYPE) IS
CURSOR cr IS SELECT u.nomcomp , u.datcomp
             FROM COMPETITION u , BATEAU v , COURSES p
			 WHERE u.ncomp = p.ncomp
			 AND   p.nbat = v.nbat
			 AND   v.nombat = nomb
			 AND   p.score = 1 ;
c cr%ROWTYPE ;
NBR_COURSES INTEGER ;
NBR_SELECTION INTEGER ;
PAS_DE_BATEAU_NOMB EXCEPTION ;
NOMB_ZERO_COURSES EXCEPTION ;
NOMB_NA_RIEN_GAGNE EXCEPTION ;
BEGIN
     SELECT COUNT(*) INTO NBR_SELECTION
	 FROM BATEAU
	 WHERE nombat = nomb ;
	 
	 IF(NBR_SELECTION = 0) THEN RAISE PAS_DE_BATEAU_NOMB ; END IF ;
	 
	 SELECT COUNT(*) INTO NBR_COURSES
	 FROM COURSES u , BATEAU v
	 WHERE u.nbat = v.nbat 
	 AND   v.nombat = nomb ;
	 
	 IF(NBR_COURSES = 0) THEN RAISE NOMB_ZERO_COURSES ; END IF ;
	 
     DBMS_OUTPUT.PUT_LINE('Le nombre de courses de "'||nomb||'" = '||NBR_COURSES);
	 
	 SELECT COUNT(u.nomcomp) INTO NBR_SELECTION 
             FROM COMPETITION u , BATEAU v , COURSES p
			 WHERE u.ncomp = p.ncomp
			 AND   p.nbat = v.nbat
			 AND   v.nombat = nomb
			 AND   p.score = 1 ;
	 
	 IF (NBR_SELECTION = 0 ) THEN RAISE NOMB_NA_RIEN_GAGNE ; END IF ; 
	 
	 DBMS_OUTPUT.PUT_LINE('Les competition gagnée par "'||nomb||'" : ');
	 FOR c IN cr LOOP
	     DBMS_OUTPUT.PUT_LINE('Nom : '|| c.nomcomp||' Date : '||c.datcomp);
	     EXIT WHEN cr%NOTFOUND ;
	 END LOOP ;
	 
EXCEPTION
    WHEN PAS_DE_BATEAU_NOMB THEN 
	DBMS_OUTPUT.PUT_LINE('Aucun Bateau ne répond au nom de "'||nomb||'" .');
	WHEN NOMB_ZERO_COURSES THEN 
	DBMS_OUTPUT.PUT_LINE('le Bateau "'||nomb||'" n"a participé à aucune course .');
	WHEN NOMB_NA_RIEN_GAGNE THEN 
	DBMS_OUTPUT.PUT_LINE('Le Bateau "'||nomb||'" n"a gagné aucune course .');
END;
/

--TESTS
EXECUTE BateauCourse('TASSILI');
EXECUTE BateauCourse('El BAHDJA');
EXECUTE BateauCourse('LA COLOMBE');
DELETE FROM COURSES WHERE nbat IN (SELECT nbat FROM BATEAU WHERE nombat = 'HOGGAR');
EXECUTE BateauCourse('HOGGAR');
EXECUTE BateauCourse('NEXISTEPAS');
















