DROP DATABASE IF EXISTS `odbc-trigger`;

CREATE DATABASE `odbc-trigger`;

DROP TABLE IF EXISTS `odbc-trigger`.person;

CREATE TABLE `odbc-trigger`.person (
	id INT PRIMARY KEY auto_increment,
	name varchar(10) NOT NULL,
	ageId INT NOT NULL
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `odbc-trigger`.age;

CREATE TABLE `odbc-trigger`.age (
	id INT PRIMARY KEY auto_increment,
	edad INT NOT NULL
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `odbc-trigger`.person_audit;

CREATE TABLE `odbc-trigger`.person_audit (
	id INT PRIMARY KEY auto_increment,
	personId INT NOT NULL,
	operationId INT NOT NULL,
	columnName TEXT NOT NULL,
	oldValue TEXT,
	newValue TEXT,
	dateModified TIMESTAMP NOT NULL
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_general_ci;

CREATE INDEX idx_operations ON `odbc-trigger`.person_audit(operationId);
