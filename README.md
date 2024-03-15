# rebase-labs 0.0.1

## origem
O re:bLABSe é o resultado de um bootcamp com o objetivo de construir um aplicativo sem utilizar Rails. 

## função
 O aplicativo foca em processo de importação de dados CSV referentes a exames médicos. O processo de importação, bem como a visualização dos dados importados, podem ser realizados por uma interface HTML, por endpoints em API e por um script em ruby.

## instalação e inicialização

1. Instale o docker compose seguindo instruções em
   - https://docs.docker.com/compose/install/
2. Certifique-se de que o docker está em execução com `docker ps`
   - Caso não esteja, execute `sudo systemctl start docker`
   - Caso ocorra algum problema, verifique se o usuário do seu sistema tem permissão de sudo.
   - Você pode autorizar seu usuário com `sudo usermod -aG docker $USER`
3. Clone o repositório com
   - `sudo git clone https://github.com/GyodaiDDA/rebase-labs.git`
4. Acesse o diretório `rebase-labs/app/`
5. No terminal, utilize `docker compose up`

## utilização
### interface web
Com o projeto no ar, a interface html estará disponível em http://localhost:4567. 

#### Import
Para importar os dados, clique em **Import**, selecione o arquivo `data1.csv` que se encontra em `rebase-labas/app/csv` e clique em **Upload file**.
> O trabalho de importação é assíncrono, então pode levar alguns minutos até que você possa visualizar os dados importados.

#### See all data
Para isso, clique em **See all data**. Cada resultado será representado pelo token e pela data do exame. Clicando em cada resultado, você pode visualizar mais detalhes do exame.

#### Search
Para realizar uma busca por tokens, preencha o campo de entrada e clique em **Search**.

> A busca por tokens pode receber um ou mais elementos separados por vírgula e sem espaço. 
> 
> Exemplo: **5UP5FA,IWH46D,AAA111**


> Serão mostrados os resultados referentes aos tokens válidos. Tokens que não correspondam a um registro no banco de dados serão ignorados.

### script de importação

Na pasta app, pode ser utilizado diretamente o script de importação `ruby import_from_csv.rb` que vai importar os dados do arquivo `data1.csv`.

### endpoints

Os endpoints são listados a seguir:

- /tests
  retorna todos os registros de exames encontrados no banco de dados
- /tests/{tokens}
  retorna os detalhes de um ou mais exames
- /import
  recebe POST para importação de arquivo csv

### pastas

- O bloco central da aplicação é formada por `server.rb` e `config.ru`, ambos na pasta **app** do container *backend*.
- As pastas seguem a seguinte estrutura:
  - **/public** - contém os arquivos referentes ao frontend/interface web
  - **/csv** - é a pasta padrão para os arquivos CSV `test-file.csv` e `data1.csv` a serem importados via script
  - **/jobs** - contém dois jobs asíncronos responsáveis pela importação dos arquivos e limpeza dos arquivos temporários que são salvos na mesma pasta.
  - **/queries** - tem arquivos sql utilizados por diversos métodos
  - **/helpers** - contém métodos especializados para operações com banco de dados, leitura de arquivos csv e entrega de dados aos endpoints
  - **/config** contém apenas database.yml com configuração de ambientes


### estrutura de dados
Para que o csv seja importável, deve seguir esta estrutura:
  - cpf;nome paciente;email paciente;data nascimento paciente;endereço/rua paciente;cidade paciente;estado patiente;crm médico;crm médico estado;nome médico;email médico;token resultado exame;data exame;tipo exame;limites tipo exame;resultado tipo exame
- no banco de dados essa estrutura é separada em 5 tabelas:
  -  pacients;
  -  doctors;
  -  exams;
  -  test_types;
  -  test_results.


### testes automatizados

A gem rspec está instalada e testes para os processos do backend estão implementados. Para executar os testes, execute `rspec` no diretório `rebase-labs/app/`.

### versões e gems

Todas as gems e suas versões encontram-se em `Gemfile`. O docker compose sempre usará a versão mais recente das imagens **ruby**, **postgres** e **redis**.

### próximos passos

Neste mesmo diretório, encontra-se o arquivo TODO.md com notas para desenvolvimento futuro da aplicação.

### agradecimentos

À rebase e à ajuda inestimável dos colegas CampusCoders da T11.

o/

#### contato: rodrigo.gyodai@gmail.com