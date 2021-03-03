DROP TABLE RESULTAT;
DROP TABLE EXAMEN;
DROP TABLE PREREQUIS;
DROP TABLE INSCRIPTION;
DROP TABLE MODULE;
DROP TABLE ETUDIANT;

-- Exercice 1 et 3

CREATE TABLE ETUDIANT
	(numEtud number, 
	nom varchar2(40), 
	prenom varchar2(40), 
	datenaiss date, 
	civilite varchar2(4), 
	patronyme varchar2(40), 
	numsecu varchar2(15) NOT NULL);

CREATE TABLE MODULE
	(codMod number, 
	nomMod varchar2(15), 
	effecMax number DEFAULT 30);

CREATE TABLE EXAMEN
	(codMod number, 
	codExam number, 
	dateExam date);

CREATE TABLE INSCRIPTION
	(numEtud number, 
	codMod number, 
	dateInsc date default sysdate);

CREATE TABLE PREREQUIS
	(codMod number, 
	codModPrereq number, 
	noteMin number(4, 2) NOT NULL);

CREATE TABLE RESULTAT
	(codMod number, 
	codExam number, 
	numEtud number,
	note number(4, 2));

-- Exercice 2

ALTER TABLE ETUDIANT ADD 
	CONSTRAINT pk_etudiant 
	PRIMARY KEY (numEtud);
ALTER TABLE MODULE ADD 
	CONSTRAINT pk_module 
	PRIMARY KEY (codMod);
ALTER TABLE EXAMEN ADD 
	CONSTRAINT pk_examen 
	PRIMARY KEY (codMod, codExam);
ALTER TABLE PREREQUIS ADD 
	CONSTRAINT pk_prerequis 
	PRIMARY KEY (codMod, codModPrereq);
ALTER TABLE INSCRIPTION ADD 
	CONSTRAINT pk_inscription 
	PRIMARY KEY (codMod, numEtud);
ALTER TABLE RESULTAT ADD 
	CONSTRAINT pk_resultat 
	PRIMARY KEY (codMod, numEtud, codExam);

ALTER TABLE INSCRIPTION ADD 
	(CONSTRAINT fk_inscription_etudiant 
	FOREIGN KEY (numEtud) 
	REFERENCES ETUDIANT(numEtud),
	CONSTRAINT fk_inscription_module 
	FOREIGN KEY (codMod) 
	REFERENCES MODULE(codMod));
ALTER TABLE PREREQUIS ADD 
	(CONSTRAINT fk_prerequis_codmod 
	FOREIGN KEY (codMod) 
	REFERENCES MODULE(codMod),
	CONSTRAINT fk_prerequis_codmodprereq 
	FOREIGN KEY (codModPrereq) 
	REFERENCES MODULE(codMod));
ALTER TABLE EXAMEN ADD 
	CONSTRAINT fk_examen 
	FOREIGN KEY (codMod) 
	REFERENCES MODULE(codMod);
ALTER TABLE RESULTAT ADD 
	(CONSTRAINT fk_resultat_examen 
	FOREIGN KEY (codMod, codExam) 
	REFERENCES EXAMEN(codMod, codExam),
	CONSTRAINT fk_resultat_inscription 
	FOREIGN KEY (codMod, numEtud) 
	REFERENCES INSCRIPTION(codMod,numEtud));

-- Exercice 3

-- Ici se trouve les constraintes de type CHECK qui n'ont pas été placées 
-- au niveau de la table pour des raisons de lisibilité.

ALTER TABLE ETUDIANT ADD 
	(CONSTRAINT ck_civilite 
	CHECK
		(
		civilite IN ('Mr', 'Mme', 'Mlle')
		), 
	CONSTRAINT ck_civilite_numsecu 
	CHECK
		(
		SUBSTR(numsecu, 1, 1) = '2' OR patronyme IS NULL
		),
	CONSTRAINT ck_length_numsecu 
	CHECK
		(
		length(numsecu) = 15
		),
	CONSTRAINT ck_annee_numsecu CHECK
		(
		to_char(datenaiss, 'yy') = substr(numsecu, 2, 2)
		)
	);


-- Il impossible de limiter de façon déclarative le nombre d'étudiants 
-- inscrits à un module.

-- Exercice 4 

INSERT INTO ETUDIANT VALUES
	((SELECT nvl(MAX(numEtud), 0) + 1 FROM ETUDIANT),
	'Fourier',
	'Joseph',
	to_date('21031768', 'ddmmyyyy'), 
	'Mr',
	NULL, 
	'168031234567890'
	);

INSERT INTO MODULE (codMod, nomMod) VALUES 
	(
	(SELECT nvl(MAX(codMod), 0) + 1 FROM MODULE),
	'Maths'
	);

INSERT INTO INSCRIPTION (codMod, numEtud) VALUES 
	((SELECT numEtud FROM ETUDIANT WHERE nom = 'Fourier'),
	 (SELECT codMod FROM MODULE WHERE nomMod = 'Maths'));


INSERT INTO EXAMEN VALUES
	(
	(SELECT codMod FROM MODULE WHERE nomMod = 'Maths'),
	1,
	to_date('02012007', 'ddmmyyyy')
	);

INSERT INTO RESULTAT VALUES
	(
	(SELECT codMod FROM MODULE WHERE nomMod = 'Maths'),
	1, 
	(SELECT numEtud FROM ETUDIANT WHERE nom = 'Fourier'),
	19
	);

UPDATE RESULTAT SET note = 20 
wHERE 
	numEtud = (SELECT numEtud FROM ETUDIANT WHERE nom = 'Fourier')
	AND codMod = (SELECT codMod FROM MODULE WHERE nomMod = 'Maths')
	AND codExam = 1;


-- Exercice 5 

-- requête 1

SELECT nom 
FROM ETUDIANT;

-- requête 2

SELECT nom
FROM ETUDIANT 
WHERE numEtud IN
	(
	SELECT numEtud 
	FROM INSCRIPTION 
	WHERE codMod IN 
		(
		SELECT codMod 
		FROM MODULE 
		WHERE nomMod = 'Maths'
		)
	);


-- requête 3

SELECT nom, prenom, 
	(	
	SELECT MAX(NOTE)
	FROM RESULTAT R 
	WHERE R.numEtud = E.numEtud
	AND codMod = 
		(
		SELECT codMod 
		FROM MODULE 
		WHERE nomMod = 'Maths'
		)
	) AS NOTE_DEFINITIVE
FROM ETUDIANT E;

-- requête 4

SELECT nom, prenom 
FROM ETUDIANT E
WHERE 
	0 <= 
	(
	SELECT count(*)
	FROM RESULTAT R
	WHERE R.numEtud = E.numEtud
	AND note >= 10
	AND codMod = 
		(
		SELECT codMod 
		FROM MODULE 
		WHERE nomMod = 'Maths'
		)
	);

-- requête 5

SELECT nom, prenom 
FROM ETUDIANT E
WHERE 
	(
	SELECT count(*)
	FROM RESULTAT R
	WHERE R.numEtud = E.numEtud
	AND codMod = 
		(
		SELECT codMod 
		FROM MODULE 
		WHERE nomMod = 'Maths'
		)
	) = 0 ;

-- requête 6

CREATE VIEW NOTE_MATHS_PAR_ETU AS
SELECT numEtud, 
	(	
	SELECT MAX(NOTE)
	FROM RESULTAT R 
	WHERE R.numEtud = E.numEtud
	AND codMod = 
		(
		SELECT codMod 
		FROM MODULE 
		WHERE nomMod = 'Maths'
		)
	) AS NOTE_MATHS
FROM ETUDIANT E;

SELECT nom, prenom 
FROM ETUDIANT 
WHERE numEtud IN 
	(
	SELECT numEtud 
	FROM NOTE_MATHS_PAR_ETU
	WHERE NOTE_MATHS 
		= 
		(
		SELECT MAX(NOTE_MATHS)
		FROM NOTE_MATHS_PAR_ETU
		)
	);

-- requête 7

CREATE VIEW NOTE_MIN_MATHS_PAR_ETU AS
SELECT numEtud, 
	(	
	SELECT MIN(NOTE)
	FROM RESULTAT R 
	WHERE R.numEtud = E.numEtud
	AND codMod = 
		(
		SELECT codMod 
		FROM MODULE 
		WHERE nomMod = 'Maths'
		)
	) AS NOTE_MATHS
FROM ETUDIANT E;

SELECT nom, prenom 
FROM ETUDIANT 
WHERE numEtud IN 
	(
	SELECT numEtud 
	FROM NOTE_MATHS_PAR_ETU
	WHERE NOTE_MATHS 
		= 
		(
		SELECT MAX(NOTE_MATHS)
		FROM NOTE_MIN_MATHS_PAR_ETU
		)
	);

-- requête 8

CREATE VIEW NOTE_PAR_ETU_MOD AS
SELECT numEtud, codMod,
	(
	SELECT MAX(note)
	FROM RESULTAT R
	WHERE R.numEtud = I.numEtud
	AND R.codMod = I.codMod
	) AS NOTE_DEF
FROM INSCRIPTION I;

SELECT nomMod 
FROM MODULE M
WHERE 
	(
	SELECT COUNT(*)
	FROM PREREQUIS P 
	WHERE M.codMod = P.codMod
	AND noteMin > 
		(
		SELECT NOTE_DEF 
		FROM NOTE_PAR_ETU_MOD N
		WHERE N.codMod = P.codModPrereq
		AND N.numEtud = 
			(
			SELECT numEtud
			FROM ETUDIANT
			WHERE nom = 'Fourier'
			)
		)
	) = 0
AND M.codMod NOT IN
	(
	SELECT codMod
	FROM INSCRIPTION
	WHERE numEtud IN
		(
		SELECT numEtud
		FROM ETUDIANT
		WHERE nom = 'Fourier'
		)
	);
