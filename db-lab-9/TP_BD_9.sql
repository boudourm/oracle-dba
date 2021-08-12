/*==============================================================*/
/* SCRIPT : TP PL/SQL                                      */
/*==============================================================*/


--1)
CREATE TABLE xxx (aaa number);
INSERT INTO xxx values (3);
SELECT * FROM xxx;

--SORTIE

--2)
SELECT * FROM xxx;

--3)
INSERT INTO xxx values (3); 	
DISCONNECT ;
CONNECT system/pwd ;
SELECT * FROM xxx;

DROP TABLE xxx;

--4)
--a
CONNECT system/pwd; 
/*Debut T1 */

CREATE USER USER1 IDENTIFIED BY pwd ; 

/*Fin T1 Validée /COMMIT implicit */ /*Debut T2*/
--b)
GRANT ALL PRIVILEGES TO USER1 ;       
/*Fin T2 Validée /COMMIT implicit*/ /*Debut T3*/
DISCONNECT ;                          
/*Fin T3 Validée /COMMIT implicit*/ 
--c)
CONNECT USER1/pwd ;   
/*Debut T4*/
--d)
CREATE TABLE BATEAU (
    nbat    NUMBER(3)   NOT NULL ,
	nombat  VARCHAR2(40) NOT NULL,
	sponsor VARCHAR2(40) NOT NULL ,
	CONSTRAINT PK_NBAT PRIMARY KEY (nbat)
);
 /*Fin T4 Validée /COMMIT implicit*/
 /*Debut T5*/
--e)
INSERT INTO BATEAU (nbat , nombat , sponsor) VALUES (102 , 'TASSILI' , 'DJEZZY') ;
INSERT INTO BATEAU (nbat , nombat , sponsor) VALUES (103 , 'EL BAHDJA' , 'BNA') ;
INSERT INTO BATEAU (nbat , nombat , sponsor) VALUES (104 , 'LA COLOMBE' , 'OOREDOO') ;
INSERT INTO BATEAU (nbat , nombat , sponsor) VALUES (105 , 'HOGGAR' , 'BNA') ;

--f)
SELECT * FROM BATEAU ;

--g)
CREATE TABLE COMPETITION (
      ncomp     NUMBER(3)   NOT NULL ,
	  nomcomp   VARCHAR2(40) NOT NULL ,
      datcomp   DATE         NOT NULL ,
      prixcomp  NUMBER(10)    NOT NULL ,
	  CONSTRAINT PK_NCOMP PRIMARY KEY (ncomp)
);
  /*Fin T5 Validée /COMMIT implicit*/
  /*Debut T6*/
--h)
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (200 , 'LE GRAND TOUR' , '21/03/2002' , 1000000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (210 , 'COURSE DE LA LIBERTE' , '05/05/2004' , 1000000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (215 , 'LE GRAND TOUR' , '20/03/2005' , 1100000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (220 , 'TROPHEE BARBEROUSSE' , '01/08/2005' , 1500000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (240 , 'COURSE DE LA LIBERTE' , '10/05/2007' , 1500000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (260 , 'TROPHEE BARBEROUSSE' , '01/08/2009' , 2000000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (265 , 'LE GRAND TOUR' , '21/03/2010' , 2000000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp)VALUES (270 , 'COURSE DE LA LIBERTE' , '08/05/2010' , 1800000) ;

SELECT * FROM COMPETITION ;
--i)
ROLLBACK ;

 /*T6 Annulée*/


SELECT * FROM COMPETITION ;

--5)
--a)
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (200 , 'LE GRAND TOUR' , '21/03/2002' , 1000000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (210 , 'COURSE DE LA LIBERTE' , '05/05/2004' , 1000000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (215 , 'LE GRAND TOUR' , '20/03/2005' , 1100000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (220 , 'TROPHEE BARBEROUSSE' , '01/08/2005' , 1500000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (240 , 'COURSE DE LA LIBERTE' , '10/05/2007' , 1500000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (260 , 'TROPHEE BARBEROUSSE' , '01/08/2009' , 2000000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (265 , 'LE GRAND TOUR' , '21/03/2010' , 2000000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp)VALUES (270 , 'COURSE DE LA LIBERTE' , '08/05/2010' , 1800000) ;

--b)
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

   /*Fin T1 Validée /COMMIT implicit*/ /*Debut T2*/
--c)
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

--d)
CREATE TABLE PARTICIPANTS (
    npart   NUMBER(3)   NOT NULL ,
    nompart VARCHAR2(40) NOT NULL ,
    nbat    NUMBER(3)   NOT NULL ,
	CONSTRAINT PK_NPART PRIMARY KEY (npart) ,
	CONSTRAINT FK_NBAT_PARTICIPANTS_BATEAU FOREIGN KEY (nbat) 
    REFERENCES BATEAU (nbat)	
);
     /*Fin T2 Validée /COMMIT implicit*/ /*Debut T3*/
--e)
ALTER TABLE BATEAU 
DROP COLUMN sponsor ;

   /*Fin T3 Validée /COMMIT implicit*/ /*Debut T4*/
--f)
ALTER TABLE BATEAU	
ADD sponsor VARCHAR2(40)  ;
   /*Fin T4 Validée /COMMIT implicit*/ /*Debut T5*/
--g)
INSERT INTO PARTICIPANTS VALUES (320 , 'MOHAMMED' , 104) ;
INSERT INTO PARTICIPANTS VALUES (470 , 'ALI' , 103) ;
INSERT INTO PARTICIPANTS VALUES (601 , 'OMAR' , 102) ;
INSERT INTO PARTICIPANTS VALUES (720 , 'MUSTAFA' , 105) ;

--h)
SAVEPOINT P1 ;  
 /*Point de Validation P1*/

--i)			
DELETE FROM PARTICIPANTS
WHERE npart = 601 ;

--j)
DELETE FROM COMPETITION
WHERE datcomp < '01/01/2003' ;

--k)
SAVEPOINT P2 ;  
/*Point de Validation P2*/

--l)
UPDATE BATEAU
SET sponsor = 'CONDOR'
WHERE nombat = 'HOGGAR' ;

SELECT * FROM BATEAU ;

--m)
SELECT u.nompart , u.npart 
FROM PARTICIPANTS u , BATEAU v
WHERE u.nbat  = v.nbat
AND    v.nombat = 'EL BAHDJA' ;


SELECT * FROM COMPETITION  ;
SELECT * FROM PARTICIPANTS ;
--n)
ROLLBACK TO P2 ;        
/*Annulation du Update*/
SELECT * FROM BATEAU ;

--o)
UPDATE BATEAU
SET sponsor = 'CONDOR'
WHERE nombat = 'HOGGAR' ;

SELECT * FROM BATEAU ;

SELECT u.nompart , u.npart 
FROM PARTICIPANTS u , BATEAU v
WHERE u.nbat  = v.nbat
AND    v.nombat = 'EL BAHDJA' ;

--p)
ROLLBACK TO P1 ;    
 /*Annulation Update BATEATU Delete PARTICIPANTS et Delete COMPETITION*/

SELECT * FROM COMPETITION  ;
SELECT * FROM PARTICIPANTS ;
SELECT * FROM BATEAU ;

--q)
DELETE FROM PARTICIPANTS
WHERE npart = 601 ;

DELETE FROM COMPETITION
WHERE datcomp < '01/01/2003' ;
	
SELECT * FROM COMPETITION  ;
SELECT * FROM PARTICIPANTS ;	
	
--7)
DROP USER USER2 CASCADE ;
CREATE USER USER2 IDENTIFIED BY pwd ;
GRANT ALL PRIVILEGES TO USER2 ;
GRANT SELECT ON BATEAU TO USER2 ;

--TERMINALE 1 
CONNECT USER1/pwd ;
--TERMINALE 2 
CONNECT USER2/pwd ;
--TERMINALE 3
sqlplus / as sysdba 

--SESSION USER1
SELECT * FROM BATEAU ;

UPDATE BATEAU
SET sponsor = 'BNA'
WHERE nbat = 104 ;

--SESSION USER2
SELECT * FROM USER1.BATEAU ;

UPDATE USER1.BATEAU
SET sponsor = 'CONDOR'
WHERE nbat = 104 ;

--SESSION SYSDBA 
SELECT SESSION_ID , ORACLE_USERNAME , OBJECT_ID , LOCKED_MODE 
FROM  V_$LOCKED_OBJECT ;

SELECT WAITING_SESSION , HOLDING_SESSION , MODE_HELD , MODE_REQUESTED 
FROM DBA_WAITERS ;

--SESSION USER1
COMMIT ;

--SESSION SYSDBA 
SELECT SESSION_ID , ORACLE_USERNAME , OBJECT_ID , LOCKED_MODE 
FROM  V_$LOCKED_OBJECT ;

SELECT WAITING_SESSION , HOLDING_SESSION , MODE_HELD , MODE_REQUESTED 
FROM DBA_WAITERS ;

--SESSION USER2
COMMIT ;

--SESSION USER1
UPDATE BATEAU SET sponsor = 'DJEZZY' WHERE nbat = 105 ;

--SESSION USER2
UPDATE USER1.BATEAU SET sponsor = 'BNA' WHERE nbat = 103 ;


--SESSION USER1
UPDATE BATEAU SET sponsor = 'DJEZZY' WHERE nbat = 103 ;

--SESSION USER2
UPDATE USER1.BATEAU SET sponsor = 'BNA' WHERE nbat = 105 ;

--SESSION USER1
COMMIT ;

SET TRANSACTION READ ONLY ;
UPDATE BATEAU SET sponsor = 'DJEZZY' WHERE nbat = 103 ;

COMMIT ;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE ;
UPDATE BATEAU SET sponsor = 'DJEZZY' WHERE nbat = 103 ;
UPDATE BATEAU SET sponsor = 'DJEZZY' WHERE nbat = 105 ;






