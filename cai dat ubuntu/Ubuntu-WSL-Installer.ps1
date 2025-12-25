# Ubuntu-WSL-Installer.ps1
$ErrorActionPreference = "Stop"

function Ensure-Admin {
    if (-not ([Security.Principal.WindowsPrincipal] `
        [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

        Start-Process powershell `
          "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" `
          -Verb RunAs
        exit
    }
}

Ensure-Admin
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ---------------- GUI ----------------
$form = New-Object Windows.Forms.Form
$form.Text = "Ubuntu WSL Installer"
$form.Size = "520,360"
$form.StartPosition = "CenterScreen"
$form.MaximizeBox = $false

$status = New-Object Windows.Forms.Label
$status.Location = "20,20"
$status.Size = "460,40"
$status.Text = "Chọn hành động:"
$form.Controls.Add($status)

$progress = New-Object Windows.Forms.ProgressBar
$progress.Location = "20,70"
$progress.Size = "460,20"
$progress.Style = "Continuous"
$form.Controls.Add($progress)

# Buttons
$btnWeb     = New-Object Windows.Forms.Button
$btnOffline = New-Object Windows.Forms.Button
$btnRepair  = New-Object Windows.Forms.Button
$btnRemove  = New-Object Windows.Forms.Button

$btnWeb.Text     = "🌐 Cài Ubuntu (Internet)"
$btnOffline.Text = "📂 Cài Ubuntu (Offline)"
$btnRepair.Text  = "🛠 Repair WSL"
$btnRemove.Text  = "🗑 Gỡ Ubuntu"

$btnWeb.Location     = "20,110"
$btnOffline.Location = "260,110"
$btnRepair.Location  = "20,160"
$btnRemove.Location  = "260,160"

$btnWeb.Size     = "220,40"
$btnOffline.Size = "220,40"
$btnRepair.Size  = "220,40"
$btnRemove.Size  = "220,40"

$form.Controls.AddRange(@($btnWeb,$btnOffline,$btnRepair,$btnRemove))

# ---------------- CORE ----------------
function Set-Progress($v,$t){ $progress.Value=$v; $status.Text=$t; $form.Refresh() }

function Enable-WSL {
    Set-Progress 10 "Bật WSL..."
    dism /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart | Out-Null
    Set-Progress 40 "Bật Virtual Machine Platform..."
    dism /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart | Out-Null
    Set-Progress 70 "Đặt WSL2 mặc định..."
    wsl --set-default-version 2 | Out-Null
}

function Need-Reboot {
    Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending"
}

function Install-Web {
    Enable-WSL
    Set-Progress 85 "Cài Ubuntu từ Internet..."
    wsl --install -d Ubuntu
    Set-Progress 100 "Hoàn tất."
    if (Need-Reboot) {
        [Windows.Forms.MessageBox]::Show("CẦN REBOOT để hoàn tất WSL.","Reboot Required")
    }
}

function Install-Offline {
    $dlg = New-Object Windows.Forms.OpenFileDialog
    $dlg.Title = "Chọn file Ubuntu WSL"
    $dlg.InitialDirectory = "$env:USERPROFILE\Downloads"
    if ($dlg.ShowDialog() -ne "OK") { return }

    Enable-WSL
    $file = $dlg.FileName
    $name = "Ubuntu-" + ([IO.Path]::GetFileNameWithoutExtension($file))
    $dir  = "C:\WSL\$name"

    Set-Progress 85 "Import Ubuntu..."
    mkdir $dir -Force | Out-Null
    wsl --import $name $dir $file

    Set-Progress 100 "Mở Ubuntu..."
    wsl -d $name
}

function Repair-WSL {
    Set-Progress 20 "Shutdown WSL..."
    wsl --shutdown
    Set-Progress 50 "Reset kernel..."
    wsl --update
    Set-Progress 100 "Repair xong."
}

function Remove-Ubuntu {
    $list = wsl -l -q
    if (-not $list) {
        [Windows.Forms.MessageBox]::Show("Không có distro nào.","Info")
        return
    }

    $choice = [Windows.Forms.MessageBox]::Show(
        "Gỡ distro: `n$list","Confirm",
        [Windows.Forms.MessageBoxButtons]::YesNo
    )

    if ($choice -eq "Yes") {
        foreach ($d in $list) {
            wsl --unregister $d
        }
        Set-Progress 100 "Đã gỡ xong."
    }
}

# ---------------- EVENTS ----------------
$btnWeb.Add_Click({ Install-Web })
$btnOffline.Add_Click({ Install-Offline })
$btnRepair.Add_Click({ Repair-WSL })
$btnRemove.Add_Click({ Remove-Ubuntu })

$form.ShowDialog()
