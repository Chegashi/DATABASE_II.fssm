USE vm_revue;
SET NAMES UTF8;
SET autocommit=0;
DELIMITER $$
DROP PROCEDURE IF EXISTS `migration`$$
DROP PROCEDURE IF EXISTS `migrationNumeros`$$
DROP PROCEDURE IF EXISTS `migrationArticles`$$
DROP PROCEDURE IF EXISTS `migrationUtilisateurs`$$
DROP PROCEDURE IF EXISTS `migrationAdresses`$$

CREATE PROCEDURE migrationUtilisateurs()
BEGIN
	DECLARE id int(11);
       DECLARE u_name varchar(255);
       DECLARE username varchar(150);
       DECLARE email varchar(100);
       DECLARE password varchar(100);
       DECLARE usertype varchar(25);
       DECLARE block tinyint(4);
       DECLARE sendEmail tinyint(4);
       DECLARE gid tinyint(3);
       DECLARE registerDate datetime;
       DECLARE lastvisitDate datetime;
       DECLARE activation varchar(100);
       DECLARE params text;
       DECLARE finished INTEGER DEFAULT 0;

       DECLARE utilisateurs CURSOR FOR
       	       SELECT * FROM jos_users;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

	select 'Importation utilisateurs !';
	START TRANSACTION;
	OPEN utilisateurs;
	userloop: LOOP		  
		select 'Importation de ', username;
	       	FETCH utilisateurs INTO id, u_name, username, email, password, usertype, block, sendEmail, gid, registerDate, lastvisitDate, activation, params;
		IF finished = 1 THEN
		   LEAVE userloop;
		END IF;
		insert into vm3_users (id, name, username, email, password, usertype, block, sendEmail, registerDate, lastvisitDate, activation, params)
		   	values (id, u_name, username, email, password, usertype, block, sendEmail, registerDate, lastvisitDate, activation, params);
	END LOOP;
	CLOSE utilisateurs;
	select 'Terminé !';
	COMMIT;
END$$

CREATE PROCEDURE migrationAdresses()
BEGIN
       DECLARE p_user_id int(11);
       DECLARE p_address_type char(2);
       DECLARE p_address_type_name varchar(32);
       DECLARE p_company varchar(64);
       DECLARE p_title varchar(32);
       DECLARE p_last_name varchar(32);
       DECLARE p_first_name varchar(32);
       DECLARE p_middle_name varchar(32);
       DECLARE p_phone_1 varchar(32);
       DECLARE p_phone_2 varchar(32);
       DECLARE p_fax varchar(32);
       DECLARE p_address_1 varchar(64);
       DECLARE p_address_2 varchar(64);
       DECLARE p_city varchar(32);
       DECLARE p_country_id tinyint(1);
       DECLARE p_zip varchar(32);
       DECLARE p_country_code char(3);

       DECLARE NB int;

       DECLARE exitLoop BOOLEAN DEFAULT FALSE;

       DECLARE adresses CURSOR
       	       FOR SELECT user_id, address_type, address_type_name, company, title, last_name, first_name, middle_name, phone_1, phone_2, p_fax, address_1, address_2, city, country, zip
	       FROM jos_vm_user_info;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET exitLoop = TRUE;

	select count(*) into NB FROM jos_vm_user_info;
	select 'Importing ', NB, 'adresses :';

	select 'Importation adresses !';
	START TRANSACTION;
	OPEN adresses;
	cursorloop: LOOP
	       	FETCH adresses INTO p_user_id, p_address_type, p_address_type_name, p_company, p_title, p_last_name, p_first_name, p_middle_name, p_phone_1, p_phone_2,
		      p_fax, p_address_1, p_address_2, p_city, p_country_code, p_zip;
		select 'Adresse n°', p_address_1, ' ', p_country_code;
		IF exitLoop THEN
		   LEAVE cursorloop;
		END IF;
		IF p_country_code IS NULL OR p_country_code = '' THEN
		   SET p_country_code = 'FRA';
		END IF;
		insert into vm3_virtuemart_userinfos
		    (virtuemart_user_id, address_type, address_type_name, company, title, last_name, first_name, middle_name, phone_1, phone_2, fax, address_1, address_2, city, virtuemart_country_id, zip)
		    values (p_user_id, p_address_type, p_address_type_name, p_company, p_title, p_last_name, p_first_name, p_middle_name, p_phone_1, p_phone_2, p_fax, p_address_1, p_address_2, p_city,
				       (SELECT virtuemart_country_id FROM vm3_virtuemart_countries WHERE country_3_code = p_country_code), p_zip);
	END LOOP;
	CLOSE adresses;
	select 'Terminé !';
	COMMIT;
END$$

CREATE PROCEDURE migrationNumeros()
BEGIN
	DECLARE p_id VARCHAR(2200);
	DECLARE son_id VARCHAR(2200);
	DECLARE p_sku VARCHAR(2200);
	DECLARE p_s_desc VARCHAR(2000);
	DECLARE p_desc VARCHAR(50000);
	DECLARE p_thumb_img VARCHAR(2000);
	DECLARE p_img VARCHAR(2000);
	DECLARE p_name VARCHAR(2000);
	DECLARE p_file_name VARCHAR(2000);
	DECLARE finished INTEGER DEFAULT 0;
	DECLARE numeros CURSOR FOR SELECT product_sku , product_s_desc, product_desc, product_thumb_Image, product_full_Image, product_name,
       (SELECT file_title
       FROM jos_vm_product_files J
       WHERE file_title LIKE '%pdf'
       AND J.file_product_id IN
       	     (SELECT product_id
	     FROM jos_vm_product D
	     WHERE substring(D.product_sku, 4, 4) = substring(P.product_sku, 4, 4)
	     AND substring(D.product_sku, 1, 3) = 'TEL'
	     AND D.product_id IN
	     	 (SELECT C.product_id
      	     	 FROM jos_vm_product_category_xref C
       		 WHERE category_id IN
      	    	       (SELECT category_id
      	    	       FROM jos_vm_category
	    	       WHERE category_name LIKE 'Num_ros t%'
       		       )
 		 )
	 )
       ) AS file_name
FROM jos_vm_product P
WHERE product_id IN
      (SELECT product_id
      FROM jos_vm_product_category_xref
      WHERE category_id IN
      	    (SELECT category_id
      	    FROM jos_vm_category
	    WHERE category_name LIKE 'Num_ros (France)')
);
		
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
	/*
	DECLARE EXIT handler for sqlexception
	  	BEGIN
		  select 'sqlexception';
	          GET DIAGNOSTICS CONDITION 1
		      @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
		  SELECT @p1, @p2;
		  ROLLBACK;
		END;

	DECLARE EXIT handler for sqlwarning
	  	BEGIN
		  select 'sqlwarning';
	          GET DIAGNOSTICS CONDITION 1
		      @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
		  SELECT @p1, @p2;
	          ROLLBACK;
		END;
	*/	
	START TRANSACTION;
	select 'go !';
	OPEN numeros;
	readloop: LOOP
		FETCH numeros INTO p_sku, p_s_desc, p_desc, p_thumb_img, p_img, p_name, p_file_name ;
		IF finished = 1 THEN
		   LEAVE readloop;
		END IF;
		-- insertion du produit
		select 'migrating product : ', p_name, substring(p_name, 1, locate('broch', p_name) - 1);
		insert into vm3_virtuemart_products (product_parent_id, product_sku, published)
	       	       values (7, substring(product_sku, 1, 7), 0);
		set p_id = LAST_INSERT_ID();
		select 'insert fr_fr : ';		
		insert into vm3_virtuemart_products_fr_fr (virtuemart_product_id, product_s_desc, product_desc, product_name, slug)
	       	       values (p_id, p_s_desc, p_desc, substring(p_name, 1, locate('broch', p_name) - 1), concat('numero-', p_id));
		select 'insert media : ';		
		insert into vm3_virtuemart_product_medias (virtuemart_product_id, virtuemart_media_id)
	       	       values (p_id, (select virtuemart_media_id from vm3_virtuemart_medias where file_title =  p_img));
		-- insertion de la version brochée 
		select 'insert broché : ';		
		insert into vm3_virtuemart_products (product_parent_id, product_sku, product_weight, product_weight_uom, published)
	       	       values (p_id, substring(product_sku, 1, 7), 1, 'KG', 1);
		select 'insert broché_fr_fr : ';		
		set son_id = LAST_INSERT_ID();
		insert into vm3_virtuemart_products_fr_fr (virtuemart_product_id, product_name, slug)
	       	       values (son_id, substring(p_name, 1, locate('(', p_name) - 1), concat('numero-', p_id, '-br'));
		select 'insert category : ';		
		insert into vm3_virtuemart_product_categories (virtuemart_product_id, virtuemart_category_id)
	       	       values (son_id, (select virtuemart_category_id from vm3_virtuemart_categories_fr_fr where category_name LIKE 'Num_ros broch_s'));
		-- insertion de la version téléchargeable
		select 'insert téléchargeable : ';		
		insert into vm3_virtuemart_products (product_parent_id, product_sku, product_weight, product_weight_uom, published)
	       	       values (p_id, substring(product_sku, 1, 7), 0.01, 'KG', 1);
		select 'insert téléchargeable_fr_fr : ';		
		set son_id = LAST_INSERT_ID();
		insert into vm3_virtuemart_products_fr_fr (virtuemart_product_id, product_name, slug)
	       	       values (son_id, concat(substring(p_name, 1, locate('broch', p_name) - 1), ' téléchargeable'), concat('numero-', p_id, '-tl'));
		select 'insert category : ';
		insert into vm3_virtuemart_product_categories (virtuemart_product_id, virtuemart_category_id)
	       	       values (son_id, (select virtuemart_category_id from vm3_virtuemart_categories_fr_fr where category_name LIKE 'Num_ros en t%'));
		-- mise en relation avec le media téléchargeable
		select 'insert downloadable media : ', p_name, substring(p_name, 1, 11), p_file_name, (select virtuemart_media_id from vm3_virtuemart_medias where file_title = p_file_name);
		insert into vm3_virtuemart_product_customfields (virtuemart_product_id, virtuemart_custom_id, customfield_value, customfield_params)
		       values (son_id, 3, 'istraxx_download',
		       	      concat('media_id="', (select virtuemart_media_id from vm3_virtuemart_medias where file_title = p_file_name),
			      	'"|free_download="0"|name=0|maxspeed="1000"|stream="0"|maxloads="0"|mloadperInterval="0"|mloadInterval="0"|maxtime="0"|publish_up="0"|publish_down="0"|show_dlicon="0"|show_subscHints="0"|show_subscAmount="0"|NotShow_filename="0"|show_subscTimeleft="0"|'));
	END LOOP;
	select 'done !';
	CLOSE numeros;
	COMMIT;
END$$

CREATE PROCEDURE migrationArticles()
BEGIN
	DECLARE p_id VARCHAR(2200);
	DECLARE son_id VARCHAR(2200);
	DECLARE p_sku VARCHAR(2200);
	DECLARE p_s_desc VARCHAR(2000);
	DECLARE p_desc VARCHAR(50000);
	DECLARE p_thumb_img VARCHAR(2000);
	DECLARE p_img VARCHAR(2000);
	DECLARE p_name VARCHAR(2000);
	DECLARE p_file_name VARCHAR(2000);
	DECLARE finished INTEGER DEFAULT 0;
	DECLARE articles CURSOR FOR SELECT product_sku , product_s_desc, product_desc, product_thumb_Image, product_full_Image, product_name,
(SELECT file_title
       FROM jos_vm_product_files J
       WHERE file_title LIKE '%pdf'
       AND J.file_product_id = P.product_id
       ) AS file_name
FROM jos_vm_product P
WHERE product_id IN
      (SELECT product_id
      FROM jos_vm_product_category_xref
      WHERE category_id IN
      	    (SELECT category_id
      	    FROM jos_vm_category
	    WHERE category_name LIKE 'Articles%')
);
		
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
	/*
	DECLARE EXIT handler for sqlexception
	  	BEGIN
		  select 'sqlexception';
	          GET DIAGNOSTICS CONDITION 1
		      @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
		  SELECT @p1, @p2;
		  ROLLBACK;
		END;

	DECLARE EXIT handler for sqlwarning
	  	BEGIN
		  select 'sqlwarning';
	          GET DIAGNOSTICS CONDITION 1
		      @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
		  SELECT @p1, @p2;
	          ROLLBACK;
		END;
	*/	
	START TRANSACTION;
	select 'go !';
	OPEN articles;
	readloop: LOOP
		FETCH articles INTO p_sku, p_s_desc, p_desc, p_thumb_img, p_img, p_name, p_file_name ;
		IF finished = 1 THEN
		   LEAVE readloop;
		END IF;
		-- insertion du produit
		select 'migrating article : ', p_name;
		IF p_file_name is not null THEN
				insert into vm3_virtuemart_products (product_parent_id, product_sku, published)
			       	       values (6, product_sku, 1);
				set p_id = LAST_INSERT_ID();
				select 'insert fr_fr : ';		
				insert into vm3_virtuemart_products_fr_fr (virtuemart_product_id, product_s_desc, product_desc, product_name, slug)
			       	       values (p_id, p_s_desc, p_desc, p_name, concat('article-', p_id));
				select 'insert media : ';		
				insert into vm3_virtuemart_product_medias (virtuemart_product_id, virtuemart_media_id)
			       	       values (p_id, (select virtuemart_media_id from vm3_virtuemart_medias where file_title =  p_img));
				-- insertion de la version brochée 
				/*select 'insert broché : ';		
				insert into vm3_virtuemart_products (product_parent_id, product_sku, product_weight, product_weight_uom, published)
	       	       values (p_id, substring(product_sku, 1, 7), 1, 'KG', 1);
				select 'insert broché_fr_fr : ';		
				set son_id = LAST_INSERT_ID();
				insert into vm3_virtuemart_products_fr_fr (virtuemart_product_id, product_name, slug)
			       	       values (son_id, substring(p_name, 1, locate('(', p_name) - 1), concat('numero-', p_id, '-br'));*/
				select 'insert category : ';		
				insert into vm3_virtuemart_product_categories (virtuemart_product_id, virtuemart_category_id)
			       	       values (p_id, (select virtuemart_category_id from vm3_virtuemart_categories_fr_fr where category_name LIKE 'Articles%'));
				-- insertion de la version téléchargeable
				/*select 'insert téléchargeable : ';		
				insert into vm3_virtuemart_products (product_parent_id, product_sku, product_weight, product_weight_uom, published)
			       	       values (p_id, substring(product_sku, 1, 7), 0.01, 'KG', 1);
				select 'insert téléchargeable_fr_fr : ';		
				set son_id = LAST_INSERT_ID();
				insert into vm3_virtuemart_products_fr_fr (virtuemart_product_id, product_name, slug)
			       	       values (son_id, concat(substring(p_name, 1, locate('broch', p_name) - 1), ' téléchargeable'), concat('numero-', p_id, '-tl'));
				select 'insert category : ';
				insert into vm3_virtuemart_product_categories (virtuemart_product_id, virtuemart_category_id)
			       	       values (son_id, (select virtuemart_category_id from vm3_virtuemart_categories_fr_fr where category_name LIKE 'Num_ros en t%'));*/
				-- mise en relation avec le media téléchargeable
				select 'insert downloadable media : ', p_name, p_file_name, (select virtuemart_media_id from vm3_virtuemart_medias where file_title = p_file_name);
				insert into vm3_virtuemart_product_customfields (virtuemart_product_id, virtuemart_custom_id, customfield_value, customfield_params)
						       values (p_id, 3, 'istraxx_download',
						       concat('media_id="', (select virtuemart_media_id from vm3_virtuemart_medias where file_title = p_file_name),
			      			       '"|free_download="0"|name=0|maxspeed="1000"|stream="0"|maxloads="0"|mloadperInterval="0"|mloadInterval="0"|maxtime="0"|publish_up="0"|publish_down="0"|show_dlicon="0"|show_subscHints="0"|show_subscAmount="0"|NotShow_filename="0"|show_subscTimeleft="0"|'));
			ELSE
				select 'no media found !';
			END IF;
	END LOOP;
	select 'done !';
	CLOSE articles;
	COMMIT;

/*BEGIN
	DECLARE p_id VARCHAR(2200);
	DECLARE son_id VARCHAR(2200);
	DECLARE p_sku VARCHAR(2200);
	DECLARE p_s_desc VARCHAR(2000);
	DECLARE p_desc VARCHAR(50000);
	DECLARE p_thumb_img VARCHAR(2000);
	DECLARE p_img VARCHAR(2000);
	DECLARE p_name VARCHAR(2000);
	DECLARE p_file_name VARCHAR(2000);
	DECLARE finished INTEGER DEFAULT 0;
	DECLARE articles CURSOR FOR
		SELECT product_sku, product_s_desc, product_desc, product_thumb_Image, product_full_Image, product_name, 
		       (SELECT file_name
		       FROM jos_vm_product_download D
		       WHERE D.product_id = P.product_id
		       ) AS file_name
		FROM jos_vm_product P
		WHERE product_id IN
		      (SELECT product_id
		      FROM jos_vm_product_category_xref
		      WHERE category_id IN
		      	    (SELECT category_id
		      	    FROM jos_vm_category
			    WHERE category_name LIKE 'Articles%')
		);
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
	
	OPEN articles;
	readloop: LOOP
		FETCH articles INTO p_sku, p_s_desc, p_desc, p_thumb_img, p_img, p_name, p_file_name;
		IF finished = 1 THEN
		   LEAVE readloop;
		-- insertion du produit
		select 'migrating product : ', p_name, substring(p_name, 1, locate('téléchargeable', p_name) - 1);
		insert into vm3_virtuemart_products (product_parent_id, product_sku, published)
	       	       values (7, product_sku, 0);
		set p_id = LAST_INSERT_ID();
		select 'insert fr_fr : ';
		insert into vm3_virtuemart_products_fr_fr (virtuemart_product_id, product_s_desc, product_desc, product_name, slug)
	       	       values (p_id, p_s_desc, p_desc, substring(p_name, 1, locate('broché', p_name) - 1), concat('numero-', p_id, '-dl'));
		select 'insert media : ';
		insert into vm3_virtuemart_product_medias (virtuemart_product_id, virtuemart_media_id)
	       	       values (p_id, (select virtuemart_media_id from vm3_virtuemart_medias where file_title =  p_img));
		-- mise en relation avec le media téléchargeable 
		select 'insert downloadable media : ';
		insert into vm3_virtuemart_product_customfields, virtuemart_product_id, virtuemart_custom_id, customfield_value, customfield_params)
		       values (son_id, 3, 'istraxx_download',
		       	      concat('media_id="', (select virtuemart_media_id from vm3_virtuemart_medias where file_title = p_file_name),
			      	'"|free_download="0"|name=0|maxspeed="1000"|stream="0"|maxloads="0"|mloadperInterval="0"|mloadInterval="0"|maxtime="0"|publish_up="0"|publish_down="0"|show_dlicon="0"|show_subscHints="0"|show_subscAmount="0"|NotShow_filename="0"|show_subscTimeleft="0"|');
		END IF;
	select p_name;
	END LOOP;
	CLOSE articles;
*/

END $$

CREATE PROCEDURE migration()
BEGIN
	CALL migrationUtilisateurs();
	CALL migrationAdresses();
	CALL migrationArticles();
	CALL migrationNumeros();
END$$

DELIMITER ;

CALL migration();
