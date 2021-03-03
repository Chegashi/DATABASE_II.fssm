            --TP3: Jointures + fonctions d’agrégation

CREATE TABLE PRODUIT(
    Numprod INTEGER PRIMARY KEY,
    Nomprod VARCHAR(25)
);

CREATE TABLE FOURNISSEUR(
    Numfou INTEGER PRIMARY KEY,
    Nomfou VARCHAR(50)
);

CREATE TABLE PROPOSER(
    Numfou INTEGER PRIMARY KEY,
    Numprod VARCHAR(50),
    Prix INTEGER
);

ALTER TABLE PROPOSER
    ADD CONSTRAINT PK PRIMARY KEY ( Numfou, Numprod);

ALTER TABLE PROPOSER
    ADD CONSTRAINT FK FOREIGN KEY (numfou , numprod) REFERENCES(PROPOSER);

CREATE TABLE LIVRAISON(
    Numfou INTEGER,
    Numli INTEGER ,
    dateli DATE
);

ALTER TABLE LIVRAISON
    ADD CONSTRAINT PK PRIMARY KEY (Numfou, Numli);

ALTER TABLE LIVRAISON
    ADD CONSTRAINT FK FOREIGN KEY (Numfou);

CREATE TABLE DETAILLIVRAISON(
    Numfou INTEGER,
    Numli INTEGER,
    Numprod INTEGER,
    Qte INTEGER
)

ALTER TABLE DETAILLIVRAISON
    ADD PK PRIMARY KEY (Numfou, Numli, Numprod);

ALTER TABLE DETAILLIVRAISON
    ADD FK FOREIGN KEY (Numfou, Numli) REFERENCES (LIVRAISON);

ALTER TABLE DETAILLIVRAISON
    ADD FK FOREIGN KEY (Numfou, Numprod) REFERENCES (PROPOSER);

INSERT INTO PRODUIT
    values
        (1, 'Roue de secours'),
        (2, 'Poupée batman'),
        (3, 'Cotons tiges'),
        (4, 'cornichons');

INSERT INTO FOURNISSEUR
    values
        (1, 'F1'),
        (2, 'F2'),
        (3, 'F3'),
        (3, 'F4');

INSERT INTO PROPOSER
    values
        (1, 1, 200),
        (1, 2, 15),
        (2, 2, 1),
        (3, 3, 2);

INSERT INTO LIVRAISON
    values
        (1, 1, now()),
        (1, 2, now()),
        (3, 1, now());

INSERT INTO DETAILLIVRAISON
    values
        (3, 1, 3, 10),
        (1, 1, 1, 25),
        (1, 1, 2, 20),
        (1, 2, 1, 15),
        (1, 2, 2, 17);

--  A-Jointures

/*
**  Afficher tous les noms des produits dont le numéro a une occurrence dans la table PROPOSER
*/

SELECT Nomprod FROM PRODUIT, fournisseur
    WHERE Numprod.PROPOSER = Numprod.PRODUIT;

/*
**  Afficher tous les noms des fournisseurs dont le numéro a une occurrencedans la table PROPOSER
*/

SELECT Nomfou FROM FOURNISSEUR, PROPOSER
    WHERE numfou.FOURNISSEUR == Numfou.PROPOSER;

/*
**  Afficher les noms des fournisseurs avec pour chaque fournisseur la liste des produits proposés.
*/

SELECT Nomfou.fournisseur, Nomprod.produit FROM PROPOSER, FOURNISSEUR, PRODUIT
    WHERE (numfou.PROPOSER = numfou.FOURNISSEUR AND numprod.PROPOSER = numprod.PRODUIT)

/*
**  Afficher les noms des fournisseurs proposant des 'Poupées Batman' par ordre de prix croissant.
*/

SELECT Nomfou.fournisseur, Nomprod.produit FROM PROPOSER, FOURNISSEUR, PRODUIT
    WHERE (numfou.PROPOSER = numfou.FOURNISSEUR AND numprod.PROPOSER = numprod.PRODUIT AND numprod == 'Poupées Batman');

/*
**  Afficher les noms de tous les produits déjà livrés par le fournisseur 'f3' ;
*/

SELECT nomprod FROM DETAILLIVRAISON, FOURNISSEUR, PRODUIT
    WHERE numfou.DETAILLIVRAISON = numfou.FOURNISSEUR AND numprod.DETAILLIVRAISON = numprod.PRODUIT AND Nomfou.FOURNISSEUR ='f3'

--  B-Fonctions d’agrégation

/*
**  Donner le nombre de fournisseurs.
*/

SELECT COUNT(Numfou) FROM FOURNISSEUR;

/*
**  Donner le nombre de fournisseurs ayant déjà effectuée une livraison
*/

SELECT COUNT (Numfou) UNIQUE FROM DETAILLIVRAISON; 

/*
**  Quel est le prix du produit proposé au prix le plus élevé par 'f1' ?
*/

SELECT MAX(Prix) FROM PROPOSER , FOURNISSEUR
    WHERE (numfou.FOURNISSEUR = numfou.PROPOSER AND Nomfou.FOURNISSEUR = 'f1');

/*
**  Combien de produits sont proposés pour chaque fournisseur proposant au moins un produit ?
*/

SELECT COUNT(numprod) as nbr, Nomfou FROM PROPOSER, FOURNISSEUR
    WHERE(numfou.FOURNISSEUR = numfou.PROPOSER AND Numprod.PRODUIT = numprod.FOURNISSEUR AND nbr > 0);

/*
**  Afficher le nombre de produits qui ne sont proposés par aucun fournisseur.
*/

SELECT COUNT(numprod) as nbr, Nomfou FROM PROPOSER, FOURNISSEUR GROUP BY Numfou.FOURNISSEUR
    WHERE(numfou.FOURNISSEUR = numfou.PROPOSER (+) AND Numprod.PRODUIT = numprod.FOURNISSEUR (+) AND = 0);


/*
**  Afficher, pour chaque produit (dont on affichera le nom), le nombre de fournisseurs l'ayant déjà livré.
*/

SELECT nomprod, COUNT(Nomfou) FROM DETAILLIVRAISON GROUP BY Numprod

/*
**  Donner pour chaque livraison le nom du fournisseur, le numéro de livraison et le nombre de produits livrés.
*/

SELECT Nomfou.FOURNISSEUR, Numli, COUNT(numprod) FROM FOURNISSEUR, DETAILLIVRAISON GROUP BY Numprod
    WHERE numfou.FOURNISSEUR = numfou.DETAILLIVRAISON;
