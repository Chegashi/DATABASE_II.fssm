DROP TABLE IF EXISTS RESULTAT;
DROP TABLE IF EXISTS EXAMEN;
DROP TABLE IF EXISTS PREREQUIS;
DROP TABLE IF EXISTS INSCRIPTION;
DROP TABLE IF EXISTS MODULE;
DROP TABLE IF EXISTS ETUDIANT;

CREATE TABLE ETUDIANT
	(numEtud int PRIMARY KEY, 
	nom varchar(40), 
	prenom varchar(40), 
	datenaiss date, 
	civilite varchar(4), 
	patronyme varchar(40), 
	numsecu varchar(15) NOT NULL
	);

CREATE TABLE MODULE
	(numMod int PRIMARY KEY, 
	nomMod varchar(15), 
	effecMax int DEFAULT 30
	);

CREATE TABLE EXAMEN
	(numMod int REFERENCES MODULE(numMod), 
	numExam int, 
	dateExam date,
	PRIMARY KEY(numMod, numExam)
	);

CREATE TABLE INSCRIPTION
	(numEtud int REFERENCES ETUDIANT(numEtud), 
	numMod int REFERENCES MODULE(numMod), 
	dateInsc date, 
	PRIMARY KEY(numEtud, numMod)
	);

CREATE TABLE PREREQUIS
	(numMod int REFERENCES MODULE(numMod), 
	numModPrereq int REFERENCES MODULE(numMod), 
	noteMin int NOT NULL DEFAULT 10,
	PRIMARY KEY(numMod, numModPrereq)
	);

CREATE TABLE RESULTAT
	(numMod int,
	numExam int, 
	numEtud int,
	note int,
	PRIMARY KEY(numMod, numExam, numEtud),
	FOREIGN KEY (numMod, numExam) REFERENCES EXAMEN(numMod, numExam),
	FOREIGN KEY (numEtud, numMod) REFERENCES INSCRIPTION(numEtud, numMod)
	);

INSERT INTO MODULE (numMod, nomMod) VALUES 
(1, 'Oracle'), 
(2, 'C++'),
(3, 'C'),
(4, 'Algo'),
(5, 'Merise'),
(6, 'PL/SQL Oracle'),
(7, 'mySQL'),
(8, 'Algo avancee');

INSERT INTO PREREQUIS (numMod, numModPrereq) VALUES 
(1, 5),
(2, 3),
(6, 5),
(8, 5),
(7, 5);
INSERT INTO PREREQUIS VALUES (6, 1, 12);
