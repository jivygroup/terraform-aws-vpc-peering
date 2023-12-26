[CmdletBinding()]
param (
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [String]
    $TestNamesRegex = "null"
)

$TAG = "latest"
docker run --rm -v ${pwd}:/lint -w /lint ghcr.io/antonbabenko/pre-commit-terraform:$TAG run -a

$tests = Get-ChildItem -Recurse -Filter '*.tftest.hcl' -File | Sort-Object
if ($TestNamesRegex) {
    $tests = $tests | Where-Object { $_.Name -match $TestNamesRegex }
} 

if (!$tests) {
    Write-Output "No tests requested"
    exit 0
}
Write-Output "Running tests: " $($tests | ForEach-Object { $_.Name })

$startingLocation = Get-Location

$tests | ForEach-Object -Parallel {
    if ($_.DirectoryName -notmatch "tests") {
        Push-Location -Path $_.DirectoryName
    }
    Write-Output "Running test: $($_.FullName)"
    terraform init -upgrade
    terraform validate
    terraform test
    $currentLocation = Get-Location
    if ($currentLocation -ne $startingLocation) {
        Pop-Location
    }
}
