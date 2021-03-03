-- questions 1, 2 et 3

DROP TABLE DETAILLIVRAISON; 
DROP TABLE LIVRAISON; 
DROP TABLE PROPOSER; 
DROP TABLE PRODUIT; 
DROP TABLE FOURNISSEUR; 

CREATE TABLE PRODUIT
(numprod number PRIMARY KEY,
nomprod varchar2(30));

CREATE TABLE FOURNISSEUR
(numfou number PRIMARY KEY,
nomfou varchar2(30));

CREATE TABLE PROPOSER
(numfou number, 
numprod number,
prix number NOT NULL,
PRIMARY KEY (numfou, numprod),
FOREIGN KEY (numfou) REFERENCES fournisseur (numfou),
FOREIGN KEY (numprod) REFERENCES produit (numprod));

CREATE TABLE LIVRAISON
(numfou number,
numli number,
dateli date default sysdate,
PRIMARY KEY (numfou, numli),
FOREIGN KEY (numfou) REFERENCES fournisseur (numfou));

CREATE TABLE DETAILLIVRAISON
(numfou number,
numli number,
numprod number,
qte number NOT NULL,
PRIMARY KEY (numfou, numli, numprod),
FOREIGN KEY (numfou, numli) REFERENCES livraison (numfou, numli),
FOREIGN KEY (numfou, numprod) REFERENCES proposer (numfou, numprod));
		
-- question 4

INSERT INTO PRODUIT values (1, 'Roue de secours');
INSERT INTO PRODUIT values (2, 'Poupée Batman');
INSERT INTO PRODUIT values (3, 'Cotons tiges');
INSERT INTO PRODUIT values (4, 'Cornichons');

INSERT INTO FOURNISSEUR values (1, 'f1');
INSERT INTO FOURNISSEUR values (2, 'f2');
INSERT INTO FOURNISSEUR values (3, 'f3');
INSERT INTO FOURNISSEUR values (4, 'f4');

INSERT INTO PROPOSER values (1, 1, 200);
INSERT INTO PROPOSER values (1, 2, 15);
INSERT INTO PROPOSER values (2, 2, 1);
INSERT INTO PROPOSER values (3, 3, 2);

INSERT INTO LIVRAISON (numfou, numli) values (1, 1);
INSERT INTO LIVRAISON (numfou, numli) values (1, 2);
INSERT INTO LIVRAISON (numfou, numli) values (3, 1);

INSERT INTO DETAILLIVRAISON values (3, 1, 3, 10);
INSERT INTO DETAILLIVRAISON values (1, 1, 1, 25);
INSERT INTO DETAILLIVRAISON values (1, 1, 2, 20);
INSERT INTO DETAILLIVRAISON values (1, 2, 1, 15);
INSERT INTO DETAILLIVRAISON values (1, 2, 2, 17);

-- question 5

-- Le script ci-dessous va vous afficher la solution. 
-- Vous pouvez procéder de deux façons : 
-- * copier-coller cette solution affichée 
-- par cette série de commandes

set und off
set heading off
set feed off
select 'alter table ' || table_name || ' drop constraint ' || 
	constraint_name || ';' from user_constraints 
where table_name in 
	('PRODUIT', 'FOURNISSEUR', 'PROPOSER', 
	'LIVRAISON', 'DETAILLIVRAISON') 
AND constraint_type IN ('R', 'P') 
ORDER BY constraint_type DESC ;
set und on
set heading on
set feed on

-- * placer ceci dans le fichier dp.sql 
-- et l'exécuter en saisissant @<cheminabsolu>/dp.sql

set trimout off ;
Set feed off ;
set echo off ;
set heading off ;
set termout off ;
set verify off;
set space 0 ;
SET NEWPAGE 0 ;
SET PAGESIZE 0 ;
spool drop_constraints.lst
select 'alter table ' || table_name || ' drop constraint ' || 
	constraint_name || ';' from user_constraints 
where table_name in 
	('PRODUIT', 'FOURNISSEUR', 
	'PROPOSER', 'LIVRAISON', 'DETAILLIVRAISON') 
AND constraint_type IN ('R', 'P') 
ORDER BY constraint_type DESC ;
spool off
@drop_constraints.lst
set trimout on ;
Set feed on ;
set echo on ;
set heading on ;
set termout on ;
set verify on;

-- question 6

alter table produit add 
	constraint pk_produit 
	PRIMARY KEY (numprod);
alter table fournisseur add 
	constraint pk_fournisseur 
	PRIMARY KEY (numfou);
alter table proposer add 
	constraint pk_proposer 
	PRIMARY KEY (numfou, numprod);
alter table livraison add 
	constraint pk_livraison 
	PRIMARY KEY (numfou, numli);
alter table detaillivraison add 
	constraint pk_detail_livraison 
	PRIMARY KEY (numfou, numli, numprod);
alter table proposer add 
	constraint fk_proposer_fournisseur 
	FOREIGN KEY (numfou) 
	REFERENCES fournisseur (numfou);
alter table proposer add constraint fk_proposer_produit 
	FOREIGN KEY (numprod) 
	REFERENCES produit (numprod);
alter table livraison add constraint fk_livraison 
	FOREIGN KEY (numfou) 
	REFERENCES fournisseur (numfou);
alter table detaillivraison add constraint fk_detail_livraison 
	FOREIGN KEY (numfou, numli) 
	REFERENCES livraison (numfou, numli);
alter table detaillivraison add constraint fk_detail_livraison_proposer 
	FOREIGN KEY (numfou, numprod) 
	REFERENCES proposer (numfou, numprod);


