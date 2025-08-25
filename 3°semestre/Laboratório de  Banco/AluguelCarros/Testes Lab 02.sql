select * from clientes
where cpf = '654.321.987-22';
select * from reservas
where id_cliente = 6;
select * from carros;
select * from reservas;
select * from sedes;
SELECT id_cliente, validade_cnh, cpf
FROM Clientes 
WHERE cpf = '654.321.987-22';


SET @mensagem = '';

CALL cadastroclienteReserva(
    '654.321.987-22',     
    'ABC1234',           
    1,                    
    1,                 
    '2025-05-14',     
    '2025-05-20',   
    @mensagem   
);

SELECT id_carro, placa, id_sede_atual FROM Carros WHERE id_carro = 1;
SELECT @mensagem;
CALL log_transferencia(1, 2); 
SELECT * FROM log_transferencias;

CALL finaliza_reserva(
    2,   
    1    
);

CALL ClientesComAtrasoDetalhado();
SELECT * FROM Historico_atrasos;


SELECT CalcularMultaEntregaOutroPonto(1, 2) AS valor_multa;
SELECT CalcularMultaEntregaOutroPonto(2, 1) AS valor_multa;
SELECT CalcularMultaEntregaOutroPonto(2, 2) AS valor_multa;

select * from reservas;
select * from carros;
select * from clientes;
select quantidade_diarias from reservas where id_cliente = 1;

SELECT dias_alugados(1) AS total_dias;

SELECT quantidade_alugueis_por_placa('ABC1234') AS total_alugueis;
SELECT quantidade_alugueis_por_placa('DEF5678') AS total_alugueis;

INSERT INTO Reservas (id_cliente, id_carro, id_sede_retirada, id_sede_devolucao, quantidade_diarias, data_locacao, data_retorno, situacao, valor_total)
VALUES (1, 6, 1, 1, 2, '2025-05-14', '2025-05-16', 'ativa', 360.00);
INSERT INTO Reservas (id_cliente, id_carro, id_sede_retirada, id_sede_devolucao, quantidade_diarias, data_locacao, data_retorno, situacao, valor_total)
VALUES (6, 8, 2, 2, 3, '2025-05-14', '2025-05-17', 'ativa', 540.00);


