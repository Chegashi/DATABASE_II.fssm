CREATE TABLE PERSONNE
(numpers number PRIMARY KEY,
 nom varchar(30) NOT NULL, 
 prenom varchar(30),
 pere REFERENCES PERSONNE(numpers),
 mere REFERENCES PERSONNE(numpers)
);

CREATE TABLE MARIAGE
(
nummari NUMBER REFERENCES PERSONNE(numpers),
numfemme NUMBER REFERENCES PERSONNE(numpers),
datemariage DATE DEFAULT SYSDATE,
datedivorce DATE DEFAULT NULL,
PRIMARY KEY(nummari, numfemme, dateMariage)
);

