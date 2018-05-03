#region Main
function Main {
    $Config = Get-Configuration
    
    if ($PSVersionTable.PSEdition -ne 'Core') {
        $OSArch = Get-CimInstance -ClassName Win32_OperatingSystem |
        Select-Object -ExpandProperty OSArchitecture
        
        $Config = $Config |
        Where-Object { $_.OperatingSystem -eq 'Windows' -and $_.OSArchitecture -eq $OSArch }
        
        try {
            Get-Command -Name pwsh -ErrorAction Stop
        }
        catch {
            Install-PSCore -PSCoreUri $Config.PSCoreUri
        }
        
        try {
            Start-Process -FilePath pwsh -ArgumentList $HostInvocation.PSCommandPath
            exit
        }
        catch {
            exit 1
        }
    }
    
    if ($IsWindows) {
        $OSArch = Get-CimInstance -ClassName Win32_OperatingSystem |
        Select-Object -ExpandProperty OSArchitecture
        
        $Config = $Config |
        Where-Object { $_.OperatingSystem -eq 'Windows' -and $_.OSArchitecture -eq $OSArch }
    }
    elseif ($IsMacOS) {
        $Config = $Config |
        Where-Object { $_.OperatingSystem -eq 'MacOS' }
    }
    
    Install-Chrome -ChromeUri $Config.ChromeUri
    Install-NodeJs -NodeJsUri $Config.NodeJsUri
    Install-Atom -AtomUri $Config.AtomUri
    Install-Git -Config $Config.GitUri
    
    Write-Verbose -Message 'Installation is complete.'
}
#endregion


#region Get-Configuration
function Get-Configuration {
    try {
        $ConfigPath = Join-Path -Path $PSScriptRoot -ChildPath 'KCWIT_ToolsInstall.xml' -ErrorAction Stop
        Import-Clixml -Path $ConfigPath -ErrorAction Stop
    }
    catch {
        Write-Warning -Message "Failed to import configuration file: $ConfigPath"
        exit 1
    }
}
#endregion


#region Install-PSCore
function Install-PSCore {
    param
    (
        [string]$PSCoreUri
    )
    
    Write-Verbose -Message 'Downloading PowerShell Core.'
    
    $PSCorePath = Join-Path -Path $env:TEMP -ChildPath PSCore.msi
    
    try {
        if (Get-Command -Name Invoke-WebRequest -ErrorAction SilentlyContinue) {
            Invoke-WebRequest -Uri $PSCoreUri -OutFile $PSCorePath -ErrorAction Stop
        }
        else {
            Invoke-WebFileDownload -Uri $PSCoreUri -Path $PSCorePath -ErrorAction Stop
        }
        
        Write-Verbose -Message 'Installing PowerShell Core.'
        Start-Process -FilePath msiexec -ArgumentList "/i $PSCorePath /qn /norestart" -Wait -NoNewWindow
    }
    catch {
        Write-Error -ErrorRecord $Error[0]
    }
    
    if ($LASTEXITCODE -eq 0) {
        Write-Verbose -Message 'PowerShell Core successfully installed.'
    }
    else {
        Write-Warning -Message 'PowerShell Core install failed.'
    }
}

#endregion


#region Install-Chrome
function Install-Chrome {
    param
    (
        [string]$ChromeUri
    )
    
    if ($IsWindows) {
        if (Get-Command -Name Chrome.exe -ErrorAction SilentlyContinue) {
            Write-Verbose -Message 'Chrome already installed.'
        }
        else {
            Write-Verbose -Message 'Downloading Chrome.'
            
            $ChromePath = Join-Path -Path $env:TEMP -ChildPath Chrome.msi
            
            try {
                Invoke-WebRequest -Uri $ChromeUri -OutFile $ChromePath -ErrorAction Stop
                Write-Verbose -Message 'Installing Chrome.'
                Start-Process -FilePath msiexec -ArgumentList "/i $ChromePath /qn /norestart" -Wait -NoNewWindow
            }
            catch {
                Write-Error -ErrorRecord $Error[0]
            }
            
            if ($LASTEXITCODE -eq 0) {
                Write-Verbose -Message 'Chrome successfully installed.'
            }
            else {
                Write-Warning -Message 'Chrome install failed.'
            }
        }
    }
    elseif ($IsMacOS) {
        #TODO: MacOS install
    }
}
#endregion


#region Install-Git
function Install-Git {
    param
    (
        [psobject]$Config
    )
    
    #TODO: Git install
}

#endregion


#region Install-NodeJs
function Install-NodeJs {
    param
    (
        [string]$NodeJsUri
    )
    
    #TODO: Update npm
    if ($IsWindows) {
        if (Get-Command -Name node.exe -ErrorAction SilentlyContinue) {
            Write-Verbose -Message 'NodeJs already installed.'
        }
        else {
            Write-Verbose -Message 'Downloading NodeJs.'
            
            $NodeJsPath = Join-Path -Path $env:TEMP -ChildPath NodeJs.msi
            
            try {
                Invoke-WebRequest -Uri $NodeJsUri -OutFile $NodeJsPath -ErrorAction Stop
                Write-Verbose -Message 'Installing NodeJs.'
                Start-Process -FilePath msiexec -ArgumentList "/i $NodeJsPath /qn /norestart" -Wait -NoNewWindow
            }
            catch {
                Write-Error -ErrorRecord $Error[0]
            }
            
            if ($LASTEXITCODE -eq 0) {
                Write-Verbose -Message 'NodeJs successfully installed.'
            }
            else {
                Write-Warning -Message 'NodeJs install failed.'
            }
        }
    }
    elseif ($IsMacOS) {
        #TODO: MacOS install
    }
}
#endregion


#region Install-Atom
function Install-Atom {
    param
    (
        [string]$AtomUri
    )
    
    #TODO: Atom install
}

#endregion


#region Invoke-WebFileDownload
function Invoke-WebFileDownload {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true,
                   Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$URI,
        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true,
                   Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]$Path
    )
    
    begin {
        $WebClient = New-Object -TypeName System.Net.WebClient
    }
    process {
        Write-Verbose -Message "Downloading file from $URI to path: $Path"
        
        try {
            $WebClient.DownloadFile($URI, $Path)
        }
        catch {
            Write-Error -ErrorRecord $Error[0]
        }
    }
    end {
        Remove-Variable -Name WebClient
    }
}
#endregion


#region Install-Msi
function Install-Msi {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true,
                   Position = 0)]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [ValidateNotNullOrEmpty()]
        [string]$Path,
        [Parameter(Position = 1)]
        [string]$ArgumentList
    )
    
    try {
        Start-Process -FilePath msiexec -ArgumentList "/i $Path /qn /norestart" -NoNewWindow -Wait
    }
    catch {
        Write-Error -ErrorRecord $Error[0]
    }
}
#endregion


Main