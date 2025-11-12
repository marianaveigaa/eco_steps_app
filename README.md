# EcoSteps - Hábitos Sustentáveis

EcoSteps é um aplicativo Flutter desenvolvido para ajudar usuários a criar e monitorar hábitos sustentáveis. Com arquitetura moderna e experiência offline-first, o app combina tecnologia e conscientização ambiental.

## 🚀 Funcionalidades Principais

### **Sustentabilidade Prática**
- **Metas Personalizáveis**: CRUD completo de metas (reduzir lixo, economizar água, etc.) com persistência local e na nuvem.
- **Provedores Verdes**: Descubra estabelecimentos sustentáveis (com cache offline).
- **Atividades Eco**: Registre ações com impacto ambiental mensurável (Backlog).
- **Progresso Visual**: Acompanhe sua evolução com gráficos e estatísticas.

### **Tecnologia Avançada**
- **Arquitetura Limpa (Padrão Repository)**: Separação clara entre UI, Domínio (interfaces) e Dados (implementações).
- **Sincronização em Tempo Real**: Dados atualizados via Supabase (PostgreSQL e Storage).
- **Funcionalidade Offline-First**: O app prioriza o cache local (`SharedPreferences`) e sincroniza com a nuvem, funcionando perfeitamente sem internet.
- **Validação Inline**: Experiência de usuário aprimorada com validação de formulário em tempo real.

### **Experiência do Usuário**
- **Onboarding Intuitivo**: Introdução suave às funcionalidades e políticas de privacidade.
- **Avatar Personalizável**: Foto de perfil com upload local, compressão e respeito à LGPD.
- **Multi-plataforma**: Disponível para mobile e desktop.
- **Acessibilidade Total**: Design inclusivo e acessível.

## 🛠️ Stack Tecnológica

**Frontend & Mobile**
- Flutter 3.0+ & Dart
- Material Design 3
- Arquitetura Limpa (Domain/Data/Repository)

**Backend & Cloud**
- Supabase (PostgreSQL, Auth, Storage)
- APIs RESTful
- Row Level Security

**Ferramentas**
- Gestão de estado nativa (StatefulWidgets)
- Cache local com SharedPreferences
- Testes unitários com `mocktail`

## ⚡ Começando

### Pré-requisitos
- Flutter 3.0 ou superior
- Conta no Supabase (com as tabelas `providers` e `sustainable_goals` criadas)
- Git instalado

### Instalação Rápida
1. Clone o repositório
2. Configure as variáveis de ambiente no arquivo `.env` (baseado no `.env.example`)
3. Execute `flutter pub get` para instalar dependências
4. Rode `flutter run` para iniciar o app

### Comandos Úteis
flutter run          # Iniciar em modo desenvolvimento
flutter build apk    # Build para Android
flutter test         # Executar testes
flutter analyze      # Análise de código

## 📱 Como Utilizar

### **Primeiro Acesso**
- Complete o onboarding para entender as funcionalidades.
- Aceite as políticas de privacidade para ter acesso ao app.

### **Funcionalidades Diárias**
- **Gerenciar Metas:** Use o botão "MINHAS METAS" para criar, editar ou excluir suas metas sustentáveis. O app salvará seu progresso mesmo se você estiver offline.
- **Explorar Provedores:** Acompanhe provedores sustentáveis na sua região.
- **Personalizar Perfil:** Adicione uma foto de perfil, que fica salva apenas no seu dispositivo.

### **Recursos Avançados**
- Sincronização automática entre dispositivos (via Supabase).
- Modo offline com todos os dados essenciais (cache de metas e provedores).
- Sistema de notificações para lembretes (Backlog).

## 🏗️ Estrutura do Projeto

O projeto segue princípios de Clean Architecture com o Padrão Repository:

- `lib/domain/`: Contém a lógica de negócio pura.
  - `entities/`: Os modelos de negócio (ex: `SustainableGoal`, `EcoProvider`).
  - `repositories/`: As **interfaces** (contratos) que a UI usa (ex: `ISustainableGoalRepository`).

- `lib/data/`: Contém a implementação das fontes de dados.
  - `dtos/`: Objetos de transferência de dados (Ex: `SustainableGoalDto`).
  - `mappers/`: Conversores que transformam DTOs em Entidades.
  - `repositories/`: A **implementação** concreta das interfaces (Ex: `SustainableGoalRepository`).

- `lib/services/`: Contém os DataSources (os "trabalhadores" que falam com o exterior).
  - `supabase_repository.dart`: (Implementa `ISustainableGoalRemoteDatasource`) Fala com o Supabase.
  - `local_cache_service.dart`: (Implementa `ISustainableGoalLocalDatasource`) Fala com o SharedPreferences.

- `lib/screens/` (Presentation): As telas/páginas do app (ex: `HomeScreen`, `SustainableGoalListPage`).
- `lib/widgets/` (Presentation): Widgets reutilizáveis (ex: `ProfileDrawer`, `SustainableGoalFormDialog`).

## 🤝 Contribuindo

Quer ajudar a melhorar o EcoSteps?

1. Faça fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

### Guidelines
- Siga o padrão de código existente
- Adicione testes para novas funcionalidades
- Mantenha a documentação atualizada
- Respeite as convenções do Flutter

## 📄 Licença

Este projeto está sob licença MIT.

## 📞 Contato & Suporte

**Desenvolvedora**: Mariana Veiga  
**Email**: suporte@ecosteps.com (ficticio)
**Documentação**: (Link para o `docs/apresentacao.md`)

---

*Juntos por um futuro mais verde! 🌱✨*
