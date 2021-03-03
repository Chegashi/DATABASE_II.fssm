DROP TABLE IF EXISTS personne;

CREATE TABLE personne
(numpers int PRIMARY KEY,
 nom varchar(30), 
 prenom varchar(30),
 pere int, 
 mere int,
 FOREIGN KEY (pere) REFERENCES personne(numpers),
 FOREIGN KEY (mere) REFERENCES personne(numpers)
);

insert into personne values (1, 'Estermont', 'Cassana', NULL, NULL);
insert into personne values (2, 'Baratheon', 'Steffon', NULL, NULL);
insert into personne values (3, 'Baratheon', 'Renly', 2, 1);
insert into personne values (4, 'Baratheon', 'Stannis', 2, 1);
insert into personne values (5, 'Baratheon', 'Robert',2, 1);
insert into personne values (12, 'Lannister', 'Joanna', NULL, NULL);
insert into personne values (13, 'Lannister', 'Tywin', NULL, NULL);
insert into personne values (9, 'Lannister', 'Cersei', 13, 12);
insert into personne values (6, NULL, 'Gendry', 5, NULL);
insert into personne values (8, 'Baratheon', 'Tommen', 5, 9);
insert into personne values (7, 'Baratheon', 'Joffrey', 5, 9);
insert into personne values (10, 'Baratheon', 'Myrcella', 5, 9);
insert into personne values (11, 'Lannister', 'Jaime', 13, 12);
insert into personne values (14, 'Lannister', 'Tyrion', 13, 12);
insert into personne values (15, 'Florent', 'Selyse', NULL, NULL);
insert into personne values (16, 'Baratheon', 'Shireen', 4, 15);
