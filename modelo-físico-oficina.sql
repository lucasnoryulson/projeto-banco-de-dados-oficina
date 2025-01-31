-- Criacao do banco de dados para a oficina
CREATE DATABASE IF NOT EXISTS oficina;
USE oficina;

-- Criacao da tabela Cliente (Pessoa Física e Jurídica)
CREATE TABLE clients (
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    CPF CHAR(11) UNIQUE,
    CNPJ CHAR(14) UNIQUE,
    address VARCHAR(255) NOT NULL,
    phone CHAR(11) NOT NULL,
    email VARCHAR(100) UNIQUE,
    CHECK ((CPF IS NOT NULL AND CNPJ IS NULL) OR (CNPJ IS NOT NULL AND CPF IS NULL))
);

-- Criacao da tabela Veículo
CREATE TABLE vehicles (
    idVehicle INT AUTO_INCREMENT PRIMARY KEY,
    plate VARCHAR(10) UNIQUE NOT NULL,
    brand VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year INT NOT NULL,
    idClient INT NOT NULL,
    FOREIGN KEY (idClient) REFERENCES clients(idClient) ON DELETE CASCADE
);

-- Criacao da tabela Serviços
CREATE TABLE services (
    idService INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(255) NOT NULL,
    price FLOAT NOT NULL
);

-- Criacao da tabela Ordem de Serviço
CREATE TABLE work_orders (
    idWorkOrder INT AUTO_INCREMENT PRIMARY KEY,
    idVehicle INT NOT NULL,
    idClient INT NOT NULL,
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Aberta', 'Em andamento', 'Finalizada', 'Cancelada') DEFAULT 'Aberta',
    FOREIGN KEY (idVehicle) REFERENCES vehicles(idVehicle) ON DELETE CASCADE,
    FOREIGN KEY (idClient) REFERENCES clients(idClient) ON DELETE CASCADE
);

-- Relacionamento M:N entre Ordem de Serviço e Serviços
CREATE TABLE work_order_services (
    idWorkOrder INT NOT NULL,
    idService INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    PRIMARY KEY (idWorkOrder, idService),
    FOREIGN KEY (idWorkOrder) REFERENCES work_orders(idWorkOrder) ON DELETE CASCADE,
    FOREIGN KEY (idService) REFERENCES services(idService) ON DELETE CASCADE
);

-- Criacao da tabela Funcionários
CREATE TABLE employees (
    idEmployee INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    role ENUM('Mecânico', 'Atendente', 'Gerente') NOT NULL,
    salary FLOAT NOT NULL,
    phone CHAR(11) NOT NULL,
    email VARCHAR(100) UNIQUE
);

-- Relacionamento M:N entre Ordem de Serviço e Funcionários
CREATE TABLE work_order_employees (
    idWorkOrder INT NOT NULL,
    idEmployee INT NOT NULL,
    PRIMARY KEY (idWorkOrder, idEmployee),
    FOREIGN KEY (idWorkOrder) REFERENCES work_orders(idWorkOrder) ON DELETE CASCADE,
    FOREIGN KEY (idEmployee) REFERENCES employees(idEmployee) ON DELETE CASCADE
);

-- Criacao da tabela Pagamentos
CREATE TABLE payments (
    idPayment INT AUTO_INCREMENT PRIMARY KEY,
    idWorkOrder INT NOT NULL,
    paymentMethod ENUM('Cartão', 'Dinheiro', 'Pix', 'Boleto') NOT NULL,
    totalAmount FLOAT NOT NULL,
    paymentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (idWorkOrder) REFERENCES work_orders(idWorkOrder) ON DELETE CASCADE
);

-- Queries para análise de dados

-- Quantidade de serviços realizados por cada mecânico
SELECT e.name AS Mecânico, COUNT(we.idWorkOrder) AS Servicos_Realizados
FROM employees e
JOIN work_order_employees we ON e.idEmployee = we.idEmployee
WHERE e.role = 'Mecânico'
GROUP BY e.name
ORDER BY Servicos_Realizados DESC;

-- Quantidade de ordens de serviço abertas por cliente
SELECT c.name AS Cliente, COUNT(wo.idWorkOrder) AS Ordens_Abertas
FROM clients c
JOIN work_orders wo ON c.idClient = wo.idClient
WHERE wo.status = 'Aberta'
GROUP BY c.name
ORDER BY Ordens_Abertas DESC;

-- Faturamento total por mês
SELECT YEAR(paymentDate) AS Ano, MONTH(paymentDate) AS Mes, SUM(totalAmount) AS Faturamento
FROM payments
GROUP BY YEAR(paymentDate), MONTH(paymentDate)
ORDER BY Ano DESC, Mes DESC;

-- Lista de clientes que gastaram mais de R$ 5000,00 na oficina
SELECT c.name AS Cliente, SUM(p.totalAmount) AS TotalGasto
FROM clients c
JOIN work_orders wo ON c.idClient = wo.idClient
JOIN payments p ON wo.idWorkOrder = p.idWorkOrder
GROUP BY c.name
HAVING TotalGasto > 5000
ORDER BY TotalGasto DESC;
