# Contrato do projeto

Preencha os campos antes de usar este arquivo para orientar implementação. Campos sem
informação podem ser preenchidos pela IA como hipóteses explícitas, desde que não sejam
necessários para uma decisão que depende do desenvolvedor.

## Identificação da arquitetura

Architecture: <unit-identity-design ou glue>
ArchitectureVersion: 1.0.0
RootNamespace: <nome em PascalCase, como MyGame>
DrivesScope: <nenhum inicialmente, ou entidades específicas>
ArchitectureSource: <cópia local; opcionalmente URL por commit>

Escolha somente um valor para `Architecture`. Para gerar um arquivo combinado, o
gerador valida essas linhas de arquitetura e versão. DRIVES é uma decisão de escopo,
não um terceiro perfil que substitui Unit ou Glue.

## Ideia e limites

- Nome e descrição do jogo: <preencher>
- Loop principal: <ação -> consequência -> repetição>
- Jogador e câmera: <2D/3D, perspectiva, controles>
- Plataformas de destino: <preencher>
- Objetivo desta versão: <resultado jogável>
- Fora do escopo desta versão: <limites concretos>

## Ambiente real

- Unity: <ler ProjectSettings/ProjectVersion.txt>
- Input: <pacote/sistema realmente utilizado>
- Render pipeline: <real>
- UI: <real>
- Pacotes já instalados relevantes: <ler Packages/manifest.json>
- Dependências extras autorizadas/necessárias: <preencher se houver>
- Projeto novo ou existente: <preencher>
- Convenções existentes que precisam ser preservadas: <preencher>

## Mapa de responsabilidades

| Feature/entidade | Fronteira pública | Dono do estado | Coordenação | Pasta |
|---|---|---|---|---|
| <feature> | <identidade ou capacidade> | <classe> | <controller ou glue> | <caminho> |

Defina quem compõe a cena/prefab, quem inicializa e quem agenda cada comportamento.
Se houver DRIVES, identifique Input, Execution e o caminho de comandos externos.

## Decisões de runtime

- Composition root/coordenador da cena: <tipo e objeto>
- Ordem de inicialização e sinal de prontidão: <preencher>
- Dono de pausa, cursor e action maps: <preencher>
- Dono de estados globais, como RenderSettings: <preencher se aplicável>
- Estado que precisa sobreviver a save/load: <preencher>
- Flyweights/registries necessários: <somente escolhas persistentes de assets>
- Estratégia de spawn/pool e referências dinâmicas: <se aplicável>
- Semântica de input/câmera e tempo escalado/não escalado: <preencher>

## Primeira fatia implementável

- Feature: <nome>
- Resultado observável: <preencher>
- Critérios de aceite: <preencher>
- Montagem no Inspector/prefab/cena: <preencher>
- Validação disponível: <editor, testes, inspeção ou passos manuais>

## Decisões e hipóteses pendentes

| Tema | Hipótese/decisão | Evidência ou motivo | Precisa de resposta antes de quê? |
|---|---|---|---|
| <tema> | <preencher> | <preencher> | <preencher> |

## Registro de mudanças

Use esta seção enquanto o registro for pequeno; extraia para `DECISIONS.md` quando
houver necessidade. Não registre escolhas triviais que o contrato já resolve.

```text
Data: YYYY-MM-DD
Decisão: <o que mudou>
Motivo: <problema concreto>
Escopo: <features/entidades afetadas>
Consequência: <montagem, API, migração ou custo relevante>
Versão do contrato: <versão adotada>
```
