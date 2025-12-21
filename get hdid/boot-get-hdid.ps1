# ==== Config ====
$PreferDistro = "Ubuntu"
$ExeName      = "get-hdid"

# Folder chứa script (đặt cạnh exe)
$WinDir = (Resolve-Path -LiteralPath $PSScriptRoot).Path

# Check file exe có tồn tại không
$ExeWinPath = Join-Path $WinDir $ExeName
if (-not (Test-Path -LiteralPath $ExeWinPath)) {
  throw "Không thấy '$ExeName' cạnh file .ps1: $ExeWinPath"
}

# List distros
$distros = @(wsl.exe -l -q 2>$null | ForEach-Object { $_.Trim() } | Where-Object { $_ })
if (-not $distros) { throw "No WSL distro found." }

# Chọn distro: đúng tên -> Ubuntu* -> fallback distro đầu
if ($distros -contains $PreferDistro) {
  $Distro = $PreferDistro
} else {
  $ubuntu = $distros | Where-Object { $_ -like "Ubuntu*" } | Select-Object -First 1
  $Distro = if ($ubuntu) { $ubuntu } else { $distros[0] }
}

# Convert Windows path -> /mnt/<drive>/...
if ($WinDir -notmatch '^(?<drv>[A-Za-z]):\\(?<rest>.*)$') {
  throw "Chỉ support path kiểu C:\... . WinDir='$WinDir'"
}
$drive    = $Matches.drv.ToLower()
$rest     = $Matches.rest.Replace('\','/')
$LinuxDir = if ($rest) { "/mnt/$drive/$rest" } else { "/mnt/$drive" }

# Escape ' cho bash
$LinuxDirBash = $LinuxDir -replace "'", "'\''"

# Bash cmd: KHÔNG dùng dấu ; (tránh wt hiểu nhầm), chạy xong giữ tab bằng exec bash -i
$BashCmd = "cd '$LinuxDirBash' && chmod +x './$ExeName' 2>/dev/null && './$ExeName' && echo && echo 'Done. Type exit to close.' && exec bash -i || exec bash -i"

# Mở tab mới trong Windows Terminal và chạy
& wt.exe new-tab -- wsl.exe -d $Distro -e bash -lc $BashCmd
