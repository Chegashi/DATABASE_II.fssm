drop table if exists contact;

CREATE TABLE contact(
id int primary key auto_increment, 
nom varchar(32), 
numero varchar(10));

insert into contact (nom, numero) 
       values ('Maurice', '0612546578'), ('Ginette', '0697831267');
