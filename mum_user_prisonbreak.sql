DELIMITER $$

DROP PROCEDURE IF EXISTS mum_user_prisonbreak $$
CREATE DEFINER=`DBO`@`localhost`
PROCEDURE mum_user_prisonbreak(IN mum_username CHAR(16))

LANGUAGE SQL
NOT DETERMINISTIC
MODIFIES SQL DATA
SQL SECURITY DEFINER
COMMENT 'Unlock a user on all known hosts'

mum_prisonbreak_sp:BEGIN

DECLARE hostname VARCHAR(64);
DECLARE done INT DEFAULT FALSE;
DECLARE hosts CURSOR for SELECT login_hostname FROM login_hosts;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
SET @mysql_user = mum_username;

OPEN hosts;

hosts_loop: LOOP
	FETCH hosts INTO hostname;
	IF done THEN
		LEAVE hosts_loop;
	END IF;
	SET @mysql_host = hostname;
	CALL mum_user_unlock(@mysql_user, @mysql_host);
END LOOP;

CLOSE hosts;

END $$

DELIMITER ;
