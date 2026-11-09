# 🏛️ HƯỚNG DẪN KHỞI CHẠY & KIỂM THỬ HỆ THỐNG VIETLENS (BE + AI + FE)

Tài liệu này tổng hợp toàn bộ các lệnh và kịch bản kiểm thử cho cả 3 thành phần chính của hệ thống VietLens:
1. **`VLensBE`**: Spring Boot Backend (Quản lý CSDL Supabase, API di sản, API lịch sử trò chuyện, xác thực Supabase JWT) - Cổng `8080`.
2. **`VLensModel`**: FastAPI AI Agent (LangGraph + Vision Model Qwen2.5-VL LoRA / Mock) - Cổng `8000` & `8082`.
3. **`VLensFE`**: React Native Expo App (Giao diện Mobile, Slide Bar lịch sử chat, Bản đồ Vector 3D, Camera Scan, AI Chat) - Cổng `8081`.

---

## 📌 Bảng Phân Bổ Cổng & Địa Chỉ Mạng (Local Network)

| Dịch vụ | Thư mục | Cổng | URL Truy cập Local / LAN |
| :--- | :--- | :---: | :--- |
| **Spring Boot Backend** | `c:\Project_DV\Viet_Lens\VLensBE\JBE` | `8080` | `http://localhost:8080` hoặc `http://172.16.0.255:8080` |
| **AI Model Agent** | `c:\Project_DV\Viet_Lens\VLensModel` | `8000` | `http://localhost:8000` hoặc `http://172.16.0.255:8000` |
| **Mock Vision Server** | `c:\Project_DV\Viet_Lens\VLensModel` | `8082` | `http://127.0.0.1:8082` |
| **Colab Vision GPU** | `colab_vision_server.ipynb` | Ngrok | `https://xxxx.ngrok-free.dev` (hoặc `.app`) |
| **Expo Metro Bundler** | `c:\Project_DV\Viet_Lens\VLensFE` | `8081` | `exp://172.16.0.255:8081` |

> [!NOTE]
> Địa chỉ IP LAN máy tính của bạn hiện tại là `172.16.0.255`. Nếu bạn đổi mạng Wi-Fi khác, hãy kiểm tra lại bằng lệnh `ipconfig` trong Command Prompt và cập nhật biến `EXPO_PUBLIC_API_URL` cùng `EXPO_PUBLIC_AI_API_URL` trong file [VLensFE/.env](file:///c:/Project_DV/Viet_Lens/VLensFE/.env).

---

## 🚀 Phần 1: Các Lệnh Khởi Động Từng Khối

Mở **3 cửa sổ Terminal (PowerShell / Command Prompt)** riêng biệt để chạy song song 3 khối:

### Terminal 1: Khởi động Backend Spring Boot (`VLensBE`)
Chạy lệnh trực tiếp hoặc nhấp đúp file `.bat`:

```powershell
# Cách 1: Dùng script tạo sẵn (Khuyên dùng)
cd c:\Project_DV\Viet_Lens\VLensBE\JBE
.\run_backend.bat

# Hoặc:
.\run_be.bat

# Cách 2: Chạy trực tiếp qua Maven Wrapper
cd c:\Project_DV\Viet_Lens\VLensBE\JBE
.\mvnw.cmd spring-boot:run
```
*Dấu hiệu thành công:* Terminal xuất hiện dòng `Tomcat started on port 8080 (http)` và `Started BeApplication in ... seconds`.

---

### Terminal 2: Khởi động AI Microservice (`VLensModel`)

Tùy vào mục đích thử nghiệm, bạn chọn **1 trong 2 chế độ**:

#### Chế độ A: Kiểm thử Nhanh với Mock Vision (Không cần GPU, máy mát)
Chạy script tự động bật song song cả cổng `8082` (Mock) và cổng `8000` (FastAPI Agent):
```powershell
cd c:\Project_DV\Viet_Lens\VLensModel
.\run_all_ai_local.bat
```
*(Hoặc mở 2 tab chạy riêng `.\run_mock.bat` và `.\run_model.bat`)*

#### Chế độ B: Kiểm thử Thực tế với GPU Google Colab (Qwen2.5-VL LoRA)
1. Mở file [colab_vision_server.ipynb](file:///c:/Project_DV/Viet_Lens/VLensModel/colab_vision_server.ipynb) trên [Google Colab](https://colab.research.google.com/), chọn **Runtime -> T4 GPU** và bấm **Run All** để lấy đường link Ngrok (ví dụ: `https://divinity-dainty-handcraft.ngrok-free.dev`).
2. Cập nhật URL vào hệ thống và khởi động `VLensModel`:
```powershell
cd c:\Project_DV\Viet_Lens\VLensModel

# Cập nhật link Colab Ngrok vào file .env
.\set_vision_url.bat https://divinity-dainty-handcraft.ngrok-free.dev

# Khởi động AI Agent cổng 8000
.\run_model.bat
```
*Dấu hiệu thành công:* Terminal xuất hiện dòng `Application startup complete.` và `Uvicorn running on http://0.0.0.0:8000`.

---

### Terminal 3: Khởi động Ứng dụng Mobile (`VLensFE`)
```powershell
cd c:\Project_DV\Viet_Lens\VLensFE

# Khởi động Expo Metro Bundler (xóa cache sạch sẽ)
npx expo start -c

# Hoặc:
npm start
```
*Dấu hiệu thành công:* Terminal hiển thị mã **QR Code**. Bạn mở ứng dụng **Expo Go** trên điện thoại (kết nối chung mạng Wi-Fi với máy tính) và quét mã QR để mở app.

---

## 🔍 Phần 2: Lệnh Kiểm Tra Nhanh Tình Trạng Hệ Thống (Health Check CLI)

Trước khi cầm điện thoại lên test, bạn có thể chạy các lệnh sau trên PowerShell / Command Prompt để xác nhận các cổng và API đã thông suốt:

### 1. Kiểm tra 3 Cổng Mạng Có Đang Lắng Nghe (Listening)
```powershell
netstat -ano | findstr "8080 8000 8082"
```

### 2. Kiểm tra API Backend Spring Boot (Lấy danh sách di sản)
```powershell
curl.exe -s http://127.0.0.1:8080/api/heritage/all
```

### 3. Kiểm tra API AI Agent (Cổng 8000)
```powershell
curl.exe -s http://127.0.0.1:8000/
# Kết quả kỳ vọng: {"status":"running","message":"Multimodal Travel Agent API is active."}
```

### 4. Kiểm tra Endpoint Nhận Diện JSON thuần của AI
```powershell
curl.exe -X POST http://127.0.0.1:8000/process-json -H "Content-Type: application/json" -d "{\"prompt\": \"Giới thiệu Cầu Rồng Đà Nẵng ngắn gọn\", \"image_base64\": null}"
```

---

## 📱 Phần 3: Kịch Bản Kiểm Thử Trực Tiếp Trên Điện Thoại

### Kịch bản 1 (MỚI): Lịch Sử Trò Chuyện & Slide Bar (`ChatHistoryDrawer`)
1. Mở app trên điện thoại -> Vào tab **Cố vấn AI** (`ChatScreen`).
2. Gửi một tin nhắn bất kỳ (ví dụ: *"Kể cho tôi nghe về Cầu Rồng Đà Nẵng"* hoặc gửi một ảnh di tích).
3. Chờ VietLens AI trả lời xong.
4. **Mở Slide Bar Lịch sử:**
   - Bấm vào biểu tượng **≡ (Menu)** ở góc trên bên trái màn hình.
   - **Kỳ vọng:** Slide Bar trượt mượt mà từ cạnh trái ra chiếm 82% màn hình, hiển thị phiên trò chuyện mới với tiêu đề về di tích/câu hỏi và thời gian `"Vừa xong"`.
5. **Tạo cuộc trò chuyện mới:**
   - Bấm nút **+ Cuộc trò chuyện mới** trên Slide Bar.
   - **Kỳ vọng:** Slide bar đóng lại, màn hình chat quay về trạng thái chào đón ban đầu.
6. **Khôi phục lịch sử cũ:**
   - Mở lại Slide Bar -> Nhấn vào cuộc trò chuyện Cầu Rồng trước đó.
   - **Kỳ vọng:** Toàn bộ tin nhắn câu hỏi và câu trả lời cũ được tải lại đầy đủ từ Backend JBE / Supabase.
7. **Xóa phiên trò chuyện:**
   - Bấm vào icon **Thùng rác** bên cạnh phiên chat -> Hộp thoại xác nhận xuất hiện -> Bấm **Xóa**.
   - **Kỳ vọng:** Phiên trò chuyện biến mất khỏi Slide Bar và màn hình làm mới an toàn.
8. **Chế độ Khách (Guest Fallback):**
   - Nếu bạn chưa đăng nhập tài khoản, tính năng vẫn lưu lịch sử vào bộ nhớ cục bộ `AsyncStorage`, kiểm tra mượt mà mà không gặp bất kỳ lỗi 401 Unauthorized nào.

---

### Kịch bản 2: AI Chat nhận diện ảnh + Nút "Xem vị trí trên Bản đồ" (Grounding)
1. Mở tab **Cố vấn AI** (`ChatScreen`).
2. Bấm vào icon **Thư viện ảnh** hoặc **Máy ảnh**, chọn ảnh một di tích (ví dụ: *Cầu Rồng* hoặc *Ngũ Hành Sơn*) -> Bấm **Gửi**.
3. **Kỳ vọng:**
   - AI phản hồi tên di sản, độ tin cậy và bài thuyết minh kiến trúc/lịch sử.
   - Dưới bong bóng chat xuất hiện thẻ màu đỏ **"Xem vị trí trên Bản đồ"**.
   - Bấm vào thẻ -> App tự động chuyển sang tab **Bản đồ** (`MapScreen`) và kích hoạt hiệu ứng camera bay 3D (`flyTo`) đến đúng tọa độ GPS của di sản.

---

### Kịch bản 3: Quét Di Sản qua Camera (`CameraScanScreen`)
1. Chuyển sang tab **Quét Di sản** (Icon Camera giữa thanh điều hướng).
2. Hướng máy ảnh chụp hoặc chọn ảnh di sản từ thư viện.
3. **Kỳ vọng:**
   - Log terminal `VLensModel` cổng `8000` nhảy dòng: `POST /process-json HTTP/1.1 200 OK`.
   - Bảng thông tin (Bottom Sheet) bật lên hiển thị tên di sản, địa chỉ, niên đại và độ tin cậy.
   - Có nút điều hướng trực tiếp sang trò chuyện chuyên sâu hoặc mở bản đồ.

---

### Kịch bản 4: Hỏi đáp nối tiếp theo ngữ cảnh di sản (Contextual Follow-up)
1. Sau khi nhận diện ảnh xong ở `ChatScreen`, thanh tiêu đề hiển thị `Khám phá: <Tên di sản>`.
2. Không cần gửi lại ảnh, chỉ cần gõ câu hỏi: *"Sự tích gắn liền với nơi này là gì?"* rồi bấm **Gửi**.
3. **Kỳ vọng:** AI trả lời đúng lịch sử và truyền thuyết của di sản đó mà không bị mất ngữ cảnh.

---

### Kịch bản 5: Kiểm thử Đa ngôn ngữ Tiếng Nhật ('ja') & Chuyển đổi 3 Ngôn ngữ (VI - EN - JA)
1. **Nạp dữ liệu Seeding vào Supabase**:
   - Mở **Supabase Dashboard** -> Vào **SQL Editor**.
   - Mở và copy toàn bộ nội dung file [supabase_seed_japanese_translations.sql](file:///c:/Project_DV/Viet_Lens/VLensBE/database/supabase_seed_japanese_translations.sql) -> Dán vào SQL Editor và nhấn **Run**.
   - **Kỳ vọng kết quả đối chiếu:**
     * `vi`: 46 bản ghi.
     * `en`: 46 bản ghi (đã bù 4 bản dịch tiếng Anh còn thiếu).
     * `ja`: 46 bản ghi (100% di sản đã có bản dịch tiếng Nhật).
2. **Kiểm thử trên Mobile App (`VLensFE`)**:
   - Khởi động lại JBE (`run_backend.bat`) và VLensFE (`npm start` hoặc `run_fe.bat`).
   - Mở màn hình **Tài khoản (Profile)** -> Chạm vào mục **Ngôn ngữ** để chuyển sang **`🇯🇵 日本語`** (hoặc chuyển bằng nút `🇯🇵 JA` trên thanh chuyển đổi).
   - **Kỳ vọng:**
     * Giao diện toàn app chuyển sang tiếng Nhật (Thanh menu: *探す, AIカメラ, 地図, AIガイド, マイページ*).
     * Bấm vào bất kỳ di sản nào (ví dụ *Cầu Rồng* -> *ドラゴン橋*, *Cầu Quay Sông Hàn* -> *ハン川旋回橋*, *Phố cổ Hội An* -> *ホイアン旧市街*): Tên, phân loại, địa chỉ và bài giới thiệu hiển thị hoàn toàn bằng tiếng Nhật chuẩn xác.
     * Bấm nút **AI Audio Guide**: Nghe thuyết minh trực tiếp bằng giọng đọc tiếng Nhật (`ja-JP`).
     * Vào tab **AIガイド (AI Chat)** và đặt câu hỏi bằng tiếng Nhật: Trợ lý AI VietLens chào và giải đáp bằng tiếng Nhật trang nhã (敬語).

---

## 🛠️ Phần 4: Bảng Tra Cứu Xử Lý Lỗi Thường Gặp (Troubleshooting)

| Triệu chứng lỗi | Nguyên nhân | Cách khắc phục |
| :--- | :--- | :--- |
| **`WARN [ChatScreen] VLensModel error: Network request failed`** | Điện thoại không kết nối được IP máy tính hoặc cổng `8000` chưa bật. | 1. Đảm bảo điện thoại và laptop cùng bắt chung 1 mạng Wi-Fi.<br>2. Kiểm tra cổng `8000` đã chạy bằng `run_model.bat`.<br>3. Kiểm tra xem tường lửa Windows (Firewall) có chặn cổng `8000` hay không. |
| **`FATAL: (ENOIDENTIFIER) no tenant identifier provided` (Spring Boot)** | Biến môi trường kết nối Supabase bị thiếu. | Chạy qua file `VLensBE\JBE\run_backend.bat` (đã tích hợp tự động đọc file `.env`). |
| **`WARN [ChatScreen] Không kết nối được JBE, fallback local`** | Backend Spring Boot (cổng `8080`) chưa được khởi chạy hoặc IP LAN bị thay đổi. | 1. Chạy `run_backend.bat` ở Terminal 1.<br>2. Kiểm tra `EXPO_PUBLIC_API_URL` trong file `.env` của `VLensFE` đã đúng IP LAN máy host chưa. |
| **AI báo: "Không thể kết nối Vision Server (Ngrok might be down)"** | Cổng `8082` (Mock) hoặc Colab Ngrok đang tắt. | Nếu test máy: chạy `run_mock.bat`.<br>Nếu test Colab: kiểm tra lại link Ngrok và chạy `set_vision_url.bat <link>`. |
| **Bản đồ Google Map không load / màn hình xám** | API Key Google Maps chưa kích hoạt hoặc thiết bị thiếu Google Play Services. | Kiểm tra `EXPO_PUBLIC_MAPS_API_KEY` trong `VLensFE/.env` và đảm bảo máy có kết nối Internet. |
| **Cổng bị chiếm dụng (`Port already in use`)** | Phiên bản cũ vẫn đang chạy ngầm trên cổng `8080` hoặc `8000`. | Mở PowerShell và chạy lệnh tìm & tắt tiến trình:<br>`Stop-Process -Id (Get-NetTCPConnection -LocalPort 8080).OwningProcess -Force` (thay `8080` bằng cổng bị kẹt). |
