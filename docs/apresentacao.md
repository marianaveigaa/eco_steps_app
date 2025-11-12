# Apresentação: Implementação das Features de "Daily Goals" no EcoSteps

- **Projeto:** EcoSteps - Hábitos Sustentáveis
- **Aluna:** Mariana Veiga
- **Data:** 12/11/2025
- **Versão:** 1.0

---

## 1. Sumário Executivo

Este documento detalha a implementação das duas features solicitadas no `Enunciado Daily Goals.pdf`, partindo da base de UI/UX fornecida.

1.  **Feature 1 (Repositório):** A tela de metas, que era "layout-only", foi refatorada para usar o Padrão Repository. Isso implementou uma arquitetura offline-first, unificando o `SupabaseRepository` (fonte remota) e o `LocalCacheService` (fonte local).

2.  **Feature 2 (Validação Inline):** A experiência do usuário no formulário de metas foi aprimorada, migrando a validação de erros de `SnackBar` para `Validators` inline, diretamente nos campos, como sugerido no documento de "Próximas melhorias" da aula.

O trabalho foi apoiado por IA (Gemini 2.5 Pro) para acelerar a escrita do código de arquitetura e dos testes unitários.

---

## 2. Arquitetura e Fluxo de Dados

A arquitetura segue os princípios de Clean Architecture, separando a UI (Telas), Domínio (Entidades, Repositórios) e Dados (Fontes de Dados, DTOs), conforme discutido no PDF "O Padrão Repository".

### Diagrama do Fluxo de Dados (Feature 1)

[ UI (SustainableGoalListPage) ] | v [ ISustainableGoalRepository (Interface/Contrato) ] | v [ SustainableGoalRepository (Implementação) ] | +-----> [ ISustainableGoalRemoteDatasource (Supabase) ] | +-----> [ ISustainableGoalLocalDatasource (Cache) ]

### Explicação do Fluxo

1.  **UI (Tela):** A `SustainableGoalListPage` não guarda mais uma lista local `items = []`. Ela agora possui uma instância do `ISustainableGoalRepository` e usa um `FutureBuilder` para lidar com os estados de carregamento, erro e dados.
2.  **Repositório:** Ao carregar a tela, a UI chama `repository.getGoals()`.
3.  **Lógica Offline-First:**
    * O `SustainableGoalRepository` primeiro busca a última data de sincronização no `ISustainableGoalLocalDatasource` (o `LocalCacheService`).
    * Em seguida, pede ao `ISustainableGoalRemoteDatasource` (o `SupabaseRepository`) apenas os dados alterados *desde* aquela data.
    * Ele salva (faz "upsert") esses dados novos no cache local.
    * Finalmente, lê a lista *completa* do cache local, mapeia os DTOs para Entidades e a retorna para a UI.
4.  **Fluxo de Escrita (Salvar/Editar):**
    * A `SustainableGoalFormDialog` chama `repository.saveGoal(goal)`.
    * O Repositório converte a `SustainableGoal` (Entidade) para um `SustainableGoalDto`.
    * O DTO é enviado para o `RemoteDatasource` (Supabase) para ser salvo.
    * *Modo de Segurança (Implementado):* Se o Supabase falhar (seja por falta de internet ou por a tabela `sustainable_goals` não existir), o `catch` no repositório salva a meta localmente no cache com um ID temporário, garantindo que o usuário não perca dados.

---

## 3. Detalhamento das Features Implementadas

Abaixo estão os detalhes das duas features solicitadas no enunciado.

### Feature 1: Implementação do Padrão Repository (Offline-First)

* **Objetivo:** Substituir a lista local (`layout-only`) da tela de metas por um sistema de persistência robusto, seguindo o Padrão Repository. O objetivo era unificar o cache local (`LocalCacheService`) e a fonte remota (`SupabaseRepository`), garantindo uma experiência offline-first.

* **Alguns dos Prompt(s) Usados:**
    * **Prompt 1 (Planejamento):** "Preciso implementar o Padrão Repository no meu app Flutter baseado nos PDFs da aula. Eu tenho um `LocalCacheService` (SharedPreferences) e um `SupabaseRepository`. Como eu crio as interfaces `ISustainableGoalRepository`, `ISustainableGoalRemoteDatasource`  e `ISustainableGoalLocalDatasource`?"
    * **Prompt 2 (Refatoração):** "Me mostre como refatorar o meu `LocalCacheService` existente para que ele implemente a nova interface `ISustainableGoalLocalDatasource`. Preciso que ele adicione a lógica de 'upsertAll' e 'listAll' para as metas, similar ao que o PDF mostra, mas adaptado para `SustainableGoalDto`."
    * **Prompt 3 (Implementação):** "Agora, me passe o código completo da classe `SustainableGoalRepository`. Ela deve implementar `ISustainableGoalRepository` e usar a lógica 'offline-first': buscar `lastSync` do cache, pedir dados novos ao Supabase, salvar no cache e, por fim, retornar tudo do cache para a UI."
    * **Prompt 4 (Refatoração da UI):** "Como eu refatoro minha `SustainableGoalListPage`, que usa uma lista local `items = []`, para usar um `FutureBuilder` que consome o novo `ISustainableGoalRepository` e lida com os estados de loading, error e data?"

* **Como Testar Localmente:**
    1.  Execute o app e vá para a `HomeScreen`.
    2.  Clique no `FloatingActionButton.extended` com o texto "MINHAS METAS".
    3.  A tela `SustainableGoalListPage` irá carregar (mostrando um `CircularProgressIndicator` enquanto busca os dados).
    4.  Clique no `+` (FAB) para adicionar uma nova meta (Ex: "Reduzir plástico"). Preencha todos os campos e salve.
    5.  A meta deve aparecer na lista.
    6.  Feche o aplicativo completamente e reabra.
    7.  Navegue novamente para a tela "Minhas Metas". A meta "Reduzir plástico" deve continuar lá, provando que foi lida do cache.

* **Limitações e Riscos:**
    * A estratégia de "merge" do cache (`cacheGoals`) no `LocalCacheService` lê toda a lista do SharedPreferences para a memória, faz o merge e salva tudo de volta. Com *milhares* de metas, isso pode se tornar lento. Uma solução futura seria migrar para um banco de dados local mais robusto (como o PDF sugere, SQLite/Drift).
    * A resolução de conflitos é "o mais novo vence" (`upsert`). Se o usuário editar offline e o servidor tiver uma versão mais nova, a versão do servidor será sobrescrita.

### Feature 2: Validação Inline (TextFormField.validator)

* **Objetivo:** Melhorar a experiência do usuário no formulário de metas, trocando os `SnackBars` de erro por uma validação *inline* (abaixo do campo), como sugerido nos "próximos passos" do PDF de explicação (`DailyGoalEntityFormDialog.pdf`).

* **Alguns dos Prompt(s) Usados:**
    * **Prompt 1 (Planejamento):** "Eu preciso trocar a validação do meu formulário de metas. Atualmente, ela usa `SnackBar` quando o usuário clica em 'Salvar'. Como eu mudo isso para usar `TextFormField.validator` e mostrar o erro 'inline' (embaixo do campo)?"
    * **Prompt 2 (Implementação):** "Me dê o código de exemplo para o `validator` de um `TextFormField` que aceita números e precisa ser obrigatório e maior que zero."
    * **Prompt 3 (Refatoração):** "Como eu mudo minha função `_onConfirm` para checar `_formKey.currentState!.validate()` antes de tentar salvar, e como eu configuro o `autovalidateMode` no `Form`?"

* **Como Testar Localmente:**
    1.  Vá para a tela "Minhas Metas" e clique no `+` (FAB).
    2.  Clique no campo "Título" e depois clique fora (sem digitar nada). O erro "Título é obrigatório." deve aparecer instantaneamente abaixo do campo.
    3.  Clique no botão "Adicionar". O formulário não deve fechar, pois a validação falhou.
    4.  Digite um "Valor Alvo" inválido (ex: "abc" ou "-5"). O erro ("Inválido" ou "> 0") deve aparecer.
    5.  Preencha todos os campos corretamente. Os erros devem sumir, e o botão "Adicionar" agora irá funcionar e salvar a meta.

* **Limitações e Riscos:**
    * A validação é feita apenas na UI (client-side). Uma validação de segurança mais complexa (ex: checar se o título já existe no banco) ainda deveria ser feita no Repositório ou, idealmente, no Backend (Supabase).

---

## 4. Roteiro de Apresentação Oral

1.  **Introdução:**
    * "Boa tarde. Meu nome é Mariana e este é o resultado do meu trabalho."
    * "O objetivo era evoluir a 'base' da UI que vimos em aula e implementar duas features principais para torná-la funcional, adaptando ao meu app, o EcoSteps."

2.  **Feature 1 - O Repositório (Arquitetura):**
    * "A primeira feature foi a mais complexa: implementar o Padrão Repository, como vimos no PDF."
    * "Eu refatorei a tela de metas, que antes usava uma lista local, para se comunicar com uma interface, a `ISustainableGoalRepository`."
    * "Essa interface é implementada pelo `SustainableGoalRepository`, que coordena duas fontes de dados: o `SupabaseRepository` (remoto) e o `LocalCacheService` (cache)."

3.  **Feature 1 - Fluxo de Dados (Demo 1):**
    * "O fluxo agora é offline-first. (Vou demonstrar...) Ao carregar a tela, o app busca updates no Supabase, salva no cache e *sempre* exibe os dados do cache."
    * "Quando eu crio uma meta nova... (criar meta)... ela é enviada ao Supabase. Eu implementei um modo de segurança: se o Supabase falhar (seja por falta de internet ou, como no meu caso, a tabela ainda não existir), o `catch` no repositório salva a meta localmente no cache mesmo assim."
    * "Se eu fechar o app e reabrir, a meta ainda está aqui, pois foi lida do cache."

4.  **Feature 2 - Validação Inline (Demo 2):**
    * "A segunda feature foi uma melhoria de UX, sugerida nos PDFs da aula: trocar os SnackBars de erro por validação inline."
    * "(Abrir o formulário) Antes, um erro só aparecia *depois* de clicar em 'Adicionar'. Agora, se eu deixar um campo obrigatório em branco... (fazer)... o erro aparece na hora, usando a propriedade `validator` do TextFormField."
    * "Isso é feito ativando o `AutovalidateMode.onUserInteraction` no `Form` e checando `_formKey.currentState!.validate()`."

5.  **Testes:**
    * "Para garantir a lógica da Feature 1, escrevi um Unit Test para o `SustainableGoalRepository`, como pedia o enunciado."
    * "Usei o pacote `mocktail` para simular as fontes de dados remota e local. Os testes validam o fluxo de sincronização e, o mais importante, o cenário 'offline' (quando a rede falha, o app retorna os dados do cache)."

6.  **Conclusão:**
    * "Com essas features, o app agora tem uma arquitetura de dados escalável e pronta para o mundo real, além de uma UX de formulário muito mais profissional e intuitiva."

---

## 5. Política de Branches e Commits

Devido a limitações no ambiente de desenvolvimento que impediram a instalação e configuração do Git a tempo para esta entrega, não foi possível utilizar o versionamento formal com *feature branches* e *commits* no GitHub.

No entanto, para simular um fluxo de trabalho profissional e garantir a organização, o desenvolvimento seguiu a **mesma lógica de separação de tarefas** que seria usada em um fluxo Git:

1.  **Desenvolvimento Isolado:** O trabalho nas novas features (Repositório e Validação) foi feito separadamente da base de código estável (equivalente a uma `feature branch`).
2.  **Etapas Lógicas (Commits Atômicos):** O progresso foi salvo localmente em etapas lógicas, que representam os "commits" que *teriam sido feitos*.

Abaixo está o histórico de desenvolvimento lógico que foi seguido, espelhando o que seriam as mensagens de commit no padrão *Conventional Commits*:

* `feat(goals): Adiciona 'base' da tela de lista e formulário`
* `refactor(goals): Implementa ISustainableGoalRepository e IGoalDatasources`
* `refactor(services): Adapta LocalCacheService para implementar ISustainableGoalLocalDatasource`
* `refactor(services): Adapta SupabaseRepository para implementar ISustainableGoalRemoteDatasource`
* `feat(goals): Conecta UI da ListPage e FormDialog ao repositório`
* `feat(validation): Migra formulário de SnackBar para validacão inline (validator)`
* `test(repository): Adiciona unit test para SustainableGoalRepository`
* `fix(ui): Corrige navegação da home e ícones de fallback`
* `docs: Cria documento de apresentação (apresentacao.md)`
