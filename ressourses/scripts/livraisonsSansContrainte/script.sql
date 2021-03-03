drop table PRODUIT;
drop table FOURNISSEUR;
drop table PROPOSER;
drop table LIVRAISON;
drop table DETAILLIVRAISON;

CREATE TABLE PRODUIT
(numprod integer,
nomprod varchar(30));

CREATE TABLE FOURNISSEUR
(numfou integer,
nomfou varchar(30));

CREATE TABLE PROPOSER
(numfou integer, 
numprod integer,
prix real);

CREATE TABLE LIVRAISON
(numfou integer,
numli integer,
dateli date
);

CREATE TABLE DETAILLIVRAISON
(numfou integer,
numli integer,
numprod integer,
qte integer);
