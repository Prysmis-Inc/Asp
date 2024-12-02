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
logradouro varchar(50) not null,
CEP decimal(8,0) not null,
Cliente_Status boolean null default 0,
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
descricao varchar (500) not null,
qtd_estoque int not null,
categoriaid int not null,
Foreign key (categoriaid) references tbCategoria(Categoriaid)
); 

create table tbCarrinhoCompra(
CarrinhoId int primary key auto_increment,
QtdPeca int not null,
ClienteId int not null,
PecaId int not null,
Foreign key (ClienteId) references tbCliente(ClienteId),
foreign key (PecaId) references tbPeca(PecaId)
);

create table tbPedido (
PedidoId int primary key auto_increment,
datapedido datetime not null,    -- Data do pedido
ClienteId int not null,          -- Referência ao cliente que fez o pedido
StatusPedido varchar(50) not null default 'Pendente',  -- Status do pedido (Pendente, Enviado, Entregue, Cancelado)
foreign key (ClienteId) references tbCliente(ClienteId)
);

create table tbItemPedido (
ItemPedidoId int primary key auto_increment,
PedidoId int not null,            -- Referência ao pedido
PecaId int not null,              -- Referência à peça comprada
QtdPeca int not null,             -- Quantidade da peça comprada
ValorUnitario decimal(8,2) not null,  -- Valor unitário da peça no momento da compra
ValorTotal decimal(8,2) not null,    -- Valor total (QtdPeca * ValorUnitario)
foreign key (PedidoId) references tbPedido(PedidoId),
foreign key (PecaId) references tbPeca(PecaId)
);

create table tbPagamento (
PagamentoId int primary key auto_increment,
PedidoId int not null,           -- Referência ao pedido
ValorPago decimal(8,2) not null, -- Valor pago
DataPagamento datetime not null, -- Data do pagamento
StatusPagamento varchar(50) not null default 'Pendente',  -- Status do pagamento (Aprovado, Pendente, Cancelado)
TipoPagamento varchar(50) not null,    -- Tipo de pagamento (Cartão, Boleto, etc.)
NomeTitular varchar(60) null,         -- Nome Titular
BandeiraCartao varchar(30) null,     -- Bandeira do cartão (Visa, MasterCard, etc.)
NumeroCartao numeric(16) null,       -- Número do cartão (masculino ou criptografado)
CVV numeric(3) null,                -- CVV do cartão
DataValidade char(5) null,
foreign key (PedidoId) references tbPedido(PedidoId)
);




select ClienteId, NomeCli, CPF, Email, SenhaUsu, DataNasc, telefone, NumEnd,CompEnd, logradouro, tbCliente.CEP, tbcidade.Cidade, tbEstado.UF, tbBairro.Bairro from tbcliente inner join tbEndereco on tbcliente.CEP = tbEndereco.Cep inner join tbBairro on tbEndereco.BairroId = tbBairro.BairroId inner join tbCidade on tbEndereco.CidadeId = tbCidade.CidadeId inner join tbEstado on tbEndereco.UFId = tbEstado.UFId;
describe tbCliente;

select PecaId, NomePeca, ValorPeca, img_peca, descricao, qtd_estoque, tbcategoria.categoriaid, nomecategoria, img_categoria from tbPeca inner join tbCategoria on tbPeca.categoriaid = tbCategoria.categoriaid;
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
call spInsertTbEndereco(12345052, 'Liberdade', 'São Paulo','SP');
call spInsertTbEndereco(12345053, 'Paulista', 'Rio de Janeiro','RJ');
call spInsertTbEndereco(12345054, 'Rua Ximbú','Rio de Janeiro','RJ');
call spInsertTbEndereco(12345055, 'Rua Piu XI','Campinas','SP');
call spInsertTbEndereco(12345056, 'Rua Chocolate','Barra Mansa','RJ');
call spInsertTbEndereco(12345057, 'Rua Pão na Chapa','Ponta Grossa','RS');

select * from tbEndereco; 

 -- procedure para inserir registro de cliente e verificar se ele já existe no sitema --
DELIMITER $$ 

create procedure spInsertCliente(
vNomeCli varchar(100), vCPF decimal(11), vEmail varchar(100), vSenhaUsu varchar(50), vDataNasc date, vTelefone bigint, vNumEnd smallint, vCompEnd varchar(50), vLogradouro varchar(50),vCEP decimal(8, 0), vClienteStatus boolean, vBairro varchar(200), vCidade varchar(200), vUF char(2)
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
            (NomeCli, CPF, Email, SenhaUsu, DataNasc, Telefone,NumEnd, CompEnd, Logradouro,CEP, Cliente_Status) 
        VALUES 
            (vNomeCli, vCPF, vEmail, vSenhaUsu, vDataNasc, vTelefone, vNumEnd, vCompEnd, vLogradouro,vCEP, vClienteStatus);
        
        -- Pega o último Id inserido e armazena na variável vClienteId. --
        SET vClienteId = LAST_INSERT_ID();

        -- Insere os registros na tbLogin, usando o ClienteId obtido. --
        INSERT INTO TbLogin (Email, SenhaUsu, Cliente_Status, ClienteId) 
        VALUES (vEmail, vSenhaUsu, vClienteStatus, vClienteId);
    END IF;
END $$

call spInsertCliente('renan', 12345212350, 'pdro@gmail.com', 'pedrosenha', '1989-01-28', 11940028922, 192, 'apto 1', 'Rua Água Marinha',12345051, 1, 'Av Brasil', 'Campinas', 'SP');
call spInsertCliente('jeferson', 12345212351, 'pedro@gmail.com', 'pedrosenha', '1989-01-28', 11940028922, 194, 'apto 1', 'Rua Topázio',12345051, 1, 'Av Brasil','Campinas', 'SP');
call spInsertCliente('João Vitor', 12345212355, 'pedr@gmail.com', 'pedrosenha', '1989-01-28', 11940028922, 194, 'apto 1', 'Rua Dedaleiro',12345099, 1, 'Rio Pequeno', 'São Paulo', 'SP');
call spInsertCliente('Clayton', 12345212377, 'clayton@gmail.com', 'claytonsenha', '1989-01-28', 11940028933, 196, 'apto 15', 'Rua Frederico Jacobi',05136110, 0, 'Jd. Santo Elias', 'São Paulo', 'SP');

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
select * from tbpeca;

delimiter $$
create procedure spInsertPeca(vNomePeca varchar(100), vValorPeca decimal(8,2), vImgPeca varchar(255), vDescricao varchar(500), vQtdEstoque int, vcategoriaid int)
begin
    declare contador int;
    select COUNT(*) into contador from tbPeca where NomePeca = vNomePeca and ValorPeca = vValorPeca and categoriaid= vcategoriaid;

    if contador > 0 then select 'Peça já registrada' as mensagem;
    else
        insert into tbPeca (NomePeca, ValorPeca,img_peca, descricao, qtd_estoque, categoriaid) values (vNomePeca, vValorPeca, vImgPeca, vDescricao, vQtdEstoque, vcategoriaid );
    end if;
end $$

/*Inserção de peças - pneus*/
CALL spInsertPeca('Pneu Aro 22 XBri', 1400.00, 'imgpneu1.png', 'Pneu Aro 22 da marca XBri, projetado para veículos de alto desempenho e segurança. Este pneu oferece uma excelente durabilidade, aderência superior e estabilidade, ideal para rodovias e estradas de alta velocidade. A tecnologia de construção garante uma experiência de direção suave e segura, mesmo em condições adversas, com resistência aprimorada ao desgaste. A combinação perfeita de performance e custo-benefício para motoristas exigentes que buscam qualidade e confiabilidade', 10, 1);
CALL spInsertPeca('Pneu 110H Scorpion', 1400.00, 'imgpneu2.png', 'Pneu Scorpion 110H, desenvolvido para oferecer ótima performance em diferentes tipos de terreno. Ideal para veículos que enfrentam uma variedade de superfícies, desde asfalto até estradas de terra. Seu design inovador proporciona resistência superior ao desgaste, estabilidade em curvas e maior capacidade de tração. A alta performance em todas as condições climáticas garante a segurança e o conforto do motorista, seja em pistas secas ou molhadas.', 10, 1);
CALL spInsertPeca('Pneu Aro 15 Archiles', 2099.00, 'imgpneu3.png', 'Pneu Archiles Aro 15, projetado para carros de passeio que exigem conforto e alta performance. Sua construção avançada proporciona uma condução silenciosa e suave, com excelente absorção de impactos, reduzindo vibrações e garantindo maior conforto ao dirigir. O design inovador melhora a aderência ao solo, oferecendo maior estabilidade e segurança em diferentes condições de clima. ', 10, 1);
CALL spInsertPeca('Pneu Aro 16 Goodyear', 959.00, 'imgpneu4.png', 'Pneu Aro 16 da Goodyear, equipado com tecnologia avançada para garantir maior durabilidade, segurança e performance superior. Este pneu foi projetado para fornecer uma condução suave e estável, mesmo em condições extremas de temperatura ou em pisos molhados. Sua banda de rodagem é otimizada para proporcionar excelente aderência ao solo, reduzindo a distância de frenagem e melhorando a eficiência de combustível.', 10, 1);
CALL spInsertPeca('Pneu Aro 16 XBri', 293.00, 'imgpneu5.png', 'Pneu XBri Aro 16, perfeito para carros de passeio que buscam um pneu de excelente custo-benefício. Com um design robusto e uma construção durável, este pneu oferece ótima performance em diversas condições de estrada. Sua estrutura especial ajuda a melhorar a aderência e a estabilidade, proporcionando uma direção mais segura, mesmo em estradas com variações de terreno. Ideal para motoristas que buscam um pneu de alta qualidade, com bom desempenho e preço acessível.', 10, 1);
/*Inserção de peças - Motores*/
CALL spInsertPeca('Motor Ford Coyote V8 5.0 3ª Geração Mustang 2018+', 73000.00, 'imgmotor1.png', 'Motor Ford Coyote V8 5.0 0km, motor novo e importado, com 466 cavalos de potência, projetado para proporcionar uma performance excepcional no Mustang 2018+. Equipado com tecnologia avançada para oferecer maior eficiência e desempenho, garantindo uma aceleração rápida, estabilidade e um som inconfundível. Ideal para quem busca performance em pista e estrada, com uma durabilidade superior para motoristas exigentes que desejam uma condução de alto nível.', 10, 2);
CALL spInsertPeca('Motor Chevy V8 496 Injetado Completo G - Carros', 119830.00, 'imgmotor2.png', 'Motor Chevy V8 496 injetado completo, desenvolvido para carros de alta performance. Com uma configuração V8, este motor oferece um incrível torque e potência, ideal para carros de alto desempenho que exigem força e resistência. Sua injeção eletrônica permite uma resposta precisa e eficiente do acelerador, tornando-o perfeito para veículos que buscam performance superior tanto em aceleração quanto em velocidade máxima. ', 8, 2);
CALL spInsertPeca('Motor Completo GM Montana 1.4 8V Gasolina 2015 e 2016', 18000.00, 'imgmotor3.png', 'Motor completo GM Montana 1.4 8V Gasolina, inclui cabeçote, pistão, biela, virabrequim e muito mais. Com um design compacto e eficiente, este motor oferece uma excelente combinação de performance e economia de combustível, sendo perfeito para o uso diário em caminhonetes como a GM Montana 2015 e 2016. Ideal para quem busca um motor robusto e confiável para o dia a dia, com manutenção acessível e desempenho satisfatório em várias condições de tráfego.', 12, 2);
CALL spInsertPeca('Motor Completo Subaru Forester', 24500.00, 'imgmotor4.png', 'Motor completo Subaru Forester EJ20, 150cv, projetado para oferecer um desempenho estável e confiável para modelos 2009 da Subaru. Com 150 cavalos de potência, o motor EJ20 oferece uma excelente relação entre performance e economia de combustível. Ideal para quem busca um motor robusto para off-road ou para a condução diária, proporcionando confiabilidade e durabilidade em terrenos difíceis e em viagens longas.', 7, 2);
CALL spInsertPeca('Motor Novo EA888 Gen3 VW Jetta', 50000.00, 'imgmotor5.png', 'Motor EA888 Gen3, novo e importado, compatível com VW Jetta GLI, Golf GTI, Tiguan e Passat a partir de 2014. Este motor 2.0 TSI oferece potência, performance e eficiência de combustível em um único pacote. Sua tecnologia de injeção direta e turboalimentação permite um desempenho superior tanto em velocidade quanto em eficiência de combustível. Ideal para motoristas que buscam um motor com alta performance para veículos Volkswagen.', 5, 2);
/*Inserção de peças - Baterias*/
CALL spInsertPeca('Bateria Cral – CS-60 D – 60 Ah', 260.00, 'imgbateria1.png', 'Bateria Cral CS-60 D, com 60 Ah de potência, totalmente selada e equipada com tecnologia de ponta. Sua liga de Cálcio/Prata garante maior eficiência e durabilidade, enquanto o indicador de carga com 3 leituras facilita o monitoramento da bateria. A bateria também conta com um protetor de pólo personalizado, oferecendo segurança extra e prevenindo corrosões. Ideal para veículos que necessitam de uma bateria confiável.', 10, 3);
CALL spInsertPeca('Bateria De Carro Moura 60ah Corsa', 527.00, 'imgbateria2.png', 'Bateria Moura 60Ah, ideal para carros como o Corsa, projetada para garantir alta performance e durabilidade. Com tecnologia avançada, oferece excelente resistência a altas temperaturas e uma vida útil prolongada. Sua capacidade de carga proporciona uma partida rápida, mesmo em condições extremas de clima e uso intenso. Uma escolha perfeita para quem busca confiança e segurança na hora de manter seu veículo em funcionamento.', 8, 3);
CALL spInsertPeca('Bateria de carro 12V, 60Ah', 1807.00, 'imgbateria3.png', 'Bateria automotiva de lítio LiFePO4 12V e 60Ah, desenvolvida para veículos de alta performance. Com tecnologia de ponta, essa bateria oferece uma carga mais eficiente, leveza e maior durabilidade em comparação com baterias tradicionais de chumbo-ácido. Ideal para carros esportivos ou modelos que exigem maior potência, ela possui uma vida útil muito mais longa, com resistência superior à descarga profunda e temperaturas extremas..', 12, 3);
CALL spInsertPeca('Bateria De Carro 72ah Moura Start-stop Efb', 799.99, 'imgbateria4.png', 'Bateria Moura 72Ah com tecnologia Start-stop EFB (Enhanced Flooded Battery), especialmente projetada para veículos modernos com sistemas de parada e partida automáticos. Sua alta capacidade de carga e resistência a ciclos de carga e descarga garantem um desempenho estável e confiável, mesmo em condições de uso intenso. Ideal para carros com tecnologias de eficiência energética.', 7, 3);
CALL spInsertPeca('Bateria De Carro Moura 60ah 12v 60gx Gol Camaro Vectra Punto', 765.00, 'imgbateria5.png', 'Bateria Moura 60Ah 12V, especialmente desenvolvida para modelos de carros como Gol, Camaro, Vectra e Punto. Com alta capacidade de carga e excelente durabilidade, oferece um desempenho superior mesmo em climas extremos. Sua tecnologia garante partidas rápidas e confiáveis, sem falhas, mesmo em temperaturas baixas. Ideal para quem busca uma bateria de longa vida útil..', 5, 3);

/*Inserção de peças - Retrovisores*/
CALL spInsertPeca('Espelho Retrovisor Lateral De motocicleta, Barra De Alumínio', 120.00, 'imgretro1.png', 'Espelho retrovisor lateral para motocicletas, projetado com uma barra de alumínio resistente e leve, proporcionando alta durabilidade e um design moderno. Ideal para quem busca um espelho de reposição ou para customização de motos. Sua construção robusta oferece resistência à corrosão e impacto, mantendo uma visibilidade clara e precisa durante a pilotagem. Uma excelente escolha para motociclistas que valorizam segurança e estilo.', 10, 4);
CALL spInsertPeca('Par Espelho Retrovisor Motocicleta Kawasaki Z400', 95.00, 'imgretro2.png', 'Par de espelhos retrovisores para motocicletas Kawasaki Z400, feitos com materiais de alta qualidade, que garantem maior resistência e durabilidade. Testado e aprovado conforme as normas de segurança, oferece excelente visibilidade e estabilidade para o condutor. Ideal para substituição ou upgrade do retrovisor original, proporcionando um visual esportivo e moderno à moto, com fácil instalação e ajustes para diferentes ângulos.', 20, 4);
CALL spInsertPeca('Retrovisor Esquerdo S10 Blazer 1995 A 2011 Elétrico Fuscão', 445.00, 'imgretro3.png', 'Retrovisor esquerdo elétrico, modelo Fuscão, compatível com S10 Blazer de 1995 a 2011. Projetado para oferecer ajuste preciso e fácil com a funcionalidade elétrica, garantindo conforto e segurança ao motorista. A peça é fabricada com materiais de alta resistência e é ideal para reposição, proporcionando ótima visibilidade, durabilidade e praticidade, com um design que se encaixa perfeitamente nos modelos mencionados.', 5, 4);
CALL spInsertPeca('Retrovisor Santa Fé 2010 2011 2012 2013 Com Pisca Elétrico', 1200.00, 'imgretro4.png', 'Retrovisor elétrico com pisca integrado, projetado para o Hyundai Santa Fé de 2010 a 2013. Este modelo combina a funcionalidade de ajuste elétrico com a conveniência do sinal de direção incorporado, proporcionando maior segurança e visibilidade em qualquer situação de trânsito. Ideal para quem precisa de um retrovisor de reposição, oferecendo não apenas estética e praticidade.', 0, 4);
CALL spInsertPeca('Retrovisor Corolla 2020 2021 2022 Elétrico Com Pisca', 1020.00, 'imgretro5.png', 'Retrovisor elétrico com pisca, projetado para o Toyota Corolla 2020 a 2022. Com ajuste elétrico preciso e sinalizador integrado, esse retrovisor proporciona maior visibilidade e segurança, especialmente em mudanças de faixa ou em manobras de estacionamento. A peça foi projetada para se encaixar perfeitamente nos modelos Corolla, combinando estética moderna e funcionalidade. Ideal para substituição ou atualização do retrovisor original.', 8, 4);

/*Inserção de peças - Suspensão*/
CALL spInsertPeca('Suspensão Coilover D2 Racing Street Volkswagen Up!', 12900.00, 'imgsuspensao1.png', 'Suspensão Coilover D2 Racing Street para Volkswagen Up!, projetada para aqueles que buscam performance e conforto no dia a dia. O kit Coilover Street da D2 Racing é perfeito para quem utiliza o carro nas ruas, oferecendo regulagem de altura e firmeza, garantindo uma condução mais estável e confortável. Ideal para quem deseja rebaixar o carro mantendo a qualidade e segurança, além de um design arrojado e durabilidade de alto nível.', 10, 5);
CALL spInsertPeca('Suspensão esportiva completa BlueLine coilover compatível com Audi A3 8P', 2254.58, 'imgsuspensao4.png', 'Suspensão esportiva BlueLine coilover, projetada especificamente para Audi A3 8P, com ajuste preciso de altura e firmeza. O kit permite rebaixamento de forma personalizada, com as configurações VA 20-60 mm e HA 30-75 mm, oferecendo excelente desempenho em pistas e ruas. Ideal para quem procura melhorar a estabilidade, a estética e o conforto do veículo.', 0, 5);
CALL spInsertPeca('Suspensão Fusca Quadro Suspensão Fusca Pivô Novo PC', 1397.44, 'imgsuspensao3.png', 'Suspensão dianteira completa para Fusca, incluindo sistema de freio a disco industrializado. Este kit de suspensão é ideal para quem deseja melhorar a performance do veículo com qualidade e confiabilidade. O pivô novo e o quadro de suspensão garantem maior estabilidade e controle, proporcionando uma condução mais suave e segura. Perfeito para quem busca uma solução moderna para o Fusca, mantendo sua originalidade e desempenho.', 5, 5);
CALL spInsertPeca('Kit Rosca Padrão Volkswagen', 1300.00, 'imgsuspensao2.png', 'Kit de suspensão Rosca Padrão para veículos Volkswagen, composto por amortecedores remanufaturados de alta qualidade e molas especiais para regulagem personalizada. O kit inclui 4 conjuntos de regulagem rosqueada, com usinagem CNC de precisão, garantindo uma condução mais confortável e firme, além de um ajuste perfeito para diferentes tipos de terreno. Ideal para quem busca um desempenho superior e a possibilidade de ajustar a suspensão de acordo com as suas preferências.', 20, 5);
CALL spInsertPeca('Kit Suspensão Rosca Slim Gol G2 À G4', 2007.08, 'imgsuspensao5.png', 'Kit de suspensão Rosca Slim Macaulay para Gol G2 a G4, composto por amortecedores reguláveis e molas slim, proporcionando um rebaixamento preciso e controle aprimorado. O design Slim permite uma instalação mais leve e compacta, mantendo a alta performance. Ideal para quem deseja um ajuste personalizável na altura e firmeza da suspensão, oferecendo uma experiência de condução mais estável e confortável, com um visual esportivo e moderno.', 8, 5);

/*Inserção de peças - Freios*/
CALL spInsertPeca('Par Disco De Freio Dianteiro Ventilado', 880.00, 'imgdisco1.png', 'Par de discos de freio dianteiros ventilados para Saveiro G6 MSI 280mm, projetado para oferecer excelente dissipação de calor e performance otimizada. Com design ventilado, esses discos proporcionam maior eficiência no processo de frenagem, garantindo maior segurança ao frear, especialmente em situações de alta demanda, como frenagens rápidas e constantes.', 10, 6);
CALL spInsertPeca('Par Freio a Disco Cerâmica 280mm', 600.00, 'imgdisco2.png', 'Par de discos de freio cerâmicos de 280mm de alta performance, desenvolvido para proporcionar uma desaceleração rápida e segura. Com baixo índice de desgaste e tecnologia de redução de ruídos, esses discos oferecem uma resposta superior durante a frenagem, garantindo maior durabilidade e confiabilidade, ideais para quem busca eficiência em frenagens intensas e condições severas de uso.', 15, 6);
CALL spInsertPeca('Par Disco De Freio Dianteiro 280MM', 342.77, 'imgdisco3.png', 'Par de discos de freio dianteiros de 280mm, fabricados com materiais de alta qualidade para garantir máxima eficiência e segurança durante a frenagem. Projetado para proporcionar desempenho confiável e durabilidade, esses discos são ideais para quem busca um produto robusto e eficiente para o uso diário e viagens, mantendo a segurança e conforto.', 20, 6);
CALL spInsertPeca('Par Disco Freio Dianteiro 328,00 mm', 515.85, 'imgdisco4.png', 'Par de discos de freio dianteiros de 328mm, com alta performance e durabilidade. Ideal para veículos que exigem respostas rápidas e precisas ao frear, esses discos são projetados para suportar altas temperaturas e condições exigentes, oferecendo excelente resistência ao desgaste e garantindo um desempenho confiável em frenagens de alta intensidade.', 18, 6);
CALL spInsertPeca('Disco de Freio Fremax 287MM Dodge', 525.01, 'imgdisco5.png', 'Disco de freio Fremax de 287mm para Dodge, desenvolvido com alta qualidade para oferecer uma frenagem eficiente e segura. Projetado para suportar altas temperaturas e garantir excelente desempenho, esse disco oferece uma desaceleração rápida, com resposta precisa e maior durabilidade, ideal para veículos que exigem alta performance em frenagens constantes.', 12, 6);

/*Inserção de peças - Filtros de Ar*/
CALL spInsertPeca('Filtro de Ar Simples Wix', 38.50, 'imgfiltroar1.png', 'Filtro de ar básico da Wix, projetado para fornecer excelente eficiência na filtragem de partículas, garantindo um fluxo de ar limpo e adequado ao motor. Ideal para quem busca uma solução de manutenção simples e eficaz para o seu veículo, com desempenho confiável para o uso diário.', 10, 7);
CALL spInsertPeca('Filtro de Ar de Alta Eficiência K&S', 20.00, 'imgfiltroar2.png', 'Filtro de ar de alta eficiência da K&S, projetado para filtrar impurezas e partículas finas com alta precisão. Este filtro melhora o desempenho do motor, proporcionando maior proteção e eficiência, além de aumentar a vida útil do sistema de admissão de ar, ideal para veículos que exigem maior cuidado no processo de filtragem.', 20, 7);
CALL spInsertPeca('Filtro de Ar AEM DryFlow', 59.99, 'imgfiltroar3.png', 'Filtro de ar DryFlow da AEM, desenvolvido para garantir máxima eficiência na filtragem de ar, mantendo o motor protegido contra impurezas. Este filtro é lavável e reutilizável, proporcionando uma solução de longa duração, com excelente desempenho e durabilidade, perfeito para quem busca alta performance e redução de custos a longo prazo.', 5, 7);
CALL spInsertPeca('Filtro de Ar Primário Donaldson', 538.11, 'imgfiltroar4.png', 'Filtro de ar industrial primário da Donaldson, projetado para aplicações pesadas e exigentes. Com tecnologia avançada de filtragem, ele oferece proteção superior para motores de grandes equipamentos, assegurando uma operação eficiente e prolongada em ambientes de trabalho rigorosos, como indústrias e maquinários pesados.', 0, 7);
CALL spInsertPeca('Filtro de Ar Spectre', 32.50, 'imgfiltroar5.png', 'Filtro de ar Spectre, projetado para melhorar a eficiência do motor através de uma filtragem eficaz e eficiente. Com um design que otimiza o fluxo de ar e minimiza a entrada de partículas indesejadas, este filtro é ideal para quem busca um desempenho constante e proteção confiável, sendo uma excelente escolha para veículos de uso regular.', 8, 7);

/*Inserção de peças - Lanternas Traseiras*/
CALL spInsertPeca('Lâmpada H4 Philips Blue Vision', 100.00, 'imglanterna1.png', 'Lâmpada automotiva H4 Philips Blue Vision, oferece alto desempenho com uma luz branca de alta intensidade, proporcionando maior visibilidade e segurança durante a condução. Ideal para quem busca uma iluminação eficiente e durável para uma experiência de direção mais confortável e segura, especialmente à noite ou em condições de baixa visibilidade.', 10, 8);
CALL spInsertPeca('Lâmpada Osram H4 12v 60/55w', 211.00, 'imglanterna2.png', 'Lâmpada halógena H4 NightBreaker Laser 12V Osram, até 150% mais brilho em comparação com a lâmpada padrão, garantindo maior visibilidade e segurança ao dirigir. Ideal para quem deseja uma iluminação potente e clara, com uma distribuição de luz mais eficaz em vias escuras e durante viagens noturnas, aumentando a segurança no trânsito.', 20, 8);
CALL spInsertPeca('Lâmpada Led H4 Haloway 12v 24w 6500k', 249.90, 'imglanterna3.png', 'Lâmpada LED H4 Haloway 12/24V 24W 6500K, com luz branca fria, proporcionando uma iluminação extremamente clara e nítida. A tecnologia LED oferece longa durabilidade, menor consumo de energia e maior eficiência, além de oferecer maior visibilidade nas estradas à noite, tornando a condução mais segura e confortável para os motoristas.', 5, 8);
CALL spInsertPeca('Lampada 12v Hb4 51w 9006 Standard Osram', 114.25, 'imglanterna4.png', 'Lâmpada automotiva HB4 51W 9006 Osram, oferece excelente desempenho com maior visibilidade e um feixe de luz amplo, ideal para condições de tráfego noturno. Sua tecnologia avançada permite uma condução segura, com ótima distribuição de luz e eficiência, proporcionando maior conforto e proteção ao dirigir em diferentes condições climáticas e de estrada.', 0, 8);
CALL spInsertPeca('Lampada H4 100w 90w 12v Rallye Original Bosch Atacado', 100.00, 'imglanterna5.png', 'Lâmpada halógena H4 100W/90W 12V Rallye Bosch, oferece alta performance e durabilidade, com excelente intensidade luminosa para melhorar a visibilidade nas estradas. Ideal para motoristas que buscam uma solução robusta e potente para iluminação, proporcionando maior segurança em viagens noturnas e condições de baixa visibilidade.', 8, 8);

/*Inserção de peças - Volantes*/
CALL spInsertPeca('Volante Esportivo Chevrolet', 159.99, 'imgvolante1.png', 'Volante esportivo projetado especificamente para veículos Chevrolet, com design aerodinâmico que proporciona melhor controle e resposta durante a direção. Fabricado com materiais de alta qualidade, garantindo durabilidade e um toque de sofisticação ao interior do seu carro, além de um conforto adicional para os motoristas que buscam uma experiência mais envolvente ao dirigir.', 10, 9);
CALL spInsertPeca('Volante Esportivo Volkswagen', 187.99, 'imgvolante2.png', 'Volante esportivo de alto desempenho para veículos Volkswagen, desenvolvido com tecnologia avançada para proporcionar mais conforto, segurança e controle. Seu design ergonômico oferece uma pegada confortável e firme, ideal para motoristas que apreciam uma condução dinâmica e precisa, melhorando a resposta do carro nas curvas e durante manobras rápidas.', 20, 9);
CALL spInsertPeca('Volante Esportivo Renault', 140.00, 'imgvolante3.png', 'Volante esportivo para veículos Renault, com um design moderno e otimizado para uma pegada confortável e ergonômica. Oferece uma condução mais precisa e responsiva, melhorando a experiência de direção com um toque mais esportivo e sofisticado, ideal para motoristas que buscam performance e estilo no interior do carro.', 5, 9);
CALL spInsertPeca('Volante Racing Sparco R368 em Camurça', 2800.00, 'sparco.png', 'Volante esportivo de alto desempenho da renomada marca Sparco, modelo R368, confeccionado em camurça para uma pegada mais firme e controle preciso. Ideal para quem busca personalizar seu veículo com um volante de corrida, oferecendo um visual esportivo incomparável e uma experiência de direção intensa e profissional, tanto para carros de competição quanto para entusiastas de carros esportivos.', 0, 9);
CALL spInsertPeca('Volante Jetta Turbo', 300.00, 'jettav.png', 'Volante tradicional, mas com um toque moderno, compatível com o Volkswagen Jetta Turbo. Projetado para oferecer uma condução confortável e prática, este volante proporciona ótimo controle e uma experiência de direção suave, mantendo a identidade e o estilo do Jetta, com um design clássico que se adapta perfeitamente ao interior do veículo.', 8, 9);

/*Inserção de peças - Óleos e Lubrificantes*/
CALL spInsertPeca('Óleo de Motor Lubrax 500ml', 21.90, 'imgoleo1.png', 'Óleo de motor sintético Lubrax 500ml, desenvolvido para oferecer excelente proteção contra desgaste, corrosão e formação de lodo. Ideal para garantir o bom desempenho do motor e prolongar a vida útil do seu veículo, proporcionando eficiência e economia em cada troca de óleo.', 10, 10);
CALL spInsertPeca('Óleo de Motor Super SL GT-0IL 1L', 16.95, 'imgoleo2.png', 'Óleo de motor convencional Super SL GT-0IL 1L, com boa viscosidade para atender às necessidades de veículos que exigem proteção e desempenho. Proporciona uma excelente lubrificação e proteção do motor, ajudando a evitar o desgaste precoce e mantendo o motor funcionando de forma eficiente.', 20, 10);
CALL spInsertPeca('Óleo de Motor Ipiranga SI 1L', 28.00, 'imgoleo3.png', 'Óleo de motor sintético Ipiranga SI 1L, formulado para oferecer alta performance e proteção ao motor, especialmente em condições de alta temperatura e esforço. Proporciona uma maior durabilidade do motor, reduzindo o atrito e prevenindo o desgaste de peças móveis.', 5, 10);
CALL spInsertPeca('Óleo de Motor Havoline 1L', 28.44, 'imgoleo4.png', 'Óleo de motor sintético Havoline 1L, desenvolvido para proporcionar uma proteção superior contra desgaste, corrosão e formação de depósitos no motor. Ideal para veículos modernos, garantindo eficiência na lubrificação e prolongando a vida útil do motor.', 0, 10);
CALL spInsertPeca('Óleo de Motor Mobil 20w50 1L', 29.89, 'imgoleo5.png', 'Óleo de motor Mobil 20w50 1L, sintético de alta performance, projetado para oferecer proteção avançada aos motores modernos contra desgaste, corrosão e altas temperaturas. Sua fórmula avançada proporciona uma lubrificação eficaz, maximizando a eficiência do motor e melhorando sua durabilidade.', 8, 10);

/*Inserção de peças - Escapamentos*/
CALL spInsertPeca('Escapamento de Carro Fiat', 254.90, 'imgescap1.png', 'Escapamento original de alta qualidade para carros Fiat, projetado para garantir excelente desempenho, durabilidade e menor emissão de ruídos. Ideal para quem busca manter a integridade e a eficiência do sistema de escape do veículo.', 12, 11);
CALL spInsertPeca('Escapamento Intermediário Meriva', 190.24, 'imgescap2.png', 'Escapamento intermediário para Meriva, desenvolvido para otimizar o desempenho do motor e reduzir significativamente os ruídos, garantindo uma condução mais silenciosa e eficiente. A solução ideal para quem busca melhorar a performance do seu veículo.', 3, 11);
CALL spInsertPeca('Escapamento Silencioso Traseiro', 155.99, 'imgescap3.png', 'Escapamento silencioso traseiro para Gol G5 8v, projetado para reduzir ruídos indesejados e melhorar a eficiência do sistema de escape, proporcionando uma condução mais tranquila, confortável e com desempenho otimizado.', 0, 11);
CALL spInsertPeca('Escapamento Silencioso Traseiro', 132.19, 'imgescap4.png', 'Escapamento silencioso traseiro para Palio 1.0 a 1.4, com tecnologia de redução de ruídos, promovendo uma experiência de condução mais silenciosa e eficiente, além de melhorar o desempenho do sistema de escape e garantir durabilidade ao longo do tempo.', 17, 11);
CALL spInsertPeca('Escapamento Silencioso Traseiro Doblô', 182.85, 'imgescap5.png', 'Escapamento silencioso traseiro para Fiat Doblô, desenvolvido para reduzir ruídos e melhorar a eficiência do sistema de escape, garantindo uma condução mais confortável e tranquila, além de aumentar a performance do veículo.', 10, 11);

/*Inserção de peças - Radiadores*/
CALL spInsertPeca('Radiador - Fire - Palio Siena Strada Idea - Eurus', 539.91, 'imgradiador1.png', 'Radiador dianteiro de alta qualidade para Fiat Palio, Siena, Strada, Idea, modelo Fire. Fabricado pela Notus, proporciona excelente performance no resfriamento do motor, garantindo maior eficiência e durabilidade ao sistema de arrefecimento do veículo.', 10, 12);
CALL spInsertPeca('Radiador Fiat Fiorino / Uno 1.0 / 1.5 / 1.6 8v Com Ou Sem Ar', 588.80, 'imgradiador2.png', 'Radiador compatível com Fiat Fiorino e Uno 1.0, 1.5 e 1.6 8v, disponível para modelos com ou sem ar condicionado. Fabricado pela Procooler, este radiador oferece ótimo desempenho no resfriamento do motor, garantindo a eficiência e durabilidade do sistema de arrefecimento.', 20, 12);
CALL spInsertPeca('Radiador de Óleo de alta Performance 700ml', 1390.00, 'imgradiador3.png', 'Radiador de óleo de alta performance, com colmeia brasada e material em alumínio, desenvolvido para oferecer excelente capacidade de resfriamento e durabilidade. Com capacidade de 700 ml, é ideal para sistemas de alto desempenho que exigem máxima eficiência no controle de temperatura.', 10, 12);
CALL spInsertPeca('Grade de radiador', 6181.73, 'imgradiador4.png', 'Grade de radiador com luz para o tanque 500, projetada para pára-choques dianteiro e máscara da grade. Fabricada pela Reit, esta grade oferece um design elegante e funcionalidade aprimorada, garantindo maior proteção ao sistema de arrefecimento e uma estética esportiva ao veículo.', 20, 12);
CALL spInsertPeca('Radiador de Água CR 2448', 518.89, 'imgradiador5.png', 'Radiador de água modelo CR 2448, projetado para oferecer excelente desempenho no resfriamento do motor, ajudando a manter a temperatura ideal para o funcionamento do veículo. Ideal para sistemas de arrefecimento eficientes e duráveis, garantindo o desempenho e a longevidade do motor.', 5, 12);


-- insert dos produtos em ofertas
CALL spInsertPeca('Motor Completo Subaru Forester', 2400.41, 'imgmotoroferta1.png', 'Motor completo para Subaru Forester, projetado para proporcionar desempenho excepcional. Inclui cabeçote, pistão, biela, virabrequim e outros componentes essenciais para garantir potência, confiabilidade e durabilidade ao seu veículo.', 5, 2);
CALL spInsertPeca('Motor Parcial L200 2011', 9600.00, 'imgmotoroferta2.png', 'Motor parcial para Mitsubishi L200 2011, 1.4 8V a gasolina. Inclui cabeçote, pistão, biela, virabrequim e outros componentes de alta qualidade, garantindo desempenho superior e confiabilidade para o seu veículo.', 5, 2);
CALL spInsertPeca('Pneu Esportivo 255X65R16 110H Scorpion', 1399.90, 'imgpneuoferta.png', 'Pneu esportivo Scorpion 255/65R16 110H, projetado para oferecer excelente performance em diversas condições de terreno. Com alta resistência e estabilidade, é ideal para quem busca maior controle e segurança ao dirigir.', 5, 1);
CALL spInsertPeca('Pneu 255X65R17 110H Scorpion', 1899.90, 'imgpneuoferta2.png', 'Pneu Scorpion 255/65R17 110H, desenvolvido para proporcionar ótimo desempenho em terrenos variados. Oferece resistência superior, alta estabilidade e controle, garantindo uma condução segura e confortável em todas as situações.', 5, 1);
CALL spInsertPeca('Servo Freio TOYOTA HILUX', 499.90, 'imgfreiooferta.png', 'Servo freio para Toyota Hilux, projetado para proporcionar maior eficiência no sistema de frenagem. Com alta qualidade e desempenho confiável, garante segurança adicional ao seu veículo, melhorando a resposta ao acionamento dos freios.', 5, 6);

select * from tbPeca;
describe tbcliente;
select * from tbcliente;
select * from tbCategoria;
-- procedure para insrir registro de carrinho --
drop procedure spInsertPagamento;

DELIMITER //

CREATE PROCEDURE spInsertPagamento (
    IN pPedidoId INT,
    IN pValorPago DECIMAL(8,2),
    IN pDataPagamento DATETIME,
	IN pTipoPagamento VARCHAR(50),
    IN pNomeTitular VARCHAR(60) 	,
    IN pBandeiraCartao VARCHAR(30),
    IN pNumeroCartao NUMERIC(16),
    IN pCVV NUMERIC(3),
    IN pDataValidade CHAR(5)  -- Novo parâmetro para DataValidade
)
BEGIN
    -- Verificar se o PedidoId informado existe na tabela tbPedido
    IF NOT EXISTS (SELECT 1 FROM tbPedido WHERE PedidoId = pPedidoId) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'PedidoId informado não existe na tabela tbPedido.';
    END IF;

    -- Inserir na tabela tbPagamento
    INSERT INTO tbPagamento (
        PedidoId, ValorPago, DataPagamento, StatusPagamento,
        TipoPagamento, NomeTitular, BandeiraCartao, NumeroCartao, CVV, DataValidade
    ) VALUES (
        pPedidoId, pValorPago, pDataPagamento, 'Finalizado',
        pTipoPagamento, pNomeTitular, pBandeiraCartao, pNumeroCartao, pCVV, pDataValidade
    );
    
    UPDATE tbPedido
        SET StatusPedido = 'Confirmado'
        WHERE PedidoId = pPedidoId;
END //

DELIMITER ;

call spInsertPagamento(1, 1400, NOW(), 'Débito', 'Clayton', 'MasterCard', 5519915703964942, 832, '01/09');
select * from tbpedido;
select * from tbItemPedido;
select * from tbPagamento;
describe tbpagamento;
select * from tbCliente;


CALL spInsertPagamento(
    1,                     -- PedidoId
    100.50,                -- ValorPago
    NOW(),                 -- DataPagamento            -- StatusPagamento
    'Cartão de Crédito',   -- TipoPagamento
    'João Silva',          -- NomeCartao
    'Visa',                -- BandeiraCartao
    1234567812345678,      -- NumeroCartao
    123                   -- CVV
);


select * from tbpedido;


select * from  tbcarrinhocompra;
SELECT PecaId, QtdPeca, ValorPeca FROM tbCarrinhoCompra WHERE ClienteId = @ClienteId;

select * from TbPagamento;




describe tbCliente;
describe tblogin;
select * from tbCliente where email = 'pdro@gmail.com' and senhausu = 'pedrosenha';
select * from tblogin;
select * from tbCliente;

DROP PROCEDURE IF EXISTS spAtualizaCliente;
DELIMITER $$

CREATE PROCEDURE spAtualizaCliente(
    IN vEmail VARCHAR(100),
    IN vSenhaUsu VARCHAR(50),
    IN vTelefone BIGINT,
    IN vNumEnd SMALLINT,
    IN vCompEnd VARCHAR(50),
    IN vLogradouro VARCHAR(50),
    IN vCEP DECIMAL(8, 0),
    IN vDataNasc DATE
)
BEGIN
    DECLARE vClienteStatus BOOLEAN;
    DECLARE vCPF DECIMAL(11);

    -- Verifica se o cliente existe com base no email
    IF EXISTS (SELECT CPF FROM tbCliente WHERE Email = vEmail) THEN
        -- Pega o CPF do cliente para usar nas outras atualizações
        SET vCPF = (SELECT CPF FROM tbCliente WHERE Email = vEmail);

        -- Pega o status atual do cliente para preservá-lo
        SET vClienteStatus = (SELECT Cliente_Status FROM tbCliente WHERE CPF = vCPF);

        -- Atualiza os dados do cliente (somente os campos permitidos: telefone, senha, complemento, logradouro, CEP e data de nascimento)
        UPDATE tbCliente
        SET 
            SenhaUsu = vSenhaUsu,       -- Atualiza a senha
            Telefone = vTelefone,       -- Atualiza o telefone
            NumEnd = vNumEnd,           -- Atualiza o número de endereço
            CompEnd = vCompEnd,         -- Atualiza o complemento de endereço
            Logradouro = vLogradouro,   -- Atualiza o logradouro
            CEP = vCEP,                 -- Atualiza o CEP
            DataNasc = vDataNasc        -- Atualiza a data de nascimento
        WHERE CPF = vCPF;

        -- Atualiza a tabela de Login (somente a senha, não o email)
        UPDATE TbLogin
        SET 
            SenhaUsu = vSenhaUsu
        WHERE ClienteId = (SELECT ClienteId FROM tbCliente WHERE CPF = vCPF);

        -- Mensagem de sucesso
        SELECT 'Cliente atualizado com sucesso!' AS Mensagem;
    ELSE
        -- Caso o cliente não exista
        SELECT 'Cliente não encontrado!' AS Mensagem;
    END IF;
END $$

DELIMITER ;



select * from tbCliente;
describe tbcliente;


SELECT *
FROM tbCarrinhoCompra
INNER JOIN tbPeca on tbCarrinhoCompra.PecaId = tbPeca.PecaId
WHERE ClienteId = 1;



select * from tbpedido;
select * from tbitempedido;
select * from tbCarrinhoCompra;
describe tbCarrinhoCompra;
delimiter $$
create procedure spObterCarrinhoId(clientId int)
begin
select * from tbCarrinhoCompra where ClienteId = clientId;
end $$
CarrinhoId, QtdPeca, ClienteId,PecaId
call spObterCarrinhoId(1);
select CarrinhoId, QtdPeca, tbCarrinhoCompra.ClienteId, tbCliente.NomeCli, tbCarrinhoCompra.PecaId, tbPeca.NomePeca from tbCarrinhoCompra inner join tbCliente on tbCarrinhoCompra.ClienteId = tbCliente.ClienteId inner join tbPeca on tbCarrinhoCompra.PecaId = tbPeca.PecaId;

select tbPedido.PedidoId, datapedido, tbPedido.ClienteId, StatusPedido, ItemPedidoId, QtdPeca, ValorUnitario, ValorTotal, tbPeca.NomePeca, tbCliente.NomeCli, PagamentoId, ValorPago, DataPagamento, StatusPagamento, TipoPagamento, NomeTitular, BandeiraCartao, NumeroCartao, CVV, DataValidade from tbPedido inner join tbitempedido on tbPedido.PedidoId = tbitempedido.PedidoId inner join tbpeca on tbitempedido.pecaid = tbpeca.pecaid inner join tbCliente on tbpedido.clienteid = tbcliente.clienteid inner join tbPagamento on tbPedido.PedidoId = tbPagamento.PedidoId;
select * from tbPedido;
describe tbpagamento;
select * from tbPagamento;
drop procedure spInsertPedido;

DELIMITER $$
CREATE PROCEDURE spInsertPedido(
    IN vClienteId INT,  -- ClienteId como chave norteadora
    IN vStatusPedido VARCHAR(50), -- Status do pedido
    OUT vPedidoId INT -- Declaração de variáveis
)
BEGIN
    -- Verifica se o Carrinho existe
    IF NOT EXISTS (
        SELECT 1
        FROM tbCarrinhoCompra
        WHERE ClienteId = vClienteId
    ) THEN
        SELECT 'Erro: Carrinho não encontrado' AS mensagem;
    ELSE
        -- Insere um novo pedido para o cliente
        INSERT INTO tbPedido (DataPedido, ClienteId, StatusPedido)
        VALUES (NOW(), vClienteId, vStatusPedido);

        -- Recupera o ID do pedido recém-criado
        SET vPedidoId = LAST_INSERT_ID();

        -- Insere os itens do carrinho na tbItemPedido
        INSERT INTO tbItemPedido (PedidoId, PecaId, QtdPeca, ValorUnitario, ValorTotal)
        SELECT 
            vPedidoId, 
            cc.PecaId, 
            cc.QtdPeca, 
            p.ValorPeca, 
            (cc.QtdPeca * p.ValorPeca)
        FROM 
            tbCarrinhoCompra cc
        JOIN 
            tbPeca p ON cc.PecaId = p.PecaId
        WHERE 
            cc.ClienteId = vClienteId;
		 
         -- deleta os itens do carrinho
         DELETE FROM tbCarrinhoCompra
		 WHERE ClienteId = vClienteId;
        
		 -- subtrai estoque
         UPDATE TbPeca p
         INNER JOIN tbItemPedido ip ON p.PecaId = ip.PecaId
		 SET p.qtd_estoque = p.qtd_estoque - ip.QtdPeca
		 WHERE p.Pecaid = ip.PecaId and ip.PedidoId = vPedidoId;

    END IF;
END $$

DELIMITER ;
   
SELECT *
FROM tbCarrinhoCompra
INNER JOIN tbPeca on tbCarrinhoCompra.PecaId = tbPeca.PecaId
WHERE ClienteId = 1;
CALL spInsertPedido(1, 'Pendente');

select *
from tbpedido 
inner join tbitempedido on tbpedido.pedidoid = tbitempedido.pedidoid 
inner join tbPeca on tbitempedido.PecaId = tbpeca.pecaid
where tbpedido.pedidoid = 22;
  describe tbpedido;
select * from tbpedido where ClienteId = 1 order by PedidoId desc;
select * from tbcarrinhocompra;
select * from tbitempedido;
select * from tbPeca;
select * from tbPagamento;
describe tbpedido;
describe tbpeca;
describe tbcarrinhocompra;