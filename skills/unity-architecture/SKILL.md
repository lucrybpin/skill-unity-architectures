---
name: unity-architecture
description: Definir, adotar ou revisar arquitetura de jogos Unity com Unit/Identity Design ou Glue. Use também ao planejar ou implementar features em projetos que adotaram esses contratos. Preserve o perfil existente; não use para impor uma arquitetura a um projeto Unity sem esse contexto.
---

# Arquitetura Unity com Unit / Identity Design e Glue

Transforme a ideia do jogo em um contrato que permita prever onde cada feature fica,
quem possui seu estado e como ela se comunica. Use o perfil escolhido pelo desenvolvedor
e mantenha a implementação dentro dessa fronteira.

Esta skill contém as referências e os templates necessários. Funciona sem scripts,
conectores ou acesso ao repositório de origem depois de instalada.

## Identificar o pedido e o contexto

Leia instruções locais, `docs/architecture/PROJECT.md`, `ARCHITECTURE.md` e decisões
existentes, quando disponíveis. Em um projeto acessível, confira
`ProjectSettings/ProjectVersion.txt`, `Packages/manifest.json` e os pontos de composição
relevantes. Use o contexto fornecido quando não houver acesso aos arquivos.

Identifique o resultado solicitado:

- **Definir:** produzir o contrato e o plano de implementação; não criar gameplay.
- **Adotar:** gravar o contrato escolhido no projeto e integrar suas instruções locais.
- **Implementar:** entregar a feature pedida dentro do contrato já adotado.
- **Revisar:** apontar violações concretas e suas consequências; corrigir somente se solicitado.

Instalar esta skill não escolhe um perfil nem autoriza refatorar um jogo existente.
Se o desenvolvedor pedir somente uma explicação ou comparação, responda sem criar arquivos.

## Selecionar uma única fronteira

Um contrato local já adotado é a referência do projeto. Preserve seu perfil, versão e
escopo; a versão desta skill não atualiza automaticamente o contrato do jogo.

Para uma definição nova, use a escolha explícita do desenvolvedor. Se ela ainda não
existir, explique a decisão com estes critérios e peça apenas a informação necessária:

| Perfil | Fronteira desejada | Coordenação |
|---|---|---|
| `unit-identity-design` | Uma identidade pública, como `Character`, protege módulos privados | Identidade coordena internamente; controller de contexto integra unidades |
| `glue` | Capacidades como `Health` funcionam independentemente de seus consumidores | Glues nomeadas conectam capacidades, input e apresentação |

Depois da seleção, leia integralmente **somente a referência do perfil escolhido**:

- Unit / Identity Design: [references/unit-identity-design.md](references/unit-identity-design.md).
- Glue: [references/glue.md](references/glue.md).

Cada referência já contém as convenções comuns. Leia as duas somente se o pedido for
compará-las. Se o contrato local estiver numa versão diferente, aplique suas regras e
use a referência empacotada apenas para uma atualização/comparação solicitada.

## Definir e adotar o contrato

Use [assets/PROJECT.md](assets/PROJECT.md) para registrar perfil, versão da referência,
namespace, ambiente real, responsabilidades, composição, decisões e hipóteses.
Apresente a árvore dos arquivos necessários, APIs de intenção, eventos/payloads,
dono de cada estado, referências de Inspector e ordem de inicialização/cleanup.

Ao iniciar um projeto novo ou desenhar uma entidade não trivial, sugira DRIVES quando
ainda não estiver em uso e registre seu escopo. Quando adotado, somente Input chama Execution. Use Flyweight Registry
quando escolhas persistentes de assets exigirem IDs resolvíveis em save/load.

Quando a gravação do contrato estiver autorizada:

1. Copie a referência selecionada para `docs/architecture/ARCHITECTURE.md`.
2. Grave `docs/architecture/PROJECT.md` preenchido, usando a versão daquela referência.
3. Incorpore [assets/AGENTS.md](assets/AGENTS.md) ao `AGENTS.md` da raiz do jogo.
   Preserve instruções existentes e evite repetir um bloco já integrado.
4. Registre mudanças que realmente alterem uma decisão; use a seção de PROJECT ou
   `docs/architecture/DECISIONS.md` se o histórico justificar um arquivo separado.

Os caminhos acima são relativos à raiz do jogo, não à pasta instalada da skill.
Não copie a skill para `Assets/` nem crie pastas vazias de gameplay apenas para ilustrar
a árvore. Em projetos existentes, delimite o escopo de adoção e preserve GUIDs e APIs
fora da mudança solicitada.

Não deixe campos do template sem definição no resultado: substitua-os por dados reais,
por hipóteses explícitas ou por uma pendência nomeada. A ausência de uma decisão
indispensável bloqueia apenas o trabalho que depende dela.

## Implementar uma feature dentro do contrato

Use [assets/FEATURE.md](assets/FEATURE.md) quando um arquivo de contrato trouxer valor;
uma feature pequena pode usar um resumo na conversa. Antes do código, indique resultado
observável, arquivos, responsabilidades, estado, comunicação, montagem e verificação.

Prossiga com a implementação já autorizada sem transformar esse resumo numa aprovação
adicional. Mudanças de perfil, atualização do contrato ou refatorações amplas devem
corresponder ao pedido do desenvolvedor, não surgir como consequência automática.

Mantenha a fronteira do perfil: em Unit, consumidores usam a fachada; em Glue,
capacidades não implementam as integrações que pertencem às glues. Aplique as regras
de Data imutável, cópia runtime, referências explícitas e ciclo de vida da referência.

## Revisar e relatar

Leia os arquivos que participam da feature e identifique violações com caminho,
trecho responsável, consequência e correção sugerida. Priorize quebra de fronteira,
estado duplicado, leitura/mutação de Data em gameplay, descoberta de dependências e
falhas de inicialização/inscrição. Use os critérios de aceite da referência selecionada.

Valide o comportamento de forma proporcional à mudança. No resultado, informe o
perfil/versão utilizados, arquivos entregues, montagem necessária, verificações
executadas e pendências. Uma revisão por leitura não comprova execução em Play Mode.
