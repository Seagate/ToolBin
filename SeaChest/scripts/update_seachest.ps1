# ================================================================================
# update_seachest.ps1 - Seagate drive utilities
# Copyright (c) 2018 Seagate Technology LLC and/or its Affiliates, All Rights Reserved
# v0.1 initial release
# v0.2 now pointing to github, added MD5 check
# v0.3 now basing update on build date instead of versions
# v0.4 need to support old and new --version layouts with multiple libraries
# ================================================================================

# Demonstrates how to chech for updates
# Exit levels:
# 0 You have the latest version or Download successful. 
# 1 Command help
# 2 There was a problem with the download. The file may be invalid.
# 3 Download declined
# 4 No matching application name found in the update data.
# 5 Application not found
# 6 MD5 mismatch

#=============== Global Variables ============================================
# Date last edit:
$Global:EDIT_STAMP="22-May-2018"
$Global:TITLE="SeaChest Utilities Update Script"
$Global:SC_UPDATE_PATH="https://raw.githubusercontent.com/Seagate/ToolBin/master/SeaChest/";
$Global:SC_UPDATE_FILE="seachestupdate.json";
$Global:SC_UPDATE_URL=$Global:SC_UPDATE_PATH+$Global:SC_UPDATE_FILE;

# Details for current app to check
$Global:CUR_APP_ARRAY="";
$Global:CUR_APP_NAME="";
$Global:CUR_APP_VER="";
$Global:CUR_APP_LIB="";
$Global:CUR_APP_DATE="";
$Global:CUR_APP_REV="";
$Global:CUR_APP_ARCH="";
$Global:CUR_APP_OS="";

[Array]$Global:JSON_DATA_ARRAY=@(); #empty array
$Global:UPD_APP_NAME="";
$Global:UPD_APP_DATE="";
$Global:UPD_APP_REV="";
$Global:UPD_APP_PATH="";
$Global:UPD_APP_OS="";
$Global:UPD_APP_FILE="";
$Global:UPD_APP_URL="";


#=============== Function Declarations ========================================

#------------------------------------------------------
Function repecho() {
  # draws the separator line
  Param (
    [int]$rep_count,
    [string]$rep_char
  ) # End of Parameters
  Process {
    for ($i=1; $i -le $rep_count; $i++)
    {
      Write-Host -NoNewline "$rep_char";
    }
    Write-Host;
  } # End of Process
}

#------------------------------------------------------
#https://stackoverflow.com/questions/2688547/multiple-foreground-colors-in-powershell-in-one-command
#see this excellent answer by mklement0, thanks!
<#
.SYNOPSIS
A wrapper around Write-Host that supports selective coloring of
substrings via embedded coloring specifications.

.DESCRIPTION
In addition to accepting a default foreground and background color,
you can embed one or more color specifications in the string to write,
using the following syntax:
#<fgcolor>[:<bgcolor>]#<text>#

<fgcolor> and <bgcolor> must be valid [ConsoleColor] values, such as 'green' or 'white' (case does not matter).
Everything following the color specification up to the next '#', or impliclitly to the end of the string,
is written in that color.

Note that nesting of color specifications is not supported.
As a corollary, any token that immediately follows a color specification is treated
as text to write, even if it happens to be a technically valid color spec too.
This allows you to use, e.g., 'The next word is #green#green#.', without fear
of having the second '#green' be interpreted as a color specification as well.

.PARAMETER ForegroundColor
Specifies the default text color for all text portions
for which no embedded foreground color is specified.

.PARAMETER BackgroundColor
Specifies the default background color for all text portions
for which no embedded background color is specified.

.PARAMETER NoNewline
Output the specified string withpout a trailing newline.

.NOTES
While this function is convenient, it will be slow with many embedded colors, because,
behind the scenes, Write-Host must be called for every colored span.

.EXAMPLE
Write-HostColored "#green#Green foreground.# Default colors. #blue:white#Blue on white."

.EXAMPLE
'#black#Black on white (by default).#Blue# Blue on white.' | Write-HostColored -BackgroundColor White

#>

function Write-HostColored() {
    [CmdletBinding()]
    param(
        [parameter(Position=0, ValueFromPipeline=$true)]
        [string[]] $Text
        ,
        [switch] $NoNewline
        ,
        [ConsoleColor] $BackgroundColor = $host.UI.RawUI.BackgroundColor
        ,
        [ConsoleColor] $ForegroundColor = $host.UI.RawUI.ForegroundColor
    )

    begin {
        # If text was given as a parameter value, it'll be an array.
        # Like Write-Host, we flatten the array into a single string
        # using simple string interpolation (which defaults to separating elements with a space,
        # which can be changed by setting $OFS).
        if ($Text -ne $null) {
            $Text = "$Text"
        }
    }

    process {
        if ($Text) {

            # Start with the foreground and background color specified via
            # -ForegroundColor / -BackgroundColor, or the current defaults.
            $curFgColor = $ForegroundColor
            $curBgColor = $BackgroundColor

            # Split message into tokens by '#'.
            # A token between to '#' instances is either the name of a color or text to write (in the color set by the previous token).
            $tokens = $Text.split("#")

            # Iterate over tokens.
            $prevWasColorSpec = $false
            foreach($token in $tokens) {

                if (-not $prevWasColorSpec -and $token -match '^([a-z]*)(:([a-z]+))?$') { # a potential color spec.
                    # If a token is a color spec, set the color for the next token to write.
                    # Color spec can be a foreground color only (e.g., 'green'), or a foreground-background color pair (e.g., 'green:white'), or just a background color (e.g., ':white')
                    try {
                        $curFgColor = [ConsoleColor] $matches[1]
                        $prevWasColorSpec = $true
                    } catch {}
                    if ($matches[3]) {
                        try {
                            $curBgColor = [ConsoleColor] $matches[3]
                            $prevWasColorSpec = $true
                        } catch {}
                    }
                    if ($prevWasColorSpec) {
                        continue
                    }
                }

                $prevWasColorSpec = $false

                if ($token) {
                    # A text token: write with (with no trailing line break).
                    # !! In the ISE - as opposed to a regular PowerShell console window,
                    # !! $host.UI.RawUI.ForegroundColor and $host.UI.RawUI.ForegroundColor inexcplicably
                    # !! report value -1, which causes an error when passed to Write-Host.
                    # !! Thus, we only specify the -ForegroundColor and -BackgroundColor parameters
                    # !! for values other than -1.
                    # !! Similarly, PowerShell Core terminal windows on *Unix* report -1 too.
                    $argsHash = @{}
                    if ([int] $curFgColor -ne -1) { $argsHash += @{ 'ForegroundColor' = $curFgColor } }
                    if ([int] $curBgColor -ne -1) { $argsHash += @{ 'BackgroundColor' = $curBgColor } }
                    Write-Host -NoNewline @argsHash $token
                }

                # Revert to default colors.
                $curFgColor = $ForegroundColor
                $curBgColor = $BackgroundColor

            }
        }
        # Terminate with a newline, unless suppressed
        if (-not $NoNewLine) { write-host }
    }
}

#------------------------------------------------------
#https://weblogs.asp.net/soever/returning-an-exit-code-from-a-powershell-script
#see this excellent blog post by Serge van den Oever [Macaw], thanks!

Function ExitWithCode { 
    param 
    ( 
        $exitcode 
    )

    $host.SetShouldExit($exitcode) 
    exit 
}

#------------------------------------------------------
#https://gist.github.com/dlwyatt/2a893db5e022e60beced
#good job, Dave!
#further refined by Twan...
#http://www.neroblanco.co.uk/2016/07/download-content-wpc-2016-via-powershell/

function Invoke-FileDownload {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [uri] $Uri,

    [Parameter(Mandatory)]
    [string] $OutputFile,

    [Parameter(Mandatory)]
    [string] $ProgressStatus
  )

  $webClient = New-Object System.Net.WebClient

  Write-Progress -Activity $ProgressStatus -PercentComplete 0
  $MessageData = New-Object PSObject -Property @{ProgressStatus=$ProgressStatus}

  $changed = Register-ObjectEvent -InputObject $webClient -EventName DownloadProgressChanged -MessageData $MessageData -Action {
    Write-Progress -Activity $Event.MessageData.ProgressStatus -PercentComplete $eventArgs.ProgressPercentage
}

  $handle = $webClient.DownloadFileAsync($Uri, $PSCmdlet.GetUnresolvedProviderPathFromPSPath($OutputFile))

  while ($webClient.IsBusy) {
    Start-Sleep -Milliseconds 1000
  }

  Write-Progress -Activity $ProgressStatus -Completed
  Get-Job $changed -ErrorAction SilentlyContinue | Remove-Job -Force -ErrorAction SilentlyContinue
  Get-EventSubscriber | Where SourceObject -eq $webClient | Unregister-Event -Force -ErrorAction SilentlyContinue
}

#------------------------------------------------------
Function populate_current_app_data() {
  Param (
    [string]$app
  ) # End of Parameters

  #for quick testing this script
  #$app="C:\Program Files\Seagate\SeaChest\SeaChest_Basics.exe";
  #$app="C:\Program Files\Seagate\SeaChest\SeaChest_Info.exe";
  #Write-Host $app;
  $Global:CUR_APP_ARRAY=& $app --version --verbose 0;
  #Write-Host '$?='$?;
  #Write-Host '$LastExitCode='$LastExitCode;
  if ($LastExitCode -ne 0) {
    Write-HostColored "Application #red:black#$app# not found";
    Write-Host "";
    ExitWithCode 5;
  }

  #two versions of version information, find which one 
  for ($i = 0; $i -le $Global:CUR_APP_ARRAY.Count-1; $i++) {
    #Write-Host $i  $Global:CUR_APP_ARRAY[$i];
    if ($Global:CUR_APP_ARRAY[$i] -match "Library") {
      $verbose_ver="OLD";
    }
  }

  if ($verbose_ver -eq "OLD") {
    #Write-Host "Library found!! OLD version";
    $Global:CUR_APP_NAME=$Global:CUR_APP_ARRAY[0];
    $Global:CUR_APP_NAME=$Global:CUR_APP_NAME.Split(' ')[-1];
    $Global:CUR_APP_NAME=$Global:CUR_APP_NAME -replace '.$'; #last character
    #Write-Host $Global:CUR_APP_NAME;
    $Global:CUR_APP_VER=$Global:CUR_APP_ARRAY[1];
    $Global:CUR_APP_VER=$Global:CUR_APP_VER.Split(' ')[-1];
    $Global:CUR_APP_LIB=$Global:CUR_APP_ARRAY[2];
    $Global:CUR_APP_LIB=$Global:CUR_APP_LIB.Split(' ')[-1];
    $Global:CUR_APP_LIB=$Global:CUR_APP_LIB -replace '\.','_';
    $Global:CUR_APP_ARRAY[3]=$Global:CUR_APP_ARRAY[3] -replace '  ',' '; #sometimes there are two spaces after the month, need just one
    #$Global:CUR_APP_ARRAY[3];
    $Global:CUR_APP_DATE=$Global:CUR_APP_ARRAY[3];
    $Global:CUR_APP_DATE=$Global:CUR_APP_DATE.Split(' ')[-3..-1];
    [string]$Global:CUR_APP_DATE=$Global:CUR_APP_DATE -join '-';
    #Write-Host $Global:CUR_APP_VER;
    #Write-Host $Global:CUR_APP_LIB;
    #Write-Host $Global:CUR_APP_DATE;
    $Global:CUR_APP_REV="$Global:CUR_APP_VER-$Global:CUR_APP_LIB";
    #Write-Host $Global:CUR_APP_REV;
    $Global:CUR_APP_ARCH=$Global:CUR_APP_ARRAY[4];
    $Global:CUR_APP_ARCH=$Global:CUR_APP_ARCH.Split(' ')[-1];
    $Global:CUR_APP_OS=$Global:CUR_APP_ARRAY[8];
    $Global:CUR_APP_OS=$Global:CUR_APP_OS.Split(' ')[-1];
    #Write-Host $Global:CUR_APP_ARCH;
    #Write-Host $Global:CUR_APP_OS;
  }
  else {
    #Write-Host "Library not found!! NEW version";
    $Global:CUR_APP_NAME=$Global:CUR_APP_ARRAY[0];
    $Global:CUR_APP_NAME=$Global:CUR_APP_NAME.Split(' ')[-1];
    $Global:CUR_APP_NAME=$Global:CUR_APP_NAME -replace '.$'; #last character
    #Write-Host $Global:CUR_APP_NAME;
    $Global:CUR_APP_VER=$Global:CUR_APP_ARRAY[1];
    $Global:CUR_APP_VER=$Global:CUR_APP_VER.Split(' ')[-1];
    $Global:CUR_APP_LIB=$Global:CUR_APP_ARRAY[3];
    $Global:CUR_APP_LIB=$Global:CUR_APP_LIB.Split(' ')[-1];
    $Global:CUR_APP_LIB=$Global:CUR_APP_LIB -replace '\.','_';
    $Global:CUR_APP_ARRAY[5]=$Global:CUR_APP_ARRAY[5] -replace '  ',' '; #sometimes there are two spaces after the month, need just one
    #$Global:CUR_APP_ARRAY[5];
    $Global:CUR_APP_DATE=$Global:CUR_APP_ARRAY[5];
    $Global:CUR_APP_DATE=$Global:CUR_APP_DATE.Split(' ')[-3..-1];
    [string]$Global:CUR_APP_DATE=$Global:CUR_APP_DATE -join '-';
    #Write-Host $Global:CUR_APP_VER;
    #Write-Host $Global:CUR_APP_LIB;
    #Write-Host $Global:CUR_APP_DATE;
    $Global:CUR_APP_REV="$Global:CUR_APP_VER-$Global:CUR_APP_LIB";
    #Write-Host $Global:CUR_APP_REV;
    $Global:CUR_APP_ARCH=$Global:CUR_APP_ARRAY[6];
    $Global:CUR_APP_ARCH=$Global:CUR_APP_ARCH.Split(' ')[-1];
    $Global:CUR_APP_OS=$Global:CUR_APP_ARRAY[10];
    $Global:CUR_APP_OS=$Global:CUR_APP_OS.Split(' ')[-1];
    #Write-Host $Global:CUR_APP_ARCH;
    #Write-Host $Global:CUR_APP_OS;
  }
}

#------------------------------------------------------
Function download_update_data() {
  Write-Host  "Checking for updates ...";
  Write-Host  "";
  #Write-Host  $Global:SC_UPDATE_URL;
  #method 1
  #Invoke-RestMethod -Uri $Global:SC_UPDATE_URL -OutFile ".\$Global:SC_UPDATE_FILE";
  #method 2
  #$wc = New-Object System.Net.WebClient
  #$wc.DownloadFile($Global:SC_UPDATE_URL, "./$Global:SC_UPDATE_FILE")
  #OR
  #(New-Object System.Net.WebClient).DownloadFile($url, $output)
  #method 3
  #Invoke-FileDownload2 $Global:SC_UPDATE_URL $Global:SC_UPDATE_FILE;
  #method 4
  $ProgressStatus = ("Downloading $Global:SC_UPDATE_URL to $Global:SC_UPDATE_FILE")
  #Write-Host $ProgressStatus
  Invoke-FileDownload $Global:SC_UPDATE_URL $Global:SC_UPDATE_FILE $ProgressStatus;
}

#------------------------------------------------------
Function populate_update_data() {
  # method 1
  #$Global:JSON_DATA_ARRAY=Get-Content "./$Global:SC_UPDATE_FILE";
  # method 2
  $Global:JSON_DATA_ARRAY = (Get-Content "./$Global:SC_UPDATE_FILE" -Raw) | ConvertFrom-Json;
  #$Global:JSON_DATA_ARRAY | Get-Member | Select-Object name
  #$Global:JSON_DATA_ARRAY."seachest_apps" | Get-Member | Select-Object name # name is reserved system, just coincedence my array also uses name
  #$Global:JSON_DATA_ARRAY."seachest_apps".name
  #$Global:JSON_DATA_ARRAY."seachest_apps".version
  #$Global:JSON_DATA_ARRAY."seachest_apps".date
  #$Global:JSON_DATA_ARRAY."seachest_apps".lin | Get-Member | Select-Object name
  #$Global:JSON_DATA_ARRAY."seachest_apps".win | Get-Member | Select-Object name
  #$Global:JSON_DATA_ARRAY."seachest_apps".lin.app_path
  #$Global:JSON_DATA_ARRAY."seachest_apps".lin.'32bit' # won't work without the quotes, not sure why
  #$Global:JSON_DATA_ARRAY."seachest_apps".lin.'64bit'
  #$Global:JSON_DATA_ARRAY.'seachest_apps'.'touch_date'[11] #increment this number if more tools are added to the json file
  #$Global:JSON_DATA_ARRAY.'seachest_apps'.'git_path'[12] #increment this number if more tools are added to the json file

  #maybe test for array ne to null? exit out if yes
  #https://stackoverflow.com/questions/23062087/how-do-you-get-the-name-field-of-a-json-object-in-powershell-if-you-dont-know-i/23062370#23062370
}

#------------------------------------------------------

Function check_update_data () {

  #Write-Host $Global:CUR_APP_NAME;
  for ($i = 0; $i -le $Global:JSON_DATA_ARRAY."seachest_apps".Count-1; $i++) {
    if ($Global:JSON_DATA_ARRAY."seachest_apps".name[$i] -match $Global:CUR_APP_NAME) {
      # match the current app to the update data
      #Write-Host -NoNewline "$i";
      #Write-Host $Global:JSON_DATA_ARRAY."seachest_apps".name[$i];
      $Global:UPD_APP_NAME=$Global:JSON_DATA_ARRAY."seachest_apps".name[$i];
      $Global:UPD_APP_REV=$Global:JSON_DATA_ARRAY."seachest_apps".version[$i];
      $Global:UPD_APP_DATE=$Global:JSON_DATA_ARRAY."seachest_apps".date[$i];
      #Write-Host $Global:UPD_APP_DATE;
      if ($Global:CUR_APP_OS -eq "Windows") {
        $Global:UPD_APP_OS=$Global:JSON_DATA_ARRAY."seachest_apps".win.app_path[$i];
        if ($Global:CUR_APP_ARCH -eq "X86") {
          $Global:UPD_APP_FILE=$Global:JSON_DATA_ARRAY."seachest_apps".win.'32bit'[$i]
          #Write-Host $Global:UPD_APP_FILE
        }
        elseif ($Global:CUR_APP_ARCH -eq "X86_64") {
          $Global:UPD_APP_FILE=$Global:JSON_DATA_ARRAY."seachest_apps".win.'64bit'[$i]
          #Write-Host $Global:UPD_APP_FILE
        }
      }
      elseif ($Global:CUR_APP_OS -eq "Linux") {
        $Global:UPD_APP_OS=$Global:JSON_DATA_ARRAY."seachest_apps".lin.app_path[$i];
        if ($Global:CUR_APP_ARCH -eq "X86" ) {
          $Global:UPD_APP_FILE=$Global:JSON_DATA_ARRAY."seachest_apps".lin.'32bit'[$i]
          #Write-Host $Global:UPD_APP_FILE
        }
        elseif ($Global:CUR_APP_ARCH -eq "X86_64") {
          $Global:UPD_APP_FILE=$Global:JSON_DATA_ARRAY."seachest_apps".lin.'64bit'[$i]
          #Write-Host $Global:UPD_APP_FILE
        }
      }
    }
  }
  if ($Global:UPD_APP_NAME -eq "") {
    Write-HostColored "#black:red#No matching application name found in the update data.#";
    Write-Host "";
    ExitWithCode 4;
  }
  $Global:UPD_APP_PATH=$Global:JSON_DATA_ARRAY.'seachest_apps'.'git_path'[12]; #increment this number if more tools are added to the json file
  $WarningPreference='SilentlyContinue';
  Write-HostColored "#yellow:black#Latest:#";
  Write-Host "$Global:UPD_APP_NAME   $Global:UPD_APP_REV   $Global:CUR_APP_OS   $Global:CUR_APP_ARCH   $Global:UPD_APP_DATE";
  # change CUR_APP_REV to test download
  #$Global:CUR_APP_REV="foo";

  #Write-Host $Global:CUR_APP_DATE;
  #Write-Host $Global:UPD_APP_DATE;
  $cur_date=[datetime]::parseexact($Global:CUR_APP_DATE, 'MMM-d-yyyy', $null);
  $upd_date=[datetime]::parseexact($Global:UPD_APP_DATE, 'MMM-d-yyyy', $null);

  #if ([datetime]::parseexact($Global:CUR_APP_DATE, 'MMM-d-yyyy', $null) -eq [datetime]::parseexact($Global:UPD_APP_DATE, 'MMM-d-yyyy', $null)) {
  if ($cur_date -eq $upd_date) {
    Write-HostColored "#white:blue#Your copy of $Global:CUR_APP_NAME is up to date.#";
  } 
  elseif ($cur_date -lt $upd_date) {
    Write-HostColored "#white:blue#Your copy of $Global:CUR_APP_NAME is old.#";
    $Global:UPD_APP_URL=$Global:UPD_APP_PATH+$Global:UPD_APP_OS+$Global:UPD_APP_FILE;
    #Write-Host "$Global:UPD_APP_PATH";
    #Write-Host "$Global:UPD_APP_OS";
    #Write-Host "$Global:UPD_APP_FILE";
    #Write-Host "$Global:UPD_APP_URL";
  }
  elseif ($cur_date -gt $upd_date) {
    Write-HostColored "#white:blue#Your copy of $Global:CUR_APP_NAME is actually newer than the available update.#";
  }
  Write-Host "";
  # check if we found a file to assign to the file variable, returns false if empty
  if ($Global:UPD_APP_URL -ne "") {
    return $true;
  }
  else {
    return $false;
  }
}

#------------------------------------------------------
Function check_md5 () {

  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [string] $inputFile,
    [Parameter(Mandatory)]
    [string] $inputhashFile
  )

  #method 1
  #Get-FileHash $inputFile -Algorithm MD5;
  #method 2
  $md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider;
  $test_md5 = [System.BitConverter]::ToString($md5.ComputeHash([System.IO.File]::ReadAllBytes($inputFile)));
  $test_md5 = $test_md5 -replace '-','';
  Write-Host "Checking MD5:     "$test_md5;
  Write-Host -NoNewLine "Expected "
  $hash_md5=Get-Content ./$inputhashFile;
  for ($i = 0; $i -le $hash_md5.Count-1; $i++) {
    if ($hash_md5[$i] -match "MD5") {
      Write-Host -NoNewline $hash_md5[$i]
      if ($hash_md5[$i] -match $test_md5) {
        Write-HostColored " #white:red#Match!#";
        Write-Host "";
        Remove-Item ./$inputhashFile; 
      }
      else {
        Write-HostColored " #white:red#Not a match!#";
        Write-Host "";
        Remove-Item ./$inputhashFile; 
        Remove-Item ./$inputFile; 
        ExitWithCode 6;
      }
    }
  }
  #Write-Host -NoNewline 
}

#=============== Main =========================================================
#Clear-Host
Write-Host  "";
Write-Host  "$Global:TITLE                               ver: $Global:EDIT_STAMP";
repecho 40 ~=;
Write-Host  "";

If ($args.Count -eq 0 -or ($args[0] -eq "--help" -or $args[0] -eq "-help" -or $args[0] -eq "-h" -or $args[0] -eq "/?" )) {
  #Write-Host $args.Count;
  #Write-Host $args[0];
  Write-HostColored -NoNewline "Usage:   #white:blue#./update_seachest.sh# #black:green#<SeaChest app name>#";
  Write-Host ""; Write-Host "";
  Write-HostColored -NoNewline "Example: #white:blue#./update_seachest.sh# #white:red#SeaChest_Basics_271_1177_32#";
  Write-Host ""; Write-Host "";
  ExitWithCode 1;
}

$sc_app=$args[0]

populate_current_app_data $sc_app;
Write-HostColored "#yellow:black#Current:#";
#$Global:CUR_APP_NAME="SomeTestNameDoesn'tMatter";
Write-Host  "$Global:CUR_APP_NAME   $Global:CUR_APP_REV   $Global:CUR_APP_OS   $Global:CUR_APP_ARCH   $Global:CUR_APP_DATE";
#Write-Host  $CUR_APP_VER;
#Write-Host  $CUR_APP_LIB;
#Write-Host  "";

download_update_data;
populate_update_data;

If (check_update_data) {
  Write-Host -NoNewline "Newer?: ";
  Write-HostColored "#black:red#Yes, at this link...#";
  Write-Host $Global:UPD_APP_URL;
  Write-Host "";
  Write-Host -NoNewline "Download the update? yes/no ";
  $reply = [System.Console]::ReadKey().Key.ToString();
  Write-Host "";
  if ($reply -match "[yY]") { 
    $hash_url=$Global:UPD_APP_URL+".hash.txt";
    #Write-Host $hash_url;
    $hash_file=$Global:UPD_APP_FILE+".hash.txt";
    #Write-Host $hash_file;
    $ProgressStatus = " ";
	Write-Host $ProgressStatus;
    Invoke-FileDownload $hash_url $hash_file $ProgressStatus;

    $ProgressStatus = ("Downloading $Global:UPD_APP_URL to $Global:UPD_APP_FILE")
	#Write-Host $ProgressStatus
    Invoke-FileDownload $Global:UPD_APP_URL $Global:UPD_APP_FILE $ProgressStatus;
    $tmp_result=$?;
    Write-Host "";
    #Write-Host '$?='$tmp_result;
    if ($tmp_result -eq $False) {
      Write-Host "There was a problem with the download. The file may be invalid.";
      ExitWithCode 2;
    }
    else {
      check_md5 $Global:UPD_APP_FILE $hash_file;
      Write-HostColored -NoNewline "#black:green#Download successful.#";
      Write-HostColored "#yellow:black#  Here is the version information from the new download:#";
      & .\$Global:UPD_APP_FILE --version --echoCommandLine;
      Write-Host "Thank you for using SeaChest Utilities.";
    }
  }
  else {
    Write-Host "You didn't say yes."
    Write-Host "";
    ExitWithCode 3;
  }
}
else {
  Write-Host -NoNewLine "Newer?: ";
  Write-HostColored "black:green#Not at this time.#";
  Write-Host "";
}
# check if we found a file to assign to the file variable, returns exit code 1 if empty
if ($Global:UPD_APP_URL -ne "") {
  ExitWithCode 0;
}
else {
  ExitWithCode 1;
};

#Show how to run a PowerShell script.
