# Cursor Runner & Get HDID

Tool hỗ trợ chạy Cursor và lấy HDID trên Windows thông qua WSL Ubuntu.

## 📋 Yêu cầu

- **Windows 10/11** (có WSL)
- **Ubuntu** (bắt buộc - cài thủ công)
- **Windows Terminal** (khuyến nghị)

## 🚀 Cài đặt

### Bước 1: Cài đặt Ubuntu (Bắt buộc)

Bạn **PHẢI** cài Ubuntu trước khi sử dụng tool này. Có 2 cách:

#### Cách 1: Cài Ubuntu trong WSL (Khuyến nghị)

1. **Mở Microsoft Store**
2. **Tìm kiếm "Ubuntu"**
3. **Click "Install"** (chọn phiên bản Ubuntu mới nhất, ví dụ: Ubuntu 24.04 LTS)
4. **Sau khi cài xong**, mở Ubuntu lần đầu để tạo username và password

**Lưu ý:** Nếu chưa có WSL, Windows sẽ tự động cài WSL khi bạn cài Ubuntu từ Microsoft Store.

#### Cách 2: Cài Ubuntu Desktop trực tiếp

Nếu không thể cài Ubuntu trong WSL:

1. Truy cập: [https://ubuntu.com/download/desktop](https://ubuntu.com/download/desktop)
2. Tải file ISO Ubuntu Desktop
3. Tạo USB bootable với [balenaEtcher](https://www.balena.io/etcher/) hoặc công cụ tương tự
4. Boot từ USB và cài Ubuntu Desktop

### Bước 2: Cài đặt Cursor CLI trong Ubuntu

Sau khi đã có Ubuntu (WSL hoặc Desktop), mở terminal Ubuntu và chạy:

```bash
curl https://cursor.com/install -fsS | bash
```

**Tài liệu chính thức:** [Cursor CLI Documentation](https://cursor.com/docs/cli/overview)

### Bước 3: Đăng nhập Cursor CLI

Sau khi cài đặt xong, bạn cần đăng nhập:

```bash
cursor-login
```

Làm theo hướng dẫn trên màn hình để đăng nhập vào tài khoản Cursor của bạn.

### Bước 4: Kiểm tra trạng thái Cursor Agent

Sau khi đăng nhập, kiểm tra trạng thái:

```bash
cursor-agent status
```

Nếu thấy trạng thái hoạt động bình thường, bạn đã sẵn sàng sử dụng Cursor CLI:

```bash
# Chạy interactive session
cursor-agent

# Chạy với prompt cụ thể
cursor-agent "refactor the auth module to use JWT tokens"
```

## 📖 Cách sử dụng

### 1. Lấy HDID (Bước đầu tiên)

**Quan trọng:** Bạn **PHẢI** chạy `get-hdid` trước để có ID và liên hệ người bán.

1. Mở thư mục `get hdid`
2. Double-click vào **`get-hdid-launcher.bat`**
3. Chờ script chạy trong Windows Terminal
4. Lấy ID từ kết quả và liên hệ người bán

### 2. Chạy Cursor Runner

Sau khi đã có HDID và liên hệ người bán:

1. Đặt file `license.json` (nhận được từ người bán) cùng thư mục với file `cursor-runner`
2. Double-click vào **`cursor-runner-launcher.bat`** ở thư mục gốc
3. Script sẽ tự động:
   - Tìm Ubuntu trong WSL
   - Chuyển đổi đường dẫn Windows sang Linux
   - Chạy `cursor-runner` trong Ubuntu

## 📁 Cấu trúc thư mục

```
repo runner/
├── cursor-runner-launcher.bat        # Launcher cho cursor-runner
├── boot-runner.ps1                   # Script PowerShell chạy cursor-runner
├── cursor-runner                     # File thực thi cursor-runner (Linux)
│
└── get hdid/
    ├── get-hdid-launcher.bat         # Launcher cho get-hdid
    ├── boot-get-hdid.ps1             # Script PowerShell chạy get-hdid
    └── get-hdid                      # File thực thi get-hdid (Linux)
```

## ⚙️ Cách hoạt động

- Các file `.bat` là launcher chạy script PowerShell
- Script PowerShell sẽ:
  - Tìm Ubuntu trong WSL
  - Chuyển đổi đường dẫn Windows → Linux
  - Chạy file thực thi Linux trong Ubuntu
- File `cursor-runner` và `get-hdid` là các file binary Linux, cần chạy trong WSL Ubuntu

## 🔧 Xử lý lỗi

### Lỗi: "No WSL distro found"

- Đảm bảo bạn đã cài Ubuntu trong WSL (xem Bước 1 ở trên)
- Kiểm tra bằng cách chạy `wsl -l` trong Command Prompt

### Lỗi: "Không tìm thấy cursor-runner/get-hdid"

- Đảm bảo file `cursor-runner` hoặc `get-hdid` nằm cùng thư mục với file `.ps1` tương ứng

### Lỗi khi chạy trong Ubuntu

- Kiểm tra quyền thực thi: `chmod +x cursor-runner` hoặc `chmod +x get-hdid`
- Đảm bảo Ubuntu đã được setup đầy đủ (username/password)
- Kiểm tra Cursor CLI đã được cài: chạy `cursor-agent --version` trong Ubuntu

### Lỗi: Cursor CLI chưa được cài

Nếu gặp lỗi khi chạy `cursor-agent`, cài lại Cursor CLI:

```bash
# Trong Ubuntu terminal
curl https://cursor.com/install -fsS | bash
```

Sau đó kiểm tra lại:

```bash
cursor-agent --version
```

### Lỗi: Chưa đăng nhập Cursor CLI

Nếu `cursor-agent status` báo lỗi chưa đăng nhập, chạy:

```bash
cursor-login
```

Làm theo hướng dẫn trên màn hình để đăng nhập. Sau đó kiểm tra lại:

```bash
cursor-agent status
```

## 📝 Lưu ý

- Luôn chạy `get-hdid` trước khi chạy `cursor-runner`
- Cần có kết nối internet để cài đặt Cursor CLI
- Windows Terminal được khuyến nghị để có trải nghiệm tốt nhất
- File `license.json` phải đặt cùng thư mục với `cursor-runner`

## 📞 Hỗ trợ

Nếu gặp vấn đề, vui lòng kiểm tra:

1. Ubuntu đã được cài đặt và hoạt động (chạy `wsl` trong Command Prompt để test)
2. Cursor CLI đã được cài trong Ubuntu (chạy `cursor-agent --version`)
3. Đã đăng nhập Cursor CLI (chạy `cursor-login` và kiểm tra `cursor-agent status`)
4. File thực thi có quyền thực thi
5. File `license.json` đã được đặt đúng vị trí
