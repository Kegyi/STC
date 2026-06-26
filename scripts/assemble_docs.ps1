# assemble_docs.ps1
# Assembles the Reference Manual sections/ back into a single readable Markdown file.
# Dynamically generates the document header and Table of Contents from section files.
# The 00_header_and_toc.md file is NOT needed â€” this script replaces it.
#
# Usage:
#   .\assemble_docs.ps1                         -> writes to STC root with today's date
#   .\assemble_docs.ps1 -OutputFile "out.md"    -> writes to a specific path

param(
    [string]$OutputFile = "c:\Users\Kegyi\STC\docs\STC_Reference_Manual_assembled_$(Get-Date -Format 'yyyyMMdd').md"
)

$sectionsDir = "c:\Users\Kegyi\STC\docs\STC Co-Pilot & Systems Architect Reference Manual\sections"
$docTitle    = "STC Systems Architect & Architectural Core Reference Manual"
$docVersion  = "2026.1.0"
$docClass    = "Core System Architecture & Compiler Specification"

if (-not (Test-Path $sectionsDir)) {
    Write-Error "sections/ folder not found. Run split_reference_manual.ps1 first."
    exit 1
}

# Collect numbered section files only (skip 00_* and non-numbered files)
$sectionFiles = Get-ChildItem $sectionsDir -Filter "*.md" |
    Where-Object { $_.Name -match '^\d{2}_' -and $_.Name -notmatch '^00_' } |
    Sort-Object Name

if ($sectionFiles.Count -eq 0) {
    Write-Error "No numbered section files found in $sectionsDir"
    exit 1
}

# Helper: convert a heading string to a GitHub-style markdown anchor
function ConvertTo-Anchor([string]$heading) {
    $anchor = $heading.ToLower()
    $anchor = $anchor -replace '[^\w\s-]', ''   # remove special chars
    $anchor = $anchor -replace '\s+', '-'        # spaces -> hyphens
    $anchor = $anchor -replace '-+', '-'         # collapse multiple hyphens
    return $anchor.Trim('-')
}

# --- Build Table of Contents from section headings ---
$tocLines = [System.Collections.Generic.List[string]]::new()
foreach ($file in $sectionFiles) {
    $firstHeading = Get-Content $file.FullName -Encoding UTF8 |
        Where-Object { $_ -match '^## \d+\.' } |
        Select-Object -First 1
    if ($firstHeading) {
        $title  = $firstHeading -replace '^## ', ''
        $anchor = ConvertTo-Anchor $title
        $tocLines.Add("- [$title](#$anchor)")
    }
}

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
$sb        = [System.Text.StringBuilder]::new()

# --- Write generated header ---
$null = $sb.AppendLine("# $docTitle")
$null = $sb.AppendLine("**Version:** $docVersion  ")
$null = $sb.AppendLine("**Classification:** $docClass")
$null = $sb.AppendLine()
$null = $sb.AppendLine("---")
$null = $sb.AppendLine("## Table of Contents")
$null = $sb.AppendLine()
foreach ($line in $tocLines) { $null = $sb.AppendLine($line) }
$null = $sb.AppendLine()
$null = $sb.AppendLine("---")
$null = $sb.AppendLine()

# --- Append each section ---
foreach ($file in $sectionFiles) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    # Strip the breadcrumb comment added by the split script
    $content = $content -replace '(?m)^<!-- Part of:.+-->\r?\n\r?\n', ''
    # Rewrite cross-file anchor links back to same-page anchors for the assembled doc
    # e.g. ](19_legend.md#acronym-RCU) → ](#acronym-RCU)
    # e.g. ](06_dynamic_reconfiguration_live_morphing_operations.md#6-dynamic-...) → ](#6-dynamic-...)
    $content = $content -replace '\]\([\w\-\.]+\.md#([^)]+)\)', '](#$1)'
    $null = $sb.AppendLine($content.TrimEnd())
    $null = $sb.AppendLine()
    $null = $sb.AppendLine("---")
    $null = $sb.AppendLine()
    Write-Host "  + $($file.Name)"
}

[System.IO.File]::WriteAllText($OutputFile, $sb.ToString(), $utf8NoBom)

Write-Host ""
Write-Host "Assembled $($sectionFiles.Count) sections -> $OutputFile"
Write-Host "Size: $([Math]::Round((Get-Item $OutputFile).Length / 1KB, 1)) KB"