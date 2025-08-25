

create database imovel;

use imovel; 	

create table tipo_imovel(
  id integer primary key, 
  descricao varchar(256)

);

create table imoveis(
  id integer primary key,
  id_proprietario integer,  
  id_tipo_imovel integer,
  logadouro varchar(200), 
  bairro varchar(45),
  cep varchar(10), 
  metragem integer, 
  dormitorios tinyint, 
  banheiros tinyint, 
  suites tinyint, 
  vagas_garagem tinyint, 
  valor_aluguel_sugerido decimal(10,2),
  obs text,
  foreign key (id_proprietario) references clientes(id),
  foreign key (id_tipo_imovel) references tipo_imovel(id)
);


create table servicos_imovel(

  id integer primary key,
  id_profissional integer,  
  id_imovel integer,
  data_servico date,
  valor_total decimal(10,2),
  obs text,
  foreign key (id_profissional) references profissionais(id),
  foreign key (id_imovel) references imoveis(id)

);


create table profissionais(
id integer primary key, 
nome varchar(45),
profissao varchar (45),
telefone1 varchar(12),
telefone2 varchar(12),
valor_hora decimal(10,2),
obs text
);
 
 create table clientes(
  id integer primary key,
  nome varchar(45) ,
  cpf varchar(15),
  telefone varchar(12),
  email varchar(100),
  dt_nascimento date );
  
  
  create table locacao(
  
   id integer primary key,
   id_imovel integer, 
   id_inquilino integer, 
   valor_aluguel decimal(10,4),
   percentual_multa decimal(5,2),
   dia_vencimento tinyint , 
   data_inicio date, 
   data_fim date,
   ativo boolean , 
   obs text,
   foreign key (id_imovel) references imoveis(id),
  foreign key (id_inquilino) references clientes(id)


  );
  
  create table alugueis(
   id integer primary key,
   id_locacao integer , 
   data_vencimento date , 
   valor_pago decimal(10,2),
   data_pagamento date, 
   obs text ,
   foreign key (id_locacao) references locacao(id)
  );
  

