-- -----------------------------------------------------
-- Table structure for table `role_time`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `role_time`;

CREATE TABLE `role_time` (
    `ckey` VARCHAR(32) NOT NULL ,
    `job` VARCHAR(32) NOT NULL ,
    `minutes` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`ckey`, `job`))
ENGINE = InnoDB;
