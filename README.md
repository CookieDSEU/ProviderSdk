# Nipkg Provider for PowerShell PackageManagement (aka OneGet) (C#)
This will be the official Nipkg provider for PackageManagement.

## Development Requires:
    - Visual Studio 2013+
    - Any official PackageManagement build from February 2015 or later.
	- NI Package Manager

## How to use:
1. Install NI Package Manager.
2. Build the project.
3. Run the install-provider.ps1 script under the root directory . and it will copy the assembly to the right spot.
4. Run Powershell as Administrator.
5. See if it loaded your provider assembly.

``` powershell

> get-packageprovider 

PS C:\root\nipkgProvider\output\v45\Debug\bin> get-packageprovider


Name                     Version          DynamicOptions
----                     -------          --------------
nipkg                    1.0.0.0          

```