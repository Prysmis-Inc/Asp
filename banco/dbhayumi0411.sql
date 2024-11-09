create database DBHayumi;
use DBHayumi;

create table tbEstado(
UFId int primary key auto_increment,
UF char(2) not null
);

create table tbCidade(
CidadeId int primary key auto_increment,
Cidade varchar(200) not null
);

create table tbBairro(
BairroId int primary key auto_increment,
Bairro varchar(200) not null
);


create table tbEndereco(
CEP decimal (8,0) primary key,
BairroId int not null,
CidadeId int not null,
UFId int not null,
foreign key (BairroId) references tbBairro (BairroId),
foreign key (CidadeId) references tbCidade (CidadeId),
foreign key (UFId) references tbEstado (UFId)
);

create table tbCliente(
ClienteId int primary key auto_increment,
NomeCli varchar(100) not null,
CPF decimal(11) not null unique,
Email varchar (100) not null,
SenhaUsu varchar (50) not null,
DataNasc date not null,
telefone bigint not null,
NumEnd smallint not null,
CompEnd varchar (50) not null,
CEP decimal(8,0) not null,
cliente_status boolean null default 0,
foreign key (CEP) references tbEndereco (CEP)
);

create table tbLogin (
LoginId int primary key auto_increment,      
Email VARCHAR(100) not null unique,          
SenhaUsu VARCHAR(50) not null,                
Cliente_Status boolean null default 0,              
ClienteId int not null,                       
foreign key (ClienteId) references tbCliente (ClienteId) -- Referência à tabela tbCliente
);

create table tbCategoria(
 categoriaid int primary key auto_increment,
 nomecategoria varchar(150) not null,
 img_categoria varchar(255)
);

create table tbPeca(
PecaId int primary key auto_increment,
NomePeca varchar(100) not null,
ValorPeca decimal(8,2) not null,
img_peca varchar (255) not null,
descricao varchar (200) not null,
qtd_estoque int not null,
categoriaid int not null,
Foreign key (categoriaid) references tbCategoria(Categoriaid)
); 

create table tbCarrinhoCompra(
CarrinhoId int primary key auto_increment,
ProdutosSelecionados varchar(200) not null,
QtdPeca int not null,
ValorTotalCompra decimal(8,2) not null,
ClienteId int not null,
PecaId int not null,
Foreign key (ClienteId) references tbCliente(ClienteId),
foreign key (PecaId) references tbPeca(PecaId)
);

create table tbPedido(
PedidoId int primary key auto_increment,
datapedido datetime,
InfoPedido varchar (500) not null,
ValorTotal decimal(8,2) not null,
TipoPagamento varchar(50) not null,
CarrinhoId int not null,
foreign key (CarrinhoId) references tbCarrinhoCompra (CarrinhoId)
);

create table tbPagamento (
PagamentoId int primary key auto_increment,
PedidoId int not null,
ValorPago decimal(8,2) not null,
DataPagamento datetime not null,
StatusPagamento varchar(50) not null, -- Ex: 'Aprovado', 'Pendente', 'Cancelado'
foreign key (PedidoId) references tbPedido(PedidoId)
);


create table tbNota_Fiscal(
NF int primary key auto_increment,
Produtos varchar(500) not null,
DataEmissao datetime,
ValorTotal decimal(8,2) not null,
PedidoId int not null,
foreign key (PedidoId) references tbPedido (PedidoId)
);

create table tbtroca(
TrocaId int primary key auto_increment,
Itens varchar(500) not null,
DataTroca datetime,
Motivo varchar(200) not null,
StatusTroca boolean not null,
NF int not null,
foreign key (NF) references TbNota_Fiscal (NF)
);



-- aplicação das procedures --

-- procedure para fazer insert das cidades e seus respectivos id's --

delimiter $$
 create procedure spInsertTbcidade(vCidadeId int, vCidade varchar(200))
 begin
     if not exists (select * from tbCidade where Cidade= vCidade) then 
         insert into tbCidade (CidadeId, Cidade) values (vCidadeId, vCidade); 
     end if;
 end $$

 call spInsertTbcidade(null,'Rio de Janeiro');
 call spInsertTbcidade(null, 'São Carlos');
 call spInsertTbcidade(null,'Campinas');
 call spInsertTbcidade(null,'Franco da Rocha');
 call spInsertTbcidade(null,'Osasco');
 call spInsertTbcidade(null,'Pirituba');
 call spInsertTbcidade(null,'Lapa');
 call spInsertTbcidade(null,'Ponta Grossa');
 
 select * from tbcidade;
 
 -- procedure para fazer insert dos estados e seus respectivos UF's --
 
 delimiter $$
 create procedure spInsertTbEstado(vUFId int, vUF varchar(2))
 begin
 if not exists (select * from tbEstado where UF = vUF) then 
         insert into tbEstado (UFId, UF) values (vUFId, vUF); 
     end if; 
 end $$
 
 call spInsertTbEstado(null, 'SP');
 call spInsertTbEstado(null, 'RJ');
 call spInsertTbEstado(null, 'RS');
 
 select * from tbestado;
 
 -- procedure para fazer insert dos bairros e seus respectivos id's --
 
 delimiter $$
 create procedure spInsertTbBairro(vBairroId int, vBairro varchar(200))
 begin
 if not exists (select * from tbBairro where Bairro = vBairro) then 
        insert into tbbairro(BairroId, Bairro) values(vBairroId, vBairro);
     end if; 
 end $$
 
 call spInsertTbBairro(null, 'Aclimação');
 call spInsertTbBairro(null, 'Capão Redondo');
 call spInsertTbBairro(null, 'Pirituba');
 call spInsertTbBairro(null, 'Liberdade');
 
 select * from tbBairro;
 
-- procedure para inserir registros na tbendereco -- 

delimiter $$
create procedure spInsertTbEndereco(vCEP decimal(8,0), vBairro varchar(200), vCidade varchar(200), vUF varchar(2))
begin
		declare vBairroId int;
        declare vCidadeId int;
        declare vUFId int;
        
        if not exists (select * from tbEndereco where CEP = vCEP) then
        
        if not exists (select * from tbBairro where Bairro = vBairro) then
        insert into tbBairro(Bairro) values (vBairro);
        set vBairroId = (select BairroId from tbBairro where Bairro = vBairro);
        else
			select BairroId into vBairroId from tbBairro where Bairro = vBairro;
end if;

		if not exists (select * from tbCidade where Cidade = vCidade) then
        insert into tbCidade(Cidade) values (vCidade);
        set vCidadeId = (select CidadeId from tbCidade where Cidade = vCidade);
        else 
			select CidadeId into vCidadeId from tbCidade where Cidade = vCidade;
end if;

		if not exists (select * from tbestado where UF = vUF) then
        insert into tbestado(UF) values (vUF);
        set vUFId = (select UFId from tbestado where UF = vUF);
        else 
			select UFId into vUFId from tbestado where UF = vUF;
end if;

insert into tbendereco(CEP, BairroId, CidadeId, UFId) values(vCEP, vBairroId, vCidadeId, vUFId);
end if;
end $$

call spInsertTbEndereco(12345678, 'Rua da Federal', 'São Paulo','SP');
call spInsertTbEndereco(12345051, 'Av Brasil', 'Campinas','SP');
call spInsertTbEndereco(12345052, 'Rua Liberdade', 'São Paulo','SP');
call spInsertTbEndereco(12345053, 'Av Paulista', 'Rio de Janeiro','RJ');
call spInsertTbEndereco(12345054, 'Rua Ximbú','Rio de Janeiro','RJ');
call spInsertTbEndereco(12345055, 'Rua Piu XI','Campinas','SP');
call spInsertTbEndereco(12345056, 'Rua Chocolate','Barra Mansa','RJ');
call spInsertTbEndereco(12345057, 'Rua Pão na Chapa','Ponta Grossa','RS');

select * from tbEndereco;
 
 -- procedure para inserir registro de cliente e verificar se ele já existe no sitema --
DELIMITER $$ 

create procedure spInsertCliente(
vNomeCli varchar(100), vCPF decimal(11), vEmail varchar(100), vSenhaUsu varchar(50), vDataNasc date, vTelefone bigint, vNumEnd smallint, vCompEnd varchar(50), vCEP decimal(8, 0), vClienteStatus boolean, vBairro varchar(200), vCidade varchar(200), vUF char(2)
) 
begin
    declare vClienteId int;
    declare vBairroId int;
    declare vCidadeId int;
    declare vUFId int;

    -- Verifica se o CPF já existe --
    IF EXISTS (SELECT CPF FROM tbCliente WHERE CPF = vCPF) THEN
        -- Caso ele exista, exibe a seguinte mensagem: --
        SELECT 'Cliente já existe!' AS Mensagem;
    ELSE
        -- Verifica se o endereço já existe. --
        IF NOT EXISTS (SELECT * FROM tbEndereco WHERE CEP = vCEP) THEN
            -- Se não existir, insere o endereço. --
            -- Verifica se o bairro existe, se não existir, insere. --
            IF NOT EXISTS (SELECT * FROM tbBairro WHERE Bairro = vBairro) THEN
                INSERT INTO tbBairro (Bairro) VALUES (vBairro);
            END IF;

            -- Busca o Id do bairro e armazena na variável vBairroId. --
            SET vBairroId = (SELECT BairroId FROM tbBairro WHERE Bairro = vBairro);

            -- Verifica se a cidade existe, se não existir, insere. --
            IF NOT EXISTS (SELECT * FROM tbCidade WHERE Cidade = vCidade) THEN
                INSERT INTO tbCidade (Cidade) VALUES (vCidade);
            END IF;

            -- Busca o Id da cidade e armazena na variável vCidadeId. --
            SET vCidadeId = (SELECT CidadeId FROM tbCidade WHERE Cidade = vCidade);

            -- Verifica se o Estado existe, se não existir, insere. --
            IF NOT EXISTS (SELECT * FROM tbEstado WHERE UF = vUF) THEN
                INSERT INTO tbEstado (UF) VALUES (vUF);
            END IF;

            -- Busca o Id do UF e armazena na variável vUFId. --
            SET vUFId = (SELECT UFId FROM tbEstado WHERE UF = vUF);

            -- Insere os registros na tbEndereco. --
            INSERT INTO tbEndereco (BairroId, CidadeId, UFId, CEP)
            VALUES (vBairroId, vCidadeId, vUFId, vCEP);
        END IF;

        -- Insere os registros do cliente na tbCliente. -- 
        INSERT INTO tbCliente 
            (NomeCli, CPF, Email, SenhaUsu, DataNasc, Telefone, NumEnd, CompEnd, CEP, Cliente_Status) 
        VALUES 
            (vNomeCli, vCPF, vEmail, vSenhaUsu, vDataNasc, vTelefone, vNumEnd, vCompEnd, vCEP, vClienteStatus);
        
        -- Pega o último Id inserido e armazena na variável vClienteId. --
        SET vClienteId = LAST_INSERT_ID();

        -- Insere os registros na tbLogin, usando o ClienteId obtido. --
        INSERT INTO TbLogin (Email, SenhaUsu, Cliente_Status, ClienteId) 
        VALUES (vEmail, vSenhaUsu, vClienteStatus, vClienteId);
    END IF;
END $$

call spInsertCliente('renan', 12345212350, 'pdro@gmail.com', 'pedrosenha', '1989-01-28', 11940028922, 192, 'apto 1', 12345051, 1, 'Av Brasil', 'Campinas', 'SP');
call spInsertCliente('jeferson', 12345212351, 'pedro@gmail.com', 'pedrosenha', '1989-01-28', 11940028922, 194, 'apto 1', 12345051, 1, 'Av Brasil','Campinas', 'SP');
call spInsertCliente('João Vitor', 12345212355, 'pedr@gmail.com', 'pedrosenha', '1989-01-28', 11940028922, 194, 'apto 1', 12345099, 1, 'Rua Pequena', 'São Paulo', 'SP');
call spInsertCliente('Clayton', 12345212377, 'clayton@gmail.com', 'claytonsenha', '1989-01-28', 11940028933, 196, 'apto 15', 12345456, 0, 'Rua Campo Grande', 'São Paulo', 'SP');

select * from tbestado;
select * from tbcidade;
select * from tbbairro;
select * from tbendereco;
select * from tbcliente;
select * from tblogin;

DELIMITER $$ 
CREATE PROCEDURE spInsertCategoria (
    IN p_nomecategoria VARCHAR(150),
    IN p_img varchar(255)
)
BEGIN
    INSERT INTO tbCategoria ( nomeCategoria, img_categoria)
    VALUES (p_nomecategoria, p_img);
END $$

CALL spInsertCategoria('Pneus', 'cpne.png'); 
CALL spInsertCategoria('Motores', 'cmot.png'); 
CALL spInsertCategoria('Baterias', 'cbateria.png');
CALL spInsertCategoria('Retrovisores', 'cretrovisor.png'); 
CALL spInsertCategoria('Suspensão', 'csuspens.png'); 
CALL spInsertCategoria('Freios', 'cfreio.png');
CALL spInsertCategoria('Filtros de Ar', 'cfiltro.png'); 
CALL spInsertCategoria('Lanternas Traseiras', 'clamp.png'); 
CALL spInsertCategoria('Volantes', 'cvolantes.png');
CALL spInsertCategoria('Óleos e Lubrificantes', 'coleoelubri.png'); 
CALL spInsertCategoria('Escapamentos', 'cescapa.png'); 
CALL spInsertCategoria('Radiadores', 'cradiador.png');

select * from tbCategoria;
delimiter $$
create procedure spInsertPeca(vNomePeca varchar(100), vValorPeca decimal(8,2), vImgPeca varchar(255), vDescricao varchar(200), vQtdEstoque int, vcategoriaid int)
begin
    declare contador int;
    select COUNT(*) into contador from tbPeca where NomePeca = vNomePeca and ValorPeca = vValorPeca and categoriaid= vcategoriaid;

    if contador > 0 then select 'Peça já registrada' as mensagem;
    else
        insert into tbPeca (NomePeca, ValorPeca,img_peca, descricao, qtd_estoque, categoriaid) values (vNomePeca, vValorPeca, vImgPeca, vDescricao, vQtdEstoque, vcategoriaid );
    end if;
end $$

/*Inserção de peças - pneus*/
CALL spInsertPeca('Pneu Aro 22 XBri', 1400.00, 'imgpneu1.png', 'Pneu Aro 22 da marca XBri, ideal para veículos com alto desempenho e segurança, com excelente durabilidade e aderência.', 10, 1);
CALL spInsertPeca('Pneu 110H Scorpion', 1400.00, 'imgpneu2.png', 'Pneu Scorpion 110H, proporciona ótima performance em diferentes tipos de terreno, com resistência e alta estabilidade.', 10, 1);
CALL spInsertPeca('Pneu Aro 15 Archiles', 2099.00, 'imgpneu3.png', 'Pneu Archiles Aro 15, ideal para carros de passeio, com design que oferece ótima performance e conforto ao dirigir.', 10, 1);
CALL spInsertPeca('Pneu Aro 16 Goodyear', 959.00, 'imgpneu4.png', 'Pneu Aro 16 da Goodyear, com tecnologia avançada que garante maior durabilidade e segurança ao dirigir.', 10, 1);
CALL spInsertPeca('Pneu Aro 16 XBri', 293.00, 'imgpneu5.png', 'Pneu XBri Aro 16, ideal para carros de passeio com excelente custo-benefício e durabilidade.', 10, 1);
/*Inserção de peças - Motores*/
CALL spInsertPeca('Motor Ford Coyote V8 5.0 3ª Geração Mustang 2018+', 73000.00, 'imgmotor1.png', 
    'Motor Ford Coyote V8 5.0 0km, motor novo e importado, 466 cavalos de potência, para Mustang 2018+.', 10, 2);
CALL spInsertPeca('Motor Chevy V8 496 Injetado Completo G - Carros', 119830.00, 'imgmotor2.png', 
    'Motor Chevy V8 496 injetado completo, ideal para carros de alta performance, configuração V8.', 8, 2);
CALL spInsertPeca('Motor Completo GM Montana 1.4 8V Gasolina 2015 e 2016', 18000.00, 'imgmotor3.png', 
    'Motor completo GM Montana 1.4 8V Gasolina, inclui cabeçote, pistão, biela, virabrequim e muito mais.', 12, 2);
CALL spInsertPeca('Motor Completo Subaru Forester', 24500.00, 'imgmotor4.png', 
    'Motor completo Subaru Forester EJ20, 150cv, para modelos 2009 da Subaru.', 7, 2);
CALL spInsertPeca('Motor Novo EA888 Gen3 VW Jetta', 50000.00, 'imgmotor5.png', 
    'Motor EA888 Gen3, novo e importado, compatível com VW Jetta GLI, Golf GTI, Tiguan e Passat a partir de 2014.', 5, 2);
/*Inserção de peças - Baterias*/
CALL spInsertPeca('Bateria Cral – CS-60 D – 60 Ah', 260.00, 'imgbateria1.png', 
    'Bateria Cral totalmente selada, com liga de Cálcio/Prata, indicador de carga com 3 leituras e protetor de pólo personalizado.', 10, 3);
CALL spInsertPeca('Bateria De Carro Moura 60ah Corsa', 527.00, 'imgbateria2.png', 
    'Bateria Moura 60Ah para veículos como Corsa, alta performance e durabilidade.', 8, 3);
CALL spInsertPeca('Bateria de carro 12V, 60Ah', 1807.00, 'imgbateria3.png', 
    'Bateria automotiva de lítio LiFePO4, 12V, 60Ah, ideal para veículos de alta performance, com tecnologia de ponta.', 12, 3);
CALL spInsertPeca('Bateria De Carro 72ah Moura Start-stop Efb', 799.99, 'imgbateria4.png', 
    'Bateria Moura 72Ah com tecnologia Start-stop EFB, ideal para veículos modernos com sistemas de parada e partida automática.', 7, 3);
CALL spInsertPeca('Bateria De Carro Moura 60ah 12v 60gx Gol Camaro Vectra Punto', 765.00, 'imgbateria5.png', 
    'Bateria Moura 60Ah 12V para veículos como Gol, Camaro, Vectra e Punto, com alta capacidade de carga e longa durabilidade.', 5, 3);
/*Inserção de peças - Retrovisores*/
CALL spInsertPeca('Espelho Retrovisor Lateral De motocicleta, Barra De Alumínio', 120.00, 'imgretro1.png', 
    'Espelho retrovisor lateral de motocicleta com barra de alumínio.', 10, 4);
CALL spInsertPeca('Par Espelho Retrovisor Motocicleta Kawasaki  Z400', 95.00, 'imgretro2.png', 
    'Par de espelhos retrovisores para motocicleta Kawasaki. Produto elaborado com material de alta qualidade, testado e aprovado dentro das normas de segurança.', 20, 4);
CALL spInsertPeca('Retrovisor Esquerdo S10 Blazer 1995 A 2011 Elétrico Fuscão', 445.00, 'imgretro3.png', 
    'Retrovisor esquerdo elétrico para S10 Blazer 1995 a 2011, modelo Fuscão.', 5, 4);
CALL spInsertPeca('Retrovisor Santa Fé 2010 2011 2012 2013 Com Pisca Elétrico', 1200.00, 'imgretro4.png', 
    'Retrovisor elétrico com pisca para Hyundai Santa Fé 2010 a 2013.', 0, 4);
CALL spInsertPeca('Retrovisor Corolla 2020 2021 2022 Elétrico Com Pisca', 1020.00, 'imgretro5.png', 
    'Retrovisor elétrico com pisca para Hyundai Corolla 2020 a 2022.', 8, 4);
/*Inserção de peças - Suspensão*/
CALL spInsertPeca('Suspensão Coilover D2 Racing Street Volkswagen Up!', 12900.00, 'imgsuspensao1.png', 
    'Suspensão Coilover D2 Racing Street Volkswagen UP! O kit Coilover Street da D2 Racing é o kit perfeito para quem utiliza o carro nas ruas para o dia a dia.', 10, 5);
CALL spInsertPeca('Suspensão esportiva completa BlueLine coilover compatível com Audi A3 8P', 2254.58, 'imgsuspensao4.png', 
'Os coilovers BlueLine são componentes de suspensão específicos para veículos de alta qualidade para rebaixamento em forma de cunha VA 20-60 / HA 30-75 mm. ', 0, 5);
CALL spInsertPeca('Suspensão Fusca Quadro Suspensão Fusca Pivô Novo PC', 1397.44, 'imgsuspensao3.png', 
    'Este anúncio contém os seguintes produtos: 01 Suspensão Dianteira completa Fusca Sistema de freio a disco industrializada.', 5, 5);
CALL spInsertPeca('Kit Rosca Padrão Volkswagen', 1300.00, 'imgsuspensao2.png', 
    '2 OU 4 AMORTECEDORES PREPARADOS (REMANUFATURADO) 4 MOLAS ESPECIAIS 4 CONJUNTO DE REGULAGEM (ROSCADA / USINAGEM CNC)', 20, 5);
CALL spInsertPeca('Kit Suspensão Rosca Slim Gol G2 À G4', 2007.08, 'imgsuspensao5.png', 
    'Kit de Suspensão Regulável Rosca Slim Macaulay é composto por amortecedores reguláveis e molas slim.', 8, 5);
/*Inserção de peças - Freios*/
CALL spInsertPeca('Par Disco De Freio Dianteiro Ventilado', 880.00, 'imgdisco1.png', 
    'Conjunto de discos de freio dianteiros ventilados para Saveiro G6 MSI 280mm, proporcionando eficiência e segurança ao frear.', 10, 6);
CALL spInsertPeca('Par Freio a Disco Cerâmica 280mm', 600.00, 'imgdisco2.png', 
    'Par de freios a disco cerâmicos de alta performance, proporcionando desaceleração rápida e segura, com baixo desgaste e ruído reduzido.', 15, 6);
CALL spInsertPeca('Par Disco De Freio Dianteiro 280MM', 342.77, 'imgdisco3.png', 
    'Conjunto de discos de freio dianteiros de alta qualidade, proporcionando eficiência e segurança ao frear.', 20, 6);
CALL spInsertPeca('Par Disco Freio Dianteiro 328,00 mm', 515.85, 'imgdisco4.png', 
    'Par de discos de freio dianteiros de alta performance, ideais para veículos que exigem desempenho e durabilidade.', 18, 6);
CALL spInsertPeca('Disco de Freio Fremax 287MM Dodge', 525.01, 'imgdisco5.png', 
    'Disco de freio de alta qualidade para Dodge, projetado para proporcionar desaceleração rápida e segura.', 12, 6);
/*Inserção de peças - Filtros de Ar*/
CALL spInsertPeca('Filtro de Ar Simples Wix', 38.50, 'imgfiltroar1.png', 
    'Filtro de ar básico para veículos, oferece boa eficiência em filtragem de partículas.', 10, 7);
CALL spInsertPeca('Filtro de Ar de Alta Eficiência K&S', 20.00, 'imgfiltroar2.png', 
    'Filtro de ar avançado com tecnologia de filtragem de alta eficiência.', 20, 7);
CALL spInsertPeca('Filtro de Ar AEM DryFlow', 59.99, 'imgfiltroar3.png', 
    'Filtro de ar DryFlow da AEM, oferece alta eficiência e durabilidade.', 5, 7);
CALL spInsertPeca('Filtro de Ar Primário Donaldson', 538.11, 'imgfiltroar4.png', 
    'Filtro de ar industrial de alta qualidade para aplicações pesadas.', 0, 7);
CALL spInsertPeca('Filtro de Ar Spectre', 32.50, 'imgfiltroar5.png', 
    'Filtro de ar Spectre, oferece boa eficiência em filtragem de partículas.', 8, 7);
/*Inserção de peças - Lanternas Traseiras*/
CALL spInsertPeca('Lâmpada H4 Philips Blue Vision', 100.00, 'imglanterna1.png', 
    'Lâmpada automotiva H4 Philips Blue Vision, com alto desempenho e durabilidade.', 10, 8);
CALL spInsertPeca('Lâmpada Osram H4 12v 60/55w', 211.00, 'imglanterna2.png', 
    'Lâmpada halógena H4 NightBreaker Laser 12V Osram, até 150% mais brilho em comparação com o mínimo legal.', 20, 8);
CALL spInsertPeca('Lâmpada Led H4 Haloway 12v 24w 6500k', 249.90, 'imglanterna3.png', 
    'Lâmpada LED H4 Haloway 12/24V 24W 6500K, luz branca fria e durabilidade longa.', 5, 8);
CALL spInsertPeca('Lampada 12v Hb4 51w 9006 Standard Osram', 114.25, 'imglanterna4.png', 
    'Lâmpada automotiva HB4 51W 9006 Osram, oferece maior visibilidade para condução segura.', 0, 8);
CALL spInsertPeca('Lampada H4 100w 90w 12v Rallye Original Bosch Atacado', 100.00, 'imglanterna5.png', 
    'Lâmpada halógena H4 100W 90W 12V Rallye Bosch, alta performance e durabilidade.', 8, 8);
/*Inserção de peças - Volantes*/
CALL spInsertPeca('Volante Esportivo Chevrolet', 159.99, 'imgvolante1.png', 
    'Volante esportivo para veículos Chevrolet, com design aerodinâmico e materiais de alta qualidade.', 10, 9);
CALL spInsertPeca('Volante Esportivo Volkswagen', 187.99, 'imgvolante2.png', 
    'Volante esportivo para veículos Volkswagen, com tecnologia avançada e conforto.', 20, 9);
CALL spInsertPeca('Volante Esportivo Renault', 140.00, 'imgvolante3.png', 
    'Volante esportivo para veículos Renault, com design moderno e ergonomia.', 5, 9);
CALL spInsertPeca('Volante Esportivo Hyundai', 159.00, 'imgvolante4.png', 
    'Volante esportivo para veículos Hyundai, com materiais de alta qualidade e conforto.', 0, 9);
CALL spInsertPeca('Volante Esportivo Fiat', 139.90, 'imgvolante5.png', 
    'Volante esportivo para veículos Fiat, com design clássico e funcionalidade.', 8, 9);
/*Inserção de peças - Óleos e Lubrificantes*/
CALL spInsertPeca('Óleo de Motor Lubrax 500ml', 21.90, 'imgoleo1.png', 
    'Óleo de motor sintético para veículos, com proteção contra desgaste e corrosão.', 10, 10);
CALL spInsertPeca('Óleo de Motor Super SL GT-0IL 1L', 16.95, 'imgoleo2.png', 
    'Óleo de motor convencional para veículos, com boa viscosidade e proteção.', 20, 10);
CALL spInsertPeca('Óleo de Motor Ipiranga SI 1L', 28.00, 'imgoleo3.png', 
    'Óleo de motor sintético para veículos, com alta performance e proteção.', 5, 10);
CALL spInsertPeca('Óleo de Motor Havoline 1L', 28.44, 'imgoleo4.png', 
    'Óleo de motor sintético para veículos, com proteção contra desgaste e corrosão.', 0, 10);
CALL spInsertPeca('Óleo de Motor Mobil 20w50 1L', 29.89, 'imgoleo5.png', 
    'Óleo sintético de alta performance, projetado para proteger os motores modernos contra desgaste e corrosão.', 8, 10);
/*Inserção de peças - Escapamentos*/
CALL spInsertPeca('Escapamento de Carro Fiat', 254.90, 'imgescap1.png', 
    'Escapamento original para carros Fiat.', 12, 11);
CALL spInsertPeca('Escapamento Intermediário Meriva', 190.24, 'imgescap2.png', 
    'Melhora desempenho do motor e reduz ruídos.', 3, 11);
CALL spInsertPeca('Escapamento Silencioso Traseiro', 155.99, 'imgescap3.png', 
    'Reduz ruídos e melhora eficiência. Para Gol G5 8v', 0, 11);
CALL spInsertPeca('Escapamento Silencioso Traseiro ', 132.19, 'imgescap4.png', 
    'Reduz ruídos e melhora desempenho. Para Palio 1.0 á 1.4', 17, 11);
CALL spInsertPeca('Escapamento Silencioso Traseiro Doblô', 182.85, 'imgescap5.png', 
    'Reduz ruídos e melhora eficiência.', 10, 11);
/*Inserção de peças - Radiadores*/
CALL spInsertPeca('Radiador - Fire - Palio Siena Strada Idea - Eurus', 539.91, 'imgradiador1.png', 
    'Radiador dianteiro para Fiat Palio, Siena, Strada, Idea, modelo Fire, marca Notus.', 10, 12);
CALL spInsertPeca('Radiador Fiat Fiorino / Uno 1.0 / 1.5 / 1.6 8v Com Ou Sem Ar', 588.80, 'imgradiador2.png', 
    'Radiador para Fiat Fiorino / Uno 1.0 / 1.5 / 1.6 8v, com ou sem ar condicionado, marca Procooler.', 20, 12);
CALL spInsertPeca('Radiador de Óleo de alta Performance 700ml', 1390.00, 'imgradiador3.png', 
    'Radiador de óleo de alta performance com colmeia brasada, material alumínio, capacidade 700 ml.', 10, 12);
CALL spInsertPeca('Grade de radiador', 6181.73, 'imgradiador4.png', 
    'Grade de radiador do carro com luz para o tanque 500, pára-choques dianteiro, máscara da grade, marca Reit.', 20, 12);
CALL spInsertPeca('Radiador de Água CR 2448', 518.89, 'imgradiador5.png', 
    'Radiador de água Mahle CR 2448, líder global em autopeças, com alta performance e qualidade.', 5, 12);

select * from tbPeca;
select * from tbCategoria;
-- procedure para insrir registro de carrinho --
delimiter $$
create procedure spInsertCarrinhoCompras( vProdutosSelecionados varchar(200),  vQtdPeca int, vValorTotalCompra decimal(8,2), vClienteId int, in vPecaId int)
begin
    -- Verifica se o cliente existe, se nao existir 
    if not exists (select 1 from tbCliente where ClienteId = vClienteId) then
        select 'Cliente não encontrado' as mensagem;
    -- Verifica se o produto existe e se há estoque suficiente
    elseif not exists (select 1 from TbPeca where PecaId = vPecaId and qtd_estoque >= vQtdPeca) then
        select 'Produto não encontrado ou estoque insuficiente' as mensagem;
    else
        -- Insere o carrinho de compras
        insert into TbCarrinhoCompra 
            (ProdutosSelecionados, QtdPeca, ValorTotalCompra, ClienteId, PecaId) 
        values
            (vProdutosSelecionados, vQtdPeca, vValorTotalCompra, vClienteId, vPecaId);
    end if;
end $$

select * from tbpeca;

call spInsertCarrinhoCompras('Carburador Marea', 1, 220.00,1, 1);
call spInsertCarrinhoCompras('Carburador Marea', 1, 660.00, 4, 1);
call spInsertCarrinhoCompras('Carburador Marea', 2, 660.00, 3, 1);
call spInsertCarrinhoCompras('Carburador Marea',2, 1500.00, 1, 1);

describe TbCarrinhoCompra;
select * from TbCarrinhoCompra;
select * from TbCliente;
select * from tbpeca;tbpeca

-- procedure para insrir registro de pedidos e verificar se eles já existem no sitema --
delimiter $$
create procedure spInsertPedidos(
    vDataPedido datetime, 
    vInfoPedido varchar(500), 
    vCarrinhoId int,
    vTipoPagamento varchar(50) -- Adicionando o tipo de pagamento como parâmetro
)
begin
    declare contador int;
    declare vValorTotalCarrinho decimal(8,2);

    -- Verifica se o carrinho existe
    if not exists (select 1 from TbCarrinhoCompra where CarrinhoId = vCarrinhoId) then
        select 'Erro: Carrinho não encontrado' as mensagem;
    else
        -- Verifica se o pedido já foi registrado
        select COUNT(*) into contador 
        from TbPedido 
        where CarrinhoId = vCarrinhoId;

        if contador > 0 THEN
            select 'Pedido já registrado' as mensagem;
        else
            -- Busca o valor total do carrinho
            select ValorTotalCompra into vValorTotalCarrinho
            from TbCarrinhoCompra 
            where CarrinhoId = vCarrinhoId;

            -- Insere o pedido com o valor total do carrinho e o tipo de pagamento
            insert into TbPedido 
                (DataPedido, InfoPedido, ValorTotal, CarrinhoId, TipoPagamento) 
            values 
                (vDataPedido, vInfoPedido, vValorTotalCarrinho, vCarrinhoId, vTipoPagamento);

            select 'Pedido registrado com sucesso' as mensagem;
        end if;
    end if;
end $$

call spInsertPedidos('2024-10-15', 'teste', 1, 'Cartão de Crédito');
call spInsertPedidos('2024-10-15','3 carburadores de Marea', 2, 'Pix');
/*call spInsertPedidos('2024-10-15','2 Laptop Mouse', 8); */
select * from tbcarrinhocompra;
select * from tbpedido

delimiter $$ 
create procedure spInsertPagamento(
    vPedidoId int, 
    vValorPago decimal(8,2), 
    vDataPagamento datetime, 
    vStatusPagamento varchar(50) -- Remover TipoPagamento daqui
)
begin
    declare contador int;

    -- Verifica se o pedido existe --
    if not exists (select PedidoId from TbPedido where PedidoId = vPedidoId) then
        select 'Erro: Pedido não encontrado' as mensagem;
    else
        -- Verifica se o pagamento já foi registrado --
        select COUNT(*) into contador 
        from TbPagamento 
        where PedidoId = vPedidoId;

        if contador > 0 then
            select 'Pagamento já registrado para este pedido' as mensagem;
        else
            -- Insere o pagamento --
            insert into TbPagamento 
                (PedidoId, ValorPago, DataPagamento, StatusPagamento) 
            values 
                (vPedidoId, vValorPago, vDataPagamento, vStatusPagamento);

            -- Atualiza a coluna TipoPagamento na tbPedido
            update TbPedido
            set TipoPagamento = 'Cartão de Crédito' -- Por exemplo, você pode passar como parâmetro também
            where PedidoId = vPedidoId;

            -- Se o pagamento for aprovado, opcionalmente atualiza o status do pedido --
            if vStatusPagamento = 'Aprovado' then
                update TbPedido
                set InfoPedido = concat(InfoPedido, ' - Pagamento Aprovado')
                where PedidoId = vPedidoId;
            end if;

            select 'Pagamento registrado com sucesso' as mensagem;
        end if;
    end if;
end $$ 


call spInsertPagamento(1, 250.00, '2024-10-20 12:00:00', 'Aprovado');
call spInsertPagamento(2, 7000.00, '2024-10-20 12:00:00', 'Aprovado');

DELIMITER $$

CREATE PROCEDURE spInsertNotaFiscal(
    vPedidoId INT
)
BEGIN
    DECLARE vProdutos VARCHAR(500);
    DECLARE vDataEmissao DATETIME;
    DECLARE vValorTotal DECIMAL(8,2);

    -- Verifica se o pedido existe
    IF NOT EXISTS (SELECT 1 FROM tbPedido WHERE PedidoId = vPedidoId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: Pedido não encontrado';
    END IF;

    -- Verifica se o pagamento foi realizado para o pedido
    IF NOT EXISTS (SELECT 1 FROM tbPagamento WHERE PedidoId = vPedidoId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: Pagamento não encontrado para este pedido';
    END IF;

    -- Busca informações do pedido
    SELECT InfoPedido, NOW(), ValorTotal INTO vProdutos, vDataEmissao, vValorTotal
    FROM tbPedido
    WHERE PedidoId = vPedidoId;

    -- Insere dados na tbNota_Fiscal (NF será gerado automaticamente)
    INSERT INTO tbNota_Fiscal (Produtos, DataEmissao, ValorTotal, PedidoId)
    VALUES (vProdutos, vDataEmissao, vValorTotal, vPedidoId);

    SELECT 'Nota Fiscal criada com sucesso!' AS Mensagem;
END $$


CALL spInsertNotaFiscal(1);  -- Substitua 1 pelo ID de um pedido existente
select * from tbnota_fiscal;
select * from tbpedido;


DELIMITER $$

CREATE PROCEDURE spInserirTroca(
    IN vMotivo VARCHAR(200),
    IN vNF INT
)
BEGIN
    DECLARE vPedidoId INT;
    DECLARE vProdutos VARCHAR(500);
    DECLARE vDataEmissao DATETIME;
    DECLARE vValorTotal DECIMAL(8,2);
    
    -- Verifica se a nota fiscal existe
    IF NOT EXISTS (SELECT 1 FROM tbNota_Fiscal WHERE NF = vNF) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: Nota Fiscal não encontrada';
    END IF;

    -- Busca o PedidoId associado à Nota Fiscal
    SELECT PedidoId INTO vPedidoId
    FROM tbNota_Fiscal
    WHERE NF = vNF;

    -- Insere o registro de troca
    INSERT INTO tbtroca (Itens, DataTroca, Motivo, StatusTroca, NF)
    VALUES (CONCAT('Itens do pedido ', vPedidoId), NOW(), vMotivo, TRUE, vNF);

    -- Busca informações do pedido para criar uma nova nota fiscal
    SELECT InfoPedido, NOW(), ValorTotal INTO vProdutos, vDataEmissao, vValorTotal
    FROM tbPedido
    WHERE PedidoId = vPedidoId;

    -- Insere a nova nota fiscal
    INSERT INTO tbNota_Fiscal (Produtos, DataEmissao, ValorTotal, PedidoId)
    VALUES (vProdutos, vDataEmissao, vValorTotal, vPedidoId);

    SELECT 'Troca registrada com sucesso!' AS Mensagem;
END $$



CALL spInserirTroca('peça com defeito', 1); -- Substitua 1 pelo NF existente
select * from tbtroca;
select * from  tbnota_fiscal;

select * from TbPagamento;
-- triggers --

DELIMITER $$

CREATE TRIGGER AtualizaEstoque
AFTER INSERT ON TbPedido
FOR EACH ROW
BEGIN
    DECLARE vQtdEstoqueAtual INT;

    -- Atualiza a quantidade de estoque das peças do carrinho
    UPDATE TbPeca p
    JOIN TbCarrinhoCompra c ON c.PecaId = p.PecaId
    SET p.qtd_estoque = p.qtd_estoque - c.QtdPeca
    WHERE c.CarrinhoId = NEW.CarrinhoId
    AND (SELECT @vQtdEstoqueAtual := p.qtd_estoque) >= c.QtdPeca;

    -- Verifica se a atualização foi bem-sucedida
    IF ROW_COUNT() = 0 THEN
        -- Se não houver estoque suficiente, restaura a quantidade
        UPDATE TbPeca p
        JOIN TbCarrinhoCompra c ON c.PecaId = p.PecaId
        SET p.qtd_estoque = p.qtd_estoque + c.QtdPeca
        WHERE c.CarrinhoId = NEW.CarrinhoId;
        
    END IF;
END $$


describe tbPeca;
select * from tbPeca where categoriaid = 1;

describe tbCategoria;
select * from tbCategoria;


select * from tbpeca where pecaid=1;
