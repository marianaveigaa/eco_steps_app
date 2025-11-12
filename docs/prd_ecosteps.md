# PRD — EduCare: Primeira Execução, Consentimento e Identidade

> **Objetivo**: Documento de Requisitos de Produto (PRD) para o aplicativo EcoSteps, com foco na jornada de primeiro uso, consentimento (LGPD) e identidade visual.

---

## 0) Metadados do Projeto
- **Nome do Produto/Projeto**: EcoSteps - Hábitos Sustentáveis
- **Responsável**: {{Mariana Veiga}}
- **Curso/Disciplina**: Desenvolvimento de Aplicações (Flutter)
- **Versão do PRD**: v1.0
- **Data**: 2025-10-07

---

## 1) Visão Geral
**Resumo**: O EcoSteps ajuda os usuários a desenvolver e monitorar hábitos sustentáveis, com foco em metas de redução de lixo, uso da água e da energia. Na primeira execução, o aplicativo apresenta um onboarding claro sobre como a medição do progresso é feita sem coletar dados sensíveis, garantino a privacidade do usuário antes de guiá-lo à tela inicial, onde vai criar a sua primeira meta.

**Problemas que ataca**: dificuldade em manter a consistência em metas ecológicas, falta de visibilidade do impacto pessoal e preocupação com a privacidade de dados de consumo.

**Resultado desejado**: primeira experiência engajante e transparente; conscientização sobre o processo de medição (auto-reportado) e decisões legais (LGPD).

---

## 2) Personas & Cenários de Primeiro Acesso
- **Persona principal**: Aluna universitária engajada com pautas de sustentabilidade, que busca formas práticas para reduzir seu impacto ambiental diário.
- **Cenário (happy path)**: abrir app → splash (decisão de rota) → onboarding (3 telas) → visualizar políticas de privacidade → consentimento explicíto → home com um card de boas-vindas para *escolher sua primeira meta semanal*.
- **Cenários alternativos**:
  - **Pular para consentimento** a partir do onboarding.
  - **Revogar consentimento** na tela de configurações, com confirmação e opção de *Desfazer*.

---

## 3) Identidade do Tema (Design)
### 3.1 Paleta e Direção Visual
- **Primária**: Green `#16A34A`
- **Secundária**: Teal `#14B8A6`
- **Acento**: Amber 400 `#FBBF24`
- **Superfície**: `#FFFFFF` (claro) / `#0B1220` (escuro)
- **Texto**: Gray `#374151` (claro) / `#E2E8F0` (escuro)
- Direção: **flat minimalista**, alto contraste **WCAG AA**, **useMaterial3: true**;
  **ColorScheme** derivada para consistência.

### 3.2 Tipografia
- Títulos: `headlineSmall` (peso 600)
- Corpo: `bodyLarge`/`bodyMedium`
- Escalabilidade: suportar **text scaling** (≥ 1.3) sem quebras.

### 3.3 Iconografia & Ilustrações
- Ícones simples (Lucide/Material) relacionados à natureza e sustentabilidade.
- Ilustrações em estados vazios (ex: "Nenhuma meta criada") com temática positiva e natural.

### 3.4 Prompts (imagens/ícone)
- **Ícone do app**: “Insígnia vetorial circular, fundo transparente, estilo flat; no centro, uma folha estilizada com três pequenas barras de progresso subindo em seu interior; paleta Green/Teal; bordas limpas, alto contraste, sem textos, 1024×1024.”
- **Hero/empty**: “Ilustração flat minimalista de uma pessoa regando uma pequena planta que cresce de dentro de um símbolo de reciclagem, atmosfera positiva e limpa, cores da paleta, sem texto.”

**Entrega de identidade**: grade de cores (hex), 2–3 imagens de referência (moodboard) e 1 prompt de ícone aprovado.

---

## 4) Jornada de Primeira Execução (Fluxo Base)
### 4.1 Splash
- Exibe logomarca; decide rota com base na existência e versão do consentimento.

### 4.2 Onboarding (3 telas)
1. **Bem‑vindo** (benefício: "Transforme pequenas ações em grandes impactos") — botão **Avançar** + **Pular**.
2. **Como funciona** (mecânica: "Escolha metas, registre seu progresso e veja seu impacto crescer") — **Avançar/Voltar** + **Pular**.
3. **Consentimento** (explicação: "Nós medimos seu avanço com base nas informações que você escolhe registrar. Nunca acessamos dados sensíveis.") — botão Entendi, ir para políticas; sem Pular.
- **DotsIndicator** sincronizado; oculto na última página.

### 4.3 Políticas e Consentimento
- **Leitura** de **Privacidade** e **Termos** (Markdown) com **barra de progresso** de leitura.
- Botão “**Marcar como lido**” habilita **somente** após 100% de scroll.
- Checkbox de **aceite** habilita após ambos os docs lidos; botão **Concordo** libera navegação para Home e persiste versão.

### 4.4 Home & Revogação
- Home com card de CTA: "Crie sua primeira meta sustentável da semana!".
- **Revogar** em Configurações → **AlertDialog** de confirmação + **SnackBar** com ação **Desfazer**.

---

## 5) Requisitos Funcionais (RF)
- **RF‑1** Dots sincronizados; ocultos na última tela do onboarding.
- **RF‑2** Navegação contextual: **Pular** vai direto para o consentimento; **Voltar/Avançar** funcionam entre as telas 1 e 2.
- **RF‑3** Visualizador de políticas em **Markdown** com progresso de leitura.
- **RF‑4** Consentimento **opt‑in**: habilitar somente após leitura dos dois docs e marcação do checkbox.
- **RF‑5** Decisão de rota no **Splash** verifica a versão do aceite de políticas.
- **RF‑6** Revogação com confirmação + **Snack Bar com Desfazer**; sem desfazer → retorna ao fluxo de consentimento.
- **RF‑7** Versão das políticas (v1) + `accepted_at` ISO8601; forçar releitura em nova versão.
- **RF‑8** Ícone gerado via `flutter_launcher_icons`.

---

## 6) Requisitos Não Funcionais (RNF)
- **A11Y**: alvos ≥ **48dp**, foco visível, **Semantics**, contraste AA; botões desabilitados **visíveis**.
- **Privacidade (LGPD)**: transparência nos textos, registro de aceite, revogação simples.
- **Arquitetura**: **UI → Service → Storage**; sem uso direto de `SharedPreferences` na UI.
- **Performance**: animações ~300ms.
- **Testabilidade**: serviço de preferências mockável.

---

## 7) Dados & Persistência (chaves)
- `privacy_read_v1`: bool
- `terms_read_v1`: bool
- `policies_version_accepted`: string (ex.: `v1`)
- `accepted_at`: string (ISO8601)
- `onboarding_completed`: bool
- (Opcional) `tips_enabled`: bool

**Serviço**: `PrefsService` com métodos *isPolicyAccepted(version)*, *acceptedPolicies(version)*, *revokeAcceptance()*.

---

## 8) Roteamento
- `/` → **Splash** (decide)
- `/onboarding` → PageView (3 telas)
- `/policy-viewer` → viewer markdown reutilizável
- `/home` → tela inicial

---

## 9) Critérios de Aceite
1. Dots sincronizados e ocultos na última tela.
2. **Pular** direciona ao consentimento.
3. Viewer de políticas com barra de progresso e “Marcar como lido” apenas no fim.
4. Checkbox/ação final habilitam somente após leitura dupla + aceite.
5. Splash leva corretamente à Home quando versão aceita existe.
6. Revogação com confirmação + **Desfazer** (SnackBar); sem desfazer → fluxo legal.
7. UI não usa `SharedPreferences` diretamente; tudo via serviço.
8. Ícones gerados e aplicados a pelo menos uma plataforma.

---

## 10) Protocolo de QA (testes manuais)
- **Execução limpa**: onboarding completo → políticas → aceite → Home com card de "primeira meta".
- **Leitura parcial**: um doc lido **não** habilita checkbox.
- **Leitura dupla + aceite**: habilita conclusão e navega para Home.
- **Reabertura**: vai direto à Home.
- **Revogação com Desfazer**: Clicar em "Revogar" e depois em "Desfazer" deve manter o usuário logado e na tela atual.
- **Revogação completa**: Clicar em "Revogar" e esperar o SnackBar sumir deve levar o usuário de volta à tela de consentimento.
- **A11Y**: Ativar text scaling (zoom de fonte) e verificar se a interface continua legível.

---

## 11) Riscos & Decisões
- **Risco**: Usuário não entender por que o app não pede dados de contas (água/luz). → **Mitigação**: Onboarding claro (tela 3) explicando o modelo de privacidade e medição auto-reportada.
- **Risco**: Lógica de consentimento acoplada à UI. → **Mitigação**: PrefsService como única fonte da verdade para o estado do consentimento.
- **Decisão**: Usar desabilitação de botões em vez de escondê-los para guiar o usuário no fluxo.
- **Decisão**: Manter os textos de políticas como arquivos Markdown nos assets do app para fácil versionamento e acesso offline.

---

## 12) Entregáveis
1. PRD preenchido + identidade (paleta, moodboard, prompt).
2. Implementação funcional do fluxo base + `PrefsService`.
3. Evidências (prints) dos estados de onboarding/consentimento/revogação.
4. Ícone gerado (comando e resultado visível em uma plataforma).

---

## 13) Backlog de Evolução (opcional)
- Tela **Configurações/Privacidade** (reabrir políticas, granularidade de consentimentos).
- Hash por arquivo de política (expira aceite quando mudar).
- Telemetria consciente do funil de primeira execução (com consentimento).
- Criptografia seletiva de preferências sensíveis.

---

## 14) Referências internas
- DotsIndicator paramétrico e animado.
- Onboarding com visibilidade inteligente (Pular/Voltar/Avançar).
- PolicyViewerPage com progresso e “Marcar como lido”.
- `PrefsService` + chaves centralizadas.
- Splash com decisão de rota por flags/versão de aceite.
- Revogação com confirmação + SnackBar (Desfazer).
- Geração de ícone com `flutter_launcher_icons`.

---

### Checklist de Conformidade (colar no PR)
- [ ] Dots sincronizados e ocultos na última tela
- [ ] Pular → consentimento; Voltar/Avançar contextuais
- [ ] Viewer com progresso + “Marcar como lido”
- [ ] Aceite habilita somente após leitura dos 2 docs
- [ ] Splash decide rota por versão aceita
- [ ] Revogação com confirmação + **Desfazer**
- [ ] Sem `SharedPreferences` direto na UI
- [ ] Ícones gerados
- [ ] A11Y (48dp, contraste, Semantics, text scaling)

> **Nota ao aluno**: use este exemplo como guia, **troque o tema** e adapte a identidade/terminologia ao seu domínio (saúde, finanças, mobilidade, etc.).

