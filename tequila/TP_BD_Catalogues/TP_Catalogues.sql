
/*==============================================================*/
/* SCRIPT : TP CATALOGUES                                       */
/*==============================================================*/


--1)
CONNECT system/pwd ;

DROP USER USER1 CASCADE;
DROP USER USER3 CASCADE;

CREATE USER USER1 IDENTIFIED BY pwd;
CREATE USER USER3 IDENTIFIED BY pwd;
GRANT ALL PRIVILEGES to USER1;
GRANT CREATE SESSION , CREATE TABLE to USER3 ;

--2)
CONNECT USER1/pwd

@C:\Users\Moflawer\Desktop\Dol_Gul_Dur\WorkShop_Tree\SQL\Almost_Done\SCRIPTs_Pour_TPs_BD2\Data_Base\Creation_Model_de_Donnees_Contraites.sql

--3)
CONNECT system/pwd ;
ALTER USER USER3 QUOTA UNLIMITED ON SYSTEM ;

CONNECT USER3/pwd ;
CREATE TABLE ENTRETIEN_BATEAU (
	  NomAgent    VARCHAR2(40) ,
	  Nbat        NUMBER(3),
	  CONSTRAINT PK_NOMAGENT_NBAT PRIMARY KEY (NomAgent , Nbat)
);

INSERT INTO ENTRETIEN_BATEAU VALUES('HAKIM' , 102);
INSERT INTO ENTRETIEN_BATEAU VALUES('HAKIM' , 103);
INSERT INTO ENTRETIEN_BATEAU VALUES('DALI' , 103);
INSERT INTO ENTRETIEN_BATEAU VALUES('SLIMANE' , 104);
INSERT INTO ENTRETIEN_BATEAU VALUES('SLIMANE' , 105);
--4)
CONNECT USER1/pwd ;
GRANT SELECT ON BATEAU to USER3 ;
GRANT REFERENCES (nbat) ON BATEAU to USER3 ;

CONNECT USER3/pwd ;
ALTER TABLE ENTRETIEN_BATEAU
ADD CONSTRAINT FK_NBT_ENTRTN_BTAU_BTAU 
FOREIGN KEY (nbat)
REFERENCES USER1.BATEAU (nbat) ;

--5)
		SELECT COUNT(*) FROM DICT ;
		DESC DICT ;
		 
--6)
SELECT * 
FROM DICT 
WHERE TABLE_NAME LIKE 'USER_TAB%' ;

--7)
SELECT COMMENTS AS A_quoi_sert_USER_TAB_PRIVS
FROM DICT 
WHERE TABLE_NAME = 'USER_TAB_PRIVS' ;

--8)
SELECT COMMENTS AS A_quoi_sert_ALL_TAB_COLUMNS
FROM DICT 
WHERE TABLE_NAME = 'ALL_TAB_COLUMNS' ;

SELECT COMMENTS AS A_quoi_sert_ALL_CONSTRAINTS
FROM DICT 
WHERE TABLE_NAME = 'ALL_CONSTRAINTS' ;

SELECT COMMENTS AS A_quoi_sert_USER_USERS
FROM DICT 
WHERE TABLE_NAME = 'USER_USERS' ;

--9)	
SELECT COMMENTS AS DIFEERENCE
FROM DICT 
WHERE TABLE_NAME = 'ALL_TABLES' 
OR    TABLE_NAME = 'USER_TABLES' ;
--10)
DESC USER_USERS ;
SELECT USERNAME , ACCOUNT_STATUS , DEFAULT_TABLESPACE
FROM USER_USERS ;

--11)
DESC USER_TABLES ;
SELECT TABLE_NAME 
FROM USER_TABLES ;
	
--12)
CONNECT SYSTEM/pwd;
SELECT TABLE_NAME 
FROM USER_TABLES ;

--13)
CONNECT USER3/pwd;
SELECT TABLE_NAME 
FROM USER_TABLES ;

--14)
CONNECT USER1/pwd ;
DESC ALL_TAB_COLUMNS ;
SELECT  COLUMN_NAME , OWNER , DATA_TYPE , DATA_LENGTH , NULLABLE
FROM ALL_TAB_COLUMNS
WHERE TABLE_NAME = 'COMPETITION' ;

--15)
CONNECT USER3/pwd ;
SELECT COLUMN_NAME , OWNER , DATA_TYPE , DATA_LENGTH , NULLABLE
FROM ALL_TAB_COLUMNS
WHERE TABLE_NAME = 'ENTRETIEN_BATEAU'
AND   OWNER = 'USER3' ;

--16)
CONNECT USER3/pwd ;
DESC ALL_CONSTRAINTS ;
SELECT CONSTRAINT_NAME ,CONSTRAINT_TYPE , TABLE_NAME ,OWNER
FROM ALL_CONSTRAINTS
WHERE OWNER = 'USER3';

--17)
CONNECT USER3/pwd ;
SELECT  CONSTRAINT_NAME ,CONSTRAINT_TYPE
FROM ALL_CONSTRAINTS
WHERE OWNER = 'USER3'
AND   CONSTRAINT_TYPE = 'R';

CONNECT USER1/pwd
SELECT  CONSTRAINT_NAME ,CONSTRAINT_TYPE
FROM ALL_CONSTRAINTS
WHERE OWNER = 'USER1'
AND   CONSTRAINT_TYPE = 'R';

--18)
CONNECT USER3/pwd ;
DESC ALL_TABLES ;
SELECT TABLE_NAME , OWNER 
FROM ALL_TABLES 
WHERE  TABLE_NAME = 'BATEAU';

--19)
CONNECT USER1/pwd ;
-----------------------------------------------------a)
SELECT TABLE_NAME AS USER_TABLES_ANVANT
FROM   USER_TABLES ;

SELECT COLUMN_NAME , TABLE_NAME 
FROM ALL_TAB_COLUMNS
WHERE OWNER = 'USER1';

SELECT CONSTRAINT_NAME , CONSTRAINT_TYPE
FROM ALL_CONSTRAINTS
WHERE OWNER = 'USER1' ;
  
CREATE TABLE SPONSOR (
             NomSponsor VARCHAR2(40) ,
			 Specialite VARCHAR2(40) ,
			 CONSTRAINT PK_NOMSPONSOR 
			 PRIMARY KEY (NomSponsor)
);

INSERT INTO SPONSOR VALUES ('CEVITAL' , 'alimentation') ;
INSERT INTO SPONSOR VALUES ('DJEZZY' ,'télécom') ;
INSERT INTO SPONSOR VALUES ('CONDOR' ,'éléctro-ménage') ;
INSERT INTO SPONSOR VALUES ('OOREDOO', 'télécom') ;
INSERT INTO SPONSOR VALUES ('STARLIGHT', 'éléctro-ménage') ;
INSERT INTO SPONSOR VALUES ('BNA' ,'banque') ;
INSERT INTO SPONSOR VALUES ('IRIS' ,'télécom') ;

SELECT TABLE_NAME AS USER_TABLES_APRES
FROM   USER_TABLES ;

SELECT COLUMN_NAME , TABLE_NAME 
FROM ALL_TAB_COLUMNS
WHERE OWNER = 'USER1';

SELECT CONSTRAINT_NAME , CONSTRAINT_TYPE
FROM ALL_CONSTRAINTS
WHERE OWNER = 'USER1' ;

--------------------------------------------------b)
SELECT CONSTRAINT_NAME , CONSTRAINT_TYPE
FROM ALL_CONSTRAINTS
WHERE OWNER = 'USER1' ;

ALTER TABLE BATEAU
ADD CONSTRAINT FK_SPONSOR_BATEAU_SPONSOR
FOREIGN KEY (sponsor)
REFERENCES SPONSOR (NomSponsor);

SELECT CONSTRAINT_NAME , CONSTRAINT_TYPE
FROM ALL_CONSTRAINTS
WHERE OWNER = 'USER1' ;

---------------------------------------------c)
SELECT TABLE_NAME AS USER_TABLES_ANVANT
FROM   USER_TABLES ;

SELECT COLUMN_NAME , TABLE_NAME 
FROM ALL_TAB_COLUMNS
WHERE OWNER = 'USER1';

SELECT CONSTRAINT_NAME , CONSTRAINT_TYPE
FROM ALL_CONSTRAINTS
WHERE OWNER = 'USER1' ;
  
DROP TABLE PARTICIPANTS CASCADE CONSTRAINTS ;

  
SELECT TABLE_NAME AS USER_TABLES_APRES
FROM   USER_TABLES ;

SELECT COLUMN_NAME , TABLE_NAME 
FROM ALL_TAB_COLUMNS
WHERE OWNER = 'USER1';

SELECT CONSTRAINT_NAME , CONSTRAINT_TYPE
FROM ALL_CONSTRAINTS
WHERE OWNER = 'USER1' ;

----------------------------------------d)
SELECT TABLE_NAME AS USER_TABLES_ANVANT
FROM   USER_TABLES ;

SELECT COLUMN_NAME , TABLE_NAME 
FROM ALL_TAB_COLUMNS
WHERE OWNER = 'USER1';


CREATE TABLE BATEAUX_GAGNANTS (
             Nom_Bateau        VARCHAR2(40),
			 Nom_Competition   VARCHAR2 (40) ,
			 Date_Competition  DATE ,
			 Prix              NUMBER(10) );
INSERT INTO BATEAUX_GAGNANTS 
(
SELECT u.nombat , p.Nomcomp , p.Datcomp , p.Prixcomp
FROM BATEAU u , COMPETITION p ,COURSES v
WHERE u.nbat = v.nbat 
AND   v.Ncomp = p.Ncomp
AND   v.Score = 1 
) ;
  
SELECT TABLE_NAME AS USER_TABLES_APRES
FROM   USER_TABLES ;

SELECT COLUMN_NAME , TABLE_NAME 
FROM ALL_TAB_COLUMNS
WHERE OWNER = 'USER1';
