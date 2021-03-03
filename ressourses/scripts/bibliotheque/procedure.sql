delimiter $$

drop procedure insertAdherent;
create procedure insertAdherent (nom varchar(64), prenom varchar(64), mail varchar(64))
begin
	insert into personne (nompers, prenompers) values (nom, prenom);
	insert into adherent (numpers, mailadherent) values (last_insert_id(), mail); 
end
$$

call insertAdherent('Morflegroin', 'Marcel', 'marcel@morflegroin.com');
call insertAdherent('Le Ballon', 'Gégé', 'gege.m@grosbuveur.com');
call insertAdherent('Couledru', 'Gertrude', 'g.proflechettes@ligue-flechettes.fr');
$$

delimiter ;

insert into personne (nompers, prenompers) values ('Rowlings', 'J. K.');

delimiter $$

drop procedure insertOuvrage;
create procedure insertOuvrage (titre varchar(64), numAuteur integer, nombreExemplaires integer)
begin
	declare ouvrage_inserted_id integer;
	declare i integer;
	insert into ouvrage(numauteur, titreouvrage) values (numAuteur, titre);
	set ouvrage_inserted_id = last_insert_id();
	set i = 1;
	while i <= nombreExemplaires do
	      insert into exemplaire (numOuvrage, numExemplaire) values (ouvrage_inserted_id, i);
	      set i = i + 1;
	end while;
end
$$

delimiter ;

call insertOuvrage('Harry Potter and the Deathly Hallows', 4, 10);
