# EcoSteps - Hábitos Sustentáveis

EcoSteps é um aplicativo Flutter desenvolvido para ajudar usuários a desenvolver e monitorar hábitos sustentáveis. Com foco em metas de redução de lixo, uso de água e energia, o app oferece um onboarding intuitivo, consentimento de privacidade em conformidade com a LGPD, e uma experiência transparente e acessível.

**Novo:** Integração com Supabase para dados em tempo real + Avatar dinâmico no Drawer com foto do usuário (câmera/galeria/desktop), compressão automática ≤200KB, remoção de EXIF/GPS e fallback para iniciais.

## 🚀 Funcionalidades Principais

* **Onboarding Interativo:** Três telas com ícones distintos (sustentabilidade, progresso e privacidade) para introduzir o usuário ao app.
* **Consentimento de Privacidade:** Leitura obrigatória de políticas e termos em Markdown, com barra de progresso e aceite opt-in.
* **Home Conectada:** Lista dinâmica de provedores sustentáveis com dados em tempo real do Supabase.
* **Cache Inteligente:** Funcionamento offline com sincronização automática quando online.
* **Revogação de Consentimento:** Opção em configurações com confirmação e possibilidade de "Desfazer".
* **Avatar com Foto no Drawer:** Adicione/altere/remova foto via câmera/galeria/desktop; compressão automática, persistência local, fallback para iniciais; acessível (≥48dp, Semantics).
* **Acessibilidade (A11Y):** Suporte a text scaling, alto contraste WCAG AA, alvos de toque ≥48dp e foco visível.
* **Privacidade LGPD:** Transparência total, dados armazenados localmente, sem coleta automática de informações sensíveis.

## 🛠️ Tecnologias Utilizadas

* **Flutter:** Framework para desenvolvimento cross-platform
* **Dart:** Linguagem de programação
* **Supabase:** Backend-as-a-Service com PostgreSQL, Auth e Storage
* **shared_preferences:** Para armazenamento local de dados
* **flutter_markdown:** Para renderizar políticas em Markdown
* **flutter_launcher_icons:** Para gerar ícones do app automaticamente
* **image_picker:** Para seleção de câmera/galeria
* **file_selector:** Para seleção de arquivos em desktop
* **flutter_image_compress:** Para compressão e remoção de EXIF/GPS
* **path_provider:** Para diretório de armazenamento local
* **flutter_dotenv:** Para gerenciamento seguro de variáveis de ambiente

## 📋 Pré-requisitos

* **Flutter:** Versão 3.0 ou superior. [Instale aqui](https://flutter.dev/docs/get-started/install)
* **Dart:** Incluído com Flutter
* **VS Code:** Recomendado, com extensões Flutter e Dart instaladas
* **Dispositivo/Emulador:** Android/iOS/Windows/macOS/Linux
* **Conta Supabase:** Para backend em nuvem

# Desenvolvimento
flutter run

# Plataformas específicas
flutter run -d windows
flutter run -d chrome
flutter run -d android
flutter run -d ios

# Build para produção
flutter build apk
flutter build ios
flutter build windows

# 🏗️ Arquitetura do Projeto

lib/

├── models/

│   └── provider.dart          # Modelo de dados EcoProvider

├── services/

│   ├── supabase_repository.dart # Comunicação com Supabase

│   ├── local_cache_service.dart # Cache offline

│   ├── prefs_service.dart     # Preferências locais

│   └── local_photo_store.dart # Gerenciamento de fotos

├── screens/

│   ├── home_screen.dart       # Tela principal com provedores

│   ├── onboarding_screen.dart # Onboarding

│   ├── splash_screen.dart     # Tela de inicialização

│   └── policy_viewer_screen.dart # Políticas de privacidade

├── widgets/

│   ├── profile_drawer.dart    # Drawer com avatar

│   ├── photo_selection_bottom_sheet.dart # Seleção de fotos

│   ├── onboarding_page.dart   # Páginas de onboarding

│   └── dots_indicator.dart    # Indicador de progresso

├── theme/

│   └── app_theme.dart         # Temas claro/escuro

└── main.dart                  # Inicialização do app

# 🔒 Segurança e Privacidade
* Variáveis de ambiente para credenciais sensíveis
* Row Level Security no Supabase para proteção de dados
* Cache local com dados anônimos
* Compressão de imagens com remoção de EXIF/GPS
* Transparência total com políticas acessíveis

# Execute os testes
flutter test

# Protocolo de QA:
# ✅ Onboarding → Políticas → Aceite → Home con Drawer
# ✅ Adicionar/remover foto de perfil
# ✅ Carregamento de provedores online/offline
# ✅ Sincronización automática
# ✅ Acessibilidade e performance

# 📄 Licença
Este projeto está sob a licença MIT. Veja o arquivo LICENSE para detalhes.

# 📞 Contato
* **Desenvolvedora: Mariana Veiga**

* **Email: suporte@ecosteps.com (fictício)**
