# Origem, decisões acrescentadas e uso didático

Este arquivo documenta a leitura do projeto `unity-game-dev-essentials-architecture-for-indie-devs`, fornecido como referência pelo autor do curso. Os caminhos abaixo são relativos à raiz desse projeto, que não está incluído no kit. Análise realizada em **2026-10-08**, com `ProjectVersion.txt` indicando Unity `6000.3.11f1`.

## O que foi observado no código

| Evidência no projeto de referência | Interpretação usada no kit |
|---|---|
| `Assets/Unit Design Architecture/Character/Scripts/Character.cs` constrói `CharacterMovement` e `CharacterHealth`, encaminha input e oferece `ReceiveDamage`/`Heal` | A identidade é o ponto de composição e de intenção da entidade |
| `CharacterMovement.cs` e `CharacterHealth.cs` são classes C# comuns | Módulos internos podem ser objetos comuns com dependências injetadas |
| `CharacterData.cs` agrupa `CharacterMovementData` e `CharacterHealthData` | Configuração de uma identidade pode compor subconfigurações |
| `Assets/Unit Design Architecture/Scene/SceneController.cs` cria `ActionReader`, coordena triggers, HUD, pausa e dia/noite | Um contexto possui um ponto de composição e coordenação das unidades |
| `Assets/Unit Design Architecture/Day and Night/DayAndNightController.cs` constrói relógio, skybox e fog, conectando eventos | A unidade também pode ser um fluxo sem um GameObject próprio |
| `PauseMenuController.cs` e `SettingsMenuController.cs` retornam respostas por `Task` | Controllers podem abstrair uma interação assíncrona, se houver contrato de conclusão/cancelamento |
| `Assets/Glue Archictecture/Glue/First Person System/FirstPersonSystem.cs` recebe input e encaminha movimento/rotação ao componente `FirstPerson` | A integração está separada da capacidade de movimento |
| `Assets/Glue Archictecture/Glue/Day and Night/DayAndNight.cs` conecta `TimeOfDay` a `DynamicSkybox` e `DynamicFog` | Glue traduz fatos de uma capacidade em comandos de apresentação |
| `Assets/Glue Archictecture/Glue/Scene Manager/SceneManager.cs` coordena input, primeira pessoa e pausa | Existe uma integração de contexto, além das integrações menores |
| Nos dois exemplos, Views apresentam elementos de UI e publicam ações de usuário | View é uma fronteira de apresentação/interação, sem autoridade de gameplay |

O nome `Glue Archictecture` é a grafia da pasta original; os novos documentos usam `Glue`. O termo Unit / Identity Design segue a nomenclatura fornecida pelo autor, enquanto o namespace original é `UnitDesignArchitecture`.

## Decisões que este kit acrescenta

Essas regras são propostas para tornar o processo previsível. Não são afirmações de que o projeto original já as cumpre integralmente.

| Decisão proposta | Motivo concreto |
|---|---|
| Em Unit, módulos privados e fachada com comandos/snapshots/eventos | A propriedade pública `Health` do exemplo permite acoplamento ao detalhe interno |
| Em Glue, integrações recebem sufixo `Glue` e ficam na feature que possui a relação | Facilitar localizar integrações sem uma pasta global que cresce com o jogo |
| Composition root e ordem explícita de `Initialize` | Evitar dependência da ordem de callbacks entre objetos |
| Data imutável e configuração copiada para runtime em ambos os perfis | Evitar que buffs/settings de uma instância alterem configuração compartilhada |
| Referências explícitas, sem busca de componentes/objetos em gameplay | Tornar montagem e dependências revisáveis; respeitar a preferência global do autor |
| View recebe snapshot inicial e a integração gerencia bind/unbind | Evitar HUD incompleto e handlers esquecidos |
| Um único dono para estados de pausa e RenderSettings | Evitar políticas globais concorrentes |
| `Hide` separado de `Save` e cancelamento de interações pendentes | Não confundir fechamento de UI com uma decisão de persistência |
| Pastas por feature, nomes em inglês e namespaces do próprio jogo | Localizar comportamento com pouca adivinhação |
| DRIVES opcional, com escopo definido; Flyweight Registry quando persistência exigir | Incorporar os padrões do autor sem substituir a fronteira escolhida |

## Lacunas do exemplo que não viram regras de arquitetura

O projeto contém trechos didáticos e métodos ainda não implementados. Estes pontos foram encontrados na leitura, sem executar o editor:

- **Configuração em gameplay:** `CharacterMovement` mantém `_movementData` e consulta sensibilidade durante movimento; `FirstPerson` mantém `_config` com leitura semelhante. O kit exige copiar esses valores no setup.
- **Velocidade no código:** ambos os movimentos usam `speed = 2f`; um comentário do exemplo Unit já indica movê-la para Data. O contrato torna velocidade configurável e carregada na cópia runtime.
- **Descoberta de dependências:** `SceneController` usa `FindObjectsByType` e os contatos usam `TryGetComponent`. Os perfis adotam montagem/registro explícito conforme a preferência global do autor.
- **Encapsulamento:** `Character` expõe módulos mutáveis em propriedades públicas, apesar de oferecer comandos da identidade. O kit escolhe a fachada como fronteira única para código externo.
- **Inscrições assimétricas:** a glue `DayAndNight`, `SettingsMenuController` e `SettingsMenuView` de Unit assinam em `Awake` e removem em `OnDisable` sem reconectar. O kit define pares por tempo de assinatura.
- **Cleanup incompleto:** `DayAndNightController.OnDestroy` não remove o handler de `OnNoon`; `HealthView` de Glue assina em `Start` sem unsubscribe correspondente. O contrato exige desconectar todos os handlers.
- **Ordem de inicialização:** `SceneController.Awake` pode tentar vincular HUD enquanto a inicialização de `Character` depende de outro `Awake`. O kit elimina essa dependência de ordem entre objetos.
- **HUD inicial:** as barras atualizam em resposta a mudanças de vida, sem uma apresentação inicial explícita no binding. O contrato exige snapshot inicial e política para máximo inválido.
- **Payload de vida:** dano letal publica `-amount`, que pode exceder a vida removida. O contrato define `Delta` como alteração efetiva.
- **Implementação pendente:** `Heal` e `Revive` não estão implementados nos exemplos de saúde; handlers de menu também contêm placeholders. As APIs do kit exigem comportamento definido quando forem implementadas.
- **Operações pendentes:** transições `async void` e `TaskCompletionSource` do exemplo não estabelecem cancelamento, proteção contra conclusão repetida ou encerramento ao destruir o dono. O contrato exige essa definição.
- **Material compartilhado:** os exemplos de skybox recebem um Material e alteram seus valores; a leitura não garante que essa referência seja uma instância runtime. O contrato exige explicitar propriedade e isolamento quando necessário.
- **Direção de integração:** no exemplo Glue, `HealthView` referencia `Health` diretamente e `DamageableCollider` chama o alvo após consulta de componente. O kit torna essas relações explícitas em glues, seguindo uma fronteira mais estrita.

Essas observações delimitam o contrato proposto. Elas não representam uma refatoração executada no projeto de referência.

## Roteiro sugerido para a etapa 2

1. Parta da ideia da etapa anterior e descreva uma feature pequena: dano, morte e barra de vida.
2. Mostre que o prompt da feature sozinho deixa abertas decisões como dono do estado, caminho da chamada e lugar da UI.
3. Apresente a fronteira Unit: os consumidores conhecem `Character`; saúde fica num módulo privado.
4. Apresente a fronteira Glue: `Health` permanece independente; morte/movimento e HUD são relações montadas em glues.
5. Escolha um perfil para o exercício e preencha o contrato de projeto com a turma.
6. Peça à IA apenas o mapa de arquivos, APIs e dependências dessa feature.
7. Faça a turma prever onde entraria uma extensão antes de pedir a implementação.
8. Na etapa 4, implemente e revise usando os critérios do contrato.

Tempo de aula e quantidade de exemplos podem ser ajustados ao curso. Esse roteiro é uma proposta de ensino, não uma regra exigida da IA durante implementação.

## Exercício que mostra a diferença

Solicite a mesma extensão nos dois desenhos: **um inimigo usa a mesma regra de vida, mas não possui HUD; ao morrer, gera um drop**.

No desenho Unit, identifique a fachada do inimigo, o reaproveitamento possível da regra interna de saúde e o coordenador que reage ao evento público de morte. Não obrigue `Enemy` a expor seu módulo de saúde para reutilizar comportamento.

No desenho Glue, reutilize `Health` e componha uma integração de morte/drop específica do inimigo. A regra de vida não recebe conhecimento de drop ou HUD.

Critérios para avaliar a resposta da IA:

- É possível apontar o único dono da vida?
- Dois personagens podem receber dano sem alterar um ao outro ou o Data asset?
- É possível remover o HUD sem reescrever a regra de saúde?
- É possível localizar e substituir a integração de drop?
- Reativação/pool reconecta eventos sem duplicação?
- O novo comportamento respeita a fronteira pública escolhida?

Uma resposta pode funcionar em Play Mode e ainda violar o contrato. Use esse exercício para ensinar a revisão da arquitetura junto da revisão do comportamento.
