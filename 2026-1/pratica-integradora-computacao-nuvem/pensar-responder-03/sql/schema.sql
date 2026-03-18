-- Schema para banco de dados de aprendizado de inglês
-- Projeto: English Learning Database

-- Criar o banco de dados (caso não seja criado automaticamente pelo Terraform)
CREATE DATABASE IF NOT EXISTS english_learning;

-- Usar o banco de dados
USE english_learning;

-- Criar tabela de frases para estudo
CREATE TABLE IF NOT EXISTS frases (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador único da frase',
    frase_ingles VARCHAR(500) NOT NULL COMMENT 'Frase em inglês',
    frase_portugues VARCHAR(500) NOT NULL COMMENT 'Tradução em português',
    revisada_em DATETIME NULL COMMENT 'Data da última revisão da frase',
    dominio ENUM('facil', 'media', 'dificil') NOT NULL DEFAULT 'media' COMMENT 'Nível de dificuldade',
    criada_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação do registro',
    atualizada_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data da última atualização'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tabela para armazenar frases de estudo de inglês';

-- Criar índice para facilitar busca por domínio
CREATE INDEX idx_dominio ON frases(dominio);

-- Criar índice para facilitar busca por data de revisão
CREATE INDEX idx_revisada_em ON frases(revisada_em);

-- Inserir alguns exemplos de frases para teste
INSERT INTO frases (frase_ingles, frase_portugues, dominio, revisada_em) VALUES
('Hello, how are you?', 'Olá, como você está?', 'facil', NOW()),
('The weather is nice today.', 'O clima está agradável hoje.', 'facil', NULL),
('I would like to book a table for two people.', 'Eu gostaria de reservar uma mesa para duas pessoas.', 'media', NULL),
('Could you please explain this concept in more detail?', 'Você poderia explicar este conceito com mais detalhes?', 'media', NOW()),
('The juxtaposition of these contrasting ideas creates a profound philosophical dilemma.', 'A justaposição dessas ideias contrastantes cria um dilema filosófico profundo.', 'dificil', NULL);

-- Verificar se as frases foram inseridas corretamente
SELECT * FROM frases;
