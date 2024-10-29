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
Logradouro varchar(200) not null,
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
cliente_status boolean,
foreign key (CEP) references tbEndereco (CEP)
);

create table tbLogin (
LoginId int primary key auto_increment,      
Email varchar(100) not null unique,          
SenhaUsu varchar(50) not null,                
Cliente_Status boolean not null,              
ClienteId int not null,                       
foreign key (ClienteId) references tbCliente (ClienteId) -- Referência à tabela tbCliente
);



create table tbPeca(
PecaId int primary key auto_increment,
NomePeca varchar(100) not null,
ValorPeca decimal(8,2) not null,
fabricante varchar(150) not null,
categoria varchar(30) not null,
img_peca varchar (255) not null,
descricao varchar (200) not null,
qtd_estoque int not null
); 

create table tbCarrinhoCompra(
CarrinhoId int primary key auto_increment,
ProdutosSelecionados varchar(200) not null,
ProdutosSelecionados1 varchar(200) null,
ProdutosSelecionados2 varchar(200) null,
ProdutosSelecionados3 varchar(200) null,
ProdutosSelecionados4 varchar(200) null,
QtdPeca int not null,
ValorTotalCompra decimal(8,2) not null,
ClienteId int not null,
PecaId int not null,
PecaId1 int null,
PecaId2 int null,
PecaId3 int null,
PecaId4 int null,

Foreign key (ClienteId) references tbCliente(ClienteId),
foreign key (PecaId) references tbPeca(PecaId),
foreign key (PecaId1) references tbPeca(PecaId),
foreign key (PecaId2) references tbPeca(PecaId),
foreign key (PecaId3) references tbPeca(PecaId),
foreign key (PecaId4) references tbPeca(PecaId)
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

-- trigger para gerenciar o estoque --
DELIMITER $$

create trigger AtualizaEstoque
after insert on TbPedido
for each row
begin
    declare vQtdEstoqueAtual int;

    -- Atualiza a quantidade de estoque das peças do carrinho
    update TbPeca p
    join TbCarrinhoCompra c on c.PecaId = p.PecaId
    set p.qtd_estoque = p.qtd_estoque - c.QtdPeca
    where c.CarrinhoId = new.CarrinhoId
    and (select @vQtdEstoqueAtual := p.qtd_estoque) >= c.QtdPeca;

    -- Verifica se a atualização foi bem-sucedida
    if row_count() = 0 then
        -- Se não houver estoque suficiente, restaura a quantidade
        update TbPeca p
        join TbCarrinhoCompra c on c.PecaId = p.PecaId
        set p.qtd_estoque = p.qtd_estoque + c.QtdPeca
        where c.CarrinhoId = new.CarrinhoId;
        
    end if;
end $$

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
create procedure spInsertTbEndereco( vCEP decimal(8,0), vLogradouro varchar(200), vBairro varchar(200), vCidade varchar(200), vUF varchar(2))
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

insert into tbendereco(CEP, Logradouro, BairroId, CidadeId, UFId) values(vCEP, vLogradouro, vBairroId, vCidadeId, vUFId);
end if;
end $$

call spInsertTbEndereco(12345678, 'Rua da Federal', 'Lapa', 'São Paulo','SP');
call spInsertTbEndereco(12345051, 'Av Brasil', 'Lapa', 'Campinas','SP');
call spInsertTbEndereco(12345052, 'Rua Liberdade', 'Consolação', 'São Paulo','SP');
call spInsertTbEndereco(12345053, 'Av Paulista', 'Penha', 'Rio de Janeiro','RJ');
call spInsertTbEndereco(12345054, 'Rua Ximbú', 'Penha', 'Rio de Janeiro','RJ');
call spInsertTbEndereco(12345055, 'Rua Piu XI', 'Penha', 'Campinas','SP');
call spInsertTbEndereco(12345056, 'Rua Chocolate', 'Aclimação', 'Barra Mansa','RJ');
call spInsertTbEndereco(12345057, 'Rua Pão na Chapa', 'Barra Funda', 'Ponta Grossa','RS');

select * from tbEndereco;
 
 -- procedure para inserir registro de cliente e verificar se ele já existe no sitema --
DELIMITER $$ 

create procedure spInsertCliente(
vNomeCli varchar(100), vCPF decimal(11), vEmail varchar(100), vSenhaUsu varchar(50), vDataNasc date, vTelefone bigint, vNumEnd smallint, vCompEnd varchar(50), vCEP decimal(8, 0), vClienteStatus boolean, vLogradouro varchar(200), vBairro varchar(200), vCidade varchar(200), vUF char(2)
) 
begin
    declare vClienteId int;
    declare vBairroId int;
    declare vCidadeId int;
    declare vUFId int;

    -- Verifica se o CPF já existe --
    if exists (select CPF from tbCliente where CPF = vCPF) then
        -- Caso ele exista, exibe a seguinte mensagem: --
        select 'Cliente já existe!' AS Mensagem;
    else
        -- Verifica se o endereço já existe. --
        if not exists (select * from tbEndereco where CEP = vCEP) then
            -- Se não existir, insere o endereço. --
            -- Verifica se o bairro existe, se não existir, insere. --
            if not exists (select * from tbBairro where Bairro = vBairro) then
                insert into tbBairro (Bairro) values (vBairro);
            end if;

            -- Busca o Id do bairro e armazena na variável vBairroId. --
            set vBairroId = (select BairroId from tbBairro where Bairro = vBairro);

            -- Verifica se a cidade existe, se não existir, insere. --
            if not exists (select * from tbCidade where Cidade = vCidade) then
                insert into tbCidade (Cidade) values (vCidade);
            end if;

            -- Busca o Id da cidade e armazena na variável vCidadeId. --
            set vCidadeId = (select CidadeId from tbCidade where Cidade = vCidade);

            -- Verifica se o Estado existe, se não existir, insere. --
            if not exists (select * from tbEstado where UF = vUF) then
                insert into tbEstado (UF) values (vUF);
            end if;

            -- Busca o Id do UF e armazena na variável vUFId. --
            set vUFId = (select UFId from tbEstado where UF = vUF);

            -- Insere os registros na tbEndereco. --
            insert into tbEndereco (Logradouro, BairroId, CidadeId, UFId, CEP)
            values (vLogradouro, vBairroId, vCidadeId, vUFId, vCEP);
        end if;

        -- Insere os registros do cliente na tbCliente. -- 
        insert into tbCliente 
            (NomeCli, CPF, Email, SenhaUsu, DataNasc, Telefone, NumEnd, CompEnd, CEP, Cliente_Status) 
        values 
            (vNomeCli, vCPF, vEmail, vSenhaUsu, vDataNasc, vTelefone, vNumEnd, vCompEnd, vCEP, vClienteStatus);
        
        -- Pega o último Id inserido e armazena na variável vClienteId. --
        set vClienteId = LAST_INSERT_ID();

        -- Insere os registros na tbLogin, usando o ClienteId obtido. --
        insert into TbLogin (Email, SenhaUsu, Cliente_Status, ClienteId) 
        values (vEmail, vSenhaUsu, vClienteStatus, vClienteId);
    end if;
end $$

call spInsertCliente('renan', 12345212350, 'pdro@gmail.com', 'pedrosenha', '1989-01-28', 11940028922, 192, 'apto 1', 12345051, 1, 'Av Brasil', 'lapa', 'Campinas', 'SP');
call spInsertCliente('jeferson', 12345212351, 'pedro@gmail.com', 'pedrosenha', '1989-01-28', 11940028922, 194, 'apto 1', 12345051, 1, 'Av Brasil', 'lapa', 'Campinas', 'SP');
call spInsertCliente('João Vitor', 12345212355, 'pedr@gmail.com', 'pedrosenha', '1989-01-28', 11940028922, 194, 'apto 1', 12345099, 1, 'Rua Pequena', 'barueri', 'São Paulo', 'SP');
call spInsertCliente('Clayton', 12345212377, 'clayton@gmail.com', 'claytonsenha', '1989-01-28', 11940028933, 196, 'apto 15', 12345456, 0, 'Rua Campo Grande', 'Balneário Camboriú', 'São Paulo', 'SP');

select * from tbcidade;
select * from tbbairro;
select * from tbendereco;
select * from tbcliente;
select * from tblogin;

delimiter $$
create procedure spInsertPeca(vNomePeca varchar(100), vValorPeca decimal(8,2), vFabricante varchar(150), vCategoria varchar(30), vImgPeca varchar(255), vDescricao varchar(200), vQtdEstoque int)
begin
    declare contador int;
    select COUNT(*) into contador from tbPeca where NomePeca = vNomePeca and ValorPeca = vValorPeca and Fabricante = vFabricante and Categoria = vCategoria;

    if contador > 0 then select 'Peça já registrada' as mensagem;
    else
        insert into tbPeca (NomePeca, ValorPeca, Fabricante, Categoria, img_peca, descricao, qtd_estoque) values (vNomePeca, vValorPeca, vFabricante, vCategoria, vImgPeca, vDescricao, vQtdEstoque);
    end if;
end $$

call spInsertPeca('Carburador Marea', 220,'Fiat', 'Carburadores', 'img_carb_marea.jpg', 'Carburador para Fiat Marea 2.5',5);
call spInsertPeca('Carburador Gol', 700,'WolksWagen', 'Carburadores', 'img_carb_gol.jpg', 'Carburador para Wolkswagen Gol 1000',10);
call spInsertPeca('Carburador Gol 1.6', 700,'WolksWagen', 'Carburadores', 'img_carb_gol1_6.jpg', 'Carburador para Wolkswagen Gol 1.6',0);
call spInsertPeca('Kit Turbina', 2000,'Holsett', 'turbos', 'img_carb_gol1_6.jpg', 'Kit Turbo Padaria',2);

select * from tbPeca


-- procedure para insrir registro de carrinho --
DELIMITER $$

CREATE PROCEDURE spInsertCarrinhoCompras(
    IN vProdutosSelecionados VARCHAR(200),
    IN vProdutosSelecionados1 VARCHAR(200),
    IN vProdutosSelecionados2 VARCHAR(200),
    IN vProdutosSelecionados3 VARCHAR(200),
    IN vProdutosSelecionados4 VARCHAR(200),
    IN vQtdPeca INT,
    IN vValorTotalCompra DECIMAL(8,2),
    IN vClienteId INT,
    IN vPecaId INT,
    IN vPecaId1 INT,
    IN vPecaId2 INT,
    IN vPecaId3 INT,
    IN vPecaId4 INT
)
BEGIN
    -- Verifica se o cliente existe
    IF NOT EXISTS (SELECT 1 FROM tbCliente WHERE ClienteId = vClienteId) THEN
        SELECT 'Cliente não encontrado' AS mensagem;

    -- Verifica se o produto principal existe e se há estoque suficiente
    ELSEIF NOT EXISTS (SELECT 1 FROM tbPeca WHERE PecaId = vPecaId AND qtd_estoque >= vQtdPeca) THEN
        SELECT 'Produto principal não encontrado ou estoque insuficiente' AS mensagem;

    -- Verifica o produto 1 se vPecaId1 não for NULL
    ELSEIF vPecaId1 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM tbPeca WHERE PecaId = vPecaId1 AND qtd_estoque >= vQtdPeca) THEN
        SELECT 'Produto 1 não encontrado ou estoque insuficiente' AS mensagem;

    -- Verifica o produto 2 se vPecaId2 não for NULL
    ELSEIF vPecaId2 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM tbPeca WHERE PecaId = vPecaId2 AND qtd_estoque >= vQtdPeca) THEN
        SELECT 'Produto 2 não encontrado ou estoque insuficiente' AS mensagem;

    -- Verifica o produto 3 se vPecaId3 não for NULL
    ELSEIF vPecaId3 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM tbPeca WHERE PecaId = vPecaId3 AND qtd_estoque >= vQtdPeca) THEN
        SELECT 'Produto 3 não encontrado ou estoque insuficiente' AS mensagem;

    -- Verifica o produto 4 se vPecaId4 não for NULL
    ELSEIF vPecaId4 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM tbPeca WHERE PecaId = vPecaId4 AND qtd_estoque >= vQtdPeca) THEN
        SELECT 'Produto 4 não encontrado ou estoque insuficiente' AS mensagem;

    ELSE
        -- Insere o carrinho de compras com múltiplos produtos
        INSERT INTO tbCarrinhoCompra (
            ProdutosSelecionados, ProdutosSelecionados1, ProdutosSelecionados2, 
            ProdutosSelecionados3, ProdutosSelecionados4, QtdPeca, ValorTotalCompra, 
            ClienteId, PecaId, PecaId1, PecaId2, PecaId3, PecaId4
        )
        VALUES (
            vProdutosSelecionados, vProdutosSelecionados1, vProdutosSelecionados2, 
            vProdutosSelecionados3, vProdutosSelecionados4, vQtdPeca, vValorTotalCompra, 
            vClienteId, vPecaId, vPecaId1, vPecaId2, vPecaId3, vPecaId4
        );

        -- Atualiza o estoque de cada peça se o ID não for NULL
        UPDATE tbPeca
        SET qtd_estoque = qtd_estoque - vQtdPeca
        WHERE PecaId = vPecaId;

        IF vPecaId1 IS NOT NULL THEN
            UPDATE tbPeca
            SET qtd_estoque = qtd_estoque - vQtdPeca
            WHERE PecaId = vPecaId1;
        END IF;

        IF vPecaId2 IS NOT NULL THEN
            UPDATE tbPeca
            SET qtd_estoque = qtd_estoque - vQtdPeca
            WHERE PecaId = vPecaId2;
        END IF;

        IF vPecaId3 IS NOT NULL THEN
            UPDATE tbPeca
            SET qtd_estoque = qtd_estoque - vQtdPeca
            WHERE PecaId = vPecaId3;
        END IF;

        IF vPecaId4 IS NOT NULL THEN
            UPDATE tbPeca
            SET qtd_estoque = qtd_estoque - vQtdPeca
            WHERE PecaId = vPecaId4;
        END IF;

        SELECT 'Carrinho inserido com sucesso' AS mensagem;
    END IF;
END $$

CALL spInsertCarrinhoCompras(
    'Carburador Gol', 'Carburador Marea', NULL, NULL, NULL, 5, 7000.00, 1, 2, 1, NULL, NULL, NULL
);
call spInsertCarrinhoCompras('Carburador Marea', 1, 660.00, 4, 1);
call spInsertCarrinhoCompras('Carburador Marea', 2, 660.00, 3, 1);
call spInsertCarrinhoCompras('Carburador Marea',2, 1500.00, 1, 1);



describe tbpeca;
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
call spInsertPedidos('2024-10-15','2 Laptop Mouse', 2,'dinheiro');
select * from tbcarrinhocompra;
select * from tbpeca


-- procedure para inserir na tabela pagamento e puxar as informações através do id do pedido --
delimiter $$ 
create procedure spInsertPagamento(
    vPedidoId int, 
    vValorPago decimal(8,2), 
    vDataPagamento datetime, 
    vStatusPagamento varchar(50)
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

            -- Atualiza a coluna TipoPagamento na tbPedido --
            update TbPedido
            set TipoPagamento = 'Cartão de Crédito' -- podendo ser passado como parâmetro -- 
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

call spInsertPagamento(1, 7000.00, '2024-10-20 12:00:00', 'Aprovado');
call spInsertPagamento(2, 7000.00, '2024-10-20 12:00:00', 'Aprovado');


-- procedure de inserir na Nota Fiscal --

delimiter $$
create procedure spInsertNotaFiscal(vPedidoId int)
begin
    declare vProdutos varchar(500);
    declare vDataEmissao datetime;
    declare vValorTotal decimal(8,2);

    -- Verifica se o pedido existe
    if not exists (select 1 from tbPedido where PedidoId = vPedidoId) THEN
        signal sqlstate '45000' set message_text = 'Erro: Pedido não encontrado';
    end if;

    -- Verifica se o pagamento foi realizado para o pedido
    if not exists (select 1 from tbPagamento where PedidoId = vPedidoId) then
        signal sqlstate '45000' set message_text = 'Erro: Pagamento não encontrado para este pedido';
    end if;

    -- Busca informações do pedido
    select InfoPedido, NOW(), ValorTotal into vProdutos, vDataEmissao, vValorTotal
    from tbPedido
    where PedidoId = vPedidoId;

    -- Insere dados na tbNota_Fiscal (NF será gerado automaticamente)
    insert into tbNota_Fiscal (Produtos, DataEmissao, ValorTotal, PedidoId)
    values (vProdutos, vDataEmissao, vValorTotal, vPedidoId);

    select 'Nota Fiscal criada com sucesso!' as Mensagem;
end $$

call spInsertNotaFiscal(2);  -- dentro dos () tem que colocar o id de um pedido existente para poder "Puxar" as informações
select * from tbnota_fiscal;
select * from tbpedido;

select * from TbPagamento;



