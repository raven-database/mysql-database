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

-- CREATE SCHEMA IF NOT EXISTS `transcriptatlas` DEFAULT CHARACTER SET latin1 ;
-- -----------------------------------------------------
-- Table `BirdLibraries`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `BirdLibraries`;
CREATE TABLE IF NOT EXISTS `BirdLibraries` (
  `library_id` INT(11) NOT NULL,
  `bird_id` VARCHAR(50) NULL DEFAULT NULL,
  `species` VARCHAR(100) NOT NULL,
  `line` VARCHAR(100) NULL DEFAULT NULL,
  `tissue` VARCHAR(100) NULL DEFAULT NULL,
  `method` VARCHAR(100) NULL DEFAULT NULL,
  `index_` INT(3) NULL DEFAULT NULL,
  `chip_result` VARCHAR(100) NULL DEFAULT NULL,
  `scientist` VARCHAR(100) NULL DEFAULT NULL,
  `date` DATETIME NOT NULL,
  `notes` VARCHAR(225) NULL DEFAULT NULL,
  PRIMARY KEY (`library_id`),
  INDEX `birdlibraries_indx_species` (`species` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `MappingStats`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `MappingStats`;
CREATE TABLE IF NOT EXISTS `MappingStats` (
  `library_id` INT(11) NOT NULL DEFAULT '0',
  `total_reads` INT(11) NULL DEFAULT NULL,
  `mapped_reads` INT(11) NULL DEFAULT NULL,
  `unmapped_reads` INT(11) NULL DEFAULT NULL,
	`alignment_rate` DOUBLE(5,2) NULL DEFAULT NULL,
  `deletions` INT(11) NULL DEFAULT NULL,
  `insertions` INT(11) NULL DEFAULT NULL,
  `junctions` INT(11) NULL DEFAULT NULL,
  `date` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`library_id`),
  CONSTRAINT `mappingstats_ibfk_1`
    FOREIGN KEY (`library_id`)
    REFERENCES `BirdLibraries` (`library_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `TheMetadata`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `TheMetadata`;
CREATE TABLE IF NOT EXISTS `TheMetadata` (
  `library_id` INT(11) NOT NULL DEFAULT '0',
  `ref_genome` VARCHAR(100) NULL DEFAULT NULL,
  `ann_file` VARCHAR(100) NULL DEFAULT NULL,
  `ann_file_ver` VARCHAR(100) NULL DEFAULT NULL,
  `stranded` VARCHAR(100) NULL DEFAULT NULL,
  `sequences` TEXT NULL DEFAULT NULL,
	`mappingtool` VARCHAR(100) NULL DEFAULT NULL,
	`status` CHAR(5) NULL DEFAULT NULL,
  PRIMARY KEY (`library_id`),
  CONSTRAINT `themetadata_ibfk_1`
    FOREIGN KEY (`library_id`)
    REFERENCES `MappingStats` (`library_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- -----------------------------------------------------
-- Table `GeneSummary`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GeneSummary`;
CREATE TABLE IF NOT EXISTS `GeneSummary` (
  `library_id` INT(11) NOT NULL DEFAULT '0',
  `isoforms` INT(11) NULL DEFAULT NULL,
  `genes` INT(11) NULL DEFAULT NULL,
  `diffexpresstool` VARCHAR(150) NULL DEFAULT NULL,
	`countstool` VARCHAR(150) NULL DEFAULT NULL,
  `status` CHAR(5) NULL DEFAULT NULL,
  `NoSQL` CHAR(10) NULL DEFAULT NULL,
	`date` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`library_id`),
  CONSTRAINT `genesummary_ibfk_1`
    FOREIGN KEY (`library_id`)
    REFERENCES `MappingStats` (`library_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `GenesFpkm`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GenesFpkm`;
CREATE TABLE IF NOT EXISTS `GenesFpkm` (
  `library_id` INT(11) NOT NULL DEFAULT '0',
  `gene_id` VARCHAR(50) NOT NULL DEFAULT '',
  `gene_short_name` VARCHAR(200) NOT NULL DEFAULT '',
  `chrom_no` VARCHAR(50) NOT NULL DEFAULT '',
  `chrom_start` INT(11) NOT NULL DEFAULT '0',
  `chrom_stop` INT(11) NOT NULL DEFAULT '0',
  `coverage` DOUBLE(20,10) NULL DEFAULT NULL,
  `tpm` DOUBLE(20,5) NOT NULL DEFAULT '0.00000',
  `fpkm` DOUBLE(20,5) NOT NULL DEFAULT '0.00000',
  `fpkm_conf_low` DOUBLE(20,5) NOT NULL DEFAULT '0.00000',
  `fpkm_conf_high` DOUBLE(20,5) NOT NULL DEFAULT '0.00000',
  `fpkm_status` VARCHAR(10) NULL DEFAULT NULL,
  PRIMARY KEY (`library_id`, `gene_id`, `gene_short_name`, `chrom_no`, `chrom_start`, `chrom_stop`, `fpkm`, `fpkm_conf_low`, `fpkm_conf_high`),
  INDEX `genesfpkm_indx_gene_short_name` (`gene_short_name` ASC),
  INDEX `genesfpkm_index_gene_and_fpkm` (`gene_short_name` ASC, `fpkm` ASC),
  INDEX `genesfpkm_index_gene_and_fpkm_and_library` (`gene_short_name` ASC, `fpkm` ASC, `library_id` ASC),
  CONSTRAINT `genesfpkm_ibfk_1`
    FOREIGN KEY (`library_id`)
    REFERENCES `GeneSummary` (`library_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ReadCount`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ReadCount`;
CREATE TABLE IF NOT EXISTS `ReadCount` (
  `library_id` INT(11) NOT NULL DEFAULT '0',
  `gene_name` VARCHAR(200) NOT NULL DEFAULT '',
  `read_count` INT(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`library_id`, `gene_name`),
  INDEX `readcount_gene_name` (`gene_name` ASC),
  CONSTRAINT `readcount_ibfk_1`
    FOREIGN KEY (`library_id`)
    REFERENCES `GeneSummary` (`library_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


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
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `VariantSummary`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VariantSummary`;
CREATE TABLE IF NOT EXISTS `VariantSummary` (
  `library_id` INT(11) NOT NULL DEFAULT '0',
  `total_VARIANTS` INT(11) NULL DEFAULT NULL,
  `total_SNPS` INT(11) NULL DEFAULT NULL,
  `total_INDELS` INT(11) NULL DEFAULT NULL,
  `variant_tool` VARCHAR(50) NULL DEFAULT NULL,
  `ANN_version` VARCHAR(50) NULL DEFAULT NULL,
  `Picard_version` VARCHAR(50) NULL DEFAULT NULL,
  `GATK_version` VARCHAR(50) NULL DEFAULT NULL,
  `date` DATE NOT NULL,
  `status` CHAR(5) NULL DEFAULT NULL,
  `NoSQL` CHAR(10) NULL DEFAULT NULL,
  PRIMARY KEY (`library_id`),
  CONSTRAINT `variantsummary_ibfk_1`
    FOREIGN KEY (`library_id`)
    REFERENCES `MappingStats` (`library_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `VariantResult`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VariantResult`;
CREATE TABLE IF NOT EXISTS `VariantResult` (
  `library_id` INT(11) NOT NULL DEFAULT '0',
  `chrom` VARCHAR(50) NOT NULL DEFAULT '',
  `position` INT(11) NOT NULL DEFAULT '0',
  `ref_allele` VARCHAR(50) NULL DEFAULT NULL,
  `alt_allele` VARCHAR(50) NULL DEFAULT NULL,
  `quality` DOUBLE(20,5) NULL DEFAULT NULL,
  `variant_class` VARCHAR(50) NULL DEFAULT NULL,
  `zygosity` VARCHAR(50) NULL DEFAULT NULL,
  `existing_variant` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`library_id`, `chrom`, `position`),
  CONSTRAINT `variantresult_ibfk_1`
    FOREIGN KEY (`library_id`)
    REFERENCES `VariantSummary` (`library_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `VariantAnnotation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `VariantAnnotation`;
CREATE TABLE IF NOT EXISTS `VariantAnnotation` (
  `library_id` INT(11) NOT NULL DEFAULT '0',
  `chrom` VARCHAR(50) NOT NULL DEFAULT '',
  `position` INT(11) NOT NULL DEFAULT '0',
  `consequence` VARCHAR(50) NOT NULL DEFAULT '',
  `gene_id` VARCHAR(50) NOT NULL DEFAULT '',
  `gene_name` VARCHAR(50) NULL DEFAULT NULL,
  `transcript` VARCHAR(200) NULL DEFAULT NULL,
  `feature` VARCHAR(50) NULL DEFAULT NULL,
  `gene_type` VARCHAR(200) NULL DEFAULT NULL,
  `protein_position` VARCHAR(50) NOT NULL DEFAULT '',
  `aminoacid_change` VARCHAR(50) NULL DEFAULT NULL,
  `codon_change` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`library_id`, `chrom`, `position`, `consequence`, `gene_id`, `protein_position`),
  INDEX `variants_annotation_indx_genename` (`gene_name` ASC),
  CONSTRAINT `variantannotation_ibfk_1`
    FOREIGN KEY (`library_id` , `chrom` , `position`)
    REFERENCES `VariantResult` (`library_id` , `chrom` , `position`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- -----------------------------------------------------
-- Placeholder table for view `vw_varanno`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vw_varanno` (`library_id` INT, `chrom` INT, `position` INT, `ref_allele` INT, `alt_allele` INT, `annotation` INT, `amount` INT);

-- -----------------------------------------------------
-- Placeholder table for view `vw_libmetadata`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vw_libmetadata` (`library_id` INT, `line` INT, `species` INT, `tissue` INT, `notes` INT, `mapped_reads` INT, `genes` INT, `isoforms` INT, `total_VARIANTS` INT, `total_SNPS` INT, `total_INDELS` INT);

-- -----------------------------------------------------
-- Placeholder table for view `vw_statuslog`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vw_statuslog` (`library_id` INT, `status` INT, `gene_status` INT, `gene_nosql` INT, `variant_status` INT, `variant_nosql` INT);

-- -----------------------------------------------------
-- Placeholder table for view `vw_variantinfo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vw_variantinfo` (`library_id` INT, `chrom` INT, `position` INT, `ref_allele` INT, `alt_allele` INT, `variant_class` INT, `annotation` INT, `genename` INT, `existing_variant` INT);

-- -----------------------------------------------------
-- View `vw_varanno`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vw_varanno`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`frnakenstein`@`localhost` SQL SECURITY DEFINER VIEW `vw_varanno` AS select `a`.`library_id` AS `library_id`,`a`.`chrom` AS `chrom`,`a`.`position` AS `position`,`a`.`ref_allele` AS `ref_allele`,`a`.`alt_allele` AS `alt_allele`,group_concat(distinct `b`.`consequence` separator '; ') AS `annotation`,count(0) AS `amount` from (`VariantResult` `a` join `VariantAnnotation` `b` on(((`a`.`library_id` = `b`.`library_id`) and (`a`.`chrom` = `b`.`chrom`) and (`a`.`position` = `b`.`position`)))) group by `a`.`library_id`,`a`.`chrom`,`a`.`position`;

-- -----------------------------------------------------
-- View `vw_libmetadata`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vw_libmetadata`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`frnakenstein`@`localhost` SQL SECURITY DEFINER VIEW `vw_libmetadata` AS select `a`.`library_id` AS `library_id`,`a`.`line` AS `line`,`a`.`species` AS `species`,`a`.`tissue` AS `tissue`,`a`.`notes` AS `notes`,`b`.`mapped_reads` AS `mapped_reads`,`d`.`genes` AS `genes`,`d`.`isoforms` AS `isoforms`,`c`.`total_VARIANTS` AS `total_VARIANTS`,`c`.`total_SNPS` AS `total_SNPS`,`c`.`total_INDELS` AS `total_INDELS` from (((`BirdLibraries` `a` join `MappingStats` `b` on((`a`.`library_id` = `b`.`library_id`))) join `VariantSummary` `c` on((`a`.`library_id` = `c`.`library_id`))) join `GeneSummary` `d` on((`a`.`library_id` = `d`.`library_id`)));

-- -----------------------------------------------------
-- View `vw_statuslog`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vw_statuslog`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`frnakenstein`@`localhost` SQL SECURITY DEFINER VIEW `vw_statuslog` AS select `a`.`library_id` AS `library_id`,`a`.`status` AS `status`,`b`.`status` AS `gene_status`,`b`.`NoSQL` AS `gene_nosql`,`c`.`status` AS `variant_status`,`c`.`NoSQL` AS `variant_nosql` from ((`TheMetadata` `a` left join `GeneSummary` `b` on((`a`.`library_id` = `b`.`library_id`))) left join `VariantSummary` `c` on((`a`.`library_id` = `c`.`library_id`)));

-- -----------------------------------------------------
-- View `vw_variantinfo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vw_variantinfo`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`frnakenstein`@`localhost` SQL SECURITY DEFINER VIEW `vw_variantinfo` AS select `a`.`library_id` AS `library_id`,`a`.`chrom` AS `chrom`,`a`.`position` AS `position`,`a`.`ref_allele` AS `ref_allele`,`a`.`alt_allele` AS `alt_allele`,`a`.`variant_class` AS `variant_class`,group_concat(distinct ifnull(`b`.`consequence`,'none') separator '; ') AS `annotation`,ifnull(group_concat(distinct `b`.`gene_name` separator '; '),'none') AS `genename`,group_concat(distinct ifnull(`a`.`existing_variant`,'none') separator '; ') AS `existing_variant` from (`VariantResult` `a` join `VariantAnnotation` `b` on(((`a`.`library_id` = `b`.`library_id`) and (`a`.`chrom` = `b`.`chrom`) and (`a`.`position` = `b`.`position`)))) where (`b`.`gene_name` is not null) group by `a`.`library_id`,`a`.`chrom`,`a`.`position`;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

