param (
    [parameter(Mandatory=$false)]
    [int] $BuildThreadCount=0,
    [parameter(Mandatory=$false)]
    [String] $BuildType="MinSizeRel"
)

### CONFIGURATION START ###
$ErrorActionPreference = "Stop"

if ( $BuildThreadCount -eq 0 ) {
    $ComputerSystem = Get-CimInstance -class Win32_ComputerSystem
    $BuildThreadCount = $ComputerSystem.NumberOfLogicalProcessors - 1
    if ( $BuildThreadCount -le 0) {
        $BuildThreadCount = 1
    }
}

Write-Output "Build thread count: $BuildThreadCount"
Write-Output "Build type: $BuildType"

$WorkDir = $PSScriptRoot
$BuildDir = "$WorkDir/build/desktop/"
$LibraryDir = "$WorkDir/openal/"

### CONFIGURATION END ###

md $BuildDir -Force | Out-Null
pushd $BuildDir

cmake -G "Visual Studio 16 2019" -A x64 -Thost=x64 `
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON `
  -DLIBTYPE=SHARED `
  -DALSOFT_UTILS=OFF `
  -DALSOFT_NO_CONFIG_UTIL=OFF `
  -DALSOFT_EXAMPLES=OFF `
  -DALSOFT_INSTALL=OFF `
  -DALSOFT_CPUEXT_SSE4_1=ON `
  -DALSOFT_REQUIRE_WINMM=ON `
  -DALSOFT_REQUIRE_DSOUND=ON `
  -DALSOFT_REQUIRE_WASAPI=ON `
  "$LibraryDir"

cmake --build "$BuildDir" --config $BuildType --parallel $BuildThreadCount

cp $BuildDir/$BuildType/OpenAL32.dll $BuildDir/

popd
