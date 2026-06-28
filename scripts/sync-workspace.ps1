# sync-workspace.ps1
# Synchronizes auto-generated regions across workspace documents.
#
# What it updates:
#   1. README.md        — AI file index table (between <!-- SYNC --> markers)
#   2. INSTRUCTIONS.md  — Topic Registry: marks ✓ for every ai/sections/ file that exists
#
# Usage:     .\scripts\sync-workspace.ps1
# Run after: adding a new ai/sections/ context map or ai/logs/ session file
# Safe:      only touches clearly-marked auto-generated regions; all other content is untouched

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$root         = Split-Path $PSScriptRoot -Parent
$readmePath   = Join-Path $root 'README.md'
$instructPath = Join-Path (Join-Path $root 'ai') 'INSTRUCTIONS.md'
$sectionsDir  = Join-Path (Join-Path $root 'ai') 'sections'
$logsDir      = Join-Path (Join-Path $root 'ai') 'logs'
$utf8NoBom    = [System.Text.UTF8Encoding]::new($false)
$bt           = '`'   # backtick — used to build Markdown inline-code spans

Write-Host "sync-workspace.ps1"
Write-Host "==================`n"

# ── Helper: "04_clay_ast.md" -> "S04 Clay Ast" ───────────────────────────────
function Get-SectionLabel([string]$filename) {
    if ($filename -match '^(\d{2})_(.+)\.md$') {
        $num   = $Matches[1]
        $words = $Matches[2] -replace '_', ' '
        $label = (Get-Culture).TextInfo.ToTitleCase($words)
        return 'S' + $num + ' ' + $label
    }
    return $filename
}

# ── Collect dynamic files ─────────────────────────────────────────────────────
$sectionFiles = @(
    Get-ChildItem $sectionsDir -Filter '*.md' |
    Where-Object { $_.Name -notmatch '^_' -and $_.Name -match '^\d{2}_' } |
    Sort-Object Name
)

$logFiles = @(
    Get-ChildItem $logsDir -Filter '*.md' |
    Where-Object { $_.Name -notmatch '^_' } |
    Sort-Object Name
)

Write-Host "  $($sectionFiles.Count) section context map(s): $($sectionFiles.Name -join ', ')"
Write-Host "  $($logFiles.Count)    session log(s):          $($logFiles.Name -join ', ')"
Write-Host ""

# ── 1. README.md — refresh file index between SYNC markers ───────────────────
$startMarker = '<!-- SYNC:ai-file-index:start -->'
$endMarker   = '<!-- SYNC:ai-file-index:end -->'

$readmeText = [System.IO.File]::ReadAllText($readmePath, [System.Text.Encoding]::UTF8)

if ($readmeText -notlike "*$startMarker*") {
    Write-Warning "README.md: SYNC markers not found. Add <!-- SYNC:ai-file-index:start --> and <!-- SYNC:ai-file-index:end --> to README.md first."
}
else {
    # Build the replacement table
    $rows = [System.Collections.Generic.List[string]]::new()
    $rows.Add('| File | Description |')
    $rows.Add('|---|---|')

    foreach ($f in $sectionFiles) {
        $label = Get-SectionLabel $f.Name
        $rows.Add('| ' + $bt + 'ai/sections/' + $f.Name + $bt + ' | Tier 2 context map - ' + $label + ' |')
    }
    foreach ($f in $logFiles) {
        $rows.Add('| ' + $bt + 'ai/logs/' + $f.Name + $bt + ' | Session log |')
    }

    $nl       = [System.Environment]::NewLine
    $newBlock = $startMarker + $nl + ($rows -join $nl) + $nl + $endMarker

    $pattern  = '(?s)' + [regex]::Escape($startMarker) + '.*?' + [regex]::Escape($endMarker)
    $newText  = [regex]::Replace($readmeText, $pattern, $newBlock)

    if ($newText -ne $readmeText) {
        [System.IO.File]::WriteAllText($readmePath, $newText, $utf8NoBom)
        Write-Host ('README.md          [OK] file index updated (' + $sectionFiles.Count + ' sections, ' + $logFiles.Count + ' logs)')
    }
    else {
        Write-Host 'README.md            already up to date'
    }
}

# ── 2. INSTRUCTIONS.md — sync Topic Registry ✓ markers ───────────────────────
$lines    = [System.Collections.Generic.List[string]](
                [System.IO.File]::ReadAllLines($instructPath, [System.Text.Encoding]::UTF8)
            )
$modified = $false

foreach ($sectionFile in $sectionFiles) {
    if ($sectionFile.Name -notmatch '^(\d{2})_') { continue }
    $nn = $Matches[1]   # e.g. "04"

    for ($i = 0; $i -lt $lines.Count; $i++) {
        # Match a Topic Registry row that:
        #   (a) still says *(not yet)* in the Tier 2 column
        #   (b) has a Tier 3 column starting with `NN_
        if ($lines[$i] -match '\*\(not yet\)\*' -and
            $lines[$i] -match ([regex]::Escape($bt + $nn + '_'))) {

            $lines[$i] = $lines[$i] -replace [regex]::Escape('*(not yet)*'),
                                              ($bt + $sectionFile.Name + $bt + ' ✓')
            $modified = $true
            Write-Host ('INSTRUCTIONS.md    [OK] marked: ' + $sectionFile.Name)
            break
        }
    }
}

if ($modified) {
    [System.IO.File]::WriteAllLines($instructPath, $lines, $utf8NoBom)
}
else {
    Write-Host 'INSTRUCTIONS.md      Topic Registry already up to date'
}

Write-Host ''
Write-Host 'Done.'
Write-Host 'Commit with: git add -A ; git commit -m "sync-workspace" ; git push'
