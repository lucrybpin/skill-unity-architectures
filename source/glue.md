## Componentes e intenção deste perfil

**Glue** organiza capacidades como componentes independentes, cada um responsável por seu próprio comportamento e estado. Classes de integração, chamadas **glues**, recebem referências explícitas e conectam comandos, eventos, input e apresentação.

Exemplo: `Health` calcula vida; `FirstPersonMovement` move um corpo; `HealthBarView` desenha uma barra. `HealthHudGlue` conecta eventos de vida à apresentação, e `CharacterLifeGlue` conecta morte à interrupção do movimento. `Health` não precisa conhecer essas integrações.

Glue não é conectar tudo com eventos, colocar toda lógica em um objeto central ou usar singletons para acessar componentes. Uma glue expressa uma relação específica entre capacidades que podem existir separadamente.

Este perfil se baseia no projeto de referência `unity-game-dev-essentials-architecture-for-indie-devs`: `FirstPersonSystem` conecta `ActionReader` e `FirstPerson`; `DayAndNight` conecta relógio, skybox e fog; `SceneManager` coordena pausa e contexto. O sufixo `Glue`, a separação do estado e as regras de ciclo de vida abaixo são propostas de padronização, não nomes já usados no exemplo.

## Papéis e fronteiras

| Papel | Exemplo | Pode fazer | Não pode fazer |
|---|---|---|---|
| Capacidade/componente | `Health`, `FirstPersonMovement`, `DayNightClock` | Executar uma regra e possuir seu estado/configuração runtime | Procurar ou conhecer capacidades irmãs, HUD ou glues |
| Data | `HealthData`, `FirstPersonMovementData` | Definir configuração compartilhada inicial | Possuir a vida/velocidade corrente de todas as instâncias |
| Input | `PlayerActionReader` | Ler ações e publicar comandos/valores | Implementar movimento, dano ou pausa |
| View | `HealthBarView`, `PauseMenuView` | Apresentar estado e publicar pedidos de UI | Coordenar gameplay ou persistência |
| Glue | `PlayerMovementGlue`, `HealthHudGlue` | Conectar capacidades com referências explícitas | Reimplementar a regra que pertence a um componente |
| Composition root | `GameplayCompositionRoot` | Inicializar participantes e ativar o contexto | Ser o dono automático de todos os estados da cena |

Prefira componentes `MonoBehaviour` para capacidades montadas no Inspector, como no projeto de referência. Uma capacidade pode delegar um cálculo/estado a uma classe C# comum quando isso trouxer uma separação concreta; ela continua sendo a fronteira pública da capacidade.

Não crie uma fachada `Character` obrigatória que esconda todos os componentes: isso muda a fronteira para Unit. O prefab `Player` pode reunir várias capacidades independentes sem que uma única classe passe a ser a entrada de todas elas.

## Direção de dependências

```text
GameplayCompositionRoot -> inicialização explícita de componentes e glues

PlayerMovementGlue
  -> PlayerActionReader
  -> FirstPersonMovement

HealthHudGlue
  -> Health
  -> HealthBarView

CharacterLifeGlue
  -> Health
  -> FirstPersonMovement

DayNightGlue
  -> DayNightClock
  -> DynamicSkyboxView
  -> DynamicFogView
```

Os componentes publicam fatos e recebem comandos. A glue referencia os componentes; os componentes não referenciam a glue. O payload de um evento pode usar contratos/valores compartilhados.

Regras obrigatórias:

1. Uma capacidade não referencia outra capacidade concreta para coordenar gameplay. `Health` não chama `PauseMenuView`, `FirstPersonMovement` ou um sistema de loot.
2. A integração entre duas capacidades pertence a uma glue com nome e escopo explícitos.
3. Cada estado mutável tem um único dono. `HealthHudGlue` não mantém uma segunda vida autoritativa; `Health` continua sendo a fonte.
4. Uma glue pode possuir o estado de uma relação/fluxo que não pertence a nenhum componente, como a política de pausa em `PauseGlue`. Isso não autoriza copiar estados autoritativos dos participantes.
5. Uma glue não depende diretamente de outra glue para formar uma cadeia de atalhos. Comunicação necessária entre fluxos passa por um contrato/componente explícito do domínio; o composition root injeta as referências. Se a integração for uma única responsabilidade, considere uma glue de escopo adequado.
6. Views não se vinculam diretamente a componentes de gameplay por padrão; a glue conecta e envia o snapshot inicial.
7. Glues não precisam usar eventos para tudo. Input contínuo pode ser amostrado e enviado por chamada direta; fatos como morte são eventos.

Dependências técnicas injetadas, como um Rigidbody, um Renderer ou uma View específica de uma capacidade, não são integrações de gameplay entre capacidades. Elas são permitidas. Uma interface que oculte outra capacidade concreta não transforma uma dependência proibida em permitida: avalie a responsabilidade real.

## Estrutura previsível de capacidades e integrações

```text
Assets/_Game/Features/
  Health/
    Runtime/
      Health.cs
      Data/
        HealthData.cs
      Contracts/
        HealthSnapshot.cs
    Data/
      HealthData_Player.asset
    Tests/
      EditMode/
        HealthRulesTests.cs
  FirstPersonMovement/
    Runtime/
      FirstPersonMovement.cs
      Data/
        FirstPersonMovementData.cs
    Data/
      FirstPersonMovementData_Default.asset
  PlayerInput/
    Runtime/
      PlayerActionReader.cs
  HealthHud/
    Runtime/
      Views/
        HealthBarView.cs
    Prefabs/
      HealthHud.prefab
  Player/
    Runtime/
      Glue/
        PlayerMovementGlue.cs
        CharacterLifeGlue.cs
        HealthHudGlue.cs
    Prefabs/
      Player.prefab
  SceneFlow/
    Runtime/
      GameplayCompositionRoot.cs
      Glue/
        PauseGlue.cs
```

Uma glue fica na feature que possui a integração, não dentro da capacidade genérica que está sendo reutilizada. Neste exemplo, o HUD é vinculado a um jogador, então `HealthHudGlue` pertence à composição `Player`. Se a integração servir a outro contexto independente, coloque-a na feature desse contexto.

Capacidades reutilizáveis não recebem prefixo de entidade por hábito: use `Health`, não `PlayerHealth`, se a mesma capacidade atende jogador e inimigo. Glues recebem nome da relação, como `PlayerMovementGlue`, `HealthHudGlue` e `DayNightGlue`. Evite `EverythingGlue`, `GameGlue` e uma pasta global com todas as integrações.

Namespace de uma capacidade: `<RootNamespace>.Features.Health`. Namespace de integração: `<RootNamespace>.Features.Player.Glue`. Data assets e prefabs específicos ficam junto de seu dono. Só coloque um contrato em `Core` quando houver necessidade concreta de compartilhá-lo.

## Montagem e inicialização

Monte o prefab com os componentes necessários e preencha as referências de cada glue pelo Inspector. As glues recebem exatamente os participantes da relação que implementam. Não resolvem referências por busca de componentes.

O composition root declara os participantes e inicializa o contexto numa ordem explícita. Uma opção padrão é compor em `Start`, depois dos `Awake` locais, e impedir execução até `Initialize`. Prefabs dinâmicos podem ser inicializados por uma factory logo após a criação.

```text
GameplayCompositionRoot.InitializeContext
  1. Validar capacidades, Views, Data e referências das glues
  2. Inicializar capacidades e suas cópias de configuração
  3. Inicializar glues, conectar fatos/comandos
  4. Apresentar snapshots iniciais nas Views
  5. Habilitar input e execução
```

As glues conectam somente depois que os participantes estão prontos. `OnEnable` anterior a `Initialize` não pode consumir estado não inicializado. Ao reativar, reconecte uma única vez e atualize a View com o estado atual.

Cada comportamento tem um único agendador. Por padrão, a capacidade executa sua própria física em `FixedUpdate` e a glue apenas entrega intenção; uma glue pode executar `FixedTick` de uma capacidade passiva se esse contrato estiver registrado. Não movimente o mesmo Rigidbody no componente e na glue simultaneamente.

Se uma glue ler input em `Update` e a capacidade consumir em `FixedUpdate`, documente como o comando é armazenado e como uma ação pontual é consumida uma única vez. Para câmera, registre a semântica de mouse delta/eixo e o loop que aplica a rotação.

## Contratos e estado: exemplo de dano, morte e HUD

Resultado esperado: uma fonte de dano reduz vida; a morte interrompe movimento; a barra apresenta o valor inicial e cada mudança. O componente de vida deve funcionar mesmo sem HUD e sem movimento.

| Arquivo | Estado/responsabilidade | API relevante |
|---|---|---|
| `HealthData.cs` | Configuração inicial imutável | `InitialHealth`, `MaxHealth` |
| `Health.cs` | Dono de vida e transições vivo/morto | `ReceiveDamage`, `Heal`, `Revive`, `Snapshot`, `HealthChanged`, `Died` |
| `DamageZone.cs` | Publicar contato/alvo conhecido | `ContactDetected` |
| `DamageGlue.cs` | Conectar fonte de dano a receptor explícito | Encaminhar `ReceiveDamage` |
| `CharacterLifeGlue.cs` | Política que relaciona morte a movimento | Escutar `Died`, solicitar `SetMovementEnabled(false)` |
| `HealthHudGlue.cs` | Relacionar vida e barra | Snapshot inicial, handlers, bind/unbind |
| `HealthBarView.cs` | Apresentação | `Present(current, max)` |

Fluxo sem DRIVES:

```text
DamageZone.ContactDetected(target, amount)
  -> DamageGlue solicita Health.ReceiveDamage(amount)
  -> Health aplica regra e publica HealthChanged/Died
     -> HealthHudGlue envia snapshot para HealthBarView
     -> CharacterLifeGlue solicita FirstPersonMovement.SetMovementEnabled(false)
```

`Health` não sabe quais consumidores recebem seus eventos. Se HUD não existir, a regra de vida continua igual. Se não houver política de parar movimento, basta não montar essa integração.

Com DRIVES selecionado para a entidade, a glue que recebe dano solicita o comando pelo adaptador Input declarado; somente esse adaptador chama Execution. Uma glue como `PlayerMovementGlue` pode ser a camada Input, mas esse papel deve estar no contrato. Glues de apresentação apenas observam os snapshots/eventos permitidos. Não misture caminhos de execução diretos com caminhos via Input na mesma entidade.

Contrato mínimo de vida:

- A vida corrente é limitada entre zero e máximo positivo/finito.
- O payload representa a alteração efetiva após clamp.
- Morte é emitida uma vez por transição vivo -> morto.
- Cura não revive implicitamente; reviver é comando separado.
- O componente não depende de UI, loot, pause ou outros consumidores.
- Reativar/revincular o HUD restaura apresentação sem duplicar handlers.

Evite integração escondida na capacidade:

```csharp
// Dentro de Health: mistura regra de vida com outra capacidade.
_movement.SetMovementEnabled(false);
_healthBar.Present(CurrentHealth, MaxHealth);
```

Expresse as relações nas glues:

```csharp
// CharacterLifeGlue: reage ao fato publicado por Health.
private void HandleDied()
{
    _movement.SetMovementEnabled(false);
}
```

O trecho mostra a responsabilidade de um handler; não é uma classe completa. Os campos e o ciclo de vida das inscrições devem ser implementados explicitamente.

## Exemplos de integração com escopo claro

**Primeira pessoa:** `PlayerMovementGlue` conecta `PlayerActionReader` a `FirstPersonMovement`. Sensibilidade, velocidade e limites pertencem à cópia runtime da capacidade, não à glue. Referências de corpo/cabeça/Rigidbody são declaradas antecipadamente.

**Dia/noite:** `DayNightClock` mantém tempo e publica `SunriseReached`, `NoonReached` e `SunsetReached`. `DayNightGlue` traduz esses fatos em pedidos para `DynamicSkyboxView` e `DynamicFogView`. Cores e duração configuráveis podem pertencer a `DayNightPresentationData`, copiadas para a integração no setup, pois descrevem a relação entre relógio e apresentação.

**Pausa:** `PauseGlue` é a autoridade do fluxo de pausa e conecta pedido de input, bloqueio de gameplay e View do menu. Mantém apenas o estado da pausa e os valores anteriores que precisa restaurar. `PauseMenuView` publica pedidos; não altera tempo global nem carrega cenas.

Configuração específica de uma relação pertence à glue/feature de integração. Configuração de uma capacidade pertence à própria capacidade. Não coloque velocidade de movimento na glue só porque ela é o chamador do movimento.

## Como encaixar uma feature nova

1. Determine se o comportamento já cabe em uma capacidade existente.
2. Para uma regra/estado novo independente, crie ou estenda a capacidade responsável.
3. Para uma nova relação entre capacidades existentes, crie ou estenda uma glue específica.
4. Mantenha configuração e estado com seu dono; defina comandos/eventos.
5. Monte a composição no prefab/cena e registre setup/cleanup.
6. Verifique a capacidade isolada e a integração concreta necessária.

Exemplo: stamina pode ser uma capacidade `Stamina`. A regra de gasto/recuperação pertence a ela. `SprintGlue` conecta pedido de correr, disponibilidade de stamina e comando de movimento. `StaminaHudGlue` apresenta seu snapshot. Nenhuma dessas relações exige que `Stamina` conheça o jogador, movimento ou HUD.

Quando uma glue crescer, divida relações diferentes, como controle, apresentação e consequência de morte. Não divida uma única política de fluxo entre várias glues que passam a chamar umas às outras e compartilhar estado duplicado.

## Antipadrões e revisão do perfil

| Problema | Correção |
|---|---|
| `Health` desativa movimento e atualiza HUD | Extrair `CharacterLifeGlue` e `HealthHudGlue` |
| Glue calcula dano, velocidade ou clamp de vida | Mover regra para a capacidade dona |
| `GameGlue` referencia todas as features | Dividir por relação e escopo de composição |
| Componentes consultam singleton/event bus para encontrar pares | Injetar referências nas glues apropriadas |
| View referencia diretamente o componente de gameplay | Glue envia estado e coordena pedidos |
| Duas glues mantêm `CurrentHealth`/`IsDead` autoritativos | Consumir snapshot do único dono |
| Toda relação vira evento global | Usar chamadas diretas para intenções e eventos locais para fatos |
| Uma glue chama outra para chegar a um terceiro componente | Declarar um contrato de fluxo e a composição necessária |

Critérios adicionais deste perfil:

- [ ] Cada capacidade pode existir sem conhecer as integrações que a utilizam.
- [ ] Cada relação de gameplay está numa glue com nome e participantes explícitos.
- [ ] A glue coordena a relação e o componente executa a regra.
- [ ] Não há comunicação direta entre capacidades para implementar integração.
- [ ] Cada estado tem um dono, inclusive estados de fluxo pertencentes às glues.
- [ ] Remover uma integração opcional não exige reescrever a capacidade.
