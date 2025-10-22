# EcoSteps - Hábitos Sustentáveis

EcoSteps é um aplicativo Flutter desenvolvido para ajudar usuários a desenvolver e monitorar hábitos sustentáveis. Com foco em metas de redução de lixo, uso de água e energia, o app oferece um onboarding intuitivo, consentimento de privacidade em conformidade com a LGPD, e uma experiência transparente e acessível.

**Novo:** Avatar dinâmico no Drawer com foto do usuário (câmera/galeria), compressão automática ≤200KB, remoção de EXIF/GPS e fallback para iniciais.

## Funcionalidades Principais

* **Onboarding Interativo:** Três telas com ícones distintos (sustentabilidade, progresso e privacidade) para introduzir o usuário ao app.
* **Consentimento de Privacidade:** Leitura obrigatória de políticas e termos em Markdown, com barra de progresso e aceite opt-in.
* **Home Personalizada:** Card de boas-vindas para criar a primeira meta sustentável.
* **Revogação de Consentimento:** Opção em configurações com confirmação e possibilidade de "Desfazer".
* **Avatar com Foto no Drawer:** Adicione/altere/remova foto via câmera/galeria; compressão automática, persistência local, fallback para iniciais; acessível (≥48dp, Semantics).
* **Acessibilidade (A11Y):** Suporte a text scaling, alto contraste WCAG AA, alvos de toque ≥48dp e foco visível.
* **Privacidade LGPD:** Transparência total, dados armazenados localmente, sem coleta automática de informações sensíveis.

## Pré-requisitos

* **Flutter:** Versão 3.0 ou superior. [Instale aqui](https://flutter.dev/docs/get-started/install).
* **Dart:** Incluído com Flutter.
* **VS Code:** Recomendado, com extensões Flutter e Dart instaladas.
* **Dispositivo/Emulador:** Android/iOS ou desktop. Para testar a câmera, use um dispositivo real.

## Instalação

1.  Clone o repositório:
    ```bash
    git clone [https://github.com/seu-usuario/ecosteps.git](https://github.com/seu-usuario/ecosteps.git)
    cd ecosteps
    ```

2.  Instale as dependências:
    ```bash
    flutter pub get
    ```

3.  Gere o ícone do app (opcional, mas recomendado):
    ```bash
    flutter pub run flutter_launcher_icons
    ```

4.  Configure permissões:

    * **Android:** Adicione ao `android/app/src/main/AndroidManifest.xml`:
        ```xml
        <uses-permission android:name="android.permission.CAMERA" />
        <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
        ```

    * **iOS:** Adicione ao `ios/Runner/Info.plist`:
        ```xml
        <key>NSCameraUsageDescription</key>
        <string>Precisamos acessar a câmera para tirar fotos de perfil.</string>
        <key>NSPhotoLibraryUsageDescription</key>
        <string>Precisamos acessar a galeria para fotos de perfil.</string>
        ```

5.  Adicione os arquivos de assets:
    * Crie a pasta `assets/markdown/` e adicione `privacy_policy_v1.md` e `terms_of_use_v1.md`.
    * Adicione `assets/images/logo.png` (1024x1024) para o gerador de ícones.

## Como Executar

1.  Conecte um dispositivo ou inicie um emulador.
2.  Execute o app:
    ```bash
    flutter run
    ```
3.  Para builds específicos:
    ```bash
    flutter build apk
    flutter build ios
    flutter run -d chrome
    flutter run -d windows
    ```

## Como Usar o Avatar com Foto

1.  Abra o Drawer (ícone de menu no AppBar da Home).
2.  Toque no avatar (CircleAvatar).
3.  Escolha "Câmera" ou "Galeria" para adicionar/alterar foto.
4.  A imagem é comprimida automaticamente (≤200KB), EXIF/GPS removido, e salva localmente.
5.  **Fallback:** Se sem foto, mostra iniciais ("U").
6.  **Para remover:** Escolha "Remover Foto" no BottomSheet.

> **Nota:** Em plataformas desktop, a câmera pode não funcionar – use galeria ou dispositivo real.

## Tecnologias Utilizadas

* **Flutter:** Framework para desenvolvimento cross-platform.
* **Dart:** Linguagem de programação.
* **shared_preferences:** Para armazenamento local de dados (consentimento, caminho da foto).
* **markdown_widget:** Para renderizar políticas em Markdown (substituto do `flutter_markdown`).
* **flutter_launcher_icons:** Para gerar ícones do app automaticamente.
* **image_picker:** Para seleção de câmera/galeria.
* **flutter_image_compress:** Para compressão e remoção de EXIF/GPS.
* **path_provider:** Para diretório de armazenamento local.
* **go_router:** Para roteamento de URL.

## Testes e QA

Siga o protocolo de QA do PRD:

* **Execução Limpa:** Onboarding → Políticas → Aceite → Home com Drawer.
* **Adicionar Foto:** Selecione câmera/galeria; verifique compressão ≤200KB e EXIF removido.
* **Remover Foto:** Apaga arquivo e limpa prefs; volta a iniciais.
* **Fallback:** Sem foto, mostra iniciais; erro carrega fallback.
* **A11Y:** Toque ≥48dp, Semantics, foco visível.
* **Desempenho:** Drawer carrega ≤100ms.
* Execute testes unitários: `flutter test`.

## Checklist de Conformidade (Avatar)

- [x] Adicionar foto (câmera/galeria) funciona
- [x] Remover foto apaga arquivo local e limpa preferências
- [x] Fallback para iniciais quando sem foto ou em erro
- [x] Compressão ≤ ~200KB (usando quality:85)
- [x] EXIF/GPS removido
- [x] Drawer sem lentidão perceptível (meta: ≤100ms)
- [x] Ações acessíveis (≥48dp, rótulos/semantics, foco)
- [x] 1 unit test e 1 widget test passando

## Contribuição

Contribuições são bem-vindas! Para contribuir:

1.  Fork o repositório.
2.  Crie uma branch para sua feature: `git checkout -b feature/nova-funcionalidade`.
3.  Commit suas mudanças: `git commit -m 'Adiciona nova funcionalidade'`.
4.  Push e abra um Pull Request.

## Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para detalhes.

## Contato
* **Desenvolvedora:** Mariana Veiga
* **Email:** suporte@ecosteps.com (fictício)