param(
    [Parameter(Mandatory)]
    [string] $InstallDirectory
)

$ErrorActionPreference = 'Stop'
$rsync = Join-Path $InstallDirectory 'bin/rsync.exe'
$ssh = Join-Path $InstallDirectory 'bin/ssh.exe'
& $rsync --version
if ($LASTEXITCODE -ne 0) { throw 'rsync failed to start' }
& $ssh -V
if ($LASTEXITCODE -ne 0) { throw 'Bundled SSH failed to start' }

$fixture = Join-Path ([IO.Path]::GetTempPath()) ('cwrsync-test-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path "$fixture/source", "$fixture/destination" | Out-Null
try {
    Set-Content -LiteralPath "$fixture/source/file with spaces.txt" -Value 'cwRsync copy verification' -Encoding utf8
    $posix = '/cygdrive/' + $fixture.Substring(0, 1).ToLowerInvariant() + $fixture.Substring(2).Replace('\', '/')
    & $rsync -a "$posix/source/" "$posix/destination/"
    if ($LASTEXITCODE -ne 0) { throw 'Local rsync copy failed' }
    $sourceHash = (Get-FileHash -LiteralPath "$fixture/source/file with spaces.txt").Hash
    $destinationHash = (Get-FileHash -LiteralPath "$fixture/destination/file with spaces.txt").Hash
    if ($sourceHash -ne $destinationHash) { throw 'Copied file content differs' }
} finally {
    $resolved = [IO.Path]::GetFullPath($fixture)
    $tempRoot = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd('\') + '\'
    if (!$resolved.StartsWith($tempRoot, [StringComparison]::OrdinalIgnoreCase)) { throw 'Unexpected fixture path' }
    Remove-Item -LiteralPath $resolved -Recurse -Force
}
