# Contrato de desenvolvimento deste projeto

Antes de propor ou alterar código de gameplay, leia:

1. `docs/architecture/PROJECT.md` para contexto, perfil, versão, escopo DRIVES e decisões do jogo.
2. `docs/architecture/ARCHITECTURE.md` para as regras do perfil selecionado.
3. `docs/architecture/DECISIONS.md`, se existir, para mudanças explicitamente adotadas.
4. O contrato da feature em `docs/features/`, se existir.

Use a versão/pacotes reais da Unity. Apresente um resumo de arquivos, responsabilidades,
estado, contratos, dependências e montagem antes de implementar uma feature relevante.
Quando o pedido já autorizar a implementação e as decisões couberem no contrato,
prossiga sem criar uma etapa extra de aprovação.

Mantenha Data imutável em runtime, estado com um único dono e referências explícitas.
Respeite a direção de comunicação de Unit/Identity Design ou Glue escolhida neste jogo.
Se DRIVES estiver selecionado para uma entidade, somente Input pode chamar Execution.

Não altere a fronteira do perfil silenciosamente. Registre a razão e o escopo de uma
mudança arquitetural. Preserve GUIDs/arquivos `.meta` e código gerado/terceiros.

Ao concluir, informe comportamento entregue, setup necessário, verificações executadas
e pendências. Não declare execução de Unity/testes que não ocorreu.
