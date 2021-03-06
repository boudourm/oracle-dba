/*==============================================================*/
/* SCRIPT : TP BD 4                                             */
/*==============================================================*/
--1)
CONNECT system/pwd ;
--2)
DROP USER DONQUICHOTTE CASCADE ;
CREATE USER DONQUICHOTTE IDENTIFIED BY pwd ;
--3)
GRANT ALL PRIVILEGES TO DONQUICHOTTE ;
--4)
CONNECT DONQUICHOTTE/pwd ;

--5)
CREATE TABLE BATEAU (
    nbat    NUMBER(3)   NOT NULL ,
	nombat  VARCHAR2(40) NOT NULL,
	sponsor VARCHAR2(40) NOT NULL ,
	CONSTRAINT PK_NBAT PRIMARY KEY (nbat)
);
--6)
INSERT INTO BATEAU (nbat , nombat , sponsor) VALUES (102 , 'TASSILI' , 'DJEZZY') ;
INSERT INTO BATEAU (nbat , nombat , sponsor) VALUES (103 , 'El BAHDJA' , 'BNA') ;
INSERT INTO BATEAU (nbat , nombat , sponsor) VALUES (104 , 'LA COLOMBE' , 'NEDJMA') ;
INSERT INTO BATEAU (nbat , nombat , sponsor) VALUES (105 , 'HOGGAR' , 'BNA') ;

--7)
ALTER TABLE BATEAU
ADD (NbC NUMBER(3) DEFAULT 0) ;

--8)
CREATE TABLE COMPETITION (
      ncomp     NUMBER(3)   NOT NULL ,
	  nomcomp   VARCHAR2(40) NOT NULL ,
      datcomp   DATE         NOT NULL ,
      prixcomp  NUMBER(10)    NOT NULL ,
	  CONSTRAINT PK_NCOMP PRIMARY KEY (ncomp)
);
--9)
CREATE TABLE S_COMPETITION (
             NumC     NUMBER(3) ,
			 Nomcomp  VARCHAR(40) ,
			 NbC      NUMBER(3) DEFAULT 0
);

CREATE SEQUENCE COMPTEUR_AUTOMATIQUE ;

INSERT INTO S_COMPETITION (NumC , Nomcomp	) VALUES (COMPTEUR_AUTOMATIQUE.NEXTVAL , 'COURSE DE LA LIBERTE') ;
INSERT INTO S_COMPETITION (NumC , Nomcomp ) VALUES (COMPTEUR_AUTOMATIQUE.NEXTVAL , 'LE GRAND TOUR') ;
INSERT INTO S_COMPETITION (NumC , Nomcomp ) VALUES (COMPTEUR_AUTOMATIQUE.NEXTVAL , 'TROPHEE BARBEROUSSE') ;
	
--10)
CREATE TRIGGER Nb_COURSES_COMPETITION
AFTER INSERT ON COMPETITION
FOR EACH ROW
BEGIN
     UPDATE S_COMPETITION
	 SET NbC = NbC + 1 
	 WHERE (:New.Nomcomp = Nomcomp) ;
END ;
/	

--11)
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (200 , 'LE GRAND TOUR' , '21/03/200' , 1000000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (210 , 'COURSE DE LA LIBERTE' , '05/05/2004' , 1000000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (215 , 'LE GRAND TOUR' , '20/03/2005' , 1100000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (220 , 'TROPHEE BARBEROUSSE' , '01/08/2005' , 1500000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (240 , 'COURSE DE LA LIBERTE' , '10/05/2007' , 1500000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (260 , 'TROPHEE BARBEROUSSE' , '01/08/2009' , 2000000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp) VALUES (265 , 'LE GRAND TOUR' , '21/03/2010' , 2000000) ;
INSERT INTO COMPETITION (ncomp , nomcomp , datcomp , prixcomp)VALUES  (270 , 'COURSE DE LA LIBERTE' , '08/05/2010' , 1800000) ;

--12)
SELECT * FROM S_COMPETITION ;

--13)
ALTER TABLE COMPETITION
ADD PREMIER NUMBER(3) ;

--14)
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

--15)
CREATE OR REPLACE TRIGGER Nb_COURSES_BATEAU
AFTER INSERT ON COURSES 
FOR EACH ROW
BEGIN 
     UPDATE BATEAU 
	 SET NbC =NbC +1 
	 WHERE :New.Nbat = Nbat ;
	 
	 UPDATE COMPETITION
	 SET PREMIER = :New.nbat
	 WHERE :New.Score = 1 
	 AND   :New.Ncomp = Ncomp ;	
END ;
/

--16)
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

--17)
SELECT * FROM BATEAU ;
SELECT * FROM COMPETITION ;

--18)
CREATE OR REPLACE TRIGGER SUPPRESSION_COURSES
AFTER DELETE ON COURSES
FOR EACH ROW 
BEGIN
     UPDATE BATEAU 
	 SET NbC = NbC - 1 
	 WHERE nbat = :Old.nbat ;
	 
	 UPDATE COMPETITION 
	 SET PREMIER = NULL
	 WHERE ncomp = :Old.ncomp
	 AND   PREMIER = :Old.nbat ;
END;
/

--19)
CREATE OR REPLACE TRIGGER MODIFICATION_SCORE
BEFORE  UPDATE OF Score ON COURSES
FOR EACH ROW 
BEGIN
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
	 
END ;
/ 
	