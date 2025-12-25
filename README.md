# Cursor Runner & Get HDID (Windows + WSL Ubuntu)

Tool hỗ trợ chạy **Cursor Runner** và **Get HDID** trên Windows thông qua **WSL Ubuntu**.
Thiết kế cho user phổ thông: chỉ cần **double-click file `.bat` hoặc `.exe`** confirm UAC là chạy.

---

## 📋 Yêu cầu hệ thống (BẮT BUỘC)

- Windows **10 / 11** (64-bit)
- **WSL 2**
- **Ubuntu chạy trong WSL** (Ubuntu 22.04 / 24.04)
- Kết nối Internet (để cài Cursor CLI)

❌ **KHÔNG hỗ trợ**

- Ubuntu Desktop cài bằng USB / ISO
- VirtualBox / VMware
- Linux distro khác Ubuntu

---

## 📁 Cấu trúc thư mục (QUAN TRỌNG)

```
repo runner/
│
├─ cai dat ubuntu/                 # Tool cài Ubuntu WSL
│  ├─ launcher.exe                 # (Khuyên dùng) GUI 1-click
│  ├─ Ubuntu-WSL-Installer.bat     # Launcher batch
│  └─ Ubuntu-WSL-Installer.ps1     # Script PowerShell
│
├─ get hdid/
│  ├─ get-hdid                     # Binary Linux
│  ├─ boot-get-hdid.ps1
│  └─ get-hdid-launcher.bat
│
├─ cursor-runner                   # Binary Linux
├─ boot-runner.ps1
├─ cursor-runner-launcher.bat
│
├─ .gitignore
└─ README.md
```

⚠️ **Không đổi tên file / thư mục**.

---

## 🐧 BƯỚC 1: CÀI UBUNTU TRONG WSL (BẮT BUỘC)

### Cách 1: GUI (DỄ NHẤT – KHUYÊN DÙNG)

1. Mở thư mục:
   ```
   repo runner/cai dat ubuntu
   ```
2. Double-click **launcher.exe**
3. Chọn **Install Ubuntu (Internet)**
4. Chờ tool chạy xong
5. Restart Windows nếu được yêu cầu

Sau đó:

- Mở **Ubuntu** từ Start Menu
- Tạo **username + password**

---

### Cách 2: Command line

```powershell
wsl --install -d Ubuntu
```

Restart nếu được yêu cầu → mở Ubuntu → tạo user.

---

### Kiểm tra Ubuntu

```powershell
wsl -l -v
```

Kết quả đúng:

```
Ubuntu    Running    2
```

---

## 🧩 BƯỚC 2: CÀI CURSOR CLI

Trong Ubuntu:

```bash
curl https://cursor.com/install -fsS | bash
cursor-agent --version
```

---

## 🔐 BƯỚC 3: ĐĂNG NHẬP CURSOR

```bash
cursor-login
cursor-agent status
```

---

## 🆔 BƯỚC 4: LẤY HDID

1. Mở:
   ```
   repo runner/get hdid
   ```
2. Double-click **get-hdid-launcher.bat**
3. Copy **HDID**
4. Gửi HDID cho người cung cấp để nhận `license.json`

---

## ▶️ BƯỚC 5: CHẠY CURSOR RUNNER

1. Đặt `license.json` **cùng thư mục với `cursor-runner`**
2. Mở thư mục gốc `repo runner`
3. Double-click **cursor-runner-launcher.bat**

---

## ⚠️ LỖI THƯỜNG GẶP

### No WSL distro found

→ Chưa cài Ubuntu hoặc chưa mở Ubuntu lần đầu

### Tool mở rồi tắt

→ Ubuntu chưa setup user hoặc WSL chưa là version 2

### Permission denied

```bash
chmod +x cursor-runner
chmod +x get-hdid
```

---

## 📝 LƯU Ý

- Luôn chạy **get-hdid trước cursor-runner**
- Không đặt repo trong OneDrive
- Khuyên dùng Windows Terminal

---

## ✅ QUICK START

1. Chạy `launcher.exe`
2. Mở Ubuntu, tạo user
3. Cài & login Cursor CLI
4. Chạy get-hdid
5. Đặt license.json
6. Chạy cursor-runner
