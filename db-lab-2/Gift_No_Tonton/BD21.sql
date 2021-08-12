/*creation des vues */

create view ListeBateaux(nbat,nombat) as select nbat,nombat from bateau;
select * from ListeBateaux;

insert into bateau values(106,'SIRTA','CEVITAL');
select * from ListeBateaux;
/* on remarque que le nouvel Bateau est affiché */

create view ListeNomsBateaux(nombat) as select nombat from Bateau;
select * from ListeNomsBateaux;

create view CompBateau(Ncomp,NbBat) as select Ncomp,count(Nbat) from Courses group by Ncomp;
select * from CompBateau;

insert into Courses values(102,220,3);
insert into Courses values(102,265,2);
select * from CompBateau;

select NomComp from Competetion where Ncomp in (select Ncomp from CompBateau where 
NbBat = (select Min(NbBat) from CompBateau));

select Ncomp from CompBateau where NbBat = (select count(NBat) from Bateau);

/* MAJ des vues */
insert into ListeBateaux values (107,'TOUAREG');
select * from Bateau;

/* les modifications et les suppression sont possibles au travers cette vue */

insert into ListeNomsBateaux values('ILLUSION');
/* erreur */
create table courses2(Nbat number(3),Ncomp number(3),score number(3));
insert into courses2 values(select * from courses);

create view VBateau as select nbat from courses2 group by nbat;

insert into VBateau values(103);
insert into VBateau values(109);
select * from courses2;
/* affichage des nouveaux tuples insérés par le biais de VBateau */

create or replace view VBateau( as select nbat, count(*) from courses2 group by nbat;
/* remplace la vue VBateau par la nouvelle