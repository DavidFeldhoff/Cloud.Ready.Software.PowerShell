﻿$workingfolder = 'C:\_WorkingFolder\Testperformance\'
$Source = Join-Path $workingfolder 'ALL_CFMD.txt'
$CurrentLanguage = 'NLB','FRB','ENU'
$DevelopmentLanguageId = 'ENU'

cd $workingfolder

$DevelopmentDictionary1.Count
$DevelopmentDictionary2.Count

$time1.TotalMilliseconds
$Time2.TotalMilliseconds

break
    
<#
$DevelopmentDictionary =
    Get-NAVApplicationObjectDevelopmentLanguage `
#>

break

$MyTranslations = 
    Get-NAVApplicationObjectLanguage `