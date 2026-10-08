# Prompt para implementar uma feature

Entregue ao assistente o perfil escolhido e o `PROJECT.md` do jogo, por arquivo ou
conteúdo. Use esse prompt depois de definir a arquitetura.

```text
Leia ARCHITECTURE.md e PROJECT.md deste jogo, além das instruções e decisões locais.

Implemente a feature: <nome e descrição>.
Resultado observável: <o que deve acontecer>.
Critérios de aceite: <cenários verificáveis>.
Contexto existente: <cenas/prefabs/scripts relevantes>.

Antes de alterar código, apresente um resumo do contrato da feature:
arquivos/caminhos, responsabilidade de cada parte, dono do estado, comandos,
eventos/payloads, dependências, montagem no Inspector, inicialização e cleanup.

A implementação está autorizada dentro do contrato do projeto; prossiga após
esse resumo. Se faltar uma decisão indispensável, pergunte e continue apenas
o trabalho independente dela. Registre mudanças de fronteira explicitamente.

Respeite o perfil escolhido, a versão/pacotes reais da Unity, as regras de Data,
referências e ciclo de vida. Se a entidade usar DRIVES, somente Input pode chamar
Execution. Não crie caminhos paralelos de comando nem acesso aos módulos privados.

Entregue a fatia funcional, o setup de cena/prefab e a verificação apropriada.
No final, informe exatamente o que foi executado, os resultados e as pendências.
```
