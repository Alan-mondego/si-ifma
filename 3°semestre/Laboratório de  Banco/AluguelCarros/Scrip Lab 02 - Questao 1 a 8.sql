DROP DATABASE IF EXISTS aluguelCarros;
CREATE DATABASE aluguelCarros;
USE aluguelCarros;

CREATE TABLE Sedes (
    id_sede INT PRIMARY KEY AUTO_INCREMENT,
    nome_sede VARCHAR(100) NOT NULL,
    endereco VARCHAR(200) NOT NULL,
    telefone VARCHAR(20),
    nome_gerente VARCHAR(100),
    multa_entrega_outro_ponto DECIMAL(10,2) NOT NULL DEFAULT 150.00
);

CREATE TABLE Classes_de_Carro (
    id_classe INT PRIMARY KEY AUTO_INCREMENT,
    nome_classe ENUM('subcompacto', 'tamanho médio', 'grande', 'luxo') NOT NULL,
    valor_diaria DECIMAL(10,2) NOT NULL,
    descricao TEXT
);

CREATE TABLE Carros (
    id_carro INT PRIMARY KEY AUTO_INCREMENT,
    placa VARCHAR(10) NOT NULL UNIQUE,
    modelo VARCHAR(100) NOT NULL,
    ano INT NOT NULL,
    cor VARCHAR(30),
    quilometragem INT DEFAULT 0,
    descricao TEXT,
    situacao ENUM('disponível', 'alugado', 'fora do ponto de origem', 'em manutenção') NOT NULL DEFAULT 'disponível',
    id_classe INT NOT NULL,
    id_sede_origem INT NOT NULL,
    id_sede_atual INT,
    FOREIGN KEY (id_classe) REFERENCES Classes_de_Carro(id_classe),
    FOREIGN KEY (id_sede_origem) REFERENCES Sedes(id_sede),
    FOREIGN KEY (id_sede_atual) REFERENCES Sedes(id_sede),
    CHECK (situacao != 'alugado' OR id_sede_atual IS NULL)
);

CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    numero_cnh VARCHAR(20) NOT NULL UNIQUE,
    validade_cnh DATE NOT NULL,
    categoria_cnh VARCHAR(5) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100),
    status ENUM('ativo', 'suspenso') NOT NULL DEFAULT 'ativo',
    CHECK (categoria_cnh IN ('A', 'B', 'AB', 'C', 'D', 'E'))
);

CREATE TABLE Reservas (
    id_reserva INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_carro INT NOT NULL,
    id_sede_retirada INT NOT NULL,
    id_sede_devolucao INT NOT NULL,
    quantidade_diarias INT NOT NULL,
    data_locacao DATE NOT NULL,
    data_retorno DATE NOT NULL,
    quilometragem_inicial INT,
    quilometragem_final INT,
    multa DECIMAL(10,2) DEFAULT 0.00,
    situacao ENUM('ativa', 'atrasada', 'finalizada', 'cancelada') NOT NULL,
    valor_total DECIMAL(10,2),
    data_hora_retirada DATETIME,
    data_hora_devolucao DATETIME,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_carro) REFERENCES Carros(id_carro),
    FOREIGN KEY (id_sede_retirada) REFERENCES Sedes(id_sede),
    FOREIGN KEY (id_sede_devolucao) REFERENCES Sedes(id_sede),
    CHECK (data_retorno > data_locacao)
);

CREATE TABLE IF NOT EXISTS log_transferencias (
    id_log INT PRIMARY KEY AUTO_INCREMENT,
    id_carro INT NOT NULL,
    sede_origem INT NOT NULL,
    sede_destino INT NOT NULL,
    data_transferencia DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_carro) REFERENCES Carros(id_carro),
    FOREIGN KEY (sede_origem) REFERENCES Sedes(id_sede),
    FOREIGN KEY (sede_destino) REFERENCES Sedes(id_sede)
);

CREATE TABLE Historico_atrasos (
    id_historico INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_reserva INT NOT NULL,
    dias_atraso INT NOT NULL,
    data_devolucao_real DATETIME NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_reserva) REFERENCES Reservas(id_reserva)
);

-- Questão 1
DELIMITER $$
CREATE PROCEDURE cadastroclienteReserva (
    IN cpf_cliente VARCHAR(14),
    IN placa_carro VARCHAR(10),
    IN sede_retirada INT,
    IN sede_devolucao INT,
    IN data_locacao DATE,
    IN data_retorno DATE,
    OUT mensagem_saida VARCHAR(100)
)
BEGIN
    DECLARE cliente_id INT;
    DECLARE cnh_validade DATE;
    DECLARE cliente_status VARCHAR(20);
    DECLARE carro_id INT;
    DECLARE carro_situacao VARCHAR(20);
    DECLARE diaria_valor DECIMAL(10,2);
    DECLARE quantidade_dias INT;
    DECLARE valor_total_reserva DECIMAL(10,2);
    DECLARE cliente_reservas_ativas INT;
    DECLARE carro_reservado INT;
    DECLARE mensagem_erro VARCHAR(255);

    -- Verificação do cliente
    SELECT id_cliente, validade_cnh, status 
    INTO cliente_id, cnh_validade, cliente_status
    FROM Clientes
    WHERE REPLACE(REPLACE(cpf, '.', ''), '-', '') = 
          REPLACE(REPLACE(cpf_cliente, '.', ''), '-', '');

    IF cliente_id IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Cliente não encontrado. Verifique o CPF informado.';
    END IF;

    IF cliente_status = 'suspenso' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Cliente suspenso. Não é possível realizar reservas.';
    END IF;

    IF cnh_validade <= CURDATE() THEN
        SET mensagem_erro = CONCAT('CNH vencida em ', DATE_FORMAT(cnh_validade, '%d/%m/%Y'), 
                                '. Não é possível realizar reservas com CNH vencida.');
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = mensagem_erro;
    END IF;

    SELECT COUNT(*) INTO cliente_reservas_ativas
    FROM Reservas
    WHERE id_cliente = cliente_id AND situacao = 'ativa';

    IF cliente_reservas_ativas > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Cliente já possui uma reserva ativa. Não é permitido múltiplas reservas.';
    END IF;

    -- Verificação do carro
    SELECT c.id_carro, c.situacao, cl.valor_diaria 
    INTO carro_id, carro_situacao, diaria_valor
    FROM Carros c
    JOIN Classes_de_Carro cl ON c.id_classe = cl.id_classe
    WHERE c.placa = placa_carro;

    IF carro_id IS NULL THEN
        SET mensagem_erro = CONCAT('Carro com placa ', placa_carro, ' não encontrado.');
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = mensagem_erro;
    END IF;

    IF carro_situacao != 'disponível' THEN
        SET mensagem_erro = CONCAT('Carro não está disponível. Situação atual: ', carro_situacao);
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = mensagem_erro;
    END IF;

    SET quantidade_dias = DATEDIFF(data_retorno, data_locacao);
    SET valor_total_reserva = quantidade_dias * diaria_valor;

    INSERT INTO Reservas (
        id_cliente,
        id_carro,
        id_sede_retirada,
        id_sede_devolucao,
        quantidade_diarias,
        data_locacao,
        data_retorno,
        situacao,
        valor_total
    ) VALUES (
        cliente_id,
        carro_id,
        sede_retirada,
        sede_devolucao,
        quantidade_dias,
        data_locacao,
        data_retorno,
        'ativa',
        valor_total_reserva
    );

    UPDATE Carros SET situacao = 'alugado' WHERE id_carro = carro_id;

    SET mensagem_saida = CONCAT('Reserva registrada com sucesso. ID: ', LAST_INSERT_ID(), 
                                ', Valor Total: R$ ', FORMAT(valor_total_reserva, 2));
END$$
DELIMITER ;

-- Questão 2
DELIMITER $$
CREATE PROCEDURE log_transferencia(
    IN carro_id INT,
    IN sede_destino INT
)
BEGIN
    DECLARE sede_origem INT;

    IF NOT EXISTS (SELECT 1 FROM Carros WHERE id_carro = carro_id) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Carro não encontrado.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM Sedes WHERE id_sede = sede_destino) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Sede de destino não encontrada.';
    END IF;

    SELECT id_sede_atual INTO sede_origem 
    FROM Carros 
    WHERE id_carro = carro_id;

    INSERT INTO log_transferencias (id_carro, sede_origem, sede_destino)
    VALUES (carro_id, sede_origem, sede_destino);

    UPDATE Carros 
    SET id_sede_atual = sede_destino 
    WHERE id_carro = carro_id;

    UPDATE Carros 
    SET situacao = 'disponível' 
    WHERE id_carro = carro_id AND situacao = 'em manutenção';
END$$
DELIMITER ;

-- Questão 3
DELIMITER $$
CREATE PROCEDURE finaliza_reserva(
    IN reserva_id INT,
    IN sede_devolucao INT
)
BEGIN
    DECLARE carro_id INT;
    DECLARE reserva_situacao VARCHAR(20);
    DECLARE quilometragem_final_reserva INT;

    SELECT id_carro, situacao, quilometragem_final
    INTO carro_id, reserva_situacao, quilometragem_final_reserva
    FROM Reservas 
    WHERE id_reserva = reserva_id;

    IF carro_id IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Reserva não encontrada.';
    END IF;

    IF reserva_situacao = 'finalizada' OR reserva_situacao = 'cancelada' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Reserva já está finalizada ou cancelada.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM Sedes WHERE id_sede = sede_devolucao) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Sede de devolução não encontrada.';
    END IF;

    UPDATE Reservas 
    SET 
        situacao = 'finalizada',
        id_sede_devolucao = sede_devolucao,
        data_hora_devolucao = NOW()
    WHERE id_reserva = reserva_id;

    UPDATE Carros 
    SET 
        situacao = 'disponível',
        id_sede_atual = sede_devolucao,
        quilometragem = quilometragem_final_reserva
    WHERE id_carro = carro_id;

    SELECT 'Reserva finalizada com sucesso.' AS mensagem;
END$$
DELIMITER ;

-- Questão 4
DELIMITER $$
CREATE PROCEDURE ClientesComAtrasoDetalhado()
BEGIN
    DECLARE fim_cursor INT DEFAULT FALSE;
    DECLARE cliente_id INT;
    DECLARE reserva_id INT;
    DECLARE data_prevista DATE;
    DECLARE data_real DATETIME;
    DECLARE dias_atraso INT;

    DECLARE cursor_atrasos CURSOR FOR
        SELECT id_cliente, id_reserva, data_retorno, data_hora_devolucao
        FROM Reservas
        WHERE 
            (data_hora_devolucao IS NOT NULL AND data_hora_devolucao > data_retorno)
            OR
            (data_hora_devolucao IS NULL AND data_retorno < CURDATE());

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fim_cursor = TRUE;

    OPEN cursor_atrasos;

    leitura: LOOP
        FETCH cursor_atrasos INTO cliente_id, reserva_id, data_prevista, data_real;
        IF fim_cursor THEN
            LEAVE leitura;
        END IF;

        IF data_real IS NOT NULL THEN
            SET dias_atraso = DATEDIFF(data_real, data_prevista);
        ELSE
            SET dias_atraso = DATEDIFF(CURDATE(), data_prevista);
            SET data_real = NOW();
        END IF;

        IF dias_atraso > 0 THEN
            INSERT INTO Historico_atrasos (id_cliente, id_reserva, dias_atraso, data_devolucao_real)
            VALUES (cliente_id, reserva_id, dias_atraso, data_real);
        END IF;

    END LOOP;

    CLOSE cursor_atrasos;
END$$
DELIMITER ;

-- Questão 5
DELIMITER $$
CREATE FUNCTION CalcularMultaEntregaOutroPonto(
    sede_origem INT,
    sede_devolucao INT
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE valor_multa DECIMAL(10,2);

    IF sede_origem = sede_devolucao THEN
        RETURN 0.00;
    ELSE
        SELECT multa_entrega_outro_ponto
        INTO valor_multa
        FROM Sedes
        WHERE id_sede = sede_devolucao;

        RETURN valor_multa;
    END IF;
END$$
DELIMITER ;

-- Questão 6
DELIMITER $$
CREATE FUNCTION dias_alugados(
    cliente_id INT
)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_dias INT DEFAULT 0;

    SELECT SUM(quantidade_diarias)
    INTO total_dias
    FROM Reservas
    WHERE id_cliente = cliente_id;

    RETURN IFNULL(total_dias, 0);
END$$
DELIMITER ;

-- Questão 7
DELIMITER $$
CREATE FUNCTION quantidade_alugueis_por_placa(
    placa VARCHAR(10)
)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE carro_id INT;
    DECLARE total_reservas INT DEFAULT 0;

    SELECT id_carro INTO carro_id
    FROM Carros
    WHERE placa = placa;

    SELECT COUNT(*) INTO total_reservas
    FROM Reservas
    WHERE id_carro = carro_id;

    RETURN total_reservas;
END$$
DELIMITER ;

-- Questão 8 -- Este trigger foi comentado para não barrar a inserção de dados abaixo, se testar, teste com cuidado
/*
DELIMITER //
CREATE TRIGGER valida_reserva_completa
BEFORE INSERT ON Reservas
FOR EACH ROW
BEGIN
    DECLARE validade_cnh_cliente DATE;
    DECLARE status_cliente VARCHAR(10);
    DECLARE reservas_em_aberto INT;

    SELECT validade_cnh, status INTO validade_cnh_cliente, status_cliente
    FROM Clientes
    WHERE id_cliente = NEW.id_cliente;

    IF validade_cnh_cliente <= CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'CNH vencida. Não é possível criar a reserva.';
    END IF;

    IF status_cliente = 'suspenso' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cliente suspenso. Não é possível criar reserva.';
    END IF;

    SELECT COUNT(*) INTO reservas_em_aberto
    FROM Reservas
    WHERE id_cliente = NEW.id_cliente
      AND situacao IN ('ativa', 'atrasada');

    IF reservas_em_aberto > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cliente já possui uma reserva ativa ou atrasada.';
    END IF;

    IF NEW.situacao = 'ativa' AND (NEW.data_locacao > CURDATE() OR NEW.data_retorno < CURDATE()) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Uma reserva ativa deve incluir a data atual em seu período.';
    END IF;

END;
//
DELIMITER ;
*/
-- TABELA SEDES (apenas 2 sedes)
INSERT INTO Sedes (id_sede, nome_sede, endereco, telefone, nome_gerente, multa_entrega_outro_ponto) VALUES
(1, 'Sede Centro', 'Rua Principal, 100 - Centro', '(11) 2222-3333', 'Carlos Silva', 150.00),
(2, 'Sede Zona Sul', 'Av. Secundária, 200 - Zona Sul', '(11) 4444-5555', 'Ana Oliveira', 200.00);

-- TABELA CLASSES_DE_CARRO (mantida igual)
INSERT INTO Classes_de_Carro (id_classe, nome_classe, valor_diaria, descricao) VALUES
(1, 'subcompacto', 120.00, 'Carros compactos e econômicos'),
(2, 'tamanho médio', 180.00, 'Carros com espaço intermediário'),
(3, 'grande', 250.00, 'Carros grandes e espaçosos'),
(4, 'luxo', 400.00, 'Carros de luxo e alta performance');

-- TABELA CARROS (ajustando todas as sedes para 1 ou 2)
INSERT INTO Carros (id_carro, placa, modelo, ano, cor, quilometragem, descricao, situacao, id_classe, id_sede_origem, id_sede_atual) VALUES
(1, 'ABC1234', 'Fiat Mobi', 2022, 'Vermelho', 15000, 'Subcompacto econômico', 'disponível', 1, 1, 1),
(2, 'DEF5678', 'Volkswagen Nivus', 2023, 'Preto', 8000, 'SUV médio com teto solar', 'disponível', 3, 2, 2),
(3, 'GHI9012', 'Toyota Corolla', 2023, 'Prata', 5000, 'Sedã médio completo', 'disponível', 2, 1, 1),
(4, 'JKL3456', 'BMW 320i', 2023, 'Branco', 3000, 'Sedã de luxo', 'disponível', 4, 2, 2),
(5, 'MNO7890', 'Renault Kwid', 2021, 'Branco', 20000, 'Compacto e econômico', 'disponível', 1, 1, 1),
(6, 'PQR1234', 'Honda Fit', 2020, 'Prata', 25000, 'Minivan urbana', 'disponível', 2, 2, 2),
(7, 'STU5678', 'Hyundai Creta', 2022, 'Preto', 12000, 'SUV compacto moderno', 'disponível', 3, 1, 1),
(8, 'VWX9012', 'Chevrolet S10', 2023, 'Cinza', 7000, 'Picape robusta', 'disponível', 3, 2, 2),
(9, 'YZA3456', 'Tesla Model 3', 2024, 'Azul', 3000, 'Elétrico de luxo', 'disponível', 4, 1, 1),
(10, 'BCD7890', 'Audi A3', 2022, 'Vermelho', 8000, 'Compacto premium', 'disponível', 4, 2, 2),
(11, 'EFG1234', 'Jeep Renegade', 2023, 'Verde', 10000, 'Off-road urbano', 'disponível', 3, 1, 1),
(12, 'HIJ5678', 'Nissan Leaf', 2021, 'Branco', 15000, '100% elétrico', 'disponível', 4, 2, 2),
(13, 'KLM9012', 'Porsche 911', 2023, 'Amarelo', 2000, 'Esportivo de luxo', 'disponível', 4, 1, 1),
(14, 'NOP3456', 'Ford EcoSport', 2020, 'Preto', 30000, 'SUV compacto', 'disponível', 3, 2, 2),
(15, 'QRS6789', 'Toyota Hilux', 2022, 'Preto', 14000, 'Picape cabine dupla', 'disponível', 3, 1, 1),
(16, 'TUV0123', 'Chevrolet Onix', 2023, 'Prata', 10000, 'Compacto econômico', 'disponível', 1, 2, 2),
(17, 'WXY4567', 'Mercedes-Benz CLA', 2023, 'Branco', 5000, 'Sedã executivo', 'disponível', 4, 1, 1),
(18, 'ZAB7890', 'Ford Fusion Hybrid', 2020, 'Cinza', 20000, 'Sedã híbrido', 'disponível', 2, 2, 2),
(19, 'CDE1234', 'Honda Civic', 2021, 'Vermelho', 17000, 'Sedã médio', 'disponível', 2, 1, 1),
(20, 'FGH5678', 'Land Rover Discovery', 2023, 'Verde', 6000, 'SUV grande de luxo', 'disponível', 4, 2, 2);

-- TABELA CLIENTES (mantida igual)
INSERT INTO Clientes (id_cliente, nome, cpf, numero_cnh, validade_cnh, categoria_cnh, telefone, email, status) VALUES
(1, 'João Silva', '123.456.789-01', 'CNH12345678', '2024-05-01', 'AB', '(11) 98765-4321', 'joao.silva@email.com', 'ativo'),
(2, 'Maria Oliveira', '987.654.321-09', 'CNH87654321', '2028-06-30', 'B', '(21) 99876-5432', 'maria.oliveira@email.com', 'ativo'),
(3, 'Pedro Martins', '321.654.987-00', 'CNH00112233', '2029-11-15', 'AB', '(31) 91234-5678', 'pedro.martins@email.com', 'ativo'),
(4, 'Aline Souza', '456.789.123-55', 'CNH22334455', '2023-02-10', 'B', '(21) 93456-7890', 'aline.souza@email.com', 'suspenso'),
(5, 'Carlos Mendes', '789.123.456-66', 'CNH33445566', '2031-03-10', 'AB', '(61) 94567-8901', 'carlos.mendes@email.com', 'ativo'),
(6, 'Fernanda Lima', '654.321.987-22', 'CNH44556677', '2026-08-30', 'B', '(71) 95678-9012', 'fernanda.lima@email.com', 'ativo'),
(7, 'Thiago Rocha', '111.222.333-44', 'CNH55667788', '2030-01-01', 'AB', '(81) 96789-0123', 'thiago.rocha@email.com', 'ativo'),
(8, 'Juliana Costa', '222.333.444-55', 'CNH66778899', '2028-09-09', 'B', '(91) 97890-1234', 'juliana.costa@email.com', 'ativo'),
(9, 'Ricardo Silva', '333.444.555-66', 'CNH77889900', '2029-07-07', 'AB', '(51) 98901-2345', 'ricardo.silva@email.com', 'ativo'),
(10, 'Luciana Andrade', '444.555.666-77', 'CNH88990011', '2032-12-12', 'B', '(11) 99012-3456', 'luciana.andrade@email.com', 'ativo'),
(11, 'Bruno Nogueira', '555.666.777-88', 'CNH99001122', '2031-04-04', 'AB', '(61) 90123-4567', 'bruno.nogueira@email.com', 'ativo'),
(12, 'Patrícia Moreira', '666.777.888-99', 'CNH10111213', '2027-06-06', 'B', '(31) 91234-5670', 'patricia.moreira@email.com', 'ativo'),
(13, 'Renato Dias', '111.333.555-77', 'CNH13141516', '2030-10-10', 'AB', '(11) 92345-6789', 'renato.dias@email.com', 'ativo'),
(14, 'Carla Bezerra', '222.444.666-88', 'CNH14151617', '2029-12-12', 'B', '(21) 93456-7891', 'carla.bezerra@email.com', 'ativo'),
(15, 'Eduardo Souza', '333.555.777-99', 'CNH15161718', '2028-03-03', 'AB', '(31) 94567-8902', 'eduardo.souza@email.com', 'ativo'),
(16, 'Vanessa Torres', '444.666.888-00', 'CNH16171819', '2031-09-09', 'B', '(41) 95678-9013', 'vanessa.torres@email.com', 'ativo'),
(17, 'Rafael Almeida', '555.777.999-11', 'CNH17181920', '2027-11-11', 'AB', '(51) 96789-0124', 'rafael.almeida@email.com', 'ativo'),
(18, 'Camila Lopes', '666.888.000-22', 'CNH18192021', '2032-07-07', 'B', '(61) 97890-1235', 'camila.lopes@email.com', 'ativo'),
(19, 'Marcelo Farias', '777.999.111-33', 'CNH19202122', '2029-08-08', 'AB', '(71) 98901-2346', 'marcelo.farias@email.com', 'ativo'),
(20, 'Beatriz Monteiro', '888.000.222-44', 'CNH20212223', '2030-06-06', 'B', '(81) 99012-3457', 'beatriz.monteiro@email.com', 'ativo');

-- TABELA RESERVAS (ajustando sedes para 1 ou 2)
INSERT INTO Reservas (id_reserva, id_cliente, id_carro, id_sede_retirada, id_sede_devolucao, quantidade_diarias, data_locacao, data_retorno, situacao, valor_total, data_hora_retirada, data_hora_devolucao) VALUES
(1, 1, 3, 1, 2, 4, '2025-04-25', '2025-04-29', 'finalizada', 720.00, '2025-04-25 09:00:00', '2025-04-29 10:00:00'),
(2, 2, 5, 2, 2, 2, '2025-05-02', '2025-05-04', 'ativa', 240.00, '2025-05-02 08:00:00', NULL),
(3, 3, 1, 1, 1, 5, '2025-04-30', '2025-05-05', 'atrasada', 600.00, '2025-04-30 09:30:00', '2025-05-06 11:00:00'),
(4, 4, 4, 1, 2, 1, '2025-05-05', '2025-05-06', 'ativa', 400.00, '2025-05-05 10:00:00', NULL),
(5, 5, 2, 2, 2, 6, '2025-05-01', '2025-05-07', 'cancelada', 0.00, NULL, NULL),
(6, 6, 3, 2, 1, 3, '2025-05-10', '2025-05-13', 'ativa', 540.00, '2025-05-10 09:00:00', NULL),
(7, 7, 5, 1, 1, 4, '2025-04-28', '2025-05-01', 'finalizada', 480.00, '2025-04-28 09:00:00', '2025-05-01 08:30:00'),
(8, 8, 1, 2, 1, 7, '2025-04-20', '2025-04-27', 'finalizada', 840.00, '2025-04-20 08:00:00', '2025-04-27 09:00:00'),
(9, 9, 2, 1, 2, 2, '2025-05-08', '2025-05-10', 'ativa', 440.00, '2025-05-08 09:30:00', NULL),
(10, 10, 4, 2, 1, 5, '2025-04-26', '2025-05-01', 'atrasada', 2000.00, '2025-04-26 08:00:00', '2025-05-03 10:00:00'),
(11, 11, 2, 1, 1, 1, '2025-05-11', '2025-05-12', 'ativa', 220.00, '2025-05-11 08:00:00', NULL),
(12, 12, 1, 1, 1, 2, '2025-05-02', '2025-05-04', 'cancelada', 0.00, NULL, NULL),
(13, 13, 5, 2, 2, 6, '2025-04-22', '2025-04-28', 'finalizada', 720.00, '2025-04-22 09:00:00', '2025-04-28 10:00:00'),
(14, 14, 2, 2, 2, 3, '2025-05-13', '2025-05-16', 'ativa', 660.00, '2025-05-13 08:00:00', NULL),
(15, 15, 4, 1, 2, 4, '2025-05-07', '2025-05-11', 'atrasada', 1600.00, '2025-05-07 09:00:00', '2025-05-13 10:00:00'),
(16, 1, 3, 1, 1, 5, '2025-05-10', '2025-05-15', 'finalizada', 600.00, '2025-05-10 08:00:00', '2025-05-15 09:00:00'),
(17, 1, 4, 1, 1, 4, '2025-05-20', '2025-05-24', 'finalizada', 1600.00, '2025-05-20 09:00:00', '2025-05-24 10:00:00');
