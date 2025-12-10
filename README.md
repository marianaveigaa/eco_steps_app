# 🌱 EcoSteps - Hábitos Sustentáveis 🌱

EcoSteps é um aplicativo Flutter desenvolvido para ajudar usuários a criar e monitorar hábitos sustentáveis. Com arquitetura moderna e experiência offline-first, o app combina tecnologia e conscientização ambiental.

## 🚀 Funcionalidades Principais

### **Sustentabilidade Prática**
- **Metas Personalizáveis**: CRUD completo de metas (reduzir lixo, economizar água, etc.) com persistência local e espelhamento na nuvem.
- **Provedores Verdes**: Descubra estabelecimentos sustentáveis próximos a você (com cache offline).
- **Atividades Eco**: Registre ações com impacto ambiental mensurável (Backlog).
- **Progresso Visual**: Acompanhe sua evolução com indicadores claros.

### **Tecnologia Avançada**
- **Arquitetura Limpa (Padrão Repository)**: Separação clara entre UI, Domínio (interfaces) e Dados (implementações).
- **Sincronização Híbrida**: Dados salvos localmente primeiro (Offline-First) e enviados silenciosamente para o Supabase.
- **Validação Inline**: Experiência de usuário aprimorada com feedback instantâneo nos formulários.
- **Tema Dinâmico**: Suporte completo a **Tema Claro e Escuro**, com persistência da escolha do usuário ou sincronia com o sistema.

### **Experiência do Usuário**
- **Onboarding Intuitivo**: Introdução suave às funcionalidades e políticas de privacidade (com scroll obrigatório).
- **Perfil Completo**: Adicione **foto e nome** de usuário, salvos localmente com respeito à privacidade.
- **Multi-plataforma**: Disponível para mobile (Android) e desktop (Windows).
- **Acessibilidade**: Design inclusivo, acessível e responsivo.

## 🛠️ Stack Tecnológica

**Frontend & Mobile**
- Flutter 3.0+ & Dart
- Material Design 3
- Arquitetura Limpa (Domain/Data/Repository)

**Backend & Cloud**
- Supabase (PostgreSQL, Auth, Storage)
- APIs RESTful
- Row Level Security

**Ferramentas & Gestão**
- Gestão de estado nativa (`StatefulWidgets` e `ChangeNotifier` para Temas)
- Cache local com `SharedPreferences`
- Testes unitários com `mocktail`

## ⚡ Começando

### Pré-requisitos
- Flutter 3.0 ou superior
- Conta no Supabase (com as tabelas `providers` e `sustainable_goals` criadas)
- Git e GitHub Desktop instalado

### Instalação Rápida
1. Clone o repositório
2. Configure as variáveis de ambiente no arquivo `.env` (baseado no `.env.example`)
3. Execute `flutter pub get` para instalar dependências
4. Rode `flutter run` para iniciar o app

### Comandos Úteis
```bash
flutter run          # Iniciar em modo desenvolvimento
flutter build apk    # Build para Android
flutter test         # Executar testes
flutter analyze      # Análise de código
```

## 📱 Como Utilizar

### **Primeiro Acesso**
- Complete o onboarding para entender as funcionalidades.
- Leia e aceite as políticas de privacidade (role até o fim para habilitar o aceite).

### **Funcionalidades Diárias**
- **Gerenciar Metas:** Use o botão "MINHAS METAS" para criar, editar ou excluir suas metas. O app salvará tudo mesmo offline.
- **Personalizar Perfil:** No menu lateral (Drawer), altere seu **Nome**, sua **Foto** e alterne entre **Tema Claro/Escuro**.
- **Explorar Provedores:** Visualize a lista de lojas sustentáveis na tela inicial.

### **Recursos Avançados**
- Sincronização automática de metas com o Supabase.
- Persistência robusta de preferências do usuário (Tema e Dados Pessoais).

## 🏗️ Estrutura do Projeto

O projeto segue princípios de Clean Architecture com o Padrão Repository:

- `lib/domain/`: Lógica de negócio pura.
  - `entities/`: Modelos de negócio (ex: `SustainableGoal`).
  - `repositories/`: Interfaces (contratos) que a UI usa.

- `lib/data/`: Implementação das fontes de dados.
  - `dtos/`: Objetos de transferência (JSON).
  - `repositories/`: Implementação concreta das interfaces.

- `lib/services/`: DataSources e Serviços.
  - `supabase_repository.dart`: Conexão remota.
  - `local_cache_service.dart`: Cache local de dados.
  - `prefs_service.dart`: Gerenciamento de preferências (Tema, User, Políticas).

- `lib/theme/`: Controle de aparência.
  - `theme_controller.dart`: Lógica de troca de temas.
  - `app_theme.dart`: Definição das cores e estilos.

- `lib/screens/`: Telas do app (ex: `HomeScreen`, `SustainableGoalListPage`).
- `lib/widgets/`: Componentes reutilizáveis (ex: `ProfileDrawer`, `SustainableGoalFormDialog`).

## 🤝 Contribuindo

### Quer ajudar a melhorar o EcoSteps?

1. Faça fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

### Guidelines
- Siga o padrão de código existente
- Adicione testes para novas funcionalidades
- Mantenha a documentação atualizada

## 📄 Licença

Este projeto está sob licença MIT.

## 📞 Contato & Suporte

**Desenvolvedora**: Mariana Veiga 
**Email**: suporte@ecosteps.com (fictício) 

---

*Juntos por um futuro mais verde! 🌱✨*
