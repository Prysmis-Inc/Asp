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
    IN p_categoriaid INT,
    IN p_nomecategoria VARCHAR(150),
    IN p_img varchar(255)
)
BEGIN
    INSERT INTO tbCategoria (categoriaid, nomeCategoria, img_categoria)
    VALUES (p_categoriaid, p_nomecategoria, p_img);
END $$



CALL spInsertCategoria(1, 'Fabricante A', 'imagem1'); -- generico 
CALL spInsertCategoria(2, 'Fabricante B', 'imagem2'); -- generico 
CALL spInsertCategoria(3, 'Fabricante C', 'imagem3'); -- generico 



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

call spInsertPeca('Carburador Marea', 220, 'img_carb_marea.jpg', 'Carburador para Fiat Marea 2.5',5,1); -- pros outros calls tem q ser nesse pique
/*call spInsertPeca('Carburador Gol', 700,'WolksWagen', 'Carburadores', 'img_carb_gol.jpg', 'Carburador para Wolkswagen Gol 1000',10);
call spInsertPeca('Carburador Gol 1.6', 700,'WolksWagen', 'Carburadores', 'img_carb_gol1_6.jpg', 'Carburador para Wolkswagen Gol 1.6',0);*/

select * from tbPeca

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

select * from tbpeca

call spInsertCarrinhoCompras('Carburador Marea', 1, 220.00,1, 1);
call spInsertCarrinhoCompras('Carburador Marea', 1, 660.00, 4, 1);
call spInsertCarrinhoCompras('Carburador Marea', 2, 660.00, 3, 1);
call spInsertCarrinhoCompras('Carburador Marea',2, 1500.00, 1, 1);

select * from TbCarrinhoCompra;
select * from TbCliente;
select * from tbpeca

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


