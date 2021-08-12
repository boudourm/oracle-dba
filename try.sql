
/*==============================================================*/
/* @C:\Users\Moflawer\Desktop\Dol_Gul_Dur\WorkShop_Tree\SQL\Almost_Done\SCRIPTs_Pour_TPs_BD2\Essai.sql */
/*==============================================================*/

/*==============================================================*/
/* SCRIPT : Gestion des Droits                                  */
/*==============================================================*/
--A)
--1)
CONNECT system/pwd;

--2)
DROP USER CASANOVA  CASCADE ;

CREATE USER CASANOVA IDENTIFIED BY pwd ;

--3)
GRANT ALL PRIVILEGES  to CASANOVA ;

--4)
CONNECT CASANOVA/pwd ;

--B)
--1)
CREATE TABLE BATEAU (
    nbat    NUMBER(3)  ,
	nombat  VARCHAR2(40) ,
	sponsor VARCHAR2(40)  );

--2)
INSERT INTO BATEAU (nbat , nombat , sponsor) VALUES (102 , 'TASSILI' , 'DJEZZY') ;
INSERT INTO BATEAU (nbat , nombat , sponsor) VALUES (103 , 'El BAHDJA' , 'BNA') ;
INSERT INTO BATEAU (nbat , nombat , sponsor) VALUES (104 , 'LA COLOMBE' , 'NEDJMA') ;
INSERT INTO BATEAU (nbat , nombat , sponsor) VALUES (105 , 'HOGGAR' , 'BNA') ;

--3)
INSERT INTO BATEAU (nbat , nombat , sponsor) VALUES (102 , 'AIGLE NOIR' , 'BNA') ;

--4)

ALTER TABLE BATEAU
ADD CONSTRAINT PK_NBAT PRIMARY KEY (nbat) ;

/*==============================================================*/
/* REMARQUE :ORA-02437: cannot validate (CASANOVA.PK_NBAT) - primary key violated*/
/*==============================================================*/

UPDATE BATEAU
SET nbat = 106
WHERE nombat = 'AIGLE NOIR' ;

ALTER TABLE BATEAU
ADD CONSTRAINT PK_NBAT PRIMARY KEY (nbat) ;

--5)
INSERT INTO BATEAU VALUES (NULL,'GRAND BLEU' , 'CONDOR') ;

/*
ORA-01400: cannot insert NULL into ("CASANOVA"."BATEAU"."NBAT")
Oui la Clé Primaire doit toujours Contenir une Valeur
*/

--6)
UPDATE BATEAU
SET nbat = 110 
WHERE nbat = 102 ;
/* Oui la Modification est Permise */

UPDATE BATEAU
SET nbat = 102 
WHERE nbat = 110 ;

---7)
UPDATE BATEAU
SET nbat = 103 
WHERE nbat = 105 ;
/*
ORA-00001: unique constraint (CASANOVA.PK_NBAT) violated
ORACLE permet la Modification de la Clé primaire si et seulement si la nouvelle
Valeur n'exsiste pas déjà dans le même champ d'une autre tuple déjà existant
dans la Table Modifié
*/

--8)
CREATE TABLE PARTICIPANTS (
    npart   NUMBER(3)    ,
    nompart VARCHAR2(40)  ,
    nbat    NUMBER(3)  ,
	CONSTRAINT PK_NPART PRIMARY KEY (npart) ,
	CONSTRAINT FK_PARTICIPANTS_BATEAU_NBAT FOREIGN KEY (nbat)
	REFERENCES BATEAU (nbat)
);

--9)
INSERT INTO PARTICIPANTS VALUES (320 , 'MOHAMMED' , 104) ;
INSERT INTO PARTICIPANTS VALUES (470 , 'ALI' , 103) ;
INSERT INTO PARTICIPANTS VALUES (601 , 'OMAR' , 102) ;
INSERT INTO PARTICIPANTS VALUES (720 , 'MUSTAFA' , 105) ;

--10)
INSERT INTO PARTICIPANTS VALUES (510 , 'BRAHIM' , 115) ;
/*
ORA-02291: integrity constraint (CASANOVA.FK_BATEAU_NBAT) violated - parent key
not found
*/
--11)
CREATE TABLE COURSES (
	nbat  NUMBER(3)  ,
	ncomp NUMBER(3)   ,
	score NUMBER(3) ,
    CONSTRAINT PK_NBAT_NCOMP PRIMARY KEY (nbat , ncomp) ,
    CONSTRAINT FK_COURSES_BATEAU_NBAT FOREIGN KEY (nbat)
    REFERENCES BATEAU (nbat) ,
    CONSTRAINT FK_COURSES_COMPETITION_NCOMP FOREIGN KEY (ncomp)
    REFERENCES COMPETTTION (ncomp)	
);
/*
REFERENCES COMPETTTION (ncomp) 
ERROR at line 9:
ORA-00942: table or view does not exist
*/

--12)
CREATE TABLE COMPETITION (
      ncomp     NUMBER(3)    ,
	  nomcomp   VARCHAR2(40) ,
      datcomp   DATE          ,
      prixcomp  NUMBER(10)   ,
      CONSTRAINT PK_NCOMP PRIMARY KEY (ncomp)	  
);

CREATE TABLE COURSES (
	nbat  NUMBER(3)  ,
	ncomp NUMBER(3)   ,
	score NUMBER(3) ,
    CONSTRAINT PK_NBAT_NCOMP PRIMARY KEY (nbat , ncomp) ,
    CONSTRAINT FK_COURSES_BATEAU_NBAT FOREIGN KEY (nbat)
    REFERENCES BATEAU (nbat) ,
    CONSTRAINT FK_COURSES_COMPETITION_NCOMP FOREIGN KEY (ncomp)
    REFERENCES COMPETITION (ncomp)	
);