-- MySQL Script generated by MySQL Workbench
-- Wed Feb 28 15:08:25 2024
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema quirinos_db
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `quirinos_db` ;

-- -----------------------------------------------------
-- Schema quirinos_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `quirinos_db` DEFAULT CHARACTER SET utf8 ;
USE `quirinos_db` ;

-- -----------------------------------------------------
-- Table `quirinos_db`.`clientes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `quirinos_db`.`clientes` ;

CREATE TABLE IF NOT EXISTS `quirinos_db`.`clientes` (
  `id_cliente` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(255) NOT NULL,
  `endereco` VARCHAR(255) NOT NULL,
  `bairro` VARCHAR(255) NOT NULL,
  `complemento` VARCHAR(255) NOT NULL,
  `cpf` VARCHAR(14) NOT NULL,
  PRIMARY KEY (`id_cliente`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `quirinos_db`.`funcionarios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `quirinos_db`.`funcionarios` ;

CREATE TABLE IF NOT EXISTS `quirinos_db`.`funcionarios` (
  `id_funcionario` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `rg` VARCHAR(12) NOT NULL,
  `senha` VARCHAR(255) NOT NULL,
  `foto` VARCHAR(255) NOT NULL,
  `editar_senha` FLOAT NOT NULL,
  `dt_criacao` DATETIME NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_funcionario`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `quirinos_db`.`servicos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `quirinos_db`.`servicos` ;

CREATE TABLE IF NOT EXISTS `quirinos_db`.`servicos` (
  `id_servico` INT NOT NULL AUTO_INCREMENT,
  `id_funcionario` INT NULL,
  `id_cliente` INT NOT NULL,
  `seguradora` VARCHAR(255) NOT NULL,
  `numero_da_assistencia` INT NOT NULL,
  `data_inicio` DATETIME NULL,
  `data_fim` DATETIME NULL,
  `tipo_de_servico` VARCHAR(255) NOT NULL,
  `descricao_problema` VARCHAR(255) NOT NULL,
  `avarias` VARCHAR(255) NULL,
  `descricao_do_servico_realizado` VARCHAR(255) NULL,
  `utilizou_pecas` TINYINT NULL,
  `pecas` VARCHAR(255) NULL,
  `valor_pecas` DOUBLE NULL,
  `checkup` VARCHAR(255) NULL,
  `problema_solucionado` TINYINT NULL,
  `havera_retorno` TINYINT NULL,
  `houve_excedente` TINYINT NULL,
  `valor_excedente` DOUBLE NULL,
  `local_limpo` TINYINT NULL,
  `cumpriu_horario` TINYINT NULL,
  `status` VARCHAR(12) NULL DEFAULT 'Pendente',
  PRIMARY KEY (`id_servico`, `id_cliente`),
  INDEX `fk_servicos_clientes1_idx` (`id_funcionario` ASC),
  INDEX `fk_servicos_funcionarios1_idx` (`id_cliente` ASC),
  CONSTRAINT `fk_servicos_clientes1`
    FOREIGN KEY (`id_funcionario`)
    REFERENCES `quirinos_db`.`funcionarios` (`id_funcionario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_servicos_funcionarios1`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `quirinos_db`.`clientes` (`id_cliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `quirinos_db`.`imagens_servico`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `quirinos_db`.`imagens_servico` ;

CREATE TABLE IF NOT EXISTS `quirinos_db`.`imagens_servico` (
  `id_imagem` INT NOT NULL AUTO_INCREMENT,
  `id_servico` INT NOT NULL,
  `imagem` VARCHAR(255) NOT NULL,
  `antes_ou_depois` VARCHAR(1) NOT NULL,
  PRIMARY KEY (`id_imagem`, `id_servico`),
  INDEX `fk_imagens_servico_servicos1_idx` (`id_servico` ASC),
  CONSTRAINT `fk_imagens_servico_servicos1`
    FOREIGN KEY (`id_servico`)
    REFERENCES `quirinos_db`.`servicos` (`id_servico`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `quirinos_db`.`assinaturas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `quirinos_db`.`assinaturas` ;

CREATE TABLE IF NOT EXISTS `quirinos_db`.`assinaturas` (
  `id_assinatura` INT NOT NULL AUTO_INCREMENT,
  `id_servico` INT NOT NULL,
  `assinatura_cliente` VARCHAR(255) NULL,
  `assinatura_prestador` VARCHAR(255) NULL,
  PRIMARY KEY (`id_assinatura`, `id_servico`),
  INDEX `fk_assinaturas_servicos1_idx` (`id_servico` ASC),
  CONSTRAINT `fk_assinaturas_servicos1`
    FOREIGN KEY (`id_servico`)
    REFERENCES `quirinos_db`.`servicos` (`id_servico`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `quirinos_db`.`pdfs_servicos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `quirinos_db`.`pdfs_servicos` ;

CREATE TABLE IF NOT EXISTS `quirinos_db`.`pdfs_servicos` (
  `id_pdf` INT NOT NULL AUTO_INCREMENT,
  `id_servico` INT NOT NULL,
  `pdf` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id_pdf`, `id_servico`),
  INDEX `fk_pdfs_servicos_servicos1_idx` (`id_servico` ASC),
  CONSTRAINT `fk_pdfs_servicos_servicos1`
    FOREIGN KEY (`id_servico`)
    REFERENCES `quirinos_db`.`servicos` (`id_servico`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
