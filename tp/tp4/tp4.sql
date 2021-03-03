            --TP 4:Requêtes imbriquées


/**
**    Exercice 1:
**    Donner, pour chaque fournisseur (afficher son nom),
**    le nombre de produits proposés, même si ce fournisseur n'en propose aucun.
**/

SELECT Nomfou, (SELECT COUNT(*) FROM (
    numfou.PROPOSER = numprod.FOURNISSEUR
    AS NB_PROD_PROPOSES)
    FROM FOURNISSEUR;
)

/*
**  Exercice 2:
**  Afficher les noms des fournisseurs qui proposent le produit numéro 2, 
**    il est interdit de faire des jointures !
*/

SELECT nomfou FROM (SELECT numfou FROM PROPOSER 
                        WHERE numprod = 2 AS NF)
    WHERE NF = numfou;

/*
**  Exercice 3:
**  Afficher les noms des fournisseurs qui proposent des poupées Batman.
*/

SELECT nomfou FROM (SELECT numfou FROM PROPOSER 
                        WHERE nomprod = 'BATMAN' AS NF)
    WHERE NF = numfou;

/*
**  Exercice 4:
**  Afficher les noms des fournisseurs qui ont déjà livré des poupées Batman.
*/

SELECT nomfou FROM (SELECT numfou FROM DETAILLIVRAISON 
                        WHERE nomprod = 'BATMAN' AS NF)
    WHERE NF = numfou;

/*
**  Exercice 5:
**  Quels sont les noms des fournisseurs qui ont déjà livré tous leurs produits au moins une fois ?
*/


SELECT Nomfou FROM FOURNISSEUR
    WHERE numfou IN (SELECT numprod FROM PRODUIT)  

/*
**  Exercice 6:
**  Donner, pour chaque fournisseur (afficher son nom), le produit proposé au prix le plus élevé.
*/


/*
**  Exercice 7:
**  Pour chaque produit p, quel sont les noms des fournisseurs qui, sur toutes ses livraisons, ont livré la plus grande quantité cumulée de produits p.
*/


/*
**  Exercice 8:
**  Afficher le nombre de produits proposés par les fournisseurs proposant le moins de produits. Normalement, un 0devrait s'afficher... Pas un 1.
*/


/*  Exercice 9:
**  Afficher le(s) nom(s) du(des) fournisseur(s) proposant le moins de produits.
*/

/*
**  Exercice 10
**  Afficher, pour chaque produit, le(s) nom(s) du(des) fournisseur(s) qui l'a(ont) leplus livré (en quantité cumulée).
*/