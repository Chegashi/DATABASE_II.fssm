-- Exercice 1

SELECT nomfou, 
	(SELECT COUNT(numprod)
	FROM PROPOSER P
	WHERE P.numfou = F.numfou
	) AS NB_PROD_PROPOSES
FROM FOURNISSEUR F;

-- Exercice 2

SELECT nomfou
FROM FOURNISSEUR
WHERE numfou IN
	(SELECT numfou
	FROM PROPOSER
	WHERE numprod = 2);

-- Exercice 3

SELECT nomfou
FROM FOURNISSEUR
WHERE numfou IN
	(SELECT numfou
	FROM PROPOSER
	WHERE numprod =
		(SELECT numprod
		FROM PRODUIT
		WHERE nomprod = 'Poupée Batman'
		)
	);

-- Exercice 4

SELECT nomfou
FROM FOURNISSEUR
WHERE numfou IN
	(SELECT numfou
	FROM DETAILLIVRAISON
	WHERE numprod IN
		(SELECT numprod
		FROM PRODUIT
		WHERE nomprod = 'Poupée Batman'
		)
	);

-- Exercice 5

SELECT nomfou 
FROM FOURNISSEUR F 
WHERE 
	numfou IN
	       (SELECT numfou
	       FROM PROPOSER)
AND
	(SELECT COUNT(DISTINCT numprod)
	FROM DETAILLIVRAISON D
	WHERE F.numfou = D.numfou
	)
	=
	(SELECT COUNT(*)
	FROM PROPOSER PR
	WHERE F.numfou = PR.numfou
	);

-- Exercice 6

SELECT nomfou, 
	(SELECT nomprod 
	FROM PRODUIT P
	WHERE P.numprod IN
		(SELECT numprod
		FROM PROPOSER PR1
		WHERE PR1.numfou = F.numfou
		AND prix = 
			(SELECT MAX(prix)
			FROM PROPOSER PR2
			WHERE PR2.numfou = F.numfou
			)
		)
	)
FROM FOURNISSEUR F;

-- Exercice 7

CREATE VIEW NB_PROD_LIVRES_PAR_FOU AS
SELECT numfou, numprod, SUM(qte) AS QTE
FROM DETAILLIVRAISON
GROUP BY numfou, numprod;

SELECT nomprod, nomfou
FROM FOURNISSEUR F, PRODUIT P
WHERE 
	(SELECT QTE
	FROM NB_PROD_LIVRES_PAR_FOU D
	WHERE D.numprod = P.numprod
	AND D.numfou = F.numfou	
 	)
	= 
	(SELECT MAX(QTE)
	FROM NB_PROD_LIVRES_PAR_FOU D
	WHERE D.numprod = P.numprod
	);

-- Exercice 8

SELECT MIN(NB_PROD)
FROM 
	(SELECT 
		(SELECT COUNT(*) 
	 	 FROM PROPOSER PR
		 WHERE PR.numfou = F.numfou
		) AS NB_PROD
	 FROM FOURNISSEUR F
	);

-- Exercice 9

SELECT nomfou 
FROM FOURNISSEUR
WHERE numfou IN
	(sELECT numfou
	 FROM 
		(SELECT numfou, 
				(SELECT COUNT(*)
				 FROM PROPOSER PR
				 WHERE F.numfou = PR.numfou
				) AS NB_PROD
		 FROM FOURNISSEUR F
		)
	 WHERE NB_PROD =
		(SELECT MIN(NB_PROD)
		 FROM 
			(SELECT numfou, 
					(SELECT COUNT(*)
					 FROM PROPOSER PR
					 WHERE F.numfou = PR.numfou
					) AS NB_PROD
		 	FROM FOURNISSEUR F
			)
		)
	);


-- Exercice 10

SELECT nomprod, nomfou
FROM PRODUIT P, FOURNISSEUR F,
	(SELECT F1.numfou, P1.numprod 
	 FROM FOURNISSEUR F1, PRODUIT P1
	 WHERE 
		(SELECT SUM(QTE)
		 FROM DETAILLIVRAiSON D
		 WHERE D.numfou = F1.numfou
		 AND D.numprod = P1.numprod
		)
	 =
		(SELECT MAX(NB_LIV)
		 FROM
			(SELECT numprod, SUM(QTE) AS NB_LIV
			 FROM DETAILLIVRAiSON D
			 GROUP BY numprod, numfou
			) Q
		 WHERE Q.numprod = P1.numprod
		)
	) M
WHERE P.numprod = M.numprod 
AND F.numfou = M.numfou;

