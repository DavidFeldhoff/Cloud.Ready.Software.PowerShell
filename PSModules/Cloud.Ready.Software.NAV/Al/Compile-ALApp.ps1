function Compile-ALApp {
    param(
        [string] $appProjectFolder,        
        [string] $appSymbolsFolder,        
        [string] $appOutputFile,
        [bool] $GenerateReportLayoutParam,
        [bool] $EnableCodeCop,
        [bool] $EnableAppSourceCop,    
        [bool] $EnablePerTenantExtensionCop,     
        [bool] $EnableUICop,     
        [string] $rulesetFile,     
        [bool] $nowarn,     
        [string] $assemblyProbingPaths  
    )

    $alc = get-childitem -Path "$env:USERPROFILE\.vscode\extensions" -Recurse alc.exe | select -First 1

    # Remove translation file
    Get-ChildItem -path $appProjectFolder -Recurse -filter "*.g.xlf" | Remove-Item -Force
    
    $alcParameters = @("/project:$appProjectFolder", "/packagecachepath:$appSymbolsFolder", "/out:$appOutputFile")
    if ($GenerateReportLayoutParam) {
        $alcParameters += @($GenerateReportLayoutParam)
    }
    if ($EnableCodeCop) {
        $alcParameters += @("/analyzer:$(Join-Path $alcPath 'Analyzers\Microsoft.Dynamics.Nav.CodeCop.dll')")
    }
    if ($EnableAppSourceCop) {
        $alcParameters += @("/analyzer:$(Join-Path $alcPath 'Analyzers\Microsoft.Dynamics.Nav.AppSourceCop.dll')")
    }
    if ($EnablePerTenantExtensionCop) {
        $alcParameters += @("/analyzer:$(Join-Path $alcPath 'Analyzers\Microsoft.Dynamics.Nav.PerTenantExtensionCop.dll')")
    }
    if ($EnableUICop) {
        $alcParameters += @("/analyzer:$(Join-Path $alcPath 'Analyzers\Microsoft.Dynamics.Nav.UICop.dll')")
    }

    if ($rulesetFile) {
        $alcParameters += @("/ruleset:$rulesetfile")
    }

    if ($nowarn) {
        $alcParameters += @("/nowarn:$nowarn")
    }

    if ($assemblyProbingPaths) {
        $alcParameters += @("/assemblyprobingpaths:$assemblyProbingPaths")
    }

    Write-Host "alc.exe $([string]::Join(' ', $alcParameters))"

    & $alc.fullname $alcParameters

    $successfullyCompiled = $true

    # Check Translationfile
    $appJson = Get-Content (Join-Path $appProjectFolder 'app.json') | ConvertFrom-Json
    $translationsActivated = $appJson.features -and $appJson.features.ToLower().Contains('translationfile')
    if($translationsActivated){
        $TranslationFile = Get-ChildItem -path $appProjectFolder -Recurse -filter "apps.json"
        if (!$TranslationFile) {
            $successfullyCompiled = $false
        }
    }
    if ($successfullyCompiled) {
        Write-Host "Successfully compiled $appProjectFolder" -ForegroundColor Green
    } else {
        write-error "Compilation ended with errors"
    }
    
}