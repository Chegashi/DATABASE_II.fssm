-- Exercice 1

SELECT COUNT(*) 
FROM FOURNISSEUR;

-- Exercice 2

SELECT COUNT(DISTINCT NUMFOU) 
FROM LIVRAISON;

-- Exercice 3

SELECT MAX(prix) AS PRIX_MAX 
FROM PROPOSER PR, FOURNISSEUR F 
WHERE F.numfou = PR.numfou 
AND nomfou = 'Paramédical Gisèle';

-- Exercice 4

SELECT nomfou, count(DISTINCT numprod) AS NB_PROD_PROPOSES 
FROM FOURNISSEUR F, PROPOSER P 
WHERE F.numfou = P.numfou 
GROUP BY nomfou;

-- Exercice 5

SELECT COUNT(DISTINCT P.numprod) - count(DISTINCT PR.numprod) 
FROM PRODUIT P, PROPOSER PR;

-- Exercice 6

SELECT nomprod, COUNT(DISTINCT D.numfou) 
FROM PRODUIT P, DETAILLIVRAISON D 
WHERE P.numprod = D.numprod 
GROUP BY nomprod;

-- Exercice 7

SELECT nomfou, L.numli, dateli, COUNT(numprod) AS NB_PRODUITS 
FROM FOURNISSEUR F, LIVRAISON L, DETAILLIVRAISON D 
WHERE F.numfou = L.numfou 
AND D.numfou = L.numfou 
AND D.numli = L.numli 
GROUP BY nomfou, L.numli, dateli;

-- Exercice 8

SELECT nomfou, L.numli, dateli, SUM(qte * prix) AS TOTAL 
FROM FOURNISSEUR F, LIVRAISON L, DETAILLIVRAISON D, PROPOSER P 
WHERE F.numfou = L.numfou 
AND D.numfou = L.numfou 
AND D.numli = L.numli 
AND P.numfou = F.numfou 
AND D.numprod = P.numprod 
GROUP BY nomfou, L.numli, dateli; 

-- Exercice 9

SELECT nomprod
FROM PRODUIT P, PROPOSER PR 
WHERE P.numprod = PR.numprod 
GROUP BY nomprod
HAVING COUNT(*) = 1;

-- Exercice 10

SELECT nomfou 
FROM FOURNISSEUR F, PROPOSER P, DETAILLIVRAISON L
WHERE F.numfou = P.numfou 
AND L.numfou = F.numfou
GROUP BY nomfou
HAVING COUNT(DISTINCT P.numprod) = COUNT(DISTINCT L.numprod);
