[CmdletBinding()]
param(
    [ValidateSet('all', 'unit-identity-design', 'glue')]
    [string] $Profile = 'all',

    [string] $ProjectFile,

    [string] $OutputFile,

    [switch] $Force,

    [switch] $Check
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$kitRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$utf8 = New-Object System.Text.UTF8Encoding($false)
$versionPath = Join-Path $kitRoot 'VERSION'
$version = [IO.File]::ReadAllText($versionPath, $utf8).Trim()

if ($version -notmatch '^\d+\.\d+\.\d+$') {
    throw 'VERSION deve conter uma versao no formato MAJOR.MINOR.PATCH.'
}

if ($Profile -eq 'all' -and ($ProjectFile -or $OutputFile)) {
    throw 'Escolha um perfil unico ao usar -ProjectFile ou -OutputFile.'
}

if ($ProjectFile -and -not $OutputFile) {
    throw 'Use -OutputFile com -ProjectFile para manter os perfis gerais separados do contrato de um jogo.'
}

if ($Check -and ($ProjectFile -or $OutputFile -or $Force)) {
    throw '-Check compara os perfis e recursos gerados da skill com as fontes; nao combine com outros parametros de saida.'
}

function Read-Markdown([string] $Path) {
    return [IO.File]::ReadAllText($Path, $utf8).Replace("`r`n", "`n").Trim()
}

$common = Read-Markdown (Join-Path $kitRoot 'source/common.md')
$introduction = Read-Markdown (Join-Path $kitRoot 'source/introduction.md')
$projectContent = $null
$resolvedProjectPath = $null

if ($ProjectFile) {
    $resolvedProjectPath = (Resolve-Path -LiteralPath $ProjectFile).ProviderPath
    $projectContent = Read-Markdown $resolvedProjectPath
    $architectureMatches = [regex]::Matches($projectContent, '(?m)^Architecture:[ \t]*(\S+)[ \t]*$')
    $versionMatches = [regex]::Matches($projectContent, '(?m)^ArchitectureVersion:[ \t]*(\S+)[ \t]*$')

    if ($architectureMatches.Count -ne 1 -or $architectureMatches[0].Groups[1].Value -ne $Profile) {
        throw "PROJECT.md deve conter exatamente uma linha Architecture: $Profile"
    }
    if ($versionMatches.Count -ne 1 -or $versionMatches[0].Groups[1].Value -ne $version) {
        throw "PROJECT.md deve conter exatamente uma linha ArchitectureVersion: $version"
    }
}

$profileNames = @($Profile)
if ($Profile -eq 'all') {
    $profileNames = @('unit-identity-design', 'glue')
}

$titles = @{
    'unit-identity-design' = 'Unit / Identity Design'
    'glue' = 'Glue'
}

$pendingOutputs = @()

foreach ($profileName in $profileNames) {
    $profilePath = Join-Path $kitRoot "source/$profileName.md"
    $specific = Read-Markdown $profilePath
    $title = $titles[$profileName]

    $header = $introduction.Replace('{{TITLE}}', $title).Replace('{{VERSION}}', $version).Replace('{{PROFILE}}', $profileName)

    $parts = @($header.Trim(), $specific, $common)
    if ($projectContent) {
        $parts += '## Contrato do projeto'
        $parts += 'Os dados abaixo definem o contexto e as escolhas deste projeto. Regras diferentes do perfil devem ser identificadas explicitamente.'
        $parts += $projectContent
    }
    $content = ($parts -join "`n`n").Replace("`r`n", "`n") + "`n"

    $targetPath = Join-Path $kitRoot "profiles/$profileName.md"
    if ($OutputFile) {
        $targetPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputFile)
        $protectedPaths = @(
            (Join-Path $kitRoot 'source/unit-identity-design.md'),
            (Join-Path $kitRoot 'source/glue.md'),
            (Join-Path $kitRoot 'source/common.md'),
            (Join-Path $kitRoot 'source/introduction.md'),
            (Join-Path $kitRoot 'profiles/unit-identity-design.md'),
            (Join-Path $kitRoot 'profiles/glue.md'),
            (Join-Path $kitRoot 'skills/unity-architecture/references/unit-identity-design.md'),
            (Join-Path $kitRoot 'skills/unity-architecture/references/glue.md'),
            (Join-Path $kitRoot 'skills/unity-architecture/SKILL.md'),
            (Join-Path $kitRoot 'skills/unity-architecture/agents/openai.yaml'),
            $versionPath,
            $PSCommandPath
        )
        foreach ($templateName in @('AGENTS.md', 'PROJECT.md', 'FEATURE.md')) {
            $protectedPaths += (Join-Path $kitRoot "templates/$templateName")
            $protectedPaths += (Join-Path $kitRoot "skills/unity-architecture/assets/$templateName")
        }
        if ($resolvedProjectPath) {
            $protectedPaths += $resolvedProjectPath
        }
        foreach ($protectedPath in $protectedPaths) {
            if ([string]::Equals($targetPath, [IO.Path]::GetFullPath($protectedPath), [StringComparison]::OrdinalIgnoreCase)) {
                throw 'A saida nao pode substituir um arquivo de entrada ou o proprio gerador.'
            }
        }
        if ((Test-Path -LiteralPath $targetPath) -and -not $Force) {
            throw "Arquivo de saida ja existe: $targetPath. Use -Force para substituir."
        }
    }

    $pendingOutputs += [pscustomobject]@{ Path = $targetPath; Content = $content }

    # A copia instalada da skill deve ser independente do resto do repositorio.
    if (-not $OutputFile) {
        $referencePath = Join-Path $kitRoot "skills/unity-architecture/references/$profileName.md"
        $pendingOutputs += [pscustomobject]@{ Path = $referencePath; Content = $content }
    }
}

if (-not $OutputFile) {
    foreach ($templateName in @('AGENTS.md', 'PROJECT.md', 'FEATURE.md')) {
        $templatePath = Join-Path $kitRoot "templates/$templateName"
        $templateContent = (Read-Markdown $templatePath) + "`n"
        if ($templateName -eq 'PROJECT.md') {
            $templateVersion = [regex]::Matches($templateContent, '(?m)^ArchitectureVersion:[ \t]*(\S+)[ \t]*$')
            if ($templateVersion.Count -ne 1 -or $templateVersion[0].Groups[1].Value -ne $version) {
                throw "Atualize ArchitectureVersion em templates/PROJECT.md para $version."
            }
        }
        $assetPath = Join-Path $kitRoot "skills/unity-architecture/assets/$templateName"
        $pendingOutputs += [pscustomobject]@{ Path = $assetPath; Content = $templateContent }
    }
}

# Valide todos os resultados antes de gravar ou reportar sucesso.
foreach ($item in $pendingOutputs) {
    if ($Check) {
        if (-not (Test-Path -LiteralPath $item.Path)) {
            throw "Perfil nao gerado: $($item.Path)"
        }
        $existing = [IO.File]::ReadAllText($item.Path, $utf8).Replace("`r`n", "`n")
        if ($existing -cne $item.Content) {
            throw "Perfil desatualizado: $($item.Path). Execute o gerador sem -Check."
        }
    }
}

foreach ($item in $pendingOutputs) {
    if ($Check) {
        Write-Output "OK: $($item.Path)"
        continue
    }
    $parentPath = [IO.Path]::GetDirectoryName($item.Path)
    [IO.Directory]::CreateDirectory($parentPath) | Out-Null
    [IO.File]::WriteAllText($item.Path, $item.Content, $utf8)
    Write-Output "Gerado: $($item.Path)"
}
