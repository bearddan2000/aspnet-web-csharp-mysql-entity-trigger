TRUNCATE `odbc-trigger`.person;
TRUNCATE `odbc-trigger`.age;
TRUNCATE `odbc-trigger`.person_audit;

INSERT INTO `odbc-trigger`.person (id, name, ageId)
VALUES(default, 'Adam', 1), (default, 'Bob', 2),
(default, 'Cal', 1), (default, 'Dale', 1);

INSERT INTO `odbc-trigger`.age (id, edad)
VALUES(default, 21), (default, 26), (default, 31),
(default, 36), (default, 41), (default, 46),
(default, 51), (default, 56), (default, 61),
(default, 66);

DROP TRIGGER IF EXISTS `odbc-trigger`.tr_person_audit_ins;

DELIMITER $$

CREATE TRIGGER `odbc-trigger`.tr_person_audit_ins AFTER INSERT ON `odbc-trigger`.person
FOR EACH ROW BEGIN
	INSERT INTO `odbc-trigger`.person_audit (
		id,	personId, operationId, columnName,
		oldValue,	newValue, dateModified)
	VALUES( default, NEW.id, 0, 'name', NULL,
		NEW.name, CURRENT_TIMESTAMP);
	INSERT INTO `odbc-trigger`.person_audit (
		id, personId, operationId, columnName,
		oldValue,	newValue, dateModified)
	VALUES( default, NEW.id, 0, 'age', NULL,
		( SELECT edad FROM `odbc-trigger`.age WHERE id = NEW.ageId), CURRENT_TIMESTAMP);
END$$

DELIMITER ;

DROP TRIGGER IF EXISTS `odbc-trigger`.tr_person_audit_upd;

DELIMITER $$

CREATE TRIGGER `odbc-trigger`.tr_person_audit_upd AFTER UPDATE ON `odbc-trigger`.person
FOR EACH ROW BEGIN
	IF OLD.name <> NEW.name THEN
		INSERT INTO `odbc-trigger`.person_audit (id, personId, operationId, columnName,
		oldValue,	newValue, dateModified)
		VALUES( default, NEW.id, 1, 'name'
			, OLD.name
			, NEW.name
			, CURRENT_TIMESTAMP);
	END IF;
	IF OLD.ageId != NEW.ageId THEN
		INSERT INTO `odbc-trigger`.person_audit (id, personId, operationId, columnName,
		oldValue,	newValue, dateModified)
		VALUES( default, NEW.id, 1, 'age'
			, ( SELECT edad FROM `odbc-trigger`.age WHERE id = OLD.ageId)
			, ( SELECT edad FROM `odbc-trigger`.age WHERE id = NEW.ageId)
			, CURRENT_TIMESTAMP);
	END IF;
END$$

DELIMITER ;

DROP TRIGGER IF EXISTS `odbc-trigger`.tr_person_audit_del;

DELIMITER $$

CREATE TRIGGER `odbc-trigger`.tr_person_audit_del AFTER DELETE ON `odbc-trigger`.person
FOR EACH ROW BEGIN
	INSERT INTO `odbc-trigger`.person_audit (id, personId, operationId, columnName,
	oldValue,	newValue, dateModified)
	VALUES( default, OLD.id, 2, 'name'
		, OLD.name
		, NULL
		, CURRENT_TIMESTAMP);

	INSERT INTO `odbc-trigger`.person_audit (id, personId, operationId, columnName,
	oldValue,	newValue, dateModified)
	VALUES( default, OLD.id, 2, 'age'
		, ( SELECT edad FROM `odbc-trigger`.age WHERE id = OLD.ageId)
		, NULL
		, CURRENT_TIMESTAMP);
END$$

DELIMITER ;

GRANT ALL PRIVILEGES ON `odbc-trigger`.* TO 'maria'@'%';
FLUSH PRIVILEGES;
