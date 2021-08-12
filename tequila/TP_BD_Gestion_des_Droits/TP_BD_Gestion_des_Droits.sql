
/*==============================================================*/
/* SCRIPT : Gestion des Droits                                          */
/*==============================================================*/

--1) 
CONNECT system/pwd;	

DROP USER USER1 CASCADE ;
DROP USER USER2 CASCADE ;
DROP ROLE Gestion_Courses ;

--2)
CREATE USER USER1 IDENTIFIED BY pwd ;
CREATE USER USER2 IDENTIFIED BY pwd ;
--3)
GRANT ALL PRIVILEGES to USER1 ;
--4)
CONNECT USER1/pwd ;
--5)
@C:\Users\Moflawer\Desktop\Dol_Gul_Dur\WorkShop_Tree\SQL\Almost_Done\SCRIPTs_Pour_TPs_BD2\Data_Base\Creation_Model_de_Donnees_Contraites.sql
--6)
CONNECT USER2/pwd ;
/*==============================================================*/
/* Remarque : ERROR: ORA-01045: user USER2 lacks CREATE SESSION privilege; logon denied */
/*==============================================================*/
--1)
CONNECT system/pwd;
GRANT CREATE SESSION to USER2 ;
CONNECT USER2/pwd;
--2)
CREATE TABLE ENTRETIENT_BATEAU(
             NomAgent VARCHAR2(40) ,
			 Nbat     NUMBER(3)
);
/*==============================================================*/
/* Remarque : ORA-01031: insufficient privileges                */
/*==============================================================*/
--3)
CONNECT system/pwd;
GRANT CREATE TABLE to USER2;
CONNECT USER2/pwd ;
--4)
CREATE TABLE ENTRETIENT_BATEAU(
             NomAgent VARCHAR2(40) ,
			 Nbat     NUMBER(3)
);
/*==============================================================*/
/* Remarque : ORA-01950: no privileges on tablespace 'SYSTEM'   */
/*==============================================================*/
CONNECT system/pwd;
ALTER USER USER2 QUOTA UNLIMITED ON SYSTEM ;

--5)
CONNECT USER2/pwd;

CREATE TABLE ENTRETIENT_BATEAU(
             NomAgent VARCHAR2(40) ,
			 Nbat     NUMBER(3) ,
			 CONSTRAINT PK_NOMAGENT_NBAT PRIMARY KEY (Nom_Agent , Nbat)
);

INSERT INTO ENTRETIENT_BATEAU VALUES('HAKIM' , 102);
INSERT INTO ENTRETIENT_BATEAU VALUES('HAKIM' , 103);
INSERT INTO ENTRETIENT_BATEAU VALUES('DALI' , 103);
INSERT INTO ENTRETIENT_BATEAU VALUES('SLIMANE' , 104);
INSERT INTO ENTRETIENT_BATEAU VALUES('SLIMANE' , 105);
	
--6)
SELECT * FROM USER1.BATEAU ;
/*==============================================================*/
/*ORA-00942: table or view does not exist                       */
/*==============================================================*/
--7)
CONNECT USER1/pwd;
GRANT SELECT ON BATEAU to USER2 ;
GRANT  UPDATE (nombat , sponsor) ON BATEAU to USER2 ;
GRANT REFERENCES (nbat) ON BATEAU to USER2 ;

--8)
CONNECT USER2/pwd;
SELECT * FROM USER1.BATEAU ;
UPDATE USER1.BATEAU
SET sponsor = 'OOREDOO'
WHERE nbat = 104 ;
SELECT * FROM USER1.BATEAU ;
ALTER TABLE ENTRETIENT_BATEAU
ADD CONSTRAINTS FK_ENTRETIENT_BATEAU_BATEAU
FOREIGN KEY (nbat) 
REFERENCES USER1.BATEAU (nbat);

--9)
CONNECT USER1/pwd;
REVOKE SELECT ON BATEAU FROM USER2 ; 
REVOKE  UPDATE  ON BATEAU FROM USER2 ;

--10)
CONNECT USER2/pwd;
SELECT * FROM USER1.BATEAU ;
UPDATE USER1.BATEAU
SET sponsor = 'OOREDOO'
WHERE nbat = 104 ;

--11)
CONNECT USER1/pwd;
CREATE ROLE Gestion_Courses ;
GRANT SELECT ON BATEAU to Gestion_Courses ;
GRANT SELECT ON PARTICIPANTS to Gestion_Courses ;
GRANT UPDATE ON COURSES  to Gestion_Courses;
GRANT UPDATE ON COMPETITION to Gestion_Courses;

--12)
GRANT Gestion_Courses to USER2 ;
--13)
CONNECT USER2/pwd;
SELECT * FROM USER1.BATEAU;
SELECT * FROM USER1.PARTICIPANTS;
UPDATE USER1.COMPETITION
SET Nomcomp = 'LE GRAND TOUR'
WHERE Ncomp = 200;
UPDATE USER1.COURSES
SET score = 2 
WHERE nbat = 102
AND   ncomp = 210 ;

--14)
CONNECT USER2/pwd
SELECT * FROM USER1.COURSES;
SELECT * FROM USER1.COMPETITION;

/*==============================================================*/
/* Remarque : USER2 ne Peut pas voir les Tables COURSES et COMPETITION   */
/*==============================================================*/

--15)
CONNECT USER1/pwd
GRANT SELECT ON COMPETITION to Gestion_Courses ;
GRANT SELECT ON COURSES to Gestion_Courses ;

--16)
CONNECT USER2/pwd;
SELECT * FROM USER1.COURSES;
SELECT * FROM USER1.COMPETITION;

 


/*==============================================================*/
/* System                      */
/*==============================================================*/
CONNECT system/pwd;	
