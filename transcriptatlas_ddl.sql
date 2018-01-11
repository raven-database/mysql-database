-- MySQL Script
-- 
-- Host: localhost    Database: transcriptatlas
-- Function: TranscriptAtlas Schema Script
-- 
-- ---------------------------------------------------
-- Server version       5.5.53
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Table `AtlasUser`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `AtlasUser`;
CREATE TABLE IF NOT EXISTS `AtlasUser` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `firstname` VARCHAR(255) NULL DEFAULT NULL,
  `lastname` VARCHAR(255) NULL DEFAULT NULL,
  `username` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `organization` VARCHAR(255) NULL DEFAULT NULL,
  `active` TINYINT(1) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `username` (`username` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- -----------------------------------------------------
-- Table `BirdLibraries`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `BirdLibraries`;
CREATE TABLE IF NOT EXISTS `BirdLibraries` (
  `libraryid` INT(11) NOT NULL,
  `birdid` VARCHAR(150) NULL DEFAULT NULL,
  `species` VARCHAR(150) NOT NULL,
  `line` VARCHAR(150) NULL DEFAULT NULL,
  `tissue` VARCHAR(150) NULL DEFAULT NULL,
  `method` VARCHAR(150) NULL DEFAULT NULL,
  `indexname` INT(3) NULL DEFAULT NULL,
  `chipresult` VARCHAR(150) NULL DEFAULT NULL,
  `scientist` VARCHAR(150) NULL DEFAULT NULL,
  `date` DATETIME NOT NULL,
  `notes` VARCHAR(225) NULL DEFAULT NULL,
  PRIMARY KEY (`libraryid`),
  INDEX `birdlibraries_indx_species` (`species` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- -----------------------------------------------------
-- Table `MappingStats`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `MappingStats`;
CREATE TABLE IF NOT EXISTS `MappingStats` (
  `libraryid` INT(11) NOT NULL DEFAULT '0',
  `totalreads` INT(11) NULL DEFAULT NULL,
  `mappedreads` INT(11) NULL DEFAULT NULL,
  `alignmentrate` DOUBLE(5,2) NULL DEFAULT NULL,
  `deletions` INT(11) NULL DEFAULT NULL,
  `insertions` INT(11) NULL DEFAULT NULL,
  `junctions` INT(11) NULL DEFAULT NULL,
  `date` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`libraryid`),
  CONSTRAINT `mappingstats_ibfk_1`
    FOREIGN KEY (`libraryid`)
    REFERENCES `BirdLibraries` (`libraryid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- -----------------------------------------------------
-- Table `Syntaxes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Syntaxes`;
CREATE TABLE IF NOT EXISTS `Syntaxes` (
  `libraryid` INT(11) NOT NULL,
  `mapsyntax` TEXT NULL DEFAULT NULL,
	`expsyntax` TEXT NULL DEFAULT NULL,
	`countsyntax` TEXT NULL DEFAULT NULL,
	`variantsyntax` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`libraryid`),
	CONSTRAINT `syntaxes_ibfk_1`
    FOREIGN KEY (`libraryid`)
    REFERENCES `MappingStats` (`libraryid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- -----------------------------------------------------
-- Table `TheMetadata`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `TheMetadata`;
CREATE TABLE IF NOT EXISTS `TheMetadata` (
  `libraryid` INT(11) NOT NULL DEFAULT '0',
  `refgenome` VARCHAR(150) NULL DEFAULT NULL,
  `annfile` VARCHAR(150) NULL DEFAULT NULL,
  `stranded` VARCHAR(150) NULL DEFAULT NULL,
  `sequences` TEXT NULL DEFAULT NULL,
	`mappingtool` VARCHAR(150) NULL DEFAULT NULL,
	`status` CHAR(5) NULL DEFAULT NULL,
  PRIMARY KEY (`libraryid`),
  CONSTRAINT `themetadata_ibfk_1`
    FOREIGN KEY (`libraryid`)
    REFERENCES `MappingStats` (`libraryid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- -----------------------------------------------------
-- Table `GenesSummary`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GenesSummary`;
CREATE TABLE IF NOT EXISTS `GenesSummary` (
  `libraryid` INT(11) NOT NULL DEFAULT '0',
  `genes` INT(11) NULL DEFAULT NULL,
  `diffexpresstool` VARCHAR(150) NULL DEFAULT NULL,
	`countstool` VARCHAR(150) NULL DEFAULT NULL,
  `genestatus` CHAR(5) NULL DEFAULT NULL,
	`countstatus` CHAR(5) NULL DEFAULT NULL,
  `date` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`libraryid`),
  CONSTRAINT `genessummary_ibfk_1`
    FOREIGN KEY (`libraryid`)
    REFERENCES `MappingStats` (`libraryid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- -----------------------------------------------------
-- Table `VariantSummary`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VariantSummary`;
CREATE TABLE IF NOT EXISTS `VariantSummary` (
  `libraryid` INT(11) NOT NULL DEFAULT '0',
  `totalVARIANTS` INT(11) NULL DEFAULT NULL,
  `totalSNPS` INT(11) NULL DEFAULT NULL,
  `totalINDELS` INT(11) NULL DEFAULT NULL,
  `varianttool` VARCHAR(150) NULL DEFAULT NULL,
  `ANNversion` VARCHAR(150) NULL DEFAULT NULL,
  `date` DATE NOT NULL,
  `status` CHAR(5) NULL DEFAULT NULL,
	`nosql` CHAR(5) NULL DEFAULT NULL,
  PRIMARY KEY (`libraryid`),
  CONSTRAINT `variantsummary_ibfk_1`
    FOREIGN KEY (`libraryid`)
    REFERENCES `MappingStats` (`libraryid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- -----------------------------------------------------
-- Table `VariantResult`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VariantResult`;
CREATE TABLE IF NOT EXISTS `VariantResult` (
  `libraryid` INT(11) NOT NULL DEFAULT '0',
  `chrom` VARCHAR(150) NOT NULL DEFAULT '',
  `position` INT(11) NOT NULL DEFAULT '0',
  `refallele` VARCHAR(1000) NULL DEFAULT NULL,
  `altallele` VARCHAR(1000) NULL DEFAULT NULL,
  `quality` DOUBLE(20,5) NULL DEFAULT NULL,
  `variantclass` VARCHAR(150) NULL DEFAULT NULL,
  `zygosity` VARCHAR(150) NULL DEFAULT NULL,
  `existingvariant` VARCHAR(150) NULL DEFAULT NULL,
  PRIMARY KEY (`libraryid`, `chrom`, `position`),
  CONSTRAINT `variantresult_ibfk_1`
    FOREIGN KEY (`libraryid`)
    REFERENCES `VariantSummary` (`libraryid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- -----------------------------------------------------
-- Table `VariantAnnotation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VariantAnnotation`;
CREATE TABLE IF NOT EXISTS `VariantAnnotation` (
  `libraryid` INT(11) NOT NULL DEFAULT '0',
  `chrom` VARCHAR(150) NOT NULL DEFAULT '',
  `position` INT(11) NOT NULL DEFAULT '0',
  `consequence` VARCHAR(150) NOT NULL DEFAULT '',
  `source` VARCHAR(150) NULL DEFAULT NULL,
	`geneid` VARCHAR(1000) NOT NULL DEFAULT '',
  `genename` VARCHAR(1000) NULL DEFAULT NULL,
  `transcript` VARCHAR(250) NULL DEFAULT NULL,
  `feature` VARCHAR(150) NULL DEFAULT NULL,
  `genetype` VARCHAR(200) NULL DEFAULT NULL,
  `proteinposition` VARCHAR(1000) NOT NULL DEFAULT '',
  `aminoacidchange` VARCHAR(1000) NULL DEFAULT NULL,
  `codonchange` VARCHAR(1000) NULL DEFAULT NULL,
  PRIMARY KEY (`libraryid`, `chrom`, `position`, `consequence`, `geneid`, `proteinposition`),
  INDEX `variantannotation_indx_genename` (`genename` ASC),
  CONSTRAINT `variantannotation_ibfk_1`
    FOREIGN KEY (`libraryid` , `chrom` , `position`)
    REFERENCES `VariantResult` (`libraryid` , `chrom` , `position`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- -----------------------------------------------------
-- View `vw_varanno`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vw_varanno`;
DROP VIEW IF EXISTS `vw_varanno`;
CREATE VIEW `vw_varanno` AS
	select `a`.`libraryid` AS `libraryid`,`a`.`chrom` AS `chrom`,`a`.`position` AS `position`,
		`a`.`refallele` AS `refallele`,`a`.`altallele` AS `alt_allele`,
		group_concat(distinct `b`.`consequence` separator '; ') AS `annotation`,
		count(0) AS `amount`
	from (`VariantResult` `a` join `VariantAnnotation` `b` on(((`a`.`libraryid` = `b`.`libraryid`)
		and (`a`.`chrom` = `b`.`chrom`) and (`a`.`position` = `b`.`position`))))
		group by `a`.`libraryid`,`a`.`chrom`,`a`.`position`;

-- -----------------------------------------------------
-- View `vw_libmetadata`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vw_libmetadata`;
DROP VIEW IF EXISTS `vw_libmetadata`;
CREATE VIEW `vw_libmetadata` AS
	select `a`.`libraryid` AS `libraryid`,`a`.`line` AS `line`,`a`.`species` AS `species`,`a`.`tissue` AS `tissue`,
		`a`.`notes` AS `notes`,`b`.`mappedreads` AS `mappedreads`,`b`.`alignmentrate` AS `alignmentrate`,
		`d`.`genes` AS `genes`,`c`.`totalVARIANTS` AS `totalVARIANTS`,`c`.`totalSNPS` AS `totalSNPS`,
		`c`.`totalINDELS` AS `totalINDELS`
	from (((`BirdLibraries` `a` join `MappingStats` `b` on((`a`.`libraryid` = `b`.`libraryid`)))
		join `VariantSummary` `c` on((`a`.`libraryid` = `c`.`libraryid`)))
		join `GenesSummary` `d` on((`a`.`libraryid` = `d`.`libraryid`)));

-- -----------------------------------------------------
-- View `vw_statuslog`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `vw_statuslog`;
CREATE VIEW `vw_statuslog` AS
	select `a`.`libraryid` AS `libraryid`,`a`.`status` AS `map_status`,`b`.`genestatus` AS `gene_status`,
		`b`.`countstatus` AS `count_status`,`c`.`status` AS `variant_status`
	from ((`TheMetadata` `a` left join `GenesSummary` `b` on((`a`.`libraryid` = `b`.`libraryid`)))
		left join `VariantSummary` `c` on((`a`.`libraryid` = `c`.`libraryid`)));

-- -----------------------------------------------------
-- View `vw_variantinfo`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `vw_variantinfo`;
CREATE VIEW `vw_variantinfo` AS
	select `a`.`libraryid` AS `libraryid`,`a`.`chrom` AS `chrom`,`a`.`position` AS `position`,
		`a`.`refallele` AS `refallele`,`a`.`altallele` AS `altallele`,`a`.`variantclass` AS `variantclass`,
		group_concat(distinct ifnull(`b`.`consequence`,'none') separator '; ') AS `annotation`,
		ifnull(group_concat(distinct `b`.`genename` separator '; '),'none') AS `genename`,
		group_concat(distinct ifnull(`a`.`existingvariant`,'none') separator '; ') AS `existingvariant`
	from (`VariantResult` `a` join `VariantAnnotation` `b` on(((`a`.`libraryid` = `b`.`libraryid`)
		and (`a`.`chrom` = `b`.`chrom`) and (`a`.`position` = `b`.`position`))))
		where (`b`.`genename` is not null) group by `a`.`libraryid`,`a`.`chrom`,`a`.`position`;

-- -----------------------------------------------------
-- View `vw_variantnosql`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `vw_variantnosql`;
CREATE VIEW `vw_variantnosql` AS
	select `a`.`variantclass` AS `variantclass`,`a`.`zygosity` AS `zygosity`,`a`.`dbsnpvariant` AS `dbsnpvariant`,
		`b`.`source` AS `source`,`b`.`consequence` AS `consequence`,`b`.`geneid` AS `geneid`,
		`b`.`genename` AS `genename`,`b`.`transcript` AS `transcript`,`b`.`feature` AS `feature`,
		`b`.`genetype` AS `genetype`,`a`.`refallele` AS `refallele`,`a`.`altallele` AS `altallele`,
		`c`.`tissue` AS `tissue`,`a`.`chrom` AS `chrom`,`b`.`aminoacidchange` AS `aminoacidchange`,`b`.`codonchange` AS `codonchange`,
		`c`.`organism` AS `organism`,`a`.`quality` AS `quality`,`a`.`libaryid` AS `libraryid`,`a`.`position` AS `position`,
		`b`.`proteinposition` AS `proteinposition`
	from ((`VariantResult` `a` join `VariantAnnotation` `b` on (((`a`.`sampleid` = `b`.`sampleid`) and (`a`.`chrom` = `b`.`chrom`) and (`a`.`position` = `b`.`position`))))
		join BirdLibraries `c` on ((`a`.`sampleid` = `c`.`sampleid`)));
		
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

