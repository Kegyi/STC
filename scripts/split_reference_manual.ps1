# split_reference_manual.ps1
# Splits the Reference Manual (v2026.1.0.md) into individual section files.
# Output: sections/ subfolder next to the source file.
# Original file is NOT modified.

$sourceFile  = "c:\Users\Kegyi\STC\docs\STC Co-Pilot & Systems Architect Reference Manual\v2026.1.0.md"
$sectionsDir = "c:\Users\Kegyi\STC\docs\STC Co-Pilot & Systems Architect Reference Manual\sections"
$docTitle    = "STC Co-Pilot & Systems Architect Reference Manual v2026.1.0"

New-Item -ItemType Directory -Force -Path $sectionsDir | Out-Null

$allLines        = Get-Content $sourceFile -Encoding UTF8
$currentLines    = [System.Collections.Generic.List[string]]::new()
$currentFileName = "00_header_and_toc"
$utf8NoBom       = [System.Text.UTF8Encoding]::new($false)

function Save-Section {
    param($Lines, $FileName, $Dir, $Encoding)
    if ($Lines.Count -eq 0) { return }
    $outPath = Join-Path $Dir "$FileName.md"
    [System.IO.File]::WriteAllLines($outPath, $Lines, $Encoding)
    Write-Host "  Saved: $FileName.md  ($($Lines.Count) lines)"
}

foreach ($line in $allLines) {
    if ($line -match '^## (\d+)\. (.+)') {

        # Flush current buffer
        Save-Section $currentLines $currentFileName $sectionsDir $utf8NoBom

        # Build new filename
        $num   = $Matches[1].PadLeft(2, '0')
        $title = $Matches[2] `
                    -replace '<[^>]+>',  '' `
                    -replace '[^\w\s]',  '' `
                    -replace '\s+',      '_' `
                    -replace '_+',       '_'
        $title = $title.ToLower().Trim('_')
        $currentFileName = "${num}_${title}"

        # Start new buffer with a breadcrumb so each file is self-contained
        $currentLines = [System.Collections.Generic.List[string]]::new()
        $currentLines.Add("<!-- Part of: $docTitle -->")
        $currentLines.Add("")
        $currentLines.Add($line)
    }
    else {
        $currentLines.Add($line)
    }
}

# Flush final section
Save-Section $currentLines $currentFileName $sectionsDir $utf8NoBom

Write-Host ""
Write-Host "Done. $((Get-ChildItem $sectionsDir -Filter '*.md').Count) files created in:"
Write-Host "  $sectionsDir"
