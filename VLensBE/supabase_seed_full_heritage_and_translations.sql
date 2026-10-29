-- ==============================================================================
-- VIETLENS: TOÀN BỘ CƠ SỞ DỮ LIỆU DI SẢN VĂN HÓA & DANH THẮNG TOÀN QUỐC
-- Nguồn dữ liệu: Data For Training + Da Nang Heritage + Biển Đảo Chủ Quyền
-- Bảng áp dụng: heritage_info & heritage_translations (Song ngữ VI & EN)
-- ==============================================================================

-- 1. NẠP DỮ LIỆU VÀO BẢNG HERITAGE_INFO
INSERT INTO heritage_info (id, name, province, address, latitude, longitude, category, image_url, description)
VALUES
-- --- ĐÀ NẴNG & MIỀN TRUNG TRỌNG ĐIỂM ---
('a1000001-0000-4000-a000-000000000001', 'Quần đảo Hoàng Sa', 'Đà Nẵng', 
 'Huyện đảo Hoàng Sa, Thành phố Đà Nẵng, Việt Nam', 16.5381, 111.6052, 'Di tích lịch sử',
 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80',
 'Quần đảo Hoàng Sa là một phần lãnh thổ thiêng liêng không thể tách rời của Tổ quốc Việt Nam trên Biển Đông, trực thuộc thành phố Đà Nẵng. Từ các thế kỷ XVII-XIX dưới thời chúa Nguyễn và triều đại nhà Nguyễn, các Đội Hoàng Sa kiêm quản Bắc Hải đã liên tục được cử ra đo đạc hải trình, cắm mốc chủ quyền, thu lượm hải vật và dựng bia khẳng định chủ quyền lãnh thổ lâu đời của dân tộc.'),

('a1000001-0000-4000-a000-000000000002', 'Quần đảo Trường Sa', 'Khánh Hòa',
 'Huyện đảo Trường Sa, Tỉnh Khánh Hòa, Việt Nam', 8.6441, 111.9208, 'Di tích lịch sử',
 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?auto=format&fit=crop&w=1200&q=80',
 'Quần đảo Trường Sa là tiền đồn kiên cường nơi đầu sóng ngọn gió bảo vệ vùng biển trời phía Đông Nam của Tổ quốc. Nơi đây gắn liền với những mốc chủ quyền sừng sững, ngọn hải đăng soi sáng hàng hải quốc tế, ngôi chùa Trường Sa Lớn thanh tịnh và Khu tưởng niệm các anh hùng liệt sĩ Gạc Ma bất tử đã ngã xuống vì sự toàn vẹn lãnh thổ thiêng liêng.'),

('a1000001-0000-4000-a000-000000000003', 'Nhà Trưng Bày Hoàng Sa', 'Đà Nẵng',
 'Đường Hoàng Sa, Phường Thọ Quang, Quận Sơn Trà, TP. Đà Nẵng', 16.0967, 108.2494, 'Kiến trúc & Cung đình',
 'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1200&q=80',
 'Nhà trưng bày Hoàng Sa là công trình văn hóa và bảo tàng tư liệu đặc biệt nằm bên bờ biển đường Hoàng Sa, Sơn Trà. Nơi đây lưu giữ hàng trăm hiện vật, bản đồ cổ phương Tây, châu bản triều Nguyễn và tư liệu lịch sử pháp lý minh chứng hùng hồn cho chủ quyền không thể chối cãi của Việt Nam đối với quần đảo Hoàng Sa.'),

('a1000001-0000-4000-a000-000000000004', 'Danh Thắng Ngũ Hành Sơn', 'Đà Nẵng',
 '81 Huyền Trân Công Chúa, Phường Hòa Hải, Quận Ngũ Hành Sơn, TP. Đà Nẵng', 16.0044, 108.2618, 'Di tích lịch sử',
 'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1200&q=80',
 'Ngũ Hành Sơn là Di tích quốc gia đặc biệt gồm quần thể 5 ngọn núi đá vôi nhô lên sừng sững bên bờ biển: Kim, Mộc, Thủy, Hỏa, Thổ. Nơi đây hội tụ vẻ đẹp huyền bí của hệ thống hang động kỳ ảo như Động Huyền Không, Động Tàng Chơn, cùng các ngôi cổ tự linh thiêng như Chùa Tam Thai, Chùa Linh Ứng Ngũ Hành Sơn và làng nghề đá mỹ nghệ Non Nước hàng trăm năm tuổi.'),

('a1000001-0000-4000-a000-000000000005', 'Bảo Tàng Điêu Khắc Chăm Đà Nẵng', 'Đà Nẵng',
 'Số 02 Đường 2 Tháng 9, Phường Bình Hiên, Quận Hải Châu, TP. Đà Nẵng', 16.0601, 108.2235, 'Văn hóa & Đời sống',
 'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?auto=format&fit=crop&w=1200&q=80',
 'Bảo tàng Điêu khắc Chăm Đà Nẵng được thành lập từ năm 1915, là bảo tàng duy nhất trên thế giới lưu giữ bộ sưu tập hiện vật điêu khắc sa thạch nguyên bản tinh xảo của nền văn minh Chăm-pa cổ. Với kiến trúc phong cách Gothic kết hợp đường nét tháp Chăm cổ điển, bảo tàng trưng bày hàng loạt Bảo vật Quốc gia như Đài thờ Trà Kiệu, Đài thờ Mỹ Sơn E1 và Tượng Bồ Tát Tara.'),

('a1000001-0000-4000-a000-000000000006', 'Di Tích Quốc Gia Đặc Biệt Thành Điện Hải', 'Đà Nẵng',
 'Số 24 Trần Phú, Phường Thạch Thang, Quận Hải Châu, TP. Đà Nẵng', 16.0746, 108.2232, 'Di tích lịch sử',
 'https://images.unsplash.com/photo-1568605117036-5fe5e7bab0b7?auto=format&fit=crop&w=1200&q=80',
 'Thành Điện Hải là pháo đài quân sự cổ kiểu Vauban kiên cố do triều Gia Long và Minh Mạng xây dựng để bảo vệ cửa biển Đà Nẵng. Đây là nơi ghi dấu trang sử hào hùng của dân tộc trong trận đầu kháng Pháp năm 1858 dưới sự chỉ huy thao lược của danh tướng Nguyễn Tri Phương, giam chân quân địch suốt nhiều tháng ròng.'),

('a1000001-0000-4000-a000-000000000007', 'Bán Đảo Sơn Trà & Chùa Linh Ứng Bãi Bụt', 'Đà Nẵng',
 'Khu vực Bãi Bụt, Bán đảo Sơn Trà, Quận Sơn Trà, TP. Đà Nẵng', 16.1002, 108.2760, 'Văn hóa & Đời sống',
 'https://images.unsplash.com/photo-1544644181-1484b3fdfc62?auto=format&fit=crop&w=1200&q=80',
 'Bán đảo Sơn Trà được mệnh danh là viên ngọc quý và lá phổi xanh của Đà Nẵng với hệ sinh thái rừng nhiệt đới trù phú cùng loài voọc chà vá chân nâu quý hiếm. Tọa lạc tại Bãi Bụt trên sườn bán đảo, Chùa Linh Ứng nổi bật với Đại tượng Phật Bà Quán Thế Âm cao 67m uy nghiêm, lưng tựa núi non, mắt hướng ra đại dương bao la cầu quốc thái dân an.'),

('a1000001-0000-4000-a000-000000000008', 'Cầu Rồng Đà Nẵng', 'Đà Nẵng',
 'Đường Nguyễn Văn Linh nối Võ Văn Kiệt, Quận Hải Châu & Sơn Trà, TP. Đà Nẵng', 16.0611, 108.2274, 'Kiến trúc & Cung đình',
 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80',
 'Cầu Rồng bắc qua dòng sông Hàn thơ mộng là kỳ quan kỹ thuật và biểu tượng thịnh vượng của Đà Nẵng hiện đại. Thiết kế mô phỏng hình tượng con rồng thời Lý dũng mãnh vươn mình ra biển Đông, chiếc cầu có khả năng phun lửa và phun nước độc đáo vào các tối cuối tuần, thu hút hàng vạn du khách trong và ngoài nước chiêm ngưỡng.'),

('a1000001-0000-4000-a000-000000000009', 'Cầu Quay Sông Hàn', 'Đà Nẵng',
 'Đường Lê Duẩn nối Phạm Văn Đồng, Quận Hải Châu & Sơn Trà, TP. Đà Nẵng', 16.0718, 108.2271, 'Kiến trúc & Cung đình',
 'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1200&q=80',
 'Cầu Sông Hàn là cây cầu quay đầu tiên và duy nhất do chính các kỹ sư và công nhân Việt Nam thiết kế, thi công với sự đồng lòng đóng góp của nhân dân Đà Nẵng. Vào mỗi đêm khuya, nhịp giữa của cầu có thể quay một góc 90 độ dọc theo dòng nước để mở luồng cho các tàu thuyền lớn qua lại, tượng trưng cho sức sống và sự năng động của thành phố.'),

('a1000001-0000-4000-a000-000000000010', 'Đình Làng Cổ Túy Loan', 'Đà Nẵng',
 'Làng Cổ Túy Loan, Xã Hòa Phong, Huyện Hòa Vang, TP. Đà Nẵng', 15.9922, 108.1325, 'Kiến trúc & Cung đình',
 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&w=1200&q=80',
 'Đình Túy Loan là một trong những ngôi đình cổ kính và linh thiêng nhất xứ Quảng với lịch sử hơn 500 năm hình thành cùng sự phát triển của làng cổ Túy Loan. Nơi đây bảo lưu trọn vẹn kiến trúc gỗ truyền thống ngũ phụ gia ba gian hai chái, lưu giữ hơn 20 sắc phong quý giá của các triều đại vua chúa nhà Nguyễn và phong vị bánh tráng Túy Loan nức tiếng.'),

('a1000001-0000-4000-a000-000000000011', 'Nhà Thờ Chính Tòa Đà Nẵng (Nhà Thờ Con Gà)', 'Đà Nẵng',
 '156 Trần Phú, Phường Hải Châu 1, Quận Hải Châu, TP. Đà Nẵng', 16.0668, 108.2234, 'Kiến trúc & Cung đình',
 'https://images.unsplash.com/photo-1548625361-195fe5786e70?auto=format&fit=crop&w=1200&q=80',
 'Nhà thờ Chính tòa Đà Nẵng (quen gọi là Nhà thờ Con Gà) được khởi công xây dựng từ thời Pháp thuộc năm 1923. Công trình nổi bật với sắc hồng pastel ngọt ngào, đường nét kiến trúc Gothic thanh thoát với các cửa sổ vòm cung nhọn lắp kính màu lộng lẫy và tượng con gà bằng hợp kim trên đỉnh tháp chuông đóng vai trò cột thu lôi kiêm chỉ hướng gió.'),

('a1000001-0000-4000-a000-000000000012', 'Quần Thể Du Lịch Bà Nà Hills', 'Đà Nẵng',
 'Thôn An Sơn, Xã Hòa Ninh, Huyện Hòa Vang, TP. Đà Nẵng', 15.9982, 107.9880, 'Danh lam thắng cảnh',
 'https://images.unsplash.com/photo-1589182373726-e4f658ab50f0?auto=format&fit=crop&w=1200&q=80',
 'Bà Nà Hills nằm trên đỉnh Núi Chúa ở độ cao 1.487m so với mực nước biển, nổi tiếng với khí hậu bốn mùa trong một ngày và cây Cầu Vàng sừng sững được nâng đỡ bởi đôi bàn tay khổng lồ rêu phong vươn giữa mây trời.'),

('a1000001-0000-4000-a000-000000000013', 'Chợ Hàn Đà Nẵng', 'Đà Nẵng',
 '119 Trần Phú, Phường Hải Châu 1, Quận Hải Châu, TP. Đà Nẵng', 16.0683, 108.2243, 'Văn hóa & Đời sống',
 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=1200&q=80',
 'Chợ Hàn là khu chợ thương mại sầm uất và lâu đời bậc nhất Đà Nẵng từ thời Pháp thuộc, nơi hội tụ tinh hoa ẩm thực xứ Quảng như mắm nêm, chả bò, hải sản khô và phong vị văn hóa đời sống người dân sông Hàn.'),

('a1000001-0000-4000-a000-000000000014', 'Cầu Tình Yêu & Tượng Cá Chép Hóa Rồng', 'Đà Nẵng',
 'Đường Trần Hưng Đạo, Phường An Hải Trung, Quận Sơn Trà, TP. Đà Nẵng', 16.0632, 108.2295, 'Kiến trúc & Cung đình',
 'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=1200&q=80',
 'Cầu Tình Yêu uốn lượn bên bờ đông sông Hàn với những cột đèn lồng hình trái tim đỏ thắm và hàng ngàn ổ khóa tình yêu bền chặt, kề bên là tượng Cá Chép Hóa Rồng phun nước uy nghi hướng ra sông lớn.'),

('a1000001-0000-4000-a000-000000000015', 'Cầu Trần Thị Lý', 'Đà Nẵng',
 'Đường Duy Tân nối Nguyễn Văn Thoại, Quận Hải Châu & Ngũ Hành Sơn, TP. Đà Nẵng', 16.0502, 108.2300, 'Kiến trúc & Cung đình',
 'https://images.unsplash.com/photo-1508873696983-2df5293cb395?auto=format&fit=crop&w=1200&q=80',
 'Cầu Trần Thị Lý mang kiến trúc dây văng cánh buồm hiện đại vươn mình ra biển lớn, với trụ tháp nghiêng độc đáo cao 145m tạo nên điểm nhấn thẩm mỹ thanh thoát trên dòng sông Hàn.'),

('a1000001-0000-4000-a000-000000000016', 'Công Viên Châu Á (Asia Park)', 'Đà Nẵng',
 'Số 01 Phan Đăng Lưu, Phường Hòa Cường Bắc, Quận Hải Châu, TP. Đà Nẵng', 16.0378, 108.2259, 'Văn hóa & Đời sống',
 'https://images.unsplash.com/photo-1513889961551-628c1e5e2ee9?auto=format&fit=crop&w=1200&q=80',
 'Asia Park là tổ hợp công viên giải trí và giao lưu văn hóa Đông Á nổi bật với Vòng quay Mặt Trời (Sun Wheel) cao 115m nằm trong top những vòng quay khổng lồ nhất thế giới.'),

-- --- QUẢNG NAM & CỐ ĐÔ HUẾ ---
('79f696ec-cc3b-4282-a245-f749bbbafeff', 'Đô Thị Cổ Hội An', 'Quảng Nam',
 'Phố cổ Hội An, Phường Minh An, TP. Hội An, Tỉnh Quảng Nam', 15.8792, 108.3238, 'Di tích lịch sử',
 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1200&q=80',
 'Đô thị cổ Hội An là Di sản Văn hóa Thế giới được UNESCO vinh danh, bảo tồn nguyên vẹn quần thể kiến trúc thương cảng truyền thống châu Á thế kỷ XVII-XIX với Chùa Cầu, nhà cổ Tấn Ký, Phùng Hưng và phố đèn lồng lung linh.'),

('159c6856-f84c-4538-ae24-7ce5fe7920f6', 'Quần Thể Lăng Minh Mạng', 'Thừa Thiên Huế',
 'Xã Hương Thọ, Thành phố Huế, Tỉnh Thừa Thiên Huế', 16.4595, 107.5950, 'Kiến trúc & Cung đình',
 'https://images.unsplash.com/photo-1544644181-1484b3fdfc62?auto=format&fit=crop&w=1200&q=80',
 'Lăng Minh Mạng (Hiếu Lăng) là đỉnh cao của nghệ thuật kiến trúc cung đình triều Nguyễn, thể hiện sự đối xứng đăng đối tuyệt đối và triết lý phong thủy hòa hợp giữa con người với non nước hữu tình.'),

('245547c7-f0db-4568-b42f-fcd3ff08b240', 'Đại Nội Huế & Cổng Ngọ Môn', 'Thừa Thiên Huế',
 'Đường 23 Tháng 8, Phường Thuận Thành, Thành phố Huế, Tỉnh Thừa Thiên Huế', 16.4615, 107.5950, 'Kiến trúc & Cung đình',
 'https://images.unsplash.com/photo-1578632767115-351597cf2477?auto=format&fit=crop&w=1200&q=80',
 'Đại Nội Huế là trung tâm quyền lực của 13 đời vua triều Nguyễn (1802-1945), với Ngọ Môn lộng lẫy, điện Thái Hòa uy nghiêm và hệ thống cung điện, miếu thờ mang đậm dấu ấn kiến trúc phương Đông cổ truyền.')
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  province = EXCLUDED.province,
  address = EXCLUDED.address,
  latitude = EXCLUDED.latitude,
  longitude = EXCLUDED.longitude,
  category = EXCLUDED.category,
  image_url = EXCLUDED.image_url,
  description = EXCLUDED.description;

-- 2. NẠP SONG NGỮ TIẾNG VIỆT (VI) VÀO HERITAGE_TRANSLATIONS
INSERT INTO heritage_translations (heritage_id, language_code, name, province, address, category, description)
SELECT id, 'vi', name, province, address, category, description
FROM heritage_info
WHERE id LIKE 'a1000001-%' OR id IN ('79f696ec-cc3b-4282-a245-f749bbbafeff', '159c6856-f84c-4538-ae24-7ce5fe7920f6', '245547c7-f0db-4568-b42f-fcd3ff08b240')
ON CONFLICT (heritage_id, language_code) DO UPDATE SET
  name = EXCLUDED.name,
  province = EXCLUDED.province,
  address = EXCLUDED.address,
  category = EXCLUDED.category,
  description = EXCLUDED.description,
  updated_at = NOW();

-- 3. NẠP SONG NGỮ TIẾNG ANH (EN) VÀO HERITAGE_TRANSLATIONS
INSERT INTO heritage_translations (heritage_id, language_code, name, province, address, category, description)
VALUES
('a1000001-0000-4000-a000-000000000001', 'en', 'Paracel Islands (Hoang Sa)', 'Da Nang',
 'Hoang Sa Island District, Da Nang City, Vietnam', 'Historical Relic',
 'The Paracel Islands (Hoang Sa) constitute a sacred, inseparable territory of Vietnam in the East Sea, administratively under Da Nang City with historical sovereignty documented since the 17th century.'),

('a1000001-0000-4000-a000-000000000002', 'en', 'Spratly Islands (Truong Sa)', 'Khanh Hoa',
 'Truong Sa Island District, Khanh Hoa Province, Vietnam', 'Historical Relic',
 'The Spratly Islands (Truong Sa) stand as a steadfast maritime outpost defending the sovereignty of Vietnam in the southeastern sea with proud historical landmarks and maritime heritage.'),

('a1000001-0000-4000-a000-000000000003', 'en', 'Hoang Sa Exhibition House', 'Da Nang',
 'Hoang Sa Coastal Road, Tho Quang, Son Tra, Da Nang City', 'Architecture & Heritage',
 'A premier maritime museum on Son Tra peninsula showcasing precious historical archives and royal decrees affirming Vietnam sovereignty over the Paracel Islands.'),

('a1000001-0000-4000-a000-000000000004', 'en', 'Marble Mountains (Ngu Hanh Son)', 'Da Nang',
 '81 Huyen Tran Cong Chua St, Hoa Hai, Ngu Hanh Son, Da Nang', 'Historical Relic',
 'A Special National Monument comprising five dramatic limestone peaks featuring mystical caverns, ancient Buddhist pagodas, and centuries-old stone craftsmanship.'),

('a1000001-0000-4000-a000-000000000005', 'en', 'Da Nang Museum of Cham Sculpture', 'Da Nang',
 'No. 02 2 Thang 9 Street, Binh Hien, Hai Chau, Da Nang City', 'Culture & Folk Art',
 'Founded in 1915, this museum houses the world largest collection of original Champa sandstone sculptures and recognized National Treasures.'),

('a1000001-0000-4000-a000-000000000006', 'en', 'Dien Hai Citadel Special National Monument', 'Da Nang',
 '24 Tran Phu Street, Thach Thang, Hai Chau, Da Nang City', 'Historical Relic',
 'A 19th-century Vauban-style fortress that defended Da Nang harbor during the historic resistance under General Nguyen Tri Phuong.'),

('a1000001-0000-4000-a000-000000000007', 'en', 'Son Tra Peninsula & Linh Ung Pagoda (Bai But)', 'Da Nang',
 'Bai But Area, Son Tra Peninsula, Son Tra District, Da Nang', 'Culture & Folk Art',
 'The emerald green peninsula of Da Nang featuring the majestic 67-meter Lady Buddha statue gazing out over the East Sea.'),

('a1000001-0000-4000-a000-000000000008', 'en', 'Dragon Bridge of Da Nang', 'Da Nang',
 'Nguyen Van Linh connecting Vo Van Kiet St, Da Nang City', 'Architecture & Heritage',
 'An iconic dragon-shaped bridge across the Han River featuring awe-inspiring weekend fire and water breathing performances.'),

('a1000001-0000-4000-a000-000000000009', 'en', 'Han River Swing Bridge', 'Da Nang',
 'Le Duan St connecting Pham Van Dong St, Da Nang City', 'Architecture & Heritage',
 'Vietnam first swing bridge engineered and constructed with community spirit, rotating 90 degrees during late night hours.'),

('a1000001-0000-4000-a000-000000000010', 'en', 'Tuy Loan Ancient Village & Communal House', 'Da Nang',
 'Tuy Loan Ancient Village, Hoa Phong, Hoa Vang, Da Nang', 'Architecture & Heritage',
 'A 500-year-old riverside settlement preserving exquisite traditional wooden architecture, imperial royal decrees, and heritage cuisine.'),

('a1000001-0000-4000-a000-000000000011', 'en', 'Da Nang Cathedral (Pink Church)', 'Da Nang',
 '156 Tran Phu Street, Hai Chau 1, Hai Chau, Da Nang City', 'Architecture & Heritage',
 'A pastel-pink Gothic cathedral constructed in 1923, featuring stained-glass arched windows and a distinctive rooster weathercock atop the spire.'),

('a1000001-0000-4000-a000-000000000012', 'en', 'Ba Na Hills & Golden Bridge', 'Da Nang',
 'An Son Village, Hoa Ninh, Hoa Vang, Da Nang City', 'Scenic Landscape',
 'A mountain resort nestled at 1,487m altitude famous for four-season daily weather and the iconic Golden Bridge held by giant stone hands.'),

('a1000001-0000-4000-a000-000000000013', 'en', 'Han Market Da Nang', 'Da Nang',
 '119 Tran Phu, Hai Chau 1, Hai Chau, Da Nang City', 'Culture & Folk Art',
 'The most bustling and storied traditional market in Da Nang since French colonial times, brimming with authentic local delicacies and handicrafts.'),

('a1000001-0000-4000-a000-000000000014', 'en', 'Love Bridge & Dragon Carp Statue', 'Da Nang',
 'Tran Hung Dao St, An Hai Trung, Son Tra, Da Nang City', 'Architecture & Heritage',
 'A romantic pier adorned with heart-shaped lanterns and love padlocks alongside the majestic water-spouting Dragon Carp statue.'),

('a1000001-0000-4000-a000-000000000015', 'en', 'Tran Thi Ly Cable-Stayed Bridge', 'Da Nang',
 'Duy Tan connecting Nguyen Van Thoai, Da Nang City', 'Architecture & Heritage',
 'An elegant cable-stayed bridge sculpted like a soaring sail toward the ocean, supported by an inclined 145-meter pylon.'),

('a1000001-0000-4000-a000-000000000016', 'en', 'Asia Park (Sun World Da Nang)', 'Da Nang',
 '01 Phan Dang Luu, Hoa Cuong Bac, Hai Chau, Da Nang City', 'Culture & Folk Art',
 'An East Asian themed amusement and cultural park centered around the world-class 115-meter Sun Wheel.'),

('79f696ec-cc3b-4282-a245-f749bbbafeff', 'en', 'Hoi An Ancient Town', 'Quang Nam',
 'Hoi An Ancient Town, Minh An Ward, Hoi An City, Quang Nam', 'Historical Relic',
 'A UNESCO World Heritage ancient trading port remarkably preserved from the 17th century with the Japanese Bridge and historic wooden shophouses.'),

('159c6856-f84c-4538-ae24-7ce5fe7920f6', 'en', 'Minh Mang Royal Tomb', 'Thua Thien Hue',
 'Huong Tho Commune, Hue City, Thua Thien Hue Province', 'Architecture & Heritage',
 'The pinnacle of Nguyen Dynasty royal funerary architecture, exhibiting strict symmetrical balance nestled within poetic natural landscapes.'),

('245547c7-f0db-4568-b42f-fcd3ff08b240', 'en', 'Imperial Citadel of Hue & Ngo Mon Gate', 'Thua Thien Hue',
 '23 Thang 8 Street, Thuan Thanh, Hue City, Thua Thien Hue', 'Architecture & Heritage',
 'The political heart of the Nguyen Dynasty (1802-1945), featuring the grand Ngo Mon Gate and historic palaces of royal Vietnam.')
ON CONFLICT (heritage_id, language_code) DO UPDATE SET
  name = EXCLUDED.name,
  province = EXCLUDED.province,
  address = EXCLUDED.address,
  category = EXCLUDED.category,
  description = EXCLUDED.description,
  updated_at = NOW();

