drop table if exists DETAILLIVRAISON;
drop table if exists LIVRAISON;
drop table if exists PROPOSER;
drop table if exists FOURNISSEUR;
drop table if exists PRODUIT;

CREATE TABLE PRODUIT
(numprod int,
nomprod varchar(64));

CREATE TABLE FOURNISSEUR
(numfou int,
nomfou varchar(64));

CREATE TABLE PROPOSER
(numfou int, 
numprod int,
prix int NOT NULL);

CREATE TABLE LIVRAISON
(numfou int,
numli int,
dateli date
);

CREATE TABLE DETAILLIVRAISON
(numfou int,
numli int,
numprod int,
qte int NOT NULL);

alter table PRODUIT add constraint pk_produit 
PRIMARY KEY (numprod);
alter table FOURNISSEUR add constraint pk_fournisseur 
PRIMARY KEY (numfou);
alter table PROPOSER add constraint pk_proposer 
PRIMARY KEY (numfou, numprod);
alter table LIVRAISON add constraint pk_livraison 
PRIMARY KEY (numfou, numli);
alter table DETAILLIVRAISON add constraint pk_detail_livraison 
PRIMARY KEY (numfou, numli, numprod);
alter table PROPOSER add constraint fk_proposer_fournisseur 
FOREIGN KEY (numfou) REFERENCES FOURNISSEUR (numfou);
alter table PROPOSER add constraint fk_proposer_produit 
FOREIGN KEY (numprod) REFERENCES PRODUIT (numprod);
alter table LIVRAISON add constraint fk_livraison 
FOREIGN KEY (numfou) REFERENCES FOURNISSEUR (numfou);
alter table DETAILLIVRAISON add constraint fk_detail_livraison 
FOREIGN KEY (numfou, numli) REFERENCES LIVRAISON (numfou, numli);
alter table DETAILLIVRAISON add constraint fk_detail_livraison_proposer 
FOREIGN KEY (numfou, numprod) REFERENCES PROPOSER (numfou, numprod);

INSERT INTO PRODUIT values
 (1, 'Bocal de cornichons'),
 (2, 'Tube de dentifrice'),
 (3, 'Flacon de lotion anti-escarres'),
 (4, 'Déodorant fraîcheur 96 heures');

INSERT INTO FOURNISSEUR values
 (1, 'Bocaux Gérard'),
 (2, 'Paramédical Gisèle'),
 (3, 'Tracteurs Raymond');

INSERT INTO PROPOSER values
 (1, 1, 2),
 (2, 1, 3),
 (2, 2, 2),
 (2, 3, 1);

INSERT INTO LIVRAISON values
 (1, 1, now()),
 (1, 2, now()),
 (2, 1, now());

INSERT INTO DETAILLIVRAISON values
 (1, 1, 1, 5),
 (1, 2, 1, 2),
 (2, 1, 2, 20),
 (2, 1, 3, 1);
