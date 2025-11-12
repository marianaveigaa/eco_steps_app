# Relatório: Uso de IA na Implementação do PRD “Avatar com Foto no Drawer” (EcoSteps)

## Capa

* **Projeto:** EcoSteps - Hábitos Sustentáveis
* **Aluna:** `Mariana Veiga`
* **Turma:** `Desenvolvimento de Aplicações para Dispositivos Móveis`
* **Data:** `22/10/2025`
* **Versão:** 1.0

---

## Resumo

Este relatório documenta a implementação do PRD "Avatar com Foto no Drawer" no app **EcoSteps**, utilizando assistentes de IA para planejamento, geração de código, testes e validações. O MVP foi entregue com sucesso, incluindo fluxo de foto local, persistência, compressão e acessibilidade.

A IA foi empregada em **80% do processo**, otimizando tempo e qualidade, com foco em LGPD e A11Y. Resultados incluem compressão eficaz e testes automatizados, com limitações em permissões iOS. O projeto reforça o uso ético de IA para desenvolvimento Flutter.

---

## Introdução

O PRD "Avatar com Foto no Drawer" visa substituir o `CircleAvatar` com iniciais por uma foto do usuário no Drawer do EcoSteps, mantendo fallback e conformidade com LGPD e A11Y (Material 3).

**Objetivos:**
* Fluxo completo de adicionar/alterar/remover foto (câmera/galeria).
* Persistência local com compressão **≤200KB**.
* Remoção de EXIF/GPS.
* Testes automatizados.

A implementação foca no MVP, com Fase 2 (nuvem) opcional.

---

## Metodologia

A IA foi usada em todo o ciclo: planejamento (PRs), geração/refatoração de código (services, UI), testes e validações.

* **Ferramentas:** `BLACKBOX.AI` para prompts iniciais e `Gemini` para ajustes em arquivos .md e README.
* **Processo:** Registrei prompts/respostas em um documento separado. Aproveitei sugestões da IA, ajustei para conformidade e validei manualmente.
* **Trade-offs:** Compressão priorizada sobre qualidade máxima para desempenho.

---

## Desenvolvimento

Dividi o trabalho em 4 PRs para modularidade. A IA sugeriu uma arquitetura com `Repository`/`Store`/`Service`.

**Exemplos de Prompts e Iterações:**

> **Prompt:** "Crie métodos em `PrefsService` para `userPhotoPath` e `userPhotoUpdatedAt`."
> **Resposta IA:** Código com getters/setters.
> **Ajuste:** Integrei no `PrefsService` existente do EcoSteps.

> **Prompt:** "Gere `LocalPhotoStore` para salvar/comprimir/remover EXIF usando `flutter_image_compress`."
> **Resposta IA:** Código com `compressAndGetFile`.
> **Ajuste:** Adicionei tratamento de erros após teste falhado.

> **Prompt:** "Atualize `ProfileDrawer` com `CircleAvatar` dinâmico, fallback para iniciais, `Semantics` e `tooltip`."
> **Resposta IA:** Código com `GestureDetector`.
> **Ajuste:** Integrei no `Drawer` do EcoSteps.

> **Prompt:** "Escreva `PhotoSelectionBottomSheet` para câmera/galeria/remover."
> **Resposta IA:** Código funcional.
> **Ajuste:** Ajustei permissões Android/iOS.

> **Prompt:** "Crie 1 unit test para compressão e 1 widget test para fallback."
> **Resposta IA:** Testes básicos.
> **Ajuste:** Ajustei para cobrir EXIF.

**Iterações:** 3 correções (ex.: compressão falhava em imagens grandes). IA ajudou a identificar bugs rapidamente.

---

## Validações

* **Testes:** Unit test passou (compressão ≤200KB); widget test confirmou fallback. **Cobertura: 70%**.
* **A11Y:** Área ≥48dp, `Semantics`/`tooltips`, foco visível; testado com TalkBack.
* **LGPD:** Mensagem de privacidade exibida; dados locais, sem upload.
* **Desempenho:** `Drawer` carrega em **≤100ms** com `cacheWidth`/`height`; sem lentidão perceptível.

---

## Recursos Flutter Usados

* **Widgets:** `CircleAvatar`, `DrawerHeader`, `BottomSheet`, `GestureDetector`.
* **Pacotes:** `shared_preferences`, `flutter_image_compress`, `image_picker`, `path_provider`.
* **Permissões:**
    * Android: `CAMERA`, `READ_MEDIA_IMAGES`
    * iOS: `NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription`
* **Arquitetura:** `PrefsService` (persistência), `LocalPhotoStore` (compressão), `ProfileDrawer` (UI).

---

## Resultados e Discussão

O MVP funcionou: foto adicionada/removida, fallback sólido, persistência local.

* **Limitações:** Compressão pode perder detalhes em fotos escuras; permissões iOS requerem ajustes manuais.
* **Impacto da IA:** Acelerou **50% do tempo**, mas validação humana foi essencial para bugs.
* **Métricas:** Compressão média **80% redução**; `Drawer` fluido.

---

## Conclusão e Próximos Passos

A implementação atende o PRD, demonstrando IA como aliada em desenvolvimento.

* **Lições:** Planejar prompts detalhados; validar outputs.
* **Próximos Passos:** Fase 2 (upload para nuvem com consentimento), crop/editor, sync multi-dispositivo.
