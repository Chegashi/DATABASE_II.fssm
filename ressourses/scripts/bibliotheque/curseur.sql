delimiter $$

DROP PROCEDURE IF EXISTS AfficheUtilisateurs;
CREATE PROCEDURE AfficheUtilisateurs()
BEGIN
	DECLARE num_pers integer;
	DECLARE nom_pers varchar(64);
	DECLARE prenom_pers varchar(64);
	DECLARE nb_a integer;
	DECLARE finished boolean DEFAULT FALSE;
	DECLARE personnes CURSOR FOR SELECT numpers, nompers, prenompers FROM personne;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = TRUE;

	OPEN personnes;
	personnesloop: LOOP
	       FETCH personnes INTO num_pers, nom_pers, prenom_pers;
	       IF finished THEN
	       	  LEAVE personnesloop;
	       END IF;
	       SELECT COUNT(*) INTO nb_a FROM adherent WHERE numpers = num_pers;
	       IF nb_a > 0 THEN
	       	  select concat(prenom_pers, ' ', nom_pers, ' est un adherent');
	       ELSE
	       	  select concat(prenom_pers, ' ', nom_pers, ' est un auteur');
	       END IF;
	END LOOP;
	CLOSE personnes;
END;
$$

CALL AfficheUtilisateurs();
$$

delimiter ;
