# BD_SQL_Demonstracoes_Fiscais
Este projeto tem como objetivo a criação de tabelas com inserção dos dados a partir da leitura de arquivos CSV, além da realização de consultas SQL.

O programa lê arquivos CSV contendo as informações financeiras das operadoras e as armazena em um banco de dados PostgreSQL. Em seguida, são executadas consultas SQL para obter as 10 operadoras com maiores despesas em determinados períodos.


## Como Utilizar

Siga as etapas abaixo para utilizar o projeto:

1. Clone o repositório do projeto para o seu ambiente local.
```shell
git clone https://github.com/NicolasBastos027/BD_SQL_DemonstracoesFiscais.git
```
2. Certifique-se de ter o PostgreSQL instalado e configurado.
3. No arquivo do código SQL `codigo.sql`, defina os caminhos completos (dentro do comando COPY) para os arquivos CSV que você deseja importar para o banco de dados (os arquivos CSV utilizados estão aqui no repositório do GitHub.
4. Execute o código SQL no seu ambiente PostgreSQL para criar as tabelas e importar os dados dos arquivos CSV.
5. Após a importação dos dados, você pode executar as queries mencionadas para obter os relatórios de despesas das operadoras.
