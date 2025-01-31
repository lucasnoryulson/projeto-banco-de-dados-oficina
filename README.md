# 🔧 Projeto de Banco de Dados para Oficina Mecânica

## 📌 Descrição do Projeto
Este projeto implementa a modelagem e criação do banco de dados para um **sistema de gestão de oficinas mecânicas**, abrangendo desde o cadastro de clientes até a administração de ordens de serviço, veículos, pagamentos e funcionários.

O banco de dados foi projetado para:
- **Cadastrar clientes** (Pessoa Física e Jurídica);
- **Registrar veículos** pertencentes aos clientes;
- **Gerenciar ordens de serviço** e os serviços prestados;
- **Acompanhar pagamentos** e formas de pagamento utilizadas;
- **Controlar funcionários** e suas funções na oficina.

O modelo segue as **boas práticas de modelagem relacional**, garantindo **integridade referencial** e **eficiência nas consultas**.

---

## 🏗 Estrutura do Banco de Dados
O banco de dados segue um modelo relacional estruturado, contendo as seguintes tabelas principais:

### **📌 Tabelas Principais**
- **`clients`**: Armazena informações sobre clientes (CPF ou CNPJ, endereço, telefone, etc.).
- **`vehicles`**: Registro de veículos dos clientes.
- **`services`**: Serviços oferecidos pela oficina.
- **`work_orders`**: Controle das ordens de serviço, vinculadas a veículos e clientes.
- **`employees`**: Cadastro de funcionários e suas funções.
- **`payments`**: Registro de pagamentos realizados para as ordens de serviço.

### **📌 Relacionamentos Importantes**
- **Ordem de serviço** está relacionada a **veículo e cliente**.
- **Serviços são associados às ordens de serviço** via uma relação **M:N**.
- **Funcionários podem estar ligados a várias ordens de serviço** via uma relação **M:N**.
- **Cada pagamento está vinculado a uma ordem de serviço**.

---

## 🛠 Tecnologias Utilizadas
- **MySQL** como Sistema Gerenciador de Banco de Dados (SGBD);
- **SQL** para criação das tabelas e consultas;
- **Workbench** (ou DBeaver) para modelagem e visualização do banco.

---

## 🔍 Queries Implementadas
Foram desenvolvidas consultas SQL para análise de dados, como:

1. **Número de serviços realizados por mecânico**:
   ```sql
   SELECT e.name AS Mecânico, COUNT(we.idWorkOrder) AS Servicos_Realizados
   FROM employees e
   JOIN work_order_employees we ON e.idEmployee = we.idEmployee
   WHERE e.role = 'Mecânico'
   GROUP BY e.name
   ORDER BY Servicos_Realizados DESC;
   ```

2. **Quantidade de ordens de serviço abertas por cliente**:
   ```sql
   SELECT c.name AS Cliente, COUNT(wo.idWorkOrder) AS Ordens_Abertas
   FROM clients c
   JOIN work_orders wo ON c.idClient = wo.idClient
   WHERE wo.status = 'Aberta'
   GROUP BY c.name
   ORDER BY Ordens_Abertas DESC;
   ```

3. **Faturamento total por mês**:
   ```sql
   SELECT YEAR(paymentDate) AS Ano, MONTH(paymentDate) AS Mes, SUM(totalAmount) AS Faturamento
   FROM payments
   GROUP BY YEAR(paymentDate), MONTH(paymentDate)
   ORDER BY Ano DESC, Mes DESC;
   ```

4. **Lista de clientes que gastaram mais de R$ 5000,00 na oficina**:
   ```sql
   SELECT c.name AS Cliente, SUM(p.totalAmount) AS TotalGasto
   FROM clients c
   JOIN work_orders wo ON c.idClient = wo.idClient
   JOIN payments p ON wo.idWorkOrder = p.idWorkOrder
   GROUP BY c.name
   HAVING TotalGasto > 5000
   ORDER BY TotalGasto DESC;
   ```

---

## 📂 Como Utilizar
1. **Criar o Banco de Dados**
   ```sql
   CREATE DATABASE oficina;
   USE oficina;
   ```
2. **Executar o Script SQL** (disponível neste repositório) para criação das tabelas.
3. **Popular o banco com dados de exemplo**.
4. **Executar as consultas para análise dos dados.**

---

## 📢 Contribuições
Se quiser contribuir com melhorias, faça um **fork** deste repositório, crie uma **branch** com as alterações e envie um **Pull Request**! 🚀

---

## 📜 Licença
Este projeto é de livre uso para aprendizado e pode ser modificado conforme necessário.

