drop table if exists PREREQUIS;
drop table if exists MODULE;

CREATE TABLE MODULE
(numMod int primary key, 
nomMod varchar(30)
);

CREATE TABLE PREREQUIS
(
numMod int,
numModPrereq int,
noteMin int DEFAULT 10 NOT NULL ,
PRIMARY KEY(numMod, numModPrereq),
FOREIGN KEY (numMod) references MODULE(numMod),
FOREIGN KEY (numModPrereq) references MODULE(numMod)
);

INSERT INTO MODULE VALUES (1, 'Oracle');
INSERT INTO MODULE VALUES (2, 'C++');
INSERT INTO MODULE VALUES (3, 'C');
INSERT INTO MODULE VALUES (4, 'Algo');
INSERT INTO MODULE VALUES (5, 'Merise');
INSERT INTO MODULE VALUES (6, 'PL/SQL Oracle');
INSERT INTO MODULE VALUES (7, 'mySQL');
INSERT INTO MODULE VALUES (8, 'Algo avancée');


INSERT INTO PREREQUIS (numMod, numModPrereq) VALUES (1, 5);
INSERT INTO PREREQUIS (numMod, numModPrereq) VALUES (2, 3);
INSERT INTO PREREQUIS VALUES (6, 1, 12);
INSERT INTO PREREQUIS (numMod, numModPrereq) VALUES (6, 5);
INSERT INTO PREREQUIS (numMod, numModPrereq) VALUES (8, 5);
INSERT INTO PREREQUIS (numMod, numModPrereq) VALUES (7, 5);
