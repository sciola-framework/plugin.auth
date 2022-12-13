-- PHP-Auth (https://github.com/delight-im/PHP-Auth)
-- Copyright (c) delight.im (https://www.delight.im/)
-- Licensed under the MIT License (https://opensource.org/licenses/MIT)

BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS `users_throttling` (
	`bucket`	VARCHAR ( 44 ) NOT NULL,
	`tokens`	REAL NOT NULL CHECK("tokens" >= 0),
	`replenished_at`	INTEGER NOT NULL CHECK("replenished_at" >= 0),
	`expires_at`	INTEGER NOT NULL CHECK("expires_at" >= 0),
	PRIMARY KEY(`bucket`)
);
CREATE TABLE IF NOT EXISTS `users_resets` (
	`id`	INTEGER NOT NULL CHECK("id" >= 0) PRIMARY KEY AUTOINCREMENT,
	`user`	INTEGER NOT NULL CHECK("user" >= 0),
	`selector`	VARCHAR ( 20 ) NOT NULL,
	`token`	VARCHAR ( 255 ) NOT NULL,
	`expires`	INTEGER NOT NULL CHECK("expires" >= 0),
	CONSTRAINT `selector` UNIQUE(`selector`)
);
CREATE TABLE IF NOT EXISTS `users_remembered` (
	`id`	INTEGER NOT NULL CHECK("id" >= 0) PRIMARY KEY AUTOINCREMENT,
	`user`	INTEGER NOT NULL CHECK("user" >= 0),
	`selector`	VARCHAR ( 24 ) NOT NULL,
	`token`	VARCHAR ( 255 ) NOT NULL,
	`expires`	INTEGER NOT NULL CHECK("expires" >= 0),
	CONSTRAINT `selector` UNIQUE(`selector`)
);
CREATE TABLE IF NOT EXISTS `users_confirmations` (
	`id`	INTEGER NOT NULL CHECK("id" >= 0) PRIMARY KEY AUTOINCREMENT,
	`user_id`	INTEGER NOT NULL CHECK("user_id" >= 0),
	`email`	VARCHAR ( 249 ) NOT NULL,
	`selector`	VARCHAR ( 16 ) NOT NULL,
	`token`	VARCHAR ( 255 ) NOT NULL,
	`expires`	INTEGER NOT NULL CHECK("expires" >= 0),
	CONSTRAINT `selector` UNIQUE(`selector`)
);
INSERT INTO `users_confirmations` VALUES (1,1,'admin@email.local','c6RUUOFsSmmM5RVX','$2y$10$Q472uCk6Z6WnGsT9l/XRfelrQ9lMXKreR1f5lKRnuDgTHLbhb.ndq',1637867136);
CREATE TABLE IF NOT EXISTS `users` (
	`id`	INTEGER NOT NULL CHECK("id" >= 0) PRIMARY KEY AUTOINCREMENT,
	`email`	VARCHAR ( 249 ) NOT NULL,
	`password`	VARCHAR ( 255 ) NOT NULL,
	`username`	VARCHAR ( 100 ) DEFAULT NULL,
	`status`	INTEGER NOT NULL DEFAULT "0" CHECK("status" >= 0),
	`verified`	INTEGER NOT NULL DEFAULT "0" CHECK("verified" >= 0),
	`resettable`	INTEGER NOT NULL DEFAULT "1" CHECK("resettable" >= 0),
	`roles_mask`	INTEGER NOT NULL DEFAULT "0" CHECK("roles_mask" >= 0),
	`registered`	INTEGER NOT NULL CHECK("registered" >= 0),
	`last_login`	INTEGER DEFAULT NULL CHECK("last_login" >= 0),
	`force_logout`	INTEGER NOT NULL DEFAULT "0" CHECK("force_logout" >= 0),
	CONSTRAINT `email` UNIQUE(`email`)
);
INSERT INTO `users` VALUES (1,'admin@email.local','$2y$10$RAUu9/OPsaALL2eTwt7v0OcWsQOwuzrvAY4YjdgoM/G1291SO2VmW','Admin',0,1,1,1,1637780735,NULL,0);
CREATE INDEX IF NOT EXISTS `users_throttling.expires_at` ON `users_throttling` (
	`expires_at`
);
CREATE INDEX IF NOT EXISTS `users_resets.user_expires` ON `users_resets` (
	`user`,
	`expires`
);
CREATE INDEX IF NOT EXISTS `users_remembered.user` ON `users_remembered` (
	`user`
);
CREATE INDEX IF NOT EXISTS `users_confirmations.user_id` ON `users_confirmations` (
	`user_id`
);
CREATE INDEX IF NOT EXISTS `users_confirmations.email_expires` ON `users_confirmations` (
	`email`,
	`expires`
);
COMMIT;
