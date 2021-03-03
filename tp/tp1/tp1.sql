                                            -- TP: Création et contrôle de tables

--Exercice 1:

/*
**  Créer  la  nouvelle  table  "table_test"  contenant  deux  champs: 
**  un  champ  entier appelé  Code  qui  doit  toujours  être  saisi  et 
**  un  champ appelé  Nom  contenant  une chaîne de 5 caractères.2
*/

CREATE TABLE table_test(
    Code INTEGER NOT NULL,
    Nom CHAR(5)
);

/*
**  Un client est définit par son identifiantde type numérique,
**  son nom, son adresse et sa date de naissance. Créer cette table.
*/

CREATE TABLE client(
    identifiantde INTEGER NOT NULL,
    nom VARCHAR(50),
    adresse VARCHAR(250),
    date_de_naissance DATE
);

--Exercice2:
/*
**      Soit  la table Etudiant suivante
**     
**    N°  Nom         Prénom  Age Sexe    Ville
**    1   KACHLOUL    Hassan  17  M       Rabat
**    2   MRABET      Salwa   19  F       Essaouira
**    3   ZAHOURI     Ali     18  M       Casablanca
**    4   SEBTI       Rachid  18  M       Marrakech
**
**  Supprimer le champ «Age».
**/

CREATE TABLE Etudiant(
    N INTEGER,
    Nom VARCHAR(50),
    Prénom VARCHAR(50),
    Age INTEGER,
    Sexe CHAR(1),
    Ville VARCHAR(50)
);

ALTER TABLE Etudiant DROP COLUMN AGE;

/*
**  Ajouter à la table Etudiant le champ Code_Postal    (Entier).
*/

ALTER TABLE Etudiant ADD Code_Postal INTEGER;

/*
**  Modifier le champ Code_Postalpour qu’il soit une chaine de caractère.
*/

ALTER TABLE Etudiant MODIFY Code_Postal VARCHAR(50);

--Exercice 3:

/*
**  Créer une table Voiture  avec les contraintes suivantes:
    [CarNo (PK), Constructeur, Modèle, Année, Age, Couleur, Kilomètres]
    Tous les champs sont obligatoires sauf Couleur. Les  seules  valeurs  possibles  pour Constructeur  sont:‘HONDA’,  ‘TOYOTA’, ‘NISSAN’La  base  de  données  doit  rejeter  toute  ligne  où  Kilomètres  est  supérieur  à 25000*Age
*/

CREATE TABLE Voiture(
    CarNo INTEGER NOT NULL,
    Constructeur VARCHAR(50) NOT NULL,
    Modele VARCHAR(50) NOT NULL CHECK (Modele IN ('HONDA', 'TOYOTA', 'NISSAN')),
    Annee VARCHAR(50) NOT NULL,
    Age INTEGER NOT NULL,
    Couleur VARCHAR(50),
    Kilometres INTEGER NOT NULL CHECK (Kilometres < (25000 * Age))
);

/*
**  Créer une table Propriétaire: [PropID (PK), Pnom, Ptel, DriversLicense ]
**  Petl est un champ optionnel.
*/

CREATE TABLE Propriétaire(
    PropID INTEGER NOT NULL PRIMARY KEY,
    Prénom VARCHAR(50) NOT NULL,
    Ptel CHAR(10),
    DriversLicense VARCHAR(50) NOT NULL,
);

/*
** Créer une table Prop_Voiture sans clés étrangères:[PropID (PK), CarNo (PK), Prix]   
*/

CREATE TABLE Prop_Voiture(
    PropID INTEGER NOT NULL,
    CarNo INTEGER NOT NULL,
    CONSTRAINT PK PRIMARY KEY (PropID, CarNo)
);

/*
**  Ajouter la clé étrangère qui va rapporter la table Prop_Voiture à la table Propriétaire.
*/

ALTER TABLE Prop_Voiture
    ADD CONSTRAINT FK FOREIGN KEY (PropID) REFERENCES (Propriétaire);

/*
**  Assurez-vous   que   la   base   de   données   ne   permettra   pas   à   la   **  valeur   de DriversLicense d’être insérée dans une nouvelle ligne si cette valeur **    a déjà été utilisée dans une autre ligne. 
*/

ALTER TABLE Propriétaire
    ADD CONSTRAINT DriversLicense UNIQUE;

/*
**  Ajouter l’attribut Padresseà la table Propriétaire. Sa taille est 30 caractères.
*/

ALTER TABLE Propriétaire
    ADD Padresse VARCHAR(30);