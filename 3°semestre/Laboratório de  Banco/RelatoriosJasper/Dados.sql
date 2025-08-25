



INSERT INTO tipo_imovel (id, descricao) VALUES
(1, 'Apartamento'),
(2, 'Casa'),
(3, 'Sala Comercial'),
(4, 'Terreno'),
(5, 'Chácara');

--
-- Inserindo dados na tabela: clientes
--
INSERT INTO clientes (id, nome, cpf, telefone, email, dt_nascimento) VALUES
(1, 'João Silva', '111.222.333-44', '11987654321', 'joao.silva@email.com', '1980-05-15'),
(2, 'Maria Oliveira', '222.333.444-55', '21988776655', 'maria.oliveira@email.com', '1992-11-20'),
(3, 'Carlos Pereira', '333.444.555-66', '31999887766', 'carlos.pereira@email.com', '1975-01-30'),
(4, 'Ana Souza', '444.555.666-77', '41987651234', 'ana.souza@email.com', '2000-03-10'),
(5, 'Pedro Santos', '555.666.777-88', '51991234567', 'pedro.santos@email.com', '1988-07-25'),
(6, 'Juliana Costa', '666.777.888-99', '61982345678', 'juliana.costa@email.com', '1995-09-05'),
(7, 'Ricardo Lima', '777.888.999-00', '71993456789', 'ricardo.lima@email.com', '1982-12-12'),
(8, 'Fernanda Almeida', '888.999.000-11', '81984567890', 'fernanda.almeida@email.com', '1998-06-18'),
(9, 'Bruno Martins', '123.456.789-10', '11912345678', 'bruno.martins@email.com', '1990-02-28'),
(10, 'Letícia Barros', '234.567.890-12', '21923456789', 'leticia.barros@email.com', '1993-04-14'),
(11, 'Vinícius Gomes', '345.678.901-23', '31934567890', 'vinicius.gomes@email.com', '1985-10-01'),
(12, 'Gabriela Ribeiro', '456.789.012-34', '41945678901', 'gabriela.ribeiro@email.com', '2001-01-07'),
(13, 'Lucas Ferreira', '567.890.123-45', '51956789012', 'lucas.ferreira@email.com', '1989-08-19'),
(14, 'Isabela Rocha', '678.901.234-56', '61967890123', 'isabela.rocha@email.com', '1997-07-07'),
(15, 'Matheus Azevedo', '789.012.345-67', '71978901234', 'matheus.azevedo@email.com', '1994-09-23'),
(16, 'Rafael Pereira', '890.123.456-78', '81989012345', 'rafael.pereira@email.com', '1987-03-12'),
(17, 'Beatriz Santos', '901.234.567-89', '91990123456', 'beatriz.santos@email.com', '1999-10-20'),
(18, 'Gustavo Lima', '012.345.678-90', '62991234567', 'gustavo.lima@email.com', '1991-05-30');

--
-- Inserindo dados na tabela: profissionais
--
INSERT INTO profissionais (id, nome, profissao, telefone1, telefone2, valor_hora, obs) VALUES
(1, 'Marcos Andrade', 'Eletricista', '11987651111', NULL, 80.00, 'Especialista em instalações residenciais'),
(2, 'Beatriz Farias', 'Encanadora', '21988772222', '2122334455', 100.00, 'Atende emergências 24h'),
(3, 'Ronaldo Mendes', 'Pintor', '31999883333', NULL, 70.00, 'Pintura interna e externa'),
(4, 'Cláudia Dias', 'Jardineira', '41987654444', NULL, 50.00, 'Manutenção de jardins e piscinas'),
(5, 'Fábio Rocha', 'Arquiteto', '51991235555', '5133445566', 250.00, 'Projetos de reforma e decoração'),
(6, 'Vanessa Costa', 'Designer de Interiores', '11988887777', NULL, 180.00, 'Especialista em otimização de espaços pequenos.');


--
-- Inserindo dados na tabela: imoveis
--
INSERT INTO imoveis (id, id_proprietario, id_tipo_imovel, logadouro, bairro, cep, metragem, dormitorios, banheiros, suites, vagas_garagem, valor_aluguel_sugerido, obs) VALUES
(1, 1, 1, 'Rua das Flores, 123', 'Centro', '12345-001', 75, 2, 2, 1, 1, 1500.00, 'Apartamento com sacada e vista para o parque.'),
(2, 3, 2, 'Avenida Principal, 456', 'Jardim América', '23456-002', 150, 3, 3, 1, 2, 2800.00, 'Casa com piscina e área de churrasqueira.'),
(3, 1, 3, 'Rua do Comércio, 789', 'Centro', '12345-003', 40, 0, 1, 0, 0, 1200.00, 'Sala comercial em prédio com portaria 24h.'),
(4, 5, 1, 'Rua dos Pássaros, 321', 'Vila Madalena', '34567-004', 50, 1, 1, 0, 1, 1100.00, 'Apartamento mobiliado.'),
(5, 7, 2, 'Alameda dos Sonhos, 654', 'Alphaville', '45678-005', 300, 4, 5, 4, 4, 7500.00, 'Casa de alto padrão em condomínio fechado.'),
(6, 3, 1, 'Travessa da Paz, 987', 'Lapa', '56789-006', 90, 3, 2, 1, 2, 2200.00, 'Próximo à estação de metrô.'),
(7, 1, 4, 'Estrada da Terra, km 5', 'Zona Rural', '67890-007', 1000, 0, 0, 0, 0, 500.00, 'Terreno plano, ideal para construção de chácara.'),
(8, 9, 1, 'Rua da Consolação, 500', 'Consolação', '01302-000', 45, 1, 1, 0, 0, 950.00, 'Kitnet ideal para estudantes.'),
(9, 11, 2, 'Av. Atlântica, 1000', 'Copacabana', '22021-000', 200, 3, 3, 2, 2, 5500.00, 'Frente para o mar.'),
(10, 13, 1, 'Rua Augusta, 1500', 'Cerqueira César', '01412-000', 60, 2, 1, 1, 1, 1800.00, 'Perto de bares e restaurantes.'),
(11, 1, 5, 'Estrada das Capivaras, S/N', 'Itapecerica', '06850-000', 2500, 5, 4, 2, 10, 4500.00, 'Chácara com lago e pomar.'),
(12, 9, 2, 'Rua das Gaivotas, 44', 'Jardim Renascença', '65075-240', 220, 4, 4, 3, 3, 3500.00, 'Casa com área gourmet.'),
(13, 11, 1, 'Avenida dos Holandeses, 300', 'Ponta d Areia', '65077-635', 110, 3, 2, 1, 2, 2500.00, 'Apartamento com vista para o mar.'),
(14, 13, 3, 'Avenida Coronel Colares Moreira, 10', 'Calhau', '65071-322', 50, 0, 1, 0, 1, 1800.00, 'Sala em centro comercial movimentado.'),
(15, 18, 1, 'Rua Harmonia, 700', 'Vila Madalena', '05435-000', 80, 2, 2, 1, 1, 1900.00, 'Prédio novo com academia e piscina.'),
(16, 18, 2, 'Avenida Brasil, 2024', 'Jardins', '01430-000', 400, 4, 5, 4, 4, 12000.00, 'Casa de luxo com automação completa.');

--
-- Inserindo dados na tabela: servicos_imovel
--
INSERT INTO servicos_imovel (id, id_profissional, id_imovel, data_servico, valor_total, obs) VALUES
(1, 1, 1, '2024-06-10', 450.00, 'Troca do quadro de disjuntores.'),
(2, 3, 2, '2024-07-22', 2500.00, 'Pintura completa da área externa da casa.'),
(3, 2, 1, '2025-01-15', 300.00, 'Conserto de vazamento no banheiro social.'),
(4, 4, 5, '2025-03-05', 400.00, 'Manutenção mensal do jardim e limpeza da piscina.'),
(5, 5, 6, '2024-11-20', 5000.00, 'Projeto de reforma da cozinha.'),
(6, 4, 11, '2025-05-20', 600.00, 'Limpeza do terreno e poda de árvores.'),
(7, 1, 15, '2025-07-10', 800.00, 'Instalação de novas tomadas e pontos de luz.'),
(8, 6, 4, '2023-09-01', 3500.00, 'Projeto de decoração da sala e quarto.');

--
-- Inserindo dados na tabela: locacao
--
INSERT INTO locacao (id, id_imovel, id_inquilino, valor_aluguel, percentual_multa, dia_vencimento, data_inicio, data_fim, ativo, obs) VALUES
(1, 1, 2, 1500.00, 10.00, 10, '2024-01-10', '2026-07-09', true, 'LOC-01: Maria Oliveira'),
(2, 2, 4, 2800.00, 12.00, 5, '2023-05-05', '2025-11-04', true, 'Seguro fiança. Inquilino: Ana Souza'),
(3, 4, 6, 1100.00, 10.00, 15, '2024-08-15', '2026-08-14', true, 'Contrato de 24 meses. Inquilino: Juliana Costa'),
(4, 5, 8, 7500.00, 15.00, 1, '2025-02-01', '2027-01-31', true, 'Caução de 3x o valor do aluguel. Inquilino: Fernanda Almeida'),
(5, 6, 5, 2100.00, 10.00, 20, '2022-03-20', '2024-09-19', false, 'Contrato finalizado. Chaves devolvidas. Inquilino: Pedro Santos'),
(6, 8, 10, 950.00, 10.00, 25, '2025-01-25', '2026-01-24', true, 'Aluguel de Kitnet. Inquilino: Letícia Barros'),
(7, 9, 12, 5500.00, 10.00, 10, '2025-03-10', '2027-09-09', true, 'Aluguel de casa de praia. Inquilino: Gabriela Ribeiro'),
(8, 10, 14, 1800.00, 10.00, 5, '2024-10-05', '2026-10-04', true, 'Aluguel de apartamento. Inquilino: Isabela Rocha'),
(9, 11, 15, 4500.00, 15.00, 15, '2025-06-15', '2026-06-14', true, 'Aluguel de chácara para eventos. Inquilino: Matheus Azevedo'),
(10, 3, 2, 1200.00, 10.00, 20, '2025-08-20', '2027-08-19', true, 'LOC-02: Maria Oliveira (sala comercial).'),
(11, 12, 2, 3500.00, 10.00, 15, '2023-01-15', '2024-07-14', false, 'LOC-03: Maria Oliveira (contrato inativo).'),
(12, 13, 2, 2500.00, 10.00, 1, '2025-09-01', '2027-08-31', true, 'LOC-04: Maria Oliveira (início futuro).'),
(13, 14, 2, 1800.00, 12.00, 5, '2022-02-05', '2023-01-31', false, 'LOC-05: Maria Oliveira (contrato antigo inativo).'),
(14, 15, 16, 1900.00, 10.00, 10, '2023-02-10', '2024-02-09', false, 'Contrato de 12 meses finalizado. Inquilino: Rafael Pereira'),
(15, 16, 17, 12000.00, 15.00, 1, '2024-03-01', '2027-02-28', true, 'Contrato de alto padrão. Inquilino: Beatriz Santos');

--
-- Inserindo dados na tabela: alugueis
--
INSERT INTO alugueis (id, id_locacao, data_vencimento, valor_pago, data_pagamento, obs) VALUES
-- Pagamentos em 2022
(1, 13, '2022-12-05', 1800.00, '2022-12-05', 'Pagamento OK - Maria Oliveira'),
(2, 5, '2022-11-20', 2100.00, '2022-11-20', 'Pagamento OK - Pedro Santos'),

-- Pagamentos em 2023 (VOLUME AUMENTADO)
(3, 13, '2023-01-05', 1800.00, '2023-01-04', 'Pagamento OK - Maria Oliveira'),
(4, 11, '2023-10-15', 3500.00, '2023-10-15', 'Pagamento OK - Maria Oliveira'),
(5, 11, '2023-11-15', 3500.00, '2023-11-14', 'Pagamento OK - Maria Oliveira'),
(6, 2, '2023-06-05', 2800.00, '2023-06-05', 'Pagamento OK - Ana Souza'),
(7, 2, '2023-07-05', 2800.00, '2023-07-06', 'Pagamento OK - Ana Souza'),
(8, 2, '2023-08-05', 3136.00, '2023-08-10', 'Pagamento com multa - Ana Souza'),
(9, 14, '2023-03-10', 1900.00, '2023-03-10', 'Pagamento OK - Rafael Pereira'),
(10, 14, '2023-04-10', 1900.00, '2023-04-09', 'Pagamento OK - Rafael Pereira'),
(11, 14, '2023-05-10', 1900.00, '2023-05-10', 'Pagamento OK - Rafael Pereira'),
(12, 5, '2023-01-20', 2100.00, '2023-01-20', 'Pagamento OK - Pedro Santos'),

-- Pagamentos em 2024
(13, 1, '2024-05-10', 1500.00, '2024-05-09', 'Pagamento OK - Inquilino 2 (Maria)'),
(14, 1, '2024-06-10', 1500.00, '2024-06-10', 'Pagamento OK - Inquilino 2 (Maria)'),
(15, 2, '2024-10-05', 2800.00, '2024-10-02', 'Pagamento OK - Inquilino 4'),
(16, 2, '2024-11-05', 2800.00, '2024-11-05', 'Pagamento OK - Inquilino 4'),
(17, 3, '2024-11-15', 1100.00, '2024-11-14', 'Pagamento OK - Inquilino 6'),
(18, 5, '2024-01-20', 2100.00, '2024-01-20', 'Pagamento OK - Inquilino 5'),
(19, 8, '2024-11-05', 1800.00, '2024-11-05', 'Pagamento OK - Inquilino 14'),
(20, 8, '2024-12-05', 1800.00, '2024-12-03', 'Pagamento OK - Inquilino 14'),
(21, 11, '2024-01-15', 3500.00, '2024-01-15', 'Pagamento OK - Maria Oliveira'),
(22, 15, '2024-04-01', 12000.00, '2024-04-01', 'Pagamento OK - Beatriz Santos'),
(23, 15, '2024-05-01', 12000.00, '2024-05-01', 'Pagamento OK - Beatriz Santos'),

-- Pagamentos em 2025
(24, 2, '2025-01-05', 2800.00, '2025-01-05', 'Pagamento OK - Inquilino 4'),
(25, 2, '2025-02-05', 3136.00, '2025-02-10', 'Pago com multa - Inquilino 4'),
(26, 3, '2025-01-15', 1100.00, '2025-01-15', 'Pagamento OK - Inquilino 6'),
(27, 4, '2025-03-01', 7500.00, '2025-02-28', 'Pagamento OK - Inquilino 8'),
(28, 6, '2025-02-25', 950.00, '2025-02-25', 'Pagamento OK - Inquilino 10'),
(29, 7, '2025-04-10', 5500.00, '2025-04-10', 'Pagamento OK - Inquilino 12'),
(30, 8, '2025-01-05', 1800.00, '2025-01-05', 'Pagamento OK - Inquilino 14'),
(31, 9, '2025-07-15', 4500.00, '2025-07-15', 'Pagamento OK - Inquilino 15'),
(32, 10, '2025-09-20', 1200.00, '2025-09-20', 'Pagamento OK - Maria Oliveira'),
(33, 12, '2025-10-01', 2500.00, '2025-09-30', 'Pagamento OK - Maria Oliveira'),
(34, 15, '2025-07-01', 12000.00, '2025-07-01', 'Pagamento OK - Beatriz Santos');



INSERT INTO imoveis (id, id_proprietario, id_tipo_imovel, logadouro, bairro, cep, metragem, dormitorios, banheiros, suites, vagas_garagem, valor_aluguel_sugerido, obs) VALUES
(99, 1, 3, 'Rua dos Armazéns, 50', 'Distrito Industrial', '65000-100', 20, 0, 0, 0, 0, 800.00, 'Pequeno depósito para armazenamento.');

INSERT INTO locacao (id, id_imovel, id_inquilino, valor_aluguel, percentual_multa, dia_vencimento, data_inicio, data_fim, ativo, obs) VALUES
(98, 99, 2, 800.00, 10.00, 25, '2024-02-25', '2025-02-24', true, 'LOC-06: Maria Oliveira (Depósito < R$1000)');

INSERT INTO alugueis (id, id_locacao, data_vencimento, valor_pago, data_pagamento, obs) VALUES
(95, 98, '2024-03-25', 800.00, '2024-03-25', 'Pagamento OK - Depósito Maria Oliveira'),
(96, 98, '2024-04-25', 800.00, '2024-04-24', 'Pagamento OK - Depósito Maria Oliveira'),
(97, 98, '2024-05-25', 880.00, '2024-05-30', 'Pago com multa - Depósito Maria Oliveira'),
(98, 98, '2024-06-25', 800.00, '2024-06-25', 'Pagamento OK - Depósito Maria Oliveira');

INSERT INTO imoveis (id, id_proprietario, id_tipo_imovel, logadouro, bairro, cep, metragem, dormitorios, banheiros, suites, vagas_garagem, valor_aluguel_sugerido, obs) VALUES
(17, 1, 3, 'Rua dos Armazéns, 50', 'Distrito Industrial', '65000-100', 20, 0, 0, 0, 0, 800.00, 'Pequeno depósito para armazenamento.');

INSERT INTO locacao (id, id_imovel, id_inquilino, valor_aluguel, percentual_multa, dia_vencimento, data_inicio, data_fim, ativo, obs) VALUES
(16, 17, 2, 800.00, 10.00, 25, '2024-02-25', '2025-02-24', true, 'LOC-06: Maria Oliveira (Depósito < R$1000)');


INSERT INTO alugueis (id, id_locacao, data_vencimento, valor_pago, data_pagamento, obs) VALUES
(35, 16, '2024-03-25', 800.00, '2024-03-25', 'Pagamento OK - Depósito Maria Oliveira');



