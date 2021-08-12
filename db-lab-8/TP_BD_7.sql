
/*==============================================================*/
/* SCRIPT : TP PL/SQL                                      */
/*==============================================================*/

--1)
CONNECT system/pwd ;

DROP USER CASANOVA CASCADE;

CREATE USER CASANOVA IDENTIFIED BY pwd ;
GRANT ALL PRIVILEGES TO CASANOVA ;

CONNECT CASANOVA/pwd ;

CREATE TABLE BATEAU (
    nbat    NUMBER(3)   NOT NULL ,
	nombat  VARCHAR2(40) NOT NULL,
	sponsor VARCHAR2(40) NOT NULL ,
	CONSTRAINT PK_NBAT PRIMARY KEY (nbat)
);

CREATE TABLE COMPETITION (
      ncomp     NUMBER(3)   NOT NULL ,
	  nomcomp   VARCHAR2(40) NOT NULL ,
      datcomp   DATE         NOT NULL ,
      prixcomp  NUMBER(10)    NOT NULL ,
	  CONSTRAINT PK_NCOMP PRIMARY KEY (ncomp)
);

CREATE TABLE PARTICIPANT (
    npart   NUMBER(3)   NOT NULL ,
    nompart VARCHAR2(40) NOT NULL ,
    nbat    NUMBER(3)    ,
	CONSTRAINT PK_NPART PRIMARY KEY (npart) ,
	CONSTRAINT FK_NBAT_PARTICIPANT_BATEAU FOREIGN KEY (nbat) 
    REFERENCES BATEAU (nbat)	
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
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp)VALUES (270 , 'COURSE DE LA LIBERTE' , '08/05/2010' , 1800000) ;

/*==============================================================*/
/* PARTICIPANTS                                               */
/*==============================================================*/
INSERT INTO PARTICIPANT VALUES (320 , 'MOHAMMED' , 104) ;
INSERT INTO PARTICIPANT VALUES (470 , 'ALI' , 103) ;
INSERT INTO PARTICIPANT VALUES (601 , 'OMAR' , 102) ;
INSERT INTO PARTICIPANT VALUES (720 , 'MUSTAFA' , 105) ;

--2)
ALTER TABLE COMPETITION
ADD CONSTRAINT  CHK_PRIXCOMP CHECK (prixcomp BETWEEN 1000000 AND 2500000) ;

--3)
SET SERVEROUTPUT ON ;
DECLARE
 s NUMBER(4) := 0 ; i  NUMBER(3) := 1;
BEGIN 
WHILE (i<=10) LOOP
      s := s+i ; i :=i+1 ;
	  END LOOP;
	  DBMS_OUTPUT.PUT_LINE('Somme='||s);
END;
/
--4)
SET SERVEROUTPUT ON ;
DECLARE
  x BATEAU.nombat%TYPE;
BEGIN 
    SELECT nombat
	INTO x 
	      FROM BATEAU
		  WHERE nbat = 102 ;
	DBMS_OUTPUT.PUT_LINE('Le Nom du Bateau Num 102 : ' || x);	  
		  
END;
/

--5)
CREATE OR REPLACE PROCEDURE NomBateau ( x IN BATEAU.nbat%TYPE ) IS 
  y BATEAU.nombat%TYPE;
BEGIN 
    SELECT nombat
	INTO y 
	      FROM BATEAU
		  WHERE nbat = x ;
	DBMS_OUTPUT.PUT_LINE('Le Nom du Bateau Num '|| x ||' : ' || y);	  
		  
END;
/
EXECUTE NOmBAteau (105) ;

--6)
CREATE OR REPLACE PROCEDURE PrixComp  IS 
 
BEGIN 
	   UPDATE COMPETITION
	   SET prixcomp = prixcomp + 100000 
	   WHERE prixcomp <= 1000000 ;
		DBMS_OUTPUT.PUT_LINE('Nombre de Competitions Modifiée = '||SQL%ROWCOUNT);	  	  
END;
/

EXECUTE PrixComp  ;

--7)
CREATE OR REPLACE PROCEDURE  procprix ( x IN COMPETITION.prixcomp%TYPE , y OUT INTEGER ) IS 
BEGIN 
   SELECT COUNT(*) INTO y FROM COMPETITION WHERE prixcomp > x ;   
  
END;
/
DECLARE 
y INTEGER ;
BEGIN
   procprix(1500000 , y ); 
   DBMS_OUTPUT.PUT_LINE('Nombre de Competition dont le prix dépasse '|| 1500000 ||' = '|| y );

END ;
/

--8)
CREATE OR REPLACE FUNCTION  fonc_prix ( x IN COMPETITION.prixcomp%TYPE  ) RETURN INTEGER  IS
y INTEGER ;
BEGIN 
   SELECT COUNT(*) INTO y FROM COMPETITION WHERE prixcomp > x ;    
   RETURN y ;
END;
/

BEGIN
DBMS_OUTPUT.PUT_LINE('Nombre de Competition dont le prix dépasse '|| 1500000 ||' = '|| fonc_prix(1500000) );
END ;
/

--9)
CREATE OR REPLACE FUNCTION  Nombre_Courses ( nc IN COMPETITION.nomcomp%TYPE  ) RETURN INTEGER  IS
y INTEGER ;
BEGIN 
   SELECT COUNT(*) INTO y FROM COMPETITION WHERE nomcomp = nc ;
    
   RETURN y ;
END;
/
BEGIN
   
   DBMS_OUTPUT.PUT_LINE('Nombre de COURSES de  '|| 'LE GRAND TOUR'||' = '|| Nombre_Courses('LE GRAND TOUR') );

END ;
/

--10)
CREATE OR REPLACE PROCEDURE PrixComp2(x IN COMPETITION.ncomp%TYPE ) IS
PRIX COMPETITION.prixcomp%TYPE ;
PRIX_TROP_GRAND EXCEPTION ;
BEGIN

     SELECT prixcomp INTO PRIX FROM COMPETITION WHERE ncomp = x ;
	 IF((PRIX+1000000) > 2500000) THEN RAISE PRIX_TROP_GRAND ; END IF ;
     UPDATE COMPETITION
	 SET prixcomp = prixcomp + 1000000
	 WHERE   ncomp = x ;
	 SELECT prixcomp INTO PRIX FROM COMPETITION WHERE ncomp = x ;
     DBMS_OUTPUT.PUT_LINE('Le nouveau prix de la Competition '|| x||' = '|| PRIX );
EXCEPTION
     WHEN  PRIX_TROP_GRAND THEN
	 DBMS_OUTPUT.PUT_LINE('Contrainte non vérifié , le nouveau prix dépasse 2500000 .');
END ;
/

EXECUTE PrixComp2(260);
EXECUTE PrixComp2(200); 	 

--11) 
CREATE OR REPLACE PROCEDURE NomCompetition(x IN COMPETITION.ncomp%TYPE) IS
NOM COMPETITION.nomcomp%TYPE ;
NBR_SELECTION INTEGER ;
COMPETITION_INTROUVABLE EXCEPTION ;
BEGIN 

     SELECT COUNT(*) INTO NBR_SELECTION 
	 FROM COMPETITION 
	 WHERE ncomp = x ;
	 IF(NBR_SELECTION= 0) THEN RAISE COMPETITION_INTROUVABLE ; END IF ;
	 SELECT nomcomp INTO NOM FROM COMPETITION WHERE ncomp = x ;
	 DBMS_OUTPUT.PUT_LINE('Le Nom de La Competition N°'||x||' = '||NOM);
EXCEPTION
     WHEN COMPETITION_INTROUVABLE THEN 
	 DBMS_OUTPUT.PUT_LINE('Aucune Competition ne correspond à '||x||' .');
END;
/

EXECUTE NomCompetition(210) ;
EXECUTE NomCompetition(320) ;

--12)
CREATE OR REPLACE PROCEDURE NomCompetition2(x IN COMPETITION.ncomp%TYPE) IS
NOM COMPETITION.nomcomp%TYPE ;
BEGIN 
	 SELECT nomcomp INTO NOM FROM COMPETITION WHERE ncomp = x ;
	 DBMS_OUTPUT.PUT_LINE('Le Nom de La Competition N°'||x||' = '||NOM);
EXCEPTION
     WHEN NO_DATA_FOUND THEN 
	 DBMS_OUTPUT.PUT_LINE('Aucune Competition ne correspond à '||x||' .');
END;
/

EXECUTE NomCompetition2(210) ;
EXECUTE NomCompetition2(320) ;

--13)
CREATE OR REPLACE PROCEDURE PrixComp3(x IN COMPETITION.prixcomp%TYPE , y IN COMPETITION.prixcomp%TYPE ) IS
NBR_SELECTION INTEGER ;
PRIX_TROP_GRAND EXCEPTION ;
BEGIN 
    
	SELECT COUNT(*) INTO NBR_SELECTION 
	FROM COMPETITION 
	WHERE prixcomp < y
    AND   (prixcomp + x) > 2500000	 ;
	
	IF(NBR_SELECTION > 0) THEN RAISE PRIX_TROP_GRAND ; END IF ;
	
	UPDATE COMPETITION
	SET prixcomp = prixcomp + x
	WHERE prixcomp < y ;
	
	IF(SQL%ROWCOUNT = 0) THEN 
	DBMS_OUTPUT.PUT_LINE('Aucune Competition na un prix inferieur à '||y|| ' .');
	ELSE
	DBMS_OUTPUT.PUT_LINE('Le Nombre De Competitoon Modifiées = '|| SQL%ROWCOUNT || ' .');
	END IF ;
EXCEPTION
     WHEN  PRIX_TROP_GRAND THEN
	 DBMS_OUTPUT.PUT_LINE('Contrainte non vérifié , le nouveau prix dépasse 2500000 .');
END ;
/

EXECUTE PrixComp3(1000,1800000) ;
EXECUTE PrixComp3(1000000,1800000) ;

--14)
INSERT INTO PARTICIPANT (npart , nompart) VALUES (480 , 'SAMIR');
INSERT INTO PARTICIPANT (npart , nompart) VALUES (501 , 'WLID');

CREATE OR REPLACE PROCEDURE BateauPartitcipant(p IN PARTICIPANT%ROWTYPE) IS
PARTICIPANT_INEXISTANT EXCEPTION ;
AUCUN_BATEAU EXCEPTION ;
NBR_SELECTION INTEGER := NULL ;
resultat1  PARTICIPANT%ROWTYPE ;
resultat2  BATEAU%ROWTYPE ;
BEGIN
     SELECT COUNT(*) INTO NBR_SELECTION 
	 FROM PARTICIPANT
	 WHERE npart = p.npart
	 AND   nompart = p.nompart ;
	
	 IF(NBR_SELECTION = 0) THEN RAISE PARTICIPANT_INEXISTANT; END IF;
	 
	 SELECT * INTO resultat1 
	 FROM PARTICIPANT 
	 WHERE npart = p.npart
	 AND   nompart = p.nompart ;
	 
	 IF(resultat1.nbat = NULL) THEN RAISE AUCUN_BATEAU ; 
	 ELSE 
	SELECT * INTO resultat2 
	 FROM BATEAU 
	 WHERE resultat1.nbat = nbat ;
	 
	 DBMS_OUTPUT.PUT_LINE('Voici le Nom du Bateau du participant N° '||p.npart||' '||p.nompart||' :');
	 DBMS_OUTPUT.PUT_LINE('N° = '||resultat2.nbat||', Nom = '||resultat2.nombat||' .');
	 END IF;
	 
	 
EXCEPTION
     WHEN PARTICIPANT_INEXISTANT THEN 
	 DBMS_OUTPUT.PUT_LINE('Participant N° '||p.npart||' '||p.nompart||' nesxiste pas .');
	 WHEN AUCUN_BATEAU OR NO_DATA_FOUND THEN 
	 DBMS_OUTPUT.PUT_LINE('Participant N° '||p.npart||' '||p.nompart||' na pas de bateau .');
	 
END;
/

DECLARE
p PARTICIPANT%ROWTYPE ;
BEGIN 
SELECT * INTO p 
FROM  PARTICIPANT
WHERE npart = 601;
BateauPartitcipant(p);
SELECT * INTO p 
FROM  PARTICIPANT
WHERE npart = 480;
BateauPartitcipant(p);

END ;
/














