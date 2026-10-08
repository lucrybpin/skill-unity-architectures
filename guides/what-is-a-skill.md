# O que é uma skill de IA?

Uma **skill** é um procedimento de trabalho reutilizável que uma ferramenta de IA pode
carregar para realizar uma tarefa. Ela reúne orientações sobre quando aplicar o
procedimento, como conduzir o trabalho e quais materiais consultar. Esse é o papel
descrito na [documentação oficial de skills](https://developers.openai.com/plugins/concepts/skills).

No nosso curso, o procedimento é transformar a ideia de um jogo Unity em uma arquitetura
explícita e manter as features dentro dela. A skill leva esse procedimento para outros
projetos sem exigir que o aluno reescreva todas as orientações na conversa.

## O que existe dentro de uma skill

O arquivo central é `SKILL.md`. Ele identifica a skill e descreve seu uso. Referências,
templates e scripts podem acompanhar o arquivo quando forem necessários. A IA usa
primeiro a identificação para decidir se o procedimento se aplica e então lê as
instruções pertinentes. [Estrutura e carregamento de skills](https://learn.chatgpt.com/docs/build-skills).

Neste repositório, a skill tem:

```text
unity-architecture/
  SKILL.md                  # Como conduzir a definição/aplicação/revisão
  references/
    unit-identity-design.md # Regras do primeiro perfil
    glue.md                 # Regras do segundo perfil
  assets/
    PROJECT.md              # Template de decisões do jogo
    AGENTS.md               # Template de instruções locais
    FEATURE.md              # Template de uma feature
  agents/
    openai.yaml             # Nome e mensagem inicial na interface do Codex
```

Nossa skill não precisa executar um programa auxiliar. As referências e os templates
são suficientes para seu workflow. O gerador na pasta `tools/` serve à manutenção do
repositório pelo autor; ele não faz parte da instalação da skill.

## Prompt, skill e contrato do projeto

Esses elementos trabalham juntos:

| Elemento | Pergunta que responde | Exemplo neste curso |
|---|---|---|
| Prompt | O que quero fazer agora? | “Defina a arquitetura deste survival usando Glue” |
| Skill | Qual procedimento deve orientar essa tarefa? | Ler contexto, aplicar o perfil e produzir o contrato |
| Perfil de arquitetura | Quais fronteiras o código deve respeitar? | Unit usa identidade; Glue explicita relações entre capacidades |
| `PROJECT.md` | Quais decisões foram tomadas para este jogo? | Namespace, features, composição, versão e escopo DRIVES |
| `AGENTS.md` | Onde a IA deve buscar as instruções deste projeto? | Referências aos contratos e regras locais |

No Codex, `AGENTS.md` é um mecanismo de instruções do projeto. Nossa adoção usa um bloco
curto nele para orientar a leitura dos contratos completos em `docs/architecture/`.
[Documentação de AGENTS.md](https://learn.chatgpt.com/docs/agent-configuration/agents-md).

O conhecimento específico do jogo fica no projeto. O procedimento reutilizável fica na
skill. Por isso, usar a mesma skill em dois jogos pode produzir contratos diferentes:
um escolhe Unit e outro escolhe Glue; um tem save/load e outro ainda não precisa dele.

## Como isso entra no processo do curso

```text
1. Ideia
   Descrever loop, jogador, câmera e escopo.

2. Definição da Arquitetura do Código
   Invocar a skill, escolher a fronteira e registrar o contrato.

3. Assets
   Preparar os assets e suas referências conforme a montagem prevista.

4. Implementação
   Solicitar features usando o contrato e revisar sua aderência.

5. Polir
   Melhorar apresentação e comportamento mantendo os donos de estado e as fronteiras.
```

Um exemplo de pedido da etapa 2:

```text
$unity-architecture Defina a arquitetura usando Unit/Identity Design.
O jogo é um runner 2D, com pulo, obstáculos, pontuação e tela de fim de jogo.
Entregue o contrato e o plano de arquivos; nesta etapa ainda não implemente gameplay.
```

A skill orienta a IA a produzir um mapa concreto: o que pertence à identidade,
quais módulos são privados, qual classe possui a pontuação, como o HUD recebe dados
e quem coordena fim de jogo e reinício.

O aluno deve conferir esse resultado antes de avançar para a implementação. A skill
fornece critérios de revisão; a correção do código continua sendo verificada pelo
comportamento, pelas dependências e pelo ciclo de vida implementados.

## Uma explicação curta para falar em aula

> Uma skill é um procedimento reutilizável que a IA consulta para trabalhar.
> Eu preparo o processo uma vez: como ler o projeto, definir responsabilidades,
> escolher uma arquitetura e revisar as features. Depois, invoco esse processo
> junto da ideia do jogo. Aqui usamos uma skill com dois perfis, Unit e Glue.
> O perfil define as regras; o contrato registra as escolhas específicas do jogo.
> Assim, conseguimos prever onde cada comportamento vai ficar e revisar a resposta
> da IA com critérios claros.

Esse texto é uma sugestão autoral de explicação, que você pode adaptar ao seu jeito de ensinar.

## Instalação, invocação e adoção são etapas diferentes

- **Instalar:** disponibilizar a pasta completa da skill para a ferramenta.
- **Invocar:** pedir que a ferramenta use o procedimento numa tarefa.
- **Adotar:** registrar no jogo o perfil escolhido e as decisões específicas.

Para fazer essas etapas na prática, siga [Como aplicar a skill](apply-the-skill.md).
Para uma conversa sem suporte a skills, use um documento completo de `profiles/` e
o prompt de definição. Os mesmos contratos continuam disponíveis em Markdown.
