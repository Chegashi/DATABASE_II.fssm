drop table emprunter;
drop table exemplaire;
drop table ouvrage;
drop table adherent;
drop table personne;

create table personne
(
numpers int primary key auto_increment,
nompers varchar(64),
prenompers varchar(64)
);

create table adherent
(
numadherent int primary key,
mailadherent varchar(64),
daterenouvellement date,
-- colonne ajoutée pour contrôler le nombre d'ouvrages
nbouvrages integer default 0,
foreign key (numadherent) references personne(numpers)
);

create table ouvrage
(
numouvrage int primary key auto_increment,
numauteur int,
titreouvrage varchar(64),
foreign key (numauteur) references personne(numpers)
);

create table exemplaire
(
numouvrage int,
numexemplaire int, 
empruntable boolean default true,
-- colonne ajoutée pour contrôler les emprunts simultanés
numemprunteur integer default null,
primary key (numouvrage, numexemplaire),
foreign key (numouvrage) references ouvrage(numouvrage),
foreign key (numemprunteur) references adherent(numadherent)
);

create table emprunter
(
numadherent int,
numouvrage int,
numexemplaire int,
dateemprunt date,
dateretour date default null,
primary key (numadherent, numouvrage, numexemplaire, dateemprunt),
foreign key (numadherent) references adherent(numadherent),
foreign key (numouvrage, numexemplaire) references exemplaire(numouvrage, numexemplaire),
check (dateemprunt < dateretour)
);

drop view adherents;
create view adherents as
       select numadherent, nompers, prenompers, mailadherent
       from adherent, personne
       where numpers = numpers;

drop view auteurs;
create view auteurs as
       select * 
       from personne
       where numpers not in
       	     (select numpers
	     from adherent
	     );

drop view exemplaires;
create view exemplaires as
       select o.numouvrage, numexemplaire, titreouvrage, concat(nompers, ", ", prenompers) as auteur
       from personne p, ouvrage o, exemplaire e
       where p.numpers = o.numauteur
       and o.numouvrage = e.numouvrage;

delimiter $$

/* Insertion des adhérents */

drop procedure insertAdherent;
create procedure insertAdherent (nom varchar(64), prenom varchar(64), mail varchar(64))
begin
	insert into personne (nompers, prenompers) values (nom, prenom);
	insert into adherent (numadherent, mailadherent) values (last_insert_id(), mail); 
end;

/* Insertion d'un ouvrage avec ses exemplaires */

drop procedure insertOuvrage;
create procedure insertOuvrage (titre varchar(64), num_auteur integer, nombre_exemplaires integer)
begin
	declare ouvrage_inserted_id integer;
	declare i integer;
	insert into ouvrage(numauteur, titreouvrage) values (num_auteur, titre);
	set ouvrage_inserted_id = last_insert_id();
	set i = 1;
	while i <= nombre_exemplaires do
	      insert into exemplaire (numouvrage, numexemplaire) values (ouvrage_inserted_id, i);
	      set i = i + 1;
	end while;
end;

/* Trigger avant l'insertion d'un adhérent */


drop trigger if exists adherentBeforeInsert;
create trigger adherentBeforeInsert before insert on adherent for each row
begin
	declare nb_aut integer;
	declare error_msg varchar(128);
	/* Met la date système par défaut  */
	if new.daterenouvellement is null then
	   set new.daterenouvellement = now();
	end if;
	/* Vérifie que l'adhérent n'est pas déjà un auteur */
	select count(*) into nb_aut
	       from ouvrage
	       where new.numadherent = numauteur;
	if nb_aut > 0 then
	   set error_msg = concat('L adhérent ', new.numadherent, 'est déjà un auteur.');
	   signal sqlstate '45000' set message_text = error_msg;
	end if;
end;

/* Trigger avant d'inserer un ouvrage */

drop trigger if exists ouvrageBeforeInsert;
create trigger ouvrageBeforeInsert before insert on ouvrage for each row
begin
	declare error_msg varchar(128);
	declare nb_adherents integer;
	/* Vérifie que l auteur n'est pas déjà adhérent */
	select count(*) into nb_adherents
	       from adherent
	       where new.numauteur = numadherent;
	if nb_adherents > 0 then
	   set error_msg = concat('L auteur ', new.numauteur, 'est déjà un adhérent.');
	   signal sqlstate '45000' set message_text = error_msg;
	end if;
end;

/* Trigger avant d'insérer un emprunt */

drop trigger if exists empruntBeforeInsert;
create trigger empruntBeforeInsert before insert on emprunter for each row
begin
	declare error_msg varchar(128);
	declare nb_exemplaires integer;
	declare date_expiration date;
	declare est_empruntable boolean;
	declare num_emprunteur integer;
	declare nb_ouvrages integer;
	/* Vérifie que l'abonnement est à jour */
	select ADDDATE(daterenouvellement, 365) into date_expiration
	       from adherent
	       where numadherent = new.numadherent;
	if now() > date_expiration then
	   set error_msg = concat('Abonnement expiré.');
	   signal sqlstate '45000' set message_text = error_msg;
	end if;	 
	/* Vérifie que le livre est empruntable */
	select empruntable, numemprunteur into est_empruntable, num_emprunteur
	       from exemplaire
	       where new.numouvrage = numouvrage
	       and new.numexemplaire = numexemplaire;
	if not(est_empruntable) then
	   set error_msg = concat('L exemplaire ', new.numouvrage, '-', new.numexemplaire, ' n est pas empruntable.');
	   signal sqlstate '45000' set message_text = error_msg;
	end if;
	/* Vérifie que le livre n'est pas déjà en possession de quelqu'un d'autre */
	if num_emprunteur is not null then
	   set error_msg = concat('L exemplaire ', new.numouvrage, '-', new.numexemplaire, ' est déjà en circulation.');
	   signal sqlstate '45000' set message_text = error_msg;
	end if;
	/* Vérifie que le nombre d'emprunts n'est pas dépassé */
	select nbouvrages into nb_ouvrages
	       from adherent
	       where numadherent = new.numadherent;
	if nb_ouvrages = 5 then
	   set error_msg = concat('Impossible d emprunter plus de 5 livres.');
	   signal sqlstate '45000' set message_text = error_msg;
	end if;
	/* Vérifie que qu'un autre exemplaire n'est pas déjà en possession du même adhérent */
	select count(*)  into nb_exemplaires
	       from exemplaire
	       where new.numouvrage = numouvrage
	       and new.numexemplaire <> numexemplaire
	       and new.numadherent = numemprunteur;
	if nb_exemplaires <> 0 then
	   set error_msg = concat('Vous ne pouvez pas emprunter deux exemplaires du même ouvrage.');
	   signal sqlstate '45000' set message_text = error_msg;
	end if;
end;

/* Trigger après l'insertion d'un emprunt */

drop trigger if exists empruntAfterInsert;
create trigger empruntAfterInsert after insert on emprunter for each row
begin
	/* Met à jour le nombre d'emprunts */
	update adherent 
		set nbouvrages = nbouvrages + 1
		where numadherent = new.numadherent;
	/* Indique l'emprunteur du livre */
	update exemplaire 
	       set numemprunteur = new.numadherent
	       where numouvrage = new.numouvrage
	       and numexemplaire = new.numexemplaire;
end;

/* Trigger avant la modification d un emprunt */

drop trigger if exists empruntBeforeUpdate;
create trigger empruntBeforeUpdate before update on emprunter for each row
begin
	/* Bloque toutes les modifications sauf celle de la date retour */	
	if (old.numadherent <> new.numadherent
	   OR old.numouvrage <> new.numouvrage
	   OR old.numexemplaire <> new.numexemplaire
	   OR old.dateemprunt <> new.dateemprunt
	   OR new.dateretour is null) then
	   signal sqlstate '45000' set message_text = 'Vous ne pouvez modifier un emprune que en déterminant une date retour.';
	end if;
end;

/* Trigger après la modification d un emprunt */

drop trigger if exists empruntAfterUpdate;
create trigger empruntAfterUpdate after update on emprunter for each row
begin
	/* Met à jour le nombre d'emprunts */
	update adherent
	       set nbouvrages = nbouvrages - 1
	       where numadherent = new.numadherent;
	/* Enlève l emprunteur du livre */
	update exemplaire 
	       set numemprunteur = null
	       where numouvrage = new.numouvrage
	       and numexemplaire = new.numexemplaire;
end;

/* Trigger avant la suppression d un emprunt */

drop trigger if exists empruntBeforeDelete;
create trigger empruntBeforeDelete before delete on emprunter for each row
begin
	/* bloque la suppression, le seul moyen de finir un 
	emprunt est de retourner le livre */
	signal sqlstate '45000' set message_text = 'Impossible de supprimer l emprunt, vous devez retourner le livre.';
end;

/* Procédure d'insertion d'un emprunt */

drop procedure if exists insertEmprunt;
create procedure insertEmprunt (num_adherent integer, num_ouvrage integer, num_exemplaire integer)
begin
	insert into emprunter values (num_adherent, num_ouvrage, num_exemplaire, now(), NULL);
end;

/* Procédure de retour d'un emprunt */

drop procedure if exists termineEmprunt;
create procedure termineEmprunt (num_adherent integer, num_ouvrage integer, num_exemplaire integer, date_emprunt date)
begin
	update emprunter set dateretour = now() 
	       where numadherent = num_adherent
	       and numouvrage = num_ouvrage
	       and dateemprunt = date_emprunt;
end;

/* Procédure de renouvellement d'un emprunt */

drop procedure if exists renouvelleEmprunt;
create procedure renouvelleEmprunt (num_adherent integer, num_auteur integer, num_exemplaire integer, date_emprunt date)
begin
	call termineEmprunt(num_adherent, num_auteur, num_exemplaire, date_emprunt);
	call insertEmprunt(num_adherent, num_auteur, num_exemplaire);
end;
$$

delimiter ;

call insertAdherent('Morflegroin', 'Marcel', 'marcel@morflegroin.com');
call insertAdherent('Le Ballon', 'Gégé', 'gege.m@grosbuveur.com');
call insertAdherent('Couledru', 'Gertrude', 'g.proflechettes@ligue-flechettes.fr');

insert into personne (nompers, prenompers) values ('Rowlings', 'J. K.');
insert into personne (nompers, prenompers) values ('Tolstoï', 'Léon');

call insertOuvrage('Harry Potter and the Deathly Hallows', 4, 10);
call insertOuvrage('Guère épais', 5, 7);

select 'un adherent ne peut pas être un auteur :';
insert into adherent values (4, 'test', now(), 0);

select 'un auteur ne peut pas être un adhérent :';
call insertOuvrage('erreur', 1, 2);

select 'emprunt réussi';
call insertEmprunt (1, 1, 1);

select 'deux exemplaires :';
call insertEmprunt (1, 1, 2);

select 'exemplaire en circulation :';
call insertEmprunt (2, 1, 1);

select 'retour réussi :';
call termineEmprunt (1, 1, 1, now());

select 'impossible de modifier emprunt :';
update emprunter set numadherent = numadherent + 1; 
