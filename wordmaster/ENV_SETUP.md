# 🔐 Environment Variables Setup

## ✅ Đã thiết lập thành công!

Project WordMaster giờ đây sử dụng file `.env` để quản lý cấu hình một cách an toàn và linh hoạt.

## 📁 Files đã tạo:

- **`.env`** - File cấu hình thực tế (đã được thêm vào .gitignore)
- **`.env.example`** - Template để chia sẻ cấu hình mẫu
- **Updated `mysql_helper.dart`** - Sử dụng dotenv thay vì hardcode
- **Updated `main.dart`** - Load .env file khi khởi động
- **Updated `constants.dart`** - Sử dụng environment variables

## 🔧 Cấu hình hiện tại:

### Database Configuration
```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=Thanhtoan6924  # Đã lấy từ file cũ
DB_NAME=wordmasterapp
```

### App Configuration
```env
APP_ENV=development
DEBUG_MODE=true
DEFAULT_LANGUAGE=en-US
MAX_SESSION_SIZE=50
DEFAULT_DIFFICULTY=Medium
```

### API Configuration (cho tương lai)
```env
API_BASE_URL=https://api.wordmaster.com
API_KEY=your_api_key_here
```

## 🚀 Cách sử dụng:

### 1. **Development Environment**
- File `.env` hiện tại đã sẵn sàng cho development
- Password MySQL đã được lấy từ cấu hình cũ

### 2. **Production Environment** 
```bash
# Tạo .env cho production
cp .env.example .env.production

# Cập nhật với thông tin production
DB_HOST=your_production_host
DB_PASSWORD=your_secure_production_password
APP_ENV=production
DEBUG_MODE=false
```

### 3. **Team Development**
```bash
# Mỗi developer tạo .env của riêng mình
cp .env.example .env

# Cập nhật với MySQL local của mình
DB_PASSWORD=my_local_mysql_password
```

## 🔒 Bảo mật:

### ✅ Đã làm:
- Thêm `.env` vào `.gitignore` 
- Tạo `.env.example` để chia sẻ template
- Sử dụng `flutter_dotenv` package

### ⚠️ Lưu ý quan trọng:
- **KHÔNG BAO GIỜ** commit file `.env` thực tế
- **CHỈ** commit file `.env.example`
- Đổi password production khác với development

## 📝 Cách thêm config mới:

### 1. Thêm vào `.env`:
```env
NEW_FEATURE_ENABLED=true
CACHE_TIMEOUT=3600
```

### 2. Sử dụng trong code:
```dart
// Trong constants.dart
static bool get newFeatureEnabled => 
    dotenv.env['NEW_FEATURE_ENABLED']?.toLowerCase() == 'true';

static int get cacheTimeout => 
    int.tryParse(dotenv.env['CACHE_TIMEOUT'] ?? '3600') ?? 3600;
```

### 3. Cập nhật `.env.example`:
```env
NEW_FEATURE_ENABLED=false
CACHE_TIMEOUT=3600
```

## 🎯 Lợi ích:

### ✅ **Bảo mật tốt hơn**
- Credentials không bị hardcode
- Mỗi environment có config riêng
- Không risk leak password qua git

### ✅ **Linh hoạt**
- Dễ dàng thay đổi config không cần rebuild
- Support multiple environments
- Team members có thể dùng config khác nhau

### ✅ **Maintainable**
- Config tập trung tại một nơi
- Dễ dàng add/remove settings
- Clear separation between code và config

## 🔄 Migration từ hardcode:

### Before:
```dart
static const String _host = 'localhost';
static const String _password = 'Thanhtoan6924';
```

### After:
```dart
String get _host => dotenv.env['DB_HOST'] ?? 'localhost';
String get _password => dotenv.env['DB_PASSWORD'] ?? '';
```

Project đã sẵn sàng với environment variables! 🎉