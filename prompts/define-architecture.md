# Prompt para a etapa 2: definir a arquitetura

Anexe um perfil completo de `profiles/`. Substitua os campos entre `<...>`.

```text
Estou na etapa 2 do meu processo de desenvolvimento de jogos com IA:
Ideia -> Definição da Arquitetura do Código -> Assets -> Implementação -> Polir.

Leia integralmente o contrato de arquitetura anexado.
Perfil escolhido: <unit-identity-design ou glue>, versão <versão>.
Ideia do jogo: <descrição do loop, jogador, câmera e plataforma>.
Escopo da primeira versão: <features essenciais e limites>.
Projeto: <novo ou existente; acesso aos arquivos ou contexto fornecido>.

Se tiver acesso ao projeto, leia versão Unity, manifest e instruções existentes.
Não presuma pacotes, APIs ou referências de cena disponíveis.

Entregue uma definição concreta contendo:
1. Um PROJECT.md preenchido com decisões e hipóteses explícitas.
2. Árvore apenas das pastas/arquivos necessários à primeira versão.
3. Mapa de identidades/módulos ou capacidades/glues, conforme o perfil escolhido.
4. Dono de cada estado mutável, Data e sua cópia runtime.
5. Comandos públicos, eventos/payloads e direção de comunicação.
6. Montagem prevista de prefabs/cena, inicialização, execução e cleanup.
7. Ordem de implementação por fatias jogáveis e critérios de aceite.
8. Sugestão de DRIVES para entidades não triviais, com escopo e consequência,
   se ele ainda não tiver sido escolhido.
9. Necessidade de Flyweight Registry somente se houver escolhas de assets
   que precisem sobreviver a save/load.

Ainda não implemente gameplay: o resultado desta etapa é o contrato de arquitetura.
Se uma informação faltar, avance com hipóteses onde isso for reversível e faça
perguntas apenas para decisões que realmente dependam de mim.
Evite abstrações e pastas sem consumidor concreto.
```
