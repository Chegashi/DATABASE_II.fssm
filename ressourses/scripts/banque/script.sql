DROP TABLE IF EXISTS OPERATION;
DROP TABLE IF EXISTS TYPEOPERATION;
DROP TABLE IF EXISTS COMPTECLIENT;
DROP TABLE IF EXISTS TYPECCL;
DROP TABLE IF EXISTS PERSONNEL;
DROP TABLE IF EXISTS CLIENT;

CREATE TABLE CLIENT
(numcli int primary key auto_increment,
 nomcli varchar(30),
 prenomcli varchar(30),
 adresse varchar(60),
 tel varchar(10),
 CONSTRAINT ck_telephone CHECK(LENGTH(tel)=10)
);

CREATE TABLE PERSONNEL
(numpers int primary key auto_increment,
 nompers varchar(30),
 prenompers varchar(30),
 manager int,
 salaire int,
 CONSTRAINT ck_salaire CHECK(SALAIRE >= 1254.28)
);

CREATE TABLE TYPECCL
(numtypeccl int primary key auto_increment,
 nomtypeccl varchar(30)
);

CREATE TABLE COMPTECLIENT
(numcli int,
 numccl int,
 numtypeccl int,
 dateccl date not null,
 numpers int,
 CONSTRAINT pk_compteclient
                PRIMARY KEY (numcli, numccl),
 CONSTRAINT fk_ccl_typeccl
                FOREIGN KEY (numtypeccl)
                REFERENCES TYPECCL (numtypeccl),
 CONSTRAINT fk_ccl_client
                FOREIGN KEY (numcli)
                REFERENCES CLIENT (numcli),
 CONSTRAINT fk_ccl_personnel
                FOREIGN KEY (numpers)
                REFERENCES PERSONNEL (numpers)
);

CREATE TABLE TYPEOPERATION
(numtypeoper int primary key auto_increment,
 nomtypeoper varchar(30)
);

CREATE TABLE OPERATION
(numcli int,
 numccl int,
 numoper int,
 numtypeoper int,
 dateoper date not null,
 montantoper int not null,
 libeloper varchar(30),
 CONSTRAINT pk_operation
                PRIMARY KEY (numcli, numccl, numoper),
 CONSTRAINT fk_oper_ccl
		FOREIGN KEY (numcli, numoper)
		REFERENCES COMPTECLIENT (numcli, numccl),
 CONSTRAINT fk_oper_codeoper
                FOREIGN KEY (numtypeoper)
                REFERENCES TYPEOPERATION (numtypeoper),
 CONSTRAINT montant_operation 
		CHECK(montantoper <> 0)
);

INSERT INTO TYPECCL VALUES (1 , 'Compte courant'),
	(2, 'livret'),
	(3, 'PEL');

INSERT INTO TYPEOPERATION VALUES (1, 'dépôt espèces'),
	(2, 'prélèvement'),
	(3, 'virement'),
	(4, 'retrait');
