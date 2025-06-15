[CmdletBinding()]
Param(
    [Parameter(Mandatory = $false, HelpMessage = "Name of the Wezterm directory in ./configs/ with the Wezterm configuration to install.")]
    [string]$ConfigName = "default"
)

# if ( -Not ( Get-Command wezterm -ErrorAction SilentlyContinue ) ) {
#     Write-Error "Wezterm is not installed. Please install Wezterm before running this script."
#     exit 1
# }

## Path script was launched from (should be repository root)
$CWD = $PWD.Path

## Path to Wezterm config source
$WEZTERM_CONFIG_SRC = ( Join-Path -Path $CWD -ChildPath ( Join-Path -Path "configs" -ChildPath $ConfigName ) )
Write-Debug "Wezterm config source: $WEZTERM_CONFIG_SRC"

## Path to ~/.config
$HOST_DOTCONFIG_DIR = "$env:USERPROFILE\.config"

## Check if config sourcce exists
if ( -not ( Test-Path $WEZTERM_CONFIG_SRC ) ) {
    Write-Error "Wezterm source config directory not found: $WEZTERM_CONFIG_SRC"
    exit 1
}

## Check if ~/.config exists, create if not
if ( -not ( Test-Path $HOST_DOTCONFIG_DIR -PathType Container -ErrorAction SilentlyContinue ) ) {
    Write-Warning "~/.config directory not found. Creating"
    try {
        New-Item -Path $HOST_DOTCONFIG_DIR -ItemType Directory
    }
    catch {
        Write-Error "Error creating ~/.config directory. Details: $($_.Exception.Message)"
        exit 1
    }
}

function Test-IsAdmin {
    ## Check if the current process is running with elevated privileges (admin rights)
    $isAdmin = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    return $isAdmin
}

function Start-AsAdmin {
    param (
        [string]$Command
    )

    # Check if the script is running as admin
    $isAdmin = [bool](New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    if (-not $isAdmin) {
        ## Prompt to run as administrator if not already running as admin
        $arguments = "-Command `"& {$command}`""
        Write-Debug "Running command: Start-Process powershell -ArgumentList $($arguments) -Verb RunAs"

        try {
            Start-Process powershell -ArgumentList $arguments -Verb RunAs
            return $true  # Indicate that the script was elevated and the command will run
        }
        catch {
            Write-Error "Error executing command as admin. Details: $($_.Exception.Message)"
        }
    }
    else {
        ## If already running as admin, execute the command
        Invoke-Expression $command

        ## Indicate that the command was run without elevation
        return $false
    }
}

## Check if ~/.wezterm already exists, backup if so
if ( Test-Path -Path "$env:USERPROFILE\.wezterm" ) {
    $Item = Get-Item "$env:USERPROFILE\.wezterm"

    ## Check if path is a junction
    if ( $Item.Attributes -band [System.IO.FileAttributes]::ReparsePoint ) {
        Write-Host "Path is already a junction: $Item" -ForegroundColor Green
    }
    else {
        ## Path is a regular directory
        Write-Warning "Path already exists: $Item. Moving to $($Item).bak"
        If ( Test-Path "$($Item).bak" ) { 
            Write-Warning "$($Item).bak already exists. Overwriting backup."
            Remove-Item -Recurse "$($Item).bak"
        }

        try {
            Move-Item $Item "$($Item).bak"
        }
        catch {
            Write-Error "Error moving $Item to $($Item).bak. Details: $($_.Exception.Message)"
            exit 1
        }
    }
}

function New-Symlink {
    Param(
        [Parameter(Mandatory = $true, HelpMessage = "Source file")]
        [string]$SRC,
        [Parameter(Mandatory = $true, HelpMessage = "Destination file")]
        [string]$DEST
    )
    $isAdmin = Test-IsAdmin

    $SymlinkCommand = "New-Item -Path $DEST -ItemType SymbolicLink -Value $SRC"

    if ( $isAdmin ) {
        try {
            Invoke-Expression $SymlinkCommand
        }
        catch {
            Write-Error "Error creating symlink from $SRC to $DEST. Details: $($_.Exception.Message)"
            exit 1
        }
    }
    else {
        Write-Warning "Script was not run as administrator. Running symlink command as administrator."
        try {
            Start-AsAdmin $SymlinkCommand
        }
        catch {
            Write-Error "Error creating symlink from $SRC to $DEST. Details: $($_.Exception.Message)"
            exit 1
        }
    }
}

## Symlink ~/.wezterm.lua
try {
    $SymlinkSuccess = New-Symlink -SRC "$WEZTERM_CONFIG_SRC" -DEST "$HOST_DOTCONFIG_DIR\wezterm"
}
catch {
    Write-Error "Error creating symlink for Wezterm Lua config file. Details: $($_.Exception.Message)"
    exit 1
}

Write-Host "Finished installing Wezterm config." -ForegroundColor Green
