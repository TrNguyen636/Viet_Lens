# PROJECT DESCRIPTION (PJD) — VIETLENS
**Hệ Thống Ứng Dụng Khám Phá & Thuyết Minh Di Sản Văn Hóa Việt Nam (VietLens)**

---

## 1. GIỚI THIỆU TỔNG QUAN DỰ ÁN

- **Tên dự án:** VietLens (VietLens Heritage App)
- **Định vị sản phẩm:** Ứng dụng di động thông minh hỗ trợ nhận diện, khám phá, thuyết minh âm thanh và tương tác đa chiều về di sản văn hóa, lịch sử và danh lam thắng cảnh Việt Nam.
- **Mục tiêu sản phẩm:** Cung cấp giải pháp số hóa toàn diện giúp người dùng nhận diện di tích ngay tại thực địa qua ống kính camera, tương tác hỏi đáp chuyên sâu với trợ lý AI đa góc nhìn, nghe thuyết minh tự động (Audio Guide), tra cứu bản đồ tọa độ di sản và lưu giữ hành trình trải nghiệm thông qua hộ chiếu số hóa.

---

## 2. NGĂN XẾP CÔNG NGHỆ & KIẾN TRÚC HỆ THỐNG

- **Ứng dụng di động (Frontend):** React Native / Expo, tích hợp Expo Camera, Expo Speech (Text-to-Speech), Leaflet / OpenStreetMap Geo Engine, i18next (Đa ngôn ngữ VI/EN).
- **Hệ thống máy chủ dịch vụ (Backend API):** Java 17, Spring Boot 3.x RESTful APIs, Spring Security, Hibernate/JPA.
- **Trí tuệ nhân tạo (AI Engine):** Llama 3 qua Groq Cloud (API chuẩn OpenAI format), cơ chế RAG (Retrieval-Augmented Generation) kết hợp nạp ngữ cảnh dữ liệu di sản đã kiểm chứng vào prompt để phản hồi chính xác.
- **Cơ sở dữ liệu & Xác thực (Database & Cloud):** Supabase PostgreSQL, Row Level Security (RLS), tính toán khoảng cách địa lý (Haversine formula), Supabase Auth & JWT.

---

## 3. DANH SÁCH & MÔ TẢ CHI TIẾT TẤT CẢ CHỨC NĂNG CỦA HỆ THỐNG

### 3.1. Phân hệ Khởi động & Điều hướng (Onboarding & Navigation)
- **Màn hình giới thiệu (Splash & Onboarding):**
  - Trình diễn slide giới thiệu ngắn gọn các tính năng cốt lõi: Quét AI, Bản đồ tương tác, Thuyết minh âm thanh.
  - Xin cấp quyền hệ thống minh bạch: Quyền Camera (để quét nhận diện) và Quyền Vị trí GPS (để gợi ý di sản lân cận).
- **Thanh điều hướng chính (Bottom Tab Navigation):**
  - Gồm 5 tab truy cập nhanh: Trang chủ (Home), Quét di sản (Camera), Bản đồ (Map), Trò chuyện AI (Chat), Hồ sơ cá nhân (Profile).
  - Tự động ẩn thanh điều hướng khi bàn phím ảo xuất hiện để tối ưu không gian hiển thị.

### 3.2. Phân hệ Xác thực & Quản lý Tài khoản (Auth & User Management)
- **Đăng ký / Đăng nhập:**
  - Hỗ trợ đăng nhập bằng Email / Mật khẩu thông qua Supabase Auth.
  - Hỗ trợ chế độ duyệt ẩn danh (Khách / Guest Mode) để xem thông tin mà không bắt buộc tạo tài khoản ngay.
- **Đồng bộ hồ sơ (User Sync):**
  - Đồng bộ thông tin người dùng từ Supabase sang cơ sở dữ liệu backend Spring Boot.
  - Quản lý vai trò người dùng (USER, GUEST, ADMIN).
- **Quản lý phiên (Session Management):** Tự động duy trì trạng thái đăng nhập, làm mới token và đăng xuất an toàn.

### 3.3. Phân hệ Trang chủ & Khám phá Di sản (Home & Discovery)
- **Bộ lọc theo Danh mục di sản:**
  - *Kiến trúc & Cung đình:* Hoàng thành, cung điện, lăng tẩm, cổng thành cổ.
  - *Quân sự & Thành quách:* Pháo đài, chiến trường cổ, địa đạo, thành lũy.
  - *Tín ngưỡng & Tôn giáo:* Chùa chiền, đền miếu, thánh địa, tháp cổ Chăm-pa.
  - *Khảo cổ & Tiền sử:* Di chỉ khảo cổ, hang động cổ sinh, bảo vật quốc gia.
  - *Văn hóa & Đời sống:* Làng nghề truyền thống, phố cổ, bảo tàng nghệ thuật.
- **Bộ lọc theo Thời kỳ & Triều đại Lịch sử:**
  - Thời Văn Lang - Âu Lạc.
  - Thời Lý - Trần (TK XI - XIV).
  - Thời Hậu Lê (TK XV - XVIII).
  - Thời Nhà Nguyễn (TK XIX - XX).
  - Thời Cận - Hiện đại.
- **Tìm kiếm di sản theo thời gian thực (Live Search):**
  - Tích hợp cơ chế Debounce để tối ưu truy vấn.
  - Tìm kiếm toàn văn theo: Tên di sản, Tên tiếng Anh, Địa chỉ cụ thể, Tỉnh/Thành phố, Từ khóa lịch sử liên quan.
- **Gợi ý di sản lân cận (Nearby Heritage Recommendations):**
  - Tự động xác định vị trí GPS của người dùng.
  - Sử dụng công thức Haversine tính toán khoảng cách thực tế và liệt kê các di sản trong phạm vi bán kính từ 15km đến 50km.
- **Bộ sưu tập chuyên đề (Curated Heritage Collections):**
  - Danh sách gợi ý sẵn các chủ đề đặc sắc (Kiến trúc Triều Nguyễn, Thủy chiến Bạch Đằng, Văn minh Chăm-pa, Thiền phái Trúc Lâm).
- **Kéo để làm mới (Pull-to-Refresh):** Cập nhật dữ liệu di sản và hình ảnh mới nhất từ máy chủ.

### 3.4. Phân hệ Nhận diện Thị giác bằng AI (AI Camera Scanner)
- **Quét trực tiếp qua Camera:** Khung quét chuẩn tỷ lệ có hiệu ứng radar laser chuyển động, bắt nét công trình di tích hoặc hiện vật trước mặt.
- **Tải ảnh từ Bộ sưu tập (Gallery Import):** Cho phép chọn ảnh đã chụp sẵn trong máy để đưa vào phân tích.
- **Công cụ hỗ trợ ống kính:** Chuyển đổi camera trước/sau, bật/tắt đèn Flash khi quét ở điều kiện thiếu sáng.
- **Phân tích & Khớp dữ liệu di sản:**
  - Nhận diện đối tượng và trả về kết quả khớp với độ tin cậy cao.
  - Hiển thị pop-up kết quả tóm tắt: Tên di tích, hình ảnh đối chiếu, mô tả sơ lược và điểm đặc trưng kiến trúc.
  - Nút chuyển hướng nhanh: Xem chi tiết toàn bộ hồ sơ di sản hoặc mở ngay cuộc trò chuyện với Trợ lý AI về di tích vừa quét.

### 3.5. Phân hệ Chi tiết Di sản Văn hóa (Heritage Details Screen)
- **Thư viện hình ảnh & Thông tin hành chính:** Tên chính thức (Việt / Anh), hình ảnh chất lượng cao, tỉnh thành, địa chỉ chính xác, tọa độ bản đồ.
- **Tóm tắt tổng quan:** Giới thiệu ngắn gọn giá trị cốt lõi của di tích.
- **Tư liệu lịch sử đã kiểm chứng (Verified History):**
  - Nguồn tư liệu trích dẫn (UNESCO, Viện Khảo cổ học, Đại Việt Sử Ký Toàn Thư,...).
  - Năm khởi lập / Niên đại xây dựng.
  - Dữ liệu khai quật khảo cổ và các tầng văn hóa phát lộ.
  - Điểm nhấn kết cấu kiến trúc tiêu biểu.
- **Góc nhìn phân tích chuyên sâu (Significance Insights):**
  - Phân tích lớp nghĩa triết học, phong thủy và giá trị biểu tượng.
  - Điểm số cộng hưởng di sản (Resonance Score).
  - Gợi ý chi tiết các hiện vật/hạng mục không nên bỏ lỡ khi tham quan.
- **Nhân vật lịch sử gắn liền (Key Historical Figures):** Danh sách vua chúa, danh tướng, danh nhân văn hóa liên quan.
- **Thẻ định danh (Tags):** Các tag phân loại di sản (UNESCO, Di tích quốc gia đặc biệt,...).

### 3.6. Phân hệ Thuyết minh Giọng nói Tự động (Smart Audio Guide)
- **Chuyển văn bản thành giọng đọc (Text-to-Speech):** Tự động phát âm thuyết minh nội dung di sản bằng giọng đọc tự nhiên.
- **Điều khiển phát âm thanh:** Nút Bật / Tắt / Dừng thuyết minh tức thì.
- **Hỗ trợ đa ngôn ngữ phát âm:** Tự động phát bằng giọng tiếng Việt hoặc tiếng Anh theo thiết lập ngôn ngữ hiện tại của ứng dụng.
- **Trải nghiệm rảnh tay (Hands-free):** Giúp người dùng vừa di chuyển tham quan thực tế vừa lắng nghe câu chuyện mà không cần nhìn liên tục vào màn hình.

### 3.7. Phân hệ Trợ lý AI Hướng dẫn viên Đa nhân vật (Multi-Persona AI Chat)
Hệ thống tích hợp 4 Persona AI chuyên biệt, mỗi nhân vật mang phong cách đối thoại và miền kiến thức riêng:
1. **VietLens AI Guide (Trợ lý Di sản Tổng quan):**
   - *Vai trò:* Cung cấp thông tin tổng thể, giải đáp lịch sử chung, hoạt động 24/7.
2. **GS. Lê Văn Lan (Cố vấn Lịch sử Cổ trung đại):**
   - *Vai trò:* Giải thích chuyên sâu về niên đại, các triều đại phong kiến, chiến thuật quân sự và ý nghĩa các cuộc kháng chiến vệ quốc.
3. **KTS. Tô Đình Dũng (Chuyên gia Kiến trúc Cổ):**
   - *Vai trò:* Phân tích kết cấu đấu củng, chồng rường, điêu khắc sa thạch, kỹ thuật nung gạch, nghệ thuật khảm sành sứ, bố cục phong thủy.
4. **Mai Thảo (Thuyết minh viên Thực địa Cố Đô):**
   - *Vai trò:* Cung cấp thông tin tham quan thực tế, giá vé, thời điểm tham quan đẹp nhất, góc chụp ảnh đẹp, lưu ý trang phục và ẩm thực bản địa.

**Các tính năng tương tác trong khung chat:**
- Tự động nạp ngữ cảnh di sản hiện tại (Current Heritage Context) vào cuộc trò chuyện để AI trả lời đúng trọng tâm.
- Chuyển đổi linh hoạt giữa 4 nhân vật ngay trong phiên trò chuyện.
- Nút nghe câu trả lời của AI bằng giọng đọc (Audio Playback / TTS).
- Khung gợi ý câu hỏi nhanh (Quick Prompts) dựa theo đặc trưng của từng di tích.

### 3.8. Phân hệ Bản đồ Di sản Tương tác (Interactive Heritage Map)
- **Bản đồ không gian số (OpenStreetMap / Leaflet Engine):** Hiển thị trực quan toàn bộ bản đồ Việt Nam.
- **Ghim tọa độ thực (GPS Markers):** Hiển thị các điểm di sản theo tọa độ vĩ độ/kinh độ chính xác.
- **Bộ lọc & Thanh tìm kiếm trên bản đồ:** Tìm nhanh di sản theo tên hoặc tỉnh thành ngay trong chế độ bản đồ.
- **Thẻ xem trước địa điểm (Site Preview Card):** Nhấn vào từng điểm ghim để xem hình ảnh đại diện, khoảng cách, phân loại và địa chỉ.
- **Nút định vị & Tái định tâm (Recenter):** Tự động đưa tầm nhìn bản đồ về vị trí di sản gần nhất hoặc điểm đang chọn.
- **Tích hợp di sản chủ quyền biển đảo:** Định vị và dữ liệu đầy đủ về Quần đảo Hoàng Sa, Quần đảo Trường Sa, Nhà trưng bày Hoàng Sa.

### 3.9. Phân hệ Hộ chiếu Văn hóa & Trò chơi hóa (Cultural Passport & Gamification)
- **Dòng thời gian khám phá (Heritage Timeline):** Lưu trữ toàn bộ lịch sử các điểm di tích mà người dùng đã đánh dấu hoặc đã ghé thăm.
- **Bộ sưu tập Huy hiệu Tem Văn hóa (Stamps Collection):**
  - Mở khóa tem điện tử tương ứng khi hoàn thành các cột mốc khám phá:
    - *Kẻ Mộng Mơ Xứ Quảng:* Khám phá di sản miền Trung (Huế, Đà Nẵng, Hội An, Mỹ Sơn).
    - *Dấu Chân Thăng Long:* Khám phá tối thiểu 3 di sản ngàn năm lịch sử tại Hà Nội.
    - *Học Giả Cố Đô:* Hoàn thành tương tác hỏi đáp với Cố vấn AI về văn hóa cung đình.
    - *Chiến Binh Bạch Đằng:* Khám phá các chiến trường quân sự cổ.
    - *Sứ Giả Văn Hóa Việt:* Khám phá đủ 10 di sản trên toàn quốc.
- **Điểm số Văn hóa & Cấp bậc Danh hiệu:**
  - Tích lũy điểm văn hóa qua từng hoạt động lưu trữ và đánh giá di tích.
  - Phân cấp danh hiệu người dùng: Tài khoản Khách $\rightarrow$ Nhà Thám Hiểm Văn Hóa.

### 3.10. Phân hệ Đánh giá & Cộng đồng (Reviews & Ratings)
- **Đánh giá sao & Nhận xét:** Cho phép người dùng gửi đánh giá từ 1 đến 5 sao kèm bình luận thực tế về trải nghiệm tại di tích.
- **Thống kê tổng hợp:** Hiển thị điểm đánh giá trung bình và tổng số lượng đánh giá của từng điểm đến.
- **Lưu trữ di sản (Bookmark):** Đánh dấu lưu địa điểm vào mục yêu thích cá nhân với 1 chạm, hỗ trợ truy cập lại nhanh chóng.

### 3.11. Phân hệ Cài đặt & Đa ngôn ngữ (Settings & Localization)
- **Chuyển đổi ngôn ngữ tức thì (i18n):**
  - Hỗ trợ đầy đủ 2 ngôn ngữ: Tiếng Việt và Tiếng Anh.
  - Chuyển đổi toàn diện: Giao diện ứng dụng, nội dung mô tả di sản, cơ sở dữ liệu dịch thuật chuyên ngành và ngôn ngữ phản hồi của Trợ lý AI.
- **Tùy chỉnh giao diện:** Tùy chọn chế độ hiển thị Sáng / Tối (Light/Dark theme).
- **Thông tin liên hệ & Hỗ trợ:** Cung cấp thông tin phiên bản ứng dụng, điều khoản sử dụng và kênh phản hồi đóng góp ý kiến.

---

## 4. BẢNG TỔNG HỢP CÁC ĐIỂM DỮ LIỆU ĐẶC TẢ DI SẢN (DATA SCHEMA OVERVIEW)

Mỗi di sản trong hệ thống khi hoàn thành đều được số hóa với các trường dữ liệu chuẩn sau:

| Tên trường dữ liệu | Kiểu dữ liệu | Diễn giải chức năng |
|:---|:---|:---|
| `id` | UUID | Khóa chính định danh duy nhất của di sản |
| `name` | String | Tên chính thức của di tích / địa danh |
| `english_name` | String | Tên tiếng Anh chuẩn quốc tế |
| `province` | String | Tỉnh / Thành phố trực thuộc |
| `address` | String | Địa chỉ chi tiết thực địa |
| `latitude` / `longitude` | Double | Tọa độ địa lý GPS chính xác phục vụ bản đồ và tính khoảng cách |
| `category` | String | Lĩnh vực di sản (Kiến trúc, Quân sự, Tôn giáo, Khảo cổ, Văn hóa) |
| `era` / `dynasty` | String | Thời kỳ lịch sử / Triều đại khởi lập |
| `image_url` | String | Liên kết ảnh chụp thực địa đại diện chất lượng cao |
| `description` | Text | Bài viết thuyết minh lịch sử, ý nghĩa văn hóa và nghệ thuật |
| `verified_history` | JSON / Text | Tư liệu lịch sử chính thống (nguồn trích dẫn, tầng văn hóa khảo cổ) |
| `architectural_features` | List / Array | Danh sách các đặc trưng kiến trúc và điêu khắc nổi bật |
| `key_figures` | List / Array | Danh sách các danh nhân, vua chúa, tướng lĩnh gắn liền |

---

## 5. TỔNG KẾT PHẠM VI SẢN PHẨM HOÀN THÀNH (SCOPE SUMMARY)

Khi hoàn thành toàn bộ, VietLens là một ứng dụng di động khép kín với đầy đủ các luồng trải nghiệm:
1. **Luồng Khám phá (Discovery Flow):** Tìm kiếm $\rightarrow$ Lọc danh mục / triều đại $\rightarrow$ Xem di sản lân cận GPS.
2. **Luồng Thực địa (On-site Flow):** Mở Camera quét di tích $\rightarrow$ Nhận diện tức thì $\rightarrow$ Bật Audio Guide nghe thuyết minh rảnh tay $\rightarrow$ Đọc phân tích kiến trúc.
3. **Luồng Tương tác Sâu (Deep-dive Flow):** Mở Chat $\rightarrow$ Chọn Persona phù hợp (Lịch sử, Kiến trúc, Du lịch) $\rightarrow$ Hỏi đáp chuyên sâu theo ngữ cảnh di sản.
4. **Luồng Định vị (Navigation Flow):** Tra cứu bản đồ tương tác $\rightarrow$ Xem vị trí di sản và khoảng cách $\rightarrow$ Chỉ dẫn điểm đến.
5. **Luồng Giữ chân & Gắn kết (Retention Flow):** Lưu Bookmark $\rightarrow$ Mở khóa tem di sản trong Hộ chiếu $\rightarrow$ Tích lũy điểm văn hóa $\rightarrow$ Đánh giá và nhận xét.
