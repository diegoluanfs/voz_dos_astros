# Backend API Documentation

## Descrição do Projeto
Este projeto é uma API backend que gerencia consultas. Ele permite a criação, recuperação e manipulação de dados relacionados a consultas através de endpoints RESTful.

## Estrutura do Projeto
O projeto é organizado da seguinte forma:

- **Controllers**
  - `ConsultaController.cs`: Gerencia as requisições relacionadas a consultas.
  
- **Models**
  - `ConsultaModel.cs`: Define o modelo de dados para uma consulta.
  
- **Services**
  - `ConsultaService.cs`: Contém a lógica de negócios relacionada a consultas.
  
- **Program.cs**: Ponto de entrada da aplicação.
  
- **Startup.cs**: Configura os serviços e o pipeline de requisições da aplicação.
  
- **appsettings.json**: Armazena as configurações da aplicação.

## Como Executar
1. Clone o repositório.
2. Navegue até o diretório do projeto.
3. Execute o comando para restaurar as dependências.
4. Inicie a aplicação.

## Endpoints
- `GET /api/consulta`: Retorna uma lista de consultas.
- `POST /api/consulta`: Cria uma nova consulta.

## Dependências
Certifique-se de ter as seguintes dependências instaladas:
- .NET 6.0 ou superior

## Contribuição
Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou pull requests.