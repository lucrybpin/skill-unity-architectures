# Como aplicar a skill unity-architecture

Este guia usa o repositório
[lucrybpin/skill-unity-architectures](https://github.com/lucrybpin/skill-unity-architectures)
e a pasta instalável `skills/unity-architecture` na raiz dele.

Instalar disponibiliza o procedimento. Adotar registra o perfil no seu jogo. A skill
também pode ser usada apenas para explicar/comparar perfis, sem gravar arquivos.

## 1. Instalar no Codex

### Opção A: pedir a instalação pelo próprio Codex

Envie esta mensagem quando os arquivos já estiverem publicados no repositório:

```text
$skill-installer Instale a skill do repositório
https://github.com/lucrybpin/skill-unity-architectures
usando o caminho skills/unity-architecture para meu usuário.
```

O instalador pode receber repositórios externos. A skill instalada deve aparecer
como `unity-architecture`; se ela não aparecer, reinicie a sessão do Codex.
[Instalação e descoberta de skills](https://learn.chatgpt.com/docs/build-skills).

### Opção B: incluir a skill somente em um projeto

Baixe/clone o repositório e copie a pasta **inteira** `skills/unity-architecture` para:

```text
<raiz-do-jogo>/.agents/skills/unity-architecture/
```

A pasta deve conter `SKILL.md`, `references/`, `assets/` e `agents/`. Copiar apenas
`SKILL.md` perde as regras dos perfis e os templates. O Codex descobre skills em
`.agents/skills` do projeto; abra a sessão na raiz do jogo.
[Locais de descoberta](https://learn.chatgpt.com/docs/build-skills).

Essa opção permite versionar a skill junto do jogo e compartilhar a mesma cópia com
a turma/equipe. Se já houver uma cópia instalada para o usuário, evite manter versões
duplicadas com o mesmo nome na mesma sessão.

Você pode obter o repositório usando Git:

```powershell
git clone https://github.com/lucrybpin/skill-unity-architectures.git
```

Copie a pasta da skill pelo gerenciador de arquivos para o destino acima. Ela pertence
à configuração da ferramenta, fora de `Assets/`.

## 2. Verificar se a skill está disponível

No Codex CLI ou na extensão de IDE, use `/skills` ou digite `$` para selecionar a skill.
A invocação explícita é uma boa forma de demonstrar seu uso em aula.
[Invocação de skills](https://learn.chatgpt.com/docs/build-skills).

Envie este pedido de verificação:

```text
$unity-architecture Explique os perfis disponíveis e quais arquivos desta skill
você consultaria para definir uma arquitetura usando Glue. Não crie arquivos.
```

O resultado deve explicar a fronteira de Glue e apontar `references/glue.md` e os
templates relevantes. Confira os arquivos realmente lidos nos registros da ferramenta;
uma resposta textual isolada não prova que a instalação aconteceu.

## 3. Definir e adotar a arquitetura do jogo

Abra o projeto Unity na ferramenta e envie, por exemplo:

```text
$unity-architecture Defina e adote a arquitetura deste projeto usando Glue.

Ideia: survival 3D em primeira pessoa.
Primeira versão: movimentação, vida, fonte de dano, HUD e pausa.
Fora do escopo inicial: inventário, crafting, multiplayer e save/load.

Leia a versão e os pacotes reais do projeto. Registre as decisões nos documentos
de arquitetura e integre as instruções ao AGENTS.md existente, preservando seu conteúdo.
Apresente responsabilidades, dono de cada estado, APIs, dependências e montagem.
Nesta etapa, não implemente gameplay.
```

Ao pedir **definir e adotar**, você autoriza a gravação do contrato e a integração das
instruções de arquitetura ao jogo. Para receber somente a proposta, peça **definir**
e explicite que não quer arquivos gravados.

O resultado esperado da adoção é:

```text
<raiz-do-jogo>/
  AGENTS.md
  docs/architecture/
    ARCHITECTURE.md
    PROJECT.md
    DECISIONS.md            # Quando o histórico justificar um arquivo separado
```

Em `ARCHITECTURE.md` fica uma cópia completa de **um** perfil. Em `PROJECT.md` ficam
perfil/versão, namespace, ambiente, responsabilidades, escopo DRIVES e decisões
específicas do jogo. `AGENTS.md` orienta a leitura desses arquivos nas tarefas do projeto.
[Papel das instruções do projeto no Codex](https://learn.chatgpt.com/docs/agent-configuration/agents-md).

Se escolher Unit / Identity Design, mude a seleção no pedido. Não substitua o perfil
de um jogo existente sem solicitar e delimitar essa mudança.

## 4. Conferir a proposta antes da etapa de implementação

Para o exemplo de Glue, confira estas decisões:

- `Health` possui vida e aplica dano/cura.
- `HealthHudGlue` relaciona vida à apresentação.
- `PlayerMovementGlue` conecta ações do jogador à capacidade de movimento.
- `PauseGlue` coordena a política de pausa e o menu.
- O composition root inicializa capacidades/glues antes de habilitar gameplay.

Para o exemplo de Unit, a fronteira pública do personagem seria a identidade e suas
regras internas ficariam em módulos privados. O contrato deve mostrar qual desses
desenhos foi adotado, sem deixar duas autoridades concorrentes para a mesma feature.

Peça à IA para explicar onde entraria uma nova feature antes de pedir seu código.
Se você conseguir prever a resposta pelos documentos, o contrato está cumprindo seu papel.

## 5. Implementar uma feature

Depois da etapa de assets e do contrato, use um pedido concreto:

```text
$unity-architecture Implemente vida, dano e barra de vida conforme o contrato adotado.

Critérios de aceite:
- A barra apresenta o valor inicial ao entrar na cena.
- Dano reduz vida até zero e morte ocorre uma vez por transição.
- Duas instâncias podem receber dano independentemente.
- Desativar e reativar o HUD reconecta seus eventos sem duplicação.

Apresente um resumo dos arquivos e da montagem e prossiga com a implementação.
No final, informe a configuração de Inspector e as verificações executadas.
```

O perfil já registrado deve ser preservado. Solicitar uma feature não exige escolher
a arquitetura novamente nem autoriza reorganizar todo o projeto.

## 6. Revisar aderência

```text
$unity-architecture Revise os arquivos desta feature contra o contrato do projeto.
Indique caminho, violação, consequência e correção sugerida.
Neste pedido, entregue a revisão sem alterar arquivos.
```

Para solicitar correções, acrescente explicitamente essa ação e seu escopo. A revisão
deve apontar problemas concretos, como acesso a módulos privados em Unit, integração
dentro de uma capacidade em Glue ou estado corrente armazenado no Data asset.

## Atualizar a skill e o contrato

A skill instalada é uma cópia do pacote. Para receber uma atualização do repositório,
atualize/reinstale essa cópia pelo mecanismo escolhido. A referência copiada para o
jogo preserva sua versão até uma atualização de contrato ser solicitada.

Se quiser atualizar também o contrato do jogo, peça à IA para comparar as regras e
explicar alterações necessárias antes de fazer a migração. Features existentes devem
continuar compreensíveis a partir dos documentos daquela versão.

## Usar em outra ferramenta de IA

Quando a ferramenta oferecer suporte a skills, instale a pasta pelo mecanismo próprio
dela. O caminho de instalação e a forma de invocação dependem do produto.

Para uma ferramenta que recebe arquivos/conteúdo na conversa, entregue:

1. Um documento de `profiles/`.
2. A ideia/contexto do jogo ou um `PROJECT.md` preenchido.
3. O [prompt de definição](../prompts/define-architecture.md) ou de implementação.

Esse é o modo portátil do kit. Apenas anexar `SKILL.md` não entrega o conteúdo das
referências que ele solicita; envie também o perfil escolhido quando não existir
acesso ao pacote completo.

## Resolver problemas de uso

| Sintoma | O que conferir |
|---|---|
| A skill não aparece | Pasta inteira no local de descoberta, nome e frontmatter; reiniciar a sessão se necessário |
| A referência não foi encontrada | `references/` deve acompanhar `SKILL.md` na instalação |
| A IA escolhe outro perfil | Seleção explícita e `Architecture` do contrato do jogo |
| Um perfil novo parece ter sido aplicado ao jogo antigo | Versão local adotada e escopo do pedido de atualização |
| O resultado tem regras, mas não tem plano concreto | Pedir arquivos, donos de estado, APIs e montagem da primeira fatia |
| O código parece organizado, mas viola a fronteira | Solicitar revisão usando os critérios do perfil selecionado |

Orientações de produto conferidas na documentação oficial em **2026-10-08**. Os
exemplos de jogo e o procedimento de adoção acima pertencem a este kit.
