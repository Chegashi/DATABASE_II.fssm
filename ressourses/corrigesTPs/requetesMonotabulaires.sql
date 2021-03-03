-- Exercice 1

SELECT nomMod 
FROM MODULE;

-- Exercice 2

SELECT DISTINCT numModPrereq 
FROM PREREQUIS 

-- Exercice 3

SELECT nomMod 
FROM MODULE 
WHERE numMod IN (1, 3, 5);

-- Exercice 4

SQL> SELECT * FROM MODULE WHERE nomMod = 'Algo avancée';

    NUMMOD NOMMOD
---------- ------------------------------
         8 Algo avancée

1 ligne sélectionnée.

SQL> UPDATE prerequis SET noteMin = 12 WHERE numMod = 8;
SQL>  SELECT *   FROM module WHERE nomMod = 'PL/SQL Oracle';

    NUMMOD NOMMOD
---------- ------------------------------
         6 PL/SQL Oracle

1 ligne sélectionnée.
SQL> UPDATE prerequis SET noteMin = 11 WHERE numMod = 6;


-- Exercice 5

SELECT numModPrereq, noteMin 
FROM PREREQUIS 
WHERE numMod = 6 
ORDER BY noteMin;

-- Exercice 6

SELECT numMod 
FROM prerequis 
WHERE numModPrereq = 5 
AND noteMin > 10;

-- Exercice 7 

SELECT nomMod 
FROM module 
WHERE nomMod LIKE '%Algo%' 
	OR nomMod LIKE '%SQL%';

-- Exercice 8

DELETE FROM intervalle 
WHERE borneSup < borneInf;

-- Exercice 9 

DELETE FROM rectangle 
WHERE xHautGauche = xBasDroit 
	OR yHautGauche = yBasDroit;

-- Exercice 10

SELECT * 
FROM intervalle 
WHERE 10 BETWEEN borneInf AND borneSup;

-- Exercice 11

SELECT * 
FROM intervalle 
WHERE borneInf <= 5 AND borneSup >= 7;

SELECT * 
FROM intervalle 
WHERE borneInf >= 5 AND borneSup <= 35;

SELECT * 
FROM intervalle 
WHERE (15 BETWEEN borneInf AND borneSup) 
	OR (20 BETWEEN borneInf AND borneSup) 
	OR (borneInf BETWEEN 15 AND 20);

-- Exercice 12

SELECT * 
FROM rectangle 
WHERE (xHautGauche > xBasDroit) 
	OR (yHautGauche < yBasDroit);

-- Exercice 13

UPDATE rectangle SET 
	xHautGauche = xBasDroit, 
	xBasDroit = xHautGauche 
WHERE xHautGauche > xBasDroit;

UPDATE rectangle SET 
	yHautGauche = yBasDroit, 
	yBasDroit = yHautGauche 
WHERE yHautGauche < yBasDroit;

-- Exercice 14

SELECT * 
FROM rectangle 
WHERE (2 BETWEEN xHautGauche AND xBasDroit) 
	AND (2 BETWEEN yBasDroit AND yHautGauche);
