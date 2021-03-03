                        --TP2: Définitionet manipulationdes données

--1.Introduction au langage SQL
/**
**  Création d'une table
**  Question1:  Créer une table qui s’appelle BIBLIO enregistrant  les  livres  vendus  par  une librairie. Nous lui donnerons la structure suivante :
**
**  Nom         type        contrainte          signification
**  Titre       Char(20)    NOT NULL UNIQUE     Titre du livre
**  Auteur      Char(12)    NOT NULL            Son auteur
**  Genre       Char(7)     NOT NULL            Son genre (policier, roman, BD,...)
**  Achat       Date        NOT NULL            Date d’achat du livre
**  Prix        Number(6,2) NOT NULL            Sonprix
**  Disponible  Char(1)     NOT NULL            Est-il disponible? o (oui),  n(non).
*/

CREATE TABLE BIBLIO(
    Titre CHAR(20) NOT NULL UNIQUE,
    Auteur Char(12) NOT NULL,
    Genre CHAR(7) NOT NULL,
    Achat DATE NOT NULL,
    Prix NUMBER(6,2) NOT NULL,
    Disponible CHAR(1) NOT NULL
);

/*
**  1.2 Remplissage d'une table
**  Question2: Remplir, comme suit, la table Biblio déjà créée
**  TITRE               AUTEUR          GENRE       ACHAT       PRIX    D
**  ---------------------------------------------------------------------
**  Candide             Voltaire        Essai       18/10/85    140     o
**  Les fleurs du mal   Baudelaire      Poème       01/01/78    120     n
**  Tintin au Tibet     Hergé           BD          10/11/90    70      o
**  La terre            Zola            roman       12/06/90    50      n
**  Madame Bovary       Flaubert        Roman       12/05/88    130     o
**  Manhattan transfer  Dos Passos      Roman       30/08/87    320     o
**  Tintin en Amérique  Hergé           BD          15/05/91    70      o
**  Du côté de ch Swann Prous           Roma        08/12/78    200     o
*/

INSERT INTO BIBLIO
    VALUES
        ('Candide', 'Voltaire', 'Essai', date '18/10/85', 140, 'o'),
        ('Les fleurs du mal', 'Baudelaire', 'Poème', date'01/01/78', 120, 'n'),
        ('Tintin au Tibet', 'Hergé', 'BD', date '10/11/90', 70, 'o'),
        ('La terre', 'Zola', 'roman', date '12/06/90, 50', 'n'),
        ('Madame Bovary', 'Flaubert', 'Roman', date '12/05/88', 130, 'o'),
        ('Manhattan transfer', 'Dos Passos', 'Roman', date '30/08/87', 320, 'o'),
        ('Tintin en Amérique', 'Hergé', 'BD', date '15/05/91', 70, 'o'),
        ('Du côté de ch Swann', 'Prous', 'Roma', date '08/12/78', 200, 'o');

/*
**  1.3 Consultation de la table
**  Question3: Afficher toutes les colonnes et lignes de la table biblio.
*/

SELECT * FROM BIBLIO;

/*
**  Question4: Afficher les titres des livres, leurs auteurs et leurs prix.
*/

SELECT Titre, Auteur, Prix FROM BIBLIO;

/*
**  Question5:Quels sont les livres (titre et prix) qui coûtent plus de 100?
*/

SELECT TITRE, PRIX FROM BIBLIO
    WHERE Prix > 100;

/*
**  Question6:Quels sont les prix des livres de genre ‘roman’? (titre, prix et genre).
*/

SELECT TITRE, GENRE, PRIX FROM BIBLIO
    WHERE Genre == 'Roman';

/*
**  Question7:Quels sont les livres de genre roman et qui coutent moins de 100?
*/

SELECT TITRE, GENRE, PRIX FROM BIBLIO
    WHERE Genre == 'Roman' AND Prix < 100;

/*
**  Question8:Quels sont les livres de genre roman ou BD?
*/

SELECT TITRE, GENRE FROM BIBLIO
    WHERE Genre == 'Roman' OR Genre == 'BD';

/*
**  Question9:Quels sont les livres qui ne sont ni roman ni bande dessinée?
*/

SELECT TITRE, GENRE FROM BIBLIO
    WHERE NOT (Genre == 'Roman' OR Genre == 'BD');

/*
**  Question10:Ordonner la table biblio suivant des achats décroissants.
*/

SELECT * FROM BIBLIO
    ORDER BY Prix DESC

/*
**  Question11:Afficher la table biblio suivant l’ordre croissant des prix.
*/

SELECT * FROM BIBLIO
    ORDER BY Prix

/*
**  Question12:Afficher la table biblio suivant l’ordre décroissant des prix et du genre
*/

SELECT * FROM BIBLIO
    ORDER BY Prix, Genre

/*
**  Question13:Supprimer de la table biblio les livres de titre ‘candide’.
*/

DELETE FROM BIBLIO
    WHERE Titre == 'candide';

/*
**  Question14:Mettre tous les genres en majuscule.
*/

UPDATE Genre FROM BIBLIO AS Gr
    set genre = UPPER(Gr);

/*
**  Question15:Augmenter les prix des romansde 5%.
*/

UPDATE Prix FROM BIBLIO AS Pr
    set Prix = (pr + (pr / 100) * 5);

/*
**  Question16:Créer une table cheaps, avec pour colonnes: titre, auteur, prix de la table biblio
**              n'enregistrant que les livres d'un prix inférieur à 100 francs
*/

CREATE TABLE cheaps AS(
    SELECT Titre, Auteur, Prix
        WHERE(Prix < 100));

/*
**  Question17:Crée une table appelée vide qui a la structure de la table biblio mais qui sera vide
*/

CREATE TABLE vide AS(
    SELECT *
        WHERE (1 == 2));

