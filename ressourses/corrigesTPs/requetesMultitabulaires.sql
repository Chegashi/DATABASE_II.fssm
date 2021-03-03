-- Exercice 1

SELECT distinct nomprod 
FROM produit, proposer 
WHERE produit.numprod = proposer.numprod;

-- Exercice 2

SELECT distinct nomfou 
FROM fournisseur f, proposer p 
WHERE f.numfou = p.numfou;

-- Exercice 3

SELECT nomfou, nomprod 
FROM fournisseur f, produit p, proposer pr
WHERE f.numfou = pr.numfou 
AND pr.numprod = p.numprod;

-- Exercice 4

SELECT nomfou, prix 
FROM fournisseur f, produit p, proposer pr
WHERE f.numfou = pr.numfou 
AND pr.numprod = p.numprod 
AND nomProd = 'Bocal de cornichons'
ORDER BY prix;

-- Exercice 5

SELECT dateli 
FROM livraison l, fournisseur f
WHERE l.numfou = f.numfou 
AND f.nomFou = 'Bocaux Gérard';

-- Exercice 6

SELECT nomprod 
FROM fournisseur f, produit p, detaillivraison d, livraison l
WHERE nomfou = 'Bocaux Gérard'
AND f.numfou = l.numfou
AND l.numfou = d.numfou
AND l.numli = d.numli
AND d.numprod = p.numprod
AND dateli < sysdate;

-- Exercice 7

SELECT l.numfou, l.numli, dateli 
FROM produit p, livraison l, detaillivraison d
WHERE p.numprod = d.numprod
AND l.numfou = d.numfou
AND l.numli = d.numli
AND p.nomprod = 'Bocal de cornichons';

-- Exercice 8

SELECT enfant.nom, enfant.prenom
FROM personne enfant, personne robert
WHERE enfant.pere = robert.numpers
AND robert.nom = 'Baratheon' AND robert.prenom = 'Robert';

-- Exercice 9

SELECT parent.nom, parent.prenom
FROM personne stannis, personne parent
WHERE parent.numpers in (stannis.pere, stannis.mere)
AND stannis.nom = 'Baratheon' AND stannis.prenom = 'Stannis';

-- Exercice 10

SELECT enfant.nom, enfant.prenom
FROM personne enfant, personne robert, personne cersei
WHERE enfant.pere = robert.numpers
AND enfant.mere = cersei.numpers
AND robert.nom = 'Baratheon' AND robert.prenom = 'Robert'
AND cersei.nom = 'Lannister' AND cersei.prenom = 'Cersei';

-- Exercice 11

SELECT frere.nom, frere.prenom
FROM personne frere, personne renly
WHERE frere.pere = renly.pere 
AND frere.mere = renly.mere 
AND renly.nom = 'Baratheon' AND renly.prenom = 'Renly'
AND frere.numpers <> renly.numpers;

-- Exercice 12

SELECT cousin.nom, cousin.prenom
FROM personne cousin, personne oncle, personne pere, personne shireen
WHERE shireen.nom = 'Baratheon' AND shireen.prenom = 'Shireen'
AND shireen.pere = pere.numpers
AND pere.pere = oncle.pere
AND pere.mere = oncle.mere 
AND pere.numpers <> oncle.numpers
AND oncle.numpers IN (cousin.pere, cousin.mere); 
/* Attention, sur certaines versions de mysql, les NULL font bugger le moteur de requetes. */

-- Exercice 13

SELECT DISTINCT demifrere.nom, demifrere.prenom
FROM personne demifrere, personne cersei, personne enfant
WHERE cersei.nom = 'Lannister' AND cersei.prenom = 'Cersei'
AND enfant.mere = cersei.numpers
AND enfant.pere = demifrere.pere
AND enfant.mere <> demifrere.mere;

-- Exercice 14

SELECT DISTINCT mere.nom, mere.prenom
FROM personne tywin, personne mere, personne enfant
WHERE tywin.nom = 'Lannister' AND tywin.prenom = 'Tywin'
AND enfant.mere = mere.numpers
AND enfant.pere = tywin.numpers;

-- Exercice 15

SELECT neveu.nom, neveu.prenom
FROM personne neveu, personne stannis, personne frere
WHERE stannis.prenom = 'Stannis' AND stannis.nom = 'Baratheon'
AND frere.pere = stannis.pere
AND frere.mere = stannis.mere
AND frere.numpers <> stannis.numpers
AND frere.numpers IN (neveu.pere, neveu.mere)
AND neveu.pere IS NOT NULL
AND neveu.mere IS NOT NULL; 
/* Attention, sur certaines versions de mysql, les NULL font bugger le moteur de requetes. */

-- Exercice 16

SELECT DISTINCT bru.nom, bru.prenom
FROM personne petitenfant, personne enfant, personne cassana, personne bru
WHERE enfant.mere = cassana.numpers
AND enfant.numpers IN (petitenfant.pere, petitenfant.mere)
AND bru.numpers = petitenfant.mere
AND cassana.nom = 'Estermont' AND cassana.prenom = 'Cassana';

-- Exercice 17

SELECT grandparent.nom, grandparent.prenom
FROM personne tommen, personne parent, personne grandparent
WHERE tommen.nom = 'Baratheon' AND tommen.prenom = 'Tommen'
AND (grandparent.numpers IN (parent.pere, parent.mere)
OR grandparent.numpers = parent.numpers)
AND parent.numpers IN (tommen.pere, tommen.mere);
