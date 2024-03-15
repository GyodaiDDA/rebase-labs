# rebase-labs 0.0.1

## origem
O re:bLABSe é o resultado de um bootcamp com o objetivo de construir um aplicativo sem utilizar Rails. 

## função
 O aplicativo foca em processo de importação de dados CSV referentes a exames médicos. O processo de importação, bem como a visualização dos dados importados, podem ser realizados por uma interface HTML, por endpoints em API e por um script em ruby.

- [ ] Refatorar o método **populate_tables** guardando o texto das queries em outro arquivo para facilitar leitura.
- [ ] Corrigir bug em CleanDataStorageJob, que hoje não está funcionando.
- [ ] Ampliar testes

Na interface
- [ ] Exibir alerta em Search quando nenhum dado for encontrado.
- [ ] Criar testes de interface com capybara