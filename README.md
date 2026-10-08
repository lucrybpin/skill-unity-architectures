# Unity Architectures: skill e contratos para Unity com IA

Este repositório contém a skill **`unity-architecture`** e os contratos de Unit / Identity Design e Glue. Ele foi preparado para a etapa **Definição da Arquitetura do Código** do curso *Introdução ao Vibe Coding com Unity* e para orientar a implementação das features depois dessa definição.

Repositório de destino: [lucrybpin/skill-unity-architectures](https://github.com/lucrybpin/skill-unity-architectures).

A pasta instalável é [skills/unity-architecture](skills/unity-architecture/SKILL.md). Ela reúne o procedimento, as referências dos dois perfis e os templates; pode ser instalada sem o restante deste repositório.

Os dois documentos completos continuam disponíveis para leitura e uso portátil em outras IAs:

- [Unit / Identity Design](profiles/unit-identity-design.md)
- [Glue](profiles/glue.md)

Cada documento inclui o perfil, as convenções comuns, exemplos de fronteiras, organização de pastas, regras de estado/referências, ciclo de vida e critérios de revisão. Basta entregar **um** deles ao assistente; os arquivos de `source/` são usados para manutenção do kit e não precisam acompanhar cada conversa.

Versão do contrato: **1.0.0**. Referência analisada: `unity-game-dev-essentials-architecture-for-indie-devs`, Unity `6000.3.11f1`. Essa versão identifica o projeto examinado; os perfis não exigem migrar todos os projetos para ela.

## Começar com a skill

Quando os arquivos estiverem publicados no repositório, peça ao Codex:

```text
$skill-installer Instale a skill do repositório
https://github.com/lucrybpin/skill-unity-architectures
usando o caminho skills/unity-architecture para meu usuário.
```

Depois, abra seu jogo Unity e use:

```text
$unity-architecture Defina e adote a arquitetura deste projeto usando Glue.
A ideia é um survival 3D em primeira pessoa, com movimento, vida, HUD e pausa.
Registre o contrato e integre suas instruções ao AGENTS.md existente.
Nesta etapa, ainda não implemente gameplay.
```

Para instalação manual por projeto, copie a pasta completa para `.agents/skills/unity-architecture/` na raiz do jogo. Os mecanismos de instalação/invocação estão descritos na [documentação oficial de skills](https://learn.chatgpt.com/docs/build-skills).

- [O que é uma skill?](guides/what-is-a-skill.md): explicação acessível e texto sugerido para a aula.
- [Como aplicar a skill](guides/apply-the-skill.md): instalação, verificação, adoção, implementação e revisão.

Instalação disponibiliza o procedimento; adoção registra o perfil e as decisões no jogo. A skill preserva o contrato de um projeto existente e lê apenas o perfil pertinente à tarefa.

## Escolher a fronteira antes de implementar

| Decisão | Unit / Identity Design | Glue |
|---|---|---|
| Entrada pública principal | Identidade, como `Character` | Capacidade, como `Health`, e integração, como `HealthHudGlue` |
| Organização da implementação | Módulos internos privados | Capacidades independentes montadas explicitamente |
| Coordenação dentro da entidade | Identidade | Glues da composição |
| Coordenação entre features | Coordenador do contexto | Glue específica da relação |
| Onde procurar uma nova regra de vida | Módulo privado de saúde da identidade | Capacidade `Health` |
| Onde ligar vida ao HUD | Coordenador vincula estado público da identidade | `HealthHudGlue` |
| Custo a observar | Fachada pode crescer; exige bons módulos e escopos | Mais referências de montagem; exige glues com escopo claro |
| Tendência de uso sugerida neste kit | Quando a identidade e seu vocabulário devem ser a fronteira estável | Quando a composição de capacidades independentes é a fronteira desejada |

Ambas admitem reutilização, testes e evolução. A escolha não demonstra desempenho ou qualidade por si só. Escolha pelo tipo de fronteira que você quer que o desenvolvedor e a IA encontrem no projeto.

Use um perfil principal por contexto. Se houver mistura, registre exatamente onde cada fronteira vale; não entregue os dois contratos completos como regras simultâneas para a mesma entidade. DRIVES pode ser uma decomposição interna de entidades em qualquer perfil, com escopo explícito no contrato do projeto.

## Uso rápido em uma conversa

Este é o modo portátil, para conversas que recebem arquivos/conteúdo sem uma instalação da skill.

1. Escolha e anexe/cole um arquivo de `profiles/`.
2. Preencha [PROJECT.md](templates/PROJECT.md), ou forneça suas informações na mensagem.
3. Use [o prompt da etapa 2](prompts/define-architecture.md).
4. Confira o plano de arquivos, responsabilidades, dependências e montagem proposto.
5. Para implementar uma feature, use [o prompt de implementação](prompts/implement-feature.md) com seu critério de aceite.

Se o assistente tiver acesso a arquivos locais, peça explicitamente a leitura. Se receber apenas um link e não puder abri-lo, entregue o conteúdo ou anexe o arquivo. Um link, o nome de uma arquitetura ou a frase “siga boas práticas” não informa as regras que o assistente precisa executar.

Prompt mínimo de adoção:

```text
Leia o contrato de arquitetura anexado e aplique suas regras a este projeto Unity.
Perfil escolhido: <unit-identity-design ou glue>.
Ideia do jogo: <descrição>.
Primeira feature: <resultado observável>.
Antes do código, apresente arquivos, responsabilidades, dono de cada estado,
API pública, dependências e montagem no Inspector. Explicite as hipóteses.
Use a versão e os pacotes reais do projeto. Siga o perfil escolhido e registre
qualquer mudança de fronteira. Nesta etapa, entregue apenas a definição;
a implementação será solicitada depois.
```

## Adoção em um repositório de jogo

Estrutura sugerida no jogo de destino:

```text
AGENTS.md
docs/architecture/ARCHITECTURE.md    # Cópia de um perfil completo
docs/architecture/PROJECT.md         # Decisões específicas deste jogo
docs/architecture/DECISIONS.md       # Registro curto de mudanças
docs/features/<FeatureName>.md       # Contrato da feature, quando necessário
```

Copie o perfil selecionado para `ARCHITECTURE.md` e preencha o template do projeto. O [template de AGENTS.md](templates/AGENTS.md) é uma porta de entrada para ferramentas que leem esse arquivo; em outras ferramentas, entregue as mesmas instruções pela conversa ou pelo mecanismo de contexto disponível. **Se já existir AGENTS.md, incorpore o trecho pertinente e preserve as instruções existentes.**

O template dentro deste kit não adota um perfil no projeto Unity que contém o kit. A adoção acontece no projeto de destino, após a escolha do perfil.

O [template de feature](templates/FEATURE.md) registra o que precisa continuar previsível durante a implementação. Para uma feature pequena, esse contrato pode ser um resumo na própria conversa; não é necessário criar documentação extensa para toda alteração.

## Manter e gerar os documentos completos

```text
ArchitectureKit/
  README.md
  VERSION
  source/
    introduction.md
    common.md
    unit-identity-design.md
    glue.md
  profiles/
    unit-identity-design.md          # Gerado: pronto para anexar
    glue.md                          # Gerado: pronto para anexar
  templates/
    AGENTS.md
    PROJECT.md
    FEATURE.md
  skills/
    unity-architecture/
      SKILL.md                       # Procedimento e seleção de perfil
      agents/openai.yaml             # Apresentação na interface
      references/
        unit-identity-design.md      # Gerado: inclui regras comuns
        glue.md                      # Gerado: inclui regras comuns
      assets/
        AGENTS.md                    # Gerado a partir de templates/
        PROJECT.md                   # Gerado a partir de templates/
        FEATURE.md                   # Gerado a partir de templates/
  guides/
    what-is-a-skill.md
    apply-the-skill.md
  prompts/
    define-architecture.md
    implement-feature.md
  tools/
    Export-Architecture.ps1
  reference-notes.md
```

Edite `source/common.md` para regras compartilhadas e `source/<perfil>.md` para regras do perfil. `source/introduction.md` é o cabeçalho compartilhado. O procedimento é mantido diretamente em `skills/unity-architecture/SKILL.md`; templates são mantidos em `templates/`. Atualize `VERSION` e a linha `ArchitectureVersion` do template de projeto quando mudar a versão do contrato, depois regenere os recursos.

Não edite `profiles/`, `skills/unity-architecture/references/` ou `skills/unity-architecture/assets/` à mão: suas alterações seriam perdidas na geração. Os arquivos gerados devem ser commitados para a skill já funcionar ao ser baixada.

A partir da raiz deste kit, no PowerShell:

```powershell
# Gerar os perfis, as referencias e os templates empacotados na skill.
./tools/Export-Architecture.ps1

# Conferir se todos os recursos gerados correspondem às fontes.
./tools/Export-Architecture.ps1 -Check

# Gerar um contrato único com as decisões de um jogo já preenchidas.
./tools/Export-Architecture.ps1 -Profile glue `
  -ProjectFile ./MyGameProject.md `
  -OutputFile ./MyGameArchitecture.md
```

`MyGameProject.md` é uma cópia preenchida de `templates/PROJECT.md`, criada por você. `Architecture` e `ArchitectureVersion` devem corresponder ao perfil/versão escolhidos. `-ProjectFile` exige `-OutputFile`, para preservar os perfis gerais. Para substituir um arquivo customizado já existente, acrescente `-Force`. O gerador usa somente arquivos locais e não publica nem instala nada.

O kit usa uma única fonte para as regras, exportando documentos portáteis e referências autossuficientes da skill. As cópias empacotadas são geradas para a instalação funcionar independentemente do restante do repositório.

## Distribuição sugerida no GitHub

Copie **o conteúdo de `ArchitectureKit/` para a raiz de `skill-unity-architectures`**, incluindo `.gitignore` e `.gitattributes`. O caminho remoto será `skills/unity-architecture`; não adicione uma pasta `ArchitectureKit` acima dele no novo repositório. O projeto Unity do curso fica fora desse pacote.

Antes do commit, execute o gerador com `-Check` e confira os arquivos com `git status --short`. A pasta `skills/` e os documentos gerados precisam acompanhar o commit. Defina a licença dos documentos para indicar como alunos podem copiar/adaptar o material.

Para uma aula ou projeto, registre a versão do contrato e um commit específico. Um link de branch como `main` acompanha alterações; um link de commit identifica o conteúdo daquela versão. O GitHub oferece permalinks de arquivo por commit; ao visualizar o arquivo, a tecla `y` converte a URL para esse formato. [Documentação oficial de permalinks](https://docs.github.com/en/repositories/working-with-files/using-files/getting-permanent-links-to-files).

Exemplo de URL por commit após a publicação:

```text
https://github.com/lucrybpin/skill-unity-architectures/blob/<commit>/profiles/glue.md
```

Mantenha uma cópia do contrato no jogo para ele continuar compreensível sem consultar a internet. Atualizar o kit não deve mudar automaticamente a arquitetura de projetos que adotaram uma versão anterior.

Política de versão proposta:

- **MAJOR:** mudança incompatível de fronteira, API estrutural ou convenção exigida.
- **MINOR:** regra ou exemplo novo compatível com a fronteira existente.
- **PATCH:** esclarecimento, correção de texto ou exemplo sem mudança do contrato.

O conteúdo local está preparado para esse repositório. Os exemplos de instalação ficam utilizáveis depois de os arquivos serem publicados. Para distribuição por um diretório de plugins, a skill também pode ser empacotada como plugin futuramente; isso é uma forma adicional de distribuição descrita na [documentação oficial](https://learn.chatgpt.com/docs/build-skills).

## Usar no curso

Comece por [O que é uma skill?](guides/what-is-a-skill.md) e demonstre [Como aplicar a skill](guides/apply-the-skill.md). O roteiro e a análise de origem estão em [reference-notes.md](reference-notes.md), com as decisões acrescentadas e um exercício que compara as duas fronteiras usando a mesma feature.

O resultado que a aula pode cobrar é concreto: outro desenvolvedor deve conseguir prever onde mora uma regra, quem pode alterá-la e como ligá-la à cena. O contrato reduz decisões improvisadas; o plano e a revisão de cada feature verificam se a IA realmente o aplicou.
