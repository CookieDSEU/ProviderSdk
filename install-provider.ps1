#.Synopsis
#   Copy the provider assembly to LocalAppData
#.Description
#   By default it will find the newest .*Provider.dll and copy it to the right location
#   You can also specify the build name (e.g. 'debug' or 'release') to use.
[CmdletBinding()]
param(
    # If specified, force to use the output in a specific build folder
    [string]$build = '',
    [string]$providerName = 'NipkgProvider',
    # How many levels UP to check for output folders (defaults to 2)
    $depth = 2
)

while($depth-- -gt 0) {
    Write-Verbose "Searching '$pwd' for '${providerName}.dll'"
    $candidates = Get-ChildItem -Recurse -Filter "${providerName}.dll" |
                     Where-Object { $_.FullName -match "\\output\\" }
                     Sort-Object -Descending -Property LastWriteTime

    $candidates2 = Get-ChildItem -Recurse -Filter "NationalInstruments.PackageManagement.Core.dll" |
                     Where-Object { $_.FullName -match "\\output\\" }
                     Sort-Object -Descending -Property LastWriteTime

    if( $build ) {
         $candidates = $candidates | Where-Object { $_.FullName -match $build }
		 $candidates2 = $candidates2 | Where-Object { $_.FullName -match $build }
    }

    $provider = $candidates | Select-Object -First 1
    if( -not $provider ) {
        cd ..
    }

	$provider2 = $candidates2 | Select-Object -First 1
    if( -not $provider ) {
        cd ..
    }
}

if( -not $provider ) {
    Write-Error "Can't find assembly '${providerName}.dll' under '$Pwd' with '\output\' and '$build' somewhere in the path`n"
    Pop-Location
    return
}

if( -not $provider2 ) {
    Write-Error "Can't find assembly 'NationalInstruments.PackageManagement.Core.dll' under '$Pwd' with '\output\' and '$build' somewhere in the path`n"
    Pop-Location
    return
}

$srcpath = $provider.Fullname
$filename = $provider.Name

$srcpath2 = $provider2.Fullname
$filename2 = $provider2.Name

$output = "${Env:LocalAppData}\PackageManagement\providerassemblies\$fileName"
$output2 = "${Env:LocalAppData}\PackageManagement\providerassemblies\$fileName2"

if(Test-Path $output) {
    Write-Warning "Found existing provider. Deleting `n   '$output' `n"
    # delete the old provider assembly
    # even if it's in use.
    $tmpName = "$filename.delete-me.$(get-random)"
    $tmpPath = "$env:localappdata\PackageManagement\providerassemblies\$tmpName"

    Rename-Item $output $tmpName -force -ea SilentlyContinue
    Remove-Item -force -ea SilentlyContinue $tmpPath
    if(Test-Path $tmpPath) {
        # locked. Move to temp folder
        Write-Warning "Old provider is in use, moving to `n   '$env:TEMP' folder `n   However, you must restart any processes using it!"
        Move-Item $tmpPath $env:TEMP
    }

    if(Test-Path $output) {
        Write-Error "Cannot remove existing provider file: `n $output `n"
        Pop-Location
        return
    }

}

if(Test-Path $output2) {
    Write-Warning "Found existing reference. Deleting `n   '$output2' `n"
    # delete the old reference assembly
    # even if it's in use.
    $tmpName2 = "$filename2.delete-me.$(get-random)"
    $tmpPath2 = "$env:localappdata\PackageManagement\providerassemblies\$tmpName2"

    Rename-Item $output2 $tmpName2 -force -ea SilentlyContinue
    Remove-Item -force -ea SilentlyContinue $tmpPath2
    if(Test-Path $tmpPath2) {
        # locked. Move to temp folder
        Write-Warning "Old reference is in use, moving to `n   '$env:TEMP' folder `n   However, you must restart any processes using it!"
        Move-Item $tmpPath2 $env:TEMP
    }

    if(Test-Path $output2) {
        Write-Error "Cannot remove existing reference file: `n $output2 `n"
        Pop-Location
        return
    }

}

Write-Host "Copying provider `nFrom:   '$srcPath'`nTo:     '$output' `n"
Write-Host "Copying reference `nFrom:   '$srcPath2'`nTo:     '$output2' `n"

Copy-Item -force $srcPath $output
Copy-Item -force $srcPath2 $output2

Pop-Location
