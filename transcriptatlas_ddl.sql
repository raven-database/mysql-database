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
  `birdid` VARCHAR(50) NULL DEFAULT NULL,
  `species` VARCHAR(100) NOT NULL,
  `line` VARCHAR(100) NULL DEFAULT NULL,
  `tissue` VARCHAR(100) NULL DEFAULT NULL,
  `method` VARCHAR(100) NULL DEFAULT NULL,
  `indexname` INT(3) NULL DEFAULT NULL,
  `chipresult` VARCHAR(100) NULL DEFAULT NULL,
  `scientist` VARCHAR(100) NULL DEFAULT NULL,
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
  `unmappedreads` INT(11) NULL DEFAULT NULL,
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
  `refgenome` VARCHAR(100) NULL DEFAULT NULL,
  `annfile` VARCHAR(100) NULL DEFAULT NULL,
  `annfilever` VARCHAR(100) NULL DEFAULT NULL,
  `stranded` VARCHAR(100) NULL DEFAULT NULL,
  `sequences` TEXT NULL DEFAULT NULL,
	`mappingtool` VARCHAR(100) NULL DEFAULT NULL,
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
  `NoSQL` CHAR(10) NULL DEFAULT NULL,
	`date` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`libraryid`),
  CONSTRAINT `genessummary_ibfk_1`
    FOREIGN KEY (`libraryid`)
    REFERENCES `MappingStats` (`libraryid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `GenesExpression`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GenesExpression`;
CREATE TABLE IF NOT EXISTS `GenesExpression` (
  `libraryid` INT(11) NOT NULL DEFAULT '0',
  `geneid` VARCHAR(50) NOT NULL DEFAULT '',
  `geneshortname` VARCHAR(200) NOT NULL DEFAULT '',
  `chrom` VARCHAR(50) NOT NULL DEFAULT '',
  `chromstart` INT(11) NOT NULL DEFAULT '0',
  `chromstop` INT(11) NOT NULL DEFAULT '0',
  `coverage` DOUBLE(20,10) NULL DEFAULT NULL,
  `tpm` DOUBLE(20,5) NOT NULL DEFAULT '0.00000',
  `fpkm` DOUBLE(20,5) NOT NULL DEFAULT '0.00000',
  `fpkmconflow` DOUBLE(20,5) NOT NULL DEFAULT '0.00000',
  `fpkmconfhigh` DOUBLE(20,5) NOT NULL DEFAULT '0.00000',
  `fpkmstatus` VARCHAR(10) NULL DEFAULT NULL,
  PRIMARY KEY (`libraryid`, `geneid`, `geneshortname`, `chrom`, `chromstart`, `chromstop`, `fpkm`, `fpkmconflow`, `fpkmconfhigh`),
  INDEX `genesexp_indx_gene_short_name` (`geneshortname` ASC),
  INDEX `genesexp_index_gene_and_fpkm` (`geneshortname` ASC, `fpkm` ASC),
  INDEX `genesexp_index_gene_and_fpkm_and_library` (`geneshortname` ASC, `fpkm` ASC, `libraryid` ASC),
  CONSTRAINT `genesexp_ibfk_1`
    FOREIGN KEY (`libraryid`)
    REFERENCES `GenesSummary` (`libraryid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ReadCount`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ReadCount`;
CREATE TABLE IF NOT EXISTS `ReadCount` (
  `libraryid` INT(11) NOT NULL DEFAULT '0',
  `genename` VARCHAR(200) NOT NULL DEFAULT '',
  `readcount` INT(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`libraryid`, `genename`),
  INDEX `readcount_gene_name` (`genename` ASC),
  CONSTRAINT `readcount_ibfk_1`
    FOREIGN KEY (`libraryid`)
    REFERENCES `GenesSummary` (`libraryid`))
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
  `varianttool` VARCHAR(50) NULL DEFAULT NULL,
  `ANNversion` VARCHAR(50) NULL DEFAULT NULL,
  `Picardversion` VARCHAR(50) NULL DEFAULT NULL,
  `GATKversion` VARCHAR(50) NULL DEFAULT NULL,
  `date` DATE NOT NULL,
  `status` CHAR(5) NULL DEFAULT NULL,
  `NoSQL` CHAR(10) NULL DEFAULT NULL,
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
  `chrom` VARCHAR(50) NOT NULL DEFAULT '',
  `position` INT(11) NOT NULL DEFAULT '0',
  `refallele` VARCHAR(50) NULL DEFAULT NULL,
  `altallele` VARCHAR(50) NULL DEFAULT NULL,
  `quality` DOUBLE(20,5) NULL DEFAULT NULL,
  `variantclass` VARCHAR(50) NULL DEFAULT NULL,
  `zygosity` VARCHAR(50) NULL DEFAULT NULL,
  `existingvariant` VARCHAR(50) NULL DEFAULT NULL,
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
  `chrom` VARCHAR(50) NOT NULL DEFAULT '',
  `position` INT(11) NOT NULL DEFAULT '0',
  `consequence` VARCHAR(50) NOT NULL DEFAULT '',
  `geneid` VARCHAR(50) NOT NULL DEFAULT '',
  `genename` VARCHAR(50) NULL DEFAULT NULL,
  `transcript` VARCHAR(200) NULL DEFAULT NULL,
  `feature` VARCHAR(50) NULL DEFAULT NULL,
  `genetype` VARCHAR(200) NULL DEFAULT NULL,
  `proteinposition` VARCHAR(50) NOT NULL DEFAULT '',
  `aminoacidchange` VARCHAR(50) NULL DEFAULT NULL,
  `codonchange` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`libraryid`, `chrom`, `position`, `consequence`, `geneid`, `proteinposition`),
  INDEX `variantannotation_indx_genename` (`genename` ASC),
  CONSTRAINT `variantannotation_ibfk_1`
    FOREIGN KEY (`libraryid` , `chrom` , `position`)
    REFERENCES `VariantResult` (`libraryid` , `chrom` , `position`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- -----------------------------------------------------
-- Placeholder table for view `vw_varanno`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vw_varanno` (`libraryid` INT, `chrom` INT, `position` INT, `refallele` INT, `altallele` INT, `annotation` INT, `amount` INT);

-- -----------------------------------------------------
-- Placeholder table for view `vw_libmetadata`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vw_libmetadata` (`libraryid` INT, `line` INT, `species` INT, `tissue` INT, `notes` INT, `mappedreads` INT, `alignmentrate` INT,`genes` INT, `totalVARIANTS` INT, `totalSNPS` INT, `totalINDELS` INT);

-- -----------------------------------------------------
-- Placeholder table for view `vw_statuslog`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vw_statuslog` (`libraryid` INT, `status` INT, `gene_status` INT, `gene_nosql` INT, `variantstatus` INT, `variant_nosql` INT);

-- -----------------------------------------------------
-- Placeholder table for view `vw_variantinfo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vw_variantinfo` (`libraryid` INT, `chrom` INT, `position` INT, `ref_allele` INT, `altallele` INT, `variantclass` INT, `annotation` INT, `genename` INT, `existingvariant` INT);

-- -----------------------------------------------------
-- View `vw_varanno`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vw_varanno`;
DROP VIEW IF EXISTS `vw_varanno`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`frnakenstein`@`localhost` SQL SECURITY DEFINER VIEW `vw_varanno` AS select `a`.`libraryid` AS `libraryid`,`a`.`chrom` AS `chrom`,`a`.`position` AS `position`,`a`.`refallele` AS `refallele`,`a`.`altallele` AS `alt_allele`,group_concat(distinct `b`.`consequence` separator '; ') AS `annotation`,count(0) AS `amount` from (`VariantResult` `a` join `VariantAnnotation` `b` on(((`a`.`libraryid` = `b`.`libraryid`) and (`a`.`chrom` = `b`.`chrom`) and (`a`.`position` = `b`.`position`)))) group by `a`.`libraryid`,`a`.`chrom`,`a`.`position`;

-- -----------------------------------------------------
-- View `vw_libmetadata`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vw_libmetadata`;
DROP VIEW IF EXISTS `vw_libmetadata`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`frnakenstein`@`localhost` SQL SECURITY DEFINER VIEW `vw_libmetadata` AS select `a`.`libraryid` AS `libraryid`,`a`.`line` AS `line`,`a`.`species` AS `species`,`a`.`tissue` AS `tissue`,`a`.`notes` AS `notes`,`b`.`mappedreads` AS `mappedreads`,`b`.`alignmentrate` AS `alignmentrate`,`d`.`genes` AS `genes`,`c`.`totalVARIANTS` AS `totalVARIANTS`,`c`.`totalSNPS` AS `totalSNPS`,`c`.`totalINDELS` AS `totalINDELS` from (((`BirdLibraries` `a` join `MappingStats` `b` on((`a`.`libraryid` = `b`.`libraryid`))) join `VariantSummary` `c` on((`a`.`libraryid` = `c`.`libraryid`))) join `GenesSummary` `d` on((`a`.`libraryid` = `d`.`libraryid`)));

-- -----------------------------------------------------
-- View `vw_statuslog`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vw_statuslog`;
DROP VIEW IF EXISTS `vw_statuslog`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`frnakenstein`@`localhost` SQL SECURITY DEFINER VIEW `vw_statuslog` AS select `a`.`libraryid` AS `libraryid`,`a`.`status` AS `map_status`,`b`.`genestatus` AS `gene_status`,`b`.`countstatus` AS `count_status`,`b`.`NoSQL` AS `gene_nosql`,`c`.`status` AS `variant_status`,`c`.`NoSQL` AS `variant_nosql` from ((`TheMetadata` `a` left join `GenesSummary` `b` on((`a`.`libraryid` = `b`.`libraryid`))) left join `VariantSummary` `c` on((`a`.`libraryid` = `c`.`libraryid`)));

-- -----------------------------------------------------
-- View `vw_variantinfo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vw_variantinfo`;
DROP VIEW IF EXISTS `vw_variantinfo`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`frnakenstein`@`localhost` SQL SECURITY DEFINER VIEW `vw_variantinfo` AS select `a`.`libraryid` AS `libraryid`,`a`.`chrom` AS `chrom`,`a`.`position` AS `position`,`a`.`refallele` AS `refallele`,`a`.`altallele` AS `altallele`,`a`.`variantclass` AS `variantclass`,group_concat(distinct ifnull(`b`.`consequence`,'none') separator '; ') AS `annotation`,ifnull(group_concat(distinct `b`.`genename` separator '; '),'none') AS `genename`,group_concat(distinct ifnull(`a`.`existingvariant`,'none') separator '; ') AS `existingvariant` from (`VariantResult` `a` join `VariantAnnotation` `b` on(((`a`.`libraryid` = `b`.`libraryid`) and (`a`.`chrom` = `b`.`chrom`) and (`a`.`position` = `b`.`position`)))) where (`b`.`genename` is not null) group by `a`.`libraryid`,`a`.`chrom`,`a`.`position`;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

