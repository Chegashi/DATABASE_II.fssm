delimiter $$

drop procedure compteARebours;

create  procedure compteARebours(i integer)
begin
	declare j integer;
	if i >= 0 then 
	   set j = i;
	   while j >= 0 do
	   	 select j;
		 set j = j - 1;
	   end while;
	end if;
end;

call compteARebours(3);
$$

delimiter ;
