delimiter $$

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
	       where new.numpers = numauteur;
	if nb_aut > 0 then
	   set error_msg = concat('L\'adhérent ', new.numpers, 'est déjà un auteur.');
	   signal sqlstate '45000' set message_text = error_msg;
	end if;
end;
$$

delimiter ;
