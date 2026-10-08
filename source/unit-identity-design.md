## Identidade e intenção deste perfil

**Unit / Identity Design** organiza uma entidade ou funcionalidade em torno de uma identidade pública. A identidade compõe e coordena seus módulos internos. Outros sistemas solicitam intenções à identidade e observam seu estado público/eventos, sem depender da estrutura dos módulos.

Exemplo: outros sistemas conhecem `Character.ReceiveDamage` e `Character.HealthChanged`. Eles não precisam saber se vida é implementada por um `CharacterHealth` comum, uma máquina de estados ou três módulos privados.

Aqui, **Unit** significa uma unidade de responsabilidade/composição; **Identity** significa sua fronteira pública no código. Não significa ECS, classe `UnityEngine.Object`, um ID de save ou simplesmente criar um script para cada GameObject. Identidades podem representar personagens, armas, veículos, menus ou um ciclo de dia/noite.

Este perfil se baseia no projeto de referência `unity-game-dev-essentials-architecture-for-indie-devs`: `Character` compõe `CharacterMovement` e `CharacterHealth`; `DayAndNightController` compõe relógio, skybox e fog; `SceneController` coordena o contexto. As regras de encapsulamento, pastas, nomenclatura e inicialização abaixo são propostas de padronização que completam esse desenho.

## Papéis e fronteiras

| Papel | Exemplo | Pode fazer | Não pode fazer |
|---|---|---|---|
| Identidade/fachada | `Character` | Receber intenções, coordenar módulos privados, expor leitura/eventos | Concentrar toda a implementação ou expor módulos mutáveis |
| Módulo interno | `CharacterMovement`, `CharacterHealth` | Possuir uma regra/estado local e executar operações específicas | Descobrir a cena, conhecer menus ou coordenar outras identidades |
| Data | `CharacterData`, `CharacterHealthData` | Definir configuração inicial, inclusive composição de subconfigurações | Armazenar estado corrente compartilhado entre instâncias |
| View | `CharacterView`, `HealthBarView` | Apresentar snapshots e emitir pedidos de interação | Alterar módulos ou decidir regras de gameplay |
| Input | `PlayerActionReader`, `CharacterInput` | Produzir/adaptar comandos sem implementar mecânicas | Aplicar dano, movimentação ou transições de estado por conta própria |
| Coordenador de contexto | `GameplaySceneController` | Montar identidades, conectar fluxos entre elas, controlar o contexto | Implementar movimento, fórmulas de dano ou renderização de UI |

A identidade de uma entidade física usa o nome do domínio, como `Character`, `Weapon` ou `Vehicle`. Uma unidade de fluxo usa `<Feature>Controller`, como `PauseMenuController` e `DayNightController`. Não crie simultaneamente `Character` e `CharacterController` como duas autoridades da mesma entidade; este último também colide com um tipo conhecido da Unity.

Prefira módulos C# comuns construídos explicitamente, como no projeto de referência. Um módulo pode usar tipos matemáticos e referências Unity injetadas; não precisa ser uma biblioteca completamente independente da Unity. Use `MonoBehaviour` quando o próprio módulo precisar ser um componente configurável ou receber callbacks Unity, e explique essa necessidade.

Uma identidade não precisa ser sempre um `MonoBehaviour`: uma unidade sem presença própria em cena pode ser uma classe comum, cujo dono fornece `Tick`, `Dispose` e dependências.

## Direção de dependências

```text
GameplaySceneController
  -> PlayerActionReader / adaptador de comandos
  -> Character (identidade)
       -> CharacterMovement (privado)
       -> CharacterHealth (privado)
       -> CharacterView (apresentação)
  -> HealthBarView (apresentação do HUD)

HealthBarView emite intenção de UI -> coordenador apropriado
Character publica snapshot/evento -> coordenador -> HealthBarView
```

O diagrama representa dependência de composição; os fatos retornam por eventos. O coordenador pode conhecer a identidade e as Views envolvidas. Os módulos internos não conhecem o coordenador e não acessam outras identidades por conta própria.

Regras obrigatórias:

1. Código externo não acessa `character.Health.ReceiveDamage(...)` nem `character.Movement.BodyMovement(...)`.
2. A identidade mantém os módulos privados e oferece comandos específicos: `ReceiveDamage`, `Heal`, `SetMoveInput`, `Reload`.
3. A identidade oferece propriedades de leitura/snapshots e reemite os eventos necessários. Não exponha o objeto interno mutável sob uma propriedade pública apenas com setter privado.
4. Módulos irmãos não se referenciam diretamente. A identidade coordena as consequências entre eles, como parar movimento depois da morte.
5. Integração entre identidades pertence ao coordenador mais próximo que possui ambas. Se houver muitos fluxos, divida por responsabilidade em coordenadores de escopo menor; não transforme o coordenador de cena em implementação de todas as features.
6. Por padrão, o coordenador vincula a View aos dados/eventos da identidade. Uma View não recebe a identidade inteira se só precisa de um snapshot. Acesso por um contrato estritamente de leitura pode ser uma decisão explícita, nunca um atalho para comandos.

Uma interface como `IDamageReceiver` pode representar a fronteira pública da identidade quando vários tipos de alvo precisam do mesmo contrato. Não crie interfaces para todos os módulos privados.

## Estrutura previsível de uma unidade

```text
Assets/_Game/Features/
  Character/
    Runtime/
      Character.cs
      Modules/
        CharacterMovement.cs
        CharacterHealth.cs
      Data/
        CharacterData.cs
        CharacterMovementData.cs
        CharacterHealthData.cs
      Contracts/
        CharacterHealthSnapshot.cs
      Input/
        CharacterInput.cs             # Se a unidade precisar deste adaptador
      Views/
        CharacterView.cs
    Data/
      CharacterData_Default.asset
      CharacterMovementData_Default.asset
      CharacterHealthData_Default.asset
    Prefabs/
      Player.prefab
    Tests/
      EditMode/
        CharacterHealthTests.cs
  HealthHud/
    Runtime/
      Views/
        HealthBarView.cs
    Prefabs/
      HealthHud.prefab
  SceneFlow/
    Runtime/
      GameplaySceneController.cs
```

Os arquivos da árvore são exemplos de uma feature que usa essas capacidades, não uma lista a ser criada inteira em todo projeto. `Contracts` fica local enquanto só representa essa identidade; um contrato comprovadamente compartilhado pode ir para `Core`.

Namespace base da unidade: `<RootNamespace>.Features.Character`; módulos podem usar `.Modules`, Views `.Views`. Módulos recebem prefixo da identidade (`CharacterHealth`), pois pertencem à sua implementação. Não use `Health` genérico e suponha que ele continuará privado por convenção.

Uma unidade de fluxo segue o mesmo princípio:

```text
DayNight/Runtime/
  DayNightController.cs
  Modules/DayNightClock.cs
  Views/DynamicSkyboxView.cs
  Views/DynamicFogView.cs
  Data/DayNightData.cs
```

## Montagem e inicialização

No prefab de `Character`, a identidade declara Data e referências como corpo, cabeça, Rigidbody e View. A construção dos módulos recebe essas referências e cópias da configuração; módulos não obtêm referências sozinhos.

O coordenador da cena inicializa explicitamente o contexto. Uma opção padrão é fazer a composição em `Start`, depois dos `Awake` locais, e manter o comportamento bloqueado até `Initialize`; uma factory pode inicializar imediatamente após instanciar, seguindo o mesmo contrato. Mesmo assim, não dependa da ordem de `Start` entre objetos: apenas o coordenador ativa o contexto.

```text
GameplaySceneController.InitializeContext
  1. Validar campos serializados
  2. Inicializar Character -> copiar Data -> construir módulos
  3. Conectar os eventos públicos da identidade
  4. Vincular HUD e apresentar Character.HealthSnapshot atual
  5. Inicializar e habilitar o adaptador de input
  6. Liberar a execução da cena
```

O dono do relógio chama `Tick(deltaTime)`; o dono da física chama `FixedTick(fixedDeltaTime)`. Classes comuns não recebem `Awake`/`Update` automaticamente. Nomeie seus métodos como `Initialize`, `Tick`, `FixedTick` e `Dispose`, em vez de imitar callbacks Unity sem deixar claro quem os chama.

Escolha um único agendador: a identidade pode atualizar seus módulos pelo próprio ciclo Unity, ou o coordenador atualiza a identidade. Não use as duas formas ao mesmo tempo. Se DRIVES estiver selecionado, esse agendamento e os comandos passam pelo adaptador Input antes de Execution.

Ao desligar/destruir o contexto, primeiro pare novos comandos, depois desfaça bindings e operações pendentes, e finalmente descarte módulos/recursos que o contexto possui. Módulos que publicam eventos precisam ser desconectados também pela identidade.

## Contratos e estado: exemplo de dano, morte e HUD

Resultado esperado: uma fonte de dano reduz a vida de um personagem; morte ocorre uma única vez; movimento deixa de aceitar comandos; a barra apresenta o valor inicial e cada mudança.

| Arquivo | Estado/responsabilidade | API relevante |
|---|---|---|
| `CharacterHealthData.cs` | Configuração inicial imutável | `InitialHealth`, `MaxHealth` |
| `CharacterHealth.cs` | Dono de `CurrentHealth` e regra de vida/morte | `ReceiveDamage`, `Heal`, `Revive`, snapshot/eventos internos |
| `Character.cs` | Fronteira pública, coordenação de saúde e movimento | `ReceiveDamage`, `Heal`, `HealthSnapshot`, `HealthChanged`, `Died` |
| `DamageZone.cs` | Detectar contato e publicar alvo/valor | `ContactDetected` com alvo já resolvido explicitamente |
| `GameplaySceneController.cs` | Ligar fonte de dano à identidade e identidade ao HUD | Handlers locais e setup/cleanup |
| `HealthBarView.cs` | Apresentar dados recebidos | `Present(current, max)` |

Fluxo sem DRIVES:

```text
DamageZone.ContactDetected(target, amount)
  -> GameplaySceneController solicita target.ReceiveDamage(amount)
  -> Character delega ao CharacterHealth privado
  -> CharacterHealth atualiza seu estado e publica a alteração efetiva
  -> Character coordena seus módulos e reemite HealthChanged/Died
  -> GameplaySceneController envia o snapshot ao HealthBarView
```

Com DRIVES selecionado, substitua a delegação de comportamento por `Character -> CharacterInput -> CharacterExecution`; Execution coordena os módulos de saúde/movimento e dirige a View interna. O sistema externo continua conhecendo apenas a fachada.

Contrato mínimo de vida:

- `CurrentHealth` permanece entre zero e `MaxHealth`; `MaxHealth` deve ser positivo e finito.
- Dano/cura inválidos não alteram estado; a política de erro deve ser explícita.
- Dano de 20 sobre vida de 5 gera `Delta = -5`, não `-20`.
- `Died` ocorre na transição vivo -> morto, sem repetição a cada colisão.
- `Heal` não revive implicitamente; `Revive` explicita a transição e a quantidade inicial.
- O coordenador apresenta o snapshot inicial depois de conectar o HUD.

Evite este acoplamento externo:

```csharp
// Externo passa a conhecer detalhes internos da entidade.
character.Health.ReceiveDamage(amount);
```

Use a intenção pública:

```csharp
character.ReceiveDamage(amount);
```

Essas linhas ilustram uma chamada; não são uma implementação completa. O contrato define o comportamento que o código concreto deve cumprir.

## Como encaixar uma feature nova

1. Identifique a identidade responsável. Uma nova regra de vida normalmente amplia `CharacterHealth`; uma entidade nova pode criar outra unidade.
2. Decida qual módulo possui o estado e como a identidade coordena consequências.
3. Acrescente comandos/eventos à fachada só quando um consumidor real precisar deles.
4. Ajuste Data e a cópia runtime se houver configuração nova.
5. Conecte consumidores externos no coordenador apropriado.
6. Registre setup de prefab/cena e verifique os critérios de aceite.

Exemplo: stamina para correr pertence à unidade `Character`. `CharacterStamina` possui stamina; `Character` coordena stamina e movimento. Um HUD externo lê o snapshot público. Ele não recebe `CharacterStamina` nem desconta energia.

Se uma identidade crescer demais, separe os módulos pela regra que executam e os coordenadores pelo fluxo que integram. Não remova a fronteira pública só para reduzir o tamanho do arquivo; mantenha o vocabulário da identidade estável sempre que possível.

## Antipadrões e revisão do perfil

| Problema | Correção |
|---|---|
| `Character` implementa física, dano, HUD e save no mesmo arquivo | Delegar regras a módulos e integrações a coordenadores |
| Toda feature acessa `.Health`/`.Movement` publicamente | Publicar intenção, leitura e evento na identidade |
| Módulo de vida referencia módulo de movimento diretamente | Identidade coordena a consequência |
| `SceneController` calcula velocidade ou dano | Levar regra à unidade correspondente |
| View chama método do módulo ou escreve estado | View emite pedido ou apresenta dados |
| Uma classe comum usa métodos `OnUpdate` sem dono definido | Definir `Tick` e o agendador explícito |
| Uma unidade vira seis arquivos vazios para cumprir DRIVES | Aplicar DRIVES somente no escopo escolhido e com responsabilidades reais |

Critérios adicionais deste perfil:

- [ ] Entidades/fluxos têm uma fronteira pública identificável.
- [ ] Módulos são detalhes privados e seus estados têm donos claros.
- [ ] Integrações externas usam a fachada/contrato, sem alcançar módulos.
- [ ] Coordenação interna pertence à identidade; coordenação externa tem escopo definido.
- [ ] Uma alteração interna pode ocorrer sem exigir mudanças em todos os consumidores.
- [ ] O plano de arquivos permite localizar rapidamente a implementação de uma intenção.
