# Feature: <nome>

## Resultado observável

<Descreva o comportamento que o jogador/desenvolvedor deve conseguir verificar.>

## Critérios de aceite

- <Cenário, ação e resultado esperado>
- <Caso de borda relevante>

## Contrato de implementação

| Arquivo/caminho | Papel | Estado que possui | Dependências permitidas |
|---|---|---|---|
| <arquivo> | <identidade, módulo, capacidade, glue, input ou View> | <estado ou nenhum> | <referências> |

- Comandos públicos: <assinaturas e significado>
- Leitura pública/snapshots: <campos e invariantes>
- Eventos: <fatos, payloads e quando ocorrem>
- Fluxo de comunicação: <origem -> dono da regra -> consumidores>
- Data e cópia runtime: <o que é carregado e quem possui a cópia>
- Escopo DRIVES: <se houver, caminho Input -> Execution>

## Montagem e ciclo de vida

- Cena/prefab e componentes: <preencher>
- Campos do Inspector e origem de referências: <preencher>
- Inicialização e agendamento: <preencher>
- Bind/unbind, desativação/reativação, pool e cleanup: <preencher>

## Verificação

<Testes ou passos manuais reproduzíveis, incluindo estado inicial e ciclo de vida.>

## Hipóteses e mudanças arquiteturais

<Registre somente decisões ainda abertas ou alterações do contrato existente.>
