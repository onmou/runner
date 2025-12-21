# User config
$Distro  = "Ubuntu"
$ExeName = "cursor-runner"

# Đặt .ps1 cạnh file exe => lấy thư mục hiện tại của script
$WinDir = (Resolve-Path -LiteralPath $PSScriptRoot).Path

# (Tuỳ chọn) check file exe có tồn tại cạnh script không
$ExeWinPath = Join-Path $WinDir $ExeName
if (-not (Test-Path -LiteralPath $ExeWinPath)) {
  throw "Không tìm thấy '$ExeName' cạnh script: $ExeWinPath"
}

# 1) Get installed distros (quiet list)
$distros = @(wsl.exe -l -q 2>$null | ForEach-Object { $_.Trim() } | Where-Object { $_ })

if (-not $distros -or $distros.Count -eq 0) {
  throw "No WSL distro found. Please install a WSL distro first."
}

# 2) Validate requested distro; fallback nếu cần
if ($distros -notcontains $Distro) {
  $ubuntu = $distros | Where-Object { $_ -like "Ubuntu*" } | Select-Object -First 1
  $Distro = if ($ubuntu) { $ubuntu } else { $distros[0] }
}

# 3) Convert Windows path -> WSL path (theo distro đã chọn)
$WinDirBash = $WinDir -replace "'", "'\''"
$LinuxDir = (wsl.exe -d $Distro -e bash -lc "wslpath -a '$WinDirBash'" 2>$null).Trim()

if (-not $LinuxDir) {
  throw "Failed to convert Windows path to WSL path. WinDir='$WinDir'"
}

# 4) Build bash command (cd -> chmod +x -> run)
$BashCmd = "cd '$LinuxDir' && chmod +x './$ExeName' 2>/dev/null && './$ExeName'"

# 5) Run in Windows Terminal
Start-Process "wt.exe" -ArgumentList @(
  "wsl.exe -d $Distro -e bash -lc `"$BashCmd`""
)
