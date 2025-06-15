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

## Check if config sourcce exists
if ( -not ( Test-Path $WEZTERM_CONFIG_SRC ) ) {
    Write-Error "Wezterm source config directory not found: $WEZTERM_CONFIG_SRC"
    exit 1
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
        # Prompt to run as administrator if not already running as admin
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
        # If already running as admin, execute the command
        Invoke-Expression $command
        return $false  # Indicate that the command was run without elevation
    }
}

## Check if ~/.wezterm.lua already exists, backup if so
if ( Test-Path -Path "$env:USERPROFILE\.wezterm.lua" ) {
    $Item = Get-Item "$env:USERPROFILE\.wezterm.lua"

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
        [Parameter(Mandatory = $false, HelpMessage = "Composed symlink command to run")]
        [string]$SymlinkCommand
    )
    $isAdmin = Test-IsAdmin

    if ( $isAdmin ) {
        try {
            Invoke-Expression $SymlinkCommand
        }
        catch {
            Write-Error "Error creating symlink from $SRC_FILE to $DEST_FILE. Details: $($_.Exception.Message)"
            exit 1
        }
    }
    else {
        Write-Warning "Script was not run as administrator. Running symlink command as administrator."
        try {
            Start-AsAdmin $SymlinkCommand
        }
        catch {
            Write-Error "Error creating symlink from $SRC_FILE to $DEST_FILE. Details: $($_.Exception.Message)"
            exit 1
        }
    }
}

function New-FileSymlink {
    Param(
        [Parameter(Mandatory = $true, HelpMessage = "Source file")]
        [string]$SRC_FILE,
        [Parameter(Mandatory = $true, HelpMessage = "Destination file")]
        [string]$DEST_FILE
    )

    Write-Host "Creating symlink from $SRC_FILE to $DEST_FILE" -ForegroundColor Green

    $SymlinkCommand = "New-Item -Path $DEST_FILE -ItemType SymbolicLink -Value $SRC_FILE"
    New-SymLink -SymlinkCommand $SymlinkCommand
}

function New-DirSymlink {
    Param(
        [Parameter(Mandatory = $true, HelpMessage = "Source directory")]
        [string]$SRC_DIR,
        [Parameter(Mandatory = $true, HelpMessage = "Destination directory")]
        [string]$DEST_DIR
    )

    Write-Host "Creating symlink from $SRC_DIR to $DEST_DIR" -ForegroundColor Green

    $SymlinkCommand = "New-Item -Path $DEST_DIR -ItemType SymbolicLink -Value $SRC_DIR"
    New-SymLink -SymlinkCommand $SymlinkCommand
}

## Symlink ~/.wezterm.lua
try {
    New-FileSymlink -SRC_FILE "$WEZTERM_CONFIG_SRC\.wezterm.lua" -DEST_FILE "$env:USERPROFILE\.wezterm.lua"
}
catch {
    Write-Error "Error creating symlink for Wezterm Lua config file. Details: $($_.Exception.Message)"
    exit 1
}

## Check if wezterm_modules dir exists in src
if ( Test-Path -Path ( Join-Path -Path $WEZTERM_CONFIG_SRC -ChildPath "wezterm_modules" -ErrorAction SilentlyContinue ) ) {
    Write-Host "Discovered a wezterm_modules directory in source config." -ForegroundColor Cyan

    if ( Test-Path "$env:USERPROFILE\.wezterm_modules" ) {

        ## Check if ~/.wezterm already exists, backup if so
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

        ## Symlink ~/.wezterm
        try {
            New-DirSymlink -SRC_DIR "$WEZTERM_CONFIG_SRC\wezterm_modules" -DEST_DIR "$env:USERPROFILE\.wezterm"
        }
        catch {
            Write-Error "Error creating symlink for Wezterm modules directory. Details: $($_.Exception.Message)"
            exit 1
        }
    }
}

Write-Host "Finished installing Wezterm config." -ForegroundColor Green
