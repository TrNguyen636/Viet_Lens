-- ==============================================================================
-- VIETLENS: BỔ SUNG DI SẢN CHỦ QUYỀN BIỂN ĐẢO (HOÀNG SA, TRƯỜNG SA) & DANH THẮNG ĐÀ NẴNG
-- Cập nhật:
--   - Đã cân chỉnh tọa độ chuẩn:
--       + Thành Điện Hải: 16.0746, 108.2232
--       + Chùa Linh Ứng Bãi Bụt Sơn Trà: 16.1002, 108.2760
--   - Nạp dữ liệu vào heritage_info
--   - Nạp đồng thời song ngữ (VI & EN) vào heritage_translations
-- ==============================================================================

-- 1. BẢNG HERITAGE_INFO
INSERT INTO heritage_info (id, name, province, address, latitude, longitude, category, image_url, description)
VALUES 
-- 1. Hoàng Sa
('a1000001-0000-4000-a000-000000000001', 'Quần đảo Hoàng Sa', 'Đà Nẵng', 
 'Huyện đảo Hoàng Sa, Thành phố Đà Nẵng, Việt Nam', 16.5381, 111.6052, 'Di tích lịch sử',
 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80',
 'Quần đảo Hoàng Sa là một phần lãnh thổ thiêng liêng không thể tách rời của Tổ quốc Việt Nam trên Biển Đông, trực thuộc thành phố Đà Nẵng. Từ các thế kỷ XVII-XIX dưới thời chúa Nguyễn và triều đại nhà Nguyễn, các Đội Hoàng Sa kiêm quản Bắc Hải đã liên tục được cử ra đo đạc hải trình, cắm mốc chủ quyền, thu lượm hải vật và dựng bia khẳng định chủ quyền lãnh thổ lâu đời của dân tộc.'),

-- 2. Trường Sa
('a1000001-0000-4000-a000-000000000002', 'Quần đảo Trường Sa', 'Khánh Hòa',
 'Huyện đảo Trường Sa, Tỉnh Khánh Hòa, Việt Nam', 8.6441, 111.9208, 'Di tích lịch sử',
 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?auto=format&fit=crop&w=1200&q=80',
 'Quần đảo Trường Sa là tiền đồn kiên cường nơi đầu sóng ngọn gió bảo vệ vùng biển trời phía Đông Nam của Tổ quốc. Nơi đây gắn liền với những mốc chủ quyền sừng sững, ngọn hải đăng soi sáng hàng hải quốc tế, ngôi chùa Trường Sa Lớn thanh tịnh và Khu tưởng niệm các anh hùng liệt sĩ Gạc Ma bất tử đã ngã xuống vì sự toàn vẹn lãnh thổ thiêng liêng.'),

-- 3. Nhà Trưng Bày Hoàng Sa
('a1000001-0000-4000-a000-000000000003', 'Nhà Trưng Bày Hoàng Sa', 'Đà Nẵng',
 'Đường Hoàng Sa, Phường Thọ Quang, Quận Sơn Trà, TP. Đà Nẵng', 16.0967, 108.2494, 'Kiến trúc & Cung đình',
 'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1200&q=80',
 'Nhà trưng bày Hoàng Sa là công trình văn hóa và bảo tàng tư liệu đặc biệt nằm bên bờ biển đường Hoàng Sa, Sơn Trà. Nơi đây lưu giữ hàng trăm hiện vật, bản đồ cổ phương Tây, châu bản triều Nguyễn và tư liệu lịch sử pháp lý minh chứng hùng hồn cho chủ quyền không thể chối cãi của Việt Nam đối với quần đảo Hoàng Sa.'),

-- 4. Ngũ Hành Sơn
('a1000001-0000-4000-a000-000000000004', 'Danh Thắng Ngũ Hành Sơn', 'Đà Nẵng',
 '81 Huyền Trân Công Chúa, Phường Hòa Hải, Quận Ngũ Hành Sơn, TP. Đà Nẵng', 16.0044, 108.2618, 'Di tích lịch sử',
 'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1200&q=80',
 'Ngũ Hành Sơn là Di tích quốc gia đặc biệt gồm quần thể 5 ngọn núi đá vôi nhô lên sừng sững bên bờ biển: Kim, Mộc, Thủy, Hỏa, Thổ. Nơi đây hội tụ vẻ đẹp huyền bí của hệ thống hang động kỳ ảo như Động Huyền Không, Động Tàng Chơn, cùng các ngôi cổ tự linh thiêng như Chùa Tam Thai, Chùa Linh Ứng Ngũ Hành Sơn và làng nghề đá mỹ nghệ Non Nước hàng trăm năm tuổi.'),

-- 5. Bảo Tàng Điêu Khắc Chăm
('a1000001-0000-4000-a000-000000000005', 'Bảo Tàng Điêu Khắc Chăm Đà Nẵng', 'Đà Nẵng',
 'Số 02 Đường 2 Tháng 9, Phường Bình Hiên, Quận Hải Châu, TP. Đà Nẵng', 16.0601, 108.2235, 'Văn hóa & Đời sống',
 'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?auto=format&fit=crop&w=1200&q=80',
 'Bảo tàng Điêu khắc Chăm Đà Nẵng được thành lập từ năm 1915, là bảo tàng duy nhất trên thế giới lưu giữ bộ sưu tập hiện vật điêu khắc sa thạch nguyên bản tinh xảo của nền văn minh Chăm-pa cổ. Với kiến trúc phong cách Gothic kết hợp đường nét tháp Chăm cổ điển, bảo tàng trưng bày hàng loạt Bảo vật Quốc gia như Đài thờ Trà Kiệu, Đài thờ Mỹ Sơn E1 và Tượng Bồ Tát Tara.'),

-- 6. Thành Điện Hải (Tọa độ cân chỉnh chính xác trung tâm pháo đài ven Trần Phú: 16.0746, 108.2232)
('a1000001-0000-4000-a000-000000000006', 'Di Tích Quốc Gia Đặc Biệt Thành Điện Hải', 'Đà Nẵng',
 'Số 24 Trần Phú, Phường Thạch Thang, Quận Hải Châu, TP. Đà Nẵng', 16.0746, 108.2232, 'Di tích lịch sử',
 'https://images.unsplash.com/photo-1568605117036-5fe5e7bab0b7?auto=format&fit=crop&w=1200&q=80',
 'Thành Điện Hải là pháo đài quân sự cổ kiểu Vauban kiên cố do triều Gia Long và Minh Mạng xây dựng để bảo vệ cửa biển Đà Nẵng. Đây là nơi ghi dấu trang sử hào hùng của dân tộc trong trận đầu kháng Pháp năm 1858 dưới sự chỉ huy thao lược của danh tướng Nguyễn Tri Phương, giam chân quân địch suốt nhiều tháng ròng.'),

-- 7. Bán Đảo Sơn Trà & Chùa Linh Ứng (Tọa độ cân chỉnh quần thể chùa Bãi Bụt: 16.1002, 108.2760)
('a1000001-0000-4000-a000-000000000007', 'Bán Đảo Sơn Trà & Chùa Linh Ứng Bãi Bụt', 'Đà Nẵng',
 'Khu vực Bãi Bụt, Bán đảo Sơn Trà, Quận Sơn Trà, TP. Đà Nẵng', 16.1002, 108.2760, 'Văn hóa & Đời sống',
 'https://images.unsplash.com/photo-1544644181-1484b3fdfc62?auto=format&fit=crop&w=1200&q=80',
 'Bán đảo Sơn Trà được mệnh danh là viên ngọc quý và lá phổi xanh của Đà Nẵng với hệ sinh thái rừng nhiệt đới trù phú cùng loài voọc chà vá chân nâu quý hiếm. Tọa lạc tại Bãi Bụt trên sườn bán đảo, Chùa Linh Ứng nổi bật với Đại tượng Phật Bà Quán Thế Âm cao 67m uy nghiêm, lưng tựa núi non, mắt hướng ra đại dương bao la cầu quốc thái dân an.'),

-- 8. Cầu Rồng
('a1000001-0000-4000-a000-000000000008', 'Cầu Rồng Đà Nẵng', 'Đà Nẵng',
 'Đường Nguyễn Văn Linh nối Võ Văn Kiệt, Quận Hải Châu & Sơn Trà, TP. Đà Nẵng', 16.0611, 108.2274, 'Kiến trúc & Cung đình',
 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80',
 'Cầu Rồng bắc qua dòng sông Hàn thơ mộng là kỳ quan kỹ thuật và biểu tượng thịnh vượng của Đà Nẵng hiện đại. Thiết kế mô phỏng hình tượng con rồng thời Lý dũng mãnh vươn mình ra biển Đông, chiếc cầu có khả năng phun lửa và phun nước độc đáo vào các tối cuối tuần, thu hút hàng vạn du khách trong và ngoài nước chiêm ngưỡng.'),

-- 9. Cầu Quay Sông Hàn
('a1000001-0000-4000-a000-000000000009', 'Cầu Quay Sông Hàn', 'Đà Nẵng',
 'Đường Lê Duẩn nối Phạm Văn Đồng, Quận Hải Châu & Sơn Trà, TP. Đà Nẵng', 16.0718, 108.2271, 'Kiến trúc & Cung đình',
 'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1200&q=80',
 'Cầu Sông Hàn là cây cầu quay đầu tiên và duy nhất do chính các kỹ sư và công nhân Việt Nam thiết kế, thi công với sự đồng lòng đóng góp của nhân dân Đà Nẵng. Vào mỗi đêm khuya, nhịp giữa của cầu có thể quay một góc 90 độ dọc theo dòng nước để mở luồng cho các tàu thuyền lớn qua lại, tượng trưng cho sức sống và sự năng động của thành phố.'),

-- 10. Đình Làng Túy Loan
('a1000001-0000-4000-a000-000000000010', 'Đình Làng Cổ Túy Loan', 'Đà Nẵng',
 'Làng Cổ Túy Loan, Xã Hòa Phong, Huyện Hòa Vang, TP. Đà Nẵng', 15.9922, 108.1325, 'Kiến trúc & Cung đình',
 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&w=1200&q=80',
 'Đình Túy Loan là một trong những ngôi đình cổ kính và linh thiêng nhất xứ Quảng với lịch sử hơn 500 năm hình thành cùng sự phát triển của làng cổ Túy Loan. Nơi đây bảo lưu trọn vẹn kiến trúc gỗ truyền thống ngũ phụ gia ba gian hai chái, lưu giữ hơn 20 sắc phong quý giá của các triều đại vua chúa nhà Nguyễn và phong vị bánh tráng Túy Loan nức tiếng.'),

-- 11. Nhà Thờ Con Gà
('a1000001-0000-4000-a000-000000000011', 'Nhà Thờ Chính Tòa Đà Nẵng (Nhà Thờ Con Gà)', 'Đà Nẵng',
 '156 Trần Phú, Phường Hải Châu 1, Quận Hải Châu, TP. Đà Nẵng', 16.0668, 108.2234, 'Kiến trúc & Cung đình',
 'https://images.unsplash.com/photo-1548625361-195fe5786e70?auto=format&fit=crop&w=1200&q=80',
 'Nhà thờ Chính tòa Đà Nẵng (quen gọi là Nhà thờ Con Gà) được khởi công xây dựng từ thời Pháp thuộc năm 1923. Công trình nổi bật với sắc hồng pastel ngọt ngào, đường nét kiến trúc Gothic thanh thoát với các cửa sổ vòm cung nhọn lắp kính màu lộng lẫy và tượng con gà bằng hợp kim trên đỉnh tháp chuông đóng vai trò cột thu lôi kiêm chỉ hướng gió.')
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  province = EXCLUDED.province,
  address = EXCLUDED.address,
  latitude = EXCLUDED.latitude,
  longitude = EXCLUDED.longitude,
  category = EXCLUDED.category,
  image_url = EXCLUDED.image_url,
  description = EXCLUDED.description;

-- 2. NẠP SONG NGỮ VÀO HERITAGE_TRANSLATIONS (BẢN TIẾNG VIỆT 'vi')
INSERT INTO heritage_translations (heritage_id, language_code, name, province, address, category, description)
SELECT id, 'vi', name, province, address, category, description
FROM heritage_info
WHERE id LIKE 'a1000001-%'
ON CONFLICT (heritage_id, language_code) DO UPDATE SET
  name = EXCLUDED.name,
  province = EXCLUDED.province,
  address = EXCLUDED.address,
  category = EXCLUDED.category,
  description = EXCLUDED.description,
  updated_at = NOW();

-- 3. NẠP SONG NGỮ VÀO HERITAGE_TRANSLATIONS (BẢN TIẾNG ANH 'en')
INSERT INTO heritage_translations (heritage_id, language_code, name, province, address, category, description)
VALUES
('a1000001-0000-4000-a000-000000000001', 'en', 'Paracel Islands (Hoang Sa)', 'Da Nang',
 'Hoang Sa Island District, Da Nang City, Vietnam', 'Historical Relic',
 'The Paracel Islands (Hoang Sa) constitute a sacred, inseparable territory of Vietnam in the East Sea, administratively under Da Nang City. Since the 17th to 19th centuries during the Nguyen Lords and the Nguyen Dynasty, royal naval expeditions (Doi Hoang Sa) were regularly dispatched to survey sea routes, establish sovereignty landmarks, salvage goods, and assert undisputed historical territorial sovereignty.'),

('a1000001-0000-4000-a000-000000000002', 'en', 'Spratly Islands (Truong Sa)', 'Khanh Hoa',
 'Truong Sa Island District, Khanh Hoa Province, Vietnam', 'Historical Relic',
 'The Spratly Islands (Truong Sa) stand as a steadfast maritime outpost defending the sovereignty of Vietnam in the southeastern sea. The archipelago features towering sovereignty milestones, historic lighthouses guiding international navigation, Truong Sa Pagoda, and the solemn Gac Ma Memorial honoring heroic soldiers who made the ultimate sacrifice for national integrity.'),

('a1000001-0000-4000-a000-000000000003', 'en', 'Hoang Sa Exhibition House', 'Da Nang',
 'Hoang Sa Coastal Road, Tho Quang, Son Tra, Da Nang City', 'Architecture & Heritage',
 'The Hoang Sa Exhibition House is a landmark cultural facility located along the scenic coast of Son Tra. It preserves and showcases hundreds of rare historical maps, royal administrative archives from the Nguyen Dynasty, and international treaties affirming the unquestionable legal and historical sovereignty of Vietnam over the Paracel Islands.'),

('a1000001-0000-4000-a000-000000000004', 'en', 'Marble Mountains (Ngu Hanh Son)', 'Da Nang',
 '81 Huyen Tran Cong Chua St, Hoa Hai, Ngu Hanh Son, Da Nang', 'Historical Relic',
 'The Marble Mountains are a Special National Monument consisting of five dramatic limestone peaks named after the five Eastern elements: Metal, Wood, Water, Fire, and Earth. The site features breathtaking mystical caverns including Huyen Khong and Tang Chon caves, sacred centuries-old sanctuaries such as Tam Thai Pagoda, and the historic Non Nuoc stone carving village.'),

('a1000001-0000-4000-a000-000000000005', 'en', 'Da Nang Museum of Cham Sculpture', 'Da Nang',
 'No. 02 2 Thang 9 Street, Binh Hien, Hai Chau, Da Nang City', 'Culture & Folk Art',
 'Founded in 1915, the Da Nang Museum of Cham Sculpture houses the world''s largest and most comprehensive collection of original sandstone and terracotta sculptures from the ancient Champa civilization. Blending French colonial architecture with traditional Cham motifs, the museum showcases prized National Treasures including the Tra Kieu Altar, My Son E1 Altar, and the exquisite Tara Bodhisattva.'),

('a1000001-0000-4000-a000-000000000006', 'en', 'Dien Hai Citadel Special National Monument', 'Da Nang',
 '24 Tran Phu Street, Thach Thang, Hai Chau, Da Nang City', 'Historical Relic',
 'Dien Hai Citadel is a historic Vauban-style military stronghold constructed during the reigns of Emperors Gia Long and Minh Mang to guard the coastal gateway of Da Nang. The fortress commemorates a heroic chapter of Vietnamese history in 1858, where legendary General Nguyen Tri Phuong commanded troops and successfully thwarted the Franco-Spanish naval invasion.'),

('a1000001-0000-4000-a000-000000000007', 'en', 'Son Tra Peninsula & Linh Ung Pagoda (Bai But)', 'Da Nang',
 'Bai But Area, Son Tra Peninsula, Son Tra District, Da Nang', 'Culture & Folk Art',
 'The Son Tra Peninsula is celebrated as the emerald jewel of Da Nang, sheltering pristine tropical rainforest ecosystems and endangered Red-shanked Douc langurs. Situated on the peninsula''s slopes at Bai But, Linh Ung Pagoda features Vietnam''s iconic 67-meter-tall statue of Lady Buddha (Avalokiteshvara), overlooking the tranquil ocean to safeguard maritime journeys.'),

('a1000001-0000-4000-a000-000000000008', 'en', 'Dragon Bridge of Da Nang', 'Da Nang',
 'Nguyen Van Linh connecting Vo Van Kiet St, Da Nang City', 'Architecture & Heritage',
 'Spanning the poetic Han River, Dragon Bridge stands as an engineering wonder and a proud symbol of Da Nang''s modern aspirations. Sculpted in the likeness of a majestic Ly Dynasty dragon soaring towards the East Sea, the bridge dazzles visitors with spectacular fire and water-breathing performances on weekend evenings.'),

('a1000001-0000-4000-a000-000000000009', 'en', 'Han River Swing Bridge', 'Da Nang',
 'Le Duan St connecting Pham Van Dong St, Da Nang City', 'Architecture & Heritage',
 'The Han River Bridge is Vietnam''s first swing bridge, designed and constructed by Vietnamese engineers with generous community contributions. At late night, the central span rotates 90 degrees along the river current to allow large maritime vessels to pass, serving as an enduring symbol of community solidarity and civic innovation.'),

('a1000001-0000-4000-a000-000000000010', 'en', 'Tuy Loan Ancient Village & Communal House', 'Da Nang',
 'Tuy Loan Ancient Village, Hoa Phong, Hoa Vang, Da Nang', 'Architecture & Heritage',
 'The Tuy Loan Communal House is one of Central Vietnam''s oldest surviving heritage structures, dating back over 500 years alongside the historic Tuy Loan riverside village. The complex preserves traditional Vietnamese wooden architecture, over 20 royal decrees from the Nguyen Dynasty, and a culinary legacy famous for handcrafted rice paper.'),

('a1000001-0000-4000-a000-000000000011', 'en', 'Da Nang Cathedral (Pink Church / Roosters Church)', 'Da Nang',
 '156 Tran Phu Street, Hai Chau 1, Hai Chau, Da Nang City', 'Architecture & Heritage',
 'The Da Nang Cathedral, fondly known as the Rooster Church (Nha tho Con Ga), was constructed in 1923 during the French colonial era. Distinguished by its soft pastel pink facade, elegant Gothic lines, soaring stained-glass arched windows, and a distinctive alloy weathercock perched atop the bell tower, it is one of the city''s most beloved religious landmarks.')
ON CONFLICT (heritage_id, language_code) DO UPDATE SET
  name = EXCLUDED.name,
  province = EXCLUDED.province,
  address = EXCLUDED.address,
  category = EXCLUDED.category,
  description = EXCLUDED.description,
  updated_at = NOW();
