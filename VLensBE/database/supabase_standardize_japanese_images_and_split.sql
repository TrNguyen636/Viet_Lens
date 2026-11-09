-- ==============================================================================
-- VIETLENS MIGRATION: STANDARDIZE JAPANESE, IMAGES & SPLIT DRAGON-CARP / LOVE BRIDGE
-- Mục đích:
--   1. Sửa toàn bộ tên tiếng Nhật hiển thị chuẩn cho 34 địa danh (không còn tiếng Việt)
--   2. Khắc phục triệt để các địa danh dùng chung ảnh train_49144_1.jpg bằng ảnh thật
--   3. Tách Cầu Tình Yêu và Tượng Cá Chép Hóa Rồng thành 2 địa danh riêng biệt kề nhau
-- ==============================================================================

BEGIN;

-- ------------------------------------------------------------------------------
-- 1. CẬP NHẬT ẢNH THẬT RIÊNG BIỆT & THÔNG TIN CẦU TÌNH YÊU TRONG HERITAGE_INFO
-- ------------------------------------------------------------------------------
UPDATE heritage_info 
SET name = 'Bãi biển Nha Trang',
    address = 'Bãi biển Nha Trang, thành phố Nha Trang, tỉnh Khánh Hòa',
    latitude = 12.2388,
    longitude = 109.1967,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/phong_canh_bien_Nha_Trang_000048.jpg',
    description = 'Bãi biển Nha Trang, một trong những danh lam thắng cảnh nổi tiếng của miền Trung Việt Nam, nằm ở phía đông thành phố Nha Trang, tỉnh Khánh Hòa. Với dải cát trắng mịn, làn nước trong xanh và dải rặng san hô đa dạng, nơi đây đã thu hút hàng triệu du khách trong và ngoài nước mỗi năm. Tuy nhiên, trong những năm gần đây, bãi biển đang đối mặt với tình trạng ô nhiễm môi trường nghiêm trọng, bao gồm rác thải nhựa, chất thải sinh hoạt và các chất ô nhiễm từ hoạt động du lịch quá tải. Những vấn đề này không chỉ làm giảm giá trị thẩm mỹ mà còn đe dọa hệ sinh thái biển, ảnh hưởng đến nguồn lợi thủy sản và sức khỏe cộng đồng. Chính quyền địa phương và các tổ chức xã hội đang triển khai các biện pháp thu gom rác, nâng cao ý thức bảo vệ môi trường và phát triển du lịch bền vững nhằm khôi phục vẻ đẹp nguyên sơ của bãi biển Nha Trang.'
WHERE id = 'f5145fde-0ad3-451c-8c12-93ce05519557';
UPDATE heritage_info 
SET name = 'Bảo Tàng Điêu Khắc Chăm Đà Nẵng',
    address = 'Số 02 Đường 2 Tháng 9, Phường Bình Hiên, Quận Hải Châu, TP. Đà Nẵng',
    latitude = 16.060121,
    longitude = 108.223084,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/bao_tang_cham_da_nang.jpg',
    description = 'Bảo tàng Điêu khắc Chăm Đà Nẵng được thành lập từ năm 1915, là bảo tàng duy nhất trên thế giới lưu giữ bộ sưu tập hiện vật điêu khắc sa thạch nguyên bản tinh xảo của nền văn minh Chăm-pa cổ. Với kiến trúc phong cách Gothic kết hợp đường nét tháp Chăm cổ điển, bảo tàng trưng bày hàng loạt Bảo vật Quốc gia như Đài thờ Trà Kiệu, Đài thờ Mỹ Sơn E1 và Tượng Bồ Tát Tara.'
WHERE id = '24639b24-25a1-4b8b-a04e-87e25127f8d1';
UPDATE heritage_info 
SET name = 'Bảo tàng Hồ Chí Minh (Hà Nội)',
    address = 'Bảo tàng Hồ Chí Minh (Hà Nội), Hà Nội',
    latitude = 21.035617,
    longitude = 105.832629,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_51050_1.jpg',
    description = 'Bảo tàng Hồ Chí Minh nằm liền kề khu di tích Lăng Bác, mang hình tượng đóa sen trắng thanh cao biểu trưng cho nhân cách giản dị mà vĩ đại của Người. Bên trong bảo tàng là không gian trưng bày nghệ thuật đương đại giàu tính biểu tượng, tái hiện trọn vẹn cuộc đời và hành trình cứu nước của Chủ tịch Hồ Chí Minh.'
WHERE id = '88f03632-8f54-4866-85e1-1fcf133e2cd0';
UPDATE heritage_info 
SET name = 'Bảo tàng Khu 5 (Đà Nẵng)',
    address = 'Bảo tàng Khu 5 (Đà Nẵng), Đà Nẵng',
    latitude = 16.04785,
    longitude = 108.21736,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_190292_1.jpg',
    description = 'Bảo tàng Khu 5 nằm trên đường Duy Tân, Đà Nẵng, là nơi lưu giữ và tái hiện những năm tháng đấu tranh kiên cường của quân và dân Quân khu 5 miền Trung. Khu trưng bày ngoài trời sở hữu nhiều hiện vật máy bay, xe tăng chiến lợi phẩm cùng mô hình tái hiện ngôi nhà sàn Bác Hồ với tỷ lệ chuẩn xác.'
WHERE id = 'b0ab53e8-7d08-451c-9fd1-4980982a862a';
UPDATE heritage_info 
SET name = 'Bảo tàng Lịch sử Quốc gia (Hà Nội)',
    address = 'Bảo tàng Lịch sử Quốc gia (Hà Nội), Hà Nội',
    latitude = 21.02414,
    longitude = 105.85976,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_37461_1.jpg',
    description = 'Bảo tàng Lịch sử Quốc gia trên đường Tràng Tiền là kiệt tác kiến trúc Đông Dương kinh điển do kiến trúc sư Ernest Hébrard thiết kế vào thập niên 1920. Bảo tàng trưng bày hàng trăm nghìn hiện vật khảo cổ vô giá từ thời tiền sử, văn hóa Đông Sơn rực rỡ đến các triều đại phong kiến hưng thịnh của Việt Nam.'
WHERE id = '6dc15a30-cbcb-4a7a-b05f-e8c9136f3627';
UPDATE heritage_info 
SET name = 'Bảo tàng Mỹ thuật Việt Nam',
    address = 'Bảo tàng Mỹ thuật Việt Nam, Hà Nội',
    latitude = 21.03069,
    longitude = 105.837046,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_159148_1.jpg',
    description = 'Bảo tàng Mỹ thuật Việt Nam tọa lạc trên phố Nguyễn Thái Học, nguyên là một dinh thự cổ kiểu Pháp được xây dựng từ thời thuộc địa với những hàng hiên và cửa sổ gỗ thanh lịch. Nơi đây lưu giữ và tôn vinh kho tàng mỹ thuật đồ sộ của dân tộc, từ tranh lụa, tranh sơn mài đỉnh cao của các danh họa Đông Dương đến tượng điêu khắc tôn giáo cổ truyền.'
WHERE id = '373d3efd-c3cd-4cb2-84aa-41a1d797b540';
UPDATE heritage_info 
SET name = 'Bảo tàng Phụ nữ Việt Nam',
    address = 'Bảo tàng Phụ nữ Việt Nam, Hà Nội',
    latitude = 21.023351,
    longitude = 105.851596,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_129798_1.jpg',
    description = 'Bảo tàng Phụ nữ Việt Nam trên phố Lý Thường Kiệt được bình chọn là một trong những điểm tham quan hấp dẫn nhất châu Á, tôn vinh vai trò kiên cường và vĩ đại của người phụ nữ Việt Nam trong lịch sử dựng nước, giữ nước và gia đình. Các gian trưng bày phong phú từ trang phục truyền thống của phụ nữ 54 dân tộc đến những kỷ vật xúc động trong chiến tranh.'
WHERE id = '924d95d5-14d3-4e27-b4c7-243f588a4192';
UPDATE heritage_info 
SET name = 'Biệt thự Cầu Đá (Bảo Đại)',
    address = 'Biệt thự Cầu Đá (Bảo Đại), Khánh Hòa',
    latitude = 12.210308,
    longitude = 109.215366,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_51494_1.jpg',
    description = 'Biệt thự Cầu Đá, hay Dinh Bảo Đại Nha Trang, gồm cụm 5 tòa biệt thự kiến trúc Pháp cổ kính xây dựng trên mỏm đồi Cảnh Long nhô ra vịnh biển. Đây từng là nơi nghỉ dưỡng của vị hoàng đế cuối cùng triều Nguyễn, sở hữu tầm nhìn 360 độ ngắm trọn vẻ đẹp lộng lẫy của vịnh Nha Trang.'
WHERE id = '093c10a7-3e5d-46c3-bc5b-023f0caabf3f';
UPDATE heritage_info 
SET name = 'Biệt thự Hằng Nga (Crazy House Đà Lạt)',
    address = 'Biệt thự Hằng Nga (Crazy House Đà Lạt), Lâm Đồng',
    latitude = 11.934707,
    longitude = 108.430897,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_173200_1.jpg',
    description = 'Biệt thự Hằng Nga, hay Crazy House, là kiệt tác kiến trúc siêu thực nổi tiếng toàn cầu do kiến trúc sư Đặng Việt Nga thiết kế. Các lối đi hình rễ cây uốn lượn, những căn phòng tựa hốc cây cổ thụ và hình khối phi đối xứng đưa du khách vào một thế giới cổ tích kỳ bí.'
WHERE id = '67d0cb11-171a-425e-af80-e17d0df03f49';
UPDATE heritage_info 
SET name = 'Buôn Akõ Dhông (Buôn Cô Thôn)',
    address = 'Buôn Akõ Dhông (Buôn Cô Thôn), Đắk Lắk',
    latitude = 12.696465,
    longitude = 108.049133,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_31603_1.jpg',
    description = 'Buôn Akõ Dhông là buôn làng cổ tích của người Ê Đê nằm ngay trong lòng thành phố Buôn Ma Thuột. Nơi đây lưu giữ nguyên vẹn hàng chục ngôi nhà dài truyền thống bằng gỗ cùng không gian văn hóa cồng chiêng sống động và phong tục dệt thổ cẩm đặc sắc.'
WHERE id = 'b2fc1f1e-56d0-4e7e-841b-b908bae52d8d';
UPDATE heritage_info 
SET name = 'Cà phê Hide Seek Vietnam',
    address = '31 Trần Phú, Phường Cẩm Châu, Thành phố Hội An, Quảng Nam',
    latitude = 15.8778,
    longitude = 108.3292,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/tro_choi_dan_gian_hide_seek_Vietnam_000030.jpg',
    description = 'Cà phê Hide Seek Vietnam tọa lạc trong khu phố cổ Hội An, nơi kiến trúc truyền thống được bảo tồn tỉ mỉ. Mặt tiền cửa hàng kết hợp những yếu tố cổ điển của nhà phố gỗ, ngói âm dương và các cột gỗ chạm khắc, đồng thời lồng ghép những đường nét hiện đại như kính cường lực và ánh sáng LED mềm mại. Sự giao thoa này không chỉ tạo nên một không gian thương mại hấp dẫn mà còn phản ánh quá trình hội nhập văn hoá du lịch, nơi người dân địa phương và khách quốc tế cùng chiêm ngưỡng vẻ đẹp hài hòa giữa quá khứ và hiện tại. Hide Seek Vietnam trở thành một biểu tượng nhỏ nhưng đầy ý nghĩa, minh chứng cho sự sáng tạo trong việc bảo tồn và phát triển di sản kiến trúc Hội An.'
WHERE id = '25156f4b-d3ad-446d-baaf-81f216fad21e';
UPDATE heritage_info 
SET name = 'Cầu Ánh Sao (Hồ Bán Nguyệt, Phú Mỹ Hưng)',
    address = 'Khu đô thị Phú Mỹ Hưng, Tân Phú, Quận 7, TP. Hồ Chí Minh',
    latitude = 10.724734,
    longitude = 106.718523,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_25073_1.jpg',
    description = 'Cầu Ánh Sao là cây cầu bộ hành hiện đại uốn cong mềm mại qua hồ Bán Nguyệt tại khu đô thị Phú Mỹ Hưng, Quận 7, TP.HCM. Mặt cầu được gắn hàng nghìn bóng đèn led lấp lánh như dải ngân hà kết hợp hệ thống thác nước cầu vồng phun từ hai bên hông cầu tạo nên khung cảnh đêm lãng mạn bậc nhất Sài Gòn.'
WHERE id = '28cbc954-adf3-455b-b6a5-b8fe6b2ceed5';
UPDATE heritage_info 
SET name = 'Chùa Cầu (Cầu Nhật Bản Hội An)',
    address = 'Đường Nguyễn Thị Minh Khai nối Trần Phú, Phố cổ Hội An, Quảng Nam',
    latitude = 15.877142,
    longitude = 108.326019,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/kien_truc_cau_Nhat_Ban_Hoi_An_000049.jpg',
    description = 'Cầu Nhật Bản, còn gọi là Cầu Đá, là một công trình kiến trúc độc đáo nằm trong khu phố cổ Hội An, Quảng Nam. Được xây dựng vào năm 1593 dưới thời chúa Nguyễn Hoàng, cầu mang dấu ấn của phong cách Nhật Bản cổ điển với những khối đá lớn được xếp chặt, tạo nên hình dáng vòm cung thanh thoát. Hai bên cầu được trang trí bằng những bức tượng đá rồng, sư tử và các họa tiết truyền thống, phản ánh sự giao thoa văn hoá giữa Nhật Bản và Việt Nam trong thời kỳ thương mại hải ngoại. Vào buổi tối, ánh đèn vàng ấm áp chiếu rọi lên bề mặt đá, tạo nên một khung cảnh lãng mạn, làm nổi bật không khí yên bình và huyền bí của phố cổ. Cầu Nhật Bản không chỉ là một công trình giao thông mà còn là biểu tượng lịch sử, văn hoá, là điểm dừng chân không thể bỏ qua của du khách khi khám phá di sản thế giới Hội An.'
WHERE id = 'd0d11c3a-2bc6-4cbd-9440-6644d3a80883';
UPDATE heritage_info 
SET name = 'Cầu Rồng Đà Nẵng',
    address = 'Đường Nguyễn Văn Linh nối Võ Văn Kiệt, Quận Hải Châu & Sơn Trà, TP. Đà Nẵng',
    latitude = 16.061168,
    longitude = 108.227897,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/cau_rong_da_nang.jpg',
    description = 'Cầu Rồng bắc qua dòng sông Hàn thơ mộng là kỳ quan kỹ thuật và biểu tượng thịnh vượng của Đà Nẵng hiện đại. Thiết kế mô phỏng hình tượng con rồng thời Lý dũng mãnh vươn mình ra biển Đông, chiếc cầu có khả năng phun lửa và phun nước độc đáo vào các tối cuối tuần, thu hút hàng vạn du khách trong và ngoài nước chiêm ngưỡng.'
WHERE id = '03c9fb22-2a21-417c-a76d-c009cee0154d';
UPDATE heritage_info 
SET name = 'Cầu Trần Thị Lý',
    address = 'Đường Trần Thị Lý nối Duy Tân & Ngũ Hành Sơn, TP. Đà Nẵng',
    latitude = 16.050179,
    longitude = 108.229381,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/cau_tran_thi_ly.jpg',
    description = 'Cầu Trần Thị Lý là một trong những điểm đến di sản tiêu biểu tọa lạc tại Đà Nẵng, lưu giữ những giá trị kiến trúc, văn hóa và cảnh quan thiên nhiên đặc sắc của Việt Nam.'
WHERE id = 'dd96af4e-7464-4794-ab43-2897febf79e3';
UPDATE heritage_info 
SET name = 'Chợ Hàn Đà Nẵng',
    address = '119 Trần Phú, Phường Hải Châu 1, Quận Hải Châu, TP. Đà Nẵng',
    latitude = 16.068352,
    longitude = 108.224283,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/cho_han_da_nang.jpg',
    description = 'Chợ Hàn Đà Nẵng là một trong những điểm đến di sản tiêu biểu tọa lạc tại Đà Nẵng, lưu giữ những giá trị kiến trúc, văn hóa và cảnh quan thiên nhiên đặc sắc của Việt Nam.'
WHERE id = 'a1b1e709-73b4-46fb-8cc0-d5b3296203fc';
UPDATE heritage_info 
SET name = 'Chùa Âng (Chùa Angkorajaborey)',
    address = 'Chùa Âng (Chùa Angkorajaborey), Trà Vinh',
    latitude = 9.915955,
    longitude = 106.303464,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_104896_1.jpg',
    description = 'Chùa Âng là ngôi chùa Khmer cổ kính và tiêu biểu nhất của tỉnh Trà Vinh, tọa lạc bên thắng cảnh ao Bà Om rợp bóng cây sao cổ thụ nghìn năm tuổi. Ngôi chùa mang đậm nghệ thuật kiến trúc Angkor độc đáo với mái ngói nhiều tầng uốn cong hình đuôi rắn Naga và tượng thần chim Krud nâng đỡ diềm mái trang nghiêm.'
WHERE id = '1a275e51-7771-4f2d-834d-93aafc3d89b0';
UPDATE heritage_info 
SET name = 'Chùa Bà Thiên Hậu (Chợ Lớn)',
    address = '710 Nguyễn Trãi, Phường 11, Quận 5, TP. Hồ Chí Minh',
    latitude = 10.753889,
    longitude = 106.659722,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_116334_1.jpg',
    description = 'Chùa Bà Thiên Hậu, hay Tuệ Thành Hội Quán, tọa lạc trên đường Nguyễn Trãi, Quận 5, là một trong những ngôi miếu cổ linh thiêng bậc nhất của cộng đồng người Hoa gốc Quảng Đông dựng từ khoảng năm 1760. Ngôi miếu nổi danh với nghệ thuật đắp nổi gốm nung tinh xảo trên bờ mái tái hiện các điển tích cổ cùng những vòng nhang treo hình xoắn ốc khổng lồ ngát hương trầm.'
WHERE id = '40097db4-35b7-4b5c-b5bc-19825412f709';
UPDATE heritage_info 
SET name = 'Chùa Bút Tháp',
    address = 'Chùa Bút Tháp, Bắc Ninh',
    latitude = 21.061083,
    longitude = 106.022198,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_89882_1.jpg',
    description = 'Chùa Bút Tháp tọa lạc bên bờ sông Đuống thuộc tỉnh Bắc Ninh, là một trong những trung tâm Phật giáo cổ truyền quy mô bậc nhất vùng đồng bằng Bắc Bộ. Ngôi chùa lưu giữ bảo vật quốc gia tượng Phật Bà Quan Âm nghìn mắt nghìn tay bằng gỗ thếp vàng tuyệt mỹ cùng tháp đá Báo Nghiêm hình ngòi bút vươn lên nền trời xanh.'
WHERE id = 'f8987c94-0917-404f-b3dd-9d1fab748cce';
UPDATE heritage_info 
SET name = 'Chùa Đại Giác',
    address = 'Ấp Nhị Hòa, Xã Hiệp Hòa, Thành phố Biên Hòa, Đồng Nai',
    latitude = 10.9275,
    longitude = 106.8127,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_117500_1.jpg',
    description = 'Chùa Đại Giác tọa lạc tại cù lao Phố trên sông Đồng Nai, là một trong những ngôi chùa cổ xưa nhất của vùng đất phương Nam hình thành từ thế kỷ XVII. Ngôi chùa từng là nơi công chúa Ngọc Du ẩn náu trong thời tao loạn, nổi tiếng với pho tượng Phật Di Đà bằng gỗ cao hơn 2 mét thiêng liêng.'
WHERE id = 'ba647be8-3911-42a6-93f2-d8305e20a89e';
UPDATE heritage_info 
SET name = 'Chùa Giác Lâm',
    address = '565 Lạc Long Quân, Phường 10, Tân Bình, TP. Hồ Chí Minh',
    latitude = 10.778262,
    longitude = 106.649213,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_93932_1.jpg',
    description = 'Chùa Giác Lâm tọa lạc trên đường Lạc Long Quân, quận Tân Bình, được xây dựng từ năm 1744, là ngôi chùa cổ nhất còn nguyên vẹn tại Thành phố Hồ Chí Minh. Ngôi chùa mang cấu trúc chữ Tam đặc trưng Nam Bộ với 98 cột gỗ lim chạm khắc câu đối chữ Hán tinh xảo, cây bồ đề cổ thụ linh thiêng và tháp xá lợi 7 tầng hình lục giác uy nghiêm.'
WHERE id = 'fea618f7-c8aa-4b0b-9d4a-ef850d7546cf';
UPDATE heritage_info 
SET name = 'Chùa Giác Viên',
    address = 'Chùa Giác Viên, TP. Hồ Chí Minh',
    latitude = 10.762984,
    longitude = 106.639201,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_90776_1.jpg',
    description = 'Chùa Giác Viên tọa lạc cạnh đầm sen công viên Đầm Sen, Quận 11, là ngôi cổ tự trên 200 năm tuổi mang đậm phong cách kiến trúc chùa truyền thống Nam Bộ. Chùa sở hữu bộ sưu tập hơn 150 pho tượng cổ bằng gỗ quý cùng những bao lam chạm lộng hình tứ linh, mai lan cúc trúc đạt đến trình độ điêu khắc bậc thầy.'
WHERE id = '6e64a470-478e-414b-a552-2948938d57cf';
UPDATE heritage_info 
SET name = 'Chùa Hang (Chùa Phước Điền, Châu Đốc)',
    address = 'Chùa Hang (Chùa Phước Điền, Châu Đốc), An Giang',
    latitude = 10.676938,
    longitude = 105.073165,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_89775_1.jpg',
    description = 'Chùa Hang, hay Phước Điền Tự, ngự trên triền dốc thoai thoải của núi Sam, Châu Đốc, gắn liền với huyền tích về đôi rắn thần biết nghe kinh kệ tu hành. Ngôi chùa độc đáo với hệ thống am động tự nhiên trong lòng núi, các tòa tháp đỏ son uy nghiêm cùng góc nhìn bao quát toàn cảnh những cánh đồng lúa An Giang bát ngát đến tận biên giới Campuchia.'
WHERE id = '16b61ec2-f798-41c2-9448-c5f118562218';
UPDATE heritage_info 
SET name = 'Chùa Hang (Kompong Chrey, Trà Vinh)',
    address = 'Chùa Hang (Kompong Chrey, Trà Vinh), Trà Vinh',
    latitude = 9.887652,
    longitude = 106.34512,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_156825_1.jpg',
    description = 'Chùa Hang, tên chữ Khmer là Kompong Chrey, tọa lạc tại thị trấn Châu Thành, Trà Vinh, nổi tiếng với cổng chùa được thiết kế xuyên qua một hang sâu độc đáo. Khuôn viên chùa rộng lớn rợp bóng cây sao cổ thụ, là nơi cư ngụ của hàng vạn cánh chim trời và lưu giữ xưởng điêu khắc gỗ nghệ thuật từ gốc cây cổ thụ tinh xảo của các nhà sư Khmer.'
WHERE id = '2312eed8-b24b-4342-9e3c-77d482676b36';
UPDATE heritage_info 
SET name = 'Chùa Hoằng Pháp',
    address = 'Chùa Hoằng Pháp, TP. Hồ Chí Minh',
    latitude = 10.900271,
    longitude = 106.581793,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_97846_1.jpg',
    description = 'Chùa Hoằng Pháp tọa lạc tại huyện Hóc Môn, TP.HCM, là một trong những trung tâm hoằng pháp và tu học Phật giáo lớn nhất cả nước do cố Hòa thượng Ngộ Chân Tử sáng lập năm 1957. Ngôi chùa nổi tiếng với các khóa tu mùa hè thu hút hàng vạn thanh thiếu niên, nổi bật với chính điện nguy nga hai tầng mái uốn cong và khuôn viên rợp bóng bồ đề.'
WHERE id = '214104e1-7ff7-4963-8155-6412f5a62218';
UPDATE heritage_info 
SET name = 'Chùa Hội Khánh',
    address = 'Chùa Hội Khánh, Bình Dương',
    latitude = 10.981632,
    longitude = 106.659104,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_71489_1.jpg',
    description = 'Chùa Hội Khánh là ngôi đại cổ tự xây dựng từ năm 1741 tại trung tâm thành phố Thủ Dầu Một, Bình Dương. Ngôi chùa xác lập kỷ lục châu Á với bức tượng Phật Thích Ca nhập Niết bàn bằng bê tông cốt thép ngự trên mái chùa dài 52 mét và cao 12 mét uy nghiêm, nổi bật giữa khuôn viên rợp bóng cây xanh cổ thụ thanh tịnh.'
WHERE id = '6a72a28e-8f6f-48b6-914d-7db5db149f06';
UPDATE heritage_info 
SET name = 'Chùa Huê Nghiêm',
    address = 'Chùa Huê Nghiêm, TP. Hồ Chí Minh',
    latitude = 10.788777,
    longitude = 106.739051,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_46540_1.jpg',
    description = 'Chùa Huê Nghiêm tọa lạc trên đường Đặng Văn Bi, thành phố Thủ Đức, là ngôi đại tự Phật giáo thanh tịnh mang phong cách kiến trúc Á Đông kết hợp hiện đại. Điểm nhấn của chùa là hồ sen thanh tịnh, tháp hoa sen đa tầng vươn cao và quần thể tượng Phật Thích Ca bằng đá cẩm thạch uy nghiêm giữa không gian thiền định xanh mát.'
WHERE id = '2e01420f-3684-4ff7-93a5-13b671164506';
UPDATE heritage_info 
SET name = 'Chùa Kim Liên',
    address = 'Phố Từ Hoa, Quảng An, Tây Hồ, Hà Nội',
    latitude = 21.060278,
    longitude = 105.830556,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_120976_1.jpg',
    description = 'Chùa Kim Liên ngự trên bán đảo Nghi Tàm soi bóng xuống mặt nước hồ Tây êm đềm, được mệnh danh là ''''bông sen vàng'''' kiều diễm của kiến trúc Phật giáo kinh kỳ. Chùa được dựng theo lối kiến trúc chữ Tam độc đáo với ba dãy chùa song song bằng gỗ lim chạm trổ tinh vi mang dấu ấn nghệ thuật thời Tây Sơn.'
WHERE id = 'f2df3353-fcb9-44d9-9e33-f337ae8f7bda';
UPDATE heritage_info 
SET name = 'Chùa Linh Sơn (Đà Lạt)',
    address = 'Chùa Linh Sơn (Đà Lạt), Lâm Đồng',
    latitude = 11.940242,
    longitude = 108.437576,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_97272_1.jpg',
    description = 'Chùa Linh Sơn ngự trên ngọn đồi yên tĩnh cách trung tâm Đà Lạt 700 mét, được xây dựng từ năm 1938 với phong cách kiến trúc Á Đông thanh tịnh. Khuôn viên chùa rợp bóng thông già râm mát, có ao sen nhỏ và đại hồng chung nặng hơn 400 kg ngân nga trầm mặc giữa phố hoa.'
WHERE id = '4f2d74fe-551a-4629-b923-e3c49808dcc4';
UPDATE heritage_info 
SET name = 'Chùa Ngọc Hoàng (Điện Ngọc Hoàng, Đa Kao)',
    address = '73 Mai Thị Lựu, Đa Kao, Quận 1, TP. Hồ Chí Minh',
    latitude = 10.791528,
    longitude = 106.697687,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_154569_1.jpg',
    description = 'Chùa Ngọc Hoàng, hay Phước Hải Tự, ngự tại đường Mai Thị Lựu, Quận 1, là ngôi chùa Đạo giáo cổ kính do cộng đồng người Hoa gốc Quảng Đông xây dựng vào đầu thế kỷ XX. Ngôi chùa ngập tràn khói hương huyền bí với hàng trăm pho tượng gỗ tinh xảo thờ Ngọc Hoàng Thượng Đế, Kim Hoa Thánh Mẫu và từng vinh dự đón Tổng thống Mỹ Barack Obama tới tham quan năm 2016.'
WHERE id = '88078fcb-df9c-488c-8ae8-c2ab5400eac2';
UPDATE heritage_info 
SET name = 'Chùa Quan Âm (Quận 5, Chợ Lớn)',
    address = '12 Lão Tử, Phường 11, Quận 5, TP. Hồ Chí Minh',
    latitude = 10.751667,
    longitude = 106.657778,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_135320_1.jpg',
    description = 'Chùa Quan Âm, hay Ôn Lăng Hội Quán, tọa lạc trên đường Lão Tử, Quận 5, là ngôi đền cổ do cộng đồng người Hoa gốc Phúc Kiến xây dựng từ năm 1740 để phụng thờ Quan Thế Âm Bồ Tát và Thiên Hậu Thánh Mẫu. Ngôi đền nổi bật với nghệ thuật gốm phù điêu tinh xảo trên bờ mái, những vòng hương nhang hình nón tỏa khói trầm mặc và phong tục đánh chuông cầu an linh thiêng.'
WHERE id = '5289dfcd-5c3b-44c8-b65c-07b2da501005';
UPDATE heritage_info 
SET name = 'Chùa Quán Sứ',
    address = 'Chùa Quán Sứ, Hà Nội',
    latitude = 21.024467,
    longitude = 105.845419,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_91317_1.jpg',
    description = 'Chùa Quán Sứ nằm trên phố Quán Sứ, Hà Nội, được khởi dựng từ thế kỷ XV thời nhà Lê làm nơi tiếp đón các sứ thần của các nước láng giềng theo đạo Phật. Ngày nay, ngôi chùa cổ kính rợp bóng bồ đề chính là trụ sở trung ương của Giáo hội Phật giáo Việt Nam, trung tâm học thuật và hoằng pháp thiêng liêng của tăng ni, phật tử cả nước.'
WHERE id = 'ec42a6ff-86dc-4d3f-9557-af8096240086';
UPDATE heritage_info 
SET name = 'Chùa Vạn Niên (Hồ Tây)',
    address = '364 Lạc Long Quân, Xuân La, Tây Hồ, Hà Nội',
    latitude = 21.066207,
    longitude = 105.810948,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_54989_1.jpg',
    description = 'Chùa Vạn Niên tọa lạc tại làng Lạc Long Quân ven bờ hồ Tây, là ngôi chùa cổ hơn 1.000 năm tuổi được xây dựng từ năm 1014 dưới triều vua Lý Thái Tổ. Chùa nổi tiếng với pho tượng Phật Thích Ca bằng ngọc bích tự nhiên nguyên khối nặng hơn 600 kg cùng hệ thống kết cấu gỗ lim chạm trổ rồng mây tinh xảo mang phong cách kiến trúc thời Nguyễn.'
WHERE id = 'ff76cb72-a7f2-408d-8163-e6771bdebd6a';
UPDATE heritage_info 
SET name = 'Chùa Vĩnh Nghiêm (TP.HCM)',
    address = 'Chùa Vĩnh Nghiêm (TP.HCM), TP. Hồ Chí Minh',
    latitude = 10.790397,
    longitude = 106.682377,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_66988_1.jpg',
    description = 'Chùa Vĩnh Nghiêm tọa lạc trên đường Nam Kỳ Khởi Nghĩa, Quận 3, được xây dựng từ năm 1964 theo nguyên mẫu ngôi tổ đình Vĩnh Nghiêm gốc tại Bắc Giang bằng kỹ thuật bê tông cốt thép hiện đại. Ngôi chùa sở hữu tòa tháp Quán Thế Âm 7 tầng cao 40 mét uy nghiêm, là trung tâm sinh hoạt tâm linh và hoằng pháp Phật giáo lớn bậc nhất của cộng đồng Phật tử miền Nam.'
WHERE id = '69620411-f3f5-40bd-a80f-9c5b06513fbd';
UPDATE heritage_info 
SET name = 'Chùa Xá Lợi',
    address = 'Chùa Xá Lợi, TP. Hồ Chí Minh',
    latitude = 10.892771,
    longitude = 106.82567,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_168064_1.jpg',
    description = 'Chùa Xá Lợi tọa lạc tại góc đường Bà Huyện Thanh Quan, Quận 3, được xây dựng từ năm 1956 để phụng thờ xá lợi Phật Thích Ca linh thiêng. Ngôi chùa là một trung tâm lịch sử quan trọng gắn liền với phong trào Phật giáo miền Nam năm 1963, nổi bật với tháp chuông 7 tầng cao 32 mét độc đáo và pho tượng Phật Thích Ca bằng đồng lớn tại chính điện thanh tịnh.'
WHERE id = 'af96b651-15f8-4d15-8169-7c666b849a3e';
UPDATE heritage_info 
SET name = 'Công Viên Châu Á (Asia Park)',
    address = 'Số 1 Phan Đăng Lưu, Phường Hòa Cường Bắc, Quận Hải Châu, TP. Đà Nẵng',
    latitude = 16.038153,
    longitude = 108.225404,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/asia_park_da_nang.jpg',
    description = 'Công Viên Châu Á (Asia Park) là một trong những điểm đến di sản tiêu biểu tọa lạc tại Đà Nẵng, lưu giữ những giá trị kiến trúc, văn hóa và cảnh quan thiên nhiên đặc sắc của Việt Nam.'
WHERE id = '4822d6d9-1227-43fc-bf26-c1daff62e516';
UPDATE heritage_info 
SET name = 'Công viên Văn hóa Đầm Sen',
    address = '03 Hòa Bình, Phường 3, Quận 11, TP. Hồ Chí Minh',
    latitude = 10.764325,
    longitude = 106.638719,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_19534_1.jpg',
    description = 'Công viên Văn hóa Đầm Sen tọa lạc tại Quận 11, TP.HCM, là ốc đảo giải trí xanh mát gắn liền với tuổi thơ của biết bao thế hệ người dân Sài Gòn. Công viên sở hữu hệ thống hàng chục trò chơi mạo hiểm cảm giác mạnh, công viên nước Đầm Sen sôi động, vườn chim thú hoang dã và sân khấu nhạc nước nghệ thuật lung linh.'
WHERE id = 'd730f525-d098-4101-a5af-6904de2621b0';
UPDATE heritage_info 
SET name = 'Cung An Định',
    address = 'Số 2, Đường Thái Thịnh, Phường Phú Nhuận, Thành phố Huế, Thừa Thiên Huế',
    latitude = 16.457413,
    longitude = 107.597971,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/kien_truc_cung_An_Dinh_000047.jpg',
    description = 'Cung An Định là viên ngọc kiến trúc độc đáo bên bờ sông An Cựu ở cố đô Huế, từng là nơi sinh sống của vua Khải Định và hoàng đế Bảo Đại. Tòa lâu đài ba tầng kết hợp hài hòa giữa hoa văn phù điêu La Mã cổ điển với các họa tiết cung đình phương Đông tinh xảo.'
WHERE id = '909a81f2-b273-40d6-87a4-b38410045fe5';
UPDATE heritage_info 
SET name = 'Cung Văn hóa Lao động Hữu nghị Việt - Xô (Quảng trường 1-5)',
    address = 'Cung Văn hóa Lao động Hữu nghị Việt - Xô (Quảng trường 1-5), Hà Nội',
    latitude = 21.022374,
    longitude = 105.844287,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_78442_1.jpg',
    description = 'Cung Văn hóa Lao động Hữu nghị Việt - Xô tọa lạc trên quảng trường 1-5 đường Trần Hưng Đạo, là công trình văn hóa quy mô lớn do Liên Xô trao tặng cho giai cấp công nhân Việt Nam năm 1985. Tòa nhà mang phong cách kiến trúc hiện đại của khối Xã hội Chủ nghĩa với hệ thống hội trường lớn, nhà hát và các phòng sinh hoạt nghệ thuật đa năng.'
WHERE id = 'a7732621-db59-40ed-bcba-b51187dd6ba8';
UPDATE heritage_info 
SET name = 'Đại Nội Huế (Hoàng Thành Huế)',
    address = 'Đại Nội Huế (Hoàng Thành Huế), Thừa Thiên Huế',
    latitude = 16.468973,
    longitude = 107.578127,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_107747_1.jpg',
    description = 'Đại Nội Huế là trung tâm chính trị, văn hóa và quân sự đầu não của triều đại nhà Nguyễn suốt 143 năm, được UNESCO công nhận là Di sản Văn hóa Thế giới năm 1993. Quần thể gồm hàng trăm công trình cung điện nguy nga, miếu thờ thâm nghiêm và hào nước bao quanh theo thế đất phong thủy hoàn hảo.'
WHERE id = 'be919670-07f9-4747-a56a-642fd2a54ec1';
UPDATE heritage_info 
SET name = 'Đan Viện Thánh Mẫu Châu Sơn Đơn Dương',
    address = 'Đan Viện Thánh Mẫu Châu Sơn Đơn Dương, Lâm Đồng',
    latitude = 11.7583,
    longitude = 108.5417,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_95547_1.jpg',
    description = 'Đan viện Thánh Mẫu Châu Sơn là tu viện cổ dòng Xitô tọa lạc giữa thung lũng thanh bình thuộc huyện Đơn Dương, Lâm Đồng. Công trình gây ấn tượng sâu sắc bởi nghệ thuật kiến trúc Gothic hoàn toàn từ gạch đỏ không tô trát, mái vòm vươn cao cổ kính giữa rừng thông tĩnh mịch.'
WHERE id = '8e74e32d-9fac-436d-98a1-e46935cf0d80';
UPDATE heritage_info 
SET name = 'Đảo Hòn Dấu',
    address = 'Đảo Hòn Dấu, Hải Phòng',
    latitude = 20.667237,
    longitude = 106.815891,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_22656_1.jpg',
    description = 'Đảo Hòn Dấu là viên ngọc xanh hoang sơ nằm cách bán đảo Đồ Sơn, Hải Phòng chưa đầy một hải lý, nổi tiếng với rừng nguyên sinh nhiệt đới đa tầng nguyên vẹn và ngọn hải đăng hơn 100 năm tuổi. Nơi đây còn có đền thờ Nam Hải Thần Vương linh thiêng được các ngư dân miền biển thành kính phụng thờ.'
WHERE id = '233d51dc-fc42-490e-bf82-1c09dfba32d2';
UPDATE heritage_info 
SET name = 'Đền Hai Bà Trưng (Mê Linh)',
    address = 'Đền Hai Bà Trưng (Mê Linh), Hà Nội',
    latitude = 21.012199,
    longitude = 105.855182,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_25693_1.jpg',
    description = 'Đền Hai Bà Trưng tọa lạc tại làng Hạ Lôi, huyện Mê Linh, Hà Nội, là mảnh đất quê hương và cũng là nơi hai nữ anh hùng dân tộc Trưng Trắc - Trưng Nhị phất cờ khởi nghĩa giành độc lập vào năm 40 sau Công nguyên. Quần thể đền mang kiến trúc ''''nội công ngoại quốc'''' bề thế, lưu giữ nhiều sắc phong, đồ thờ cổ quý giá cùng lễ hội rước kiệu thiêng liêng đầu xuân.'
WHERE id = '9f95bdc1-4ed6-48dd-836b-641edcbf569c';
UPDATE heritage_info 
SET name = 'Đền Kim Liên (Kim Liên Tứ Trấn)',
    address = 'Đền Kim Liên (Kim Liên Tứ Trấn), Hà Nội',
    latitude = 21.01068,
    longitude = 105.838139,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_104622_1.jpg',
    description = 'Đền Kim Liên tọa lạc tại phường Phương Liên, quận Đống Đa, là trấn phía Nam trong cụm di tích Thăng Long Tứ Trấn linh thiêng bảo vệ kinh thành Thăng Long xưa. Ngôi đền thờ thần Cao Sơn Đại Vương, nổi bật với hệ thống văn bia cổ, cổng tam quan bề thế và nghệ thuật chạm khắc gỗ thời Lê trung hưng đặc sắc.'
WHERE id = 'e705e3c1-86e9-4795-a4d0-222e47ec6f11';
UPDATE heritage_info 
SET name = 'Đền Quán Thánh (Trấn Vũ Quán)',
    address = 'Đền Quán Thánh (Trấn Vũ Quán), Hà Nội',
    latitude = 21.043006,
    longitude = 105.836587,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_151011_1.jpg',
    description = 'Đền Quán Thánh ngự tại ngã tư đường Thanh Niên và Quán Thánh nhìn ra hồ Tây, là trấn phía Bắc trong Thăng Long Tứ Trấn được lập từ thời vua Lý Thái Tổ. Ngôi đền Đạo giáo thờ thần Huyền Thiên Trấn Vũ, nổi tiếng với bức tượng thần bằng đồng đen nguyên khối đúc năm 1677 cao gần 4 mét và nặng 4 tấn được xem là kiệt tác đúc đồng cổ.'
WHERE id = 'de8f6daf-906f-4bc7-ba71-ceb14c1cebf3';
UPDATE heritage_info 
SET name = 'Điện Kính Thiên (Hoàng thành Thăng Long)',
    address = 'Điện Kính Thiên (Hoàng thành Thăng Long), Hà Nội',
    latitude = 21.036792,
    longitude = 105.840426,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_152437_1.jpg',
    description = 'Điện Kính Thiên là hạt nhân trung tâm quan trọng bậc nhất của Hoàng thành Thăng Long, nơi cử hành các đại lễ quốc gia trọng thể nhất của các triều đại phong kiến Đại Việt. Hiện nay khu di tích còn lưu giữ nguyên vẹn đôi rồng đá thời Lê sơ thế kỷ XV với nghệ thuật điêu khắc đá đạt đến đỉnh cao tinh xảo.'
WHERE id = 'ec5b685a-7c60-47f6-9195-529b0ee43952';
UPDATE heritage_info 
SET name = 'Đình làng Đinh Lăng',
    address = 'Đình làng Đinh Lăng, Xã Cao Hy, Huyện Hải Lăng, Tỉnh Quảng Trị, Việt Nam',
    latitude = 17.799791,
    longitude = 106.223453,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/kien_truc_dinh_lang_Viet_Nam_000012.jpg',
    description = 'Đình làng Đinh Lăng tọa lạc tại xã Cao Hy, huyện Hải Lăng, tỉnh Quảng Trị, là một công trình kiến trúc mang đậm dấu ấn cung đình Huế. Được xây dựng theo kiểu nhà rường, công trình sử dụng khung gỗ chặt, mái ngói âm dương, và các họa tiết chạm khắc tinh xảo trên trần và cột, phản ánh sự giao thoa giữa kiến trúc cung đình và truyền thống làng xã. Khác với nhà cổ Huế, nơi tập trung vào không gian nghi lễ hoàng gia, và nhà sàn Tây Nguyên, vốn dựa vào khung sàn nâng lên để thích nghi với khí hậu, nhà rường Đinh Lăng có kết cấu khép kín, tường gạch và mái ngói dày, tạo nên sự bền vững và thẩm mỹ đặc trưng. Đình không chỉ là nơi hội họp, lễ hội của cộng đồng mà còn là biểu tượng văn hoá, lưu giữ những giá trị lịch sử, phong tục và nghệ thuật chạm khắc truyền thống của người dân Quảng Trị.'
WHERE id = 'bcfbc7cc-8727-416c-9d2e-cb3453da261d';
UPDATE heritage_info 
SET name = 'Đồi Cù (Sân golf Đà Lạt)',
    address = 'Đồi Cù (Sân golf Đà Lạt), Lâm Đồng',
    latitude = 11.946772,
    longitude = 108.444621,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_179766_1.jpg',
    description = 'Đồi Cù là quần thể đồi cỏ thoai thoải xanh mướt uốn lượn ôm trọn bờ hồ Xuân Hương thơ mộng của Đà Lạt. Từng là sân golf cổ nhất Việt Nam do Vua Bảo Đại sáng lập, nơi đây nổi bật với thảm thực vật ôn đới và hàng thông reo lãng mạn.'
WHERE id = '4dc35f66-34e5-4319-9926-8dc3c98e79a7';
UPDATE heritage_info 
SET name = 'Động Phong Nha',
    address = 'Động Phong Nha, Xã Phong Nha, Huyện Bố Trạch, Tỉnh Quảng Bình, Việt Nam',
    latitude = 17.580111,
    longitude = 106.283996,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/phong_canh_Phong_Nha_cave_000002.jpg',
    description = 'Động Phong Nha, nằm trong khu bảo tồn thiên nhiên Phong Nha – Kẻ Bàng, tỉnh Quảng Bình, là một trong những hệ thống hang động karst lớn và cổ nhất thế giới. Được hình thành hơn 400 triệu năm trước qua quá trình hòa tan đá vôi dưới tác động của nước ngầm, hang chứa hơn 150 km đường đi trong các phòng, thạch nhũ và sông ngầm, trong đó Động Phong Nha là phần chính, dài khoảng 7,5 km và có các thạch nhũ khổng lồ, thạch nhũ trụ xanh lục độc đáo. Năm 2003, khu vực được UNESCO công nhận là Di sản Thiên nhiên Thế giới, khẳng định giá trị sinh thái và địa chất vô cùng quan trọng. Động không chỉ thu hút du khách trong nước mà còn là điểm đến quốc tế, góp phần thúc đẩy phát triển kinh tế địa phương và nâng cao nhận thức bảo tồn môi trường. Các tour thám hiểm, thuyền ngầm và hoạt động nghiên cứu khoa học thường xuyên được tổ chức, làm phong phú thêm di sản văn hoá và thiên nhiên của Việt Nam.'
WHERE id = 'dfcf707b-1b62-4338-9dbe-29a5dac23dd1';
UPDATE heritage_info 
SET name = 'Hầm vượt sông Sài Gòn (Hầm Thủ Thiêm)',
    address = 'Hầm Thủ Thiêm, Quận 1 & TP. Thủ Đức, TP. Hồ Chí Minh',
    latitude = 10.769702,
    longitude = 106.707918,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_35438_1.jpg',
    description = 'Hầm Thủ Thiêm là hầm dìm vượt sông đầu tiên tại Việt Nam và hiện đại nhất Đông Nam Á khi khánh thành năm 2011, nối liền trung tâm Quận 1 với bán đảo Thủ Thiêm qua lòng sông Sài Gòn. Công trình giao thông ngầm thế kỷ này đã mở toang cánh cửa phát triển rực rỡ cho khu đô thị mới Thủ Thiêm và diện mạo hiện đại của thành phố mang tên Bác.'
WHERE id = 'c6a0276c-3fc7-4845-9eff-f73e8b976a83';
UPDATE heritage_info 
SET name = 'Hồ Hữu Tiệp (Xác máy bay B52)',
    address = 'Hồ Hữu Tiệp (Xác máy bay B52), Hà Nội',
    latitude = 21.037939,
    longitude = 105.827093,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_26854_1.jpg',
    description = 'Hồ Hữu Tiệp nằm giữa làng hoa Ngọc Hà yên bình, là nơi lưu giữ nguyên vẹn một phần xác máy bay ném bom chiến lược B-52 của Mỹ bị bắn rơi trong chiến dịch ''''Hà Nội - Điện Biên Phủ trên không'''' năm 1972. Mặt hồ tĩnh lặng với mảnh xác máy bay thép nhô lên trên mặt nước là chứng tích hào hùng và biểu tượng bất khuất của thủ đô.'
WHERE id = '5b177a52-ae32-4fa9-9169-14637209e954';
UPDATE heritage_info 
SET name = 'Hồ Thác Bà',
    address = 'Hồ Thác Bà, Yên Bái',
    latitude = 21.879122,
    longitude = 104.934378,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_128228_1.jpg',
    description = 'Hồ Thác Bà thuộc tỉnh Yên Bái là một trong ba hồ nước nhân tạo lớn nhất Việt Nam, hình thành khi đập thủy điện Thác Bà chặn dòng sông Chảy. Với hơn 1.300 hòn đảo lớn nhỏ rợp bóng cây xanh soi bóng xuống làn nước ngọc bích, hồ được ví như vịnh Hạ Long trên núi ngút ngàn của vùng Tây Bắc.'
WHERE id = 'feae3036-e3a5-40e4-9cea-99fcb531b435';
UPDATE heritage_info 
SET name = 'InterContinental Danang Sun Peninsula Resort',
    address = 'InterContinental Danang Sun Peninsula Resort, Đà Nẵng',
    latitude = 16.121088,
    longitude = 108.306136,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_149535_1.jpg',
    description = 'InterContinental Danang là kiệt tác nghỉ dưỡng xa hoa do kiến trúc sư huyền thoại Bill Bensley kiến tạo, ẩn mình giữa sườn đồi thoai thoải của bán đảo Sơn Trà. Khu nghỉ dưỡng kết hợp tài tình kiến trúc đền đài cổ Việt Nam với bốn tầng Heavenly, Sky, Earth và Sea dẫn thẳng ra bãi biển riêng tư biệt lập.'
WHERE id = 'b5f5f5bf-ae62-4e59-9955-053024a22037';
UPDATE heritage_info 
SET name = 'Khách sạn InterContinental Nha Trang',
    address = 'Khách sạn InterContinental Nha Trang, Khánh Hòa',
    latitude = 12.245045,
    longitude = 109.195791,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_79053_1.jpg',
    description = 'InterContinental Nha Trang là khách sạn nghỉ dưỡng 5 sao sang trọng tọa lạc tại vị trí đắc địa nhất trên đại lộ Trần Phú ôm trọn vịnh Nha Trang xanh ngọc. Với kiến trúc đương đại thanh lịch cùng các tiện ích chuẩn quốc tế, nơi đây mang đến kỳ nghỉ dưỡng biển đẳng cấp và hoàn hảo.'
WHERE id = 'ae52c7e8-5226-472d-8491-16e688d5890a';
UPDATE heritage_info 
SET name = 'Kinh thành Huế – Ngọ Môn (ban đêm)',
    address = 'Đoàn Thị Điểm, Thuận Hòa, Thành phố Huế, Thừa Thiên Huế',
    latitude = 16.4674,
    longitude = 107.5778,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/kien_truc_kinh_thanh_Hue_000039.jpg',
    description = 'Kinh thành Huế, di sản văn hoá thế giới được UNESCO công nhận, là trung tâm chính trị, văn hoá của triều đại Nguyễn (1802‑1945). Ngọ Môn, cổng chính phía nam của thành, được xây dựng theo phong cách kiến trúc cung đình truyền thống, với mái ngói âm dương, cột gỗ chạm khắc tinh xảo và các bức tượng rồng, phượng tượng trưng cho quyền lực hoàng gia. Khi ánh đèn hiện đại chiếu sáng vào ban đêm, Ngọ Môn hiện lên trong một bức tranh ánh sáng hài hòa, tôn vinh vẻ đẹp cổ kính đồng thời khắc họa sự giao thoa giữa truyền thống và công nghệ. Hình ảnh này không chỉ là minh chứng cho giá trị lịch sử, kiến trúc độc đáo của Kinh thành Huế mà còn là biểu tượng của niềm tự hào dân tộc, ghi lại dấu ấn sâu sắc trong tâm trí du khách và người dân Việt Nam.'
WHERE id = '245547c7-f0db-4568-b42f-fcd3ff08b240';
UPDATE heritage_info 
SET name = 'Lăng Khải Định',
    address = 'Lăng Khải Định, Đại Nam, Thủy Bằng, Phường Thủy Xuân, Thành phố Huế, Thừa Thiên Huế, Việt Nam',
    latitude = 16.399017,
    longitude = 107.590339,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/kien_truc_lang_Khai_Dinh_000018.jpg',
    description = 'Lăng Khải Định, công trình tôn nghiêm của Vua Khải Định (1925‑1932), tọa lạc tại Đại Nam, Thủy Bằng, Phường Thủy Xuân, thành phố Huế, Thừa Thiên Huế. Được xây dựng từ năm 1925 đến 1932, lăng là biểu tượng tiêu biểu cho sự giao thoa giữa kiến trúc truyền thống Việt Nam và phong cách Art Deco, Baroque của phương Tây. Kiến trúc sư người Pháp Victor Bastin cùng các nghệ nhân địa phương đã kết hợp các yếu tố như mái ngói âm dương, cột gỗ chạm khắc tinh xảo, cùng các chi tiết trang trí bằng đá cẩm thạch, đồng và gốm sứ màu sắc rực rỡ. Nội thất lăng được trang hoàng bằng các bức tượng, tranh vẽ, và đồ trang sức hoàng gia, phản ánh gu thẩm mỹ cá tính và hiện đại của vua Khải Định. Lăng không chỉ là nơi an táng hoàng gia mà còn là công trình nghệ thuật độc đáo, thể hiện sự hội nhập văn hoá Đông‑Tây trong thời kỳ cuối cùng của triều Nguyễn.'
WHERE id = 'bae2b1d4-d837-44dc-a79c-314a4f2432f8';
UPDATE heritage_info 
SET name = 'Lăng Minh Mạng',
    address = 'Lăng Minh Mạng, Khu Lăng Minh Mạng, Phường Kim Long, Thành phố Huế, Thừa Thiên Huế, Việt Nam',
    latitude = 16.387754,
    longitude = 107.567783,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/kien_truc_lang_Minh_Mang_000038.jpg',
    description = 'Lăng Minh Mạng (tên đầy đủ: Lăng Minh Mạng – Thế Tông) là lăng mộ của Hoàng đế Minh Mạng (1820‑1841), vị vua thứ ba của triều Nguyễn, được xây dựng từ năm 1831 đến 1833 ngay trong khu vực Khu Lăng Minh Mạng thuộc Khu Di tích Cố đô Huế, Thừa Thiên Huế. Kiến trúc lăng mang đậm phong cách cung đình Huế, kết hợp hài hòa giữa các yếu tố kiến trúc truyền thống và cảnh quan thiên nhiên: cổng tam quan rêu phong, tháp chính bằng đá cẩm thạch, các gian nội thất được trang trí bằng gỗ chạm khắc tinh xảo và ngói âm dương. Bố cục đối xứng, các khu vực lễ nghi, thờ cúng và khu vực nghỉ ngơi được bố trí theo nguyên tắc phong thủy, thể hiện quan niệm “trời đất hòa hợp”. Lăng Minh Mạng không chỉ là chứng nhân của nghệ thuật xây dựng đỉnh cao thời Nguyễn mà còn là biểu tượng của quyền lực, uy nghi và truyền thống tôn kính tổ tiên của dân tộc Việt Nam, được UNESCO công nhận là di sản văn hóa thế giới.'
WHERE id = '159c6856-f84c-4538-ae24-7ce5fe7920f6';
UPDATE heritage_info 
SET name = 'Làng mộc Kim Bồng',
    address = 'Làng mộc Kim Bồng, Quảng Nam',
    latitude = 15.864517,
    longitude = 108.325302,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_134053_1.jpg',
    description = 'Làng mộc Kim Bồng có lịch sử hơn 500 năm nằm hữu ngạn sông Thu Bồn đối diện phố cổ Hội An, nổi tiếng với kỹ nghệ đóng tàu thuyền và dựng nhà gỗ cổ truyền. Các nghệ nhân tài hoa của làng chính là những người đã góp phần trùng tu và gìn giữ nét kiến trúc bằng gỗ độc đáo của di sản đô thị cổ Hội An.'
WHERE id = '9e633da5-535c-45e0-93c6-854122adc942';
UPDATE heritage_info 
SET name = 'Lăng Tự Đức (Khiêm Lăng)',
    address = 'Lăng Tự Đức (Khiêm Lăng), Thừa Thiên Huế',
    latitude = 16.433181,
    longitude = 107.564586,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/kien_truc_lang_Tu_Duc_000024.jpg',
    description = 'Lăng Tự Đức là một trong những công trình lăng tẩm thơ mộng nhất của triều Nguyễn, được xây dựng như một chốn nghỉ dưỡng thứ hai giữa rừng thông reo và hồ Lưu Khiêm êm ả. Lối kiến trúc thanh nhã với nhà tạ sen, sân cầu thơ và các công trình mang chữ ''''Khiêm'''' phản ánh tâm hồn thi sĩ lãng mạn mà u buồn của vị vua hiền.'
WHERE id = '02ccb432-9d46-418b-8988-7a1c4b995ca5';
UPDATE heritage_info 
SET name = 'Miếu Nhị Phủ (Chùa Ông Bổn)',
    address = '264 Hải Thượng Lãn Ông, Phường 14, Quận 5, TP. Hồ Chí Minh',
    latitude = 10.751389,
    longitude = 106.654167,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_117745_1.jpg',
    description = 'Miếu Nhị Phủ, hay Chùa Ông Bổn, tọa lạc tại đường Hải Thượng Lãn Ông, Quận 5, là hội quán cổ kính bậc nhất do cộng đồng người Hoa gốc Phúc Châu và Tuyền Châu dựng nên từ cuối thế kỷ XVII. Ngôi miếu nổi danh với nghệ thuật đắp nổi sành sứ tinh xảo trên bờ nóc uốn cong hình thuyền buồm cùng tượng Phúc Đức Chính Thần phù hộ cho việc kinh doanh phát đạt.'
WHERE id = '5b7d0cc6-2daa-415f-9b53-2950061bf4a2';
UPDATE heritage_info 
SET name = 'Nhà Cổ Hội An',
    address = 'Phố Cổ Hội An, Thị trấn Hội An, Thành phố Hội An, Quảng Nam',
    latitude = 15.877053,
    longitude = 108.327358,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/kien_truc_nha_co_Hoi_An_000010.jpg',
    description = 'Nhà cổ Hội An là những công trình kiến trúc truyền thống đặc trưng của khu phố cổ Hội An, được xây dựng từ thế kỷ XVII đến XIX, phản ánh sự giao thoa văn hoá Đông – Tây trong thời kỳ thương mại sầm uất. Các ngôi nhà thường có nền gạch men, mái ngói âm dương, cửa sổ gỗ chạm khắc tinh xảo và các chi tiết trang trí bằng gốm sứ, đồng. Bố cục không gian nội thất hài hòa, kết hợp giữa phòng khách rộng rãi, phòng ngủ ấm cúng và sân thượng mở, tạo nên môi trường sinh hoạt thoáng đãng, phù hợp với khí hậu nhiệt đới. Nhà cổ không chỉ là di sản kiến trúc mà còn là biểu tượng của sự giàu có, tinh thần thương mại và đa dạng văn hoá của người dân Hội An, góp phần quan trọng vào việc bảo tồn và phát huy giá trị lịch sử, du lịch của thành phố.'
WHERE id = '3e98db0b-ba27-464a-9de2-528f80552219';
UPDATE heritage_info 
SET name = 'Nhà thờ Cha Tam (Nhà thờ Thánh Phanxicô Xaviê)',
    address = 'Nhà thờ Cha Tam (Nhà thờ Thánh Phanxicô Xaviê), TP. Hồ Chí Minh',
    latitude = 10.75272,
    longitude = 106.65397,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_198060_1.jpg',
    description = 'Nhà thờ Cha Tam, hay Nhà thờ Thánh Phanxicô Xaviê, tọa lạc tại trung tâm khu phố người Hoa Chợ Lớn, được xây dựng từ năm 1900 mang đậm phong cách kiến trúc Gothic phương Tây kết hợp hoa văn chữ Hán Á Đông. Cổng tam quan nhà thờ uốn mái cong lợp ngói âm dương, là nơi lưu giữ dấu tích lịch sử đặc biệt gắn liền với sự biến cố chính trường miền Nam năm 1963.'
WHERE id = '0787d2a6-bcc9-4532-8119-0f961d755f40';
UPDATE heritage_info 
SET name = 'Nhà Thờ Chính Tòa Đà Nẵng (Nhà Thờ Con Gà)',
    address = '156 Trần Phú, Phường Hải Châu 1, Quận Hải Châu, TP. Đà Nẵng',
    latitude = 16.066683,
    longitude = 108.223058,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/nha_tho_con_ga_da_nang.jpg',
    description = 'Nhà thờ Chính tòa Đà Nẵng (quen gọi là Nhà thờ Con Gà) được khởi công xây dựng từ thời Pháp thuộc năm 1923. Công trình nổi bật với sắc hồng pastel ngọt ngào, đường nét kiến trúc Gothic thanh thoát với các cửa sổ vòm cung nhọn lắp kính màu lộng lẫy và tượng con gà bằng hợp kim trên đỉnh tháp chuông đóng vai trò cột thu lôi kiêm chỉ hướng gió.'
WHERE id = '8e52fc58-0e3c-427a-a74c-c40332655aa4';
UPDATE heritage_info 
SET name = 'Nhà thờ Núi Nha Trang (Nhà thờ Chính Tòa)',
    address = 'Nhà thờ Núi Nha Trang (Nhà thờ Chính Tòa), Khánh Hòa',
    latitude = 12.246733,
    longitude = 109.188137,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_25569_1.jpg',
    description = 'Nhà thờ Núi Nha Trang sừng sững trên mỏm núi Bông trung tâm thành phố, là công trình kiến trúc Gothic phương Tây tráng lệ bằng đá nhân tạo xây dựng từ năm 1928. Những ô cửa kính màu lung linh và tháp chuông ngân vang tạo nên không gian tâm linh trang trọng, bình yên giữa lòng phố biển.'
WHERE id = 'f015a089-0e84-40a2-b0fc-4359c3f3729c';
UPDATE heritage_info 
SET name = 'Nhà thờ Thánh Giuse (Quận 1)',
    address = '06 Tôn Đức Thắng, Bến Nghé, Quận 1, TP. Hồ Chí Minh',
    latitude = 10.781944,
    longitude = 106.705833,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_18959_1.jpg',
    description = 'Nhà thờ Thánh Giuse tọa lạc trên đường Nguyễn Bỉnh Khiêm, Quận 1, nguyên là nhà thờ thuộc Đại Chủng viện Thánh Giuse Sài Gòn được xây dựng từ năm 1863 thời kỳ đầu Pháp thuộc. Tòa thánh đường nhỏ xinh mang phong cách kiến trúc Romanesque thanh nhã với những hàng cột đá nguyên khối và vòm trần cao tĩnh mịch giữa vườn cây xanh râm mát.'
WHERE id = '14a91b83-9cdc-40ba-ae40-ecab0832f6ed';
UPDATE heritage_info 
SET name = 'Nhà thờ Thánh Jeanne d''Arc (Nhà thờ Ngã Sáu)',
    address = 'Nhà thờ Thánh Jeanne d''Arc (Nhà thờ Ngã Sáu), TP. Hồ Chí Minh',
    latitude = 10.757028,
    longitude = 106.667376,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_62827_1.jpg',
    description = 'Nhà thờ Thánh Jeanne d''Arc (Nhà thờ Ngã Sáu) là một trong những điểm đến di sản tiêu biểu tọa lạc tại TP. Hồ Chí Minh, lưu giữ những giá trị kiến trúc, văn hóa và cảnh quan thiên nhiên đặc sắc của Việt Nam.'
WHERE id = '75136ea2-30ba-4f1d-ab56-46fff509fddc';
UPDATE heritage_info 
SET name = 'Nhà Trưng Bày Hoàng Sa',
    address = 'Đường Hoàng Sa, Phường Thọ Quang, Quận Sơn Trà, TP. Đà Nẵng',
    latitude = 16.093458,
    longitude = 108.251203,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/nha_trung_bay_hoang_sa.jpg',
    description = 'Nhà trưng bày Hoàng Sa là công trình văn hóa và bảo tàng tư liệu đặc biệt nằm bên bờ biển đường Hoàng Sa, Sơn Trà. Nơi đây lưu giữ hàng trăm hiện vật, bản đồ cổ phương Tây, châu bản triều Nguyễn và tư liệu lịch sử pháp lý minh chứng hùng hồn cho chủ quyền không thể chối cãi của Việt Nam đối với quần đảo Hoàng Sa.'
WHERE id = '263fecde-6852-42bc-82be-66f74d7875ea';
UPDATE heritage_info 
SET name = 'Phố cổ Hội An',
    address = 'Phố cổ Hội An, Phường Cẩm Châu, Thành phố Hội An, Quảng Nam, Việt Nam',
    latitude = 15.879166,
    longitude = 108.323789,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/phong_canh_Hoi_An_ancient_town_000006.jpg',
    description = 'Phố cổ Hội An, một di sản văn hoá thế giới được UNESCO công nhận, tọa lạc tại thành phố Hội An, tỉnh Quảng Nam, miền Trung Việt Nam. Được xây dựng từ thế kỷ 15, khu phố giữ nguyên những ngôi nhà cổ mang kiến trúc pha trộn giữa phong cách Việt, Trung, Nhật và Bồ Đào Nha, phản ánh lịch sử thương mại quốc tế phong phú của vùng. Vào lúc hoàng hôn, những chiếc đèn lồng đỏ rực rỡ treo khắp các con phố, tạo nên một khung cảnh lãng mạn, gợi nhớ đến những truyền thuyết và phong tục lễ hội truyền thống. Đèn lồng không chỉ là biểu tượng thịnh vượng mà còn là nét văn hoá đặc trưng, thu hút hàng triệu du khách mỗi năm. Sự hài hòa giữa thiên nhiên, ánh sáng và kiến trúc cổ kính khiến Phố cổ Hội An trở thành một trong những điểm đến tiêu biểu nhất của du lịch văn hoá Việt Nam.'
WHERE id = 'ac079b1d-d9d3-4be8-8515-591e8780c2a3';
UPDATE heritage_info 
SET name = 'Phủ Chủ tịch',
    address = 'Phủ Chủ tịch, Hà Nội',
    latitude = 21.039302,
    longitude = 105.834432,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_14034_1.jpg',
    description = 'Phủ Chủ tịch tọa lạc gần Quảng trường Ba Đình, nguyên là Dinh Toàn quyền Đông Dương được kiến trúc sư Auguste Henri Vildieu thiết kế xây dựng từ năm 1900 đến 1906 theo phong cách Phục hưng Pháp cổ điển. Tòa nhà quét vôi vàng sang trọng, hiện nay là nơi diễn ra các lễ đón tiếp nguyên thủ quốc gia và các sự kiện ngoại giao quan trọng của Việt Nam.'
WHERE id = 'd5857479-eba9-43bf-b0c8-5fcc58a32082';
UPDATE heritage_info 
SET name = 'Quần đảo Hải Tặc (Hà Tiên)',
    address = 'Quần đảo Hải Tặc (Hà Tiên), Kiên Giang',
    latitude = 10.317412,
    longitude = 104.329768,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_34610_1.jpg',
    description = 'Quần đảo Hải Tặc gồm 16 hòn đảo lớn nhỏ nằm trong vịnh Thái Lan thuộc thành phố Hà Tiên, Kiên Giang, từng là căn cứ khét tiếng của các băng cướp biển lộng hành thế kỷ XVII - XVIII. Ngày nay, quần đảo khoác lên mình vẻ đẹp hoang sơ tĩnh lặng với những bãi cát trắng mịn, rặng dừa nghiêng soi bóng và nguồn hải sản tươi ngon tuyệt vời.'
WHERE id = '42579380-5a53-4462-be16-76b47fa09533';
UPDATE heritage_info 
SET name = 'Saigon Centre (Takashimaya)',
    address = 'Saigon Centre (Takashimaya), TP. Hồ Chí Minh',
    latitude = 10.772949,
    longitude = 106.700657,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_44907_1.jpg',
    description = 'Saigon Centre tọa lạc trên đại lộ Lê Lợi sầm uất tại trung tâm Quận 1, là tổ hợp trung tâm thương mại và tháp văn phòng cao cấp chuẩn quốc tế bậc nhất TP.HCM. Tòa nhà là nơi đặt trung tâm thương mại Takashimaya đầu tiên tại Việt Nam, quy tụ hàng trăm thương hiệu xa xỉ toàn cầu cùng không gian ẩm thực phong phú và sang trọng.'
WHERE id = 'cf97223f-4963-43b8-a30d-6437af82f151';
UPDATE heritage_info 
SET name = 'Thánh thất Đa Phước',
    address = 'Thánh thất Đa Phước, Lâm Đồng',
    latitude = 11.944273,
    longitude = 108.50256,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_119206_1.jpg',
    description = 'Thánh thất Đa Phước là thánh đường Cao Đài lớn nhất tỉnh Lâm Đồng, ngự trên sườn đồi thoai thoải hướng nhìn xuống rừng thông thơ mộng. Kiến trúc rực rỡ sắc màu với biểu tượng Thiên Nhãn, hai tháp chuông cao vút và các họa tiết chạm trổ rồng phụng tạo nên vẻ đẹp tôn giáo trang nghiêm, huyền bí.'
WHERE id = 'f883ddc9-494c-4e3e-83ee-d69cebcc57a1';
UPDATE heritage_info 
SET name = 'Tháp Hòa Phong (Hồ Gươm)',
    address = 'Đinh Tiên Hoàng, Tràng Tiền, Hoàn Kiếm, Hà Nội',
    latitude = 21.026336,
    longitude = 105.853313,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_19621_1.jpg',
    description = 'Tháp Hòa Phong nằm bên bờ đông hồ Hoàn Kiếm, là di tích cổ kính duy nhất còn sót lại của đại danh lam chùa Báo Ân nổi tiếng thế kỷ XIX. Tòa tháp vuông ba tầng bằng gạch nung rêu phong trầm mặc mang dáng dấp cổ xưa, là gạch nối thiêng liêng giữa ký ức kinh kỳ xưa và nhịp sống đô thị hôm nay.'
WHERE id = 'e38ea413-f379-4966-ac7f-1c9be90cbae1';
UPDATE heritage_info 
SET name = 'Thiền viện Vạn Hạnh (Đà Lạt)',
    address = 'Thiền viện Vạn Hạnh (Đà Lạt), Lâm Đồng',
    latitude = 11.964003,
    longitude = 108.443616,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_3113_1.jpg',
    description = 'Thiền viện Vạn Hạnh nổi danh với pho tượng Phật Thích Ca niêm hoa vi tiếu bằng đồng vàng cao 24 mét ngự trên đỉnh đồi lộng gió tại Đà Lạt. Từ sân thiền viện, du khách có thể phóng tầm mắt chiêm ngưỡng bức tranh thung lũng nông nghiệp trù phú và những rặng thông xanh ngút ngàn.'
WHERE id = 'a9d514ec-804f-490c-a5b9-7e5009099b6d';
UPDATE heritage_info 
SET name = 'Thung Lũng Vàng Đà Lạt',
    address = 'Thôn Lạt Đồng, Xã Lát, Lạc Dương, Lâm Đồng',
    latitude = 11.986667,
    longitude = 108.38,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_58815_1.jpg',
    description = 'Thung Lũng Vàng nằm cách trung tâm Đà Lạt 15 km, nép mình dưới chân núi Langbiang với những đồi thông trập trùng bên mặt hồ Đan Kia êm đềm. Khung cảnh nên thơ với đồi cỏ hồng mộng mơ và những vườn đá phong thủy tạo nên không gian thư thái tuyệt đối.'
WHERE id = '769c8c69-6e26-41ae-8c5d-bf291ec28153';
UPDATE heritage_info 
SET name = 'Tịnh xá Trung Tâm',
    address = '21 Nguyễn Trung Trực, Phường 5, Bình Thạnh, TP. Hồ Chí Minh',
    latitude = 10.812222,
    longitude = 106.690833,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_112557_1.jpg',
    description = 'Tịnh xá Trung Tâm tọa lạc trên đường Nguyễn Trung Trực, quận Bình Thạnh, là ngôi tổ đình đầu tiên và quan trọng nhất của Hệ phái Phật giáo Khất sĩ Việt Nam do Tổ sư Minh Đăng Quang sáng lập. Ngôi tịnh xá nổi bật với chính điện bát giác độc đáo bằng gỗ quý, bảo tháp tứ giác vươn cao thanh thoát và không gian thiền môn thanh tịnh giữa lòng đô thị.'
WHERE id = 'a7bbf2bf-f90e-42ea-abd5-421da0e9ae01';
UPDATE heritage_info 
SET name = 'Bạch Dinh (Villa Blanche)',
    address = '04 Trần Phú, Phường 1, Vũng Tàu, Bà Rịa - Vũng Tàu',
    latitude = 10.350737,
    longitude = 107.068642,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_119243_1.jpg',
    description = 'Bạch Dinh là dinh thự nghỉ dưỡng sang trọng mang kiến trúc châu Âu cuối thế kỷ XIX, tọa lạc trên sườn Núi Lớn nhìn thẳng ra vịnh biển Vũng Tàu. Tòa nhà cao ba tầng sơn trắng tinh khôi được trang trí bằng các bức phù điêu chân dung Hy Lạp cổ đại cùng bộ sưu tập đồ gốm sứ trục vớt từ các con tàu đắm cổ vô giá.'
WHERE id = '0c8e6a9e-4d9b-4791-8cb5-001b5ab6d633';
UPDATE heritage_info 
SET name = 'Bãi biển Quy Nhơn',
    address = 'Bãi biển Quy Nhơn, Phường Quy Nhơn, Thành phố Quy Nhơn, Tỉnh Bình Định, Việt Nam',
    latitude = 13.7667,
    longitude = 109.2333,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/phong_canh_bien_Quy_Nhon_000001.jpg',
    description = 'Bãi biển Quy Nhơn nằm ở thành phố Quy Nhơn, tỉnh Bình Định, là một trong những điểm du lịch ven biển nổi bật của miền Trung Việt Nam. Với bờ cát trắng mịn, làn nước trong xanh và sóng nhẹ, nơi đây mang đến khung cảnh thiên nhiên hoang sơ, đồng thời được quy hoạch hiện đại với các khu nghỉ dưỡng, công viên ven biển và lối đi bộ dọc bờ. Địa danh này không chỉ thu hút khách du lịch trong nước mà còn là điểm dừng chân của du khách quốc tế nhờ sự kết hợp hài hòa giữa vẻ đẹp tự nhiên và hạ tầng đô thị. Bãi biển Quy Nhơn còn là nơi tổ chức các lễ hội văn hoá địa phương, như hội chợ hải sản và các hoạt động thể thao nước, góp phần bảo tồn và phát huy giá trị văn hoá, sinh thái của khu vực.'
WHERE id = 'fe41196d-625b-41c2-8046-c518fbe963fd';
UPDATE heritage_info 
SET name = 'Bán Đảo Sơn Trà & Chùa Linh Ứng Bãi Bụt',
    address = 'Khu vực Bãi Bụt, Bán đảo Sơn Trà, Quận Sơn Trà, TP. Đà Nẵng',
    latitude = 16.1002,
    longitude = 108.276,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/chua_linh_ung_son_tra.jpg',
    description = 'Bán đảo Sơn Trà được mệnh danh là viên ngọc quý và lá phổi xanh của Đà Nẵng với hệ sinh thái rừng nhiệt đới trù phú cùng loài voọc chà vá chân nâu quý hiếm. Tọa lạc tại Bãi Bụt trên sườn bán đảo, Chùa Linh Ứng nổi bật với Đại tượng Phật Bà Quán Thế Âm cao 67m uy nghiêm, lưng tựa núi non, mắt hướng ra đại dương bao la cầu quốc thái dân an.'
WHERE id = '5b4ee06b-cbc0-4b14-990d-b29195b86838';
UPDATE heritage_info 
SET name = 'Bảo tàng Chứng tích Chiến tranh',
    address = '28 Võ Văn Tần, Phường 6, Quận 3, TP. Hồ Chí Minh',
    latitude = 10.779365,
    longitude = 106.692281,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_26359_1.jpg',
    description = 'Bảo tàng Chứng tích Chiến tranh tọa lạc trên đường Võ Văn Tần, Quận 3, là một trong những bảo tàng thu hút đông đảo du khách quốc tế nhất tại Việt Nam, ghi dấu những tội ác chiến tranh và hậu quả tàn khốc của chất độc da cam đối với dân tộc. Bảo tàng trưng bày nhiều hiện vật chiến tranh giá trị, máy bay, xe tăng chiến lợi phẩm và phòng tranh ảnh ''''Hồi niệm'''' xúc động lòng người.'
WHERE id = '3ee08e01-44f0-4e88-b612-9863bd963ac8';
UPDATE heritage_info 
SET name = 'Bảo tàng Dân tộc học Việt Nam',
    address = 'Đường Nguyễn Văn Huyên, Quan Hoa, Cầu Giấy, Hà Nội',
    latitude = 21.040077,
    longitude = 105.79884,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_140932_1.jpg',
    description = 'Bảo tàng Dân tộc học Việt Nam trên đường Nguyễn Văn Huyên là trung tâm nghiên cứu và bảo tồn văn hóa sống động của 54 dân tộc anh em trên dải đất hình chữ S. Khuôn viên ngoài trời rộng lớn rợp bóng cây xanh trưng bày nguyên bản những ngôi nhà rông Tây Nguyên cao vút, nhà dài Ê Đê, nhà sàn Thái và nhà mồ Gia Rai độc đáo.'
WHERE id = '8b3ed65e-d5df-46a6-b254-1a1203876cde';
UPDATE heritage_info 
SET name = 'Bảo tàng Hà Nội',
    address = 'Bảo tàng Hà Nội, Hà Nội',
    latitude = 21.0116,
    longitude = 105.7547,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_55647_1.jpg',
    description = 'Bảo tàng Hà Nội tọa lạc trên đường Phạm Hùng, gây ấn tượng mạnh mẽ với kiến trúc hình kim tự tháp ngược độc đáo gồm bốn tầng nổi vươn dần ra ngoài. Bảo tàng trưng bày hàng vạn hiện vật, cổ vật quý hiếm tái hiện chặng đường lịch sử hơn 1.000 năm hào hùng và diện mạo đổi mới của thủ đô ngàn năm văn hiến.'
WHERE id = '118bac73-fe5f-4dba-8d77-640ec69acff5';
UPDATE heritage_info 
SET name = 'Bảo tàng Lịch sử Quân sự Việt Nam',
    address = '28A Điện Biên Phủ, Điện Biên, Ba Đình, Hà Nội',
    latitude = 21.011587,
    longitude = 105.754706,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_149285_1.jpg',
    description = 'Bảo tàng Lịch sử Quân sự Việt Nam nằm trên đại lộ Thăng Long, là một trong những bảo tàng quốc gia lớn nhất cả nước trưng bày hàng vạn hiện vật lịch sử chiến tranh vô giá. Không gian trưng bày hiện đại lưu giữ bốn bảo vật quốc gia gồm máy bay tiêm kích MiG-21 và xe tăng T-54 huyền thoại đã lập nên những mốc son chói lọi trong lịch sử bảo vệ Tổ quốc.'
WHERE id = 'c70efbc5-c21e-4938-8b47-d36e6f0db9fc';
UPDATE heritage_info 
SET name = 'Bảo tàng Lịch sử TP. Hồ Chí Minh',
    address = 'Bảo tàng Lịch sử TP. Hồ Chí Minh, TP. Hồ Chí Minh',
    latitude = 10.788,
    longitude = 106.705,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_27048_1.jpg',
    description = 'Bảo tàng Lịch sử TP.HCM nằm trong khuôn viên Thảo Cầm Viên, là kiệt tác kiến trúc Đông Dương kết hợp giữa nghệ thuật cung đình phương Đông và kỹ thuật xây dựng Pháp do kiến trúc sư Auguste Delaval thiết kế năm 1929. Bảo tàng trưng bày hàng chục nghìn cổ vật quý báu từ thời nguyên thủy, văn hóa Óc Eo Phù Nam kỳ bí đến xác ướp Xóm Cải nổi tiếng.'
WHERE id = '74934c12-17fc-4079-91c3-91033a5b7649';
UPDATE heritage_info 
SET name = 'Bảo tàng Mỹ thuật TP. Hồ Chí Minh',
    address = 'Bảo tàng Mỹ thuật TP. Hồ Chí Minh, TP. Hồ Chí Minh',
    latitude = 10.7692,
    longitude = 106.6997,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_71126_1.jpg',
    description = 'Bảo tàng Mỹ thuật TP.HCM tọa lạc trên đường Phó Đức Chính, nguyên là tư dinh lộng lẫy của đại phú gia Hứa Bổn Hòa (chú Hỏa) xây dựng đầu thế kỷ XX. Tòa dinh thự ba tầng mang phong cách Art Deco kết hợp hài hòa mỹ thuật Baroque Pháp và hoa văn Á Đông, nổi tiếng với thang máy cổ bằng gỗ đầu tiên của Sài Gòn và những hành lang kính màu tráng lệ.'
WHERE id = 'a462e1cf-6dd1-48d5-afd2-2d8beb5b1316';
UPDATE heritage_info 
SET name = 'Bảo tàng Thành phố Hồ Chí Minh (Dinh Gia Long)',
    address = 'Bảo tàng Thành phố Hồ Chí Minh (Dinh Gia Long), TP. Hồ Chí Minh',
    latitude = 10.7759,
    longitude = 106.6996,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_51835_1.jpg',
    description = 'Bảo tàng Thành phố Hồ Chí Minh tọa lạc trên đường Lý Tự Trọng, nguyên là Dinh Thống đốc Nam Kỳ do kiến trúc sư người Pháp Alfred Foulhoux thiết kế xây dựng từ năm 1885 đến 1890. Tòa dinh thự cổ điển châu Âu tráng lệ lưu giữ hàng nghìn hiện vật khảo cổ học, lịch sử đấu tranh cách mạng cùng hệ thống đường hầm trú ẩn ngầm kiên cố dưới tầng hầm.'
WHERE id = '5fa24f7b-2523-48b3-b5dd-6c17e4fe6de2';
UPDATE heritage_info 
SET name = 'Bến Nhà Rồng',
    address = 'Số 01 Nguyễn Tất Thành, Phường 12, Quận 4, TP. Hồ Chí Minh',
    latitude = 10.768285,
    longitude = 106.706645,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_151058_1.jpg',
    description = 'Bến Nhà Rồng nằm bên ngã ba sông Sài Gòn, nguyên là trụ sở của hãng tàu buôn Pháp Messageries Maritimes xây dựng từ năm 1863 với đôi rồng gốm uốn lượn chầu mặt trăng trên đỉnh mái ngói. Nơi đây đã đi vào lịch sử dân tộc khi người thanh niên yêu nước Nguyễn Tất Thành ra đi tìm đường cứu nước vào ngày 5 tháng 6 năm 1911.'
WHERE id = 'bc5ee05f-9606-498e-8569-70e91e2d503a';
UPDATE heritage_info 
SET name = 'Biển Đà Nẵng',
    address = 'Bờ biển thành phố Đà Nẵng, Đà Nẵng, Việt Nam',
    latitude = 16.0683,
    longitude = 108.2467,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/phong_canh_bien_Da_Nang_000065.jpg',
    description = 'Biển Đà Nẵng là dải bờ biển dài khoảng 30 km trải dài từ khu vực Bán đảo Sơn Trà tới bờ sông Hàn, nằm trong khu vực đô thị hiện đại của thành phố Đà Nẵng, tỉnh miền Trung Việt Nam. Với cát trắng mịn, nước biển trong xanh và sóng nhẹ, bãi biển không chỉ là điểm thu hút du khách trong và ngoài nước mà còn là nơi người dân địa phương tận hưởng không gian giải trí, thể thao và dã ngoại. Đặc trưng của Biển Đà Nẵng là sự hài hòa giữa vẻ đẹp tự nhiên hoang sơ và các công trình kiến trúc hiện đại như cầu Rồng, cầu Sông Hàn, khu nghỉ dưỡng sang trọng và các khu công viên ven biển. Nhờ vị trí địa lý thuận lợi, hạ tầng giao thông phát triển và môi trường sạch sẽ, Biển Đà Nẵng đã trở thành biểu tượng của sự phát triển bền vững, phản ánh tinh thần năng động, sáng tạo và khát vọng hội nhập của thành phố.'
WHERE id = 'a5708200-c948-4e82-9ce2-a83ef3e4f791';
UPDATE heritage_info 
SET name = 'Biển Sầm Sơn',
    address = 'Bãi biển Sầm Sơn, thành phố Sầm Sơn, tỉnh Thanh Hóa, Việt Nam',
    latitude = 19.74,
    longitude = 105.9083,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/phong_canh_bien_Sam_Son_000055.jpg',
    description = 'Biển Sầm Sơn, nằm ở thành phố Sầm Sơn, tỉnh Thanh Hóa, là một trong những bãi biển nổi tiếng nhất miền Bắc Việt Nam. Với vị trí địa lý gần Hà Nội, Sầm Sơn đã phát triển mạnh mẽ về cơ sở hạ tầng du lịch: các khu nghỉ dưỡng, khách sạn, khu vui chơi giải trí và hệ thống giao thông hiện đại, đáp ứng nhu cầu của hàng triệu lượt du khách mỗi năm. So với các bãi biển miền Trung như Đà Nẵng, Nha Trang hay Phú Quốc, Sầm Sơn giữ được nét đặc trưng của biển miền Bắc – khí hậu mát mẻ, sóng nhẹ và bãi cát trắng mịn. Về văn hoá du lịch, Sầm Sơn nổi bật với các lễ hội truyền thống, ẩm thực địa phương phong phú và các hoạt động thể thao biển, tạo nên một mô hình du lịch kết hợp giữa tiện nghi hiện đại và bản sắc địa phương, khác biệt rõ rệt so với các điểm du lịch biển miền Trung và Nam Bộ.'
WHERE id = 'fed52192-2393-4713-aa73-b3c3eec10181';
UPDATE heritage_info 
SET name = 'Bưu điện Trung tâm Sài Gòn',
    address = '02 Công xã Paris, Bến Nghé, Quận 1, TP. Hồ Chí Minh',
    latitude = 10.779956,
    longitude = 106.699992,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_35573_1.jpg',
    description = 'Bưu điện Trung tâm Sài Gòn nằm đối diện Nhà thờ Đức Bà, được xây dựng từ năm 1886 đến 1891 theo đồ án của kiến trúc sư Marie-Alfred Foulhoux với phong cách chiết trung châu Âu kết hợp hoa văn phương Đông. Tòa nhà gây ấn tượng bởi mái vòm cong kim loại đồ sộ gợi nhớ các nhà ga cổ điển châu Âu, những quầy bưu chính bằng gỗ bóng loáng và hai bức bản đồ lịch sử vẽ tay trên tường.'
WHERE id = '320c9c55-64f5-4f22-8877-ee0cfa48fd9a';
UPDATE heritage_info 
SET name = 'Căn cứ The Rockpile (Đồi Elliot)',
    address = 'Căn cứ The Rockpile (Đồi Elliot), Quảng Trị',
    latitude = 16.7583,
    longitude = 106.9417,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_136610_1.jpg',
    description = 'Căn cứ The Rockpile là một tháp đá vôi tự nhiên cao 240 mét nằm chơ vơ bên đường 9 thuộc tỉnh Quảng Trị, từng là tiền đồn quan sát chiến lược trọng yếu của thủy quân lục chiến Mỹ trong chiến tranh Việt Nam. Địa danh này là một chứng tích lịch sử tiêu biểu về tuyến hàng rào điện tử McNamara và những năm tháng khói lửa.'
WHERE id = 'c00511f1-6abd-4833-92cf-84cad5e7d187';
UPDATE heritage_info 
SET name = 'Cầu Bãi Cháy',
    address = 'Bãi Cháy, Thành phố Hạ Long, Quảng Ninh',
    latitude = 20.960159,
    longitude = 107.06579,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_133325_1.jpg',
    description = 'Cầu Bãi Cháy là cây cầu dây văng một mặt phẳng dây đầu tiên của Việt Nam, vắt ngang eo biển Cửa Lục nối liền hai khu vực Hòn Gai và Bãi Cháy của thành phố Hạ Long. Với chiều dài hơn 900 mét và độ cao thông thuyền 50 mét, cây cầu tựa như một cánh cung thanh thoát in bóng xuống vịnh di sản.'
WHERE id = '60f4524e-1aab-4316-96f0-b92a650143fa';
UPDATE heritage_info 
SET name = 'Cầu Cần Thơ',
    address = 'Sông Hậu, Cần Thơ & Vĩnh Long',
    latitude = 10.102944,
    longitude = 105.49603,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_174562_1.jpg',
    description = 'Cầu Cần Thơ là cây cầu dây văng có nhịp chính dài nhất Đông Nam Á khi hoàn thành năm 2010, bắc qua dòng sông Hậu nối liền đôi bờ Cần Thơ và Vĩnh Long. Hai tháp cầu hình chữ Y ngược cao 171 mét sừng sững giữa ngút ngàn sông nước miền Tây, là đòn bẩy thúc đẩy kinh tế - xã hội bứt phá cho toàn vùng đồng bằng sông Cửu Long.'
WHERE id = '3c6c5ff3-caba-4f70-a166-dd7d75dd8e2e';
UPDATE heritage_info 
SET name = 'Cầu Chương Dương',
    address = 'Cầu Chương Dương, Hoàn Kiếm, Hà Nội',
    latitude = 21.0406,
    longitude = 105.858,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_30807_1.jpg',
    description = 'Cầu Chương Dương là cây cầu thép lớn đầu tiên hoàn toàn do các kỹ sư và công nhân Việt Nam tự lực thiết kế và thi công vượt qua dòng sông Hồng vào thập niên 1980. Cây cầu là tuyến giao thông huyết mạch kiên cường nối liền trung tâm thủ đô với các tỉnh thành phía bắc và lưu giữ những ký ức không thể nào quên của thời kỳ đổi mới.'
WHERE id = 'ac8cb7dc-6c44-4f8d-9ad4-36cf41906767';
UPDATE heritage_info 
SET name = 'Cầu Cốc Lếu',
    address = 'Cầu Cốc Lếu, Thành phố Lào Cai, Lào Cai',
    latitude = 22.503159,
    longitude = 103.968486,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_152501_1.jpg',
    description = 'Cầu Cốc Lếu là cây cầu lịch sử bắc qua dòng sông Hồng chảy vào đất Việt tại trung tâm thành phố cửa khẩu Lào Cai. Được xây dựng lại khang trang với dầm vòm thép uốn lượn và hệ thống chiếu sáng hiện đại, cây cầu là biểu tượng giao thương sầm uất và tình hữu nghị biên giới vùng Tây Bắc.'
WHERE id = '0e678576-79ef-4000-bf47-37fb78e1601d';
UPDATE heritage_info 
SET name = 'Cầu Long Biên',
    address = 'Cầu Long Biên, Hoàn Kiếm, Hà Nội',
    latitude = 21.04314,
    longitude = 105.858175,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_152377_1.jpg',
    description = 'Cầu Long Biên là cây cầu thép lịch sử vắt ngang sông Hồng do công ty Daydé & Pillé nước Pháp xây dựng từ năm 1898 đến năm 1902, từng là một trong những cây cầu dài nhất thế giới thời bấy giờ. Trải qua hơn một thế kỷ với hai cuộc chiến tranh ác liệt, cây cầu tựa như một chứng nhân lịch sử kiên cường bằng thép của thủ đô Hà Nội.'
WHERE id = '31ead606-0ea2-483a-9328-a794a9d28427';
UPDATE heritage_info 
SET name = 'Cầu Mỹ Thuận',
    address = 'Cầu Mỹ Thuận, Tiền Giang',
    latitude = 10.2774,
    longitude = 105.91,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_60252_1.jpg',
    description = 'Cầu Mỹ Thuận khánh thành năm 2000, là cây cầu dây văng đầu tiên bắc qua sông Tiền nối liền hai tỉnh Tiền Giang và Vĩnh Long với sự hợp tác giữa chính phủ Việt Nam và Australia. Cây cầu đã chấm dứt nhiều thập kỷ cảnh phà tắc nghẽn, mở toang cánh cửa giao thương huyết mạch cho vùng vựa lúa trù phú miền Tây Nam Bộ.'
WHERE id = '75d0c517-17f9-4f92-a5d0-8bb922feecaf';
UPDATE heritage_info 
SET name = 'Cầu Nhật Tân',
    address = 'Cầu Nhật Tân, Tây Hồ, Hà Nội',
    latitude = 21.098494,
    longitude = 105.82329,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_93615_1.jpg',
    description = 'Cầu Nhật Tân là cây cầu dây văng nhiều nhịp lớn nhất Việt Nam bắc qua sông Hồng, được xây dựng bằng nguồn vốn hỗ trợ phát triển chính thức ODA của Nhật Bản. Với năm trụ tháp kim cương tượng trưng cho năm cửa ô lịch sử của Hà Nội, cây cầu lung linh ánh đèn đa sắc khi đêm về nối liền nội đô với sân bay quốc tế Nội Bài.'
WHERE id = '804a7f77-47a2-41db-89a2-e02b00aff4a4';
UPDATE heritage_info 
SET name = 'Cầu Phú Mỹ',
    address = 'Cầu Phú Mỹ, Quận 7 & TP. Thủ Đức, TP. Hồ Chí Minh',
    latitude = 10.749,
    longitude = 106.744,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_113331_1.jpg',
    description = 'Cầu Phú Mỹ là cây cầu dây văng lớn nhất Thành phố Hồ Chí Minh bắc qua sông Sài Gòn, kết nối Quận 7 với thành phố Thủ Đức. Với chiều dài hơn 2.000 mét và tháp đôi hình chữ H cao 145 mét sừng sững, cây cầu là cửa ngõ giao thông huyết mạch đưa luồng hàng hóa từ các cảng biển lớn lưu thông nhanh chóng.'
WHERE id = 'd0ce2e97-4f9f-4a0b-af08-87e59fa11637';
UPDATE heritage_info 
SET name = 'Cầu Quay Sông Hàn',
    address = 'Đường Lê Duẩn nối Phạm Văn Đồng, Quận Hải Châu & Sơn Trà, TP. Đà Nẵng',
    latitude = 16.0723,
    longitude = 108.2267,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/cau_quay_song_han.jpg',
    description = 'Cầu Sông Hàn là cây cầu quay đầu tiên và duy nhất do chính các kỹ sư và công nhân Việt Nam thiết kế, thi công với sự đồng lòng đóng góp của nhân dân Đà Nẵng. Vào mỗi đêm khuya, nhịp giữa của cầu có thể quay một góc 90 độ dọc theo dòng nước để mở luồng cho các tàu thuyền lớn qua lại, tượng trưng cho sức sống và sự năng động của thành phố.'
WHERE id = 'eef6e36f-5996-446e-ad60-9a7be658508a';
UPDATE heritage_info 
SET name = 'Cầu Thê Húc',
    address = 'Hồ Hoàn Kiếm, Hoàn Kiếm, Hà Nội',
    latitude = 21.030769,
    longitude = 105.852782,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/kien_truc_cau_The_Huc_000010.jpg',
    description = 'Cầu Thê Húc mang ý nghĩa ''''nơi lưu giữ ánh sáng ban mai'''', là cây cầu gỗ màu đỏ son cong hình con tôm uốn lượn nối bờ hồ Hoàn Kiếm dẫn vào đền Ngọc Sơn cổ kính. Được danh sĩ Nguyễn Văn Siêu cho xây dựng năm 1865, cây cầu là một trong những biểu tượng thị giác lãng mạn và đặc trưng nhất của thủ đô ngàn năm văn hiến.'
WHERE id = '6b99559a-5407-494a-8a3b-8ba97e0b83a2';
UPDATE heritage_info 
SET name = 'Cầu Thuận Phước',
    address = 'Hải Châu & Sơn Trà, Thành phố Đà Nẵng',
    latitude = 16.094808,
    longitude = 108.220013,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_199566_1.jpg',
    description = 'Cầu Thuận Phước là cây cầu treo dây võng dài nhất Việt Nam, bắc qua cửa biển nơi dòng sông Hàn hòa vào vịnh Đà Nẵng. Với chiều dài hơn 1.800 mét và hệ thống đèn led đổi màu lung linh khi màn đêm buông xuống, cây cầu tựa như một dải lụa phát sáng mềm mại nối đôi bờ vịnh biển.'
WHERE id = 'e3656439-fb89-4001-b353-4302f729c5c8';
UPDATE heritage_info 
SET name = 'Cầu Tình Yêu Đà Nẵng',
    address = 'Đường Trần Hưng Đạo, Phường An Hải Tây, Quận Sơn Trà, TP. Đà Nẵng',
    latitude = 16.0617,
    longitude = 108.2294,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/cau_tinh_yeu_da_nang.jpg',
    description = 'Cầu Tình Yêu Đà Nẵng nằm bên bờ đông sông Hàn, trên đường Trần Hưng Đạo, ngay cạnh Tượng Cá Chép Hóa Rồng và gần đầu Cầu Rồng. Được lấy cảm hứng từ những cây cầu khóa tình yêu lãng mạn nổi tiếng thế giới như Pont des Arts hay Milvio, cầu có hình vòng cung uốn lượn hướng ra sông với những cột đèn lồng hình trái tim đỏ rực rỡ. Đây là điểm check-in yêu thích của các cặp đôi để gắn những ổ khóa minh chứng cho tình yêu vĩnh cửu.'
WHERE id = '63baaf3f-8e8d-4d3d-9475-0475978adbb9';
UPDATE heritage_info 
SET name = 'Cầu Vàng – Bà Nà Hills',
    address = 'Khu du lịch Bà Nà Hills, xã Hòa Vang, thành phố Đà Nẵng, Việt Nam',
    latitude = 15.9949,
    longitude = 107.9963,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/cau_vang_ba_na.jpg',
    description = 'Cầu Vàng, còn được biết đến với tên gọi Golden Bridge, là một công trình kiến trúc hiện đại nổi bật nằm trên đỉnh núi Bà Nà, thuộc thành phố Đà Nẵng. Được khánh thành vào năm 2018, cầu dài 150 mét, rộng 6 mét, được thiết kế bởi kiến trúc sư người Pháp Marc Mimram, nổi bật với hai cột đá khổng lồ hình người khổng lồ (còn gọi là "cây khổng lồ") nâng đỡ toàn bộ cấu trúc. Vị trí cao trên độ cao hơn 1.400 mét so với mực nước biển, cùng với khung cảnh núi rừng xanh mướt và sương mù nhẹ, tạo nên một khung cảnh thơ mộng, thu hút hàng triệu du khách trong và ngoài nước. Cầu Vàng không chỉ là biểu tượng của sự sáng tạo trong kiến trúc du lịch mà còn là điểm nhấn quan trọng của khu du lịch Bà Nà Hills, góp phần quảng bá vẻ đẹp thiên nhiên và văn hoá hiện đại của miền Trung Việt Nam.'
WHERE id = 'cac2e5c0-90dc-41e9-be97-ba3bd5e66bbe';
UPDATE heritage_info 
SET name = 'Chợ Bến Thành',
    address = 'Đường Lê Lợi, Bến Thành, Quận 1, TP. Hồ Chí Minh',
    latitude = 10.77253,
    longitude = 106.698037,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_155319_1.jpg',
    description = 'Chợ Bến Thành là biểu tượng thương mại và văn hóa lâu đời của Thành phố Hồ Chí Minh, được khánh thành từ năm 1914 với tháp đồng hồ bốn mặt đặc trưng nơi cửa Nam. Khu chợ sầm uất quy tụ hàng nghìn gian hàng bày bán phong phú từ vải vóc, đồ lưu niệm thủ công mỹ nghệ đến khu ẩm thực nức tiếng với bún riêu, bánh xèo, chè ngọt đậm đà hương vị phương Nam.'
WHERE id = '72c33b0d-b575-4bfc-a481-0669e1fa0c1e';
UPDATE heritage_info 
SET name = 'Chợ Đà Lạt',
    address = 'Đường Nguyễn Thị Minh Khai, Phường 1, Đà Lạt, Lâm Đồng',
    latitude = 11.943436,
    longitude = 108.437178,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_41376_1.jpg',
    description = 'Chợ Đà Lạt là trung tâm giao thương sầm uất mang dấu ấn kiến trúc độc đáo của kiến trúc sư Ngô Viết Thụ. Khi hoàng hôn buông xuống, khu chợ đêm trở thành thiên đường ẩm thực đường phố với bánh tráng nướng, sữa đậu nành nóng và các loại mứt đặc sản hấp dẫn.'
WHERE id = 'aca475b2-9c5e-4074-b42c-6033ad0e83d7';
UPDATE heritage_info 
SET name = 'Chợ Đồng Xuân',
    address = 'Đồng Xuân, Hoàn Kiếm, Hà Nội',
    latitude = 21.038256,
    longitude = 105.849671,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_164543_1.jpg',
    description = 'Chợ Đồng Xuân được người Pháp thành lập năm 1889, là khu chợ đầu mối bán buôn lớn và lâu đời nhất khu phố cổ Hà Nội với mặt tiền năm vòm cuốn đặc trưng. Khu chợ ba tầng sầm uất ngập tràn hàng nghìn sạp hàng vải vóc, quần áo và các món quà vặt ẩm thực nức tiếng đất kinh kỳ như chả que tre, chè thập cẩm.'
WHERE id = 'fedc5b30-74fa-45c8-9ebd-615124fc1493';
UPDATE heritage_info 
SET name = 'Chùa Bích Động',
    address = 'Chùa Bích Động, Ninh Bình',
    latitude = 20.2181,
    longitude = 105.9144,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_79723_1.jpg',
    description = 'Chùa Bích Động được chúa Trịnh Sâm ban tặng danh hiệu ''''Nam thiên đệ nhị động'''', là ngôi chùa cổ độc đáo tọa lạc trong lòng hang núi đá vôi thuộc quần thể Tràng An, Ninh Bình. Chùa được dựng theo ba tầng Hạ, Trung và Thượng men theo sườn núi rêu phong, soi bóng xuống đầm sen thơm ngát qua cây cầu đá mộc mạc.'
WHERE id = '7a6f49be-3191-4909-8c87-d2d52ae8d67f';
UPDATE heritage_info 
SET name = 'Chùa Cổ Lễ (Thần Quang Tự)',
    address = 'Chùa Cổ Lễ (Thần Quang Tự), Nam Định',
    latitude = 20.3542,
    longitude = 106.275,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_145173_1.jpg',
    description = 'Chùa Cổ Lễ, hay Thần Quang Tự, ngự tại huyện Trực Ninh, Nam Định, là ngôi danh lam cổ tự do quốc sư Nguyễn Minh Không sáng lập từ thời nhà Lý. Chùa nổi danh với tháp Cửu Phẩm Liên Hoa 12 tầng cao 32 mét độc đáo kết hợp nghệ thuật chùa tháp truyền thống với đường nét kiến trúc Gothic phương Tây và quả chuông đồng Đại Hồng Chung nặng 9 tấn.'
WHERE id = '040b4c86-2e03-4804-b978-dd54a50bcd34';
UPDATE heritage_info 
SET name = 'Chùa Dâu (Chùa Cổ Pháp)',
    address = 'Chùa Dâu (Chùa Cổ Pháp), Bắc Ninh',
    latitude = 21.0359,
    longitude = 106.0425,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_51698_1.jpg',
    description = 'Chùa Dâu tọa lạc tại thị xã Thuận Thành, Bắc Ninh, là ngôi chùa Phật giáo cổ xưa nhất Việt Nam được khởi dựng từ thế kỷ thứ II sau Công nguyên tại trung tâm trị sở Giao Châu cổ. Ngôi chùa là cái nôi của trung tâm Phật giáo Luy Lâu nổi tiếng với tháp Hòa Phong ba tầng bằng gạch nung cổ kính và tín ngưỡng Tứ Pháp linh thiêng.'
WHERE id = '4ab88fd9-2333-4312-a89b-e5cad701705d';
UPDATE heritage_info 
SET name = 'Chùa Hương (Quần thể Hương Sơn)',
    address = 'Xã Hương Sơn, Mỹ Đức, Hà Nội',
    latitude = 21.004393,
    longitude = 105.851764,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_76871_1.jpg',
    description = 'Chùa Hương là quần thể danh thắng tâm linh Phật giáo nổi tiếng bậc nhất miền Bắc, tọa lạc giữa thung lũng đá vôi non nước hữu tình ven dòng suối Yến ở Mỹ Đức, Hà Nội. Hàng năm vào mỗi độ xuân về, lễ hội Chùa Hương thu hút hàng vạn khách hành hương chèo thuyền vãn cảnh và chiêm bái động Hương Tích kỳ vĩ.'
WHERE id = '6d795bc8-afb7-49cb-bc21-a227b937e4ea';
UPDATE heritage_info 
SET name = 'Chùa Linh Phước (Chùa Ve Chai)',
    address = '120 Tự Phước, Trại Mát, Đà Lạt, Lâm Đồng',
    latitude = 11.94428,
    longitude = 108.499399,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_137130_1.jpg',
    description = 'Chùa Linh Phước, hay Chùa Ve Chai, là kiệt tác kiến trúc khảm sành sứ độc nhất vô nhị tọa lạc tại Trại Mát, Đà Lạt. Ngôi chùa sở hữu con rồng dài 49 mét uốn lượn quanh sân được ghép từ 12.000 vỏ chai bia cùng tháp chuông 7 tầng lưu giữ chuông đại hồng chung linh thiêng.'
WHERE id = '0380e78b-6d1d-4c1c-990b-af9cc74388e6';
UPDATE heritage_info 
SET name = 'Chùa Một Cột',
    address = 'Phố Chùa Một Cột, Đội Cấn, Ba Đình, Hà Nội',
    latitude = 21.035856,
    longitude = 105.833614,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_121481_1.jpg',
    description = 'Chùa Một Cột, hay Diên Hựu Tự, được vua Lý Thái Tông cho xây dựng năm 1049, là biểu tượng kiến trúc tâm linh độc nhất vô nhị của thủ đô Hà Nội. Ngôi chùa bằng gỗ tựa như một đóa hoa sen thanh khiết vươn lên từ mặt hồ Linh Chiểu nhờ một cột đá trụ duy nhất, phản ánh đỉnh cao triết lý Phật giáo và tài hoa mỹ thuật Đại Việt.'
WHERE id = '6af65ea1-ec3d-4af6-81db-46ec375ca6ef';
UPDATE heritage_info 
SET name = 'Chùa Phật Tích',
    address = 'Chùa Phật Tích, Bắc Ninh',
    latitude = 21.0937,
    longitude = 106.0263,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_10877_1.jpg',
    description = 'Chùa Phật Tích ngự trên sườn núi Lan Kha thuộc huyện Tiên Du, Bắc Ninh, là ngôi cổ tự linh thiêng khởi dựng từ thế kỷ XI thời nhà Lý. Chùa là nơi lưu giữ bảo vật quốc gia pho tượng Phật A Di Đà bằng đá xanh ngồi thiền trên tòa sen cổ nhất Việt Nam cùng hàng tượng linh thú đá nghìn năm tuổi uy nghiêm.'
WHERE id = '22091615-0b42-481a-abc6-47a403e0b808';
UPDATE heritage_info 
SET name = 'Chùa Thiên Mụ (Linh Mụ)',
    address = 'Đồi Hà Khê, Kim Long, Thành phố Huế',
    latitude = 16.453719,
    longitude = 107.544581,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_110950_1.jpg',
    description = 'Chùa Thiên Mụ ngự trên đồi Hà Khê soi bóng xuống dòng sông Hương thơ mộng, là ngôi cổ tự linh thiêng bậc nhất và biểu tượng trường tồn của xứ Huế. Tháp Phước Duyên 7 tầng hình bát giác cao 21 mét cùng tiếng chuông chùa ngân vang trầm ấm đã đi vào biết bao thi ca nhạc họa của dân tộc.'
WHERE id = 'e659c7f3-ca80-4ca7-9200-91aeb0471d0f';
UPDATE heritage_info 
SET name = 'Chùa Tiên Châu (Cù lao An Bình)',
    address = 'Chùa Tiên Châu (Cù lao An Bình), Vĩnh Long',
    latitude = 10.2583,
    longitude = 105.975,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_4986_1.jpg',
    description = 'Chùa Tiên Châu tọa lạc trên cù lao An Bình thanh bình giữa dòng sông Cổ Chiên, là ngôi cổ tự linh thiêng bậc nhất tỉnh Vĩnh Long được khởi dựng từ giữa thế kỷ XVIII. Ngôi chùa ngập tràn bóng mát của những vườn cây ăn trái xum xuê, nổi bật với chính điện bằng gỗ quý chạm trổ hoa văn tinh xảo mang vẻ đẹp thanh tao, thoát tục miền sông nước miệt vườn.'
WHERE id = 'de8eda99-be1b-43bf-95c2-bbcbdfb0a247';
UPDATE heritage_info 
SET name = 'Chùa Trấn Quốc (Hồ Tây)',
    address = 'Chùa Trấn Quốc (Hồ Tây), Hà Nội',
    latitude = 21.0478,
    longitude = 105.837,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/kien_truc_chua_Tran_Quoc_000032.jpg',
    description = 'Chùa Trấn Quốc tọa lạc trên hòn đảo xanh duy nhất bên bờ đông hồ Tây, là ngôi chùa cổ nhất thủ đô với lịch sử hơn 1.500 năm hình thành từ thời vua Lý Nam Đế. Bảo tháp Lục Độ Đài Sen 11 tầng màu đỏ rực rỡ vươn cao cùng cây bồ đề quý do Tổng thống Ấn Độ trao tặng năm 1959 tạo nên biểu tượng tâm linh bất hủ giữa lòng Hà Nội.'
WHERE id = 'f2717fd3-b220-4093-9359-9cbd80c18d4e';
UPDATE heritage_info 
SET name = 'Chùa Vĩnh Tràng (Mỹ Tho)',
    address = 'Ấp Mỹ An, Xã Mỹ Phong, Mỹ Tho, Tiền Giang',
    latitude = 10.362837,
    longitude = 106.373569,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_94769_1.jpg',
    description = 'Chùa Vĩnh Tràng tọa lạc tại thành phố Mỹ Tho, Tiền Giang, là ngôi đại danh lam cổ tự lớn nhất miền Tây Nam Bộ khởi dựng từ đầu thế kỷ XIX. Kiến trúc chùa là sự giao thoa nghệ thuật tuyệt mỹ giữa phong cách Pháp, Ý, văn hóa Champa và chùa cổ Việt Nam với những mái vòm La Mã, hoa văn Phục hưng và ba pho đại tượng Phật khổng lồ giữa vườn cây thanh tịnh.'
WHERE id = '1ff17ac7-0b08-41a3-be1b-735ef4ef6de3';
UPDATE heritage_info 
SET name = 'Con đường Gốm sứ Hà Nội',
    address = 'Con đường Gốm sứ Hà Nội, Hà Nội',
    latitude = 21.0361,
    longitude = 105.8556,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_185771_1.jpg',
    description = 'Con đường Gốm sứ ven sông Hồng là tác phẩm nghệ thuật công cộng kỷ niệm 1.000 năm Thăng Long - Hà Nội, từng xác lập kỷ lục Guinness là bức tranh ghép gốm mosaic dài nhất thế giới với chiều dài gần 4 km. Hàng triệu viên gốm Bát Tràng nhiều màu sắc tái hiện sống động dòng chảy lịch sử dân tộc, hoa văn Đông Sơn và cảnh đẹp đất nước.'
WHERE id = 'd63a2c7b-010d-4246-bf33-6fcd549fbbdc';
UPDATE heritage_info 
SET name = 'Cột cờ Hà Nội',
    address = '28A Điện Biên Phủ, Ba Đình, Hà Nội',
    latitude = 21.03259,
    longitude = 105.839825,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_145844_1.jpg',
    description = 'Cột cờ Hà Nội, hay Kỳ đài Hà Nội, được xây dựng từ năm 1812 dưới triều vua Gia Long, là một trong số ít công trình kiến trúc nguyên vẹn nhất còn sót lại trong quần thể Hoàng thành Thăng Long. Với chiều cao hơn 33 mét gồm ba tầng chân đế hình chóp cụt bằng gạch nung kiên cố, lá cờ đỏ sao vàng luôn tung bay kiêu hãnh trên nền trời thủ đô ngàn năm văn hiến.'
WHERE id = '3272fdef-e63d-48a1-a1d7-60511781d31c';
UPDATE heritage_info 
SET name = 'Danh Thắng Ngũ Hành Sơn',
    address = '81 Huyền Trân Công Chúa, Phường Hòa Hải, Quận Ngũ Hành Sơn, TP. Đà Nẵng',
    latitude = 16.0042,
    longitude = 108.2611,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/danh_thang_ngu_hanh_son.jpg',
    description = 'Ngũ Hành Sơn là Di tích quốc gia đặc biệt gồm quần thể 5 ngọn núi đá vôi nhô lên sừng sững bên bờ biển: Kim, Mộc, Thủy, Hỏa, Thổ. Nơi đây hội tụ vẻ đẹp huyền bí của hệ thống hang động kỳ ảo như Động Huyền Không, Động Tàng Chơn, cùng các ngôi cổ tự linh thiêng như Chùa Tam Thai, Chùa Linh Ứng Ngũ Hành Sơn và làng nghề đá mỹ nghệ Non Nước hàng trăm năm tuổi.'
WHERE id = 'debfd006-9c55-44ed-b28c-1eab8deff7ae';
UPDATE heritage_info 
SET name = 'Đảo Cát Bà',
    address = 'Quần đảo Cát Bà, Cát Hải, Hải Phòng',
    latitude = 20.795166,
    longitude = 107.00493,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/phong_canh_dao_Cat_Ba_000070.jpg',
    description = 'Đảo Cát Bà là hòn đảo ngọc lớn nhất trong quần thể hơn 360 đảo của vịnh Lan Hạ, Hải Phòng, nổi bật với địa hình karst ngập mặn và những bãi tắm tự nhiên cát trắng phẳng mịn. Du khách đến đây có thể chèo thuyền kayak qua các làng chài nổi cổ xưa và chiêm ngưỡng làn nước xanh trong vắt ôm lấy những vách đá vôi sừng sững.'
WHERE id = 'a4b8c2c7-9faa-4e2c-816a-dd7743cc0625';
UPDATE heritage_info 
SET name = 'Đảo Phú Quốc',
    address = 'Thành phố Phú Quốc, Kiên Giang',
    latitude = 10.228786,
    longitude = 104.014359,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/phong_canh_dao_Phu_Quoc_000091.jpg',
    description = 'Đảo Phú Quốc được mệnh danh là ''''Đảo Ngọc'''' của Việt Nam, hòn đảo lớn nhất đất nước nằm trọn trong vịnh Thái Lan với những bãi biển cát trắng tuyệt mỹ như Bãi Sao, Bãi Khem. Nơi đây nổi tiếng toàn cầu với nghề sản xuất nước mắm truyền thống hàng trăm năm, hồ tiêu cay nồng và những khu nghỉ dưỡng sang trọng ngắm hoàng hôn đỏ rực trên biển Tây.'
WHERE id = '0e56a467-cc87-4e20-b4a9-a30604008cfc';
UPDATE heritage_info 
SET name = 'Dãy Hoàng Liên Sơn',
    address = 'Dãy Hoàng Liên Sơn, Lào Cai',
    latitude = 22.3033,
    longitude = 103.775,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_66659_1.jpg',
    description = 'Dãy Hoàng Liên Sơn là dãy núi non hùng vĩ bậc nhất vùng Tây Bắc, được mệnh danh là ''''dãy Alps của Đông Nam Á'''' với nhiều đỉnh núi cao trên 2.800 mét quanh năm mây phủ. Địa hình núi non hiểm trở cùng những thung lũng ruộng bậc thang trập trùng Mường Hoa tạo nên cảnh sắc thiên nhiên kỳ vĩ làm say đắm lòng người.'
WHERE id = '05340a26-dacd-461a-a23f-2cc493cc7771';
UPDATE heritage_info 
SET name = 'Đền Đô (Đền Lý Bát Đế)',
    address = 'Đền Đô (Đền Lý Bát Đế), Bắc Ninh',
    latitude = 21.107,
    longitude = 105.9598,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_184716_1.jpg',
    description = 'Đền Đô, hay Cổ Pháp Điện, tọa lạc tại phường Đình Bảng, thị xã Từ Sơn, Bắc Ninh, là nơi phụng thờ 8 vị hoàng đế triều Lý - triều đại khai mở nền văn minh Thăng Long độc lập. Quần thể đền mang kiến trúc cung đình truyền thống rộng lớn với hồ Bán Nguyệt, nhà Thủy Đình cổ kính và không gian tôn kính đậm đà bản sắc hào khí Thăng Long.'
WHERE id = '0df4d271-6943-4c09-8518-ab6e2cf6eb50';
UPDATE heritage_info 
SET name = 'Đền Mẫu Âu Cơ (Hạ Hòa)',
    address = 'Đền Mẫu Âu Cơ (Hạ Hòa), Phú Thọ',
    latitude = 21.5633,
    longitude = 105.0072,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_133572_1.jpg',
    description = 'Đền Mẫu Âu Cơ ngự giữa rừng cọ xanh ngát thuộc xã Hiền Lương, huyện Hạ Hòa, Phú Thọ, là nơi thờ Mẹ Âu Cơ - người mẹ huyền thoại sinh ra bọc trăm trứng nở thành trăm người con của bách việt. Ngôi đền cổ kính linh thiêng lưu giữ bức tượng Mẹ Âu Cơ ngồi trên ngai vàng cùng câu chuyện truyền thuyết thiêng liêng về nguồn cội ''''con Rồng cháu Tiên'''' của dân tộc.'
WHERE id = '48eb5588-83fd-4ac5-a1d6-92d7d15170f6';
UPDATE heritage_info 
SET name = 'Đền Ngọc Sơn (Hồ Hoàn Kiếm)',
    address = 'Hồ Hoàn Kiếm, Đinh Tiên Hoàng, Hoàn Kiếm, Hà Nội',
    latitude = 21.030727,
    longitude = 105.852376,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_72275_1.jpg',
    description = 'Đền Ngọc Sơn tọa lạc trên đảo Ngọc giữa làn nước xanh biếc của hồ Hoàn Kiếm, được nối với bờ bằng cầu Thê Húc màu đỏ son uốn cong duyên dáng. Ngôi đền thờ Đức Thánh Trần Hưng Đạo và Văn Xương Đế Quân, lưu giữ tiêu bản Rùa Hồ Gươm khổng lồ gắn liền với truyền thuyết trả gươm thần lịch sử của vua Lê Thái Tổ.'
WHERE id = 'c76d68ce-a5c8-4128-8389-b0984dae7b20';
UPDATE heritage_info 
SET name = 'Đền Tưởng niệm Liệt sĩ Bến Dược',
    address = 'Đền Tưởng niệm Liệt sĩ Bến Dược, TP. Hồ Chí Minh',
    latitude = 11.1436,
    longitude = 106.4632,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_19003_1.jpg',
    description = 'Đền Tưởng niệm Liệt sĩ Bến Dược nằm trong khu di tích Địa đạo Củ Chi bên dòng sông Sài Gòn, là công trình văn hóa lịch sử tâm linh quy mô lớn tri ân hơn 44.000 liệt sĩ đã hy sinh vì nền độc lập tự do của Tổ quốc. Ngôi đền mang kiến trúc cổ truyền ba tầng mái uốn cong chạm trổ công phu và tháp chuông 9 tầng vươn cao kiêu hãnh.'
WHERE id = 'e98c04bf-555a-4c43-9790-1d6ab86b135c';
UPDATE heritage_info 
SET name = 'Đèo Hải Vân',
    address = 'Thị trấn Lăng Cô & Quận Liên Chiểu, Đà Nẵng',
    latitude = 16.169143,
    longitude = 108.126262,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_62708_1.jpg',
    description = 'Đèo Hải Vân được mệnh danh là ''''Thiên hạ đệ nhất hùng quan'''', uốn lượn ngoạn mục qua dãy núi Bạch Mã nhô sát biển Đông nối liền Đà Nẵng và Thừa Thiên Huế. Đứng từ đỉnh đèo quanh năm mây phủ, du khách có thể phóng tầm mắt ngắm vịnh Đà Nẵng cong mềm và làn nước xanh thẳm của Lăng Cô.'
WHERE id = 'bad03177-3e8f-4bff-9156-1b01ee174669';
UPDATE heritage_info 
SET name = 'Di tích Nhà tù Hỏa Lò (Hanoi Hilton)',
    address = 'Số 1 Hỏa Lò, Trần Hưng Đạo, Hoàn Kiếm, Hà Nội',
    latitude = 21.0252,
    longitude = 105.8465,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_186946_1.jpg',
    description = 'Nhà tù Hỏa Lò được thực dân Pháp xây dựng năm 1896 dưới tên gọi Maison Centrale, là nơi từng giam giữ hàng vạn chiến sĩ cách mạng yêu nước Việt Nam trong điều kiện ngục tù khắc nghiệt. Trong chiến tranh kháng Mỹ, nơi đây từng là nơi tạm giam các phi công Mỹ bị bắn rơi và được họ đặt biệt danh hài hước là ''''Hanoi Hilton''''.'
WHERE id = '8518a833-aee9-4636-a4e6-11080fc736bb';
UPDATE heritage_info 
SET name = 'Di Tích Quốc Gia Đặc Biệt Thành Điện Hải',
    address = 'Số 24 Trần Phú, Phường Thạch Thang, Quận Hải Châu, TP. Đà Nẵng',
    latitude = 16.075,
    longitude = 108.2222,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/thanh_dien_hai_da_nang.jpg',
    description = 'Thành Điện Hải là pháo đài quân sự cổ kiểu Vauban kiên cố do triều Gia Long và Minh Mạng xây dựng để bảo vệ cửa biển Đà Nẵng. Đây là nơi ghi dấu trang sử hào hùng của dân tộc trong trận đầu kháng Pháp năm 1858 dưới sự chỉ huy thao lược của danh tướng Nguyễn Tri Phương, giam chân quân địch suốt nhiều tháng ròng.'
WHERE id = 'dbb0c93e-7c2e-48a5-9a21-339e4880d9fe';
UPDATE heritage_info 
SET name = 'Địa đạo Củ Chi',
    address = 'TL15, Phú Hiệp, Củ Chi, TP. Hồ Chí Minh',
    latitude = 11.063044,
    longitude = 106.529124,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_118748_1.jpg',
    description = 'Địa đạo Củ Chi là ''''thành phố ngầm'''' huyền thoại dài hơn 250 km được quân và dân Củ Chi đào hoàn toàn bằng tay trong hai cuộc kháng chiến chống Pháp và chống Mỹ. Hệ thống địa đạo đa tầng kiên cố gồm bệnh viện dã chiến, bếp Hoàng Cầm giấu khói, phòng họp và kho vũ khí ngầm thể hiện ý chí quật cường và nghệ thuật chiến tranh nhân dân độc đáo.'
WHERE id = 'ab6fd7cf-fe44-456c-a363-359d18c9af1e';
UPDATE heritage_info 
SET name = 'Điện Thái Hòa (Hoàng Thành Huế)',
    address = 'Đại Nội Huế, Thuận Thành, Thành phố Huế',
    latitude = 16.468744,
    longitude = 107.578387,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_24264_1.jpg',
    description = 'Điện Thái Hòa là ngôi chính điện uy nghiêm nhất trong Đại Nội Huế, nơi diễn ra các lễ đăng quang, sinh nhật vua và đón tiếp sứ thần của 13 vị vua triều Nguyễn. Ngôi điện mang kiến trúc ''''trùng thiềm điệp ốc'''' với 80 cột gỗ lim sơn son thếp vàng chạm rồng mây tinh xảo và ngai vàng quyền lực tối thượng.'
WHERE id = 'e3021783-0a0f-4fe4-8054-5e3e32486174';
UPDATE heritage_info 
SET name = 'Đình Bảng',
    address = 'Phường Đình Bảng, Thành phố Từ Sơn, Tỉnh Bắc Ninh, Việt Nam',
    latitude = 21.107,
    longitude = 105.9598,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/kien_truc_dinh_Bang_000030.jpg',
    description = 'Đình Bảng là Di tích quốc gia đặc biệt tại thành phố Từ Sơn, Bắc Ninh, được xây dựng từ thế kỷ 18 với quy mô đồ sộ và nghệ thuật điêu khắc gỗ tinh xảo bậc nhất kiến trúc đình làng Việt Nam.'
WHERE id = 'e8f6245e-8493-4b9a-a937-82a726d7609c';
UPDATE heritage_info 
SET name = 'Đền Lừ (Đình Lừ)',
    address = 'Phường Hoàng Văn Thụ, Quận Hoàng Mai, Thành phố Hà Nội, Việt Nam',
    latitude = 20.985,
    longitude = 105.85,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/kien_truc_dinh_Den_Lu_000016.jpg',
    description = 'Đền Lừ là di tích lịch sử - văn hóa cổ kính tại quận Hoàng Mai, Hà Nội, lưu giữ nét sinh hoạt tâm linh lâu đời và các hiện vật điêu khắc truyền thống gắn liền với lịch sử ngàn năm Thăng Long.'
WHERE id = '7d382c7e-e680-4813-8fed-1eac74e60950';
UPDATE heritage_info 
SET name = 'Dinh Độc Lập (Dinh Thống Nhất)',
    address = '135 Nam Kỳ Khởi Nghĩa, Bến Thành, Quận 1, TP. Hồ Chí Minh',
    latitude = 10.777035,
    longitude = 106.695488,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_195083_1.jpg',
    description = 'Dinh Độc Lập, nay là Di tích Quốc gia Đặc biệt Dinh Thống Nhất, là kiệt tác kiến trúc do kiến trúc sư tài ba Ngô Viết Thụ thiết kế kết hợp triết lý phương Đông với kỹ thuật hiện đại phương Tây trên khuôn viên 12 ha rợp bóng cổ thụ. Nơi đây đã đi vào lịch sử thế giới vào trưa ngày 30 tháng 4 năm 1975 khi chiếc xe tăng giải phóng húc đổ cánh cổng sắt, đánh dấu sự thống nhất trọn vẹn non sông.'
WHERE id = '6840138c-cb22-47b1-9378-b4d1f1856fbb';
UPDATE heritage_info 
SET name = 'Đỉnh Fansipan',
    address = 'Dãy Hoàng Liên Sơn, Sa Pa, Lào Cai',
    latitude = 22.3033,
    longitude = 103.775,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_31769_1.jpg',
    description = 'Fansipan là đỉnh núi cao nhất trong dãy Hoàng Liên Sơn và được mệnh danh là ''''Nóc nhà Đông Dương'''' với độ cao kiêu hãnh 3.143 mét so với mực nước biển. Chinh phục đỉnh Fansipan, du khách sẽ bước vào chốn bồng lai tiên cảnh giữa biển mây bồng bềnh, chiêm bái đại tượng Phật A Di Đà bằng đồng uy nghiêm giữa mây ngàn Sa Pa.'
WHERE id = '761fca85-40b6-4639-96bf-92a09d04b49f';
UPDATE heritage_info 
SET name = 'Đình Làng Cổ Túy Loan',
    address = 'Làng Cổ Túy Loan, Xã Hòa Phong, Huyện Hòa Vang, TP. Đà Nẵng',
    latitude = 15.9917,
    longitude = 108.1417,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/dinh_lang_co_tuy_loan.jpg',
    description = 'Đình Túy Loan là một trong những ngôi đình cổ kính và linh thiêng nhất xứ Quảng với lịch sử hơn 500 năm hình thành cùng sự phát triển của làng cổ Túy Loan. Nơi đây bảo lưu trọn vẹn kiến trúc gỗ truyền thống ngũ phụ gia ba gian hai chái, lưu giữ hơn 20 sắc phong quý giá của các triều đại vua chúa nhà Nguyễn và phong vị bánh tráng Túy Loan nức tiếng.'
WHERE id = '6ece9832-a064-4d11-8c0e-184050d02109';
UPDATE heritage_info 
SET name = 'Đồi cát Mũi Né',
    address = 'Đồi cát Mũi Né, Phường Mũi Né, Thành phố Phan Thiết, Tỉnh Bình Thuận, Việt Nam',
    latitude = 10.9333,
    longitude = 108.2875,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/phong_canh_doi_cat_Mui_Ne_000060.jpg',
    description = 'Đồi cát Mũi Né (còn gọi là Đồi cát Bay) là danh thắng thiên nhiên nổi tiếng bậc nhất Bình Thuận với những trảng cát vàng trải dài uốn lượn thay đổi hình dạng từng giờ theo chiều gió.'
WHERE id = 'e0dfa682-bac9-4dde-a694-01a4cccd1d15';
UPDATE heritage_info 
SET name = 'Động Thiên Đường',
    address = 'Bố Trạch, Quảng Bình',
    latitude = 17.519201,
    longitude = 106.223045,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_121721_1.jpg',
    description = 'Động Thiên Đường được ca tụng là ''''hoàng cung trong lòng đất'''', tọa lạc giữa quần thể núi đá vôi hùng vĩ của vườn quốc gia Phong Nha - Kẻ Bàng với chiều dài kỷ lục hơn 31 km. Lòng động sở hữu hệ thống thạch nhũ và măng đá kỳ ảo đa dạng hình thù được thiên nhiên kiến tạo qua hàng triệu năm kiến tạo địa chất.'
WHERE id = 'e7b672b8-425d-4bdb-9df7-dc0aeac2577c';
UPDATE heritage_info 
SET name = 'Hải đăng Kê Gà',
    address = 'Tân Thành, Hàm Thuận Nam, Bình Thuận',
    latitude = 10.695285,
    longitude = 107.991581,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_52885_1.jpg',
    description = 'Hải đăng Kê Gà ngự trên một cù lao đá hoa cương hoang sơ thuộc huyện Hàm Thuận Nam, Bình Thuận, được người Pháp xây dựng từ năm 1897. Với chiều cao tháp 35 mét xây hoàn toàn bằng những khối đá granit mộng ghép tỉ mỉ, đây là ngọn hải đăng cổ kính và cao bậc nhất Việt Nam.'
WHERE id = '74c5d6b4-d9cc-4926-a1a3-ef0e6574497c';
UPDATE heritage_info 
SET name = 'Hải đăng Vũng Tàu (Núi Nhỏ)',
    address = 'Đỉnh Núi Nhỏ, Phường 2, Vũng Tàu, Bà Rịa - Vũng Tàu',
    latitude = 10.256278,
    longitude = 105.272219,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_128374_1.jpg',
    description = 'Hải đăng Vũng Tàu ngự trên đỉnh Núi Nhỏ ở độ cao 170 mét so với mực nước biển, được người Pháp xây dựng từ năm 1862, là một trong những ngọn hải đăng cổ xưa nhất tại Việt Nam. Tháp hải đăng hình trụ tròn sơn trắng cao 18 mét, nối với nhà điều hành bằng một hầm hầm đá cổ kính, từ ban công ngọn hải đăng du khách có thể phóng tầm mắt bao trọn phố biển Vũng Tàu lộng gió.'
WHERE id = '923e7b4b-2754-45d2-8914-3c5d2529ec34';
UPDATE heritage_info 
SET name = 'Hang Sơn Đoòng',
    address = 'Vườn quốc gia Phong Nha - Kẻ Bàng, Quảng Bình',
    latitude = 17.456944,
    longitude = 106.2875,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_121100_1.jpg',
    description = 'Hang Sơn Đoòng nằm sâu trong vùng lõi vườn quốc gia Phong Nha - Kẻ Bàng, được ghi nhận là hang động tự nhiên lớn nhất thế giới với thể tích lên tới 38,5 triệu mét khối. Lòng hang rộng lớn đến mức có thể chứa trọn một tòa nhà chọc trời, sở hữu hệ sinh thái rừng nhiệt đới riêng biệt, hồ nước ngầm và thạch nhũ khổng lồ.'
WHERE id = '7b760ce4-5297-4cb6-aafe-850a22c73b57';
UPDATE heritage_info 
SET name = 'Hiển Lâm Các (Đại Nội Huế)',
    address = 'Đại Nội Huế, Thành phố Huế',
    latitude = 16.466738,
    longitude = 107.577063,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_104627_1.jpg',
    description = 'Hiển Lâm Các là công trình kiến trúc bằng gỗ thanh tú cao ba tầng nằm đối diện Thế Tổ Miếu trong Hoàng Thành Huế, được xây dựng năm 1821 dưới thời vua Minh Mạng. Tòa lầu được dựng lên như đài kỷ niệm ghi nhớ công lao các đại thần có công dựng nước, nổi bật với hệ mái ngói hoàng lưu ly trang nghiêm.'
WHERE id = 'e754f60b-0f79-4edd-94a7-ce22e7c5a5bb';
UPDATE heritage_info 
SET name = 'Hồ Núi Cốc',
    address = 'Hồ Núi Cốc, Thái Nguyên',
    latitude = 21.5775,
    longitude = 105.7039,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_109993_1.jpg',
    description = 'Hồ Núi Cốc là hồ nước ngọt nhân tạo tuyệt đẹp thuộc tỉnh Thái Nguyên, gắn liền với huyền thoại tình yêu thủy chung đầy xúc động giữa nàng Công và chàng Cốc. Mặt hồ mênh mông rộng 25 km² được điểm xuyết bởi 89 hòn đảo lớn nhỏ xanh tươi, là điểm đến du lịch sinh thái và nghỉ dưỡng hấp dẫn của vùng trung du.'
WHERE id = '78666601-c736-4111-bd5e-4c27dde8f1d3';
UPDATE heritage_info 
SET name = 'Hồ Tây',
    address = 'Quận Tây Hồ, Hà Nội',
    latitude = 21.058042,
    longitude = 105.813965,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_189744_1.jpg',
    description = 'Hồ Tây là hồ nước ngọt tự nhiên lớn nhất thủ đô Hà Nội với diện tích hơn 500 ha và chu vi bờ hồ gần 20 km, từng là một nhánh của dòng sông Hồng cổ. Mặt hồ lộng gió soi bóng những ngôi đền chùa cổ kính, vườn sen ngát hương và những cung đường dạo bộ lãng mạn ngắm hoàng hôn đỏ rực buông xuống mặt nước.'
WHERE id = 'f40f37d4-061c-4b98-92d1-8b02805a99ea';
UPDATE heritage_info 
SET name = 'Hồ Tuyền Lâm (Đà Lạt)',
    address = 'Phường 4, Thành phố Đà Lạt, Lâm Đồng',
    latitude = 11.940242,
    longitude = 108.437576,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_60719_1.jpg',
    description = 'Hồ Tuyền Lâm là hồ nước ngọt nhân tạo lớn nhất Đà Lạt với diện tích hơn 350 ha, bao bọc bởi những bán đảo xanh và rừng thông nguyên sinh ngút ngàn. Nơi đây là điểm đến lý tưởng cho các hoạt động chèo thuyền kayak, cắm trại dã ngoại và đón bình minh huyền ảo giữa làn sương khói.'
WHERE id = 'e5b48e8c-fbb4-4bda-b262-9e2207743178';
UPDATE heritage_info 
SET name = 'Hồ Xuân Hương',
    address = 'Trung tâm Thành phố Đà Lạt, Lâm Đồng',
    latitude = 11.94508,
    longitude = 108.448722,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_137138_1.jpg',
    description = 'Hồ Xuân Hương được ví như trái tim lãng mạn của thành phố Đà Lạt với hình dáng lưỡi liềm uốn quanh những hàng thông duyên dáng và thảm cỏ xanh mướt. Đây là nơi lý tưởng để tản bộ, đạp xe đạp nước thiên nga hoặc nhâm nhi tách cà phê ngắm sương mù bảng lảng trên mặt nước.'
WHERE id = 'b6090af6-8b6c-4cd2-92fe-563a60058611';
UPDATE heritage_info 
SET name = 'Kênh Vĩnh Tế',
    address = 'Kênh Vĩnh Tế, An Giang',
    latitude = 10.5367,
    longitude = 104.902,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_62292_1.jpg',
    description = 'Kênh Vĩnh Tế là con kênh đào thủ công vĩ đại dài gần 90 km chạy dọc theo biên giới Việt Nam - Campuchia từ Châu Đốc ra biển Hà Tiên, do Thoại Ngọc Hầu chỉ huy đào đắp từ năm 1819 dưới triều vua Gia Long và Minh Mạng. Công trình thủy lợi quân sự lịch sử mang tên bà Châu Thị Tế - phu nhân của Thoại Ngọc Hầu, là chứng tích bất tử cho công cuộc khai hoang mở cõi và khẳng định chủ quyền non sông.'
WHERE id = 'b5fb4f57-b6a9-4a4e-b936-fa18fc318cf7';
UPDATE heritage_info 
SET name = 'Khu danh thắng Tam Cốc - Bích Động',
    address = 'Ninh Hải, Hoa Lư, Ninh Bình',
    latitude = 20.2181,
    longitude = 105.9381,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_45282_1.jpg',
    description = 'Tam Cốc - Bích Động được ngợi ca là ''''Vịnh Hạ Long trên cạn'''', thuộc quần thể Di sản Thế giới Tràng An tại Ninh Bình. Du khách ngồi thuyền nan xuôi dòng sông Ngô Đồng thơ mộng uốn lượn xuyên qua ba hang động tự nhiên ngắm nhìn những vách núi đá vôi sừng sững và những ruộng lúa chín vàng óng đôi bờ vào mùa hạ.'
WHERE id = 'c4f15806-d138-4f05-a99e-25bd7ddaaebe';
UPDATE heritage_info 
SET name = 'Khu di tích Thành Cổ Loa',
    address = 'Xã Cổ Loa, Đông Anh, Hà Nội',
    latitude = 21.1122,
    longitude = 105.8711,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_184903_1.jpg',
    description = 'Thành Cổ Loa là kinh đô cổ xưa nhất của nhà nước Âu Lạc thời kỳ An Dương Vương thế kỷ thứ III trước Công nguyên, nằm trên địa bàn huyện Đông Anh, Hà Nội. Tòa thành quân sự độc đáo với kiến trúc hình xoáy trôn ốc nhiều vòng lũy đất kiên cố gắn liền với truyền thuyết nỏ thần Kim Quy và câu chuyện tình bi tráng Trọng Thủy - Mỵ Châu.'
WHERE id = '888bd048-9c18-46e9-ba90-1eb4cdf47e28';
UPDATE heritage_info 
SET name = 'Khu đô thị Vinhomes Times City',
    address = 'Khu đô thị Vinhomes Times City, Hà Nội',
    latitude = 20.995,
    longitude = 105.8675,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_34387_1.jpg',
    description = 'Vinhomes Times City tại quận Hai Bà Trưng, Hà Nội, là khu đô thị phức hợp sinh thái hiện đại bậc nhất thủ đô lấy cảm hứng từ kiến trúc Tây Âu thanh lịch. Điểm nhấn thu hút du khách là thủy cung ngầm Vinpearl Aquarium quy mô lớn với hàng chục nghìn sinh vật biển và quảng trường nhạc nước rực rỡ sắc màu mỗi tối.'
WHERE id = 'cffcc8ef-8307-4ea9-bcf3-a3db4b9e646b';
UPDATE heritage_info 
SET name = 'Khu Du Lịch Bà Nà Hills',
    address = 'Khu Du Lịch Bà Nà Hills, Đà Nẵng',
    latitude = 15.9983,
    longitude = 108.0167,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/ba_na_hills_da_nang.jpg',
    description = 'Bà Nà Hills tọa lạc trên đỉnh núi Chúa ở độ cao 1.487 mét so với mực nước biển, nổi danh với khí hậu bốn mùa trong một ngày và Cầu Vàng nâng đỡ bởi đôi bàn tay khổng lồ. Quần thể sở hữu tuyến cáp treo đạt nhiều kỷ lục thế giới và ngôi làng Pháp cổ kính giữa mây ngàn bồng bềnh.'
WHERE id = '375ffa07-2563-4480-a085-1e16884bcf6b';
UPDATE heritage_info 
SET name = 'Khu du lịch Đại Nam Văn Hiến',
    address = 'Khu du lịch Đại Nam Văn Hiến, Bình Dương',
    latitude = 11.0286,
    longitude = 106.6347,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_40463_1.jpg',
    description = 'Khu du lịch Đại Nam Văn Hiến tại thành phố Thủ Dầu Một, Bình Dương, là quần thể du lịch tâm linh và giải trí rộng lớn bậc nhất Việt Nam với diện tích hơn 450 ha. Quần thể nổi bật với Đền Đại Nam dát vàng tráng lệ, vườn bách thú mở đầu tiên tại Việt Nam, trường đua phức hợp và biển nhân tạo tạo sóng khổng lồ.'
WHERE id = 'de1cafca-0077-4c99-9f4e-560ac5ed4319';
UPDATE heritage_info 
SET name = 'Khu du lịch Núi Tà Cú',
    address = 'Khu du lịch Núi Tà Cú, Bình Thuận',
    latitude = 10.8333,
    longitude = 107.8833,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_195579_1.jpg',
    description = 'Núi Tà Cú là thắng cảnh tâm linh nổi tiếng của tỉnh Bình Thuận, sừng sững ở độ cao 649 mét giữa khu bảo tồn thiên nhiên ven biển Hàm Thuận Nam. Trên đỉnh núi có chùa Linh Sơn Trường Thọ ngự trị cùng bức tượng Phật Thích Ca nhập Niết bàn dài 49 mét kỷ lục, nằm thanh thản giữa ngút ngàn mây trời.'
WHERE id = 'bcbc76fd-c38f-48c7-8db2-840f2eb3e175';
UPDATE heritage_info 
SET name = 'Khu Du lịch Văn hóa Suối Tiên',
    address = '120 Xa lộ Hà Nội, Tân Phú, TP. Thủ Đức, TP. Hồ Chí Minh',
    latitude = 10.8656,
    longitude = 106.8028,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_148756_1.jpg',
    description = 'Khu Du lịch Văn hóa Suối Tiên tại thành phố Thủ Đức là công viên giải trí chuyên đề đầu tiên trên thế giới xây dựng theo các chủ đề thần thoại và truyền thuyết lịch sử dân tộc Việt Nam. Quần thể nổi bật với biển Tiên Đồng Ngọc Nữ nhân tạo kỳ vĩ, bức tượng Vua Hùng khổng lồ tạc vào vách đá và hàng loạt trò chơi giải trí nước công nghệ cao hiện đại.'
WHERE id = '9e04bbc0-4676-4aae-8fb4-b3d0aabe63da';
UPDATE heritage_info 
SET name = 'Kỳ Đài Huế',
    address = 'Kinh thành Huế, Thuận Hòa, Thành phố Huế',
    latitude = 16.4674,
    longitude = 107.5792,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_111065_1.jpg',
    description = 'Kỳ Đài Huế là cột cờ sừng sững trước Ngọ Môn Hoàng Thành Huế, được xây dựng từ năm Gia Long thứ 6 (1807) bằng gạch vồ ba tầng kiên cố. Trải qua bao thăng trầm lịch sử và khói lửa chiến tranh, Kỳ Đài vẫn hiên ngang là biểu tượng uy nghi của vương quyền và chủ quyền dân tộc nơi cố đô.'
WHERE id = '0d128f84-9ea2-40e6-9627-b65ae5cd3cee';
UPDATE heritage_info 
SET name = 'Lăng Chủ tịch Hồ Chí Minh',
    address = 'Số 2 Hùng Vương, Điện Biên, Ba Đình, Hà Nội',
    latitude = 21.036783,
    longitude = 105.834689,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_73542_1.jpg',
    description = 'Lăng Chủ tịch Hồ Chí Minh tọa lạc trang nghiêm tại trung tâm Quảng trường Ba Đình, là nơi yên nghỉ vĩnh hằng của vị lãnh tụ kính yêu của dân tộc Việt Nam. Công trình được xây dựng kiên cố bằng đá hoa cương khối xám tự nhiên mang hình tượng đài hoa sen cách điệu, hàng ngày đón hàng vạn đồng bào và bạn bè quốc tế vào lăng viếng Bác.'
WHERE id = 'b13c8b30-9b00-4fc9-8ddd-63b1e0b255c6';
UPDATE heritage_info 
SET name = 'Lăng Gia Long (Thiên Thọ Lăng)',
    address = 'Hương Thọ, Thị xã Hương Trà, Thừa Thiên Huế',
    latitude = 16.363193,
    longitude = 107.596476,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_182673_1.jpg',
    description = 'Lăng Gia Long, hay Thiên Thọ Lăng, là lăng tẩm của vị vua khai sáng triều Nguyễn, tọa lạc giữa quần sơn Thiên Thọ cách trung tâm Huế 20 km. Khu lăng mang vẻ đẹp trầm mặc, khoáng đạt với sự hòa quyện tuyệt đối giữa công trình kiến trúc lăng mộ với thiên nhiên núi rừng và hồ nước bao la.'
WHERE id = '47fff1a7-1aa4-4e31-8019-7fdf2a847090';
UPDATE heritage_info 
SET name = 'Lăng Thiệu Trị (Xương Lăng)',
    address = 'Thủy Bằng, Hương Thủy, Thừa Thiên Huế',
    latitude = 16.416256,
    longitude = 107.57322,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_194348_1.jpg',
    description = 'Lăng Thiệu Trị tọa lạc dưới chân núi Thuận Đạo, là lăng tẩm duy nhất của các vua triều Nguyễn quay mặt về hướng tây bắc và không có la thành bao bọc. Mang tính cách khiêm cung, giản dị, lăng hòa mình nhẹ nhàng vào những ruộng lúa xanh rì và vườn cây ăn trái thanh bình chốn đồng quê xứ Huế.'
WHERE id = 'ef615eeb-b4ba-436a-b688-9b94a171b8ed';
UPDATE heritage_info 
SET name = 'Nghĩa trang Bình An',
    address = 'Nghĩa trang Bình An, Bình Dương',
    latitude = 10.8833,
    longitude = 106.8,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_136317_1.jpg',
    description = 'Nghĩa trang Bình An, trước đây là Nghĩa trang Quân đội Biên Hòa, tọa lạc trên đồi Dĩ An thuộc tỉnh Bình Dương. Nơi đây là công trình tưởng niệm lịch sử ghi dấu những mất mát của người lính trong chiến tranh, lưu giữ bức tượng đài Tiếc Thương nổi tiếng một thời và mang ý nghĩa hòa giải, khép lại quá khứ đau thương.'
WHERE id = 'a2e7d491-30e0-455b-a3b7-254faf2f2149';
UPDATE heritage_info 
SET name = 'Ngôi nhà Đức (Deutsches Haus)',
    address = 'Ngôi nhà Đức (Deutsches Haus), TP. Hồ Chí Minh',
    latitude = 10.7817,
    longitude = 106.7003,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_139377_1.jpg',
    description = 'Ngôi nhà Đức tọa lạc tại góc đường Lê Duẩn, Quận 1, là tòa cao ốc văn phòng hạng A+ tiên phong đạt tiêu chuẩn công trình xanh LEED Platinum kép danh giá. Với mặt dựng kính hai lớp cách nhiệt hiện đại phản chiếu bầu trời xanh, tòa nhà là biểu tượng kiến trúc bền vững và cầu nối kinh tế - văn hóa hữu nghị giữa Việt Nam và Cộng hòa Liên bang Đức.'
WHERE id = '04b8b2c8-914a-47c1-bb8a-9a0df69672c1';
UPDATE heritage_info 
SET name = 'Nhà hát Lớn Hà Nội',
    address = 'Số 1 Tràng Tiền, Hoàn Kiếm, Hà Nội',
    latitude = 21.024202,
    longitude = 105.857834,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_44895_1.jpg',
    description = 'Nhà hát Lớn Hà Nội được người Pháp khởi công xây dựng năm 1901 theo nguyên mẫu nhà hát Opéra Garnier tráng lệ tại thủ đô Paris, mang đậm phong cách kiến trúc Tân cổ điển châu Âu. Tòa nhà nổi bật với những cột đá La Mã, mái vòm lợp ngói đá đen và phòng khán giả lộng lẫy, là trung tâm biểu diễn nghệ thuật hàn lâm đỉnh cao của cả nước.'
WHERE id = '9f7a2381-0e01-456a-bb62-60cb4006af36';
UPDATE heritage_info 
SET name = 'Nhà hát Thành phố Hồ Chí Minh',
    address = '07 Công Trường Lam Sơn, Bến Nghé, Quận 1, TP. Hồ Chí Minh',
    latitude = 10.776744,
    longitude = 106.703249,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_16314_1.jpg',
    description = 'Nhà hát Thành phố tọa lạc tại trung tâm quảng trường Công trường Lam Sơn, Quận 1, được kiến trúc sư Eugène Ferret khánh thành năm 1900 theo phong cách Tân cổ điển Pháp lãng mạn. Với mặt tiền chạm khắc phù điêu nữ thần nghệ thuật lộng lẫy và khán phòng 500 chỗ ngồi sang trọng, đây là nơi diễn ra các chương trình hòa nhạc giao hưởng, múa ballet và vở diễn nghệ thuật À Ố Show trứ danh.'
WHERE id = '174598ac-01fc-4bc1-8644-060e3a6f8bbb';
UPDATE heritage_info 
SET name = 'Nhà máy Thủy điện Hòa Bình',
    address = 'Nhà máy Thủy điện Hòa Bình, Hòa Bình',
    latitude = 20.8167,
    longitude = 105.3167,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_52015_1.jpg',
    description = 'Thủy điện Hòa Bình trên sông Đà từng là công trình thủy điện lớn nhất Đông Nam Á của thế kỷ XX, được xây dựng với sự hỗ trợ chí tình của các chuyên gia Liên Xô. Đập ngăn sông khổng lồ không chỉ cung cấp nguồn điện năng dồi dào cho đất nước mà còn là công trình chế ngự lũ lụt lịch sử cho toàn vùng đồng bằng Bắc Bộ.'
WHERE id = '94af7c01-f4b8-4c30-920e-b9c3d1b2239d';
UPDATE heritage_info 
SET name = 'Nhà máy Thủy điện Sơn La',
    address = 'Nhà máy Thủy điện Sơn La, Sơn La',
    latitude = 21.4967,
    longitude = 103.9967,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_149877_1.jpg',
    description = 'Thủy điện Sơn La nằm trên dòng sông Đà thuộc huyện Mường La, là công trình thủy điện lớn nhất Đông Nam Á với công suất thiết kế 2.400 MW hoàn toàn do các kỹ sư Việt Nam làm tổng thầu thiết kế và thi công. Đập bê tông trọng lực đồ sộ đứng sừng sững giữa núi rừng Tây Bắc là kỳ tích vẻ vang của ngành năng lượng và trí tuệ Việt Nam.'
WHERE id = '486eb734-cf34-40bc-909c-dcd3ac535e0e';
UPDATE heritage_info 
SET name = 'Nhà thờ Chính Tòa Long Xuyên',
    address = 'Nhà thờ Chính Tòa Long Xuyên, An Giang',
    latitude = 10.375,
    longitude = 105.4333,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_122786_1.jpg',
    description = 'Nhà thờ Chính Tòa Long Xuyên tọa lạc bên bờ rạch Long Xuyên, tỉnh An Giang, là công trình thánh đường Công giáo bề thế khánh thành năm 1973 theo lối kiến trúc hiện đại độc đáo. Tháp chuông cao 55 mét thanh thoát vươn lên giữa bầu trời miền Tây cùng những mảng tranh tường kính màu rực rỡ tạo nên vẻ đẹp tôn nghiêm và thanh tịnh.'
WHERE id = 'eee0b116-66f6-4a5d-aa3b-07a62697d7ee';
UPDATE heritage_info 
SET name = 'Nhà thờ Con Gà Đà Lạt (Nhà thờ Chính Tòa)',
    address = '15 Trần Phú, Phường 3, Đà Lạt, Lâm Đồng',
    latitude = 10.921788,
    longitude = 108.095048,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_162524_1.jpg',
    description = 'Nhà thờ Con Gà là công trình kiến trúc tôn giáo tiêu biểu của Đà Lạt được xây dựng từ thời Pháp thuộc theo phong cách Romanesque cổ điển. Đỉnh tháp chuông cao 47 mét nổi bật với bức tượng con gà bằng đồng quay theo hướng gió, mở ra tầm nhìn bao quát toàn thành phố sương mù.'
WHERE id = '7b8a79e1-4264-4051-99f5-77ecbe406c85';
UPDATE heritage_info 
SET name = 'Nhà thờ đá Phát Diệm',
    address = 'Thị trấn Phát Diệm, Kim Sơn, Ninh Bình',
    latitude = 20.093425,
    longitude = 106.078855,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_115883_1.jpg',
    description = 'Nhà thờ đá Phát Diệm tại huyện Kim Sơn, Ninh Bình, là kiệt tác kiến trúc Công giáo độc nhất vô nhị do linh mục Phêrô Trần Lục chủ trì xây dựng suốt 24 năm từ thế kỷ XIX. Toàn bộ quần thể kết hợp tài tình giữa kiến trúc đình chùa truyền thống phương Đông với nghệ thuật thánh đường phương Tây hoàn toàn bằng đá và gỗ lim nguyên khối.'
WHERE id = 'ce0bb861-f6bc-4dbc-9d7a-f2e158470236';
UPDATE heritage_info 
SET name = 'Nhà thờ Domaine de Marie (Nhà thờ Mai Anh)',
    address = '01 Ngô Quyền, Phường 6, Đà Lạt, Lâm Đồng',
    latitude = 11.949663,
    longitude = 108.430137,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_47137_1.jpg',
    description = 'Nhà thờ Domaine de Marie tọa lạc trên đồi Mai Anh rợp bóng tùng sam, nổi bật với sắc hồng đất ấm áp và mái nhọn gợi nhớ kiến trúc nhà rông Tây Nguyên kết hợp phong cách Gothic Pháp. Bên trong khuôn viên là vườn hoa rực rỡ và khu trưng bày tranh thêu tay tinh xảo.'
WHERE id = 'a573bbf5-9cc3-415d-a69e-87089bf03d23';
UPDATE heritage_info 
SET name = 'Nhà Thờ Đức Bà Huế',
    address = '1 Đường Trần Hưng Đạo, Phường 1, Quận 1, Huế, Thừa Thiên-Huế',
    latitude = 16.4583,
    longitude = 107.5917,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/kien_truc_nha_tho_Duc_Ba_000054.jpg',
    description = 'Nhà Thờ Đức Bà Huế, còn gọi là Nhà thờ Đức Bà Huế, là một công trình kiến trúc Gothic được xây dựng từ năm 1900-1904 dưới thời Đế quốc Pháp. Nằm ngay trung tâm thành phố Huế, nó là biểu tượng của sự giao thoa văn hóa, tín ngưỡng và lịch sử giữa dân tộc Việt Nam và người Pháp. Kiến trúc của nhà thờ với những cột sông, cửa sổ kính màu và mái vòm cao đã tạo nên một không gian linh thiêng, thu hút du khách và tín đồ. Ngoài ra, nhà thờ còn là nơi lưu giữ nhiều tác phẩm nghệ thuật, tượng trưng cho sự hòa nhập và đa dạng văn hoá của vùng đất Huế.'
WHERE id = '06a84594-a3b9-44af-b7d0-317c37404dc8';
UPDATE heritage_info 
SET name = 'Nhà thờ Đức Bà Sài Gòn',
    address = '01 Công xã Paris, Bến Nghé, Quận 1, TP. Hồ Chí Minh',
    latitude = 10.7798,
    longitude = 106.699,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_153668_1.jpg',
    description = 'Vương cung thánh đường Đức Bà Sài Gòn khánh thành năm 1880 tại quảng trường Công xã Paris, là kiệt tác kiến trúc Gothic kết hợp Romanesque tuyệt mỹ với toàn bộ gạch ngói và kính màu đều được vận chuyển trực tiếp từ Marseille và Toulouse nước Pháp. Hai tháp chuông vươn cao 60,5 mét cùng tượng Đức Mẹ Hòa Bình bằng đá cẩm thạch trắng là trái tim biểu tượng của thành phố hơn 300 năm tuổi.'
WHERE id = '488790f5-7f27-43d7-898f-08929e7a1ca4';
UPDATE heritage_info 
SET name = 'Nhà thờ Lớn Hà Nội',
    address = '40 Nhà Chung, Hàng Trống, Hoàn Kiếm, Hà Nội',
    latitude = 21.028648,
    longitude = 105.848857,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_2414_1.jpg',
    description = 'Nhà thờ Lớn Hà Nội khánh thành vào dịp Giáng sinh năm 1887 trên phố Nhà Thờ, là ngôi thánh đường Công giáo cổ kính nhất thủ đô mang đậm phong cách kiến trúc Gothic châu Âu mô phỏng Nhà thờ Đức Bà Paris. Bức tường rêu phong cổ kính cùng tháp chuông đôi cao 31 mét là điểm hẹn văn hóa và biểu tượng nhiếp ảnh quen thuộc của du khách khi đến Hà Nội.'
WHERE id = '9f136a9e-baa9-4d5f-95bd-f43f36b0601e';
UPDATE heritage_info 
SET name = 'Nhà thờ Tân Định (Nhà thờ Màu Hồng)',
    address = '289 Hai Bà Trưng, Phường 8, Quận 3, TP. Hồ Chí Minh',
    latitude = 10.78836,
    longitude = 106.690642,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_162703_1.jpg',
    description = 'Nhà thờ Tân Định tọa lạc trên đường Hai Bà Trưng, Quận 3, được khánh thành năm 1876, là một trong những công trình tôn giáo cổ xưa và nổi tiếng nhất Sài Gòn với sắc hồng ngọt ngào độc nhất vô nhị. Kiến trúc thánh đường kết hợp hài hòa giữa phong cách Gothic thanh thoát với hoa văn vòm cuốn Romanesque và tháp chuông chính cao 52,6 mét kiều diễm.'
WHERE id = '1fb109b8-19c8-40d1-97ca-3d4c35f58b91';
UPDATE heritage_info 
SET name = 'Nhà thờ Thánh Tâm Nha Trang',
    address = 'Số 2/3, Đường 2/3, Phường Phước Hải, Thành phố Nha Trang, Khánh Hòa, Việt Nam',
    latitude = 12.2417,
    longitude = 109.1833,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/kien_truc_nha_tho_thanh_that_000021.jpg',
    description = 'Nhà thờ Thánh Tâm Nha Trang, còn gọi là Nhà thờ Thánh Tâm, là một công trình kiến trúc tôn giáo tiêu biểu của thời kỳ thực dân Pháp tại miền Trung Việt Nam. Được khánh thành vào năm 1913, nhà thờ mang phong cách Gothic pha trộn các yếu tố kiến trúc Romanesque, với tháp chuông cao vươn lên, cửa sổ kính màu rực rỡ và các họa tiết chạm khắc tinh xảo. Vật liệu chủ yếu là gạch và đá, kết hợp cùng các chi tiết bằng sắt rèn, phản ánh sự giao thoa giữa nghệ thuật châu Âu và điều kiện địa phương. Nhà thờ không chỉ là nơi sinh hoạt tôn giáo của cộng đồng Công giáo Nha Trang mà còn là chứng nhân lịch sử cho quá trình truyền bá đạo Thiên Chúa và ảnh hưởng văn hoá Pháp tại Việt Nam. Hiện nay, công trình được bảo tồn và mở cửa tham quan, là điểm dừng chân quan trọng cho du khách muốn khám phá di sản kiến trúc và lịch sử tôn giáo của khu vực.'
WHERE id = '40647a6f-7dd0-4256-b8d9-c1de613e4eb6';
UPDATE heritage_info 
SET name = 'Nhà tù Côn Đảo',
    address = 'Đường Nguyễn Huệ, Côn Đảo, Bà Rịa - Vũng Tàu',
    latitude = 8.688966,
    longitude = 106.614841,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_84676_1.jpg',
    description = 'Nhà tù Côn Đảo do thực dân Pháp và chính quyền Sài Gòn xây dựng suốt hơn 100 năm, được mệnh danh là ''''địa ngục trần gian'''' giam giữ và tra tấn dã man hàng vạn tù nhân chính trị yêu nước. Hệ thống ''''chuồng cọp'''' kiên cố ngột ngạt cùng Nghĩa trang Hàng Dương linh thiêng là bản anh hùng ca bất diệt về lòng kiên trung bất khuất của dân tộc Việt Nam.'
WHERE id = '3be77c59-fa87-4fa3-862f-05e98791984e';
UPDATE heritage_info 
SET name = 'Nhà Vườn Huế',
    address = 'Số 1, Đường Lê Lợi, Phường Phú Hội, Thành phố Huế, Thừa Thiên Huế',
    latitude = 16.45,
    longitude = 107.55,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/kien_truc_nha_vuon_Hue_000012.jpg',
    description = 'Nhà Vườn Huế là một công trình kiến trúc truyền thống đặc trưng của thành phố Huế, được xây dựng vào cuối thế kỷ XIX dưới thời vua Thành Thái. Toàn bộ ngôi nhà được bố trí hài hòa giữa không gian sống và khu vườn, phản ánh triết lý sống gần gũi với thiên nhiên của người dân Huế. Kiến trúc ngôi nhà mang đậm nét phong cách cung đình Huế với mái ngói âm dương, cột gỗ chạm khắc tinh xảo và các cửa sổ mở ra những góc vườn xanh mát, nơi trồng các loại cây cảnh, cây ăn quả và hoa lá truyền thống. Nội thất được bài trí theo phong cách cổ điển, kết hợp các vật dụng gốm sứ, tranh thêu và đồ gỗ quý, tạo nên một không gian thanh bình, yên tĩnh. Nhà Vườn Huế không chỉ là di sản kiến trúc mà còn là biểu tượng của lối sống tinh tế, tôn trọng thiên nhiên và bảo tồn giá trị văn hoá của người Huế.'
WHERE id = '1d30dd8e-fd66-42f0-ab06-376b177e29d3';
UPDATE heritage_info 
SET name = 'Núi Bà Đen',
    address = 'Thạnh Tân, Thành phố Tây Ninh, Tây Ninh',
    latitude = 11.382383,
    longitude = 106.170221,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/kien_truc_chua_Ba_Den_000026.png',
    description = 'Núi Bà Đen được mệnh danh là ''''Nóc nhà Nam Bộ'''' với độ cao 986 mét sừng sững giữa đồng bằng bạt ngàn của tỉnh Tây Ninh. Đỉnh núi là chốn bồng lai mây phủ với đại tượng Phật Bà Tây Bổ Đà Sơn bằng đồng cao kỷ lục 72 mét cùng hệ thống cáp treo hiện đại đưa du khách chiêm bái quần thể chùa Bà linh thiêng.'
WHERE id = '11bb9125-a589-4651-a34f-65134d7dfd32';
UPDATE heritage_info 
SET name = 'Phố Tây Bùi Viện - Phạm Ngũ Lão',
    address = 'Phố Bùi Viện, Phạm Ngũ Lão, Quận 1, TP. Hồ Chí Minh',
    latitude = 10.7675,
    longitude = 106.6936,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_10363_1.jpg',
    description = 'Khu phố Tây Bùi Viện - Phạm Ngũ Lão thuộc phường Phạm Ngũ Lão, Quận 1, là tụ điểm vui chơi giải trí đêm sôi động bậc nhất phương Nam dành cho du khách quốc tế. Khi màn đêm buông xuống, con phố đi bộ bùng nổ với âm nhạc rộn ràng từ các quán bar, bia hơi vỉa hè và vô số món ăn đường phố hấp dẫn kéo dài đến tận tờ mờ sáng.'
WHERE id = 'fdab3324-fc3b-40eb-9c37-96cbb6999919';
UPDATE heritage_info 
SET name = 'Quần đảo Bà Lụa',
    address = 'Quần đảo Bà Lụa, Kiên Giang',
    latitude = 10.1833,
    longitude = 104.5333,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_163230_1.jpg',
    description = 'Quần đảo Bà Lụa thuộc vịnh Thái Lan, tỉnh Kiên Giang, được ví như ''''tiểu Hạ Long phương Nam'''' với hơn 40 đảo lớn nhỏ nhấp nhô trên làn nước biển phẳng lặng. Nổi tiếng nhất là nhóm Ba Hòn Đầm với bãi tắm nước nông trong vắt, nơi du khách có thể thỏa thích lội bộ qua lại giữa các đảo nổi và tự tay bắt ốc, sò tươi ngon.'
WHERE id = 'cb5ac586-2755-49c6-a94c-521910db21ba';
UPDATE heritage_info 
SET name = 'Quần đảo Côn Đảo',
    address = 'Huyện Côn Đảo, Bà Rịa - Vũng Tàu',
    latitude = 8.6833,
    longitude = 106.6,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_183876_1.jpg',
    description = 'Quần đảo Côn Đảo gồm 16 hòn đảo lớn nhỏ nằm giữa biển khơi ngoài khơi Vũng Tàu, từng là ''''địa ngục trần gian'''' thời chiến tranh nhưng nay đã chuyển mình thành thiên đường du lịch sinh thái đẳng cấp. Với những bãi biển hoang sơ nước trong vắt như Đầm Trầu và khu bảo tồn rùa biển đẻ trứng lớn nhất Việt Nam, Côn Đảo là điểm đến kỳ thú tuyệt đỉnh.'
WHERE id = 'aa4cb4f9-712a-479a-8e5e-4af252a44c67';
UPDATE heritage_info 
SET name = 'Quần đảo Hoàng Sa',
    address = 'Huyện đảo Hoàng Sa, Thành phố Đà Nẵng, Việt Nam',
    latitude = 16.5,
    longitude = 112.0,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/nha_trung_bay_hoang_sa.jpg',
    description = 'Quần đảo Hoàng Sa là một phần lãnh thổ thiêng liêng không thể tách rời của Tổ quốc Việt Nam trên Biển Đông, trực thuộc thành phố Đà Nẵng. Từ các thế kỷ XVII-XIX dưới thời chúa Nguyễn và triều đại nhà Nguyễn, các Đội Hoàng Sa kiêm quản Bắc Hải đã liên tục được cử ra đo đạc hải trình, cắm mốc chủ quyền, thu lượm hải vật và dựng bia khẳng định chủ quyền lãnh thổ lâu đời của dân tộc.'
WHERE id = 'b3431f84-7623-49fa-919a-04cfab689e54';
UPDATE heritage_info 
SET name = 'Quần đảo Trường Sa',
    address = 'Huyện đảo Trường Sa, Tỉnh Khánh Hòa, Việt Nam',
    latitude = 8.6444,
    longitude = 111.9194,
    image_url = 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?auto=format&fit=crop&w=1200&q=80',
    description = 'Quần đảo Trường Sa là tiền đồn kiên cường nơi đầu sóng ngọn gió bảo vệ vùng biển trời phía Đông Nam của Tổ quốc. Nơi đây gắn liền với những mốc chủ quyền sừng sững, ngọn hải đăng soi sáng hàng hải quốc tế, ngôi chùa Trường Sa Lớn thanh tịnh và Khu tưởng niệm các anh hùng liệt sĩ Gạc Ma bất tử đã ngã xuống vì sự toàn vẹn lãnh thổ thiêng liêng.'
WHERE id = 'f38ffb1e-13bc-45b1-9ee5-da1702865358';
UPDATE heritage_info 
SET name = 'Quần thể Chùa Bái Đính',
    address = 'Xã Gia Sinh, Gia Viễn, Ninh Bình',
    latitude = 20.2742,
    longitude = 105.8647,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_67114_1.jpg',
    description = 'Chùa Bái Đính là quần thể tâm linh Phật giáo quy mô lớn bậc nhất Đông Nam Á, tọa lạc trên sườn núi đá vôi linh thiêng của vùng đất cố đô Ninh Bình. Ngôi chùa xác lập hàng loạt kỷ lục châu Á với hành lang 500 vị La Hán bằng đá xanh nguyên khối, tượng Phật Thích Ca bằng đồng dát vàng lớn nhất và bảo tháp 13 tầng uy nghi.'
WHERE id = 'fe533186-23ab-403d-b791-59b3931927d2';
UPDATE heritage_info 
SET name = 'Quảng trường Ba Đình',
    address = 'Số 1 Hùng Vương, Ba Đình, Hà Nội',
    latitude = 21.036987,
    longitude = 105.835792,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_4958_1.jpg',
    description = 'Quảng trường Ba Đình là quảng trường lịch sử lớn nhất Việt Nam, nơi Chủ tịch Hồ Chí Minh đọc bản Tuyên ngôn Độc lập khai sinh ra nước Việt Nam Dân chủ Cộng hòa vào ngày 2 tháng 9 năm 1945. Không gian quảng trường rộng lớn với 168 ô cỏ xanh mướt, hướng thẳng về Lăng Bác và tòa nhà Quốc hội trang nghiêm.'
WHERE id = 'e0e600dc-fa7e-4b11-a479-7a7b09f161d3';
UPDATE heritage_info 
SET name = 'Sân vận động Chi Lăng',
    address = 'Sân vận động Chi Lăng, Đà Nẵng',
    latitude = 16.07,
    longitude = 108.2183,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_128310_1.jpg',
    description = 'Sân vận động Chi Lăng từng là ''''chảo lửa'''' bóng đá huyền thoại gắn liền với những chiến tích vang dội của đội bóng Đà Nẵng và những sự kiện thể thao lớn của miền Trung. Nằm ở vị trí trung tâm thành phố, nơi đây đong đầy ký ức thể thao và đời sống sôi động của bao thế hệ người dân Đà Nẵng.'
WHERE id = '50e3365f-b62d-4f43-9498-c63bdd5d0e1c';
UPDATE heritage_info 
SET name = 'Sân vận động Gò Đậu',
    address = 'Sân vận động Gò Đậu, Bình Dương',
    latitude = 10.975,
    longitude = 106.6717,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_191801_1.jpg',
    description = 'Sân vận động Gò Đậu tọa lạc tại trung tâm thành phố Thủ Dầu Một, là sân nhà của câu lạc bộ bóng đá danh tiếng Becamex Bình Dương - đội bóng từng 4 lần vô địch V-League. Với sức chứa gần 20.000 khán giả, chảo lửa Gò Đậu là biểu tượng cho sự trỗi dậy mạnh mẽ của phong trào thể thao vùng kinh tế trọng điểm Đông Nam Bộ.'
WHERE id = 'f3150563-a8dc-492a-88c7-ce04e0fc00ec';
UPDATE heritage_info 
SET name = 'Sân vận động Hàng Đẫy',
    address = 'Sân vận động Hàng Đẫy, Hà Nội',
    latitude = 21.03,
    longitude = 105.8317,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_44226_1.jpg',
    description = 'Sân vận động Hàng Đẫy nằm trên phố Trịnh Hoài Đức, là cái nôi lâu đời của phong trào bóng đá thủ đô và từng là sân nhà của đội tuyển quốc gia Việt Nam suốt nhiều thập kỷ. Khán đài thân thương nơi đây luôn bùng cháy tình yêu thể thao nồng nhiệt của người hâm mộ bóng đá Hà thành qua nhiều thế hệ.'
WHERE id = '24607de1-f8f4-4662-a31d-d54b869faea4';
UPDATE heritage_info 
SET name = 'Sân vận động Quốc gia Mỹ Đình',
    address = 'Lê Đức Thọ, Mỹ Đình 1, Nam Từ Liêm, Hà Nội',
    latitude = 21.020503,
    longitude = 105.763927,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_141856_1.jpg',
    description = 'Sân vận động Quốc gia Mỹ Đình khánh thành năm 2003 tại quận Nam Từ Liêm, Hà Nội, là sân vận động hiện đại bậc nhất Việt Nam với sức chứa hơn 40.000 khán giả. Nơi đây là đấu trường chính của các kỳ SEA Games, các giải đấu bóng đá quốc tế danh giá và những đại nhạc hội tầm cỡ thế giới.'
WHERE id = '2a5dadf0-2d78-4e44-9a6c-e1fe419f66c3';
UPDATE heritage_info 
SET name = 'Sân vận động Thống Nhất',
    address = 'Sân vận động Thống Nhất, TP. Hồ Chí Minh',
    latitude = 10.7583,
    longitude = 106.6617,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_60036_1.jpg',
    description = 'Sân vận động Thống Nhất nằm trên đường Nguyễn Kim, Quận 10, là thánh địa bóng đá lâu đời và giàu truyền thống bậc nhất phương Nam với lịch sử hình thành từ thập niên 1930 thời Pháp thuộc. Nơi đây từng chứng kiến bao thế hệ danh thủ tài hoa thi đấu và là sân nhà cuồng nhiệt của các câu lạc bộ bóng đá hàng đầu thành phố Hồ Chí Minh.'
WHERE id = '4b8ef0d9-d8c7-49af-8fdf-1a0a4e83cb85';
UPDATE heritage_info 
SET name = 'Sông Hương',
    address = 'Sông Hương, thành phố Huế, Thừa Thiên Huế, Việt Nam',
    latitude = 16.4678,
    longitude = 107.5856,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/phong_canh_song_Huong_000064.png',
    description = 'Sông Hương, còn gọi là Perfume River, là một trong những con sông quan trọng và biểu tượng của thành phố Huế, Thừa Thiên Huế. Dòng sông bắt nguồn từ dãy Núi Trường Sơn, chảy qua các thung lũng xanh mướt và cuối cùng đổ ra Vịnh Thuận An. Với chiều dài khoảng 80 km, Sông Hương không chỉ tạo nên cảnh quan thiên nhiên thơ mộng, mà còn gắn liền với lịch sử, văn hoá và đời sống của người dân Huế. Hai bên bờ sông hiện diện các di tích kiến trúc cổ kính như Cầu Trường Tiền, Đình Ngọ Môn và các cung điện của triều đại Nguyễn, phản ánh sự hài hòa giữa thiên nhiên và nhân tạo. Sông Hương còn là nguồn cảm hứng cho nhiều tác phẩm thơ ca, âm nhạc và lễ hội truyền thống, được người dân xem là “linh hồn” của cố đô, biểu tượng cho sự bình yên, thanh thản và tinh hoa văn hoá Huế.'
WHERE id = '2ed02e2a-8131-426e-bfa3-d4d0de3c438b';
UPDATE heritage_info 
SET name = 'Sông Thu Bồn',
    address = 'Sông Thu Bồn, tỉnh Quảng Nam, Việt Nam',
    latitude = 15.8756,
    longitude = 108.3283,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/phong_canh_song_Thu_Bon_000057.jpg',
    description = 'Sông Thu Bồn, một trong những con sông quan trọng của miền Trung Việt Nam, chảy qua tỉnh Quảng Nam từ nguồn ở dãy Trường Sơn, qua các huyện Duy Xuyên, Điện Bàn, và cuối cùng đổ ra biển tại Hội An. Với chiều dài khoảng 150 km, sông không chỉ là nguồn nước sinh hoạt, nông nghiệp và công nghiệp mà còn là mạch máu văn hoá, lịch sử của người dân Quảng Nam. Trải dài dọc bờ sông, các làng nghề truyền thống, di tích cổ kính và các khu di sản thế giới như phố cổ Hội An đã hình thành, phát triển nhờ nguồn lợi từ Thu Bồn. Hình ảnh sông Thu Bồn thường được mô tả như biểu tượng của sự gắn bó mật thiết giữa con người và thiên nhiên, là chứng nhân của bao thăng trầm lịch sử, đồng thời là nguồn cảm hứng cho các tác phẩm nghệ thuật, lễ hội và truyền thống địa phương.'
WHERE id = 'd0751acd-b36f-4e8b-8674-0983d6aaf514';
UPDATE heritage_info 
SET name = 'Tây An Cổ Tự (Núi Sam, Châu Đốc)',
    address = 'Tây An Cổ Tự (Núi Sam, Châu Đốc), An Giang',
    latitude = 10.675,
    longitude = 105.075,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_180385_1.jpg',
    description = 'Tây An Cổ Tự tọa lạc dưới chân núi Sam, thành phố Châu Đốc, là ngôi danh lam cổ tự do Tổng đốc Doãn Uẩn cho khởi dựng từ năm 1847. Kiến trúc chùa độc nhất vô nhị kết hợp nghệ thuật đền tháp Hồi giáo Ấn Độ với phong cách chùa cổ truyền thống Việt Nam, sở hữu mái vòm hình củ hành độc đáo cùng hơn 11.000 pho tượng Phật gỗ chạm trổ tinh xảo.'
WHERE id = '640917d8-c66a-4756-ae68-d9c92653c77c';
UPDATE heritage_info 
SET name = 'Thác Bản Giốc',
    address = 'Xã Đàm Thủy, Trùng Khánh, Cao Bằng',
    latitude = 22.8539,
    longitude = 106.723287,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_184326_1.jpg',
    description = 'Thác Bản Giốc nằm trên dòng sông Quây Sơn thuộc huyện Trùng Khánh, Cao Bằng, là thác nước tự nhiên lớn nhất Đông Nam Á và là một trong bốn thác nước xuyên biên giới kỳ vĩ nhất thế giới. Dòng nước đổ xuống qua nhiều tầng đá vôi tung bọt trắng xóa giữa thung lũng lúa vàng óng và rặng tre xanh ngắt.'
WHERE id = 'e0e3cb04-0665-4ed1-855f-4bc8a0190ceb';
UPDATE heritage_info 
SET name = 'Thác Bobla (Thác Liên Đầm)',
    address = 'Thác Bobla (Thác Liên Đầm), Lâm Đồng',
    latitude = 11.5749,
    longitude = 108.0184,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_29884_1.jpg',
    description = 'Thác Bobla, còn gọi là thác Liên Đầm, ẩn mình giữa núi rừng nguyên sơ thuộc huyện Di Linh, Lâm Đồng. Dòng thác trắng xóa đổ từ độ cao hơn 50 mét xuống vực sâu tạo nên khung cảnh thiên nhiên kỳ vĩ và bầu không khí trong lành, hoang sơ của vùng đất cao nguyên.'
WHERE id = '65086fbb-e1fb-4a0f-83e2-2cd4f491d88b';
UPDATE heritage_info 
SET name = 'Thác Datanla',
    address = 'QL20 Đèo Prenn, Phường 3, Đà Lạt, Lâm Đồng',
    latitude = 11.901177,
    longitude = 108.448844,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_27605_1.jpg',
    description = 'Thác Datanla nằm ven đèo Prenn, sở hữu dòng nước trong vắt len lỏi qua 7 tầng ghềnh đá hoa cương giữa rừng thông bạt ngàn. Du khách đến đây có thể trải nghiệm cảm giác mạnh với hệ thống máng trượt uốn lượn xuyên rừng dài bậc nhất Việt Nam.'
WHERE id = '487c0718-6060-4f0c-9236-47a61a91b230';
UPDATE heritage_info 
SET name = 'Thác Gia Long (Dray Sáp Thượng)',
    address = 'Thác Gia Long (Dray Sáp Thượng), Đắk Nông',
    latitude = 12.5283,
    longitude = 107.9148,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_26688_1.jpg',
    description = 'Thác Gia Long nằm trên dòng sông Sêrêpôk huyền thoại, mang vẻ đẹp hoang sơ kỳ vĩ với hệ thống hang động bazan đen tuyền và hồ tắm thiên nhiên xanh ngắt. Tương truyền vua Gia Long từng chọn nơi đây làm chốn dừng chân nghỉ ngơi và thưởng ngoạn cảnh sắc đại ngàn.'
WHERE id = '30099548-b35c-48ca-9b57-36b0279e4598';
UPDATE heritage_info 
SET name = 'Thác Hang Cọp',
    address = 'Thác Hang Cọp, Lâm Đồng',
    latitude = 11.9683,
    longitude = 108.52,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_165388_1.jpg',
    description = 'Thác Hang Cọp ẩn mình giữa thung lũng thông rậm rạp thuộc xã Xuân Thọ, Đà Lạt, với dòng nước dội mạnh từ vách đá cao 25 mét xuống hồ sâu. Dưới chân thác có hang đá tự nhiên gắn liền với những truyền thuyết ly kỳ về loài hổ chúa của rừng Tây Nguyên.'
WHERE id = 'a6db97cd-214b-49d1-8d88-43a2fcd5fbc9';
UPDATE heritage_info 
SET name = 'Thác Pongour',
    address = 'Thác Pongour, Xã Tân Hội, Huyện Đơn Dương, Tỉnh Lâm Đồng, Việt Nam',
    latitude = 11.6893,
    longitude = 108.2655,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/phong_canh_thac_Pongour_000047.jpg',
    description = 'Thác Pongour, còn được biết đến với tên gọi "Thác Bốn Mùa", nằm trên lưu vực sông Đa Nhim, thuộc xã Tân Hội, huyện Đơn Dương, tỉnh Lâm Đồng. Được hình thành nhờ dòng nước mưa dày đặc của dãy Trường Sơn và địa hình đồi núi đá vôi, thác tạo ra bốn tầng thác rơi xen kẽ, mỗi tầng lại mang một màu sắc và âm thanh riêng, phản ánh rõ nét bốn mùa trong năm. Khí hậu ôn đới nhiệt đới gió mùa của Lâm Đồng, với mưa rải rác quanh năm, giúp thác luôn duy trì dòng chảy mạnh mẽ, tạo nên khung cảnh hùng vĩ và lãng mạn. Thác Pongour không chỉ là điểm du lịch sinh thái mà còn là biểu tượng văn hoá của người dân địa phương, nơi họ tổ chức các lễ hội truyền thống, ca hát và các hoạt động văn nghệ để tôn vinh thiên nhiên và duy trì bản sắc văn hoá vùng cao.'
WHERE id = '7110e30b-cc7b-422e-9600-1a21565a874b';
UPDATE heritage_info 
SET name = 'Thác Prenn',
    address = 'QL20 Chân đèo Prenn, Phường 3, Đà Lạt, Lâm Đồng',
    latitude = 11.876519,
    longitude = 108.470104,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_33080_1.jpg',
    description = 'Thác Prenn nằm ngay cửa ngõ tiến vào thành phố Đà Lạt dưới chân đèo Prenn, đổ xuống mềm mại như dải lụa qua một vòm đá tự nhiên. Du khách có thể đi bộ xuyên qua lối mòn đá luồn sau rèm nước đổ và tham gia các hoạt động chèo thuyền, cưỡi voi thú vị.'
WHERE id = '8cca2cac-4ee0-4c16-a9c7-ba5bdfdd5e84';
UPDATE heritage_info 
SET name = 'Thác Voi (Liêng Rơwoa)',
    address = 'Thị trấn Nam Ban, Lâm Hà, Lâm Đồng',
    latitude = 11.823509,
    longitude = 108.334904,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_36336_1.jpg',
    description = 'Thác Voi, hay Liêng Rơwoa, là ngọn thác kỳ vĩ bậc nhất Lâm Đồng thuộc thị trấn Nam Ban, đổ từ vách đá cao hơn 30 mét tung bọt trắng xóa như đàn voi khổng lồ. Dưới chân thác là hang Dơi kỳ bí và những tảng đá nhấp nhô rêu phong giữa thảm rừng nhiệt đới đại ngàn.'
WHERE id = '05c6cecb-1d0c-4d7d-8c4b-b1ccb244385b';
UPDATE heritage_info 
SET name = 'Thánh địa Mỹ Sơn',
    address = 'Xã Duy Phú, Duy Xuyên, Quảng Nam',
    latitude = 15.76552,
    longitude = 108.123453,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_14098_1.jpg',
    description = 'Thánh địa Mỹ Sơn là quần thể tháp đền Ấn Độ giáo cổ kính ẩn mình giữa thung lũng kín đáo được bao bọc bởi đồi núi linh thiêng tại Quảng Nam. Từng là trung tâm tế lễ của các vương triều Chăm pa từ thế kỷ IV đến thế kỷ XIV, nơi đây được UNESCO vinh danh là Di sản Văn hóa Thế giới với kỹ thuật xây gạch không lộ mạch hồ kỳ bí.'
WHERE id = 'b954610d-cf26-4ce7-9e4b-7a16606a2534';
UPDATE heritage_info 
SET name = 'Thành phố Đà Nẵng',
    address = 'Thành phố Đà Nẵng, Việt Nam',
    latitude = 16.0544,
    longitude = 108.2022,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/giao_thong_do_nang_000003.jpg',
    description = 'Đà Nẵng, thành phố trực thuộc trung ương miền Trung, là một trong những điểm du lịch hấp dẫn nhất Việt Nam với bờ biển dài, cát trắng mịn và hệ thống hạ tầng hiện đại. Nơi đây hội tụ các danh thắng nổi tiếng như Bán đảo Sơn Trà, Ngũ Hành Sơn, cầu Rồng, cầu Sông Hàn và khu phố cổ Hội An lân cận, phản ánh sự đa dạng văn hoá, lịch sử và tín ngưỡng của vùng. Đà Nẵng còn là trung tâm giao thương, công nghiệp và giáo dục, đồng thời tổ chức nhiều lễ hội truyền thống như Lễ hội Đèn lồng và Lễ hội ẩm thực, góp phần làm phong phú đời sống văn hoá của người dân và du khách.'
WHERE id = 'f6add28a-73e4-4a6b-985b-61c45f02d04d';
UPDATE heritage_info 
SET name = 'Thảo Cầm Viên Sài Gòn',
    address = '02 Nguyễn Bỉnh Khiêm, Bến Nghé, Quận 1, TP. Hồ Chí Minh',
    latitude = 10.787842,
    longitude = 106.706335,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_35734_1.jpg',
    description = 'Thảo Cầm Viên Sài Gòn thành lập năm 1864 bởi nhà thực vật học người Pháp Jean-Baptiste Louis Pierre, là một trong tám vườn thú cổ xưa nhất thế giới còn tồn tại. Ốc đảo sinh thái xanh tươi giữa lòng Quận 1 này bảo tồn hơn 1.000 cá thể động vật quý hiếm cùng hàng nghìn cây cổ thụ trăm tuổi tạo nên không gian thiên nhiên trong lành tuyệt vời.'
WHERE id = '86734732-eb30-475f-bbac-79e77b693b69';
UPDATE heritage_info 
SET name = 'Tháp Bà Ponagar',
    address = 'Đường 2 Tháng 4, Vĩnh Phước, Nha Trang, Khánh Hòa',
    latitude = 12.2656,
    longitude = 109.1958,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_185834_1.jpg',
    description = 'Tháp Bà Ponagar ngự trên ngọn đồi đá hoa cương xanh mát ven sông Cái tại Nha Trang, là quần thể đền tháp Chăm pa cổ kính xây dựng từ thế kỷ VIII đến thế kỷ XIII. Nơi đây thờ nữ thần Thiên Y A Na Thánh Mẫu linh thiêng và là điểm sinh hoạt tín ngưỡng, múa Chăm truyền thống đặc sắc của đồng bào địa phương.'
WHERE id = '94feba1c-c462-4ee0-83a3-40323c771d82';
UPDATE heritage_info 
SET name = 'Tháp Chăm Bằng An',
    address = 'Tháp Chăm Bằng An, Quảng Nam',
    latitude = 15.895,
    longitude = 108.2583,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_58737_1.jpg',
    description = 'Tháp Chăm Bằng An tọa lạc tại thị xã Điện Bàn, Quảng Nam, là tháp Chăm duy nhất tại Việt Nam có cấu trúc hình bát giác đặc biệt. Xây dựng từ khoảng thế kỷ thứ IX đến X, ngọn tháp cao hơn 21 mét thờ thần Shiva, tượng trưng cho đỉnh cao kỹ thuật nung gạch và nghệ thuật điêu khắc Chăm pa cổ.'
WHERE id = 'cd377416-cbf9-460b-a4b2-c83d393a83cb';
UPDATE heritage_info 
SET name = 'Tháp Chăm Po Sah Inư (Phan Thiết)',
    address = 'Đồi Bà Nài, Phú Hài, Phan Thiết, Bình Thuận',
    latitude = 10.936053,
    longitude = 108.146122,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_149368_1.jpg',
    description = 'Tháp Chăm Po Sah Inư ngự trên đồi Bà Nài nhìn ra biển Phan Thiết, là cụm tháp cổ thờ thần Shiva theo phong cách kiến trúc Hòa Lai được xây dựng từ cuối thế kỷ thứ VIII. Hàng năm vào tháng 7 Chăm lịch, lễ hội Katê rộn ràng với tiếng kèn Saranai và tiếng trống Paranưng thu hút đông đảo du khách thập phương.'
WHERE id = '46e45b79-4622-4391-9a9d-f652c73fc5a2';
UPDATE heritage_info 
SET name = 'Tháp Rùa (Hồ Hoàn Kiếm)',
    address = 'Hồ Hoàn Kiếm, Hàng Trống, Hoàn Kiếm, Hà Nội',
    latitude = 21.027873,
    longitude = 105.852293,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_134878_1.jpg',
    description = 'Tháp Rùa đứng cô liêu mà kiêu hãnh trên gò đất nổi giữa làn nước trong xanh của hồ Hoàn Kiếm, được xây dựng vào cuối thế kỷ XIX với sự giao thoa giữa kiến trúc gô-tích châu Âu và mái cong Á Đông. Ngọn tháp nhỏ bé là linh hồn bất tử của thủ đô, gắn liền với huyền tích Rùa Vàng trả gươm thần gìn giữ nền hòa bình độc lập của non sông.'
WHERE id = 'e46ce884-5c66-4987-9891-580e803d9801';
UPDATE heritage_info 
SET name = 'Thập tự Long Tân',
    address = 'Thập tự Long Tân, Bà Rịa - Vũng Tàu',
    latitude = 10.5167,
    longitude = 107.25,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_158425_1.jpg',
    description = 'Thập tự Long Tân tọa lạc giữa cánh rừng cao su bạt ngàn thuộc huyện Đất Đỏ, tỉnh Bà Rịa - Vũng Tàu, là đài tưởng niệm các chiến sĩ thuộc Trung đoàn 6 Quân đội Hoàng gia Úc tử trận trong trận đánh Long Tân năm 1966. Nơi đây là di tích lịch sử chiến trường đặc biệt thu hút đông đảo cựu chiến binh và du khách quốc tế đến thăm để tưởng niệm hòa bình.'
WHERE id = '85bc378c-c3a8-4142-ade2-402af2c711e7';
UPDATE heritage_info 
SET name = 'Thế Tổ Miếu (Hoàng thành Huế)',
    address = 'Đại Nội Huế, Thành phố Huế',
    latitude = 16.467161,
    longitude = 107.57674,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_86503_1.jpg',
    description = 'Thế Tổ Miếu, hay Thế Miếu, là khu đền thờ tôn nghiêm bậc nhất nằm ở góc tây nam Hoàng Thành Huế, được vua Minh Mạng cho xây dựng năm 1821 để thờ cúng các vị hoàng đế triều Nguyễn. Trước sân đền là Cửu Đỉnh đúc bằng đồng tượng trưng cho sự trường tồn vĩnh cửu và bờ cõi non sông đất nước.'
WHERE id = '6385ca24-79be-4737-8c53-dec887f528cd';
UPDATE heritage_info 
SET name = 'Thiền viện Trúc Lâm Đà Lạt',
    address = 'Đường Trần Thánh Tông, Phường 3, Đà Lạt, Lâm Đồng',
    latitude = 11.904158,
    longitude = 108.434787,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_141206_1.jpg',
    description = 'Thiền viện Trúc Lâm là thiền viện thuộc dòng Trúc Lâm Yên Tử lớn bậc nhất Việt Nam, tọa lạc trên núi Phụng Hoàng soi bóng xuống hồ Tuyền Lâm phẳng lặng. Không gian thiền môn thanh tịnh giữa ngàn thông reo cùng vườn hoa muôn sắc mang lại cảm giác an yên tuyệt đối cho người hành hương.'
WHERE id = 'dc9608c0-0f69-4408-b844-edfca764f624';
UPDATE heritage_info 
SET name = 'Thư viện Quốc gia Việt Nam',
    address = 'Thư viện Quốc gia Việt Nam, Hà Nội',
    latitude = 21.0267,
    longitude = 105.85,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_131182_1.jpg',
    description = 'Thư viện Quốc gia Việt Nam tọa lạc trên phố Tràng Thi, Hà Nội, được thành lập từ năm 1917 thời Pháp thuộc theo phong cách kiến trúc Đông Dương trang nhã và thanh thoát. Nơi đây là kho tàng tri thức lớn nhất đất nước, lưu trữ hàng triệu tài liệu quý, bản thảo Hán Nôm cổ và các bộ sưu tập sách báo vô giá.'
WHERE id = '9271f241-8ac1-44a0-ad2a-f9f8fa67c049';
UPDATE heritage_info 
SET name = 'Thung Lũng Tình Yêu',
    address = '3 - 5 - 7 Mai Anh Đào, Phường 8, Đà Lạt, Lâm Đồng',
    latitude = 11.978185,
    longitude = 108.449923,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_201016_1.jpg',
    description = 'Thung Lũng Tình Yêu là thắng cảnh lãng mạn trứ danh của xứ sở ngàn hoa Đà Lạt, nằm ẩn mình bên những sườn đồi thông và hồ Đa Thiện trong xanh. Quần thể sở hữu mê cung tình yêu, các tiểu cảnh hoa nghệ thuật và cầu kính đi bộ ngắm trọn cảnh sắc thiên nhiên thơ mộng.'
WHERE id = 'dce9ca0f-1b07-46b7-8972-d7cf913f895a';
UPDATE heritage_info 
SET name = 'Tòa cao ốc Lotte Center Hà Nội',
    address = '54 Liễu Giai, Ba Đình, Hà Nội',
    latitude = 21.0322,
    longitude = 105.8126,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_133933_1.jpg',
    description = 'Lotte Center Hà Nội cao 65 tầng tại ngã tư Liễu Giai - Đào Tấn, mô phỏng tà áo dài truyền thống Việt Nam thướt tha mềm mại bằng kính phản quang hiện đại. Tòa nhà là tổ hợp thương mại cao cấp với đài quan sát Sky Walk sàn kính trong suốt ở tầng 65 mang lại cảm giác lơ lửng ngắm toàn cảnh thủ đô rực rỡ từ trên cao.'
WHERE id = 'c8d07d35-fe54-4180-aa13-4e4c8682fe57';
UPDATE heritage_info 
SET name = 'Tòa nhà Saigon Trade Center',
    address = 'Tòa nhà Saigon Trade Center, TP. Hồ Chí Minh',
    latitude = 10.7833,
    longitude = 106.7042,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_93380_1.jpg',
    description = 'Saigon Trade Center cao 33 tầng tại ngã ba Tôn Đức Thắng và Nguyễn Thị Minh Khai, từng là tòa nhà cao nhất Việt Nam khi hoàn thành vào năm 1997. Với hình khối bát giác bọc kính xanh vững chãi và quán bar tầng thượng lộng gió, công trình là biểu tượng mở đầu cho kỷ nguyên hội nhập kinh tế và bùng nổ cao ốc hiện đại của thành phố.'
WHERE id = '1525cb78-149f-4122-95d0-4dfe2bb62b21';
UPDATE heritage_info 
SET name = 'Tòa nhà The Reverie Saigon (Times Square)',
    address = 'Tòa nhà The Reverie Saigon (Times Square), TP. Hồ Chí Minh',
    latitude = 10.7733,
    longitude = 106.7036,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_185687_1.jpg',
    description = 'Times Square Saigon tọa lạc giữa hai đại lộ danh giá Nguyễn Huệ và Đồng Khởi, là nơi ngự trị của khách sạn siêu sang 6 sao The Reverie Saigon. Tòa nhà gây choáng ngợp bởi nghệ thuật trang trí nội thất thủ công vương giả của các bậc thầy nước Ý, lát đá cẩm thạch xa hoa và hệ thống đèn chùm pha lê Baccarat lộng lẫy.'
WHERE id = 'dbba85d6-e8e8-4d32-abc2-b10868abef0f';
UPDATE heritage_info 
SET name = 'Tòa Thánh Tây Ninh',
    address = 'Phạm Hộ Pháp, Hòa Thành, Tây Ninh',
    latitude = 11.3097,
    longitude = 106.1364,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_189897_1.jpg',
    description = 'Tòa Thánh Tây Ninh là thánh địa trung ương tối cao của đạo Cao Đài, nổi bật với sự kết hợp kiến trúc kỳ vĩ giữa chùa chiền phương Đông, tháp chuông thánh đường Công giáo và tháp giáo đường Hồi giáo. Nội thất thánh đường rực rỡ sắc màu với những hàng cột rồng đắp nổi tinh xảo dẫn về Quả Càn Khôn và biểu tượng Thiên Nhãn tỏa sáng linh thiêng.'
WHERE id = 'ec1b0d75-ba8b-424d-b210-272ef3589294';
UPDATE heritage_info 
SET name = 'Tòa tháp Bitexco Financial Tower',
    address = '02 Hải Triều, Bến Nghé, Quận 1, TP. Hồ Chí Minh',
    latitude = 10.7716,
    longitude = 106.7044,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_4125_1.jpg',
    description = 'Bitexco Financial Tower cao 262 mét gồm 68 tầng tại trung tâm Quận 1, mô phỏng hình tượng búp hoa sen vươn cao tràn đầy sức sống của một Việt Nam đổi mới. Tòa tháp nổi bật với sân đỗ trực thăng nhô ra ở tầng 52 và đài quan sát Saigon Skydeck trên tầng 49 đem đến góc nhìn 360 độ ngoạn mục ngắm trọn khúc uốn lượn của dòng sông Sài Gòn.'
WHERE id = 'e334cfaf-2ecc-42a9-b265-2713be8710c3';
UPDATE heritage_info 
SET name = 'Tòa tháp IFC One Saigon (Saigon One Tower)',
    address = 'Tòa tháp IFC One Saigon (Saigon One Tower), TP. Hồ Chí Minh',
    latitude = 10.7711,
    longitude = 106.7058,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_90811_1.jpg',
    description = 'IFC One Saigon tọa lạc tại góc đường Hàm Nghi và Tôn Đức Thắng nhìn ra sông Sài Gòn, là tòa tháp chọc trời cao 185 mét với 41 tầng nổi bật bởi lớp kính vảy rồng cách điệu lấp lánh phản chiếu ánh sáng. Tòa tháp là điểm nhấn kiến trúc đương đại mạnh mẽ khẳng định tầm vóc của một trung tâm tài chính quốc tế năng động hàng đầu khu vực.'
WHERE id = '5b539431-25df-4bcb-8a00-b9ffdbdeb409';
UPDATE heritage_info 
SET name = 'Tòa tháp Keangnam Hanoi Landmark Tower 72',
    address = 'Khu E6 Đô thị mới Cầu Giấy, Nam Từ Liêm, Hà Nội',
    latitude = 21.017,
    longitude = 105.7839,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_121533_1.jpg',
    description = 'Keangnam Hanoi Landmark Tower cao 350 mét với 72 tầng trên đường Phạm Hùng, từng là tòa nhà chọc trời cao nhất Việt Nam trong nhiều năm. Tòa tháp là tổ hợp tài chính, khách sạn 5 sao cao cấp và đài quan sát Sky72 trên đỉnh cao mang lại tầm nhìn toàn cảnh ngoạn mục khắp vùng đô thị Hà Nội.'
WHERE id = '0b6fe83f-5ee0-4f9c-b20f-be57dc96a26d';
UPDATE heritage_info 
SET name = 'Tòa tháp Vietcombank Tower',
    address = 'Tòa tháp Vietcombank Tower, TP. Hồ Chí Minh',
    latitude = 10.7744,
    longitude = 106.7053,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_46072_1.jpg',
    description = 'Vietcombank Tower cao 206 mét với 35 tầng tại công trường Mê Linh, Quận 1, do công ty kiến trúc lừng danh Pelli Clarke Pelli thiết kế theo phong cách hiện đại hình khối giật cấp vươn cao. Mặt ngoài bọc đá granite và kính cường lực xanh ngọc soi bóng xuống dòng sông Sài Gòn, là trụ sở tài chính đẳng cấp và biểu tượng thịnh vượng của thành phố.'
WHERE id = '7d5ffe1d-8e3f-457a-8c24-99e5b935b914';
UPDATE heritage_info 
SET name = 'Trụ sở UBND Thành phố Hồ Chí Minh',
    address = '86 Lê Thánh Tôn, Bến Nghé, Quận 1, TP. Hồ Chí Minh',
    latitude = 10.7766,
    longitude = 106.7009,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_142465_1.jpg',
    description = 'Trụ sở UBND Thành phố Hồ Chí Minh ngự ở đầu phố đi bộ Nguyễn Huệ, nguyên là Dinh Xã Tây được kiến trúc sư Paul Gardès thiết kế xây dựng từ năm 1898 đến 1909 theo phong cách Phục hưng Pháp. Tòa nhà nổi bật với tháp chuông trung tâm cao vút, các bức phù điêu nữ thần Marianne tinh xảo và hệ thống chiếu sáng nghệ thuật rực rỡ khi đêm về.'
WHERE id = 'cb1c2271-f4ef-4fda-aa06-b3f807702f42';
UPDATE heritage_info 
SET name = 'Trung tâm Thương mại Tràng Tiền Plaza',
    address = '24 Hai Bà Trưng, Tràng Tiền, Hoàn Kiếm, Hà Nội',
    latitude = 21.0253,
    longitude = 105.8544,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_44280_1.jpg',
    description = 'Tràng Tiền Plaza ngự tại góc phố Tràng Tiền hướng ra hồ Hoàn Kiếm, là trung tâm thương mại cao cấp và lâu đời bậc nhất của Hà Nội khởi nguyên từ bách hóa tổng hợp thời Pháp thuộc. Tòa nhà được tân trang lộng lẫy theo phong cách kiến trúc cổ điển châu Âu xa hoa, quy tụ các thương hiệu thời trang đẳng cấp quốc tế.'
WHERE id = 'f590f80e-9718-442e-8b12-2a711f545143';
UPDATE heritage_info 
SET name = 'Trường THPT Chuyên Quốc Học Huế',
    address = '12 Lê Lợi, Vĩnh Ninh, Thành phố Huế',
    latitude = 16.4589,
    longitude = 107.5867,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_79684_1.jpg',
    description = 'Trường Quốc Học Huế thành lập năm 1896 bên bờ sông Hương, là một trong những ngôi trường trung học lâu đời và giàu truyền thống hiếu học bậc nhất Việt Nam. Khuôn viên trường gây ấn tượng mạnh với phong cách kiến trúc Pháp cổ điển kết hợp cổng tam quan Á Đông và những bức tường quét vôi đỏ thắm rợp bóng xà cừ cổ thụ.'
WHERE id = '548b9e71-70df-4996-a606-5ac287dfb4f7';
UPDATE heritage_info 
SET name = 'Tượng Chúa Kitô Vua (Vũng Tàu)',
    address = 'Đường Thùy Vân, Phường 2, Vũng Tàu, Bà Rịa - Vũng Tàu',
    latitude = 10.350536,
    longitude = 107.071501,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_50819_1.jpg',
    description = 'Tượng Chúa Kitô Vua sừng sững trên đỉnh Núi Nhỏ ở độ cao 170 mét so với mực nước biển, là bức tượng Chúa Giêsu lớn bậc nhất châu Á với chiều cao 32 mét và sải tay dài 18,3 mét. Du khách vượt qua gần 1.000 bậc đá và leo 133 bậc thang xoắn ốc bên trong thân tượng để bước ra đôi vai Chúa ngắm toàn cảnh phố biển Vũng Tàu tuyệt mỹ.'
WHERE id = '37028aad-459a-4853-89b7-c32478e4d98b';
UPDATE heritage_info 
SET name = 'Vịnh Cam Ranh',
    address = 'Thành phố Cam Ranh, Khánh Hòa',
    latitude = 11.900377,
    longitude = 109.180727,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_128015_1.jpg',
    description = 'Vịnh Cam Ranh là một trong những vịnh nước sâu tự nhiên đẹp và kín gió nhất thế giới, được bao bọc bởi bán đảo Cam Ranh cùng những dãy núi trập trùng. Nơi đây quy tụ nhiều bãi biển hoang sơ tuyệt mỹ như Bãi Dài với bờ cát trắng mịn và làn nước trong vắt như pha lê.'
WHERE id = '9400573a-310d-44aa-b9b5-4e314e0e14ce';
UPDATE heritage_info 
SET name = 'Vườn Bách Thảo Hà Nội',
    address = 'Vườn Bách Thảo Hà Nội, Hà Nội',
    latitude = 21.0383,
    longitude = 105.8283,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_124454_1.jpg',
    description = 'Vườn Bách Thảo Hà Nội thành lập từ năm 1890, được ví như ''''lá phổi xanh'''' yên ả nằm ngay phía sau Quảng trường Ba Đình và Phủ Chủ tịch. Công viên lưu giữ hàng trăm loài cây cổ thụ quý hiếm, những đồi cỏ xanh ngắt rợp bóng mát cùng hồ Vị Danh thanh bình, là điểm dạo mát lý tưởng của người dân thủ đô.'
WHERE id = '65153ddf-07b2-4d5f-8806-f8e167b58a8c';
UPDATE heritage_info 
SET name = 'Vườn hoa Thành phố Đà Lạt',
    address = 'Vườn hoa Thành phố Đà Lạt, Lâm Đồng',
    latitude = 11.9483,
    longitude = 108.4517,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_144275_1.jpg',
    description = 'Vườn hoa Thành phố tọa lạc bên bờ hồ Xuân Hương, là nơi hội tụ của hơn 300 loài hoa quý hiếm trong nước và quốc tế. Khí hậu ôn đới quanh năm mát mẻ giúp hàng nghìn luống hoa hồng, cẩm tú cầu, hoa lan đua nhau khoe sắc rực rỡ suốt bốn mùa.'
WHERE id = '37173f2d-c36a-4ba8-acc7-2542a60a49a9';
UPDATE heritage_info 
SET name = 'Vườn quốc gia Ba Vì',
    address = 'Huyện Ba Vì, Hà Nội',
    latitude = 21.018448,
    longitude = 105.393026,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_165669_1.jpg',
    description = 'Vườn quốc gia Ba Vì ôm trọn dãy núi Ba Vì hùng vĩ cách trung tâm Hà Nội khoảng 50 km, sở hữu khí hậu vùng cao mát mẻ quanh năm và thảm thực vật nhiệt đới đa dạng. Nơi đây nổi tiếng với đền thờ Bác Hồ trên đỉnh Vua, phế tích nhà thờ Pháp cổ rêu phong và vườn xương rồng độc đáo giữa mây ngàn.'
WHERE id = '2b6e93fa-3873-4c89-9713-3b6f0e9562f1';
UPDATE heritage_info 
SET name = 'Vườn quốc gia Bạch Mã',
    address = 'Vườn quốc gia Bạch Mã, Thừa Thiên Huế',
    latitude = 16.2292,
    longitude = 107.8542,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_109509_1.jpg',
    description = 'Vườn quốc gia Bạch Mã trải rộng trên dải núi Trường Sơn hùng vĩ, là khu bảo tồn thiên nhiên đa dạng sinh học bậc nhất miền Trung. Đứng từ đỉnh Vọng Hải Đài mây phủ ở độ cao 1.450 mét, du khách có thể phóng tầm mắt bao trọn đầm Cầu Hai và bờ biển xanh ngắt của vịnh Lăng Cô.'
WHERE id = 'a713bc60-205d-419b-9ca3-fdf4e48e0f63';
UPDATE heritage_info 
SET name = 'Vườn quốc gia Cát Bà',
    address = 'Vườn quốc gia Cát Bà, Hải Phòng',
    latitude = 20.7967,
    longitude = 106.9972,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_48766_1.jpg',
    description = 'Vườn quốc gia Cát Bà được UNESCO công nhận là Khu dự trữ sinh quyển thế giới, là nơi cư trú duy nhất trên hành tinh của loài voọc Cát Bà cực kỳ quý hiếm. Hệ sinh thái rừng nhiệt đới nguyên sinh trên núi đá vôi cùng hồ ếch tự nhiên mở ra những cung đường trekking kỳ thú băng qua thung lũng nguyên sơ.'
WHERE id = '0b350de9-d15c-415d-be86-8b9ccf438345';
UPDATE heritage_info 
SET name = 'Vườn quốc gia Cát Tiên',
    address = 'Tân Phú, Đồng Nai',
    latitude = 11.454726,
    longitude = 107.319781,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_177220_1.jpg',
    description = 'Vườn quốc gia Cát Tiên trải dài trên địa bàn Đồng Nai, Lâm Đồng và Bình Phước, là Khu dự trữ sinh quyển thế giới bảo tồn hệ sinh thái rừng nhiệt đới đất thấp lớn nhất Nam Bộ. Nơi đây là vương quốc hoang dã của loài bò tót, chim công, cá sấu đầm lầy Bàu Sấu và những cây tùng cổ thụ nghìn năm tuổi khổng lồ.'
WHERE id = '0539ea0e-6063-46e9-afdb-d5c42467ba4b';
UPDATE heritage_info 
SET name = 'Vườn quốc gia Cúc Phương',
    address = 'Vườn quốc gia Cúc Phương, Ninh Bình',
    latitude = 20.3163,
    longitude = 105.6177,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/phong_canh_vuon_quoc_gia_Cuc_Phuong_000045.jpg',
    description = 'Vườn quốc gia Cúc Phương thành lập năm 1962, là vườn quốc gia đầu tiên của Việt Nam nằm trên vùng ranh giới ba tỉnh Ninh Bình, Hòa Bình và Thanh Hóa. Nơi đây bảo tồn hệ sinh thái rừng mưa nhiệt đới nguyên sinh với cây Chò ngàn năm tuổi sừng sững, hang động người tiền sử và mùa bướm rừng bay rợp trời tuyệt mỹ vào đầu hạ.'
WHERE id = 'de8fca7f-fb63-46a5-82e4-246e6ee7ecf3';
UPDATE heritage_info 
SET name = 'Vườn quốc gia Phong Nha - Kẻ Bàng',
    address = 'Bố Trạch, Quảng Bình',
    latitude = 17.555264,
    longitude = 106.112304,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_73264_1.jpg',
    description = 'Vườn quốc gia Phong Nha - Kẻ Bàng là Di sản Thiên nhiên Thế giới UNESCO hai lần vinh danh, sở hữu vùng núi đá vôi cổ xưa nhất châu Á với niên đại hơn 400 triệu năm. Quần thể ẩn chứa hệ thống hàng trăm hang động kỳ vĩ, những dòng sông ngầm huyền ảo và hệ sinh thái rừng nhiệt đới nguyên sinh bạt ngàn.'
WHERE id = '45be95b2-3ce3-4369-b63d-b41a105e032d';
UPDATE heritage_info 
SET name = 'Vườn quốc gia Tràm Chim',
    address = 'Tam Nông, Đồng Tháp',
    latitude = 10.729893,
    longitude = 105.500107,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_35484_1.jpg',
    description = 'Vườn quốc gia Tràm Chim tại huyện Tam Nông, Đồng Tháp, là khu Ramsar đất ngập nước quý giá của đồng bằng sông Cửu Long, nơi lưu giữ trọn vẹn cảnh quan hoang sơ của vùng Đồng Tháp Mười thu nhỏ. Nơi đây là vương quốc của hơn 230 loài chim nước, đặc biệt là loài Sếu đầu đỏ quý hiếm nằm trong Sách đỏ thế giới về đây nhảy múa vào mùa khô.'
WHERE id = 'a2e3dbab-fcde-4eca-98aa-cb603782105d';
UPDATE heritage_info 
SET name = 'Vườn quốc gia U Minh Thượng',
    address = 'An Minh, Kiên Giang',
    latitude = 9.602452,
    longitude = 105.093211,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_157989_1.jpg',
    description = 'Vườn quốc gia U Minh Thượng thuộc tỉnh Kiên Giang, là khu bảo tồn đất ngập nước trên nền than bùn quý hiếm bậc nhất khu vực Đông Nam Á, được công nhận là Vườn Di sản ASEAN và khu Ramsar thế giới. Rừng tràm bạt ngàn soi bóng xuống mặt nước màu hổ phách đặc trưng là nơi sinh sống của rái cá lông mũi, dơi ngựa và hàng trăm loài động thực vật hoang dã quý hiếm.'
WHERE id = '1c75319f-e1d9-4cb6-84c2-669f239f2d8e';
UPDATE heritage_info 
SET name = 'Vườn quốc gia Xuân Thủy',
    address = 'Vườn quốc gia Xuân Thủy, Nam Định',
    latitude = 20.2279,
    longitude = 106.5826,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_2809_1.jpg',
    description = 'Vườn quốc gia Xuân Thủy tọa lạc tại cửa sông Hồng thuộc huyện Giao Thủy, Nam Định, là khu đất ngập nước đầu tiên của Đông Nam Á được công nhận theo Công ước Ramsar quốc tế. Vùng đầm lầy ngập mặn trù phú này là ''''ga quốc tế'''' của hàng triệu cánh chim di cư quý hiếm từ phương Bắc dừng chân tránh rét hàng năm.'
WHERE id = '17ac0b0f-5ce5-4e0e-9941-5914aeb638e6';
UPDATE heritage_info 
SET name = 'Vương cung thánh đường Đức Mẹ La Vang',
    address = 'Vương cung thánh đường Đức Mẹ La Vang, Quảng Trị',
    latitude = 16.7067,
    longitude = 107.1956,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_75786_1.jpg',
    description = 'Vương cung thánh đường Đức Mẹ La Vang thuộc tỉnh Quảng Trị là trung tâm hành hương Công giáo lớn và linh thiêng bậc nhất Việt Nam. Nơi đây gắn liền với sự tích Đức Mẹ hiển linh an ủi các tín đồ vào năm 1798 giữa cánh rừng rậm rạp, thu hút hàng triệu lượt khách hành hương mỗi năm.'
WHERE id = 'd0bb89f5-8300-4044-a90a-99bf8c0dec65';
UPDATE heritage_info 
SET name = 'Vương cung thánh đường Phú Nhai',
    address = 'Vương cung thánh đường Phú Nhai, Nam Định',
    latitude = 20.3077,
    longitude = 106.3298,
    image_url = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa_images/train_46328_1.jpg',
    description = 'Vương cung thánh đường Phú Nhai tọa lạc tại huyện Xuân Trường, Nam Định, là một trong những nhà thờ Công giáo lớn và tráng lệ bậc nhất Việt Nam mang đậm phong cách kiến trúc Gothic Tây Ban Nha. Hai tháp chuông sừng sững cao 44 mét cùng hệ thống mái vòm uốn cong chạm trổ phù điêu tinh xảo tạo nên vẻ đẹp tôn nghiêm và lộng lẫy.'
WHERE id = 'ade0405a-b1c8-43f0-bb8d-81a655c51004';

-- ------------------------------------------------------------------------------
-- 2. THÊM ĐỊA DANH MỚI: TƯỢNG CÁ CHÉP HÓA RỒNG ĐÀ NẴNG
-- ------------------------------------------------------------------------------
INSERT INTO heritage_info (id, name, category, province, province_id, address, latitude, longitude, image_url, description)
VALUES (
    'a1000001-0000-4000-a000-000000000003',
    'Tượng Cá Chép Hóa Rồng Đà Nẵng',
    'Kiến trúc & Cung đình',
    'Đà Nẵng',
    '101a8575-93a3-4f37-8dc7-45718d57ae6a',
    'Bến du thuyền DHC Marina, Đường Trần Hưng Đạo, Phường An Hải Tây, Quận Sơn Trà, TP. Đà Nẵng',
    16.0620,
    108.2295,
    'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/ca_chep_hoa_rong_da_nang.jpg',
    'Tượng Cá Chép Hóa Rồng tọa lạc tại bờ đông sông Hàn, ngay sát Cầu Tình Yêu và gần Cầu Rồng. Tác phẩm điêu khắc nặng gần 200 tấn, cao 7,5m, được chế tác tinh xảo từ khối đá cẩm thạch trắng tự nhiên Non Nước bởi các nghệ nhân làng đá Non Nước Ngũ Hành Sơn. Bức tượng mang ý nghĩa phong thủy sâu sắc về sự thăng tiến, kiên trì vượt vũ môn để hóa rồng, đồng thời liên tục phun nước ra sông Hàn tạo cảnh quan độc đáo thu hút đông đảo du khách.'
)
ON CONFLICT (id) DO UPDATE SET
    name = EXCLUDED.name,
    category = EXCLUDED.category,
    province = EXCLUDED.province,
    address = EXCLUDED.address,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude,
    image_url = EXCLUDED.image_url,
    description = EXCLUDED.description;

-- ------------------------------------------------------------------------------
-- 3. CẬP NHẬT VÀ BỔ SUNG BẢN DỊCH ĐA NGÔN NGỮ (HERITAGE_TRANSLATIONS)
-- ------------------------------------------------------------------------------
UPDATE heritage_translations
SET name = 'Bãi biển Nha Trang',
    address = 'Bãi biển Nha Trang, thành phố Nha Trang, tỉnh Khánh Hòa',
    description = 'Bãi biển Nha Trang, một trong những danh lam thắng cảnh nổi tiếng của miền Trung Việt Nam, nằm ở phía đông thành phố Nha Trang, tỉnh Khánh Hòa. Với dải cát trắng mịn, làn nước trong xanh và dải rặng san hô đa dạng, nơi đây đã thu hút hàng triệu du khách trong và ngoài nước mỗi năm. Tuy nhiên, trong những năm gần đây, bãi biển đang đối mặt với tình trạng ô nhiễm môi trường nghiêm trọng, bao gồm rác thải nhựa, chất thải sinh hoạt và các chất ô nhiễm từ hoạt động du lịch quá tải. Những vấn đề này không chỉ làm giảm giá trị thẩm mỹ mà còn đe dọa hệ sinh thái biển, ảnh hưởng đến nguồn lợi thủy sản và sức khỏe cộng đồng. Chính quyền địa phương và các tổ chức xã hội đang triển khai các biện pháp thu gom rác, nâng cao ý thức bảo vệ môi trường và phát triển du lịch bền vững nhằm khôi phục vẻ đẹp nguyên sơ của bãi biển Nha Trang.'
WHERE heritage_id = 'f5145fde-0ad3-451c-8c12-93ce05519557' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Nha Trang Beach (Bãi biển Nha Trang)',
    address = 'Bãi biển Nha Trang, thành phố Nha Trang, tỉnh Khánh Hòa',
    description = 'Bãi biển Nha Trang is an esteemed cultural and scenic landmark located in Khanh Hoa, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = 'f5145fde-0ad3-451c-8c12-93ce05519557' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ニャチャンビーチ (ニャチャン海岸)',
    address = 'Bãi biển Nha Trang, thành phố Nha Trang, tỉnh Khánh Hòa',
    description = 'Bãi biển Nha Trangは、ベトナムカインホアに位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = 'f5145fde-0ad3-451c-8c12-93ce05519557' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Bảo Tàng Điêu Khắc Chăm Đà Nẵng',
    address = 'Số 02 Đường 2 Tháng 9, Phường Bình Hiên, Quận Hải Châu, TP. Đà Nẵng',
    description = 'Bảo tàng Điêu khắc Chăm Đà Nẵng được thành lập từ năm 1915, là bảo tàng duy nhất trên thế giới lưu giữ bộ sưu tập hiện vật điêu khắc sa thạch nguyên bản tinh xảo của nền văn minh Chăm-pa cổ. Với kiến trúc phong cách Gothic kết hợp đường nét tháp Chăm cổ điển, bảo tàng trưng bày hàng loạt Bảo vật Quốc gia như Đài thờ Trà Kiệu, Đài thờ Mỹ Sơn E1 và Tượng Bồ Tát Tara.'
WHERE heritage_id = '24639b24-25a1-4b8b-a04e-87e25127f8d1' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Bảo Tàng Điêu Khắc Chăm Đà Nẵng',
    address = 'Số 02 Đường 2 Tháng 9, Phường Bình Hiên, Quận Hải Châu, TP. Đà Nẵng',
    description = 'Bảo Tàng Điêu Khắc Chăm Đà Nẵng is an esteemed cultural and scenic landmark located in Da Nang, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = '24639b24-25a1-4b8b-a04e-87e25127f8d1' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ダナン・チャム彫刻博物館',
    address = 'Số 02 Đường 2 Tháng 9, Phường Bình Hiên, Quận Hải Châu, TP. Đà Nẵng',
    description = 'Bảo Tàng Điêu Khắc Chăm Đà Nẵngは、ベトナムダナンに位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = '24639b24-25a1-4b8b-a04e-87e25127f8d1' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Bảo tàng Hồ Chí Minh (Hà Nội)',
    address = 'Bảo tàng Hồ Chí Minh (Hà Nội), Hà Nội',
    description = 'Bảo tàng Hồ Chí Minh nằm liền kề khu di tích Lăng Bác, mang hình tượng đóa sen trắng thanh cao biểu trưng cho nhân cách giản dị mà vĩ đại của Người. Bên trong bảo tàng là không gian trưng bày nghệ thuật đương đại giàu tính biểu tượng, tái hiện trọn vẹn cuộc đời và hành trình cứu nước của Chủ tịch Hồ Chí Minh.'
WHERE heritage_id = '88f03632-8f54-4866-85e1-1fcf133e2cd0' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Bảo tàng Hồ Chí Minh (Hà Nội)',
    address = 'Bảo tàng Hồ Chí Minh (Hà Nội), Hà Nội',
    description = 'The Ho Chi Minh Museum is situated adjacent to the Mausoleum complex, designed in the abstract form of a noble white lotus flower honoring the leader''''s modest yet monumental life. Its interior features conceptual and avant-garde exhibits illustrating the historical epochs of Ho Chi Minh''''s international revolutionary journey.'
WHERE heritage_id = '88f03632-8f54-4866-85e1-1fcf133e2cd0' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ホー・チミン博物館',
    address = 'Bảo tàng Hồ Chí Minh (Hà Nội), Hà Nội',
    description = 'ホー・チミン博物館は、ホー・チミン廟のすぐ隣に位置し、白蓮の花をかたどった幾何学的な外観を持つ博物館です。館内には前衛的な現代アートと展示空間が広がり、波乱に満ちた独立運動の歩みと主席の生涯が象徴的に分かりやすく解説されています。'
WHERE heritage_id = '88f03632-8f54-4866-85e1-1fcf133e2cd0' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Bảo tàng Khu 5 (Đà Nẵng)',
    address = 'Bảo tàng Khu 5 (Đà Nẵng), Đà Nẵng',
    description = 'Bảo tàng Khu 5 nằm trên đường Duy Tân, Đà Nẵng, là nơi lưu giữ và tái hiện những năm tháng đấu tranh kiên cường của quân và dân Quân khu 5 miền Trung. Khu trưng bày ngoài trời sở hữu nhiều hiện vật máy bay, xe tăng chiến lợi phẩm cùng mô hình tái hiện ngôi nhà sàn Bác Hồ với tỷ lệ chuẩn xác.'
WHERE heritage_id = 'b0ab53e8-7d08-451c-9fd1-4980982a862a' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Bảo tàng Khu 5 (Đà Nẵng)',
    address = 'Bảo tàng Khu 5 (Đà Nẵng), Đà Nẵng',
    description = 'Zone 5 Military Museum in Da Nang documents the heroic struggles and wartime resilience of the armed forces and local populace across Central Vietnam. Its expansive outdoor grounds showcase captured military tanks, fighter jets, and an authentic full-scale replica of President Ho Chi Minh''''s stilt house.'
WHERE heritage_id = 'b0ab53e8-7d08-451c-9fd1-4980982a862a' AND language_code = 'en';
UPDATE heritage_translations
SET name = '第5軍区博物館（ダナン）',
    address = 'Bảo tàng Khu 5 (Đà Nẵng), Đà Nẵng',
    description = '第5軍区博物館は、ベトナム戦争時の中部第5軍区における軍民の激しい抗戦の歴史を展示するダナンの軍事博物館です。屋外展示場には実際に使用された戦闘機や戦車などの大型兵器が並び、敷地内にはハノイのホー・チミン主席の高床式住居の正確なレプリカも再現されています。'
WHERE heritage_id = 'b0ab53e8-7d08-451c-9fd1-4980982a862a' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Bảo tàng Lịch sử Quốc gia (Hà Nội)',
    address = 'Bảo tàng Lịch sử Quốc gia (Hà Nội), Hà Nội',
    description = 'Bảo tàng Lịch sử Quốc gia trên đường Tràng Tiền là kiệt tác kiến trúc Đông Dương kinh điển do kiến trúc sư Ernest Hébrard thiết kế vào thập niên 1920. Bảo tàng trưng bày hàng trăm nghìn hiện vật khảo cổ vô giá từ thời tiền sử, văn hóa Đông Sơn rực rỡ đến các triều đại phong kiến hưng thịnh của Việt Nam.'
WHERE heritage_id = '6dc15a30-cbcb-4a7a-b05f-e8c9136f3627' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Bảo tàng Lịch sử Quốc gia (Hà Nội)',
    address = 'Bảo tàng Lịch sử Quốc gia (Hà Nội), Hà Nội',
    description = 'The National Museum of Vietnamese History on Trang Tien Street is an architectural triumph of the Indochine style created by Ernest Hebrard in the late 1920s. It houses an extraordinary collection of archaeological treasures spanning prehistoric times, the bronze Dong Son culture, and subsequent feudal dynasties.'
WHERE heritage_id = '6dc15a30-cbcb-4a7a-b05f-e8c9136f3627' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ベトナム国立歴史博物館',
    address = 'Bảo tàng Lịch sử Quốc gia (Hà Nội), Hà Nội',
    description = 'ベトナム国立歴史博物館は、ハノイのチャンティ通りにある、建築家エルネスト・エブラールが設計したインドシナ様式の最高傑作建築です。ドンソン文化の青銅太鼓をはじめ、旧石器時代から歴代封建王朝の終焉に至るまでの第一級の国宝級文化財が展示されています。'
WHERE heritage_id = '6dc15a30-cbcb-4a7a-b05f-e8c9136f3627' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Bảo tàng Mỹ thuật Việt Nam',
    address = 'Bảo tàng Mỹ thuật Việt Nam, Hà Nội',
    description = 'Bảo tàng Mỹ thuật Việt Nam tọa lạc trên phố Nguyễn Thái Học, nguyên là một dinh thự cổ kiểu Pháp được xây dựng từ thời thuộc địa với những hàng hiên và cửa sổ gỗ thanh lịch. Nơi đây lưu giữ và tôn vinh kho tàng mỹ thuật đồ sộ của dân tộc, từ tranh lụa, tranh sơn mài đỉnh cao của các danh họa Đông Dương đến tượng điêu khắc tôn giáo cổ truyền.'
WHERE heritage_id = '373d3efd-c3cd-4cb2-84aa-41a1d797b540' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Bảo tàng Mỹ thuật Việt Nam',
    address = 'Bảo tàng Mỹ thuật Việt Nam, Hà Nội',
    description = 'The Vietnam National Museum of Fine Arts on Nguyen Thai Hoc Street occupies a historic French colonial residence adorned with elegant verandas. It showcases the nation''''s premier visual arts heritage, ranging from ancient religious wood sculptures to celebrated lacquer and silk masterpieces of the Indochina Fine Arts school.'
WHERE heritage_id = '373d3efd-c3cd-4cb2-84aa-41a1d797b540' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ベトナム国立美術館',
    address = 'Bảo tàng Mỹ thuật Việt Nam, Hà Nội',
    description = 'ベトナム国立美術館は、フランス植民地時代の美しい西洋式洋館を利用したベトナム最高峰の美術の殿堂です。伝統的な仏教彫刻や民俗版画から、インドシナ美術学校出身の巨匠たちによる繊細な絹絵や漆絵画の名品まで、豊かな芸術の世界を堪能できます。'
WHERE heritage_id = '373d3efd-c3cd-4cb2-84aa-41a1d797b540' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Bảo tàng Phụ nữ Việt Nam',
    address = 'Bảo tàng Phụ nữ Việt Nam, Hà Nội',
    description = 'Bảo tàng Phụ nữ Việt Nam trên phố Lý Thường Kiệt được bình chọn là một trong những điểm tham quan hấp dẫn nhất châu Á, tôn vinh vai trò kiên cường và vĩ đại của người phụ nữ Việt Nam trong lịch sử dựng nước, giữ nước và gia đình. Các gian trưng bày phong phú từ trang phục truyền thống của phụ nữ 54 dân tộc đến những kỷ vật xúc động trong chiến tranh.'
WHERE heritage_id = '924d95d5-14d3-4e27-b4c7-243f588a4192' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Bảo tàng Phụ nữ Việt Nam',
    address = 'Bảo tàng Phụ nữ Việt Nam, Hà Nội',
    description = 'The Vietnamese Women''''s Museum on Ly Thuong Kiet Street is consistently voted among Asia''''s top cultural institutions, paying moving homage to the courage, artistry, and maternal leadership of Vietnamese women throughout history. Exhibits span vibrant tribal textiles of 54 ethnic groups to poignant personal letters from wartime heroines.'
WHERE heritage_id = '924d95d5-14d3-4e27-b4c7-243f588a4192' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ベトナム女性博物館',
    address = 'Bảo tàng Phụ nữ Việt Nam, Hà Nội',
    description = 'ベトナム女性博物館は、ハノイ中心部のリートゥオンキエット通りにあり、国際的にも高く評価されている博物館です。家族生活、歴史の中の女性、伝統衣装の3つのテーマで展示され、過酷な戦争を生き抜いた女性兵士たちの勇気や、民族ごとの華やかな織物衣装を伝えています。'
WHERE heritage_id = '924d95d5-14d3-4e27-b4c7-243f588a4192' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Biệt thự Cầu Đá (Bảo Đại)',
    address = 'Biệt thự Cầu Đá (Bảo Đại), Khánh Hòa',
    description = 'Biệt thự Cầu Đá, hay Dinh Bảo Đại Nha Trang, gồm cụm 5 tòa biệt thự kiến trúc Pháp cổ kính xây dựng trên mỏm đồi Cảnh Long nhô ra vịnh biển. Đây từng là nơi nghỉ dưỡng của vị hoàng đế cuối cùng triều Nguyễn, sở hữu tầm nhìn 360 độ ngắm trọn vẻ đẹp lộng lẫy của vịnh Nha Trang.'
WHERE heritage_id = '093c10a7-3e5d-46c3-bc5b-023f0caabf3f' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Biệt thự Cầu Đá (Bảo Đại)',
    address = 'Biệt thự Cầu Đá (Bảo Đại), Khánh Hòa',
    description = 'Bao Dai Villa in Nha Trang is a cluster of five French colonial pavilions perched gracefully atop Canh Long Hill overlooking the sapphire bay. Formerly the seaside retreat of Vietnam''''s last emperor, it offers breathtaking 360-degree vistas over one of the world''''s most scenic ocean bays.'
WHERE heritage_id = '093c10a7-3e5d-46c3-bc5b-023f0caabf3f' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'バオ・ダイ旧邸（カウダー別荘）',
    address = 'Biệt thự Cầu Đá (Bảo Đại), Khánh Hòa',
    description = 'バオ・ダイ旧邸（カウダー別荘）は、ニャチャン湾を見渡すカンロンの丘の上に建つ5棟のフランス植民地様式の別荘群です。阮朝最後の皇帝バオ・ダイの避暑地として愛用され、テラスからは世界有数の美しさを誇るニャチャン湾の大パノラマが広がります。'
WHERE heritage_id = '093c10a7-3e5d-46c3-bc5b-023f0caabf3f' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Biệt thự Hằng Nga (Crazy House Đà Lạt)',
    address = 'Biệt thự Hằng Nga (Crazy House Đà Lạt), Lâm Đồng',
    description = 'Biệt thự Hằng Nga, hay Crazy House, là kiệt tác kiến trúc siêu thực nổi tiếng toàn cầu do kiến trúc sư Đặng Việt Nga thiết kế. Các lối đi hình rễ cây uốn lượn, những căn phòng tựa hốc cây cổ thụ và hình khối phi đối xứng đưa du khách vào một thế giới cổ tích kỳ bí.'
WHERE heritage_id = '67d0cb11-171a-425e-af80-e17d0df03f49' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Biệt thự Hằng Nga (Crazy House Đà Lạt)',
    address = 'Biệt thự Hằng Nga (Crazy House Đà Lạt), Lâm Đồng',
    description = 'Crazy House, designed by architect Dang Viet Nga, is a world-renowned masterpiece of surrealist architecture in Da Lat. Its twisting tree-root stairways, mushroom-shaped rooms, and whimsical organic structures invite visitors into a captivating fairy-tale world.'
WHERE heritage_id = '67d0cb11-171a-425e-af80-e17d0df03f49' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'クレイジーハウス（ハンガー・ゲストハウス）',
    address = 'Biệt thự Hằng Nga (Crazy House Đà Lạt), Lâm Đồng',
    description = 'クレイジーハウス（ハンガー・ゲストハウス）は、女性建築家ダン・ヴィエット・ガーが手掛けた世界的に有名なシュルレアリスム建築です。巨大な古木の洞窟やクモの巣のような曲がりくねった通路が立体迷路のように広がり、まるでおとぎ話の世界に迷い込んだかのような体験が楽しめます。'
WHERE heritage_id = '67d0cb11-171a-425e-af80-e17d0df03f49' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Buôn Akõ Dhông (Buôn Cô Thôn)',
    address = 'Buôn Akõ Dhông (Buôn Cô Thôn), Đắk Lắk',
    description = 'Buôn Akõ Dhông là buôn làng cổ tích của người Ê Đê nằm ngay trong lòng thành phố Buôn Ma Thuột. Nơi đây lưu giữ nguyên vẹn hàng chục ngôi nhà dài truyền thống bằng gỗ cùng không gian văn hóa cồng chiêng sống động và phong tục dệt thổ cẩm đặc sắc.'
WHERE heritage_id = 'b2fc1f1e-56d0-4e7e-841b-b908bae52d8d' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Buôn Akõ Dhông (Buôn Cô Thôn)',
    address = 'Buôn Akõ Dhông (Buôn Cô Thôn), Đắk Lắk',
    description = 'Ako Dhong Village is a cultural heritage settlement of the Ede ethnic people nestled in Buon Ma Thuot City. It preserves dozens of traditional wooden longhouses alongside vibrant Gong performances and age-old brocade weaving crafts.'
WHERE heritage_id = 'b2fc1f1e-56d0-4e7e-841b-b908bae52d8d' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'アコ・ドン村（コ・トン村）',
    address = 'Buôn Akõ Dhông (Buôn Cô Thôn), Đắk Lắk',
    description = 'アコ・ドン村は、バンメトート市の中心部に位置するエデ族の伝統的な村落です。木造の高床式ロングハウスが立ち並び、ユネスコ無形文化遺産の銅鑼（ゴング）演奏や伝統的な絣織りの文化を間近に体験できます。'
WHERE heritage_id = 'b2fc1f1e-56d0-4e7e-841b-b908bae52d8d' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Cà phê Hide Seek Vietnam',
    address = '31 Trần Phú, Phường Cẩm Châu, Thành phố Hội An, Quảng Nam',
    description = 'Cà phê Hide Seek Vietnam tọa lạc trong khu phố cổ Hội An, nơi kiến trúc truyền thống được bảo tồn tỉ mỉ. Mặt tiền cửa hàng kết hợp những yếu tố cổ điển của nhà phố gỗ, ngói âm dương và các cột gỗ chạm khắc, đồng thời lồng ghép những đường nét hiện đại như kính cường lực và ánh sáng LED mềm mại. Sự giao thoa này không chỉ tạo nên một không gian thương mại hấp dẫn mà còn phản ánh quá trình hội nhập văn hoá du lịch, nơi người dân địa phương và khách quốc tế cùng chiêm ngưỡng vẻ đẹp hài hòa giữa quá khứ và hiện tại. Hide Seek Vietnam trở thành một biểu tượng nhỏ nhưng đầy ý nghĩa, minh chứng cho sự sáng tạo trong việc bảo tồn và phát triển di sản kiến trúc Hội An.'
WHERE heritage_id = '25156f4b-d3ad-446d-baaf-81f216fad21e' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Hide Seek Vietnam Coffee (Cà phê Hide Seek Vietnam)',
    address = '31 Trần Phú, Phường Cẩm Châu, Thành phố Hội An, Quảng Nam',
    description = 'Cà phê Hide Seek Vietnam is an esteemed cultural and scenic landmark located in Quang Nam, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = '25156f4b-d3ad-446d-baaf-81f216fad21e' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'Hide Seek Vietnam カフェ',
    address = '31 Trần Phú, Phường Cẩm Châu, Thành phố Hội An, Quảng Nam',
    description = 'Cà phê Hide Seek Vietnamは、ベトナムクアンナムに位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = '25156f4b-d3ad-446d-baaf-81f216fad21e' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Cầu Ánh Sao (Hồ Bán Nguyệt, Phú Mỹ Hưng)',
    address = 'Khu đô thị Phú Mỹ Hưng, Tân Phú, Quận 7, TP. Hồ Chí Minh',
    description = 'Cầu Ánh Sao là cây cầu bộ hành hiện đại uốn cong mềm mại qua hồ Bán Nguyệt tại khu đô thị Phú Mỹ Hưng, Quận 7, TP.HCM. Mặt cầu được gắn hàng nghìn bóng đèn led lấp lánh như dải ngân hà kết hợp hệ thống thác nước cầu vồng phun từ hai bên hông cầu tạo nên khung cảnh đêm lãng mạn bậc nhất Sài Gòn.'
WHERE heritage_id = '28cbc954-adf3-455b-b6a5-b8fe6b2ceed5' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Cầu Ánh Sao (Hồ Bán Nguyệt, Phú Mỹ Hưng)',
    address = 'Khu đô thị Phú Mỹ Hưng, Tân Phú, Quận 7, TP. Hồ Chí Minh',
    description = 'Starlight Bridge (Cau Anh Sao) is a pedestrian footbridge arching gracefully across Crescent Lake in the Phu My Hung urban area of District 7, Ho Chi Minh City. Fitted with thousands of glittering fiber-optic floor lights and illuminated rainbow waterfalls cascading from its sides, it is a favored promenade for evening romantic strolls.'
WHERE heritage_id = '28cbc954-adf3-455b-b6a5-b8fe6b2ceed5' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'スターライト橋（アインサオ橋）',
    address = 'Khu đô thị Phú Mỹ Hưng, Tân Phú, Quận 7, TP. Hồ Chí Minh',
    description = 'スターライト橋（星光橋）は、ホーチミン市7区のフーミーフン新都市区の三日月湖（クレセントレイク）に架かる歩行者専用のモダンな橋です。橋の床面に埋め込まれた無数のLEDライトが天の川のように瞬き、両サイドから流れる七色の滝のライトアップが夜のロマンチックな散策を演出します。'
WHERE heritage_id = '28cbc954-adf3-455b-b6a5-b8fe6b2ceed5' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chùa Cầu (Cầu Nhật Bản Hội An)',
    address = 'Đường Nguyễn Thị Minh Khai nối Trần Phú, Phố cổ Hội An, Quảng Nam',
    description = 'Cầu Nhật Bản, còn gọi là Cầu Đá, là một công trình kiến trúc độc đáo nằm trong khu phố cổ Hội An, Quảng Nam. Được xây dựng vào năm 1593 dưới thời chúa Nguyễn Hoàng, cầu mang dấu ấn của phong cách Nhật Bản cổ điển với những khối đá lớn được xếp chặt, tạo nên hình dáng vòm cung thanh thoát. Hai bên cầu được trang trí bằng những bức tượng đá rồng, sư tử và các họa tiết truyền thống, phản ánh sự giao thoa văn hoá giữa Nhật Bản và Việt Nam trong thời kỳ thương mại hải ngoại. Vào buổi tối, ánh đèn vàng ấm áp chiếu rọi lên bề mặt đá, tạo nên một khung cảnh lãng mạn, làm nổi bật không khí yên bình và huyền bí của phố cổ. Cầu Nhật Bản không chỉ là một công trình giao thông mà còn là biểu tượng lịch sử, văn hoá, là điểm dừng chân không thể bỏ qua của du khách khi khám phá di sản thế giới Hội An.'
WHERE heritage_id = 'd0d11c3a-2bc6-4cbd-9440-6644d3a80883' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Japanese Covered Bridge (Chua Cau)',
    address = 'Đường Nguyễn Thị Minh Khai nối Trần Phú, Phố cổ Hội An, Quảng Nam',
    description = 'Cầu Nhật Bản (Hội An) is an esteemed cultural and scenic landmark located in Quang Nam, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = 'd0d11c3a-2bc6-4cbd-9440-6644d3a80883' AND language_code = 'en';
UPDATE heritage_translations
SET name = '来遠橋 (日本橋 / チュアカウ)',
    address = 'Đường Nguyễn Thị Minh Khai nối Trần Phú, Phố cổ Hội An, Quảng Nam',
    description = 'Cầu Nhật Bản (Hội An)は、ベトナムクアンナムに位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = 'd0d11c3a-2bc6-4cbd-9440-6644d3a80883' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Cầu Rồng Đà Nẵng',
    address = 'Đường Nguyễn Văn Linh nối Võ Văn Kiệt, Quận Hải Châu & Sơn Trà, TP. Đà Nẵng',
    description = 'Cầu Rồng bắc qua dòng sông Hàn thơ mộng là kỳ quan kỹ thuật và biểu tượng thịnh vượng của Đà Nẵng hiện đại. Thiết kế mô phỏng hình tượng con rồng thời Lý dũng mãnh vươn mình ra biển Đông, chiếc cầu có khả năng phun lửa và phun nước độc đáo vào các tối cuối tuần, thu hút hàng vạn du khách trong và ngoài nước chiêm ngưỡng.'
WHERE heritage_id = '03c9fb22-2a21-417c-a76d-c009cee0154d' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Cầu Rồng Đà Nẵng',
    address = 'Đường Nguyễn Văn Linh nối Võ Văn Kiệt, Quận Hải Châu & Sơn Trà, TP. Đà Nẵng',
    description = 'Dragon Bridge is a modern architectural icon spanning the Han River, sculpted into the form of a golden dragon from the historic Ly Dynasty flying toward the East Sea. On weekend evenings, thousands of onlookers gather along the riverbanks to witness its dramatic fire and water breathing spectacles.'
WHERE heritage_id = '03c9fb22-2a21-417c-a76d-c009cee0154d' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ドラゴン橋（ロン橋）',
    address = 'Đường Nguyễn Văn Linh nối Võ Văn Kiệt, Quận Hải Châu & Sơn Trà, TP. Đà Nẵng',
    description = 'ドラゴン橋（ロン橋）は、ハン川に架かる全長666メートルの近代的な橋で、李朝時代の力強い龍が海へと向かって飛翔する姿を模しています。毎週末の夜には龍の口から火と水を噴き出す大迫力のショーが開催され、多くの観光客で賑わいます。'
WHERE heritage_id = '03c9fb22-2a21-417c-a76d-c009cee0154d' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Cầu Trần Thị Lý',
    address = 'Đường Trần Thị Lý nối Duy Tân & Ngũ Hành Sơn, TP. Đà Nẵng',
    description = 'Cầu Trần Thị Lý là một trong những điểm đến di sản tiêu biểu tọa lạc tại Đà Nẵng, lưu giữ những giá trị kiến trúc, văn hóa và cảnh quan thiên nhiên đặc sắc của Việt Nam.'
WHERE heritage_id = 'dd96af4e-7464-4794-ab43-2897febf79e3' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Cầu Trần Thị Lý',
    address = 'Đường Trần Thị Lý nối Duy Tân & Ngũ Hành Sơn, TP. Đà Nẵng',
    description = 'Cầu Trần Thị Lý is an esteemed cultural and scenic landmark located in Da Nang, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = 'dd96af4e-7464-4794-ab43-2897febf79e3' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'チャン・ティ・リー橋',
    address = 'Đường Trần Thị Lý nối Duy Tân & Ngũ Hành Sơn, TP. Đà Nẵng',
    description = 'Cầu Trần Thị Lýは、ベトナムダナンに位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = 'dd96af4e-7464-4794-ab43-2897febf79e3' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chợ Hàn Đà Nẵng',
    address = '119 Trần Phú, Phường Hải Châu 1, Quận Hải Châu, TP. Đà Nẵng',
    description = 'Chợ Hàn Đà Nẵng là một trong những điểm đến di sản tiêu biểu tọa lạc tại Đà Nẵng, lưu giữ những giá trị kiến trúc, văn hóa và cảnh quan thiên nhiên đặc sắc của Việt Nam.'
WHERE heritage_id = 'a1b1e709-73b4-46fb-8cc0-d5b3296203fc' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chợ Hàn Đà Nẵng',
    address = '119 Trần Phú, Phường Hải Châu 1, Quận Hải Châu, TP. Đà Nẵng',
    description = 'Chợ Hàn Đà Nẵng is an esteemed cultural and scenic landmark located in Da Nang, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = 'a1b1e709-73b4-46fb-8cc0-d5b3296203fc' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ハン市場 (ダナン)',
    address = '119 Trần Phú, Phường Hải Châu 1, Quận Hải Châu, TP. Đà Nẵng',
    description = 'Chợ Hàn Đà Nẵngは、ベトナムダナンに位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = 'a1b1e709-73b4-46fb-8cc0-d5b3296203fc' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chùa Âng (Chùa Angkorajaborey)',
    address = 'Chùa Âng (Chùa Angkorajaborey), Trà Vinh',
    description = 'Chùa Âng là ngôi chùa Khmer cổ kính và tiêu biểu nhất của tỉnh Trà Vinh, tọa lạc bên thắng cảnh ao Bà Om rợp bóng cây sao cổ thụ nghìn năm tuổi. Ngôi chùa mang đậm nghệ thuật kiến trúc Angkor độc đáo với mái ngói nhiều tầng uốn cong hình đuôi rắn Naga và tượng thần chim Krud nâng đỡ diềm mái trang nghiêm.'
WHERE heritage_id = '1a275e51-7771-4f2d-834d-93aafc3d89b0' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chùa Âng (Chùa Angkorajaborey)',
    address = 'Chùa Âng (Chùa Angkorajaborey), Trà Vinh',
    description = 'Chua Ang, known classically as Angkorajaborey Pagoda, is the oldest and most revered Khmer Buddhist monastery in Tra Vinh, located beside ancient Ba Om Pond. Featuring distinctive Angkorian architectural styling with soaring multi-tiered gables crowned by Naga serpents, it serves as the spiritual heart of the Mekong Khmer community.'
WHERE heritage_id = '1a275e51-7771-4f2d-834d-93aafc3d89b0' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'アン寺（アンコール・ラジャ・ボレイ寺）',
    address = 'Chùa Âng (Chùa Angkorajaborey), Trà Vinh',
    description = 'アン寺（アンコール・ラジャ・ボレイ寺）は、チャビン省の古木が生い茂るバオム池のほとりに建つ、10世紀創建のクメール仏教を代表する最古の名刹です。ナーガ（蛇神）が飾られた多層屋根や怪鳥神クルードが軒を支えるアンコール様式の建築美を今に伝えています。'
WHERE heritage_id = '1a275e51-7771-4f2d-834d-93aafc3d89b0' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chùa Bà Thiên Hậu (Chợ Lớn)',
    address = '710 Nguyễn Trãi, Phường 11, Quận 5, TP. Hồ Chí Minh',
    description = 'Chùa Bà Thiên Hậu, hay Tuệ Thành Hội Quán, tọa lạc trên đường Nguyễn Trãi, Quận 5, là một trong những ngôi miếu cổ linh thiêng bậc nhất của cộng đồng người Hoa gốc Quảng Đông dựng từ khoảng năm 1760. Ngôi miếu nổi danh với nghệ thuật đắp nổi gốm nung tinh xảo trên bờ mái tái hiện các điển tích cổ cùng những vòng nhang treo hình xoắn ốc khổng lồ ngát hương trầm.'
WHERE heritage_id = '40097db4-35b7-4b5c-b5bc-19825412f709' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chùa Bà Thiên Hậu (Chợ Lớn)',
    address = '710 Nguyễn Trãi, Phường 11, Quận 5, TP. Hồ Chí Minh',
    description = 'Thien Hau Temple (Tue Thanh Assembly Hall) on Nguyen Trai Street in District 5 is one of the most venerable and sacred Cantonese shrines in Cholon, established around 1760 to honor Mazu, Goddess of the Sea. Celebrated for its intricate ceramic dioramas adorning the tiled rooftops and colossal suspended incense spirals, it radiates profound cultural mystery.'
WHERE heritage_id = '40097db4-35b7-4b5c-b5bc-19825412f709' AND language_code = 'en';
UPDATE heritage_translations
SET name = '天后宮（ティエンハウ寺 / チョロン）',
    address = '710 Nguyễn Trãi, Phường 11, Quận 5, TP. Hồ Chí Minh',
    description = '天后宮（ティエンハウ寺 / 穂城会館）は、1760年頃に広東系華人によって建てられたチョロン地区で最も信仰を集める道教寺院です。屋根を飾る陶器製の精巧なジオラマ人形や、天井から無数に吊るされた巨大な渦巻き線香が幻想的で、航海安全と商売繁盛の神「天后聖母」が祀られています。'
WHERE heritage_id = '40097db4-35b7-4b5c-b5bc-19825412f709' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chùa Bút Tháp',
    address = 'Chùa Bút Tháp, Bắc Ninh',
    description = 'Chùa Bút Tháp tọa lạc bên bờ sông Đuống thuộc tỉnh Bắc Ninh, là một trong những trung tâm Phật giáo cổ truyền quy mô bậc nhất vùng đồng bằng Bắc Bộ. Ngôi chùa lưu giữ bảo vật quốc gia tượng Phật Bà Quan Âm nghìn mắt nghìn tay bằng gỗ thếp vàng tuyệt mỹ cùng tháp đá Báo Nghiêm hình ngòi bút vươn lên nền trời xanh.'
WHERE heritage_id = 'f8987c94-0917-404f-b3dd-9d1fab748cce' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chùa Bút Tháp',
    address = 'Chùa Bút Tháp, Bắc Ninh',
    description = 'But Thap Temple sits gracefully along the Duong River in Bac Ninh, recognized as one of the most prominent classical Buddhist sanctuaries of the Red River Delta. It houses the National Treasure statue of Thousand-armed Avalokiteshvara sculpted from lacquered wood, alongside the iconic stone Bao Nghiem Tower shaped like a calligraphy brush.'
WHERE heritage_id = 'f8987c94-0917-404f-b3dd-9d1fab748cce' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ブータップ寺（筆塔寺）',
    address = 'Chùa Bút Tháp, Bắc Ninh',
    description = 'ブータップ寺（筆塔寺）は、バクニン省のドゥオン川のほとりに位置する17世紀建立の由緒ある名刹です。国宝に指定されている見事な金箔漆塗りの「千手千眼観音菩薩像」や、筆の穂先を模して建てられた高さ13メートルの石塔「報厳塔」など、ベトナム仏教美術の粋が集められています。'
WHERE heritage_id = 'f8987c94-0917-404f-b3dd-9d1fab748cce' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chùa Đại Giác',
    address = 'Ấp Nhị Hòa, Xã Hiệp Hòa, Thành phố Biên Hòa, Đồng Nai',
    description = 'Chùa Đại Giác tọa lạc tại cù lao Phố trên sông Đồng Nai, là một trong những ngôi chùa cổ xưa nhất của vùng đất phương Nam hình thành từ thế kỷ XVII. Ngôi chùa từng là nơi công chúa Ngọc Du ẩn náu trong thời tao loạn, nổi tiếng với pho tượng Phật Di Đà bằng gỗ cao hơn 2 mét thiêng liêng.'
WHERE heritage_id = 'ba647be8-3911-42a6-93f2-d8305e20a89e' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chùa Đại Giác',
    address = 'Ấp Nhị Hòa, Xã Hiệp Hòa, Thành phố Biên Hòa, Đồng Nai',
    description = 'Dai Giac Pagoda on Pho Island in the Dong Nai River is one of Southern Vietnam''''s earliest Buddhist temples, founded in the mid-17th century by pioneering settlers. Historically associated with royal refugees during dynastic wars, it houses an ancient two-meter wooden Buddha statue venerated for centuries.'
WHERE heritage_id = 'ba647be8-3911-42a6-93f2-d8305e20a89e' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ダイザック寺（大覚寺・ドンナイ）',
    address = 'Ấp Nhị Hòa, Xã Hiệp Hòa, Thành phố Biên Hòa, Đồng Nai',
    description = 'ダイザック寺（大覚寺）は、ドンナイ川に浮かぶ歴史あるフォ中州に17世紀に開山された南部屈指の古寺です。かつて阮朝の王族が難を逃れて身を寄せた由緒を持ち、高さ2メートルを超える本尊の木造阿弥陀仏像は霊験あらたかな仏として深く信仰されています。'
WHERE heritage_id = 'ba647be8-3911-42a6-93f2-d8305e20a89e' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chùa Giác Lâm',
    address = '565 Lạc Long Quân, Phường 10, Tân Bình, TP. Hồ Chí Minh',
    description = 'Chùa Giác Lâm tọa lạc trên đường Lạc Long Quân, quận Tân Bình, được xây dựng từ năm 1744, là ngôi chùa cổ nhất còn nguyên vẹn tại Thành phố Hồ Chí Minh. Ngôi chùa mang cấu trúc chữ Tam đặc trưng Nam Bộ với 98 cột gỗ lim chạm khắc câu đối chữ Hán tinh xảo, cây bồ đề cổ thụ linh thiêng và tháp xá lợi 7 tầng hình lục giác uy nghiêm.'
WHERE heritage_id = 'fea618f7-c8aa-4b0b-9d4a-ef850d7546cf' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chùa Giác Lâm',
    address = '565 Lạc Long Quân, Phường 10, Tân Bình, TP. Hồ Chí Minh',
    description = 'Giac Lam Pagoda in Tan Binh District is the oldest documented temple in Ho Chi Minh City, established in 1744 by pioneering Chinese-Vietnamese settlers. The architectural treasure retains a traditional triple-hall layout supported by 98 polished ironwood columns, sheltering ancient Buddhist statues and a soaring seven-story hexagonal stupa.'
WHERE heritage_id = 'fea618f7-c8aa-4b0b-9d4a-ef850d7546cf' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ザックラム寺（覚林寺）',
    address = '565 Lạc Long Quân, Phường 10, Tân Bình, TP. Hồ Chí Minh',
    description = 'ザックラム寺（覚林寺）は、ホーチミン市タンビン区にある1744年創建の市内最古の仏教寺院です。98本の鉄木の巨柱が支える三連構造の本堂には、歴史ある貴重な木造仏像や金箔の扁額が並び、境内にはスリランカから贈られた聖なる菩提樹と七重の仏塔がそびえています。'
WHERE heritage_id = 'fea618f7-c8aa-4b0b-9d4a-ef850d7546cf' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chùa Giác Viên',
    address = 'Chùa Giác Viên, TP. Hồ Chí Minh',
    description = 'Chùa Giác Viên tọa lạc cạnh đầm sen công viên Đầm Sen, Quận 11, là ngôi cổ tự trên 200 năm tuổi mang đậm phong cách kiến trúc chùa truyền thống Nam Bộ. Chùa sở hữu bộ sưu tập hơn 150 pho tượng cổ bằng gỗ quý cùng những bao lam chạm lộng hình tứ linh, mai lan cúc trúc đạt đến trình độ điêu khắc bậc thầy.'
WHERE heritage_id = '6e64a470-478e-414b-a552-2948938d57cf' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chùa Giác Viên',
    address = 'Chùa Giác Viên, TP. Hồ Chí Minh',
    description = 'Giac Vien Pagoda is a 200-year-old Buddhist sanctuary nestled beside Dam Sen Lake in District 11, preserving the classic architectural heritage of southern monasteries. It shelters an invaluable collection of over 150 antique wooden statues and intricately fretworked altars depicting mythical beasts and floral allegories.'
WHERE heritage_id = '6e64a470-478e-414b-a552-2948938d57cf' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ザックヴィエン寺（覚円寺）',
    address = 'Chùa Giác Viên, TP. Hồ Chí Minh',
    description = 'ザックヴィエン寺（覚円寺）は、ダムセン公園の湖畔近くに佇む200年以上の歴史を誇る南部伝統様式の仏教古刹です。153体もの貴重な木造仏像や、四神や花鳥風月が立体的に彫り込まれた透かし彫りの祭壇など、南部工芸の最高峰の技術を今に留めています。'
WHERE heritage_id = '6e64a470-478e-414b-a552-2948938d57cf' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chùa Hang (Chùa Phước Điền, Châu Đốc)',
    address = 'Chùa Hang (Chùa Phước Điền, Châu Đốc), An Giang',
    description = 'Chùa Hang, hay Phước Điền Tự, ngự trên triền dốc thoai thoải của núi Sam, Châu Đốc, gắn liền với huyền tích về đôi rắn thần biết nghe kinh kệ tu hành. Ngôi chùa độc đáo với hệ thống am động tự nhiên trong lòng núi, các tòa tháp đỏ son uy nghiêm cùng góc nhìn bao quát toàn cảnh những cánh đồng lúa An Giang bát ngát đến tận biên giới Campuchia.'
WHERE heritage_id = '16b61ec2-f798-41c2-9448-c5f118562218' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chùa Hang (Chùa Phước Điền, Châu Đốc)',
    address = 'Chùa Hang (Chùa Phước Điền, Châu Đốc), An Giang',
    description = 'Hang Pagoda (Phuoc Dien Tu) clings dramatically to the cliffside slopes of Sam Mountain in Chau Doc, steeped in folklore about two giant spirit serpents reformed by Buddhist chants. Featuring mystical natural grottos and crimson hillside pavilions, it commands breathtaking views over the patchwork rice paddies extending to the Cambodian border.'
WHERE heritage_id = '16b61ec2-f798-41c2-9448-c5f118562218' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ハング寺（福田寺・チャウドック洞窟寺）',
    address = 'Chùa Hang (Chùa Phước Điền, Châu Đốc), An Giang',
    description = 'ハング寺（福田寺 / 洞窟寺）は、アンザン省チャウドックの霊峰サム山の断崖に築かれた神秘的な寺院です。かつて読経を聞いて改心した大蛇の伝説が残る天然の洞窟堂があり、崖に張り出すように建つ朱塗りの展望台からは見渡す限りの広大な水田とカンボジア国境の景色が広がります。'
WHERE heritage_id = '16b61ec2-f798-41c2-9448-c5f118562218' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chùa Hang (Kompong Chrey, Trà Vinh)',
    address = 'Chùa Hang (Kompong Chrey, Trà Vinh), Trà Vinh',
    description = 'Chùa Hang, tên chữ Khmer là Kompong Chrey, tọa lạc tại thị trấn Châu Thành, Trà Vinh, nổi tiếng với cổng chùa được thiết kế xuyên qua một hang sâu độc đáo. Khuôn viên chùa rộng lớn rợp bóng cây sao cổ thụ, là nơi cư ngụ của hàng vạn cánh chim trời và lưu giữ xưởng điêu khắc gỗ nghệ thuật từ gốc cây cổ thụ tinh xảo của các nhà sư Khmer.'
WHERE heritage_id = '2312eed8-b24b-4342-9e3c-77d482676b36' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chùa Hang (Kompong Chrey, Trà Vinh)',
    address = 'Chùa Hang (Kompong Chrey, Trà Vinh), Trà Vinh',
    description = 'Chua Hang, natively Kompong Chrey, is an extraordinary Khmer temple in Chau Thanh, Tra Vinh, famed for its cavernous tunnel-like entrance gate. Nestled inside a massive virgin forest populated by thousands of wild nesting birds, it features a master woodcarving atelier where talented monks craft intricate statues from reclaimed tree roots.'
WHERE heritage_id = '2312eed8-b24b-4342-9e3c-77d482676b36' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ハング寺（コンポン・チュレイ寺・チャビン）',
    address = 'Chùa Hang (Kompong Chrey, Trà Vinh), Trà Vinh',
    description = 'ハング寺（コンポン・チュレイ寺）は、チャビン省チャウタインにあるクメール仏教寺院で、まるで洞窟を通り抜けるような特徴的な門を持つことからこの名が付きました。緑豊かな巨木林には無数の野鳥が生息し、境内では僧侶たちによって古木の根から彫り出された見事な木彫り芸術が制作されています。'
WHERE heritage_id = '2312eed8-b24b-4342-9e3c-77d482676b36' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chùa Hoằng Pháp',
    address = 'Chùa Hoằng Pháp, TP. Hồ Chí Minh',
    description = 'Chùa Hoằng Pháp tọa lạc tại huyện Hóc Môn, TP.HCM, là một trong những trung tâm hoằng pháp và tu học Phật giáo lớn nhất cả nước do cố Hòa thượng Ngộ Chân Tử sáng lập năm 1957. Ngôi chùa nổi tiếng với các khóa tu mùa hè thu hút hàng vạn thanh thiếu niên, nổi bật với chính điện nguy nga hai tầng mái uốn cong và khuôn viên rợp bóng bồ đề.'
WHERE heritage_id = '214104e1-7ff7-4963-8155-6412f5a62218' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chùa Hoằng Pháp',
    address = 'Chùa Hoằng Pháp, TP. Hồ Chí Minh',
    description = 'Hoang Phap Pagoda in Hoc Mon District is one of Vietnam''''s largest and most influential centers of Pure Land Buddhist retreats, founded in 1957. Famous for its massive summer youth mindfulness camps accommodating tens of thousands of practitioners, it boasts grand dual-roofed prayer halls and tranquil bodhi courtyards.'
WHERE heritage_id = '214104e1-7ff7-4963-8155-6412f5a62218' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ホアンファップ寺（弘法寺）',
    address = 'Chùa Hoằng Pháp, TP. Hồ Chí Minh',
    description = 'ホアンファップ寺（弘法寺）は、ホーチミン市ホックモン郡に位置するベトナム最大級の仏教布教・瞑想センターです。壮大な二層屋根の本堂を備え、毎年夏に開催される青少年向けの仏教サマースクールには全国から数万人が集うことで広く知られています。'
WHERE heritage_id = '214104e1-7ff7-4963-8155-6412f5a62218' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chùa Hội Khánh',
    address = 'Chùa Hội Khánh, Bình Dương',
    description = 'Chùa Hội Khánh là ngôi đại cổ tự xây dựng từ năm 1741 tại trung tâm thành phố Thủ Dầu Một, Bình Dương. Ngôi chùa xác lập kỷ lục châu Á với bức tượng Phật Thích Ca nhập Niết bàn bằng bê tông cốt thép ngự trên mái chùa dài 52 mét và cao 12 mét uy nghiêm, nổi bật giữa khuôn viên rợp bóng cây xanh cổ thụ thanh tịnh.'
WHERE heritage_id = '6a72a28e-8f6f-48b6-914d-7db5db149f06' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chùa Hội Khánh',
    address = 'Chùa Hội Khánh, Bình Dương',
    description = 'Hoi Khanh Temple in Thu Dau Mot, Binh Duong, is a venerable Buddhist sanctuary established in 1741. It holds an official Asian record for its monumental 52-meter reclining Buddha statue resting serenely atop the temple roof, elevated 22 meters above tranquil surrounding landscaped gardens.'
WHERE heritage_id = '6a72a28e-8f6f-48b6-914d-7db5db149f06' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ホイカン寺（会慶寺・寝釈迦仏）',
    address = 'Chùa Hội Khánh, Bình Dương',
    description = 'ホイカン寺（会慶寺）は、1741年に建立されたビンズオン省を代表する歴史ある仏教寺院です。本堂の屋上に鎮座する全長52メートル・高さ12メートルの巨大な「涅槃仏像」は屋上涅槃仏としてアジア最大を誇り、静寂な境内を見下ろすように穏やかに横たわっています。'
WHERE heritage_id = '6a72a28e-8f6f-48b6-914d-7db5db149f06' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chùa Huê Nghiêm',
    address = 'Chùa Huê Nghiêm, TP. Hồ Chí Minh',
    description = 'Chùa Huê Nghiêm tọa lạc trên đường Đặng Văn Bi, thành phố Thủ Đức, là ngôi đại tự Phật giáo thanh tịnh mang phong cách kiến trúc Á Đông kết hợp hiện đại. Điểm nhấn của chùa là hồ sen thanh tịnh, tháp hoa sen đa tầng vươn cao và quần thể tượng Phật Thích Ca bằng đá cẩm thạch uy nghiêm giữa không gian thiền định xanh mát.'
WHERE heritage_id = '2e01420f-3684-4ff7-93a5-13b671164506' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chùa Huê Nghiêm',
    address = 'Chùa Huê Nghiêm, TP. Hồ Chí Minh',
    description = 'Hue Nghiem Pagoda in Thu Duc City is an expansive modern Buddhist sanctuary designed with traditional East Asian aesthetic elegance. The peaceful complex is highlighted by an idyllic lotus pond, soaring multi-tiered pagodas, and monumental white marble Buddha statues surrounded by manicured bonsai gardens.'
WHERE heritage_id = '2e01420f-3684-4ff7-93a5-13b671164506' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'フエギエム寺（華厳寺）',
    address = 'Chùa Huê Nghiêm, TP. Hồ Chí Minh',
    description = 'フエギエム寺（華厳寺）は、トゥードゥック市にある静寂と緑に包まれた広大な現代仏教寺院です。手入れの行き届いた日本庭園風の蓮池や、天に向かってそびえる優美な仏塔、白大理石の釈迦牟尼仏像が立ち並び、心洗われる瞑想の場として親しまれています。'
WHERE heritage_id = '2e01420f-3684-4ff7-93a5-13b671164506' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chùa Kim Liên',
    address = 'Phố Từ Hoa, Quảng An, Tây Hồ, Hà Nội',
    description = 'Chùa Kim Liên ngự trên bán đảo Nghi Tàm soi bóng xuống mặt nước hồ Tây êm đềm, được mệnh danh là ''''bông sen vàng'''' kiều diễm của kiến trúc Phật giáo kinh kỳ. Chùa được dựng theo lối kiến trúc chữ Tam độc đáo với ba dãy chùa song song bằng gỗ lim chạm trổ tinh vi mang dấu ấn nghệ thuật thời Tây Sơn.'
WHERE heritage_id = 'f2df3353-fcb9-44d9-9e33-f337ae8f7bda' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chùa Kim Liên',
    address = 'Phố Từ Hoa, Quảng An, Tây Hồ, Hà Nội',
    description = 'Kim Lien Pagoda rests on the tranquil Nghi Tam Peninsula along West Lake, praised as the ''''Golden Lotus'''' of classic northern Buddhist architecture. Constructed in an unusual triple-parallel hall layout using polished ironwood, it exhibits breathtaking wood-carved motifs dating to the Tay Son era.'
WHERE heritage_id = 'f2df3353-fcb9-44d9-9e33-f337ae8f7bda' AND language_code = 'en';
UPDATE heritage_translations
SET name = '金蓮寺（キムリエン寺）',
    address = 'Phố Từ Hoa, Quảng An, Tây Hồ, Hà Nội',
    description = '金蓮寺（キムリエン寺）は、西湖の静かなギータム半島に位置し、「金色の蓮」と称えられる風光明媚な寺院です。本堂は三棟の建物が平行に並ぶ「三字型」の珍しい構造で、西山朝時代の華麗な木彫り細工が随所に施されています。'
WHERE heritage_id = 'f2df3353-fcb9-44d9-9e33-f337ae8f7bda' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chùa Linh Sơn (Đà Lạt)',
    address = 'Chùa Linh Sơn (Đà Lạt), Lâm Đồng',
    description = 'Chùa Linh Sơn ngự trên ngọn đồi yên tĩnh cách trung tâm Đà Lạt 700 mét, được xây dựng từ năm 1938 với phong cách kiến trúc Á Đông thanh tịnh. Khuôn viên chùa rợp bóng thông già râm mát, có ao sen nhỏ và đại hồng chung nặng hơn 400 kg ngân nga trầm mặc giữa phố hoa.'
WHERE heritage_id = '4f2d74fe-551a-4629-b923-e3c49808dcc4' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chùa Linh Sơn (Đà Lạt)',
    address = 'Chùa Linh Sơn (Đà Lạt), Lâm Đồng',
    description = 'Linh Son Pagoda sits atop a tranquil hill just 700 meters from central Da Lat, built in 1938 in graceful traditional Asian architectural lines. Shaded by ancient pines, the peaceful monastery houses a bronze bell weighing over 400 kg and fragrant lotus ponds.'
WHERE heritage_id = '4f2d74fe-551a-4629-b923-e3c49808dcc4' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'リンソン寺（霊山寺）',
    address = 'Chùa Linh Sơn (Đà Lạt), Lâm Đồng',
    description = 'リンソン寺（霊山寺）は、ダラット中心部近くの小高い丘の上に建つ1938年建立の歴史ある仏教寺院です。落ち着いた東洋伝統の建築様式と手入れされた蓮池、古い松の木立が調和し、都会の喧騒から離れた清らかな静寂が漂います。'
WHERE heritage_id = '4f2d74fe-551a-4629-b923-e3c49808dcc4' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chùa Ngọc Hoàng (Điện Ngọc Hoàng, Đa Kao)',
    address = '73 Mai Thị Lựu, Đa Kao, Quận 1, TP. Hồ Chí Minh',
    description = 'Chùa Ngọc Hoàng, hay Phước Hải Tự, ngự tại đường Mai Thị Lựu, Quận 1, là ngôi chùa Đạo giáo cổ kính do cộng đồng người Hoa gốc Quảng Đông xây dựng vào đầu thế kỷ XX. Ngôi chùa ngập tràn khói hương huyền bí với hàng trăm pho tượng gỗ tinh xảo thờ Ngọc Hoàng Thượng Đế, Kim Hoa Thánh Mẫu và từng vinh dự đón Tổng thống Mỹ Barack Obama tới tham quan năm 2016.'
WHERE heritage_id = '88078fcb-df9c-488c-8ae8-c2ab5400eac2' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chùa Ngọc Hoàng (Điện Ngọc Hoàng, Đa Kao)',
    address = '73 Mai Thị Lựu, Đa Kao, Quận 1, TP. Hồ Chí Minh',
    description = 'The Jade Emperor Pagoda (Phuoc Hai Tu) on Mai Thi Luu Street in District 1 is an atmospheric Taoist-Buddhist sanctuary erected by the Cantonese diaspora at the dawn of the 20th century. Swathed in fragrant incense coils, it houses ornate carved statues of Taoist deities and was famously visited by US President Barack Obama in 2016.'
WHERE heritage_id = '88078fcb-df9c-488c-8ae8-c2ab5400eac2' AND language_code = 'en';
UPDATE heritage_translations
SET name = '玉皇殿（福海寺 / 福海成樹・ダカオ）',
    address = '73 Mai Thị Lựu, Đa Kao, Quận 1, TP. Hồ Chí Minh',
    description = '玉皇殿（福海寺）は、ホーチミン市1区ダカオ地区にある、20世紀初頭に広東系華人によって建てられた道教寺院です。線香の煙が立ち込める薄暗い堂内には、玉皇大帝をはじめとする精巧な木造神像が並び、2016年にはオバマ元米大統領が参拝したことでも有名です。'
WHERE heritage_id = '88078fcb-df9c-488c-8ae8-c2ab5400eac2' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chùa Quan Âm (Quận 5, Chợ Lớn)',
    address = '12 Lão Tử, Phường 11, Quận 5, TP. Hồ Chí Minh',
    description = 'Chùa Quan Âm, hay Ôn Lăng Hội Quán, tọa lạc trên đường Lão Tử, Quận 5, là ngôi đền cổ do cộng đồng người Hoa gốc Phúc Kiến xây dựng từ năm 1740 để phụng thờ Quan Thế Âm Bồ Tát và Thiên Hậu Thánh Mẫu. Ngôi đền nổi bật với nghệ thuật gốm phù điêu tinh xảo trên bờ mái, những vòng hương nhang hình nón tỏa khói trầm mặc và phong tục đánh chuông cầu an linh thiêng.'
WHERE heritage_id = '5289dfcd-5c3b-44c8-b65c-07b2da501005' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chùa Quan Âm (Quận 5, Chợ Lớn)',
    address = '12 Lão Tử, Phường 11, Quận 5, TP. Hồ Chí Minh',
    description = 'Quan Am Pagoda (Wen Ling Assembly Hall) was founded in 1740 along Lao Tu Street in Cholon by Fujian immigrants to honor the Bodhisattva of Compassion and Goddess Mazu. Famous for its dazzling rooflines populated with ceramic figurines and winding incense coils, it offers a deeply peaceful spiritual refuge in the bustling Chinatown.'
WHERE heritage_id = '5289dfcd-5c3b-44c8-b65c-07b2da501005' AND language_code = 'en';
UPDATE heritage_translations
SET name = '観音寺（チョロン温陵会館）',
    address = '12 Lão Tử, Phường 11, Quận 5, TP. Hồ Chí Minh',
    description = '観音寺（温陵会館）は、1740年に福建系華人によって建てられたチョロン地区で最も古い寺院の一つです。屋根を埋め尽くす極彩色の陶器製レリーフや、天井から無数に吊るされた渦巻き線香が幻想的で、観音菩薩や航海を守る天后聖母（媽祖）が手厚く祀られています。'
WHERE heritage_id = '5289dfcd-5c3b-44c8-b65c-07b2da501005' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chùa Quán Sứ',
    address = 'Chùa Quán Sứ, Hà Nội',
    description = 'Chùa Quán Sứ nằm trên phố Quán Sứ, Hà Nội, được khởi dựng từ thế kỷ XV thời nhà Lê làm nơi tiếp đón các sứ thần của các nước láng giềng theo đạo Phật. Ngày nay, ngôi chùa cổ kính rợp bóng bồ đề chính là trụ sở trung ương của Giáo hội Phật giáo Việt Nam, trung tâm học thuật và hoằng pháp thiêng liêng của tăng ni, phật tử cả nước.'
WHERE heritage_id = 'ec42a6ff-86dc-4d3f-9557-af8096240086' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chùa Quán Sứ',
    address = 'Chùa Quán Sứ, Hà Nội',
    description = 'Quan Su Pagoda on Quan Su Street was founded in the 15th century under the Le Dynasty as a diplomatic guesthouse for Buddhist envoys from neighboring nations. Today, shaded by sacred bodhi trees, the venerable temple serves as the administrative headquarters of the Buddhist Sangha of Vietnam.'
WHERE heritage_id = 'ec42a6ff-86dc-4d3f-9557-af8096240086' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'クアンスー寺（館使寺）',
    address = 'Chùa Quán Sứ, Hà Nội',
    description = 'クアンスー寺（館使寺）は、15世紀の黎朝時代に仏教国の使節を迎える迎賓館として建てられたハノイの中心寺院です。現在はベトナム仏教協会の総本部が置かれており、菩提樹の木陰が涼しい境内は全国の僧侶や仏教徒が集う信仰の中心地となっています。'
WHERE heritage_id = 'ec42a6ff-86dc-4d3f-9557-af8096240086' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chùa Vạn Niên (Hồ Tây)',
    address = '364 Lạc Long Quân, Xuân La, Tây Hồ, Hà Nội',
    description = 'Chùa Vạn Niên tọa lạc tại làng Lạc Long Quân ven bờ hồ Tây, là ngôi chùa cổ hơn 1.000 năm tuổi được xây dựng từ năm 1014 dưới triều vua Lý Thái Tổ. Chùa nổi tiếng với pho tượng Phật Thích Ca bằng ngọc bích tự nhiên nguyên khối nặng hơn 600 kg cùng hệ thống kết cấu gỗ lim chạm trổ rồng mây tinh xảo mang phong cách kiến trúc thời Nguyễn.'
WHERE heritage_id = 'ff76cb72-a7f2-408d-8163-e6771bdebd6a' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chùa Vạn Niên (Hồ Tây)',
    address = '364 Lạc Long Quân, Xuân La, Tây Hồ, Hà Nội',
    description = 'Van Nien Pagoda is an ancient thousand-year-old temple gracing the southwestern shore of West Lake, founded in 1014 during Emperor Ly Thai To''''s reign. The serene lakeside sanctuary is famed for its rare 600-kg solid jade statue of Shakyamuni Buddha and exquisite wooden rafters carved in dragon motifs.'
WHERE heritage_id = 'ff76cb72-a7f2-408d-8163-e6771bdebd6a' AND language_code = 'en';
UPDATE heritage_translations
SET name = '万年寺（ヴァンニエン寺・西湖）',
    address = '364 Lạc Long Quân, Xuân La, Tây Hồ, Hà Nội',
    description = '万年寺（ヴァンニエン寺）は、西湖のほとりに建つ1014年李朝時代創建の千年以上の歴史を持つ古刹です。重さ約600キロの天然翡翠（ヒスイ）の一枚岩から彫り出された釈迦牟尼仏像が祀られており、静かな湖の借景と木造建築の美しさが巡礼者の心を癒やします。'
WHERE heritage_id = 'ff76cb72-a7f2-408d-8163-e6771bdebd6a' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chùa Vĩnh Nghiêm (TP.HCM)',
    address = 'Chùa Vĩnh Nghiêm (TP.HCM), TP. Hồ Chí Minh',
    description = 'Chùa Vĩnh Nghiêm tọa lạc trên đường Nam Kỳ Khởi Nghĩa, Quận 3, được xây dựng từ năm 1964 theo nguyên mẫu ngôi tổ đình Vĩnh Nghiêm gốc tại Bắc Giang bằng kỹ thuật bê tông cốt thép hiện đại. Ngôi chùa sở hữu tòa tháp Quán Thế Âm 7 tầng cao 40 mét uy nghiêm, là trung tâm sinh hoạt tâm linh và hoằng pháp Phật giáo lớn bậc nhất của cộng đồng Phật tử miền Nam.'
WHERE heritage_id = '69620411-f3f5-40bd-a80f-9c5b06513fbd' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chùa Vĩnh Nghiêm (TP.HCM)',
    address = 'Chùa Vĩnh Nghiêm (TP.HCM), TP. Hồ Chí Minh',
    description = 'Vinh Nghiem Pagoda on Nam Ky Khoi Nghia Boulevard in District 3 was constructed in 1964, modeling its traditional northern Mahayana forms in modern reinforced concrete after the historic Bac Giang ancestor temple. Anchored by the majestic 40-meter, seven-story Avalokiteshvara Tower, it serves as a central spiritual sanctuary in modern Saigon.'
WHERE heritage_id = '69620411-f3f5-40bd-a80f-9c5b06513fbd' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ヴィンギエム寺（永厳寺 / ホーチミン市）',
    address = 'Chùa Vĩnh Nghiêm (TP.HCM), TP. Hồ Chí Minh',
    description = 'ヴィンギエム寺（永厳寺）は、ホーチミン市3区のナムキーコイギア通りに1964年に建立された、北部バクニン省の古刹をモデルとした鉄筋コンクリート造りの大寺院です。高さ40メートルの壮大な七重の「観世音仏塔」がそびえ、南部における北部仏教伝統を受け継ぐ最大の拠点として多くの参拝者で賑わいます。'
WHERE heritage_id = '69620411-f3f5-40bd-a80f-9c5b06513fbd' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chùa Xá Lợi',
    address = 'Chùa Xá Lợi, TP. Hồ Chí Minh',
    description = 'Chùa Xá Lợi tọa lạc tại góc đường Bà Huyện Thanh Quan, Quận 3, được xây dựng từ năm 1956 để phụng thờ xá lợi Phật Thích Ca linh thiêng. Ngôi chùa là một trung tâm lịch sử quan trọng gắn liền với phong trào Phật giáo miền Nam năm 1963, nổi bật với tháp chuông 7 tầng cao 32 mét độc đáo và pho tượng Phật Thích Ca bằng đồng lớn tại chính điện thanh tịnh.'
WHERE heritage_id = 'af96b651-15f8-4d15-8169-7c666b849a3e' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chùa Xá Lợi',
    address = 'Chùa Xá Lợi, TP. Hồ Chí Minh',
    description = 'Xa Loi Pagoda in District 3 was constructed in 1956 to enshrine sacred bone relics of the Buddha, designed in refined contemporary Buddhist architecture. The historic temple served as the central nerve center during the fateful Buddhist movement of 1963, distinguished by its iconic seven-story 32-meter bell tower.'
WHERE heritage_id = 'af96b651-15f8-4d15-8169-7c666b849a3e' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'サーロイ寺（舎利寺）',
    address = 'Chùa Xá Lợi, TP. Hồ Chí Minh',
    description = 'サーロイ寺（舎利寺）は、ホーチミン市3区にある、仏舎利（釈迦の遺骨）を奉安するために1956年に建立された近代仏教建築の名刹です。1963年の仏教徒危機における重要な抗議運動の拠点となった歴史を持ち、高さ32メートルの七重の鐘楼と落ち着いた本堂が信仰を集めています。'
WHERE heritage_id = 'af96b651-15f8-4d15-8169-7c666b849a3e' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Công Viên Châu Á (Asia Park)',
    address = 'Số 1 Phan Đăng Lưu, Phường Hòa Cường Bắc, Quận Hải Châu, TP. Đà Nẵng',
    description = 'Công Viên Châu Á (Asia Park) là một trong những điểm đến di sản tiêu biểu tọa lạc tại Đà Nẵng, lưu giữ những giá trị kiến trúc, văn hóa và cảnh quan thiên nhiên đặc sắc của Việt Nam.'
WHERE heritage_id = '4822d6d9-1227-43fc-bf26-c1daff62e516' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Công Viên Châu Á (Asia Park)',
    address = 'Số 1 Phan Đăng Lưu, Phường Hòa Cường Bắc, Quận Hải Châu, TP. Đà Nẵng',
    description = 'Công Viên Châu Á (Asia Park) is an esteemed cultural and scenic landmark located in Da Nang, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = '4822d6d9-1227-43fc-bf26-c1daff62e516' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'アジアパーク・ダナン (Asia Park)',
    address = 'Số 1 Phan Đăng Lưu, Phường Hòa Cường Bắc, Quận Hải Châu, TP. Đà Nẵng',
    description = 'Công Viên Châu Á (Asia Park)は、ベトナムダナンに位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = '4822d6d9-1227-43fc-bf26-c1daff62e516' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Công viên Văn hóa Đầm Sen',
    address = '03 Hòa Bình, Phường 3, Quận 11, TP. Hồ Chí Minh',
    description = 'Công viên Văn hóa Đầm Sen tọa lạc tại Quận 11, TP.HCM, là ốc đảo giải trí xanh mát gắn liền với tuổi thơ của biết bao thế hệ người dân Sài Gòn. Công viên sở hữu hệ thống hàng chục trò chơi mạo hiểm cảm giác mạnh, công viên nước Đầm Sen sôi động, vườn chim thú hoang dã và sân khấu nhạc nước nghệ thuật lung linh.'
WHERE heritage_id = 'd730f525-d098-4101-a5af-6904de2621b0' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Công viên Văn hóa Đầm Sen',
    address = '03 Hòa Bình, Phường 3, Quận 11, TP. Hồ Chí Minh',
    description = 'Dam Sen Cultural Park in District 11 is an expansive green amusement oasis deeply cherished in the childhood memories of Saigon residents. Covering 50 hectares around a natural lake, it features thrill rides, water slides at Dam Sen Water Park, zoological exhibits, and dazzling laser fountain shows.'
WHERE heritage_id = 'd730f525-d098-4101-a5af-6904de2621b0' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ダムセン文化公園',
    address = '03 Hòa Bình, Phường 3, Quận 11, TP. Hồ Chí Minh',
    description = 'ダムセン文化公園は、ホーチミン市11区の広大な天然湖を中心に広がる、市民に長年親しまれている老舗総合アミューズメントパークです。絶叫マシンが揃う遊園地、巨大ウォーターパーク、動植物園、夜の噴水レーザーショーなどがあり、週末は家族連れで大いに賑わいます。'
WHERE heritage_id = 'd730f525-d098-4101-a5af-6904de2621b0' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Cung An Định',
    address = 'Số 2, Đường Thái Thịnh, Phường Phú Nhuận, Thành phố Huế, Thừa Thiên Huế',
    description = 'Cung An Định là viên ngọc kiến trúc độc đáo bên bờ sông An Cựu ở cố đô Huế, từng là nơi sinh sống của vua Khải Định và hoàng đế Bảo Đại. Tòa lâu đài ba tầng kết hợp hài hòa giữa hoa văn phù điêu La Mã cổ điển với các họa tiết cung đình phương Đông tinh xảo.'
WHERE heritage_id = '909a81f2-b273-40d6-87a4-b38410045fe5' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'An Dinh Palace',
    address = 'Số 2, Đường Thái Thịnh, Phường Phú Nhuận, Thành phố Huế, Thừa Thiên Huế',
    description = 'An Dinh Palace is a magnificent architectural gem on the banks of An Cuu River in Hue, serving as the private residence of Emperor Khai Dinh and later Emperor Bao Dai. The three-story residence masterfully blends European neoclassical motifs with elaborate traditional Vietnamese imperial craftsmanship.'
WHERE heritage_id = '909a81f2-b273-40d6-87a4-b38410045fe5' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'アンディン宮',
    address = 'Số 2, Đường Thái Thịnh, Phường Phú Nhuận, Thành phố Huế, Thừa Thiên Huế',
    description = 'アンディン宮は、フエのアンクー川のほとりに建つカイディン（啓成）帝とバオ・ダイ（保大）帝の私邸だった歴史的宮殿です。ヨーロッパの新古典主義とベトナム伝統の宮廷装飾が見事に調和した優雅な西洋風建築群を誇ります。'
WHERE heritage_id = '909a81f2-b273-40d6-87a4-b38410045fe5' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Cung Văn hóa Lao động Hữu nghị Việt - Xô (Quảng trường 1-5)',
    address = 'Cung Văn hóa Lao động Hữu nghị Việt - Xô (Quảng trường 1-5), Hà Nội',
    description = 'Cung Văn hóa Lao động Hữu nghị Việt - Xô tọa lạc trên quảng trường 1-5 đường Trần Hưng Đạo, là công trình văn hóa quy mô lớn do Liên Xô trao tặng cho giai cấp công nhân Việt Nam năm 1985. Tòa nhà mang phong cách kiến trúc hiện đại của khối Xã hội Chủ nghĩa với hệ thống hội trường lớn, nhà hát và các phòng sinh hoạt nghệ thuật đa năng.'
WHERE heritage_id = 'a7732621-db59-40ed-bcba-b51187dd6ba8' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Cung Văn hóa Lao động Hữu nghị Việt - Xô (Quảng trường 1-5)',
    address = 'Cung Văn hóa Lao động Hữu nghị Việt - Xô (Quảng trường 1-5), Hà Nội',
    description = 'The Vietnam - Soviet Friendship Labor Cultural Palace sits on 1-5 Square along Tran Hung Dao Street, gifted by the Soviet Union to Vietnamese workers in 1985. Designed in monumental socialist modernist architecture, it houses expansive auditoriums, theaters, and multifunctional exhibition spaces for national cultural events.'
WHERE heritage_id = 'a7732621-db59-40ed-bcba-b51187dd6ba8' AND language_code = 'en';
UPDATE heritage_translations
SET name = '越ソ労働友好文化宮殿（5月1日広場）',
    address = 'Cung Văn hóa Lao động Hữu nghị Việt - Xô (Quảng trường 1-5), Hà Nội',
    description = '越ソ労働友好文化宮殿（5月1日広場）は、1985年にソ連からベトナムの労働者階級へと寄贈されたハノイ中心部の壮大な複合文化施設です。社会主義モダニズム建築の重厚な佇まいを誇り、大劇場や展示ホールを備え、主要な芸術公演や国際イベントが開催されています。'
WHERE heritage_id = 'a7732621-db59-40ed-bcba-b51187dd6ba8' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Đại Nội Huế (Hoàng Thành Huế)',
    address = 'Đại Nội Huế (Hoàng Thành Huế), Thừa Thiên Huế',
    description = 'Đại Nội Huế là trung tâm chính trị, văn hóa và quân sự đầu não của triều đại nhà Nguyễn suốt 143 năm, được UNESCO công nhận là Di sản Văn hóa Thế giới năm 1993. Quần thể gồm hàng trăm công trình cung điện nguy nga, miếu thờ thâm nghiêm và hào nước bao quanh theo thế đất phong thủy hoàn hảo.'
WHERE heritage_id = 'be919670-07f9-4747-a56a-642fd2a54ec1' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Đại Nội Huế (Hoàng Thành Huế)',
    address = 'Đại Nội Huế (Hoàng Thành Huế), Thừa Thiên Huế',
    description = 'The Imperial City of Hue served as the political, cultural, and ceremonial hub of Vietnam''''s final imperial dynasty for 143 years, inscribed as a UNESCO World Heritage site in 1993. Surrounded by a massive moat, it encompasses hundreds of palaces, shrines, and pavilions aligned with geomantic harmony.'
WHERE heritage_id = 'be919670-07f9-4747-a56a-642fd2a54ec1' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'フエ王宮（大内皇城）',
    address = 'Đại Nội Huế (Hoàng Thành Huế), Thừa Thiên Huế',
    description = 'フエ王宮（皇城）は、阮朝が143年間にわたり首都とした王権の中心地であり、1993年にベトナム初の世界文化遺産に登録されました。頑丈な城壁と堀に囲まれた広大な敷地内には、華麗な宮殿や廟、庭園が風水の思想に基づき整然と配置されています。'
WHERE heritage_id = 'be919670-07f9-4747-a56a-642fd2a54ec1' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Đan Viện Thánh Mẫu Châu Sơn Đơn Dương',
    address = 'Đan Viện Thánh Mẫu Châu Sơn Đơn Dương, Lâm Đồng',
    description = 'Đan viện Thánh Mẫu Châu Sơn là tu viện cổ dòng Xitô tọa lạc giữa thung lũng thanh bình thuộc huyện Đơn Dương, Lâm Đồng. Công trình gây ấn tượng sâu sắc bởi nghệ thuật kiến trúc Gothic hoàn toàn từ gạch đỏ không tô trát, mái vòm vươn cao cổ kính giữa rừng thông tĩnh mịch.'
WHERE heritage_id = '8e74e32d-9fac-436d-98a1-e46935cf0d80' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Đan Viện Thánh Mẫu Châu Sơn Đơn Dương',
    address = 'Đan Viện Thánh Mẫu Châu Sơn Đơn Dương, Lâm Đồng',
    description = 'Chau Son Cistercian Monastery is a contemplative monastery nestled in a secluded valley of Don Duong District, Lam Dong. The abbey captivates visitors with its striking unplastered red-brick Gothic architecture and soaring pointed spires set against silent pine groves.'
WHERE heritage_id = '8e74e32d-9fac-436d-98a1-e46935cf0d80' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'チャウソン・ドンズオン修道院',
    address = 'Đan Viện Thánh Mẫu Châu Sơn Đơn Dương, Lâm Đồng',
    description = 'チャウソン・ドンズオン修道院は、ラムドン省ドンズオン県の静かな谷あいに佇むシトー会の修道院です。漆喰を塗らずに赤レンガをそのまま積み上げて造られた壮麗なネオゴシック様式の建築群が、鬱蒼とした森の中で神聖な美しさを放っています。'
WHERE heritage_id = '8e74e32d-9fac-436d-98a1-e46935cf0d80' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Đảo Hòn Dấu',
    address = 'Đảo Hòn Dấu, Hải Phòng',
    description = 'Đảo Hòn Dấu là viên ngọc xanh hoang sơ nằm cách bán đảo Đồ Sơn, Hải Phòng chưa đầy một hải lý, nổi tiếng với rừng nguyên sinh nhiệt đới đa tầng nguyên vẹn và ngọn hải đăng hơn 100 năm tuổi. Nơi đây còn có đền thờ Nam Hải Thần Vương linh thiêng được các ngư dân miền biển thành kính phụng thờ.'
WHERE heritage_id = '233d51dc-fc42-490e-bf82-1c09dfba32d2' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Đảo Hòn Dấu',
    address = 'Đảo Hòn Dấu, Hải Phòng',
    description = 'Hon Dau Island is a lush emerald islet located just one nautical mile off Do Son Peninsula in Hai Phong, famed for its ancient climax rainforest and a century-old French lighthouse. The sacred island also shelters the revered shrine of the Lord of the South Sea, worshiped by seafaring fishing communities.'
WHERE heritage_id = '233d51dc-fc42-490e-bf82-1c09dfba32d2' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ホンダウ島',
    address = 'Đảo Hòn Dấu, Hải Phòng',
    description = 'ホンダウ島は、ハイフォン市のドーソン半島沖合に浮かぶ、手つかずの熱帯原生林に覆われた小島です。100年以上の歴史を刻むフランス式灯台や、航海の安全を祈願する神聖な南海神王廟があり、静かな自然美と信仰が息づいています。'
WHERE heritage_id = '233d51dc-fc42-490e-bf82-1c09dfba32d2' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Đền Hai Bà Trưng (Mê Linh)',
    address = 'Đền Hai Bà Trưng (Mê Linh), Hà Nội',
    description = 'Đền Hai Bà Trưng tọa lạc tại làng Hạ Lôi, huyện Mê Linh, Hà Nội, là mảnh đất quê hương và cũng là nơi hai nữ anh hùng dân tộc Trưng Trắc - Trưng Nhị phất cờ khởi nghĩa giành độc lập vào năm 40 sau Công nguyên. Quần thể đền mang kiến trúc ''''nội công ngoại quốc'''' bề thế, lưu giữ nhiều sắc phong, đồ thờ cổ quý giá cùng lễ hội rước kiệu thiêng liêng đầu xuân.'
WHERE heritage_id = '9f95bdc1-4ed6-48dd-836b-641edcbf569c' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Đền Hai Bà Trưng (Mê Linh)',
    address = 'Đền Hai Bà Trưng (Mê Linh), Hà Nội',
    description = 'The Hai Ba Trung Temple in Me Linh, Hanoi, marks the ancestral homeland where the heroic sisters Trung Trac and Trung Nhi launched their historic uprising against foreign rule in 40 CE. Built in grand classical temple architecture, it preserves ancient imperial decrees, bronze statues, and reverent traditional spring procession festivals.'
WHERE heritage_id = '9f95bdc1-4ed6-48dd-836b-641edcbf569c' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ハイ・バー・チュン寺（二徴夫人廟・メーリン）',
    address = 'Đền Hai Bà Trưng (Mê Linh), Hà Nội',
    description = 'ハイ・バー・チュン寺（二徴夫人廟）は、西暦40年に漢の支配に対して独立蜂起を起こした救国の英雄・徴姉妹の故郷メーリンに建つ神社です。荘厳な伝統建築様式の社殿には徴姉妹の尊像が祀られ、毎年旧暦正月の例大祭では勇壮な神輿行列が行われます。'
WHERE heritage_id = '9f95bdc1-4ed6-48dd-836b-641edcbf569c' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Đền Kim Liên (Kim Liên Tứ Trấn)',
    address = 'Đền Kim Liên (Kim Liên Tứ Trấn), Hà Nội',
    description = 'Đền Kim Liên tọa lạc tại phường Phương Liên, quận Đống Đa, là trấn phía Nam trong cụm di tích Thăng Long Tứ Trấn linh thiêng bảo vệ kinh thành Thăng Long xưa. Ngôi đền thờ thần Cao Sơn Đại Vương, nổi bật với hệ thống văn bia cổ, cổng tam quan bề thế và nghệ thuật chạm khắc gỗ thời Lê trung hưng đặc sắc.'
WHERE heritage_id = 'e705e3c1-86e9-4795-a4d0-222e47ec6f11' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Đền Kim Liên (Kim Liên Tứ Trấn)',
    address = 'Đền Kim Liên (Kim Liên Tứ Trấn), Hà Nội',
    description = 'Kim Lien Shrine is the sacred southern guardian shrine among the historic ''''Four Sacred Protectors'''' that shielded imperial Thang Long from harm. Dedicated to the mountain deity Cao Son Dai Vuong, the shrine preserves ancient stone steles, monumental brick gates, and fine Late Le dynasty wooden reliefs.'
WHERE heritage_id = 'e705e3c1-86e9-4795-a4d0-222e47ec6f11' AND language_code = 'en';
UPDATE heritage_translations
SET name = '金蓮祠（キムリエン祠・ハノイ四鎮）',
    address = 'Đền Kim Liên (Kim Liên Tứ Trấn), Hà Nội',
    description = '金蓮祠（キムリエン祠）は、古都タンロン（現ハノイ）を四方から守護する「タンロン四鎮」のうち、南方を守護する神聖な霊廟です。山神「高山大王」を祀り、古い石碑や堂々たる山門、後黎朝時代の見事な木彫り装飾が保存されています。'
WHERE heritage_id = 'e705e3c1-86e9-4795-a4d0-222e47ec6f11' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Đền Quán Thánh (Trấn Vũ Quán)',
    address = 'Đền Quán Thánh (Trấn Vũ Quán), Hà Nội',
    description = 'Đền Quán Thánh ngự tại ngã tư đường Thanh Niên và Quán Thánh nhìn ra hồ Tây, là trấn phía Bắc trong Thăng Long Tứ Trấn được lập từ thời vua Lý Thái Tổ. Ngôi đền Đạo giáo thờ thần Huyền Thiên Trấn Vũ, nổi tiếng với bức tượng thần bằng đồng đen nguyên khối đúc năm 1677 cao gần 4 mét và nặng 4 tấn được xem là kiệt tác đúc đồng cổ.'
WHERE heritage_id = 'de8f6daf-906f-4bc7-ba71-ceb14c1cebf3' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Đền Quán Thánh (Trấn Vũ Quán)',
    address = 'Đền Quán Thánh (Trấn Vũ Quán), Hà Nội',
    description = 'Quan Thanh Temple guards the northern gate of ancient Thang Long at the scenic junction of Thanh Nien Road and West Lake, established during Emperor Ly Thai To''''s reign. Dedicated to the Taoist deity Huyen Thien Tran Vu, it houses a magnificent 4-ton bronze statue cast in 1677, recognized as a supreme feat of metallurgy.'
WHERE heritage_id = 'de8f6daf-906f-4bc7-ba71-ceb14c1cebf3' AND language_code = 'en';
UPDATE heritage_translations
SET name = '鎮武観（クアンタイン寺・ハノイ四鎮）',
    address = 'Đền Quán Thánh (Trấn Vũ Quán), Hà Nội',
    description = '鎮武観（クアンタイン寺）は、西湖とチュックバック湖を分ける青年の道の起点に建つ「タンロン四鎮」の北方を守護する道教寺院です。1677年に鋳造された重さ約4トン・高さ約4メートルの巨大な黒銅製の「玄天鎮武神像」（国宝）が本堂に堂々と鎮座しています。'
WHERE heritage_id = 'de8f6daf-906f-4bc7-ba71-ceb14c1cebf3' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Điện Kính Thiên (Hoàng thành Thăng Long)',
    address = 'Điện Kính Thiên (Hoàng thành Thăng Long), Hà Nội',
    description = 'Điện Kính Thiên là hạt nhân trung tâm quan trọng bậc nhất của Hoàng thành Thăng Long, nơi cử hành các đại lễ quốc gia trọng thể nhất của các triều đại phong kiến Đại Việt. Hiện nay khu di tích còn lưu giữ nguyên vẹn đôi rồng đá thời Lê sơ thế kỷ XV với nghệ thuật điêu khắc đá đạt đến đỉnh cao tinh xảo.'
WHERE heritage_id = 'ec5b685a-7c60-47f6-9195-529b0ee43952' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Điện Kính Thiên (Hoàng thành Thăng Long)',
    address = 'Điện Kính Thiên (Hoàng thành Thăng Long), Hà Nội',
    description = 'Kinh Thien Palace forms the supreme ceremonial heart of the UNESCO-inscribed Imperial Citadel of Thang Long, where monarchs hosted critical national rituals. Today, its grand stone terrace preserves the National Treasure twin dragons carved in monolithic stone from the 15th-century Early Le Dynasty.'
WHERE heritage_id = 'ec5b685a-7c60-47f6-9195-529b0ee43952' AND language_code = 'en';
UPDATE heritage_translations
SET name = '敬天殿（タンロン遺跡）',
    address = 'Điện Kính Thiên (Hoàng thành Thăng Long), Hà Nội',
    description = '敬天殿は、ユネスコ世界遺産のタンロン皇城の中心に位置し、歴代王朝の最も重要な国家儀式が挙行された正殿跡です。現在残る階段には、15世紀の黎朝初期に一枚の石から彫り出された国宝「石龍」が今も堂々たる威厳を保っています。'
WHERE heritage_id = 'ec5b685a-7c60-47f6-9195-529b0ee43952' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Đình làng Đinh Lăng',
    address = 'Đình làng Đinh Lăng, Xã Cao Hy, Huyện Hải Lăng, Tỉnh Quảng Trị, Việt Nam',
    description = 'Đình làng Đinh Lăng tọa lạc tại xã Cao Hy, huyện Hải Lăng, tỉnh Quảng Trị, là một công trình kiến trúc mang đậm dấu ấn cung đình Huế. Được xây dựng theo kiểu nhà rường, công trình sử dụng khung gỗ chặt, mái ngói âm dương, và các họa tiết chạm khắc tinh xảo trên trần và cột, phản ánh sự giao thoa giữa kiến trúc cung đình và truyền thống làng xã. Khác với nhà cổ Huế, nơi tập trung vào không gian nghi lễ hoàng gia, và nhà sàn Tây Nguyên, vốn dựa vào khung sàn nâng lên để thích nghi với khí hậu, nhà rường Đinh Lăng có kết cấu khép kín, tường gạch và mái ngói dày, tạo nên sự bền vững và thẩm mỹ đặc trưng. Đình không chỉ là nơi hội họp, lễ hội của cộng đồng mà còn là biểu tượng văn hoá, lưu giữ những giá trị lịch sử, phong tục và nghệ thuật chạm khắc truyền thống của người dân Quảng Trị.'
WHERE heritage_id = 'bcfbc7cc-8727-416c-9d2e-cb3453da261d' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Dinh Lang Village Hall (Đình làng Đinh Lăng)',
    address = 'Đình làng Đinh Lăng, Xã Cao Hy, Huyện Hải Lăng, Tỉnh Quảng Trị, Việt Nam',
    description = 'Đình làng Đinh Lăng is an esteemed cultural and scenic landmark located in Quang Tri, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = 'bcfbc7cc-8727-416c-9d2e-cb3453da261d' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ディンラン村集会所 (クアンチ)',
    address = 'Đình làng Đinh Lăng, Xã Cao Hy, Huyện Hải Lăng, Tỉnh Quảng Trị, Việt Nam',
    description = 'Đình làng Đinh Lăngは、ベトナムクアンチに位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = 'bcfbc7cc-8727-416c-9d2e-cb3453da261d' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Đồi Cù (Sân golf Đà Lạt)',
    address = 'Đồi Cù (Sân golf Đà Lạt), Lâm Đồng',
    description = 'Đồi Cù là quần thể đồi cỏ thoai thoải xanh mướt uốn lượn ôm trọn bờ hồ Xuân Hương thơ mộng của Đà Lạt. Từng là sân golf cổ nhất Việt Nam do Vua Bảo Đại sáng lập, nơi đây nổi bật với thảm thực vật ôn đới và hàng thông reo lãng mạn.'
WHERE heritage_id = '4dc35f66-34e5-4319-9926-8dc3c98e79a7' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Đồi Cù (Sân golf Đà Lạt)',
    address = 'Đồi Cù (Sân golf Đà Lạt), Lâm Đồng',
    description = 'Cu Hill comprises gentle, verdant slopes embracing the picturesque shores of Xuan Huong Lake in Da Lat. Home to Vietnam''''s oldest golf course founded by Emperor Bao Dai, the rolling greens are adorned with whispering pines and crisp temperate breezes.'
WHERE heritage_id = '4dc35f66-34e5-4319-9926-8dc3c98e79a7' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'クーの丘（ダラット・ゴルフ場）',
    address = 'Đồi Cù (Sân golf Đà Lạt), Lâm Đồng',
    description = 'クーの丘は、スアンフーン湖畔に広がる緩やかな起伏が美しい緑豊かな丘陵地帯です。かつてバオ・ダイ皇帝によって造られたベトナム最古のゴルフ場があり、松林を渡る涼風と穏やかな緑の景観が人々を魅了します。'
WHERE heritage_id = '4dc35f66-34e5-4319-9926-8dc3c98e79a7' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Động Phong Nha',
    address = 'Động Phong Nha, Xã Phong Nha, Huyện Bố Trạch, Tỉnh Quảng Bình, Việt Nam',
    description = 'Động Phong Nha, nằm trong khu bảo tồn thiên nhiên Phong Nha – Kẻ Bàng, tỉnh Quảng Bình, là một trong những hệ thống hang động karst lớn và cổ nhất thế giới. Được hình thành hơn 400 triệu năm trước qua quá trình hòa tan đá vôi dưới tác động của nước ngầm, hang chứa hơn 150 km đường đi trong các phòng, thạch nhũ và sông ngầm, trong đó Động Phong Nha là phần chính, dài khoảng 7,5 km và có các thạch nhũ khổng lồ, thạch nhũ trụ xanh lục độc đáo. Năm 2003, khu vực được UNESCO công nhận là Di sản Thiên nhiên Thế giới, khẳng định giá trị sinh thái và địa chất vô cùng quan trọng. Động không chỉ thu hút du khách trong nước mà còn là điểm đến quốc tế, góp phần thúc đẩy phát triển kinh tế địa phương và nâng cao nhận thức bảo tồn môi trường. Các tour thám hiểm, thuyền ngầm và hoạt động nghiên cứu khoa học thường xuyên được tổ chức, làm phong phú thêm di sản văn hoá và thiên nhiên của Việt Nam.'
WHERE heritage_id = 'dfcf707b-1b62-4338-9dbe-29a5dac23dd1' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Phong Nha Cave (Động Phong Nha)',
    address = 'Động Phong Nha, Xã Phong Nha, Huyện Bố Trạch, Tỉnh Quảng Bình, Việt Nam',
    description = 'Động Phong Nha is an esteemed cultural and scenic landmark located in Quang Binh, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = 'dfcf707b-1b62-4338-9dbe-29a5dac23dd1' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'フォンニャ洞窟',
    address = 'Động Phong Nha, Xã Phong Nha, Huyện Bố Trạch, Tỉnh Quảng Bình, Việt Nam',
    description = 'Động Phong Nhaは、ベトナムクアンビンに位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = 'dfcf707b-1b62-4338-9dbe-29a5dac23dd1' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Hầm vượt sông Sài Gòn (Hầm Thủ Thiêm)',
    address = 'Hầm Thủ Thiêm, Quận 1 & TP. Thủ Đức, TP. Hồ Chí Minh',
    description = 'Hầm Thủ Thiêm là hầm dìm vượt sông đầu tiên tại Việt Nam và hiện đại nhất Đông Nam Á khi khánh thành năm 2011, nối liền trung tâm Quận 1 với bán đảo Thủ Thiêm qua lòng sông Sài Gòn. Công trình giao thông ngầm thế kỷ này đã mở toang cánh cửa phát triển rực rỡ cho khu đô thị mới Thủ Thiêm và diện mạo hiện đại của thành phố mang tên Bác.'
WHERE heritage_id = 'c6a0276c-3fc7-4845-9eff-f73e8b976a83' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Hầm vượt sông Sài Gòn (Hầm Thủ Thiêm)',
    address = 'Hầm Thủ Thiêm, Quận 1 & TP. Thủ Đức, TP. Hồ Chí Minh',
    description = 'The Thu Thiem Tunnel is Southeast Asia''''s longest immersed river tunnel, running beneath the Saigon River bed to link the historic heart of District 1 with the modern Thu Thiêm New Urban Area upon its 2011 debut. The landmark underwater crossing represents a major engineering milestone transforming urban connectivity across the metropolis.'
WHERE heritage_id = 'c6a0276c-3fc7-4845-9eff-f73e8b976a83' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'サイゴン川トンネル（トゥーティエム・トンネル）',
    address = 'Hầm Thủ Thiêm, Quận 1 & TP. Thủ Đức, TP. Hồ Chí Minh',
    description = 'サイゴン川トンネル（トゥーティエム・トンネル）は、サイゴン川の川底を潜り抜けて1区中心街と新興開発区トゥーティエムを結ぶ、2011年に完成した東南アジア最長の沈埋トンネルです。近代都市ホーチミン市の急速な発展と交通革命を象徴する世紀の地下インフラです。'
WHERE heritage_id = 'c6a0276c-3fc7-4845-9eff-f73e8b976a83' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Hồ Hữu Tiệp (Xác máy bay B52)',
    address = 'Hồ Hữu Tiệp (Xác máy bay B52), Hà Nội',
    description = 'Hồ Hữu Tiệp nằm giữa làng hoa Ngọc Hà yên bình, là nơi lưu giữ nguyên vẹn một phần xác máy bay ném bom chiến lược B-52 của Mỹ bị bắn rơi trong chiến dịch ''''Hà Nội - Điện Biên Phủ trên không'''' năm 1972. Mặt hồ tĩnh lặng với mảnh xác máy bay thép nhô lên trên mặt nước là chứng tích hào hùng và biểu tượng bất khuất của thủ đô.'
WHERE heritage_id = '5b177a52-ae32-4fa9-9169-14637209e954' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Hồ Hữu Tiệp (Xác máy bay B52)',
    address = 'Hồ Hữu Tiệp (Xác máy bay B52), Hà Nội',
    description = 'Huu Tiep Lake in the quiet Ngoc Ha flower village preserves the twisted wreckage of an American B-52 Stratofortress bomber shot down during the historic 1972 Linebacker II campaign. The tranquil neighborhood pond and its protruding metal remains stand as an indelible monument to Hanoi''''s wartime resilience.'
WHERE heritage_id = '5b177a52-ae32-4fa9-9169-14637209e954' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'フーティエップ湖（B52爆撃機墜落池）',
    address = 'Hồ Hữu Tiệp (Xác máy bay B52), Hà Nội',
    description = 'フーティエップ湖（B52爆撃機の池）は、ハノイ市内の静かな花村ゴックハーの路地裏にある池で、1972年の「ハノイ空中ディエンビエンフー作戦」で撃墜された米軍B-52爆撃機の残骸が今もそのまま水面に突き出て保存されている歴史証拠地です。'
WHERE heritage_id = '5b177a52-ae32-4fa9-9169-14637209e954' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Hồ Thác Bà',
    address = 'Hồ Thác Bà, Yên Bái',
    description = 'Hồ Thác Bà thuộc tỉnh Yên Bái là một trong ba hồ nước nhân tạo lớn nhất Việt Nam, hình thành khi đập thủy điện Thác Bà chặn dòng sông Chảy. Với hơn 1.300 hòn đảo lớn nhỏ rợp bóng cây xanh soi bóng xuống làn nước ngọc bích, hồ được ví như vịnh Hạ Long trên núi ngút ngàn của vùng Tây Bắc.'
WHERE heritage_id = 'feae3036-e3a5-40e4-9cea-99fcb531b435' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Hồ Thác Bà',
    address = 'Hồ Thác Bà, Yên Bái',
    description = 'Thac Ba Lake in Yen Bai is one of Vietnam''''s largest man-made freshwater reservoirs, formed during the damming of the Chay River for the country''''s early hydroelectric program. Studded with over 1,300 forested limestone islets reflected upon sapphire waters, it is celebrated as an ''''inland Ha Long Bay'''' of the northern mountains.'
WHERE heritage_id = 'feae3036-e3a5-40e4-9cea-99fcb531b435' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'タックバー湖',
    address = 'Hồ Thác Bà, Yên Bái',
    description = 'タックバー湖は、イエンバイ省に位置するベトナム最初期の水力発電所建設によって生まれた国内最大級の人造湖です。エメラルド色の湖面には1,300以上もの緑の小島が点在し、北西部の山あいに広がる「山中のハロン湾」としてエコツアー客に親しまれています。'
WHERE heritage_id = 'feae3036-e3a5-40e4-9cea-99fcb531b435' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'InterContinental Danang Sun Peninsula Resort',
    address = 'InterContinental Danang Sun Peninsula Resort, Đà Nẵng',
    description = 'InterContinental Danang là kiệt tác nghỉ dưỡng xa hoa do kiến trúc sư huyền thoại Bill Bensley kiến tạo, ẩn mình giữa sườn đồi thoai thoải của bán đảo Sơn Trà. Khu nghỉ dưỡng kết hợp tài tình kiến trúc đền đài cổ Việt Nam với bốn tầng Heavenly, Sky, Earth và Sea dẫn thẳng ra bãi biển riêng tư biệt lập.'
WHERE heritage_id = 'b5f5f5bf-ae62-4e59-9955-053024a22037' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'InterContinental Danang Sun Peninsula Resort',
    address = 'InterContinental Danang Sun Peninsula Resort, Đà Nẵng',
    description = 'InterContinental Danang Sun Peninsula Resort is an architectural tour de force conceived by acclaimed designer Bill Bensley, nestled on the pristine slopes of Son Tra Peninsula. Blending Vietnamese temple motifs with avant-garde luxury across four vertical levels—Heaven, Sky, Earth, and Sea—it boasts a secluded private cove.'
WHERE heritage_id = 'b5f5f5bf-ae62-4e59-9955-053024a22037' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'インターコンチネンタル・ダナン・サン・ペニンシュラ・リゾート',
    address = 'InterContinental Danang Sun Peninsula Resort, Đà Nẵng',
    description = 'インターコンチネンタル・ダナン・サン・ペニンシュラ・リゾートは、名匠ビル・ベンズリーが手掛けた世界屈指の最高級リゾートです。ソンチャ半島のプライベートな入り江に建ち、ベトナム伝統寺院の意匠とモダンラグジュアリーが融合した圧巻の空間を提供します。'
WHERE heritage_id = 'b5f5f5bf-ae62-4e59-9955-053024a22037' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Khách sạn InterContinental Nha Trang',
    address = 'Khách sạn InterContinental Nha Trang, Khánh Hòa',
    description = 'InterContinental Nha Trang là khách sạn nghỉ dưỡng 5 sao sang trọng tọa lạc tại vị trí đắc địa nhất trên đại lộ Trần Phú ôm trọn vịnh Nha Trang xanh ngọc. Với kiến trúc đương đại thanh lịch cùng các tiện ích chuẩn quốc tế, nơi đây mang đến kỳ nghỉ dưỡng biển đẳng cấp và hoàn hảo.'
WHERE heritage_id = 'ae52c7e8-5226-472d-8491-16e688d5890a' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Khách sạn InterContinental Nha Trang',
    address = 'Khách sạn InterContinental Nha Trang, Khánh Hòa',
    description = 'InterContinental Nha Trang is a luxury beachfront hotel occupying a prime location along prestigious Tran Phu Boulevard facing sapphire Nha Trang Bay. Featuring sleek contemporary design and world-class hospitality, it offers discerning travelers an unparalleled five-star seaside retreat.'
WHERE heritage_id = 'ae52c7e8-5226-472d-8491-16e688d5890a' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'インターコンチネンタル・ニャチャン',
    address = 'Khách sạn InterContinental Nha Trang, Khánh Hòa',
    description = 'インターコンチネンタル・ニャチャンは、市内随一のメインストリートであるチャンフー通り沿いに位置するラグジュアリーな5つ星ビーチフロントホテルです。モダンで洗練された客室からは美しいニャチャン湾が一望でき、極上のリゾート滞在を約束します。'
WHERE heritage_id = 'ae52c7e8-5226-472d-8491-16e688d5890a' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Kinh thành Huế – Ngọ Môn (ban đêm)',
    address = 'Đoàn Thị Điểm, Thuận Hòa, Thành phố Huế, Thừa Thiên Huế',
    description = 'Kinh thành Huế, di sản văn hoá thế giới được UNESCO công nhận, là trung tâm chính trị, văn hoá của triều đại Nguyễn (1802‑1945). Ngọ Môn, cổng chính phía nam của thành, được xây dựng theo phong cách kiến trúc cung đình truyền thống, với mái ngói âm dương, cột gỗ chạm khắc tinh xảo và các bức tượng rồng, phượng tượng trưng cho quyền lực hoàng gia. Khi ánh đèn hiện đại chiếu sáng vào ban đêm, Ngọ Môn hiện lên trong một bức tranh ánh sáng hài hòa, tôn vinh vẻ đẹp cổ kính đồng thời khắc họa sự giao thoa giữa truyền thống và công nghệ. Hình ảnh này không chỉ là minh chứng cho giá trị lịch sử, kiến trúc độc đáo của Kinh thành Huế mà còn là biểu tượng của niềm tự hào dân tộc, ghi lại dấu ấn sâu sắc trong tâm trí du khách và người dân Việt Nam.'
WHERE heritage_id = '245547c7-f0db-4568-b42f-fcd3ff08b240' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Ngọ Gate, Hue Imperial City (Night View)',
    address = 'Đoàn Thị Điểm, Thuận Hòa, Thành phố Huế, Thừa Thiên Huế',
    description = 'Kinh thành Huế – Ngọ Môn (ban đêm) is an esteemed cultural and scenic landmark located in Thua Thien Hue, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = '245547c7-f0db-4568-b42f-fcd3ff08b240' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'フエ王宮・午門 (夜景)',
    address = 'Đoàn Thị Điểm, Thuận Hòa, Thành phố Huế, Thừa Thiên Huế',
    description = 'Kinh thành Huế – Ngọ Môn (ban đêm)は、ベトナムトゥアティエン・フエに位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = '245547c7-f0db-4568-b42f-fcd3ff08b240' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Lăng Khải Định',
    address = 'Lăng Khải Định, Đại Nam, Thủy Bằng, Phường Thủy Xuân, Thành phố Huế, Thừa Thiên Huế, Việt Nam',
    description = 'Lăng Khải Định, công trình tôn nghiêm của Vua Khải Định (1925‑1932), tọa lạc tại Đại Nam, Thủy Bằng, Phường Thủy Xuân, thành phố Huế, Thừa Thiên Huế. Được xây dựng từ năm 1925 đến 1932, lăng là biểu tượng tiêu biểu cho sự giao thoa giữa kiến trúc truyền thống Việt Nam và phong cách Art Deco, Baroque của phương Tây. Kiến trúc sư người Pháp Victor Bastin cùng các nghệ nhân địa phương đã kết hợp các yếu tố như mái ngói âm dương, cột gỗ chạm khắc tinh xảo, cùng các chi tiết trang trí bằng đá cẩm thạch, đồng và gốm sứ màu sắc rực rỡ. Nội thất lăng được trang hoàng bằng các bức tượng, tranh vẽ, và đồ trang sức hoàng gia, phản ánh gu thẩm mỹ cá tính và hiện đại của vua Khải Định. Lăng không chỉ là nơi an táng hoàng gia mà còn là công trình nghệ thuật độc đáo, thể hiện sự hội nhập văn hoá Đông‑Tây trong thời kỳ cuối cùng của triều Nguyễn.'
WHERE heritage_id = 'bae2b1d4-d837-44dc-a79c-314a4f2432f8' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Khai Dinh Tomb (Lăng Khải Định)',
    address = 'Lăng Khải Định, Đại Nam, Thủy Bằng, Phường Thủy Xuân, Thành phố Huế, Thừa Thiên Huế, Việt Nam',
    description = 'Lăng Khải Định is an esteemed cultural and scenic landmark located in Thua Thien Hue, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = 'bae2b1d4-d837-44dc-a79c-314a4f2432f8' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'カイディン帝陵',
    address = 'Lăng Khải Định, Đại Nam, Thủy Bằng, Phường Thủy Xuân, Thành phố Huế, Thừa Thiên Huế, Việt Nam',
    description = 'Lăng Khải Địnhは、ベトナムトゥアティエン・フエに位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = 'bae2b1d4-d837-44dc-a79c-314a4f2432f8' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Lăng Minh Mạng',
    address = 'Lăng Minh Mạng, Khu Lăng Minh Mạng, Phường Kim Long, Thành phố Huế, Thừa Thiên Huế, Việt Nam',
    description = 'Lăng Minh Mạng (tên đầy đủ: Lăng Minh Mạng – Thế Tông) là lăng mộ của Hoàng đế Minh Mạng (1820‑1841), vị vua thứ ba của triều Nguyễn, được xây dựng từ năm 1831 đến 1833 ngay trong khu vực Khu Lăng Minh Mạng thuộc Khu Di tích Cố đô Huế, Thừa Thiên Huế. Kiến trúc lăng mang đậm phong cách cung đình Huế, kết hợp hài hòa giữa các yếu tố kiến trúc truyền thống và cảnh quan thiên nhiên: cổng tam quan rêu phong, tháp chính bằng đá cẩm thạch, các gian nội thất được trang trí bằng gỗ chạm khắc tinh xảo và ngói âm dương. Bố cục đối xứng, các khu vực lễ nghi, thờ cúng và khu vực nghỉ ngơi được bố trí theo nguyên tắc phong thủy, thể hiện quan niệm “trời đất hòa hợp”. Lăng Minh Mạng không chỉ là chứng nhân của nghệ thuật xây dựng đỉnh cao thời Nguyễn mà còn là biểu tượng của quyền lực, uy nghi và truyền thống tôn kính tổ tiên của dân tộc Việt Nam, được UNESCO công nhận là di sản văn hóa thế giới.'
WHERE heritage_id = '159c6856-f84c-4538-ae24-7ce5fe7920f6' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Minh Mạng Mausoleum (Lăng Minh Mạng)',
    address = 'Lăng Minh Mạng, Khu Lăng Minh Mạng, Phường Kim Long, Thành phố Huế, Thừa Thiên Huế, Việt Nam',
    description = 'Lăng Minh Mạng is an esteemed cultural and scenic landmark located in Thua Thien Hue, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = '159c6856-f84c-4538-ae24-7ce5fe7920f6' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ミンマン帝陵',
    address = 'Lăng Minh Mạng, Khu Lăng Minh Mạng, Phường Kim Long, Thành phố Huế, Thừa Thiên Huế, Việt Nam',
    description = 'Lăng Minh Mạngは、ベトナムトゥアティエン・フエに位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = '159c6856-f84c-4538-ae24-7ce5fe7920f6' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Làng mộc Kim Bồng',
    address = 'Làng mộc Kim Bồng, Quảng Nam',
    description = 'Làng mộc Kim Bồng có lịch sử hơn 500 năm nằm hữu ngạn sông Thu Bồn đối diện phố cổ Hội An, nổi tiếng với kỹ nghệ đóng tàu thuyền và dựng nhà gỗ cổ truyền. Các nghệ nhân tài hoa của làng chính là những người đã góp phần trùng tu và gìn giữ nét kiến trúc bằng gỗ độc đáo của di sản đô thị cổ Hội An.'
WHERE heritage_id = '9e633da5-535c-45e0-93c6-854122adc942' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Làng mộc Kim Bồng',
    address = 'Làng mộc Kim Bồng, Quảng Nam',
    description = 'Kim Bong Carpentry Village boasts a 500-year history on the south bank of the Thu Bon River opposite Hoi An Ancient Town, renowned for exquisite boat building and wooden architecture. The master artisans of Kim Bong played a vital role in crafting and restoring the timeless heritage homes of Hoi An.'
WHERE heritage_id = '9e633da5-535c-45e0-93c6-854122adc942' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'キムボン木彫り村',
    address = 'Làng mộc Kim Bồng, Quảng Nam',
    description = 'キムボン木彫り村は、トゥボン川を渡った対岸に位置する500年以上の歴史を誇る伝統工芸の村です。かつてホイアン旧市街の古民家や寺院の建築、造船に大きく貢献した木工職人の技が受け継がれ、繊細な木彫り細工やお土産が作られています。'
WHERE heritage_id = '9e633da5-535c-45e0-93c6-854122adc942' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Lăng Tự Đức (Khiêm Lăng)',
    address = 'Lăng Tự Đức (Khiêm Lăng), Thừa Thiên Huế',
    description = 'Lăng Tự Đức là một trong những công trình lăng tẩm thơ mộng nhất của triều Nguyễn, được xây dựng như một chốn nghỉ dưỡng thứ hai giữa rừng thông reo và hồ Lưu Khiêm êm ả. Lối kiến trúc thanh nhã với nhà tạ sen, sân cầu thơ và các công trình mang chữ ''''Khiêm'''' phản ánh tâm hồn thi sĩ lãng mạn mà u buồn của vị vua hiền.'
WHERE heritage_id = '02ccb432-9d46-418b-8988-7a1c4b995ca5' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Lăng Tự Đức (Khiêm Lăng)',
    address = 'Lăng Tự Đức (Khiêm Lăng), Thừa Thiên Huế',
    description = 'The Tomb of Emperor Tu Duc (Khiem Tomb) is arguably the most romantic imperial necropolis in Hue, conceived as a peaceful retreat among pine forests and lotus-filled Luu Khiem Lake. Its poetic pavilions, water-borne theaters, and humble architecture reflect the melancholy literary soul of Emperor Tu Duc.'
WHERE heritage_id = '02ccb432-9d46-418b-8988-7a1c4b995ca5' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'トゥドゥック帝陵（謙陵）',
    address = 'Lăng Tự Đức (Khiêm Lăng), Thừa Thiên Huế',
    description = 'トゥドゥック帝陵（謙陵）は、広大な松林と蓮池が広がる絵画のように優美な皇帝陵です。在位中から皇帝自身の離宮として使用され、水上劇場や読書のための東屋が配された風雅な景観は、詩人でもあった皇帝のロマンチックな世界観を見事に表現しています。'
WHERE heritage_id = '02ccb432-9d46-418b-8988-7a1c4b995ca5' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Miếu Nhị Phủ (Chùa Ông Bổn)',
    address = '264 Hải Thượng Lãn Ông, Phường 14, Quận 5, TP. Hồ Chí Minh',
    description = 'Miếu Nhị Phủ, hay Chùa Ông Bổn, tọa lạc tại đường Hải Thượng Lãn Ông, Quận 5, là hội quán cổ kính bậc nhất do cộng đồng người Hoa gốc Phúc Châu và Tuyền Châu dựng nên từ cuối thế kỷ XVII. Ngôi miếu nổi danh với nghệ thuật đắp nổi sành sứ tinh xảo trên bờ nóc uốn cong hình thuyền buồm cùng tượng Phúc Đức Chính Thần phù hộ cho việc kinh doanh phát đạt.'
WHERE heritage_id = '5b7d0cc6-2daa-415f-9b53-2950061bf4a2' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Miếu Nhị Phủ (Chùa Ông Bổn)',
    address = '264 Hải Thượng Lãn Ông, Phường 14, Quận 5, TP. Hồ Chí Minh',
    description = 'Nhi Phu Temple, affectionately known as Ong Bon Pagoda, was founded in the late 17th century on Hai Thuong Lan Ong Street by Hokkien merchants from Quanzhou and Zhangzhou. The architectural gem showcases rooflines shaped like sweeping boats adorned with intricate ceramic mosaics, dedicated to the guardian deity of prosperity.'
WHERE heritage_id = '5b7d0cc6-2daa-415f-9b53-2950061bf4a2' AND language_code = 'en';
UPDATE heritage_translations
SET name = '二府会館（オンボン寺 / チョロン）',
    address = '264 Hải Thượng Lãn Ông, Phường 14, Quận 5, TP. Hồ Chí Minh',
    description = '二府会館（オンボン寺）は、チョロンの漢方薬街ハイ・トゥオン・ラン・オン通りにある、17世紀末に福建省出身の華人によって建てられた最古級の寺院です。反り返った船形の屋根に施された極彩色の陶器モザイク彫刻が見事で、土地の福徳正神が祀られています。'
WHERE heritage_id = '5b7d0cc6-2daa-415f-9b53-2950061bf4a2' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Nhà Cổ Hội An',
    address = 'Phố Cổ Hội An, Thị trấn Hội An, Thành phố Hội An, Quảng Nam',
    description = 'Nhà cổ Hội An là những công trình kiến trúc truyền thống đặc trưng của khu phố cổ Hội An, được xây dựng từ thế kỷ XVII đến XIX, phản ánh sự giao thoa văn hoá Đông – Tây trong thời kỳ thương mại sầm uất. Các ngôi nhà thường có nền gạch men, mái ngói âm dương, cửa sổ gỗ chạm khắc tinh xảo và các chi tiết trang trí bằng gốm sứ, đồng. Bố cục không gian nội thất hài hòa, kết hợp giữa phòng khách rộng rãi, phòng ngủ ấm cúng và sân thượng mở, tạo nên môi trường sinh hoạt thoáng đãng, phù hợp với khí hậu nhiệt đới. Nhà cổ không chỉ là di sản kiến trúc mà còn là biểu tượng của sự giàu có, tinh thần thương mại và đa dạng văn hoá của người dân Hội An, góp phần quan trọng vào việc bảo tồn và phát huy giá trị lịch sử, du lịch của thành phố.'
WHERE heritage_id = '3e98db0b-ba27-464a-9de2-528f80552219' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Historic House of Hoi An (Nhà Cổ Hội An)',
    address = 'Phố Cổ Hội An, Thị trấn Hội An, Thành phố Hội An, Quảng Nam',
    description = 'Nhà Cổ Hội An is an esteemed cultural and scenic landmark located in Quang Nam, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = '3e98db0b-ba27-464a-9de2-528f80552219' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ホイアン古民家 (フンフンの家)',
    address = 'Phố Cổ Hội An, Thị trấn Hội An, Thành phố Hội An, Quảng Nam',
    description = 'Nhà Cổ Hội Anは、ベトナムクアンナムに位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = '3e98db0b-ba27-464a-9de2-528f80552219' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Nhà thờ Cha Tam (Nhà thờ Thánh Phanxicô Xaviê)',
    address = 'Nhà thờ Cha Tam (Nhà thờ Thánh Phanxicô Xaviê), TP. Hồ Chí Minh',
    description = 'Nhà thờ Cha Tam, hay Nhà thờ Thánh Phanxicô Xaviê, tọa lạc tại trung tâm khu phố người Hoa Chợ Lớn, được xây dựng từ năm 1900 mang đậm phong cách kiến trúc Gothic phương Tây kết hợp hoa văn chữ Hán Á Đông. Cổng tam quan nhà thờ uốn mái cong lợp ngói âm dương, là nơi lưu giữ dấu tích lịch sử đặc biệt gắn liền với sự biến cố chính trường miền Nam năm 1963.'
WHERE heritage_id = '0787d2a6-bcc9-4532-8119-0f961d755f40' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Nhà thờ Cha Tam (Nhà thờ Thánh Phanxicô Xaviê)',
    address = 'Nhà thờ Cha Tam (Nhà thờ Thánh Phanxicô Xaviê), TP. Hồ Chí Minh',
    description = 'Saint Francis Xavier Church, universally known as Cha Tam Church, was consecrated in 1902 in the vibrant heart of Cholon, blending French Gothic arches with Chinese pagoda ornamentation. Entered through a unique Chinese-styled temple gate with yin-yang tiles, it is historically renowned as the final sanctuary sought by President Ngo Dinh Diem in 1963.'
WHERE heritage_id = '0787d2a6-bcc9-4532-8119-0f961d755f40' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'チャータム教会（聖フランシスコ・ザビエル教会 / チョロン）',
    address = 'Nhà thờ Cha Tam (Nhà thờ Thánh Phanxicô Xaviê), TP. Hồ Chí Minh',
    description = 'チャータム教会（聖フランシスコ・ザビエル教会）は、中華街チョロンの中心部に1902年に建てられたカトリック教会です。西洋のゴシック様式に中国伝統の瓦屋根や漢字の扁額が融合した珍しい建築で、1963年のクーデターの際にゴ・ディン・ジエム大統領が最後に身を寄せた歴史の舞台としても有名です。'
WHERE heritage_id = '0787d2a6-bcc9-4532-8119-0f961d755f40' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Nhà Thờ Chính Tòa Đà Nẵng (Nhà Thờ Con Gà)',
    address = '156 Trần Phú, Phường Hải Châu 1, Quận Hải Châu, TP. Đà Nẵng',
    description = 'Nhà thờ Chính tòa Đà Nẵng (quen gọi là Nhà thờ Con Gà) được khởi công xây dựng từ thời Pháp thuộc năm 1923. Công trình nổi bật với sắc hồng pastel ngọt ngào, đường nét kiến trúc Gothic thanh thoát với các cửa sổ vòm cung nhọn lắp kính màu lộng lẫy và tượng con gà bằng hợp kim trên đỉnh tháp chuông đóng vai trò cột thu lôi kiêm chỉ hướng gió.'
WHERE heritage_id = '8e52fc58-0e3c-427a-a74c-c40332655aa4' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Nhà Thờ Chính Tòa Đà Nẵng (Nhà Thờ Con Gà)',
    address = '156 Trần Phú, Phường Hải Châu 1, Quận Hải Châu, TP. Đà Nẵng',
    description = 'Nhà Thờ Chính Tòa Đà Nẵng (Nhà Thờ Con Gà) is an esteemed cultural and scenic landmark located in Da Nang, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = '8e52fc58-0e3c-427a-a74c-c40332655aa4' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ダナン大聖堂 (鶏教会)',
    address = '156 Trần Phú, Phường Hải Châu 1, Quận Hải Châu, TP. Đà Nẵng',
    description = 'Nhà Thờ Chính Tòa Đà Nẵng (Nhà Thờ Con Gà)は、ベトナムダナンに位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = '8e52fc58-0e3c-427a-a74c-c40332655aa4' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Nhà thờ Núi Nha Trang (Nhà thờ Chính Tòa)',
    address = 'Nhà thờ Núi Nha Trang (Nhà thờ Chính Tòa), Khánh Hòa',
    description = 'Nhà thờ Núi Nha Trang sừng sững trên mỏm núi Bông trung tâm thành phố, là công trình kiến trúc Gothic phương Tây tráng lệ bằng đá nhân tạo xây dựng từ năm 1928. Những ô cửa kính màu lung linh và tháp chuông ngân vang tạo nên không gian tâm linh trang trọng, bình yên giữa lòng phố biển.'
WHERE heritage_id = 'f015a089-0e84-40a2-b0fc-4359c3f3729c' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Nhà thờ Núi Nha Trang (Nhà thờ Chính Tòa)',
    address = 'Nhà thờ Núi Nha Trang (Nhà thờ Chính Tòa), Khánh Hòa',
    description = 'Cathedral of Christ the King, locally known as Nha Trang Stone Church, stands proudly atop a rocky hill in the city center. Built in 1928 with grand French Gothic masonry and luminous stained-glass clerestories, its chiming carillon adds solemn grace to this coastal metropolis.'
WHERE heritage_id = 'f015a089-0e84-40a2-b0fc-4359c3f3729c' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ニャチャン大聖堂（山頂教会）',
    address = 'Nhà thờ Núi Nha Trang (Nhà thờ Chính Tòa), Khánh Hòa',
    description = 'ニャチャン大聖堂（山頂教会）は、市中心部の小高い岩山の上に1928年に建てられたネオゴシック様式のカトリック大聖堂です。重厚な石造りの外観と、日光を受けてきらめく美しいステンドグラスが厳かで神聖な雰囲気を醸し出しています。'
WHERE heritage_id = 'f015a089-0e84-40a2-b0fc-4359c3f3729c' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Nhà thờ Thánh Giuse (Quận 1)',
    address = '06 Tôn Đức Thắng, Bến Nghé, Quận 1, TP. Hồ Chí Minh',
    description = 'Nhà thờ Thánh Giuse tọa lạc trên đường Nguyễn Bỉnh Khiêm, Quận 1, nguyên là nhà thờ thuộc Đại Chủng viện Thánh Giuse Sài Gòn được xây dựng từ năm 1863 thời kỳ đầu Pháp thuộc. Tòa thánh đường nhỏ xinh mang phong cách kiến trúc Romanesque thanh nhã với những hàng cột đá nguyên khối và vòm trần cao tĩnh mịch giữa vườn cây xanh râm mát.'
WHERE heritage_id = '14a91b83-9cdc-40ba-ae40-ecab0832f6ed' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Nhà thờ Thánh Giuse (Quận 1)',
    address = '06 Tôn Đức Thắng, Bến Nghé, Quận 1, TP. Hồ Chí Minh',
    description = 'Saint Joseph Church on Nguyen Binh Khiem Street in District 1 is an intimate historical sanctuary situated within the grounds of Saint Joseph Major Seminary, founded in 1863. Designed in graceful French Romanesque architecture with stone columns and tranquil cloisters, it offers a serene spiritual haven tucked away from the bustling city.'
WHERE heritage_id = '14a91b83-9cdc-40ba-ae40-ecab0832f6ed' AND language_code = 'en';
UPDATE heritage_translations
SET name = '聖ヨセフ教会（1区・グエンビンキエム）',
    address = '06 Tôn Đức Thắng, Bến Nghé, Quận 1, TP. Hồ Chí Minh',
    description = '聖ヨセフ教会は、ホーチミン市1区グエンビンキエム通りの聖ヨセフ神学校の敷地内に1863年に建てられた歴史あるカトリック教会です。小規模ながらも初期フランス植民地時代の美しいロマネスク様式を今に伝え、緑豊かな木々に囲まれた静寂な祈りの空間となっています。'
WHERE heritage_id = '14a91b83-9cdc-40ba-ae40-ecab0832f6ed' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Nhà thờ Thánh Jeanne d''Arc (Nhà thờ Ngã Sáu)',
    address = 'Nhà thờ Thánh Jeanne d''Arc (Nhà thờ Ngã Sáu), TP. Hồ Chí Minh',
    description = 'Nhà thờ Thánh Jeanne d''Arc (Nhà thờ Ngã Sáu) là một trong những điểm đến di sản tiêu biểu tọa lạc tại TP. Hồ Chí Minh, lưu giữ những giá trị kiến trúc, văn hóa và cảnh quan thiên nhiên đặc sắc của Việt Nam.'
WHERE heritage_id = '75136ea2-30ba-4f1d-ab56-46fff509fddc' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Nhà thờ Thánh Jeanne d''Arc (Nhà thờ Ngã Sáu)',
    address = 'Nhà thờ Thánh Jeanne d''Arc (Nhà thờ Ngã Sáu), TP. Hồ Chí Minh',
    description = 'Nhà thờ Thánh Jeanne d''Arc (Nhà thờ Ngã Sáu) is an esteemed cultural and scenic landmark located in Ho Chi Minh City, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = '75136ea2-30ba-4f1d-ab56-46fff509fddc' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ジャンヌ・ダルク教会 (ガイサウ教会)',
    address = 'Nhà thờ Thánh Jeanne d''Arc (Nhà thờ Ngã Sáu), TP. Hồ Chí Minh',
    description = 'Nhà thờ Thánh Jeanne d''Arc (Nhà thờ Ngã Sáu)は、ベトナムホーチミン市に位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = '75136ea2-30ba-4f1d-ab56-46fff509fddc' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Nhà Trưng Bày Hoàng Sa',
    address = 'Đường Hoàng Sa, Phường Thọ Quang, Quận Sơn Trà, TP. Đà Nẵng',
    description = 'Nhà trưng bày Hoàng Sa là công trình văn hóa và bảo tàng tư liệu đặc biệt nằm bên bờ biển đường Hoàng Sa, Sơn Trà. Nơi đây lưu giữ hàng trăm hiện vật, bản đồ cổ phương Tây, châu bản triều Nguyễn và tư liệu lịch sử pháp lý minh chứng hùng hồn cho chủ quyền không thể chối cãi của Việt Nam đối với quần đảo Hoàng Sa.'
WHERE heritage_id = '263fecde-6852-42bc-82be-66f74d7875ea' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Nhà Trưng Bày Hoàng Sa',
    address = 'Đường Hoàng Sa, Phường Thọ Quang, Quận Sơn Trà, TP. Đà Nẵng',
    description = 'Nhà Trưng Bày Hoàng Sa is an esteemed cultural and scenic landmark located in Da Nang, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = '263fecde-6852-42bc-82be-66f74d7875ea' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ホアンサ諸島展示館',
    address = 'Đường Hoàng Sa, Phường Thọ Quang, Quận Sơn Trà, TP. Đà Nẵng',
    description = 'Nhà Trưng Bày Hoàng Saは、ベトナムダナンに位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = '263fecde-6852-42bc-82be-66f74d7875ea' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Phố cổ Hội An',
    address = 'Phố cổ Hội An, Phường Cẩm Châu, Thành phố Hội An, Quảng Nam, Việt Nam',
    description = 'Phố cổ Hội An, một di sản văn hoá thế giới được UNESCO công nhận, tọa lạc tại thành phố Hội An, tỉnh Quảng Nam, miền Trung Việt Nam. Được xây dựng từ thế kỷ 15, khu phố giữ nguyên những ngôi nhà cổ mang kiến trúc pha trộn giữa phong cách Việt, Trung, Nhật và Bồ Đào Nha, phản ánh lịch sử thương mại quốc tế phong phú của vùng. Vào lúc hoàng hôn, những chiếc đèn lồng đỏ rực rỡ treo khắp các con phố, tạo nên một khung cảnh lãng mạn, gợi nhớ đến những truyền thuyết và phong tục lễ hội truyền thống. Đèn lồng không chỉ là biểu tượng thịnh vượng mà còn là nét văn hoá đặc trưng, thu hút hàng triệu du khách mỗi năm. Sự hài hòa giữa thiên nhiên, ánh sáng và kiến trúc cổ kính khiến Phố cổ Hội An trở thành một trong những điểm đến tiêu biểu nhất của du lịch văn hoá Việt Nam.'
WHERE heritage_id = 'ac079b1d-d9d3-4be8-8515-591e8780c2a3' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Phố cổ Hội An',
    address = 'Phố cổ Hội An, Phường Cẩm Châu, Thành phố Hội An, Quảng Nam, Việt Nam',
    description = 'Phố cổ Hội An is an esteemed cultural and scenic landmark located in Quang Nam, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = 'ac079b1d-d9d3-4be8-8515-591e8780c2a3' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ホイアン旧市街',
    address = 'Phố cổ Hội An, Phường Cẩm Châu, Thành phố Hội An, Quảng Nam, Việt Nam',
    description = 'Phố cổ Hội Anは、ベトナムクアンナムに位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = 'ac079b1d-d9d3-4be8-8515-591e8780c2a3' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Phủ Chủ tịch',
    address = 'Phủ Chủ tịch, Hà Nội',
    description = 'Phủ Chủ tịch tọa lạc gần Quảng trường Ba Đình, nguyên là Dinh Toàn quyền Đông Dương được kiến trúc sư Auguste Henri Vildieu thiết kế xây dựng từ năm 1900 đến 1906 theo phong cách Phục hưng Pháp cổ điển. Tòa nhà quét vôi vàng sang trọng, hiện nay là nơi diễn ra các lễ đón tiếp nguyên thủ quốc gia và các sự kiện ngoại giao quan trọng của Việt Nam.'
WHERE heritage_id = 'd5857479-eba9-43bf-b0c8-5fcc58a32082' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Phủ Chủ tịch',
    address = 'Phủ Chủ tịch, Hà Nội',
    description = 'The Presidential Palace near Ba Dinh Square was originally constructed between 1900 and 1906 as the Governor-General of French Indochina''''s palace, designed by Auguste Henri Vildieu in French classical Renaissance styling. With its stately mustard-yellow facade, it now serves as the ceremonial venue for welcoming foreign heads of state.'
WHERE heritage_id = 'd5857479-eba9-43bf-b0c8-5fcc58a32082' AND language_code = 'en';
UPDATE heritage_translations
SET name = '大統領府（旧仏印総督府）',
    address = 'Phủ Chủ tịch, Hà Nội',
    description = '大統領府（旧フランス総督府）は、バーディン広場に隣接する1906年竣工の豪壮なフランス古典ルネサンス様式の洋館です。鮮やかな黄色い外壁が美しく、現在は国家主席の公邸として各国の国家元首を迎える重要な外交行事に使用されています。'
WHERE heritage_id = 'd5857479-eba9-43bf-b0c8-5fcc58a32082' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Quần đảo Hải Tặc (Hà Tiên)',
    address = 'Quần đảo Hải Tặc (Hà Tiên), Kiên Giang',
    description = 'Quần đảo Hải Tặc gồm 16 hòn đảo lớn nhỏ nằm trong vịnh Thái Lan thuộc thành phố Hà Tiên, Kiên Giang, từng là căn cứ khét tiếng của các băng cướp biển lộng hành thế kỷ XVII - XVIII. Ngày nay, quần đảo khoác lên mình vẻ đẹp hoang sơ tĩnh lặng với những bãi cát trắng mịn, rặng dừa nghiêng soi bóng và nguồn hải sản tươi ngon tuyệt vời.'
WHERE heritage_id = '42579380-5a53-4462-be16-76b47fa09533' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Quần đảo Hải Tặc (Hà Tiên)',
    address = 'Quần đảo Hải Tặc (Hà Tiên), Kiên Giang',
    description = 'The Pirate Archipelago (Quan dao Hai Tac) encompasses 16 serene islands in the Gulf of Thailand off Ha Tien, once infamous as a dreaded pirate stronghold in the 17th and 18th centuries. Today, the pristine archipelago enchants visitors with secluded sandy beaches, swaying coconut palms, and abundant fresh seafood.'
WHERE heritage_id = '42579380-5a53-4462-be16-76b47fa09533' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'パイレーツ諸島（海賊諸島 / ハティエン）',
    address = 'Quần đảo Hải Tặc (Hà Tiên), Kiên Giang',
    description = 'パイレーツ諸島（海賊諸島）は、キエンザン省ハティエン沖のタイランド湾に浮かぶ16の小島群で、17〜18世紀に交易船を襲撃した海賊団のアジトだったという伝説が残る島です。現在は手つかずの白い砂浜と澄んだ海が広がるのどかな漁村の島として静かなブームを呼んでいます。'
WHERE heritage_id = '42579380-5a53-4462-be16-76b47fa09533' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Saigon Centre (Takashimaya)',
    address = 'Saigon Centre (Takashimaya), TP. Hồ Chí Minh',
    description = 'Saigon Centre tọa lạc trên đại lộ Lê Lợi sầm uất tại trung tâm Quận 1, là tổ hợp trung tâm thương mại và tháp văn phòng cao cấp chuẩn quốc tế bậc nhất TP.HCM. Tòa nhà là nơi đặt trung tâm thương mại Takashimaya đầu tiên tại Việt Nam, quy tụ hàng trăm thương hiệu xa xỉ toàn cầu cùng không gian ẩm thực phong phú và sang trọng.'
WHERE heritage_id = 'cf97223f-4963-43b8-a30d-6437af82f151' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Saigon Centre (Takashimaya)',
    address = 'Saigon Centre (Takashimaya), TP. Hồ Chí Minh',
    description = 'Saigon Centre commands a premier frontage along bustling Le Loi Boulevard in District 1, serving as Ho Chi Minh City''''s flagship luxury mixed-use retail and office complex. Housing the esteemed Japanese department store Takashimaya, it showcases world-class fashion houses, lifestyle boutiques, and gourmet dining destinations.'
WHERE heritage_id = 'cf97223f-4963-43b8-a30d-6437af82f151' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'サイゴンセンター（高島屋ベトナム）',
    address = 'Saigon Centre (Takashimaya), TP. Hồ Chí Minh',
    description = 'サイゴンセンターは、ホーチミン市1区の中心街レロイ通りに位置する最高級の複合商業施設です。日本の大手百貨店「高島屋」が核テナントとして入居し、世界のラグジュアリーブランドや人気レストラン、カフェが勢揃いするトレンド発信地となっています。'
WHERE heritage_id = 'cf97223f-4963-43b8-a30d-6437af82f151' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Thánh thất Đa Phước',
    address = 'Thánh thất Đa Phước, Lâm Đồng',
    description = 'Thánh thất Đa Phước là thánh đường Cao Đài lớn nhất tỉnh Lâm Đồng, ngự trên sườn đồi thoai thoải hướng nhìn xuống rừng thông thơ mộng. Kiến trúc rực rỡ sắc màu với biểu tượng Thiên Nhãn, hai tháp chuông cao vút và các họa tiết chạm trổ rồng phụng tạo nên vẻ đẹp tôn giáo trang nghiêm, huyền bí.'
WHERE heritage_id = 'f883ddc9-494c-4e3e-83ee-d69cebcc57a1' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Thánh thất Đa Phước',
    address = 'Thánh thất Đa Phước, Lâm Đồng',
    description = 'Da Phuoc Holy See is the largest Cao Dai temple in Lam Dong, situated on a gentle hillside overlooking sweeping pine valleys. Featuring colorful architectural motifs with the Divine Eye symbol and soaring twin belfries, it reflects the distinct spiritual syncretism of Caodaism.'
WHERE heritage_id = 'f883ddc9-494c-4e3e-83ee-d69cebcc57a1' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ダフオック・カオダイ教寺院',
    address = 'Thánh thất Đa Phước, Lâm Đồng',
    description = 'ダフオック聖室は、ラムドン省最大のカオダイ教寺院であり、松林を見渡す丘陵の斜面に建っています。鮮やかな色彩の装飾や全知の目を象った「天眼」のシンボル、壮麗な双塔が目を引き、独自の融合宗教の神秘的な精神世界を伝えています。'
WHERE heritage_id = 'f883ddc9-494c-4e3e-83ee-d69cebcc57a1' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Tháp Hòa Phong (Hồ Gươm)',
    address = 'Đinh Tiên Hoàng, Tràng Tiền, Hoàn Kiếm, Hà Nội',
    description = 'Tháp Hòa Phong nằm bên bờ đông hồ Hoàn Kiếm, là di tích cổ kính duy nhất còn sót lại của đại danh lam chùa Báo Ân nổi tiếng thế kỷ XIX. Tòa tháp vuông ba tầng bằng gạch nung rêu phong trầm mặc mang dáng dấp cổ xưa, là gạch nối thiêng liêng giữa ký ức kinh kỳ xưa và nhịp sống đô thị hôm nay.'
WHERE heritage_id = 'e38ea413-f379-4966-ac7f-1c9be90cbae1' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Tháp Hòa Phong (Hồ Gươm)',
    address = 'Đinh Tiên Hoàng, Tràng Tiền, Hoàn Kiếm, Hà Nội',
    description = 'Hoa Phong Tower stands on the eastern bank of Hoan Kiem Lake as the sole surviving structure of the grand 19th-century Bao An Pagoda complex. Built in rustic weathered brick across three stepped square tiers, it serves as an evocative poetic link connecting pre-colonial Thang Long with modern street life.'
WHERE heritage_id = 'e38ea413-f379-4966-ac7f-1c9be90cbae1' AND language_code = 'en';
UPDATE heritage_translations
SET name = '和風塔（ホアンキエム湖畔）',
    address = 'Đinh Tiên Hoàng, Tràng Tiền, Hoàn Kiếm, Hà Nội',
    description = '和風塔（ホアフォン塔）は、ホアンキエム湖の東岸の歩道沿いにひっそりと佇む三層の古いレンガ造りの塔です。19世紀にフランスによって破壊された巨大寺院「報恩寺」の唯一現存する遺構であり、ハノイの激動の歴史を見守り続けてきた貴重な文化財です。'
WHERE heritage_id = 'e38ea413-f379-4966-ac7f-1c9be90cbae1' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Thiền viện Vạn Hạnh (Đà Lạt)',
    address = 'Thiền viện Vạn Hạnh (Đà Lạt), Lâm Đồng',
    description = 'Thiền viện Vạn Hạnh nổi danh với pho tượng Phật Thích Ca niêm hoa vi tiếu bằng đồng vàng cao 24 mét ngự trên đỉnh đồi lộng gió tại Đà Lạt. Từ sân thiền viện, du khách có thể phóng tầm mắt chiêm ngưỡng bức tranh thung lũng nông nghiệp trù phú và những rặng thông xanh ngút ngàn.'
WHERE heritage_id = 'a9d514ec-804f-490c-a5b9-7e5009099b6d' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Thiền viện Vạn Hạnh (Đà Lạt)',
    address = 'Thiền viện Vạn Hạnh (Đà Lạt), Lâm Đồng',
    description = 'Van Hanh Zen Monastery is renowned for its colossal 24-meter golden statue of the Golden Buddha holding a lotus blossom atop a scenic Da Lat hill. From the temple terrace, visitors can soak in breathtaking panoramic views over rolling farmland valleys and pine-clad horizons.'
WHERE heritage_id = 'a9d514ec-804f-490c-a5b9-7e5009099b6d' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ヴァンハン禅院（万行禅院）',
    address = 'Thiền viện Vạn Hạnh (Đà Lạt), Lâm Đồng',
    description = 'ヴァンハン禅院（万行禅院）は、蓮の花を手にした高さ24メートルの巨大な黄金の釈迦牟尼仏像で知られる名高い禅寺です。風光明媚な高台に位置し、境内からはダラットの野菜畑や温室群が広がるのどかな田園風景を一望できます。'
WHERE heritage_id = 'a9d514ec-804f-490c-a5b9-7e5009099b6d' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Thung Lũng Vàng Đà Lạt',
    address = 'Thôn Lạt Đồng, Xã Lát, Lạc Dương, Lâm Đồng',
    description = 'Thung Lũng Vàng nằm cách trung tâm Đà Lạt 15 km, nép mình dưới chân núi Langbiang với những đồi thông trập trùng bên mặt hồ Đan Kia êm đềm. Khung cảnh nên thơ với đồi cỏ hồng mộng mơ và những vườn đá phong thủy tạo nên không gian thư thái tuyệt đối.'
WHERE heritage_id = '769c8c69-6e26-41ae-8c5d-bf291ec28153' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Thung Lũng Vàng Đà Lạt',
    address = 'Thôn Lạt Đồng, Xã Lát, Lạc Dương, Lâm Đồng',
    description = 'Golden Valley lies 15 km from central Da Lat at the foot of Mount Langbiang, framed by rolling pine hills overlooking peaceful Dan Kia Lake. Its dreamy pink grass meadows, bonsai gardens, and serene waters provide a tranquil nature retreat.'
WHERE heritage_id = '769c8c69-6e26-41ae-8c5d-bf291ec28153' AND language_code = 'en';
UPDATE heritage_translations
SET name = '黄金の谷（トゥンルン・ヴァン）',
    address = 'Thôn Lạt Đồng, Xã Lát, Lạc Dương, Lâm Đồng',
    description = '黄金の谷（トゥンルン・ヴァン）は、ランビアン山の麓、ダンキア湖畔に広がる自然美豊かな観光公園です。なだらかな松の丘、秋に見られる幻想的なピンクの草原、手入れの行き届いた盆栽庭園が穏やかな安らぎを与えてくれます。'
WHERE heritage_id = '769c8c69-6e26-41ae-8c5d-bf291ec28153' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Tịnh xá Trung Tâm',
    address = '21 Nguyễn Trung Trực, Phường 5, Bình Thạnh, TP. Hồ Chí Minh',
    description = 'Tịnh xá Trung Tâm tọa lạc trên đường Nguyễn Trung Trực, quận Bình Thạnh, là ngôi tổ đình đầu tiên và quan trọng nhất của Hệ phái Phật giáo Khất sĩ Việt Nam do Tổ sư Minh Đăng Quang sáng lập. Ngôi tịnh xá nổi bật với chính điện bát giác độc đáo bằng gỗ quý, bảo tháp tứ giác vươn cao thanh thoát và không gian thiền môn thanh tịnh giữa lòng đô thị.'
WHERE heritage_id = 'a7bbf2bf-f90e-42ea-abd5-421da0e9ae01' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Tịnh xá Trung Tâm',
    address = '21 Nguyễn Trung Trực, Phường 5, Bình Thạnh, TP. Hồ Chí Minh',
    description = 'Tinh Xa Trung Tam in Binh Thanh District is the historic mother temple of the indigenous Mendicant Buddhist Order (Khat Si) founded by Master Minh Dang Quang. The architectural landmark features a distinctive octagonal wooden meditation hall, serene quadrangular stupas, and a tranquil courtyard dedicated to ascetic contemplation.'
WHERE heritage_id = 'a7bbf2bf-f90e-42ea-abd5-421da0e9ae01' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ティンサー・チュンタム（中央精舎・ビンタイン）',
    address = '21 Nguyễn Trung Trực, Phường 5, Bình Thạnh, TP. Hồ Chí Minh',
    description = 'ティンサー・チュンタム（中央精舎）は、ホーチミン市ビンタイン区にある、ベトナム独自の托鉢仏教宗派「カッシ派（乞食派）」の総本山寺院です。八角形の独特な木造本堂と高くそびえる仏塔が特徴で、都心にありながら清らかな戒律と瞑想の精神が息づく聖地となっています。'
WHERE heritage_id = 'a7bbf2bf-f90e-42ea-abd5-421da0e9ae01' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Bạch Dinh (Villa Blanche)',
    address = '04 Trần Phú, Phường 1, Vũng Tàu, Bà Rịa - Vũng Tàu',
    description = 'Bạch Dinh là dinh thự nghỉ dưỡng sang trọng mang kiến trúc châu Âu cuối thế kỷ XIX, tọa lạc trên sườn Núi Lớn nhìn thẳng ra vịnh biển Vũng Tàu. Tòa nhà cao ba tầng sơn trắng tinh khôi được trang trí bằng các bức phù điêu chân dung Hy Lạp cổ đại cùng bộ sưu tập đồ gốm sứ trục vớt từ các con tàu đắm cổ vô giá.'
WHERE heritage_id = '0c8e6a9e-4d9b-4791-8cb5-001b5ab6d633' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Bạch Dinh (Villa Blanche)',
    address = '04 Trần Phú, Phường 1, Vũng Tàu, Bà Rịa - Vũng Tàu',
    description = 'Villa Blanche (Bach Dinh) is an elegant 19th-century French mansion perched on the verdant slopes of Big Mountain overlooking the ocean in Vung Tau. Adorned with Greek-style neoclassical friezes and pristine white stucco, it preserves antique French furniture and valuable shipwreck porcelain recovered from the seabed.'
WHERE heritage_id = '0c8e6a9e-4d9b-4791-8cb5-001b5ab6d633' AND language_code = 'en';
UPDATE heritage_translations
SET name = '白亜の宮殿（バクディン / ヴィラ・ブランシュ）',
    address = '04 Trần Phú, Phường 1, Vũng Tàu, Bà Rịa - Vũng Tàu',
    description = '白亜の宮殿（バクディン / ヴィラ・ブランシュ）は、ブンタウの大山の斜面に建つ19世紀末のフランス植民地様式の優美な白亜の洋館です。ギリシャ神話をモチーフにした浮き彫り彫刻やアンティーク家具が保存され、館内からは紺碧の南シナ海を一望できます。'
WHERE heritage_id = '0c8e6a9e-4d9b-4791-8cb5-001b5ab6d633' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Bãi biển Quy Nhơn',
    address = 'Bãi biển Quy Nhơn, Phường Quy Nhơn, Thành phố Quy Nhơn, Tỉnh Bình Định, Việt Nam',
    description = 'Bãi biển Quy Nhơn nằm ở thành phố Quy Nhơn, tỉnh Bình Định, là một trong những điểm du lịch ven biển nổi bật của miền Trung Việt Nam. Với bờ cát trắng mịn, làn nước trong xanh và sóng nhẹ, nơi đây mang đến khung cảnh thiên nhiên hoang sơ, đồng thời được quy hoạch hiện đại với các khu nghỉ dưỡng, công viên ven biển và lối đi bộ dọc bờ. Địa danh này không chỉ thu hút khách du lịch trong nước mà còn là điểm dừng chân của du khách quốc tế nhờ sự kết hợp hài hòa giữa vẻ đẹp tự nhiên và hạ tầng đô thị. Bãi biển Quy Nhơn còn là nơi tổ chức các lễ hội văn hoá địa phương, như hội chợ hải sản và các hoạt động thể thao nước, góp phần bảo tồn và phát huy giá trị văn hoá, sinh thái của khu vực.'
WHERE heritage_id = 'fe41196d-625b-41c2-8046-c518fbe963fd' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Quy Nhon Beach (Bãi biển Quy Nhơn)',
    address = 'Bãi biển Quy Nhơn, Phường Quy Nhơn, Thành phố Quy Nhơn, Tỉnh Bình Định, Việt Nam',
    description = 'Bãi biển Quy Nhơn is an esteemed cultural and scenic landmark located in Binh Dinh, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = 'fe41196d-625b-41c2-8046-c518fbe963fd' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'クイニョンビーチ',
    address = 'Bãi biển Quy Nhơn, Phường Quy Nhơn, Thành phố Quy Nhơn, Tỉnh Bình Định, Việt Nam',
    description = 'Bãi biển Quy Nhơnは、ベトナムビンディンに位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = 'fe41196d-625b-41c2-8046-c518fbe963fd' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Bán Đảo Sơn Trà & Chùa Linh Ứng Bãi Bụt',
    address = 'Khu vực Bãi Bụt, Bán đảo Sơn Trà, Quận Sơn Trà, TP. Đà Nẵng',
    description = 'Bán đảo Sơn Trà được mệnh danh là viên ngọc quý và lá phổi xanh của Đà Nẵng với hệ sinh thái rừng nhiệt đới trù phú cùng loài voọc chà vá chân nâu quý hiếm. Tọa lạc tại Bãi Bụt trên sườn bán đảo, Chùa Linh Ứng nổi bật với Đại tượng Phật Bà Quán Thế Âm cao 67m uy nghiêm, lưng tựa núi non, mắt hướng ra đại dương bao la cầu quốc thái dân an.'
WHERE heritage_id = '5b4ee06b-cbc0-4b14-990d-b29195b86838' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Bán Đảo Sơn Trà & Chùa Linh Ứng Bãi Bụt',
    address = 'Khu vực Bãi Bụt, Bán đảo Sơn Trà, Quận Sơn Trà, TP. Đà Nẵng',
    description = 'Bán Đảo Sơn Trà & Chùa Linh Ứng Bãi Bụt is an esteemed cultural and scenic landmark located in Da Nang, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = '5b4ee06b-cbc0-4b14-990d-b29195b86838' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ソンチャ半島＆リンウン寺 (バイブット)',
    address = 'Khu vực Bãi Bụt, Bán đảo Sơn Trà, Quận Sơn Trà, TP. Đà Nẵng',
    description = 'Bán Đảo Sơn Trà & Chùa Linh Ứng Bãi Bụtは、ベトナムダナンに位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = '5b4ee06b-cbc0-4b14-990d-b29195b86838' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Bảo tàng Chứng tích Chiến tranh',
    address = '28 Võ Văn Tần, Phường 6, Quận 3, TP. Hồ Chí Minh',
    description = 'Bảo tàng Chứng tích Chiến tranh tọa lạc trên đường Võ Văn Tần, Quận 3, là một trong những bảo tàng thu hút đông đảo du khách quốc tế nhất tại Việt Nam, ghi dấu những tội ác chiến tranh và hậu quả tàn khốc của chất độc da cam đối với dân tộc. Bảo tàng trưng bày nhiều hiện vật chiến tranh giá trị, máy bay, xe tăng chiến lợi phẩm và phòng tranh ảnh ''''Hồi niệm'''' xúc động lòng người.'
WHERE heritage_id = '3ee08e01-44f0-4e88-b612-9863bd963ac8' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Bảo tàng Chứng tích Chiến tranh',
    address = '28 Võ Văn Tần, Phường 6, Quận 3, TP. Hồ Chí Minh',
    description = 'The War Remnants Museum on Vo Van Tan Street in District 3 is Vietnam''''s most visited museum, offering a powerful, uncompromising exhibition of the tragic human costs and aftermath of the Vietnam War. Exhibits include captured aircraft, heavy armor, and the acclaimed ''''Requiem'''' photography gallery honoring international photojournalists who perished in the conflict.'
WHERE heritage_id = '3ee08e01-44f0-4e88-b612-9863bd963ac8' AND language_code = 'en';
UPDATE heritage_translations
SET name = '戦争証跡博物館（ホーチミン市）',
    address = '28 Võ Văn Tần, Phường 6, Quận 3, TP. Hồ Chí Minh',
    description = '戦争証跡博物館は、ホーチミン市3区にある、年間数百万人が訪れるベトナムで最も訪問者の多い博物館です。米軍の戦車や戦闘機の実物展示をはじめ、枯葉剤被害の実態や戦争の悲惨さを克明に記録した写真・資料が展示され、平和の大切さを世界に訴え続けています。'
WHERE heritage_id = '3ee08e01-44f0-4e88-b612-9863bd963ac8' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Bảo tàng Dân tộc học Việt Nam',
    address = 'Đường Nguyễn Văn Huyên, Quan Hoa, Cầu Giấy, Hà Nội',
    description = 'Bảo tàng Dân tộc học Việt Nam trên đường Nguyễn Văn Huyên là trung tâm nghiên cứu và bảo tồn văn hóa sống động của 54 dân tộc anh em trên dải đất hình chữ S. Khuôn viên ngoài trời rộng lớn rợp bóng cây xanh trưng bày nguyên bản những ngôi nhà rông Tây Nguyên cao vút, nhà dài Ê Đê, nhà sàn Thái và nhà mồ Gia Rai độc đáo.'
WHERE heritage_id = '8b3ed65e-d5df-46a6-b254-1a1203876cde' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Bảo tàng Dân tộc học Việt Nam',
    address = 'Đường Nguyễn Văn Huyên, Quan Hoa, Cầu Giấy, Hà Nội',
    description = 'The Vietnam Museum of Ethnology on Nguyen Van Huyen Street is an internationally acclaimed cultural center celebrating the vibrant diversity of Vietnam''''s 54 ethnic groups. Its sprawling leafy outdoor grounds feature authentic full-scale reconstructions of towering Central Highland Rong houses, Ede longhouses, and traditional Tay stilt homes.'
WHERE heritage_id = '8b3ed65e-d5df-46a6-b254-1a1203876cde' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ベトナム民族学博物館',
    address = 'Đường Nguyễn Văn Huyên, Quan Hoa, Cầu Giấy, Hà Nội',
    description = 'ベトナム民族学博物館は、ハノイ西郊に位置し、ベトナムに暮らす全54の民族の多様な文化と生活様式を紹介する最高水準の博物館です。屋外展示場には、高床式のバーナール族の巨大な共同住宅「ロンハウス」や少数民族の伝統住居が移築・再現されています。'
WHERE heritage_id = '8b3ed65e-d5df-46a6-b254-1a1203876cde' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Bảo tàng Hà Nội',
    address = 'Bảo tàng Hà Nội, Hà Nội',
    description = 'Bảo tàng Hà Nội tọa lạc trên đường Phạm Hùng, gây ấn tượng mạnh mẽ với kiến trúc hình kim tự tháp ngược độc đáo gồm bốn tầng nổi vươn dần ra ngoài. Bảo tàng trưng bày hàng vạn hiện vật, cổ vật quý hiếm tái hiện chặng đường lịch sử hơn 1.000 năm hào hùng và diện mạo đổi mới của thủ đô ngàn năm văn hiến.'
WHERE heritage_id = '118bac73-fe5f-4dba-8d77-640ec69acff5' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Bảo tàng Hà Nội',
    address = 'Bảo tàng Hà Nội, Hà Nội',
    description = 'The Hanoi Museum stands out along Pham Hung Boulevard with its striking inverted-pyramid modernist architecture where the top tiers overhang the base. The museum houses thousands of precious historical artifacts and multimedia exhibits documenting the thousand-year evolution of the historic capital.'
WHERE heritage_id = '118bac73-fe5f-4dba-8d77-640ec69acff5' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ハノイ博物館',
    address = 'Bảo tàng Hà Nội, Hà Nội',
    description = 'ハノイ博物館は、逆ピラミッド型の斬新で近未来的な建築デザインが目を引く市立総合博物館です。吹き抜けのスロープが美しい館内には、古代ドンソン文化の青銅器から現代までの数万点に及ぶ貴重な文化財が展示され、ハノイ千年の歴史を物語っています。'
WHERE heritage_id = '118bac73-fe5f-4dba-8d77-640ec69acff5' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Bảo tàng Lịch sử Quân sự Việt Nam',
    address = '28A Điện Biên Phủ, Điện Biên, Ba Đình, Hà Nội',
    description = 'Bảo tàng Lịch sử Quân sự Việt Nam nằm trên đại lộ Thăng Long, là một trong những bảo tàng quốc gia lớn nhất cả nước trưng bày hàng vạn hiện vật lịch sử chiến tranh vô giá. Không gian trưng bày hiện đại lưu giữ bốn bảo vật quốc gia gồm máy bay tiêm kích MiG-21 và xe tăng T-54 huyền thoại đã lập nên những mốc son chói lọi trong lịch sử bảo vệ Tổ quốc.'
WHERE heritage_id = 'c70efbc5-c21e-4938-8b47-d36e6f0db9fc' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Bảo tàng Lịch sử Quân sự Việt Nam',
    address = '28A Điện Biên Phủ, Điện Biên, Ba Đình, Hà Nội',
    description = 'The Vietnam Military History Museum, relocated to a colossal campus along Thang Long Boulevard, documents centuries of heroic national defense against foreign aggression. Its world-class galleries proudly display National Treasures including legendary MiG-21 jet fighters and T-54 tanks that took part in historic wartime triumphs.'
WHERE heritage_id = 'c70efbc5-c21e-4938-8b47-d36e6f0db9fc' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ベトナム軍事歴史博物館',
    address = '28A Điện Biên Phủ, Điện Biên, Ba Đình, Hà Nội',
    description = 'ベトナム軍事歴史博物館は、ハノイのタンロン通り沿いに移転新築された国内最大規模の国立軍事博物館です。屋外および壮大な館内には、幾多の戦火を潜り抜けた戦闘機MiG-21や戦車T-54など数々の国宝を含む貴重な実物兵器や資料が系統的に展示されています。'
WHERE heritage_id = 'c70efbc5-c21e-4938-8b47-d36e6f0db9fc' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Bảo tàng Lịch sử TP. Hồ Chí Minh',
    address = 'Bảo tàng Lịch sử TP. Hồ Chí Minh, TP. Hồ Chí Minh',
    description = 'Bảo tàng Lịch sử TP.HCM nằm trong khuôn viên Thảo Cầm Viên, là kiệt tác kiến trúc Đông Dương kết hợp giữa nghệ thuật cung đình phương Đông và kỹ thuật xây dựng Pháp do kiến trúc sư Auguste Delaval thiết kế năm 1929. Bảo tàng trưng bày hàng chục nghìn cổ vật quý báu từ thời nguyên thủy, văn hóa Óc Eo Phù Nam kỳ bí đến xác ướp Xóm Cải nổi tiếng.'
WHERE heritage_id = '74934c12-17fc-4079-91c3-91033a5b7649' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Bảo tàng Lịch sử TP. Hồ Chí Minh',
    address = 'Bảo tàng Lịch sử TP. Hồ Chí Minh, TP. Hồ Chí Minh',
    description = 'The Museum of Vietnamese History in Ho Chi Minh City sits inside the Botanical Gardens, constructed in 1929 by Auguste Delaval as a masterwork of Indochine architecture with an octagonal temple pagoda roof. It safeguards priceless artifacts from prehistoric civilizations, the ancient Oc Eo Kingdom, and the famous Xom Cai mummy.'
WHERE heritage_id = '74934c12-17fc-4079-91c3-91033a5b7649' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ベトナム歴史博物館（ホーチミン市）',
    address = 'Bảo tàng Lịch sử TP. Hồ Chí Minh, TP. Hồ Chí Minh',
    description = 'ベトナム歴史博物館（ホーチミン市）は、動植物園の緑豊かな敷地内に1929年に建てられた八角堂屋根を持つインドシナ様式の傑作建築です。古代オケオ文明の黄金の出土品やチャンパ彫刻、歴代王朝の遺物、そして有名な「ソムカイのミイラ」などが展示されています。'
WHERE heritage_id = '74934c12-17fc-4079-91c3-91033a5b7649' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Bảo tàng Mỹ thuật TP. Hồ Chí Minh',
    address = 'Bảo tàng Mỹ thuật TP. Hồ Chí Minh, TP. Hồ Chí Minh',
    description = 'Bảo tàng Mỹ thuật TP.HCM tọa lạc trên đường Phó Đức Chính, nguyên là tư dinh lộng lẫy của đại phú gia Hứa Bổn Hòa (chú Hỏa) xây dựng đầu thế kỷ XX. Tòa dinh thự ba tầng mang phong cách Art Deco kết hợp hài hòa mỹ thuật Baroque Pháp và hoa văn Á Đông, nổi tiếng với thang máy cổ bằng gỗ đầu tiên của Sài Gòn và những hành lang kính màu tráng lệ.'
WHERE heritage_id = 'a462e1cf-6dd1-48d5-afd2-2d8beb5b1316' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Bảo tàng Mỹ thuật TP. Hồ Chí Minh',
    address = 'Bảo tàng Mỹ thuật TP. Hồ Chí Minh, TP. Hồ Chí Minh',
    description = 'The Ho Chi Minh City Museum of Fine Arts occupies a splendid early 20th-century mansion complex formerly owned by legendary merchant Hui Bon Hoa. Fusing French Art Deco elegance with classical Chinese ornamentation, it features Saigon''''s oldest functional wooden elevator and vast galleries of fine arts.'
WHERE heritage_id = 'a462e1cf-6dd1-48d5-afd2-2d8beb5b1316' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ホーチミン市美術博物館',
    address = 'Bảo tàng Mỹ thuật TP. Hồ Chí Minh, TP. Hồ Chí Minh',
    description = 'ホーチミン市美術博物館は、20世紀初頭に豪商フア・ボン・ホア（通称アンクル・ホア）の私邸として建てられた、アールデコと東洋建築が融合した華麗な邸宅です。サイゴン最古の木製エレベーターや美しいステンドグラス、吹き抜けの回廊があり、ベトナム近代美術の傑作が展示されています。'
WHERE heritage_id = 'a462e1cf-6dd1-48d5-afd2-2d8beb5b1316' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Bảo tàng Thành phố Hồ Chí Minh (Dinh Gia Long)',
    address = 'Bảo tàng Thành phố Hồ Chí Minh (Dinh Gia Long), TP. Hồ Chí Minh',
    description = 'Bảo tàng Thành phố Hồ Chí Minh tọa lạc trên đường Lý Tự Trọng, nguyên là Dinh Thống đốc Nam Kỳ do kiến trúc sư người Pháp Alfred Foulhoux thiết kế xây dựng từ năm 1885 đến 1890. Tòa dinh thự cổ điển châu Âu tráng lệ lưu giữ hàng nghìn hiện vật khảo cổ học, lịch sử đấu tranh cách mạng cùng hệ thống đường hầm trú ẩn ngầm kiên cố dưới tầng hầm.'
WHERE heritage_id = '5fa24f7b-2523-48b3-b5dd-6c17e4fe6de2' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Bảo tàng Thành phố Hồ Chí Minh (Dinh Gia Long)',
    address = 'Bảo tàng Thành phố Hồ Chí Minh (Dinh Gia Long), TP. Hồ Chí Minh',
    description = 'The Museum of Ho Chi Minh City on Ly Tu Trong Street was originally built between 1885 and 1890 as the French Governor''''s Palace, conceived by architect Alfred Foulhoux in opulent classical European architecture. Inside its majestic columns and sweeping staircases lie rich archival exhibitions and historic underground escape bunkers.'
WHERE heritage_id = '5fa24f7b-2523-48b3-b5dd-6c17e4fe6de2' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ホーチミン市博物館（旧ジアロン宮殿）',
    address = 'Bảo tàng Thành phố Hồ Chí Minh (Dinh Gia Long), TP. Hồ Chí Minh',
    description = 'ホーチミン市博物館（旧ジアロン宮殿）は、1890年にフランス人建築家アルフレッド・フルフーの設計で落成した旧コーチシナ総督公邸です。コリント様式の列柱や大理石の大階段が美しい新古典主義建築で、地下には大統領避難用の防空壕トンネルが遺されています。'
WHERE heritage_id = '5fa24f7b-2523-48b3-b5dd-6c17e4fe6de2' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Bến Nhà Rồng',
    address = 'Số 01 Nguyễn Tất Thành, Phường 12, Quận 4, TP. Hồ Chí Minh',
    description = 'Bến Nhà Rồng nằm bên ngã ba sông Sài Gòn, nguyên là trụ sở của hãng tàu buôn Pháp Messageries Maritimes xây dựng từ năm 1863 với đôi rồng gốm uốn lượn chầu mặt trăng trên đỉnh mái ngói. Nơi đây đã đi vào lịch sử dân tộc khi người thanh niên yêu nước Nguyễn Tất Thành ra đi tìm đường cứu nước vào ngày 5 tháng 6 năm 1911.'
WHERE heritage_id = 'bc5ee05f-9606-498e-8569-70e91e2d503a' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Bến Nhà Rồng',
    address = 'Số 01 Nguyễn Tất Thành, Phường 12, Quận 4, TP. Hồ Chí Minh',
    description = 'Dragon Wharf (Ben Nha Rong) sits at the junction of the Saigon River and Ben Nghe Canal, built in 1863 as the headquarters of the French Messageries Maritimes shipping line with rooftop terracotta dragons. It holds profound historical significance as the departure point where young patriot Nguyen Tat Thanh set sail on June 5, 1911, to seek national liberation.'
WHERE heritage_id = 'bc5ee05f-9606-498e-8569-70e91e2d503a' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ベンニャーロン（龍の家・ホー・チミン博物館）',
    address = 'Số 01 Nguyễn Tất Thành, Phường 12, Quận 4, TP. Hồ Chí Minh',
    description = 'ベンニャーロン（龍の家）は、サイゴン川沿いに1863年に建設されたフランス郵船会社の旧社屋で、屋根の上に青い陶器の龍が対峙していることからこの名が付きました。1911年6月5日、若き日のホー・チミンが祖国救済の旅に出航した歴史的な地であり、現在は記念博物館となっています。'
WHERE heritage_id = 'bc5ee05f-9606-498e-8569-70e91e2d503a' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Biển Đà Nẵng',
    address = 'Bờ biển thành phố Đà Nẵng, Đà Nẵng, Việt Nam',
    description = 'Biển Đà Nẵng là dải bờ biển dài khoảng 30 km trải dài từ khu vực Bán đảo Sơn Trà tới bờ sông Hàn, nằm trong khu vực đô thị hiện đại của thành phố Đà Nẵng, tỉnh miền Trung Việt Nam. Với cát trắng mịn, nước biển trong xanh và sóng nhẹ, bãi biển không chỉ là điểm thu hút du khách trong và ngoài nước mà còn là nơi người dân địa phương tận hưởng không gian giải trí, thể thao và dã ngoại. Đặc trưng của Biển Đà Nẵng là sự hài hòa giữa vẻ đẹp tự nhiên hoang sơ và các công trình kiến trúc hiện đại như cầu Rồng, cầu Sông Hàn, khu nghỉ dưỡng sang trọng và các khu công viên ven biển. Nhờ vị trí địa lý thuận lợi, hạ tầng giao thông phát triển và môi trường sạch sẽ, Biển Đà Nẵng đã trở thành biểu tượng của sự phát triển bền vững, phản ánh tinh thần năng động, sáng tạo và khát vọng hội nhập của thành phố.'
WHERE heritage_id = 'a5708200-c948-4e82-9ce2-a83ef3e4f791' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Da Nang Beach (Biển Đà Nẵng)',
    address = 'Bờ biển thành phố Đà Nẵng, Đà Nẵng, Việt Nam',
    description = 'Biển Đà Nẵng is an esteemed cultural and scenic landmark located in Da Nang, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = 'a5708200-c948-4e82-9ce2-a83ef3e4f791' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ダナン海岸 (ミーケービーチ)',
    address = 'Bờ biển thành phố Đà Nẵng, Đà Nẵng, Việt Nam',
    description = 'Biển Đà Nẵngは、ベトナムダナンに位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = 'a5708200-c948-4e82-9ce2-a83ef3e4f791' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Biển Sầm Sơn',
    address = 'Bãi biển Sầm Sơn, thành phố Sầm Sơn, tỉnh Thanh Hóa, Việt Nam',
    description = 'Biển Sầm Sơn, nằm ở thành phố Sầm Sơn, tỉnh Thanh Hóa, là một trong những bãi biển nổi tiếng nhất miền Bắc Việt Nam. Với vị trí địa lý gần Hà Nội, Sầm Sơn đã phát triển mạnh mẽ về cơ sở hạ tầng du lịch: các khu nghỉ dưỡng, khách sạn, khu vui chơi giải trí và hệ thống giao thông hiện đại, đáp ứng nhu cầu của hàng triệu lượt du khách mỗi năm. So với các bãi biển miền Trung như Đà Nẵng, Nha Trang hay Phú Quốc, Sầm Sơn giữ được nét đặc trưng của biển miền Bắc – khí hậu mát mẻ, sóng nhẹ và bãi cát trắng mịn. Về văn hoá du lịch, Sầm Sơn nổi bật với các lễ hội truyền thống, ẩm thực địa phương phong phú và các hoạt động thể thao biển, tạo nên một mô hình du lịch kết hợp giữa tiện nghi hiện đại và bản sắc địa phương, khác biệt rõ rệt so với các điểm du lịch biển miền Trung và Nam Bộ.'
WHERE heritage_id = 'fed52192-2393-4713-aa73-b3c3eec10181' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Sầm Sơn Beach (Biển Sầm Sơn)',
    address = 'Bãi biển Sầm Sơn, thành phố Sầm Sơn, tỉnh Thanh Hóa, Việt Nam',
    description = 'Biển Sầm Sơn is an esteemed cultural and scenic landmark located in Thanh Hoa, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = 'fed52192-2393-4713-aa73-b3c3eec10181' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'サムソンビーチ',
    address = 'Bãi biển Sầm Sơn, thành phố Sầm Sơn, tỉnh Thanh Hóa, Việt Nam',
    description = 'Biển Sầm Sơnは、ベトナムタインホアに位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = 'fed52192-2393-4713-aa73-b3c3eec10181' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Bưu điện Trung tâm Sài Gòn',
    address = '02 Công xã Paris, Bến Nghé, Quận 1, TP. Hồ Chí Minh',
    description = 'Bưu điện Trung tâm Sài Gòn nằm đối diện Nhà thờ Đức Bà, được xây dựng từ năm 1886 đến 1891 theo đồ án của kiến trúc sư Marie-Alfred Foulhoux với phong cách chiết trung châu Âu kết hợp hoa văn phương Đông. Tòa nhà gây ấn tượng bởi mái vòm cong kim loại đồ sộ gợi nhớ các nhà ga cổ điển châu Âu, những quầy bưu chính bằng gỗ bóng loáng và hai bức bản đồ lịch sử vẽ tay trên tường.'
WHERE heritage_id = '320c9c55-64f5-4f22-8877-ee0cfa48fd9a' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Bưu điện Trung tâm Sài Gòn',
    address = '02 Công xã Paris, Bến Nghé, Quận 1, TP. Hồ Chí Minh',
    description = 'Saigon Central Post Office stands facing Notre-Dame Cathedral, designed between 1886 and 1891 by architect Marie-Alfred Foulhoux in eclectic French colonial elegance. Its grand vaulted iron-and-glass ceiling reminiscent of vintage European train stations, antique wooden phone booths, and hand-painted historic maps enchant visitors.'
WHERE heritage_id = '320c9c55-64f5-4f22-8877-ee0cfa48fd9a' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'サイゴン中央郵便局',
    address = '02 Công xã Paris, Bến Nghé, Quận 1, TP. Hồ Chí Minh',
    description = 'サイゴン中央郵便局は、1891年に完成したフランス植民地時代を代表する優美なコロニアル建築です。ヨーロッパのオールドステーションを思わせる巨大な鉄骨アーチ天井や、手描きの大地図、クラシカルな木製電話ボックスが現在も現役で使われ、旅情をそそります。'
WHERE heritage_id = '320c9c55-64f5-4f22-8877-ee0cfa48fd9a' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Căn cứ The Rockpile (Đồi Elliot)',
    address = 'Căn cứ The Rockpile (Đồi Elliot), Quảng Trị',
    description = 'Căn cứ The Rockpile là một tháp đá vôi tự nhiên cao 240 mét nằm chơ vơ bên đường 9 thuộc tỉnh Quảng Trị, từng là tiền đồn quan sát chiến lược trọng yếu của thủy quân lục chiến Mỹ trong chiến tranh Việt Nam. Địa danh này là một chứng tích lịch sử tiêu biểu về tuyến hàng rào điện tử McNamara và những năm tháng khói lửa.'
WHERE heritage_id = 'c00511f1-6abd-4833-92cf-84cad5e7d187' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Căn cứ The Rockpile (Đồi Elliot)',
    address = 'Căn cứ The Rockpile (Đồi Elliot), Quảng Trị',
    description = 'The Rockpile is an isolated 240-meter limestone pinnacle alongside historic Route 9 in Quang Tri, serving as a vital American military observation outpost during the Vietnam War. Today, it stands as an evocative historical relic of the McNamara Line and the fierce battles that raged along the Demilitarized Zone.'
WHERE heritage_id = 'c00511f1-6abd-4833-92cf-84cad5e7d187' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ロックパイル米軍基地（エリオットの丘）',
    address = 'Căn cứ The Rockpile (Đồi Elliot), Quảng Trị',
    description = 'ロックパイル（エリオットの丘）は、クアンチ省の国道9号線沿いに孤立してそびえ立つ標高240メートルの岩山要塞跡です。ベトナム戦争当時は非武装地帯（DMZ）付近の重要な米海兵隊の偵察・監視拠点であり、激戦の記憶を留める歴史遺構となっています。'
WHERE heritage_id = 'c00511f1-6abd-4833-92cf-84cad5e7d187' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Cầu Bãi Cháy',
    address = 'Bãi Cháy, Thành phố Hạ Long, Quảng Ninh',
    description = 'Cầu Bãi Cháy là cây cầu dây văng một mặt phẳng dây đầu tiên của Việt Nam, vắt ngang eo biển Cửa Lục nối liền hai khu vực Hòn Gai và Bãi Cháy của thành phố Hạ Long. Với chiều dài hơn 900 mét và độ cao thông thuyền 50 mét, cây cầu tựa như một cánh cung thanh thoát in bóng xuống vịnh di sản.'
WHERE heritage_id = '60f4524e-1aab-4316-96f0-b92a650143fa' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Cầu Bãi Cháy',
    address = 'Bãi Cháy, Thành phố Hạ Long, Quảng Ninh',
    description = 'Bai Chay Bridge is Vietnam''''s first single-plane cable-stayed bridge, spanning the Cua Luc Strait to link the vibrant coastal quarters of Hon Gai and Bai Chay in Ha Long City. Rising 50 meters above the bay waters, its slender architectural profile resembles a giant harp set against the world-famous seascape.'
WHERE heritage_id = '60f4524e-1aab-4316-96f0-b92a650143fa' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'バイチャイ橋',
    address = 'Bãi Cháy, Thành phố Hạ Long, Quảng Ninh',
    description = 'バイチャイ橋は、ハロン市内のクアルック海峡に架かるベトナム初の一面吊り斜張橋で、ホンガイ地区とバイチャイ地区を結んでいます。水面から50メートルの高さを誇り、優美なハープのような白いケーブルの曲線が世界遺産ハロン湾の海景に美しく調和しています。'
WHERE heritage_id = '60f4524e-1aab-4316-96f0-b92a650143fa' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Cầu Cần Thơ',
    address = 'Sông Hậu, Cần Thơ & Vĩnh Long',
    description = 'Cầu Cần Thơ là cây cầu dây văng có nhịp chính dài nhất Đông Nam Á khi hoàn thành năm 2010, bắc qua dòng sông Hậu nối liền đôi bờ Cần Thơ và Vĩnh Long. Hai tháp cầu hình chữ Y ngược cao 171 mét sừng sững giữa ngút ngàn sông nước miền Tây, là đòn bẩy thúc đẩy kinh tế - xã hội bứt phá cho toàn vùng đồng bằng sông Cửu Long.'
WHERE heritage_id = '3c6c5ff3-caba-4f70-a166-dd7d75dd8e2e' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Cầu Cần Thơ',
    address = 'Sông Hậu, Cần Thơ & Vĩnh Long',
    description = 'Can Tho Bridge boasts the longest main span among cable-stayed bridges in Southeast Asia upon its 2010 completion, spanning the massive Hau River between Can Tho and Vinh Long. Its inverted Y-shaped pylons soaring 171 meters high stand as an engineering triumph driving economic dynamism across the Mekong Delta.'
WHERE heritage_id = '3c6c5ff3-caba-4f70-a166-dd7d75dd8e2e' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'カントー橋（メコンの斜張橋）',
    address = 'Sông Hậu, Cần Thơ & Vĩnh Long',
    description = 'カントー橋は、2010年に日本のODA協力によってメコン川水系のハウザン（後江）に架けられた東南アジア最長の主径間を持つ斜張橋です。高さ171メートルの2基の逆Y字型主塔が雄大にそびえ、メコンデルタ全体の物流と経済発展を支える大動脈となっています。'
WHERE heritage_id = '3c6c5ff3-caba-4f70-a166-dd7d75dd8e2e' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Cầu Chương Dương',
    address = 'Cầu Chương Dương, Hoàn Kiếm, Hà Nội',
    description = 'Cầu Chương Dương là cây cầu thép lớn đầu tiên hoàn toàn do các kỹ sư và công nhân Việt Nam tự lực thiết kế và thi công vượt qua dòng sông Hồng vào thập niên 1980. Cây cầu là tuyến giao thông huyết mạch kiên cường nối liền trung tâm thủ đô với các tỉnh thành phía bắc và lưu giữ những ký ức không thể nào quên của thời kỳ đổi mới.'
WHERE heritage_id = 'ac8cb7dc-6c44-4f8d-9ad4-36cf41906767' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Cầu Chương Dương',
    address = 'Cầu Chương Dương, Hoàn Kiếm, Hà Nội',
    description = 'Chuong Duong Bridge is Vietnam''''s first major steel bridge engineered and erected entirely by domestic builders across the Red River in the mid-1980s. Serving as a crucial vehicular artery linking downtown Hanoi with northeastern provinces, it represents a proud symbol of Vietnamese self-reliance during the subsidy and reform eras.'
WHERE heritage_id = 'ac8cb7dc-6c44-4f8d-9ad4-36cf41906767' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'チュオンズオン橋',
    address = 'Cầu Chương Dương, Hoàn Kiếm, Hà Nội',
    description = 'チュオンズオン橋は、1980年代半ばにベトナム人技術者と労働者の力のみで紅河に架けられた最初の大型鉄橋です。ハノイ中心街と北部諸省を結ぶ大動脈として機能し、戦後復興とドイモイ（刷新）初期のベトナムの自立精神を象徴する歴史的架橋です。'
WHERE heritage_id = 'ac8cb7dc-6c44-4f8d-9ad4-36cf41906767' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Cầu Cốc Lếu',
    address = 'Cầu Cốc Lếu, Thành phố Lào Cai, Lào Cai',
    description = 'Cầu Cốc Lếu là cây cầu lịch sử bắc qua dòng sông Hồng chảy vào đất Việt tại trung tâm thành phố cửa khẩu Lào Cai. Được xây dựng lại khang trang với dầm vòm thép uốn lượn và hệ thống chiếu sáng hiện đại, cây cầu là biểu tượng giao thương sầm uất và tình hữu nghị biên giới vùng Tây Bắc.'
WHERE heritage_id = '0e678576-79ef-4000-bf47-37fb78e1601d' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Cầu Cốc Lếu',
    address = 'Cầu Cốc Lếu, Thành phố Lào Cai, Lào Cai',
    description = 'Coc Leu Bridge is a landmark steel-arch bridge spanning the Red River as it flows directly into Vietnam at the border city of Lao Cai. Reconstructed with soaring illuminated arches and spacious pedestrian sidewalks, it serves as an iconic symbol of cross-border commerce and northern frontier connectivity.'
WHERE heritage_id = '0e678576-79ef-4000-bf47-37fb78e1601d' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'コクレウ橋',
    address = 'Cầu Cốc Lếu, Thành phố Lào Cai, Lào Cai',
    description = 'コクレウ橋は、中国からベトナムへと流れ込む紅河をまたぎ、国境の街ラオカイ市街を結ぶ歴史あるアーチ橋です。現代的な美しいアーチ構造と夜間ライトアップが施され、国境貿易の活気と西北部山岳地帯の発展を象徴するランドマークとなっています。'
WHERE heritage_id = '0e678576-79ef-4000-bf47-37fb78e1601d' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Cầu Long Biên',
    address = 'Cầu Long Biên, Hoàn Kiếm, Hà Nội',
    description = 'Cầu Long Biên là cây cầu thép lịch sử vắt ngang sông Hồng do công ty Daydé & Pillé nước Pháp xây dựng từ năm 1898 đến năm 1902, từng là một trong những cây cầu dài nhất thế giới thời bấy giờ. Trải qua hơn một thế kỷ với hai cuộc chiến tranh ác liệt, cây cầu tựa như một chứng nhân lịch sử kiên cường bằng thép của thủ đô Hà Nội.'
WHERE heritage_id = '31ead606-0ea2-483a-9328-a794a9d28427' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Cầu Long Biên',
    address = 'Cầu Long Biên, Hoàn Kiếm, Hà Nội',
    description = 'Long Bien Bridge is an iconic historic cantilever bridge spanning the Red River, erected between 1898 and 1902 by the French firm Dayde & Pille as one of the longest bridges of its era. Having endured wartime bombardments for over a century, the weathered steel structure remains a poetic living witness to Hanoi''''s triumphs.'
WHERE heritage_id = '31ead606-0ea2-483a-9328-a794a9d28427' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ロンビエン橋',
    address = 'Cầu Long Biên, Hoàn Kiếm, Hà Nội',
    description = 'ロンビエン橋は、1902年にフランスによって紅河に架けられた歴史ある鋼鉄トラス橋で、当時としてはアジア最長を誇る巨大建築でした。ベトナム戦争の激しい空爆を何度も耐え抜いた「決して倒れない橋」として知られ、ハノイの百年の激動を見つめ続けてきた不屈のシンボルです。'
WHERE heritage_id = '31ead606-0ea2-483a-9328-a794a9d28427' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Cầu Mỹ Thuận',
    address = 'Cầu Mỹ Thuận, Tiền Giang',
    description = 'Cầu Mỹ Thuận khánh thành năm 2000, là cây cầu dây văng đầu tiên bắc qua sông Tiền nối liền hai tỉnh Tiền Giang và Vĩnh Long với sự hợp tác giữa chính phủ Việt Nam và Australia. Cây cầu đã chấm dứt nhiều thập kỷ cảnh phà tắc nghẽn, mở toang cánh cửa giao thương huyết mạch cho vùng vựa lúa trù phú miền Tây Nam Bộ.'
WHERE heritage_id = '75d0c517-17f9-4f92-a5d0-8bb922feecaf' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Cầu Mỹ Thuận',
    address = 'Cầu Mỹ Thuận, Tiền Giang',
    description = 'My Thuan Bridge, completed in 2000 through collaboration between Vietnam and Australia, is the pioneering cable-stayed bridge over the Tien River linking Tien Giang with Vinh Long. Replacing historic ferry bottlenecks, the bridge permanently transformed regional transport and trade across the vast Mekong Delta.'
WHERE heritage_id = '75d0c517-17f9-4f92-a5d0-8bb922feecaf' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ミートゥアン橋（メコンの斜張橋）',
    address = 'Cầu Mỹ Thuận, Tiền Giang',
    description = 'ミートゥアン橋は、オーストラリア政府の支援協力により2000年にティエンザン（前江）に架けられたベトナム初の近代斜張橋です。長年続いたフェリー連絡による交通渋滞を解消し、メコンデルタ西部の経済発展を一変させた記念碑的インフラです。'
WHERE heritage_id = '75d0c517-17f9-4f92-a5d0-8bb922feecaf' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Cầu Nhật Tân',
    address = 'Cầu Nhật Tân, Tây Hồ, Hà Nội',
    description = 'Cầu Nhật Tân là cây cầu dây văng nhiều nhịp lớn nhất Việt Nam bắc qua sông Hồng, được xây dựng bằng nguồn vốn hỗ trợ phát triển chính thức ODA của Nhật Bản. Với năm trụ tháp kim cương tượng trưng cho năm cửa ô lịch sử của Hà Nội, cây cầu lung linh ánh đèn đa sắc khi đêm về nối liền nội đô với sân bay quốc tế Nội Bài.'
WHERE heritage_id = '804a7f77-47a2-41db-89a2-e02b00aff4a4' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Cầu Nhật Tân',
    address = 'Cầu Nhật Tân, Tây Hồ, Hà Nội',
    description = 'Nhat Tan Bridge is Vietnam''''s largest multi-span cable-stayed bridge over the Red River, realized through official development assistance from Japan. Its five diamond-shaped pylons represent the five ancient gates of Hanoi, illuminating the night sky as a magnificent gateway to Noi Bai International Airport.'
WHERE heritage_id = '804a7f77-47a2-41db-89a2-e02b00aff4a4' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ニャッタン橋（日越友好橋）',
    address = 'Cầu Nhật Tân, Tây Hồ, Hà Nội',
    description = 'ニャッタン橋（日越友好橋）は、日本政府のODA支援によって紅河に建設された東南アジア最大級の5主塔斜張橋です。5つのダイヤモンド型の主塔はハノイの歴史ある5つの城門を象徴しており、ノイバイ国際空港と都心を結ぶ光り輝くシンボルとなっています。'
WHERE heritage_id = '804a7f77-47a2-41db-89a2-e02b00aff4a4' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Cầu Phú Mỹ',
    address = 'Cầu Phú Mỹ, Quận 7 & TP. Thủ Đức, TP. Hồ Chí Minh',
    description = 'Cầu Phú Mỹ là cây cầu dây văng lớn nhất Thành phố Hồ Chí Minh bắc qua sông Sài Gòn, kết nối Quận 7 với thành phố Thủ Đức. Với chiều dài hơn 2.000 mét và tháp đôi hình chữ H cao 145 mét sừng sững, cây cầu là cửa ngõ giao thông huyết mạch đưa luồng hàng hóa từ các cảng biển lớn lưu thông nhanh chóng.'
WHERE heritage_id = 'd0ce2e97-4f9f-4a0b-af08-87e59fa11637' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Cầu Phú Mỹ',
    address = 'Cầu Phú Mỹ, Quận 7 & TP. Thủ Đức, TP. Hồ Chí Minh',
    description = 'Phu My Bridge is Ho Chi Minh City''''s largest cable-stayed bridge spanning the wide Saigon River, directly connecting District 7 with Thu Duc City. Stretching over 2,000 meters supported by dual 145-meter H-shaped concrete pylons, it stands as an engineering landmark expediting vital maritime logistics.'
WHERE heritage_id = 'd0ce2e97-4f9f-4a0b-af08-87e59fa11637' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'フーミー橋（サイゴン川斜張橋）',
    address = 'Cầu Phú Mỹ, Quận 7 & TP. Thủ Đức, TP. Hồ Chí Minh',
    description = 'フーミー橋は、サイゴン川下流に架かる全長2,000メートルを超えるホーチミン市最大の斜張橋で、7区とトゥードゥック市を結んでいます。高さ145メートルのH型主塔が青空に堂々とそびえ、コンテナ港と工業地帯を結ぶ物流の要衝として機能しています。'
WHERE heritage_id = 'd0ce2e97-4f9f-4a0b-af08-87e59fa11637' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Cầu Quay Sông Hàn',
    address = 'Đường Lê Duẩn nối Phạm Văn Đồng, Quận Hải Châu & Sơn Trà, TP. Đà Nẵng',
    description = 'Cầu Sông Hàn là cây cầu quay đầu tiên và duy nhất do chính các kỹ sư và công nhân Việt Nam thiết kế, thi công với sự đồng lòng đóng góp của nhân dân Đà Nẵng. Vào mỗi đêm khuya, nhịp giữa của cầu có thể quay một góc 90 độ dọc theo dòng nước để mở luồng cho các tàu thuyền lớn qua lại, tượng trưng cho sức sống và sự năng động của thành phố.'
WHERE heritage_id = 'eef6e36f-5996-446e-ad60-9a7be658508a' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Cầu Quay Sông Hàn',
    address = 'Đường Lê Duẩn nối Phạm Văn Đồng, Quận Hải Châu & Sơn Trà, TP. Đà Nẵng',
    description = 'Han River Bridge is Vietnam''''s pioneering swing bridge, proudly engineered and constructed by domestic talent with enthusiastic community contributions. In the quiet hours of midnight, the central span rotates 90 degrees along its axis to facilitate ship passage, creating a captivating nocturnal spectacle.'
WHERE heritage_id = 'eef6e36f-5996-446e-ad60-9a7be658508a' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ソンハン橋（ハン川旋回橋）',
    address = 'Đường Lê Duẩn nối Phạm Văn Đồng, Quận Hải Châu & Sơn Trà, TP. Đà Nẵng',
    description = 'ソンハン橋は、地元ダナン市民の寄付とベトナム人技術者の手によって建設された国内初の旋回式可動橋です。深夜になると橋の中央部分が90度回転して大型船の航行を可能にする仕組みとなっており、ダナンの夜景を彩る名物となっています。'
WHERE heritage_id = 'eef6e36f-5996-446e-ad60-9a7be658508a' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Cầu Thê Húc',
    address = 'Hồ Hoàn Kiếm, Hoàn Kiếm, Hà Nội',
    description = 'Cầu Thê Húc mang ý nghĩa ''''nơi lưu giữ ánh sáng ban mai'''', là cây cầu gỗ màu đỏ son cong hình con tôm uốn lượn nối bờ hồ Hoàn Kiếm dẫn vào đền Ngọc Sơn cổ kính. Được danh sĩ Nguyễn Văn Siêu cho xây dựng năm 1865, cây cầu là một trong những biểu tượng thị giác lãng mạn và đặc trưng nhất của thủ đô ngàn năm văn hiến.'
WHERE heritage_id = '6b99559a-5407-494a-8a3b-8ba97e0b83a2' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Cầu Thê Húc',
    address = 'Hồ Hoàn Kiếm, Hoàn Kiếm, Hà Nội',
    description = 'The Huc Bridge, poetically translated as the ''''Bridge of the Morning Sunlight'''', is an iconic arched crimson wooden bridge connecting the banks of Hoan Kiem Lake to Ngoc Son Temple. Rebuilt in 1865 by scholar Nguyen Van Sieu, the elegant red pedestrian span stands as a quintessential romantic visual hallmark of Hanoi.'
WHERE heritage_id = '6b99559a-5407-494a-8a3b-8ba97e0b83a2' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'テーフック橋（棲旭橋）',
    address = 'Hồ Hoàn Kiếm, Hoàn Kiếm, Hà Nội',
    description = 'テーフック橋（棲旭橋）は、「朝の光が宿る橋」という意味を持つ、ホアンキエム湖畔から玉山祠へと架かる優美な朱塗りの木造太鼓橋です。1865年に大学者グエン・ヴァン・シエウによって再建され、緑豊かな湖水に映える鮮やかな赤がハノイを代表する絵画的景観となっています。'
WHERE heritage_id = '6b99559a-5407-494a-8a3b-8ba97e0b83a2' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Cầu Thuận Phước',
    address = 'Hải Châu & Sơn Trà, Thành phố Đà Nẵng',
    description = 'Cầu Thuận Phước là cây cầu treo dây võng dài nhất Việt Nam, bắc qua cửa biển nơi dòng sông Hàn hòa vào vịnh Đà Nẵng. Với chiều dài hơn 1.800 mét và hệ thống đèn led đổi màu lung linh khi màn đêm buông xuống, cây cầu tựa như một dải lụa phát sáng mềm mại nối đôi bờ vịnh biển.'
WHERE heritage_id = 'e3656439-fb89-4001-b353-4302f729c5c8' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Cầu Thuận Phước',
    address = 'Hải Châu & Sơn Trà, Thành phố Đà Nẵng',
    description = 'Thuan Phuoc Bridge is Vietnam''''s longest suspension bridge, spanning the open estuary where the Han River empties into Da Nang Bay. Stretching over 1,800 meters with dynamic LED lighting illuminating the night horizon, it appears like a radiant ribbon connecting the bustling city with the Son Tra Peninsula.'
WHERE heritage_id = 'e3656439-fb89-4001-b353-4302f729c5c8' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'トゥアンフオック橋',
    address = 'Hải Châu & Sơn Trà, Thành phố Đà Nẵng',
    description = 'トゥアンフオック橋は、ハン川がダナン湾へと注ぐ河口に架かる全長1,856メートルのベトナム最長の吊り橋です。夜になると最新のLEDイルミネーションが美しく点灯し、ソンチャ半島と市街地を結ぶ光の架け橋としてダナンの夜景を彩ります。'
WHERE heritage_id = 'e3656439-fb89-4001-b353-4302f729c5c8' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Cầu Tình Yêu Đà Nẵng',
    address = 'Đường Trần Hưng Đạo, Phường An Hải Tây, Quận Sơn Trà, TP. Đà Nẵng',
    description = 'Cầu Tình Yêu Đà Nẵng nằm bên bờ đông sông Hàn, trên đường Trần Hưng Đạo, ngay cạnh Tượng Cá Chép Hóa Rồng và gần đầu Cầu Rồng. Được lấy cảm hứng từ những cây cầu khóa tình yêu lãng mạn nổi tiếng thế giới như Pont des Arts hay Milvio, cầu có hình vòng cung uốn lượn hướng ra sông với những cột đèn lồng hình trái tim đỏ rực rỡ. Đây là điểm check-in yêu thích của các cặp đôi để gắn những ổ khóa minh chứng cho tình yêu vĩnh cửu.'
WHERE heritage_id = '63baaf3f-8e8d-4d3d-9475-0475978adbb9' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Da Nang Love Lock Bridge',
    address = 'Tran Hung Dao Street, An Hai Tay Ward, Son Tra District, Da Nang',
    description = 'Da Nang Love Lock Bridge is situated on the eastern bank of the Han River along Tran Hung Dao Street, right next to the Dragon Carp Statue and near Dragon Bridge. Inspired by world-famous love padlock bridges, it features an arc-shaped walkway over the water adorned with heart-shaped red lampposts where couples attach padlocks to symbolize enduring love.'
WHERE heritage_id = '63baaf3f-8e8d-4d3d-9475-0475978adbb9' AND language_code = 'en';
UPDATE heritage_translations
SET name = '愛の桟橋 (ダナン・ラブブリッジ)',
    address = 'ダナン市ソンチャ区アンハイタイ坊チャンフンダオ通り',
    description = 'ダナン愛の桟橋（ラブブリッジ）は、ハン川東岸のチャンフンダオ通り沿いに位置し、鯉の滝登り像（カーチェップ・ホア・ロン）のすぐ隣、ドラゴン橋のたもとにあります。世界的に有名な愛の南京錠の橋から着想を得ており、川に向かって伸びる遊歩道には赤いハート型のランタンが連なり、カップルが永遠の愛を誓って南京錠を掛ける人気の観光スポットです。'
WHERE heritage_id = '63baaf3f-8e8d-4d3d-9475-0475978adbb9' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Cầu Vàng – Bà Nà Hills',
    address = 'Khu du lịch Bà Nà Hills, xã Hòa Vang, thành phố Đà Nẵng, Việt Nam',
    description = 'Cầu Vàng, còn được biết đến với tên gọi Golden Bridge, là một công trình kiến trúc hiện đại nổi bật nằm trên đỉnh núi Bà Nà, thuộc thành phố Đà Nẵng. Được khánh thành vào năm 2018, cầu dài 150 mét, rộng 6 mét, được thiết kế bởi kiến trúc sư người Pháp Marc Mimram, nổi bật với hai cột đá khổng lồ hình người khổng lồ (còn gọi là "cây khổng lồ") nâng đỡ toàn bộ cấu trúc. Vị trí cao trên độ cao hơn 1.400 mét so với mực nước biển, cùng với khung cảnh núi rừng xanh mướt và sương mù nhẹ, tạo nên một khung cảnh thơ mộng, thu hút hàng triệu du khách trong và ngoài nước. Cầu Vàng không chỉ là biểu tượng của sự sáng tạo trong kiến trúc du lịch mà còn là điểm nhấn quan trọng của khu du lịch Bà Nà Hills, góp phần quảng bá vẻ đẹp thiên nhiên và văn hoá hiện đại của miền Trung Việt Nam.'
WHERE heritage_id = 'cac2e5c0-90dc-41e9-be97-ba3bd5e66bbe' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Golden Bridge (Ba Na Hills)',
    address = 'Khu du lịch Bà Nà Hills, xã Hòa Vang, thành phố Đà Nẵng, Việt Nam',
    description = 'Cầu Vàng – Bà Nà Hills is an esteemed cultural and scenic landmark located in Da Nang, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = 'cac2e5c0-90dc-41e9-be97-ba3bd5e66bbe' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ゴールデンブリッジ (バーナーヒルズ)',
    address = 'Khu du lịch Bà Nà Hills, xã Hòa Vang, thành phố Đà Nẵng, Việt Nam',
    description = 'Cầu Vàng – Bà Nà Hillsは、ベトナムダナンに位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = 'cac2e5c0-90dc-41e9-be97-ba3bd5e66bbe' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chợ Bến Thành',
    address = 'Đường Lê Lợi, Bến Thành, Quận 1, TP. Hồ Chí Minh',
    description = 'Chợ Bến Thành là biểu tượng thương mại và văn hóa lâu đời của Thành phố Hồ Chí Minh, được khánh thành từ năm 1914 với tháp đồng hồ bốn mặt đặc trưng nơi cửa Nam. Khu chợ sầm uất quy tụ hàng nghìn gian hàng bày bán phong phú từ vải vóc, đồ lưu niệm thủ công mỹ nghệ đến khu ẩm thực nức tiếng với bún riêu, bánh xèo, chè ngọt đậm đà hương vị phương Nam.'
WHERE heritage_id = '72c33b0d-b575-4bfc-a481-0669e1fa0c1e' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chợ Bến Thành',
    address = 'Đường Lê Lợi, Bến Thành, Quận 1, TP. Hồ Chí Minh',
    description = 'Ben Thanh Market is the historic commercial and cultural landmark of Ho Chi Minh City, constructed in 1914 with its iconic four-faced clock tower dominating the southern entrance. The bustling emporium shelters thousands of stalls overflowing with local textiles, lacquerware, and a legendary food court serving authentic southern specialties.'
WHERE heritage_id = '72c33b0d-b575-4bfc-a481-0669e1fa0c1e' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ベンタイン市場',
    address = 'Đường Lê Lợi, Bến Thành, Quận 1, TP. Hồ Chí Minh',
    description = 'ベンタイン市場は、1914年に建てられた南門の四面時計塔がシンボルとなっているホーチミン市屈指の歴史ある巨大市場です。場内には衣類や民芸品、乾物などを売る無数の店舗がひしめき、名物の生春巻きやフォー、チェーなどを味わえる大衆食堂街は常に活気に溢れています。'
WHERE heritage_id = '72c33b0d-b575-4bfc-a481-0669e1fa0c1e' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chợ Đà Lạt',
    address = 'Đường Nguyễn Thị Minh Khai, Phường 1, Đà Lạt, Lâm Đồng',
    description = 'Chợ Đà Lạt là trung tâm giao thương sầm uất mang dấu ấn kiến trúc độc đáo của kiến trúc sư Ngô Viết Thụ. Khi hoàng hôn buông xuống, khu chợ đêm trở thành thiên đường ẩm thực đường phố với bánh tráng nướng, sữa đậu nành nóng và các loại mứt đặc sản hấp dẫn.'
WHERE heritage_id = 'aca475b2-9c5e-4074-b42c-6033ad0e83d7' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chợ Đà Lạt',
    address = 'Đường Nguyễn Thị Minh Khai, Phường 1, Đà Lạt, Lâm Đồng',
    description = 'Da Lat Market is a bustling trading hub marked by unique modernist architectural lines. At nightfall, the front plaza transforms into a vibrant night market celebrated for crispy Vietnamese pizza, hot soy milk, and sweet dried fruit preserves.'
WHERE heritage_id = 'aca475b2-9c5e-4074-b42c-6033ad0e83d7' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ダラット市場',
    address = 'Đường Nguyễn Thị Minh Khai, Phường 1, Đà Lạt, Lâm Đồng',
    description = 'ダラット市場は、著名な建築家ゴー・ヴィエット・トゥーによって設計された活気ある商業の中心地です。夕暮れ時からはナイトマーケットが開かれ、名物の焼きライスペーパーや温かい豆乳、ドライフルーツなどの露店が立ち並び賑わいます。'
WHERE heritage_id = 'aca475b2-9c5e-4074-b42c-6033ad0e83d7' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chợ Đồng Xuân',
    address = 'Đồng Xuân, Hoàn Kiếm, Hà Nội',
    description = 'Chợ Đồng Xuân được người Pháp thành lập năm 1889, là khu chợ đầu mối bán buôn lớn và lâu đời nhất khu phố cổ Hà Nội với mặt tiền năm vòm cuốn đặc trưng. Khu chợ ba tầng sầm uất ngập tràn hàng nghìn sạp hàng vải vóc, quần áo và các món quà vặt ẩm thực nức tiếng đất kinh kỳ như chả que tre, chè thập cẩm.'
WHERE heritage_id = 'fedc5b30-74fa-45c8-9ebd-615124fc1493' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chợ Đồng Xuân',
    address = 'Đồng Xuân, Hoàn Kiếm, Hà Nội',
    description = 'Dong Xuan Market, established in 1889 by French authorities, is the oldest and largest covered wholesale marketplace in Hanoi''''s Old Quarter, known for its distinctive five-arched entrance facade. Spanning three bustling floors packed with textiles, souvenirs, and legendary traditional food alleys, it pulses with the authentic heartbeat of northern commerce.'
WHERE heritage_id = 'fedc5b30-74fa-45c8-9ebd-615124fc1493' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ドンスアン市場',
    address = 'Đồng Xuân, Hoàn Kiếm, Hà Nội',
    description = 'ドンスアン市場は、1889年にフランスによって建設されたハノイ旧市街最大かつ最古の歴史を誇る巨大屋内市場です。5連アーチのファサードが特徴的な3階建ての建物内には、布地や衣料品、雑貨を扱う無数の店舗がひしめき、活気あふれる下町の商業熱気を感じられます。'
WHERE heritage_id = 'fedc5b30-74fa-45c8-9ebd-615124fc1493' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chùa Bích Động',
    address = 'Chùa Bích Động, Ninh Bình',
    description = 'Chùa Bích Động được chúa Trịnh Sâm ban tặng danh hiệu ''''Nam thiên đệ nhị động'''', là ngôi chùa cổ độc đáo tọa lạc trong lòng hang núi đá vôi thuộc quần thể Tràng An, Ninh Bình. Chùa được dựng theo ba tầng Hạ, Trung và Thượng men theo sườn núi rêu phong, soi bóng xuống đầm sen thơm ngát qua cây cầu đá mộc mạc.'
WHERE heritage_id = '7a6f49be-3191-4909-8c87-d2d52ae8d67f' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chùa Bích Động',
    address = 'Chùa Bích Động, Ninh Bình',
    description = 'Bich Dong Pagoda, honored by historical rulers as the ''''Second Most Beautiful Grotto of the Southern Realm'''', is a tranquil cave temple complex nestled within the limestone cliffs of Trang An, Ninh Binh. Tiered into Lower, Middle, and Upper shrines along mountain crags, its stone entrance bridge crosses a peaceful lotus pond.'
WHERE heritage_id = '7a6f49be-3191-4909-8c87-d2d52ae8d67f' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ビックドン寺（碧洞寺）',
    address = 'Chùa Bích Động, Ninh Bình',
    description = 'ビックドン寺（碧洞寺）は、ニンビンの世界遺産チャンアンの一角にあり、歴代領主から「南方第二の洞窟」と称えられた洞窟寺院です。蓮池にかかる石橋を渡ると、岩山の斜面に沿って下寺・中寺・上寺が配置され、自然の洞窟と古い木造寺院が一体となった神秘的な景観に出会えます。'
WHERE heritage_id = '7a6f49be-3191-4909-8c87-d2d52ae8d67f' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chùa Cổ Lễ (Thần Quang Tự)',
    address = 'Chùa Cổ Lễ (Thần Quang Tự), Nam Định',
    description = 'Chùa Cổ Lễ, hay Thần Quang Tự, ngự tại huyện Trực Ninh, Nam Định, là ngôi danh lam cổ tự do quốc sư Nguyễn Minh Không sáng lập từ thời nhà Lý. Chùa nổi danh với tháp Cửu Phẩm Liên Hoa 12 tầng cao 32 mét độc đáo kết hợp nghệ thuật chùa tháp truyền thống với đường nét kiến trúc Gothic phương Tây và quả chuông đồng Đại Hồng Chung nặng 9 tấn.'
WHERE heritage_id = '040b4c86-2e03-4804-b978-dd54a50bcd34' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chùa Cổ Lễ (Thần Quang Tự)',
    address = 'Chùa Cổ Lễ (Thần Quang Tự), Nam Định',
    description = 'Co Le Pagoda, originally Than Quang Tu, is a celebrated historical temple in Truc Ninh, Nam Dinh, founded in the 12th century by National Master Nguyen Minh Khong. The complex is distinguished by its 12-story Cuu Pham Lien Hoa stupa fusing pagoda motifs with Gothic pinnacles, alongside an enormous 9-ton bronze bell.'
WHERE heritage_id = '040b4c86-2e03-4804-b978-dd54a50bcd34' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'コーレー寺（神光寺）',
    address = 'Chùa Cổ Lễ (Thần Quang Tự), Nam Định',
    description = 'コーレー寺（神光寺）は、ナムディン省チュックニン県に位置する、12世紀の李朝時代の高僧グエン・ミン・コンによって開山された名刹です。高さ32メートルの十二重の仏塔「九品連花塔」は伝統の塔と西洋ゴシックが融合した傑作であり、重さ9トンの巨大大梵鐘が残されています。'
WHERE heritage_id = '040b4c86-2e03-4804-b978-dd54a50bcd34' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chùa Dâu (Chùa Cổ Pháp)',
    address = 'Chùa Dâu (Chùa Cổ Pháp), Bắc Ninh',
    description = 'Chùa Dâu tọa lạc tại thị xã Thuận Thành, Bắc Ninh, là ngôi chùa Phật giáo cổ xưa nhất Việt Nam được khởi dựng từ thế kỷ thứ II sau Công nguyên tại trung tâm trị sở Giao Châu cổ. Ngôi chùa là cái nôi của trung tâm Phật giáo Luy Lâu nổi tiếng với tháp Hòa Phong ba tầng bằng gạch nung cổ kính và tín ngưỡng Tứ Pháp linh thiêng.'
WHERE heritage_id = '4ab88fd9-2333-4312-a89b-e5cad701705d' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chùa Dâu (Chùa Cổ Pháp)',
    address = 'Chùa Dâu (Chùa Cổ Pháp), Bắc Ninh',
    description = 'Dau Pagoda, located in Thuan Thanh, Bac Ninh, is recognized as the oldest Buddhist temple in Vietnam, founded in the 2nd century CE within the ancient Han trading capital of Luy Lau. It serves as the historic cradle of Vietnamese Buddhism, distinguished by the ancient brick Hoa Phong Tower and the indigenous Four Dharmas deity cult.'
WHERE heritage_id = '4ab88fd9-2333-4312-a89b-e5cad701705d' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ザウ寺（古法寺）',
    address = 'Chùa Dâu (Chùa Cổ Pháp), Bắc Ninh',
    description = 'ザウ寺（延応寺 / 古法寺）は、西暦2世紀に古代交趾郡の州治ルイラウに建立されたベトナム最古の仏教寺院です。ベトナム仏教発祥の聖地として崇敬され、境内中央に建つ古いレンガ造りの「和風塔」や、天候を司る四法雲雨風雷神信仰の総本山として知られています。'
WHERE heritage_id = '4ab88fd9-2333-4312-a89b-e5cad701705d' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chùa Hương (Quần thể Hương Sơn)',
    address = 'Xã Hương Sơn, Mỹ Đức, Hà Nội',
    description = 'Chùa Hương là quần thể danh thắng tâm linh Phật giáo nổi tiếng bậc nhất miền Bắc, tọa lạc giữa thung lũng đá vôi non nước hữu tình ven dòng suối Yến ở Mỹ Đức, Hà Nội. Hàng năm vào mỗi độ xuân về, lễ hội Chùa Hương thu hút hàng vạn khách hành hương chèo thuyền vãn cảnh và chiêm bái động Hương Tích kỳ vĩ.'
WHERE heritage_id = '6d795bc8-afb7-49cb-bc21-a227b937e4ea' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chùa Hương (Quần thể Hương Sơn)',
    address = 'Xã Hương Sơn, Mỹ Đức, Hà Nội',
    description = 'Perfume Pagoda (Chua Huong) is a vast sacred Buddhist sanctuary tucked inside the limestone karsts of My Duc, Hanoi, accessed by gliding along the tranquil Yen Stream. Each spring, the legendary Perfume Pagoda Festival draws millions of pilgrims to board small rowing skiffs and ascend to the holy Huong Tich cave shrine.'
WHERE heritage_id = '6d795bc8-afb7-49cb-bc21-a227b937e4ea' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'フオン寺（香寺・香山名勝）',
    address = 'Xã Hương Sơn, Mỹ Đức, Hà Nội',
    description = 'フオン寺（香寺）は、ハノイ南部ミードゥック郡の奇岩怪石とイエン川（燕川）の清流に囲まれたベトナム最大の仏教巡礼地です。毎年春の祭りには無数の小舟が川を行き交い、参拝者たちは神秘的な鍾乳洞寺院「香積洞」を目指して祈りを捧げます。'
WHERE heritage_id = '6d795bc8-afb7-49cb-bc21-a227b937e4ea' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chùa Linh Phước (Chùa Ve Chai)',
    address = '120 Tự Phước, Trại Mát, Đà Lạt, Lâm Đồng',
    description = 'Chùa Linh Phước, hay Chùa Ve Chai, là kiệt tác kiến trúc khảm sành sứ độc nhất vô nhị tọa lạc tại Trại Mát, Đà Lạt. Ngôi chùa sở hữu con rồng dài 49 mét uốn lượn quanh sân được ghép từ 12.000 vỏ chai bia cùng tháp chuông 7 tầng lưu giữ chuông đại hồng chung linh thiêng.'
WHERE heritage_id = '0380e78b-6d1d-4c1c-990b-af9cc74388e6' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chùa Linh Phước (Chùa Ve Chai)',
    address = '120 Tự Phước, Trại Mát, Đà Lạt, Lâm Đồng',
    description = 'Linh Phuoc Pagoda, popularly called the Broken Glass Pagoda, is an astonishing temple decorated with millions of ceramic and glass fragments in Trai Mat. It features a magnificent 49-meter dragon crafted from 12,000 beer bottles and a towering seven-story bell tower.'
WHERE heritage_id = '0380e78b-6d1d-4c1c-990b-af9cc74388e6' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'リンフオック寺（空き瓶寺）',
    address = '120 Tự Phước, Trại Mát, Đà Lạt, Lâm Đồng',
    description = 'リンフオック寺（通称モザイク寺・空き瓶寺）は、陶磁器やガラスの破片で緻密に装飾されたダラット屈指の名刹です。1万2千本のビール瓶で作られた全長49メートルの巨大な龍の像や、ベトナム最大級の大梵鐘を擁する七重の塔が圧巻です。'
WHERE heritage_id = '0380e78b-6d1d-4c1c-990b-af9cc74388e6' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chùa Một Cột',
    address = 'Phố Chùa Một Cột, Đội Cấn, Ba Đình, Hà Nội',
    description = 'Chùa Một Cột, hay Diên Hựu Tự, được vua Lý Thái Tông cho xây dựng năm 1049, là biểu tượng kiến trúc tâm linh độc nhất vô nhị của thủ đô Hà Nội. Ngôi chùa bằng gỗ tựa như một đóa hoa sen thanh khiết vươn lên từ mặt hồ Linh Chiểu nhờ một cột đá trụ duy nhất, phản ánh đỉnh cao triết lý Phật giáo và tài hoa mỹ thuật Đại Việt.'
WHERE heritage_id = '6af65ea1-ec3d-4af6-81db-46ec375ca6ef' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chùa Một Cột',
    address = 'Phố Chùa Một Cột, Đội Cấn, Ba Đình, Hà Nội',
    description = 'The One Pillar Pagoda, originally Lien Hoa Dai, was commissioned in 1049 by Emperor Ly Thai Tong and stands as an unparalleled emblem of Hanoi''''s spiritual heritage. Resembling a blooming lotus blossom emerging from a square pool on a single stone pillar, it embodies sublime Buddhist philosophy and ingenious architecture.'
WHERE heritage_id = '6af65ea1-ec3d-4af6-81db-46ec375ca6ef' AND language_code = 'en';
UPDATE heritage_translations
SET name = '一柱寺（延祐寺）',
    address = 'Phố Chùa Một Cột, Đội Cấn, Ba Đình, Hà Nội',
    description = '一柱寺（延祐寺）は、李朝の太宗によって1049年に建立されたハノイを代表する名刹です。池の中に立つ一本の石柱の上に木造の仏堂が配され、まるで水面に咲く一輪の清らかな蓮の花のような独特の構造美を誇り、子宝祈願の寺としても信仰を集めています。'
WHERE heritage_id = '6af65ea1-ec3d-4af6-81db-46ec375ca6ef' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chùa Phật Tích',
    address = 'Chùa Phật Tích, Bắc Ninh',
    description = 'Chùa Phật Tích ngự trên sườn núi Lan Kha thuộc huyện Tiên Du, Bắc Ninh, là ngôi cổ tự linh thiêng khởi dựng từ thế kỷ XI thời nhà Lý. Chùa là nơi lưu giữ bảo vật quốc gia pho tượng Phật A Di Đà bằng đá xanh ngồi thiền trên tòa sen cổ nhất Việt Nam cùng hàng tượng linh thú đá nghìn năm tuổi uy nghiêm.'
WHERE heritage_id = '22091615-0b42-481a-abc6-47a403e0b808' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chùa Phật Tích',
    address = 'Chùa Phật Tích, Bắc Ninh',
    description = 'Phat Tich Pagoda rests on the pine-covered slopes of Lan Kha Mountain in Bac Ninh, established in the 11th century under the royal patronages of the Ly Dynasty. It shelters the National Treasure stone statue of Amitabha Buddha seated in meditation—the oldest of its kind in Vietnam—alongside ancient mythical stone beasts.'
WHERE heritage_id = '22091615-0b42-481a-abc6-47a403e0b808' AND language_code = 'en';
UPDATE heritage_translations
SET name = '仏跡寺（ファットティック寺）',
    address = 'Chùa Phật Tích, Bắc Ninh',
    description = '仏跡寺（ファットティック寺）は、バクニン省の緑豊かなランカ山の山腹に11世紀の李朝時代に建立された由緒ある古刹です。蓮華座に座すベトナム最古の石造「阿弥陀如来坐像」（国宝）や、石段を守護する千年前の神獣の石彫群など第一級の文化遺産を擁しています。'
WHERE heritage_id = '22091615-0b42-481a-abc6-47a403e0b808' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chùa Thiên Mụ (Linh Mụ)',
    address = 'Đồi Hà Khê, Kim Long, Thành phố Huế',
    description = 'Chùa Thiên Mụ ngự trên đồi Hà Khê soi bóng xuống dòng sông Hương thơ mộng, là ngôi cổ tự linh thiêng bậc nhất và biểu tượng trường tồn của xứ Huế. Tháp Phước Duyên 7 tầng hình bát giác cao 21 mét cùng tiếng chuông chùa ngân vang trầm ấm đã đi vào biết bao thi ca nhạc họa của dân tộc.'
WHERE heritage_id = 'e659c7f3-ca80-4ca7-9200-91aeb0471d0f' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chùa Thiên Mụ (Linh Mụ)',
    address = 'Đồi Hà Khê, Kim Long, Thành phố Huế',
    description = 'Thien Mu Pagoda, also known as the Pagoda of the Celestial Lady, sits majestically on Ha Khe Hill overlooking the poetic Perfume River. Its iconic seven-story octagonal Phuoc Duyen Tower rising 21 meters, alongside the gentle resonance of its temple bell, embodies the serene spiritual soul of Hue.'
WHERE heritage_id = 'e659c7f3-ca80-4ca7-9200-91aeb0471d0f' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ティエンムー寺（天姥寺）',
    address = 'Đồi Hà Khê, Kim Long, Thành phố Huế',
    description = 'ティエンムー寺（天姥寺）は、フエの香河（パフューム川）沿いの丘の上に建つ、1601年創建の古都を象徴する名刹です。高さ21メートルを誇る八角七重の塔「福縁塔」が美しくそびえ、夕暮れ時に境内に響き渡る鐘の音はフエの風情として詩歌にも詠まれています。'
WHERE heritage_id = 'e659c7f3-ca80-4ca7-9200-91aeb0471d0f' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chùa Tiên Châu (Cù lao An Bình)',
    address = 'Chùa Tiên Châu (Cù lao An Bình), Vĩnh Long',
    description = 'Chùa Tiên Châu tọa lạc trên cù lao An Bình thanh bình giữa dòng sông Cổ Chiên, là ngôi cổ tự linh thiêng bậc nhất tỉnh Vĩnh Long được khởi dựng từ giữa thế kỷ XVIII. Ngôi chùa ngập tràn bóng mát của những vườn cây ăn trái xum xuê, nổi bật với chính điện bằng gỗ quý chạm trổ hoa văn tinh xảo mang vẻ đẹp thanh tao, thoát tục miền sông nước miệt vườn.'
WHERE heritage_id = 'de8eda99-be1b-43bf-95c2-bbcbdfb0a247' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chùa Tiên Châu (Cù lao An Bình)',
    address = 'Chùa Tiên Châu (Cù lao An Bình), Vĩnh Long',
    description = 'Tien Chau Pagoda on peaceful An Binh Island in the Co Chien River is the oldest and most revered Buddhist sanctuary in Vinh Long Province, founded in the mid-18th century. Nestled among tranquil rambutan and durian orchards, its ornate wooden sanctuary showcases delicate folk carvings evocative of idyllic delta spirituality.'
WHERE heritage_id = 'de8eda99-be1b-43bf-95c2-bbcbdfb0a247' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ティエンチャウ寺（仙洲寺 / アンビン島）',
    address = 'Chùa Tiên Châu (Cù lao An Bình), Vĩnh Long',
    description = 'ティエンチャウ寺（仙洲寺）は、ビンロン省のコチエン川に浮かぶ長閑なアンビン中州に18世紀半ばに創建された名刹です。豊かな果樹園の木陰に包まれた境内には、精緻な木彫り装飾が施された本堂が佇み、メコンデルタの水郷地帯ならではの心癒やされる静寂が漂います。'
WHERE heritage_id = 'de8eda99-be1b-43bf-95c2-bbcbdfb0a247' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chùa Trấn Quốc (Hồ Tây)',
    address = 'Chùa Trấn Quốc (Hồ Tây), Hà Nội',
    description = 'Chùa Trấn Quốc tọa lạc trên hòn đảo xanh duy nhất bên bờ đông hồ Tây, là ngôi chùa cổ nhất thủ đô với lịch sử hơn 1.500 năm hình thành từ thời vua Lý Nam Đế. Bảo tháp Lục Độ Đài Sen 11 tầng màu đỏ rực rỡ vươn cao cùng cây bồ đề quý do Tổng thống Ấn Độ trao tặng năm 1959 tạo nên biểu tượng tâm linh bất hủ giữa lòng Hà Nội.'
WHERE heritage_id = 'f2717fd3-b220-4093-9359-9cbd80c18d4e' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chùa Trấn Quốc (Hồ Tây)',
    address = 'Chùa Trấn Quốc (Hồ Tây), Hà Nội',
    description = 'Tran Quoc Pagoda sits on a tranquil green islet on the eastern shore of West Lake, holding the distinction of being Hanoi''''s oldest temple with over 1,500 years of heritage dating to Emperor Ly Nam De. Its stunning 11-story terracotta lotus stupa and sacred bodhi tree gifted from India make it an iconic spiritual sanctuary.'
WHERE heritage_id = 'f2717fd3-b220-4093-9359-9cbd80c18d4e' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'チャンクオック寺（鎮国寺・西湖）',
    address = 'Chùa Trấn Quốc (Hồ Tây), Hà Nội',
    description = 'チャンクオック寺（鎮国寺）は、西湖の東岸に突き出た小島に位置する、6世紀の李南帝時代に創建されたハノイ最古の仏教寺院です。11層の赤い蓮華仏塔「六度台蓮」や、インド大統領から贈られた聖なる菩提樹が静かな湖水に美しく映え、夕暮れ時の絶景スポットとして知られます。'
WHERE heritage_id = 'f2717fd3-b220-4093-9359-9cbd80c18d4e' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Chùa Vĩnh Tràng (Mỹ Tho)',
    address = 'Ấp Mỹ An, Xã Mỹ Phong, Mỹ Tho, Tiền Giang',
    description = 'Chùa Vĩnh Tràng tọa lạc tại thành phố Mỹ Tho, Tiền Giang, là ngôi đại danh lam cổ tự lớn nhất miền Tây Nam Bộ khởi dựng từ đầu thế kỷ XIX. Kiến trúc chùa là sự giao thoa nghệ thuật tuyệt mỹ giữa phong cách Pháp, Ý, văn hóa Champa và chùa cổ Việt Nam với những mái vòm La Mã, hoa văn Phục hưng và ba pho đại tượng Phật khổng lồ giữa vườn cây thanh tịnh.'
WHERE heritage_id = '1ff17ac7-0b08-41a3-be1b-735ef4ef6de3' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Chùa Vĩnh Tràng (Mỹ Tho)',
    address = 'Ấp Mỹ An, Xã Mỹ Phong, Mỹ Tho, Tiền Giang',
    description = 'Vinh Trang Pagoda in My Tho, Tien Giang, is the largest and most famous historic Buddhist monastery in the Mekong Delta, established in the early 19th century. Its extraordinary architecture seamlessly harmonizes French Renaissance arcades and Romanesque arches with traditional Vietnamese carvings, dominated by three colossal statues of Buddha.'
WHERE heritage_id = '1ff17ac7-0b08-41a3-be1b-735ef4ef6de3' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ヴィンチャン寺（永長寺 / ミトー）',
    address = 'Ấp Mỹ An, Xã Mỹ Phong, Mỹ Tho, Tiền Giang',
    description = 'ヴィンチャン寺（永長寺）は、メコンデルタの玄関口ミトーにある、19世紀初頭創建の南部最大級の名刹です。フランス風の列柱やローマ風のアーチ、ルネサンスのステンドグラスと東洋伝統の寺院装飾が調和した圧巻の建築美を誇り、境内には巨大な阿弥陀如来像や弥勒菩薩像が鎮座しています。'
WHERE heritage_id = '1ff17ac7-0b08-41a3-be1b-735ef4ef6de3' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Con đường Gốm sứ Hà Nội',
    address = 'Con đường Gốm sứ Hà Nội, Hà Nội',
    description = 'Con đường Gốm sứ ven sông Hồng là tác phẩm nghệ thuật công cộng kỷ niệm 1.000 năm Thăng Long - Hà Nội, từng xác lập kỷ lục Guinness là bức tranh ghép gốm mosaic dài nhất thế giới với chiều dài gần 4 km. Hàng triệu viên gốm Bát Tràng nhiều màu sắc tái hiện sống động dòng chảy lịch sử dân tộc, hoa văn Đông Sơn và cảnh đẹp đất nước.'
WHERE heritage_id = 'd63a2c7b-010d-4246-bf33-6fcd549fbbdc' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Con đường Gốm sứ Hà Nội',
    address = 'Con đường Gốm sứ Hà Nội, Hà Nội',
    description = 'The Hanoi Ceramic Mosaic Mural along the Red River dike was crafted to celebrate the millennium of Thang Long-Hanoi, recognized by Guinness World Records as the longest ceramic mosaic wall on Earth stretching nearly 4 km. Millions of colorful Bat Trang tiles vibrantly depict Vietnamese historical sagas, folklore, and Dong Son motifs.'
WHERE heritage_id = 'd63a2c7b-010d-4246-bf33-6fcd549fbbdc' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ハノイ陶器モザイク壁画通り',
    address = 'Con đường Gốm sứ Hà Nội, Hà Nội',
    description = 'ハノイ陶器モザイク壁画通りは、ハノイ遷都1000年を記念して紅河の堤防沿いに制作された全長約4キロに及ぶ世界最長の陶器モザイクアートです。伝統のバッチャン焼きの陶片数百万枚が使われ、ベトナムの建国神話やドンソン文化、民俗風景が色彩豊かに描かれています。'
WHERE heritage_id = 'd63a2c7b-010d-4246-bf33-6fcd549fbbdc' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Cột cờ Hà Nội',
    address = '28A Điện Biên Phủ, Ba Đình, Hà Nội',
    description = 'Cột cờ Hà Nội, hay Kỳ đài Hà Nội, được xây dựng từ năm 1812 dưới triều vua Gia Long, là một trong số ít công trình kiến trúc nguyên vẹn nhất còn sót lại trong quần thể Hoàng thành Thăng Long. Với chiều cao hơn 33 mét gồm ba tầng chân đế hình chóp cụt bằng gạch nung kiên cố, lá cờ đỏ sao vàng luôn tung bay kiêu hãnh trên nền trời thủ đô ngàn năm văn hiến.'
WHERE heritage_id = '3272fdef-e63d-48a1-a1d7-60511781d31c' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Cột cờ Hà Nội',
    address = '28A Điện Biên Phủ, Ba Đình, Hà Nội',
    description = 'The Hanoi Flag Tower was constructed in 1812 under Emperor Gia Long, standing as one of the rarest intact monuments surviving the historic Citadel of Thang Long. Rising over 33 meters atop three tiered brick bastions within the Military History grounds, the national flag flutters proudly over the ancient capital.'
WHERE heritage_id = '3272fdef-e63d-48a1-a1d7-60511781d31c' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ハノイ旗台（フラッグタワー）',
    address = '28A Điện Biên Phủ, Ba Đình, Hà Nội',
    description = 'ハノイ旗台は、1812年に阮朝のザーロン帝によって建立されたハノイ城郭の数少ない遺構の一つです。八角形のレンガ造りの塔が3段の頑丈な基壇の上にそびえ立ち、高さ約33メートルの頂上にはベトナム国旗（金星紅旗）が首都の空に誇らしげにはためいています。'
WHERE heritage_id = '3272fdef-e63d-48a1-a1d7-60511781d31c' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Danh Thắng Ngũ Hành Sơn',
    address = '81 Huyền Trân Công Chúa, Phường Hòa Hải, Quận Ngũ Hành Sơn, TP. Đà Nẵng',
    description = 'Ngũ Hành Sơn là Di tích quốc gia đặc biệt gồm quần thể 5 ngọn núi đá vôi nhô lên sừng sững bên bờ biển: Kim, Mộc, Thủy, Hỏa, Thổ. Nơi đây hội tụ vẻ đẹp huyền bí của hệ thống hang động kỳ ảo như Động Huyền Không, Động Tàng Chơn, cùng các ngôi cổ tự linh thiêng như Chùa Tam Thai, Chùa Linh Ứng Ngũ Hành Sơn và làng nghề đá mỹ nghệ Non Nước hàng trăm năm tuổi.'
WHERE heritage_id = 'debfd006-9c55-44ed-b28c-1eab8deff7ae' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Danh Thắng Ngũ Hành Sơn',
    address = '81 Huyền Trân Công Chúa, Phường Hòa Hải, Quận Ngũ Hành Sơn, TP. Đà Nẵng',
    description = 'Danh Thắng Ngũ Hành Sơn is an esteemed cultural and scenic landmark located in Da Nang, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = 'debfd006-9c55-44ed-b28c-1eab8deff7ae' AND language_code = 'en';
UPDATE heritage_translations
SET name = '五行山 (マーブルマウンテン)',
    address = '81 Huyền Trân Công Chúa, Phường Hòa Hải, Quận Ngũ Hành Sơn, TP. Đà Nẵng',
    description = 'Danh Thắng Ngũ Hành Sơnは、ベトナムダナンに位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = 'debfd006-9c55-44ed-b28c-1eab8deff7ae' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Đảo Cát Bà',
    address = 'Quần đảo Cát Bà, Cát Hải, Hải Phòng',
    description = 'Đảo Cát Bà là hòn đảo ngọc lớn nhất trong quần thể hơn 360 đảo của vịnh Lan Hạ, Hải Phòng, nổi bật với địa hình karst ngập mặn và những bãi tắm tự nhiên cát trắng phẳng mịn. Du khách đến đây có thể chèo thuyền kayak qua các làng chài nổi cổ xưa và chiêm ngưỡng làn nước xanh trong vắt ôm lấy những vách đá vôi sừng sững.'
WHERE heritage_id = 'a4b8c2c7-9faa-4e2c-816a-dd7743cc0625' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Đảo Cát Bà',
    address = 'Quần đảo Cát Bà, Cát Hải, Hải Phòng',
    description = 'Cat Ba Island is the largest jewel in the archipelago of 367 limestone islands in Lan Ha Bay, Hai Phong, renowned for rugged karst geography and pristine sandy beaches. It serves as an adventure haven where travelers kayak past floating fishing villages and cruise through hidden emerald lagoons.'
WHERE heritage_id = 'a4b8c2c7-9faa-4e2c-816a-dd7743cc0625' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'カットバ島',
    address = 'Quần đảo Cát Bà, Cát Hải, Hải Phòng',
    description = 'カットバ島は、ランハ湾に浮かぶ360以上の島々の中で最大の島であり、ユネスコ生物圏保存地域に指定された自然豊かな楽園です。白い砂浜のビーチや手つかずの石灰岩カルスト、エメラルドグリーンの入り江を巡るシーカヤックやクルーズが世界中の旅人を魅了しています。'
WHERE heritage_id = 'a4b8c2c7-9faa-4e2c-816a-dd7743cc0625' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Đảo Phú Quốc',
    address = 'Thành phố Phú Quốc, Kiên Giang',
    description = 'Đảo Phú Quốc được mệnh danh là ''''Đảo Ngọc'''' của Việt Nam, hòn đảo lớn nhất đất nước nằm trọn trong vịnh Thái Lan với những bãi biển cát trắng tuyệt mỹ như Bãi Sao, Bãi Khem. Nơi đây nổi tiếng toàn cầu với nghề sản xuất nước mắm truyền thống hàng trăm năm, hồ tiêu cay nồng và những khu nghỉ dưỡng sang trọng ngắm hoàng hôn đỏ rực trên biển Tây.'
WHERE heritage_id = '0e56a467-cc87-4e20-b4a9-a30604008cfc' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Đảo Phú Quốc',
    address = 'Thành phố Phú Quốc, Kiên Giang',
    description = 'Phu Quoc Island, known as the ''''Pearl Island'''', is Vietnam''''s largest island basking in the warm Gulf of Thailand, famed for its powdery white shores such as Sao Beach and Khem Beach. Renowned globally for artisanal fish sauce brewing, black pepper plantations, and world-class seaside resorts, it offers mesmerizing golden sunsets.'
WHERE heritage_id = '0e56a467-cc87-4e20-b4a9-a30604008cfc' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'フーコック島（真珠の島）',
    address = 'Thành phố Phú Quốc, Kiên Giang',
    description = 'フーコック島は、「真珠の島」と称えられるタイランド湾に浮かぶベトナム最大の熱帯リゾート島です。バイサオ海岸をはじめとする鳴き砂の白浜ビーチやエメラルドグリーンの海、伝統の魚醤（ヌックマム）工場、胡椒農園があり、海に沈む極上の夕日が人々を魅了します。'
WHERE heritage_id = '0e56a467-cc87-4e20-b4a9-a30604008cfc' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Dãy Hoàng Liên Sơn',
    address = 'Dãy Hoàng Liên Sơn, Lào Cai',
    description = 'Dãy Hoàng Liên Sơn là dãy núi non hùng vĩ bậc nhất vùng Tây Bắc, được mệnh danh là ''''dãy Alps của Đông Nam Á'''' với nhiều đỉnh núi cao trên 2.800 mét quanh năm mây phủ. Địa hình núi non hiểm trở cùng những thung lũng ruộng bậc thang trập trùng Mường Hoa tạo nên cảnh sắc thiên nhiên kỳ vĩ làm say đắm lòng người.'
WHERE heritage_id = '05340a26-dacd-461a-a23f-2cc493cc7771' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Dãy Hoàng Liên Sơn',
    address = 'Dãy Hoàng Liên Sơn, Lào Cai',
    description = 'The Hoang Lien Son Mountain Range is the most majestic cordillera in Vietnam, often hailed as the ''''Tonkinese Alps'''' with multiple rugged peaks exceeding 2,800 meters. The dramatic mountain landscape, interwoven with Sapa''''s iconic cascading rice terraces and ethnic hill-tribe hamlets, offers world-class trekking vistas.'
WHERE heritage_id = '05340a26-dacd-461a-a23f-2cc493cc7771' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ホアンリエンソン山脈',
    address = 'Dãy Hoàng Liên Sơn, Lào Cai',
    description = 'ホアンリエンソン山脈は、ベトナム北西部に連なる国内最高峰の山脈であり、「トンキン・アルプス」と称される雄大な山岳地帯です。標高2,800メートル級の峻険な峰々と、山肌を幾重にも埋め尽くすムオンホア渓谷の棚田が織りなす大自然は圧巻の美しさです。'
WHERE heritage_id = '05340a26-dacd-461a-a23f-2cc493cc7771' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Đền Đô (Đền Lý Bát Đế)',
    address = 'Đền Đô (Đền Lý Bát Đế), Bắc Ninh',
    description = 'Đền Đô, hay Cổ Pháp Điện, tọa lạc tại phường Đình Bảng, thị xã Từ Sơn, Bắc Ninh, là nơi phụng thờ 8 vị hoàng đế triều Lý - triều đại khai mở nền văn minh Thăng Long độc lập. Quần thể đền mang kiến trúc cung đình truyền thống rộng lớn với hồ Bán Nguyệt, nhà Thủy Đình cổ kính và không gian tôn kính đậm đà bản sắc hào khí Thăng Long.'
WHERE heritage_id = '0df4d271-6943-4c09-8518-ab6e2cf6eb50' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Đền Đô (Đền Lý Bát Đế)',
    address = 'Đền Đô (Đền Lý Bát Đế), Bắc Ninh',
    description = 'Do Temple, also known as Ly Bat De Shrine, is located in Dinh Bang, Bac Ninh, dedicated to venerating the eight monarchs of the Ly Dynasty who founded imperial Thang Long. The sprawling complex incorporates serene crescent ponds, water pavilions, and ancient shrines echoing the golden cultural dawn of independent Vietnam.'
WHERE heritage_id = '0df4d271-6943-4c09-8518-ab6e2cf6eb50' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ドー寺（李八帝廟）',
    address = 'Đền Đô (Đền Lý Bát Đế), Bắc Ninh',
    description = 'ドー寺（李八帝廟）は、バクニン省ディンバンにある、ハノイ遷都を行い黄金期を築いた李朝の歴代8人の皇帝を祀る神聖な霊廟です。美しい半月池に浮かぶ水上東屋や格式高い宮廷様式の社殿が立ち並び、国家草創期の栄光を今に伝えています。'
WHERE heritage_id = '0df4d271-6943-4c09-8518-ab6e2cf6eb50' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Đền Mẫu Âu Cơ (Hạ Hòa)',
    address = 'Đền Mẫu Âu Cơ (Hạ Hòa), Phú Thọ',
    description = 'Đền Mẫu Âu Cơ ngự giữa rừng cọ xanh ngát thuộc xã Hiền Lương, huyện Hạ Hòa, Phú Thọ, là nơi thờ Mẹ Âu Cơ - người mẹ huyền thoại sinh ra bọc trăm trứng nở thành trăm người con của bách việt. Ngôi đền cổ kính linh thiêng lưu giữ bức tượng Mẹ Âu Cơ ngồi trên ngai vàng cùng câu chuyện truyền thuyết thiêng liêng về nguồn cội ''''con Rồng cháu Tiên'''' của dân tộc.'
WHERE heritage_id = '48eb5588-83fd-4ac5-a1d6-92d7d15170f6' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Đền Mẫu Âu Cơ (Hạ Hòa)',
    address = 'Đền Mẫu Âu Cơ (Hạ Hòa), Phú Thọ',
    description = 'Au Co Mother Temple sits amidst whispering palm hills in Hien Luong, Phu Tho, dedicated to Mother Au Co, the legendary matriarch who gave birth to the sack of one hundred eggs founding the Vietnamese race. The sacred forest temple enshrines a solemn statue of Mother Au Co, celebrating the eternal cultural myth of Dragon and Fairy ancestry.'
WHERE heritage_id = '48eb5588-83fd-4ac5-a1d6-92d7d15170f6' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'アウコー母神廟（ハホア）',
    address = 'Đền Mẫu Âu Cơ (Hạ Hòa), Phú Thọ',
    description = 'アウコー母神廟は、フート省のヤシの丘に抱かれた神聖な廟で、百個の卵を産んでベトナム民族の始祖となった伝説の母神アウコー（欧姫）を祀っています。「龍と仙人の子孫」というベトナム人のルーツを象徴する重要な聖地として、多くの参拝者が訪れます。'
WHERE heritage_id = '48eb5588-83fd-4ac5-a1d6-92d7d15170f6' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Đền Ngọc Sơn (Hồ Hoàn Kiếm)',
    address = 'Hồ Hoàn Kiếm, Đinh Tiên Hoàng, Hoàn Kiếm, Hà Nội',
    description = 'Đền Ngọc Sơn tọa lạc trên đảo Ngọc giữa làn nước xanh biếc của hồ Hoàn Kiếm, được nối với bờ bằng cầu Thê Húc màu đỏ son uốn cong duyên dáng. Ngôi đền thờ Đức Thánh Trần Hưng Đạo và Văn Xương Đế Quân, lưu giữ tiêu bản Rùa Hồ Gươm khổng lồ gắn liền với truyền thuyết trả gươm thần lịch sử của vua Lê Thái Tổ.'
WHERE heritage_id = 'c76d68ce-a5c8-4128-8389-b0984dae7b20' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Đền Ngọc Sơn (Hồ Hoàn Kiếm)',
    address = 'Hồ Hoàn Kiếm, Đinh Tiên Hoàng, Hoàn Kiếm, Hà Nội',
    description = 'Temple of the Jade Mountain (Ngoc Son Temple) crowns Jade Island in the emerald waters of Hoan Kiem Lake, accessed via the scarlet wooden The Huc Bridge. Dedicated to national hero Tran Hung Dao and the god of literature, it houses preserved specimens of the sacred giant softshell turtles of Sword Lake.'
WHERE heritage_id = 'c76d68ce-a5c8-4128-8389-b0984dae7b20' AND language_code = 'en';
UPDATE heritage_translations
SET name = '玉山祠（ゴックソン寺・ホアンキエム湖）',
    address = 'Hồ Hoàn Kiếm, Đinh Tiên Hoàng, Hoàn Kiếm, Hà Nội',
    description = '玉山祠（ゴックソン寺）は、ホアンキエム湖に浮かぶ小島「玉島」に建つ、19世紀創建の風光明媚な寺院です。湖畔から朱塗りの木造「テーフック橋（棲旭橋）」を渡って参拝でき、文昌帝君や名将チャン・フン・ダオを祀り、伝説の巨大スッポンの剥製が展示されています。'
WHERE heritage_id = 'c76d68ce-a5c8-4128-8389-b0984dae7b20' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Đền Tưởng niệm Liệt sĩ Bến Dược',
    address = 'Đền Tưởng niệm Liệt sĩ Bến Dược, TP. Hồ Chí Minh',
    description = 'Đền Tưởng niệm Liệt sĩ Bến Dược nằm trong khu di tích Địa đạo Củ Chi bên dòng sông Sài Gòn, là công trình văn hóa lịch sử tâm linh quy mô lớn tri ân hơn 44.000 liệt sĩ đã hy sinh vì nền độc lập tự do của Tổ quốc. Ngôi đền mang kiến trúc cổ truyền ba tầng mái uốn cong chạm trổ công phu và tháp chuông 9 tầng vươn cao kiêu hãnh.'
WHERE heritage_id = 'e98c04bf-555a-4c43-9790-1d6ab86b135c' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Đền Tưởng niệm Liệt sĩ Bến Dược',
    address = 'Đền Tưởng niệm Liệt sĩ Bến Dược, TP. Hồ Chí Minh',
    description = 'Ben Duoc Memorial Temple, located inside the Cu Chi Tunnels complex along the Saigon River, is a grand spiritual sanctuary honoring over 44,000 fallen martyrs who fought in the southern resistance. Crafted in traditional Vietnamese temple architecture with multi-tiered curved roofs, it features a towering nine-story memorial pagoda.'
WHERE heritage_id = 'e98c04bf-555a-4c43-9790-1d6ab86b135c' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ベンドゥオック殉国者記念廟（クチ）',
    address = 'Đền Tưởng niệm Liệt sĩ Bến Dược, TP. Hồ Chí Minh',
    description = 'ベンドゥオック殉国者記念廟は、クチの地下トンネル遺跡公園内にある、国土の解放のために散華した4万4千人以上の英雄烈士を祀る壮大な追悼寺院です。伝統的な多層屋根を持つ荘厳な本堂と九重の記念塔が建ち、訪れる人々に平和の尊さを伝えています。'
WHERE heritage_id = 'e98c04bf-555a-4c43-9790-1d6ab86b135c' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Đèo Hải Vân',
    address = 'Thị trấn Lăng Cô & Quận Liên Chiểu, Đà Nẵng',
    description = 'Đèo Hải Vân được mệnh danh là ''''Thiên hạ đệ nhất hùng quan'''', uốn lượn ngoạn mục qua dãy núi Bạch Mã nhô sát biển Đông nối liền Đà Nẵng và Thừa Thiên Huế. Đứng từ đỉnh đèo quanh năm mây phủ, du khách có thể phóng tầm mắt ngắm vịnh Đà Nẵng cong mềm và làn nước xanh thẳm của Lăng Cô.'
WHERE heritage_id = 'bad03177-3e8f-4bff-9156-1b01ee174669' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Đèo Hải Vân',
    address = 'Thị trấn Lăng Cô & Quận Liên Chiểu, Đà Nẵng',
    description = 'Hai Van Pass, hailed as the ''''Most Magnificent Gateway under Heaven'''', twists dramatically along the coastal cliffs of the Bach Ma range between Da Nang and Hue. From the mist-shrouded summit, travelers are rewarded with breathtaking panoramic vistas of Da Nang Bay and the turquoise crescent of Lang Co Beach.'
WHERE heritage_id = 'bad03177-3e8f-4bff-9156-1b01ee174669' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ハイヴァン峠（海雲峠）',
    address = 'Thị trấn Lăng Cô & Quận Liên Chiểu, Đà Nẵng',
    description = 'ハイヴァン峠（海雲峠）は、「天下第一の奇観」と称えられ、ダナンとフエの境界に連なるアンナン山脈を越える風光明媚な峠です。雲がたなびく標高約500メートルの頂上からは、弓なりに続くダナン湾とエメラルドグリーンに輝くランコー海岸の大絶景を見渡せます。'
WHERE heritage_id = 'bad03177-3e8f-4bff-9156-1b01ee174669' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Di tích Nhà tù Hỏa Lò (Hanoi Hilton)',
    address = 'Số 1 Hỏa Lò, Trần Hưng Đạo, Hoàn Kiếm, Hà Nội',
    description = 'Nhà tù Hỏa Lò được thực dân Pháp xây dựng năm 1896 dưới tên gọi Maison Centrale, là nơi từng giam giữ hàng vạn chiến sĩ cách mạng yêu nước Việt Nam trong điều kiện ngục tù khắc nghiệt. Trong chiến tranh kháng Mỹ, nơi đây từng là nơi tạm giam các phi công Mỹ bị bắn rơi và được họ đặt biệt danh hài hước là ''''Hanoi Hilton''''.'
WHERE heritage_id = '8518a833-aee9-4636-a4e6-11080fc736bb' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Di tích Nhà tù Hỏa Lò (Hanoi Hilton)',
    address = 'Số 1 Hỏa Lò, Trần Hưng Đạo, Hoàn Kiếm, Hà Nội',
    description = 'Hoa Lo Prison, constructed by French authorities in 1896 as Maison Centrale, originally served as a maximum-security penitentiary for Vietnamese political revolutionaries. During the Vietnam War, the facility held captured American pilots—including late Senator John McCain—who ironically dubbed it the ''''Hanoi Hilton''''.'
WHERE heritage_id = '8518a833-aee9-4636-a4e6-11080fc736bb' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ホアロー収容所跡（ハノイ・ヒルトン）',
    address = 'Số 1 Hỏa Lò, Trần Hưng Đạo, Hoàn Kiếm, Hà Nội',
    description = 'ホアロー収容所跡は、1896年にフランス植民地政府によって愛国主義者や政治犯を収容するために建設された刑務所です。ベトナム戦争時には撃墜された米軍パイロットの収容施設としても使われ、アメリカ兵たちから「ハノイ・ヒルトン」という皮肉な別名で呼ばれました。'
WHERE heritage_id = '8518a833-aee9-4636-a4e6-11080fc736bb' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Di Tích Quốc Gia Đặc Biệt Thành Điện Hải',
    address = 'Số 24 Trần Phú, Phường Thạch Thang, Quận Hải Châu, TP. Đà Nẵng',
    description = 'Thành Điện Hải là pháo đài quân sự cổ kiểu Vauban kiên cố do triều Gia Long và Minh Mạng xây dựng để bảo vệ cửa biển Đà Nẵng. Đây là nơi ghi dấu trang sử hào hùng của dân tộc trong trận đầu kháng Pháp năm 1858 dưới sự chỉ huy thao lược của danh tướng Nguyễn Tri Phương, giam chân quân địch suốt nhiều tháng ròng.'
WHERE heritage_id = 'dbb0c93e-7c2e-48a5-9a21-339e4880d9fe' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Di Tích Quốc Gia Đặc Biệt Thành Điện Hải',
    address = 'Số 24 Trần Phú, Phường Thạch Thang, Quận Hải Châu, TP. Đà Nẵng',
    description = 'Di Tích Quốc Gia Đặc Biệt Thành Điện Hải is an esteemed cultural and scenic landmark located in Da Nang, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = 'dbb0c93e-7c2e-48a5-9a21-339e4880d9fe' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ディエンハイ城塞 (国家特別遺跡)',
    address = 'Số 24 Trần Phú, Phường Thạch Thang, Quận Hải Châu, TP. Đà Nẵng',
    description = 'Di Tích Quốc Gia Đặc Biệt Thành Điện Hảiは、ベトナムダナンに位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = 'dbb0c93e-7c2e-48a5-9a21-339e4880d9fe' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Địa đạo Củ Chi',
    address = 'TL15, Phú Hiệp, Củ Chi, TP. Hồ Chí Minh',
    description = 'Địa đạo Củ Chi là ''''thành phố ngầm'''' huyền thoại dài hơn 250 km được quân và dân Củ Chi đào hoàn toàn bằng tay trong hai cuộc kháng chiến chống Pháp và chống Mỹ. Hệ thống địa đạo đa tầng kiên cố gồm bệnh viện dã chiến, bếp Hoàng Cầm giấu khói, phòng họp và kho vũ khí ngầm thể hiện ý chí quật cường và nghệ thuật chiến tranh nhân dân độc đáo.'
WHERE heritage_id = 'ab6fd7cf-fe44-456c-a363-359d18c9af1e' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Địa đạo Củ Chi',
    address = 'TL15, Phú Hiệp, Củ Chi, TP. Hồ Chí Minh',
    description = 'The Cu Chi Tunnels form a legendary subterranean network stretching over 250 kilometers, dug entirely by hand during the resistance wars. Featuring multi-level living quarters, smoke-less Hoang Cam kitchens, surgical bunkers, and booby traps, it stands as an astonishing monument to human resilience and guerrilla warfare.'
WHERE heritage_id = 'ab6fd7cf-fe44-456c-a363-359d18c9af1e' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'クチの地下トンネル',
    address = 'TL15, Phú Hiệp, Củ Chi, TP. Hồ Chí Minh',
    description = 'クチの地下トンネルは、抗仏・抗米戦争中に手作業で掘り進められた全長250キロメートル以上に及ぶ網の目のような地下要塞です。病院、台所、指令室、武器工場が多層に配置され、米軍の猛攻をしのいだ驚異的なゲリラ戦の歴史を物語る世界的遺構です。'
WHERE heritage_id = 'ab6fd7cf-fe44-456c-a363-359d18c9af1e' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Điện Thái Hòa (Hoàng Thành Huế)',
    address = 'Đại Nội Huế, Thuận Thành, Thành phố Huế',
    description = 'Điện Thái Hòa là ngôi chính điện uy nghiêm nhất trong Đại Nội Huế, nơi diễn ra các lễ đăng quang, sinh nhật vua và đón tiếp sứ thần của 13 vị vua triều Nguyễn. Ngôi điện mang kiến trúc ''''trùng thiềm điệp ốc'''' với 80 cột gỗ lim sơn son thếp vàng chạm rồng mây tinh xảo và ngai vàng quyền lực tối thượng.'
WHERE heritage_id = 'e3021783-0a0f-4fe4-8054-5e3e32486174' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Điện Thái Hòa (Hoàng Thành Huế)',
    address = 'Đại Nội Huế, Thuận Thành, Thành phố Huế',
    description = 'The Hall of Supreme Harmony is the principal ceremonial palace inside Hue''''s Imperial Citadel, where coronations, royal anniversaries, and official receptions of the 13 Nguyen emperors were staged. Supported by 80 gilded ironwood pillars intricately carved with clouds and dragons, it preserves the imperial golden throne.'
WHERE heritage_id = 'e3021783-0a0f-4fe4-8054-5e3e32486174' AND language_code = 'en';
UPDATE heritage_translations
SET name = '太和殿（フエ王宮正殿）',
    address = 'Đại Nội Huế, Thuận Thành, Thành phố Huế',
    description = '太和殿は、フエ王宮の中心に位置し、阮朝の歴代皇帝の即位式や重要な国家行事が執り行われた最も格式高い正殿です。「重簷畳屋」様式の伝統建築で、金箔と朱漆で装飾された80本の鉄木（リム）の柱に囲まれるように玉座が鎮座しています。'
WHERE heritage_id = 'e3021783-0a0f-4fe4-8054-5e3e32486174' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Đình Bảng',
    address = 'Phường Đình Bảng, Thành phố Từ Sơn, Tỉnh Bắc Ninh, Việt Nam',
    description = 'Đình Bảng là Di tích quốc gia đặc biệt tại thành phố Từ Sơn, Bắc Ninh, được xây dựng từ thế kỷ 18 với quy mô đồ sộ và nghệ thuật điêu khắc gỗ tinh xảo bậc nhất kiến trúc đình làng Việt Nam.'
WHERE heritage_id = 'e8f6245e-8493-4b9a-a937-82a726d7609c' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Dinh Bang Communal House',
    address = 'Phường Đình Bảng, Thành phố Từ Sơn, Tỉnh Bắc Ninh, Việt Nam',
    description = 'Dinh Bang Communal House is a special national historic relic in Tu Son, Bac Ninh, renowned for its imposing 18th-century timber architecture and masterfully carved traditional motifs.'
WHERE heritage_id = 'e8f6245e-8493-4b9a-a937-82a726d7609c' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ディンバン集会所（亭）',
    address = 'Phường Đình Bảng, Thành phố Từ Sơn, Tỉnh Bắc Ninh, Việt Nam',
    description = 'ディンバン集会所はバクニン省トゥーソン市に佇む国家特別歴史遺産であり、18世紀に建立された壮大な木造建築と精緻な彫刻美を誇る伝統的集会所です。'
WHERE heritage_id = 'e8f6245e-8493-4b9a-a937-82a726d7609c' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Đền Lừ (Đình Lừ)',
    address = 'Phường Hoàng Văn Thụ, Quận Hoàng Mai, Thành phố Hà Nội, Việt Nam',
    description = 'Đền Lừ là di tích lịch sử - văn hóa cổ kính tại quận Hoàng Mai, Hà Nội, lưu giữ nét sinh hoạt tâm linh lâu đời và các hiện vật điêu khắc truyền thống gắn liền với lịch sử ngàn năm Thăng Long.'
WHERE heritage_id = '7d382c7e-e680-4813-8fed-1eac74e60950' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Den Lu Temple',
    address = 'Phường Hoàng Văn Thụ, Quận Hoàng Mai, Thành phố Hà Nội, Việt Nam',
    description = 'Den Lu Temple is a revered historic shrine in Hoang Mai District, Hanoi, preserving centuries of spiritual traditions and classical Vietnamese communal architecture.'
WHERE heritage_id = '7d382c7e-e680-4813-8fed-1eac74e60950' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'デンルー寺院',
    address = 'Phường Hoàng Văn Thụ, Quận Hoàng Mai, Thành phố Hà Nội, Việt Nam',
    description = 'デンルー寺院はハノイ市ホアンマイ区に位置する由緒ある古刹であり、古都タンロンの豊かな信仰文化と伝統的な木造彫刻を今に伝えています。'
WHERE heritage_id = '7d382c7e-e680-4813-8fed-1eac74e60950' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Dinh Độc Lập (Dinh Thống Nhất)',
    address = '135 Nam Kỳ Khởi Nghĩa, Bến Thành, Quận 1, TP. Hồ Chí Minh',
    description = 'Dinh Độc Lập, nay là Di tích Quốc gia Đặc biệt Dinh Thống Nhất, là kiệt tác kiến trúc do kiến trúc sư tài ba Ngô Viết Thụ thiết kế kết hợp triết lý phương Đông với kỹ thuật hiện đại phương Tây trên khuôn viên 12 ha rợp bóng cổ thụ. Nơi đây đã đi vào lịch sử thế giới vào trưa ngày 30 tháng 4 năm 1975 khi chiếc xe tăng giải phóng húc đổ cánh cổng sắt, đánh dấu sự thống nhất trọn vẹn non sông.'
WHERE heritage_id = '6840138c-cb22-47b1-9378-b4d1f1856fbb' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Dinh Độc Lập (Dinh Thống Nhất)',
    address = '135 Nam Kỳ Khởi Nghĩa, Bến Thành, Quận 1, TP. Hồ Chí Minh',
    description = 'The Independence Palace, also known as Reunification Palace, is a masterpiece of modernist architecture designed by Ngo Viet Thu, harmonizing Eastern geomancy with Western structural design across 12 lush hectares. It became a historic global icon on April 30, 1975, when liberation tanks crashed through its iron gates, marking the reunification of Vietnam.'
WHERE heritage_id = '6840138c-cb22-47b1-9378-b4d1f1856fbb' AND language_code = 'en';
UPDATE heritage_translations
SET name = '統一会堂（旧大統領官邸 / 独立宮殿）',
    address = '135 Nam Kỳ Khởi Nghĩa, Bến Thành, Quận 1, TP. Hồ Chí Minh',
    description = '統一会堂（旧大統領官邸 / 独立宮殿）は、著名な建築家ゴー・ヴィエット・トゥーが設計し、東洋哲学の「吉」の字などを取り入れた近代モダニズム建築の最高傑作です。1975年4月30日に解放軍の戦車が鉄門を突破してベトナム戦争が終結した歴史の舞台として世界に知られています。'
WHERE heritage_id = '6840138c-cb22-47b1-9378-b4d1f1856fbb' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Đỉnh Fansipan',
    address = 'Dãy Hoàng Liên Sơn, Sa Pa, Lào Cai',
    description = 'Fansipan là đỉnh núi cao nhất trong dãy Hoàng Liên Sơn và được mệnh danh là ''''Nóc nhà Đông Dương'''' với độ cao kiêu hãnh 3.143 mét so với mực nước biển. Chinh phục đỉnh Fansipan, du khách sẽ bước vào chốn bồng lai tiên cảnh giữa biển mây bồng bềnh, chiêm bái đại tượng Phật A Di Đà bằng đồng uy nghiêm giữa mây ngàn Sa Pa.'
WHERE heritage_id = '761fca85-40b6-4639-96bf-92a09d04b49f' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Đỉnh Fansipan',
    address = 'Dãy Hoàng Liên Sơn, Sa Pa, Lào Cai',
    description = 'Fansipan Peak crowns the Hoang Lien Son mountain range as the celebrated ''''Roof of Indochina'''', soaring proudly at 3,143 meters above sea level. Reached by scenic hiking trails or modern cable cars from Sa Pa, the summit opens into a celestial cloud paradise crowned by monumental Buddhist sanctuaries and panoramic alpine ridges.'
WHERE heritage_id = '761fca85-40b6-4639-96bf-92a09d04b49f' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ファンシーパン山（インドシナ最高峰）',
    address = 'Dãy Hoàng Liên Sơn, Sa Pa, Lào Cai',
    description = 'ファンシーパン山は、ホアンリエンソン山脈にそびえ立つ標高3,143メートルの「インドシナ最高峰」です。サパからロープウェイまたは登山道で雲上の山頂へ登ることができ、眼下に広がる壮大な雲海と連峰のパノラマ、山頂の巨大な阿弥陀如来銅像が訪れる者を圧倒します。'
WHERE heritage_id = '761fca85-40b6-4639-96bf-92a09d04b49f' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Đình Làng Cổ Túy Loan',
    address = 'Làng Cổ Túy Loan, Xã Hòa Phong, Huyện Hòa Vang, TP. Đà Nẵng',
    description = 'Đình Túy Loan là một trong những ngôi đình cổ kính và linh thiêng nhất xứ Quảng với lịch sử hơn 500 năm hình thành cùng sự phát triển của làng cổ Túy Loan. Nơi đây bảo lưu trọn vẹn kiến trúc gỗ truyền thống ngũ phụ gia ba gian hai chái, lưu giữ hơn 20 sắc phong quý giá của các triều đại vua chúa nhà Nguyễn và phong vị bánh tráng Túy Loan nức tiếng.'
WHERE heritage_id = '6ece9832-a064-4d11-8c0e-184050d02109' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Đình Làng Cổ Túy Loan',
    address = 'Làng Cổ Túy Loan, Xã Hòa Phong, Huyện Hòa Vang, TP. Đà Nẵng',
    description = 'Đình Làng Cổ Túy Loan is an esteemed cultural and scenic landmark located in Da Nang, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = '6ece9832-a064-4d11-8c0e-184050d02109' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'トゥイロアン古代集会所 (古村ディン)',
    address = 'Làng Cổ Túy Loan, Xã Hòa Phong, Huyện Hòa Vang, TP. Đà Nẵng',
    description = 'Đình Làng Cổ Túy Loanは、ベトナムダナンに位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = '6ece9832-a064-4d11-8c0e-184050d02109' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Đồi cát Mũi Né',
    address = 'Đồi cát Mũi Né, Phường Mũi Né, Thành phố Phan Thiết, Tỉnh Bình Thuận, Việt Nam',
    description = 'Đồi cát Mũi Né (còn gọi là Đồi cát Bay) là danh thắng thiên nhiên nổi tiếng bậc nhất Bình Thuận với những trảng cát vàng trải dài uốn lượn thay đổi hình dạng từng giờ theo chiều gió.'
WHERE heritage_id = 'e0dfa682-bac9-4dde-a694-01a4cccd1d15' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Mui Ne Sand Dunes (Đồi cát Mũi Né)',
    address = 'Đồi cát Mũi Né, Phường Mũi Né, Thành phố Phan Thiết, Tỉnh Bình Thuận, Việt Nam',
    description = 'The Mui Ne Sand Dunes, located in Phan Thiet, Binh Thuan Province, are famous for their shifting golden sand hills and picturesque coastal landscapes overlooking the East Sea.'
WHERE heritage_id = 'e0dfa682-bac9-4dde-a694-01a4cccd1d15' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ムイネー砂丘',
    address = 'Đồi cát Mũi Né, Phường Mũi Né, Thành phố Phan Thiết, Tỉnh Bình Thuận, Việt Nam',
    description = 'ムイネー砂丘（イエロー・デューン）は、ビントゥアン省ファンティエットに位置し、風によって刻々と表情を変える壮大な黄金色の砂丘と美しい海岸線で親しまれています。'
WHERE heritage_id = 'e0dfa682-bac9-4dde-a694-01a4cccd1d15' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Động Thiên Đường',
    address = 'Bố Trạch, Quảng Bình',
    description = 'Động Thiên Đường được ca tụng là ''''hoàng cung trong lòng đất'''', tọa lạc giữa quần thể núi đá vôi hùng vĩ của vườn quốc gia Phong Nha - Kẻ Bàng với chiều dài kỷ lục hơn 31 km. Lòng động sở hữu hệ thống thạch nhũ và măng đá kỳ ảo đa dạng hình thù được thiên nhiên kiến tạo qua hàng triệu năm kiến tạo địa chất.'
WHERE heritage_id = 'e7b672b8-425d-4bdb-9df7-dc0aeac2577c' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Động Thiên Đường',
    address = 'Bố Trạch, Quảng Bình',
    description = 'Paradise Cave (Thien Duong Cave) is celebrated as a sublime ''''underground palace'''', nestled in the limestone karsts of Phong Nha-Ke Bang with an astounding length of 31.4 kilometers. The cavern features soaring vaulted chambers filled with glittering stalactites and stalagmites sculpted over millions of years.'
WHERE heritage_id = 'e7b672b8-425d-4bdb-9df7-dc0aeac2577c' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ティエン・ドゥオン洞（天国の洞窟）',
    address = 'Bố Trạch, Quảng Bình',
    description = 'ティエン・ドゥオン洞（天国の洞窟）は、フォンニャ＝ケバン国立公園に位置し全長31キロ以上を誇るアジア最長の乾燥洞窟です。「地中の宮殿」と称される巨大なドーム状の空間には、何百万年もの歳月が創り出した神秘的な鍾乳石が幻想的に輝いています。'
WHERE heritage_id = 'e7b672b8-425d-4bdb-9df7-dc0aeac2577c' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Hải đăng Kê Gà',
    address = 'Tân Thành, Hàm Thuận Nam, Bình Thuận',
    description = 'Hải đăng Kê Gà ngự trên một cù lao đá hoa cương hoang sơ thuộc huyện Hàm Thuận Nam, Bình Thuận, được người Pháp xây dựng từ năm 1897. Với chiều cao tháp 35 mét xây hoàn toàn bằng những khối đá granit mộng ghép tỉ mỉ, đây là ngọn hải đăng cổ kính và cao bậc nhất Việt Nam.'
WHERE heritage_id = '74c5d6b4-d9cc-4926-a1a3-ef0e6574497c' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Hải đăng Kê Gà',
    address = 'Tân Thành, Hàm Thuận Nam, Bình Thuận',
    description = 'Ke Ga Lighthouse stands atop a rugged granite islet off the coast of Ham Thuan Nam in Binh Thuan, erected by French engineers in 1897. Soaring 35 meters high with precision-hewn granite blocks, it remains the oldest and one of the tallest navigational beacons in Vietnam.'
WHERE heritage_id = '74c5d6b4-d9cc-4926-a1a3-ef0e6574497c' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ケーガ灯台',
    address = 'Tân Thành, Hàm Thuận Nam, Bình Thuận',
    description = 'ケーガ灯台は、ビントゥアン省ハムトゥアンナムの沖合に浮かぶ小島に1897年フランスによって建造されたベトナム最古級の灯台です。花崗岩を精巧に積み上げた高さ35メートルの八角形の塔が青い海と奇岩の中にそびえ立ち、息をのむ絶景を誇ります。'
WHERE heritage_id = '74c5d6b4-d9cc-4926-a1a3-ef0e6574497c' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Hải đăng Vũng Tàu (Núi Nhỏ)',
    address = 'Đỉnh Núi Nhỏ, Phường 2, Vũng Tàu, Bà Rịa - Vũng Tàu',
    description = 'Hải đăng Vũng Tàu ngự trên đỉnh Núi Nhỏ ở độ cao 170 mét so với mực nước biển, được người Pháp xây dựng từ năm 1862, là một trong những ngọn hải đăng cổ xưa nhất tại Việt Nam. Tháp hải đăng hình trụ tròn sơn trắng cao 18 mét, nối với nhà điều hành bằng một hầm hầm đá cổ kính, từ ban công ngọn hải đăng du khách có thể phóng tầm mắt bao trọn phố biển Vũng Tàu lộng gió.'
WHERE heritage_id = '923e7b4b-2754-45d2-8914-3c5d2529ec34' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Hải đăng Vũng Tàu (Núi Nhỏ)',
    address = 'Đỉnh Núi Nhỏ, Phường 2, Vũng Tàu, Bà Rịa - Vũng Tàu',
    description = 'Vung Tau Lighthouse crowns the summit of Small Mountain 170 meters above sea level, erected by the French in 1862 as one of Vietnam''''s oldest navigational beacons. The iconic 18-meter white cylindrical tower features an antique circular balcony offering spectacular 360-degree vistas over the coastal city and shimmering East Sea.'
WHERE heritage_id = '923e7b4b-2754-45d2-8914-3c5d2529ec34' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ブンタウ灯台（小山灯台）',
    address = 'Đỉnh Núi Nhỏ, Phường 2, Vũng Tàu, Bà Rịa - Vũng Tàu',
    description = 'ブンタウ灯台は、小山の頂上に1862年にフランスによって建設されたベトナム最古級の歴史的灯台です。高さ18メートルの純白の円筒形灯台へは古いトンネルを通って登ることができ、展望デッキからはブンタウ市街の街並みと青く輝く南シナ海の絶景を360度見渡せます。'
WHERE heritage_id = '923e7b4b-2754-45d2-8914-3c5d2529ec34' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Hang Sơn Đoòng',
    address = 'Vườn quốc gia Phong Nha - Kẻ Bàng, Quảng Bình',
    description = 'Hang Sơn Đoòng nằm sâu trong vùng lõi vườn quốc gia Phong Nha - Kẻ Bàng, được ghi nhận là hang động tự nhiên lớn nhất thế giới với thể tích lên tới 38,5 triệu mét khối. Lòng hang rộng lớn đến mức có thể chứa trọn một tòa nhà chọc trời, sở hữu hệ sinh thái rừng nhiệt đới riêng biệt, hồ nước ngầm và thạch nhũ khổng lồ.'
WHERE heritage_id = '7b760ce4-5297-4cb6-aafe-850a22c73b57' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Hang Sơn Đoòng',
    address = 'Vườn quốc gia Phong Nha - Kẻ Bàng, Quảng Bình',
    description = 'Son Doong Cave, hidden deep within Phong Nha-Ke Bang National Park, is verified as the largest natural cave on Earth with a volume exceeding 38.5 million cubic meters. The colossal subterranean labyrinth is immense enough to shelter a 40-story skyscraper, featuring its own localized climate, jungle, and underground clouds.'
WHERE heritage_id = '7b760ce4-5297-4cb6-aafe-850a22c73b57' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ソンドン洞（世界最大の洞窟）',
    address = 'Vườn quốc gia Phong Nha - Kẻ Bàng, Quảng Bình',
    description = 'ソンドン洞は、フォンニャ＝ケバン国立公園の最奥部に位置する世界最大の天然洞窟です。容積は約3850万立方メートルに達し、超高層ビルがすっぽり収まるほどの巨大な空間には、独自の気候システムや地下ジャングル、巨大な鍾乳石が広がっています。'
WHERE heritage_id = '7b760ce4-5297-4cb6-aafe-850a22c73b57' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Hiển Lâm Các (Đại Nội Huế)',
    address = 'Đại Nội Huế, Thành phố Huế',
    description = 'Hiển Lâm Các là công trình kiến trúc bằng gỗ thanh tú cao ba tầng nằm đối diện Thế Tổ Miếu trong Hoàng Thành Huế, được xây dựng năm 1821 dưới thời vua Minh Mạng. Tòa lầu được dựng lên như đài kỷ niệm ghi nhớ công lao các đại thần có công dựng nước, nổi bật với hệ mái ngói hoàng lưu ly trang nghiêm.'
WHERE heritage_id = 'e754f60b-0f79-4edd-94a7-ce22e7c5a5bb' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Hiển Lâm Các (Đại Nội Huế)',
    address = 'Đại Nội Huế, Thành phố Huế',
    description = 'The Pavilion of Splendour (Hien Lam Cac) is an elegant three-story timber tower facing The Mieu Temple in Hue''''s Imperial Citadel, built in 1821 by Emperor Minh Mang. Erected as a memorial monument to honor meritorious ministers and generals, it is distinguished by ornate carvings and glazed imperial yellow tiles.'
WHERE heritage_id = 'e754f60b-0f79-4edd-94a7-ce22e7c5a5bb' AND language_code = 'en';
UPDATE heritage_translations
SET name = '顕臨閣（フエ王宮）',
    address = 'Đại Nội Huế, Thành phố Huế',
    description = '顕臨閣は、フエ王宮内の太祖廟の正面に建つ高さ17メートルの優雅な木造三層楼閣です。1821年にミンマン（明命）帝によって功臣たちを顕彰するために建立され、繊細な木彫り装飾と屋根を彩る黄色い瑠璃瓦が往時の宮廷文化の気品を漂わせています。'
WHERE heritage_id = 'e754f60b-0f79-4edd-94a7-ce22e7c5a5bb' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Hồ Núi Cốc',
    address = 'Hồ Núi Cốc, Thái Nguyên',
    description = 'Hồ Núi Cốc là hồ nước ngọt nhân tạo tuyệt đẹp thuộc tỉnh Thái Nguyên, gắn liền với huyền thoại tình yêu thủy chung đầy xúc động giữa nàng Công và chàng Cốc. Mặt hồ mênh mông rộng 25 km² được điểm xuyết bởi 89 hòn đảo lớn nhỏ xanh tươi, là điểm đến du lịch sinh thái và nghỉ dưỡng hấp dẫn của vùng trung du.'
WHERE heritage_id = '78666601-c736-4111-bd5e-4c27dde8f1d3' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Hồ Núi Cốc',
    address = 'Hồ Núi Cốc, Thái Nguyên',
    description = 'Nui Coc Lake is an expansive man-made freshwater lake in Thai Nguyen, steeped in the tragic romantic folk legend of Cong and Coc. Spanning 25 square kilometers studded with 89 emerald islets, it offers scenic boat cruises, amusement parks, and refreshing midland mountain breezes.'
WHERE heritage_id = '78666601-c736-4111-bd5e-4c27dde8f1d3' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ヌイコック湖',
    address = 'Hồ Núi Cốc, Thái Nguyên',
    description = 'ヌイコック湖は、タイグエン省に位置する広さ約25平方キロメートルの人工湖で、切ない純愛伝説「コンとコックの物語」が語り継がれています。湖面には89もの緑の小島が点在し、ボートクルーズや遊園地、湖畔リゾートを楽しめる人気の観光地です。'
WHERE heritage_id = '78666601-c736-4111-bd5e-4c27dde8f1d3' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Hồ Tây',
    address = 'Quận Tây Hồ, Hà Nội',
    description = 'Hồ Tây là hồ nước ngọt tự nhiên lớn nhất thủ đô Hà Nội với diện tích hơn 500 ha và chu vi bờ hồ gần 20 km, từng là một nhánh của dòng sông Hồng cổ. Mặt hồ lộng gió soi bóng những ngôi đền chùa cổ kính, vườn sen ngát hương và những cung đường dạo bộ lãng mạn ngắm hoàng hôn đỏ rực buông xuống mặt nước.'
WHERE heritage_id = 'f40f37d4-061c-4b98-92d1-8b02805a99ea' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Hồ Tây',
    address = 'Quận Tây Hồ, Hà Nội',
    description = 'West Lake (Ho Tay) is Hanoi''''s largest natural freshwater lake covering over 500 hectares with a scenic 17-kilometer shoreline, formed millennia ago as a meander of the Red River. Encircled by ancient temples, fragrant lotus ponds, and trendy lakeside cafes, it offers the capital''''s most romantic sunset panoramas.'
WHERE heritage_id = 'f40f37d4-061c-4b98-92d1-8b02805a99ea' AND language_code = 'en';
UPDATE heritage_translations
SET name = '西湖（タイ湖）',
    address = 'Quận Tây Hồ, Hà Nội',
    description = '西湖（タイ湖）は、ハノイ市内で最大の面積（約500ヘクタール）を誇る広大な天然湖です。湖畔には鎮国寺をはじめとする古刹や蓮池、お洒落なカフェが立ち並び、湖面が黄金色に染まる夕暮れ時のサンセットはハノイ屈指のロマンチックな風景として親しまれています。'
WHERE heritage_id = 'f40f37d4-061c-4b98-92d1-8b02805a99ea' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Hồ Tuyền Lâm (Đà Lạt)',
    address = 'Phường 4, Thành phố Đà Lạt, Lâm Đồng',
    description = 'Hồ Tuyền Lâm là hồ nước ngọt nhân tạo lớn nhất Đà Lạt với diện tích hơn 350 ha, bao bọc bởi những bán đảo xanh và rừng thông nguyên sinh ngút ngàn. Nơi đây là điểm đến lý tưởng cho các hoạt động chèo thuyền kayak, cắm trại dã ngoại và đón bình minh huyền ảo giữa làn sương khói.'
WHERE heritage_id = 'e5b48e8c-fbb4-4bda-b262-9e2207743178' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Hồ Tuyền Lâm (Đà Lạt)',
    address = 'Phường 4, Thành phố Đà Lạt, Lâm Đồng',
    description = 'Tuyen Lam Lake is Da Lat''''s largest freshwater lake spanning over 350 hectares, enveloped by verdant peninsulas and pine-covered ridges. It is an idyllic setting for kayaking, eco-camping, and watching morning mists drift gently over tranquil mirror-like waters.'
WHERE heritage_id = 'e5b48e8c-fbb4-4bda-b262-9e2207743178' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'トゥエンラム湖',
    address = 'Phường 4, Thành phố Đà Lạt, Lâm Đồng',
    description = 'トゥエンラム湖は、350ヘクタール以上の面積を誇るダラット最大の美しい淡水湖です。深い松林と小島が織りなす絵画のような風景に囲まれ、カヤックやSUP、湖畔でのキャンプなど自然を満喫できるリゾート地として親しまれています。'
WHERE heritage_id = 'e5b48e8c-fbb4-4bda-b262-9e2207743178' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Hồ Xuân Hương',
    address = 'Trung tâm Thành phố Đà Lạt, Lâm Đồng',
    description = 'Hồ Xuân Hương được ví như trái tim lãng mạn của thành phố Đà Lạt với hình dáng lưỡi liềm uốn quanh những hàng thông duyên dáng và thảm cỏ xanh mướt. Đây là nơi lý tưởng để tản bộ, đạp xe đạp nước thiên nga hoặc nhâm nhi tách cà phê ngắm sương mù bảng lảng trên mặt nước.'
WHERE heritage_id = 'b6090af6-8b6c-4cd2-92fe-563a60058611' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Hồ Xuân Hương',
    address = 'Trung tâm Thành phố Đà Lạt, Lâm Đồng',
    description = 'Xuan Huong Lake is the poetic heart of Da Lat, curving gracefully like a crescent moon bordered by weeping willows and flowering boulevards. It offers a dreamlike backdrop for leisurely strolls, swan paddle-boating, or savoring hot highland coffee beside the misty waters.'
WHERE heritage_id = 'b6090af6-8b6c-4cd2-92fe-563a60058611' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'スアンフーン湖（春香湖）',
    address = 'Trung tâm Thành phố Đà Lạt, Lâm Đồng',
    description = 'スアンフーン湖（春香湖）は、ダラットの中心部に位置し「街の心臓」と称される三日月形の美しい湖です。湖畔には柳や松の木々、鮮やかな花壇が整備され、白鳥ボートやサイクリング、湖面を渡る風を感じながらのカフェタイムが楽しめます。'
WHERE heritage_id = 'b6090af6-8b6c-4cd2-92fe-563a60058611' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Kênh Vĩnh Tế',
    address = 'Kênh Vĩnh Tế, An Giang',
    description = 'Kênh Vĩnh Tế là con kênh đào thủ công vĩ đại dài gần 90 km chạy dọc theo biên giới Việt Nam - Campuchia từ Châu Đốc ra biển Hà Tiên, do Thoại Ngọc Hầu chỉ huy đào đắp từ năm 1819 dưới triều vua Gia Long và Minh Mạng. Công trình thủy lợi quân sự lịch sử mang tên bà Châu Thị Tế - phu nhân của Thoại Ngọc Hầu, là chứng tích bất tử cho công cuộc khai hoang mở cõi và khẳng định chủ quyền non sông.'
WHERE heritage_id = 'b5fb4f57-b6a9-4a4e-b936-fa18fc318cf7' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Kênh Vĩnh Tế',
    address = 'Kênh Vĩnh Tế, An Giang',
    description = 'Vinh Te Canal is a monumental historic waterway stretching nearly 90 kilometers along the Vietnam-Cambodia border from Chau Doc to the Ha Tien coast, hand-dug under the leadership of General Thoai Ngoc Hau between 1819 and 1824. Named after his noble wife, Chau Thi Te, the canal transformed regional flood defense, agriculture, and border sovereignty.'
WHERE heritage_id = 'b5fb4f57-b6a9-4a4e-b936-fa18fc318cf7' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ヴィンテ運河（永済河）',
    address = 'Kênh Vĩnh Tế, An Giang',
    description = 'ヴィンテ運河（永済河）は、1819年から1824年にかけて名将トアイ・ゴック・ハウの指揮のもと、数万人の人々の手掘りで開削された中越国境沿いの全長約90キロに及ぶ大運河です。治水、灌漑、防衛に絶大な役割を果たし、名将の夫人の名（永済）を冠した不朽の歴史土木遺産です。'
WHERE heritage_id = 'b5fb4f57-b6a9-4a4e-b936-fa18fc318cf7' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Khu danh thắng Tam Cốc - Bích Động',
    address = 'Ninh Hải, Hoa Lư, Ninh Bình',
    description = 'Tam Cốc - Bích Động được ngợi ca là ''''Vịnh Hạ Long trên cạn'''', thuộc quần thể Di sản Thế giới Tràng An tại Ninh Bình. Du khách ngồi thuyền nan xuôi dòng sông Ngô Đồng thơ mộng uốn lượn xuyên qua ba hang động tự nhiên ngắm nhìn những vách núi đá vôi sừng sững và những ruộng lúa chín vàng óng đôi bờ vào mùa hạ.'
WHERE heritage_id = 'c4f15806-d138-4f05-a99e-25bd7ddaaebe' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Khu danh thắng Tam Cốc - Bích Động',
    address = 'Ninh Hải, Hoa Lư, Ninh Bình',
    description = 'Tam Coc - Bich Dong is celebrated as ''''Ha Long Bay on land'''', located within the UNESCO World Heritage landscape of Trang An in Ninh Binh. Hand-rowed sampans glide gently down the winding Ngo Dong River, steering through three natural cavern tunnels fringed by towering limestone karsts and vibrant golden rice paddies.'
WHERE heritage_id = 'c4f15806-d138-4f05-a99e-25bd7ddaaebe' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'タムコック＝ビックドン景勝地',
    address = 'Ninh Hải, Hoa Lư, Ninh Bình',
    description = 'タムコック＝ビックドンは、「陸のハロン湾」と称えられる世界遺産ニンビンの代表的な景勝地です。のどかなゴーゾン川を手漕ぎの小舟（サンパン）で進みながら、3つの自然の鍾乳洞門をくぐり抜け、奇岩カルストの絶壁と川沿いに広がる黄金色の水田の絶景を満喫できます。'
WHERE heritage_id = 'c4f15806-d138-4f05-a99e-25bd7ddaaebe' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Khu di tích Thành Cổ Loa',
    address = 'Xã Cổ Loa, Đông Anh, Hà Nội',
    description = 'Thành Cổ Loa là kinh đô cổ xưa nhất của nhà nước Âu Lạc thời kỳ An Dương Vương thế kỷ thứ III trước Công nguyên, nằm trên địa bàn huyện Đông Anh, Hà Nội. Tòa thành quân sự độc đáo với kiến trúc hình xoáy trôn ốc nhiều vòng lũy đất kiên cố gắn liền với truyền thuyết nỏ thần Kim Quy và câu chuyện tình bi tráng Trọng Thủy - Mỵ Châu.'
WHERE heritage_id = '888bd048-9c18-46e9-ba90-1eb4cdf47e28' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Khu di tích Thành Cổ Loa',
    address = 'Xã Cổ Loa, Đông Anh, Hà Nội',
    description = 'Co Loa Citadel is the oldest documented capital of ancient Vietnam, built in the 3rd century BCE under King An Duong Vuong of the Au Lac Kingdom in modern-day Dong Anh, Hanoi. Designed with unique spiral earthen defensive ramparts, the fortress is steeped in legendary lore of the magic crossbow and the historic romance of My Chau and Trong Thuy.'
WHERE heritage_id = '888bd048-9c18-46e9-ba90-1eb4cdf47e28' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'コーロア古城遺跡（古螺城）',
    address = 'Xã Cổ Loa, Đông Anh, Hà Nội',
    description = 'コーロア古城遺跡（古螺城）は、紀元前3世紀のアン・ズオン・ヴオン（安陽王）が築いたオーラック（甌雒）王国の都城跡です。渦巻き状（カタツムリの殻形）に三重の土塁と堀が巡らされた古代の軍事要塞であり、魔法の弓矢にまつわる神話や切ない悲恋伝説の舞台として知られています。'
WHERE heritage_id = '888bd048-9c18-46e9-ba90-1eb4cdf47e28' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Khu đô thị Vinhomes Times City',
    address = 'Khu đô thị Vinhomes Times City, Hà Nội',
    description = 'Vinhomes Times City tại quận Hai Bà Trưng, Hà Nội, là khu đô thị phức hợp sinh thái hiện đại bậc nhất thủ đô lấy cảm hứng từ kiến trúc Tây Âu thanh lịch. Điểm nhấn thu hút du khách là thủy cung ngầm Vinpearl Aquarium quy mô lớn với hàng chục nghìn sinh vật biển và quảng trường nhạc nước rực rỡ sắc màu mỗi tối.'
WHERE heritage_id = 'cffcc8ef-8307-4ea9-bcf3-a3db4b9e646b' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Khu đô thị Vinhomes Times City',
    address = 'Khu đô thị Vinhomes Times City, Hà Nội',
    description = 'Vinhomes Times City in Hai Ba Trung District, Hanoi, is a flagship master-planned urban complex inspired by sophisticated Western European architectural styling. Popular destinations within the development include the massive Vinpearl Aquarium housing thousands of marine species and nightly choreographed musical water fountains.'
WHERE heritage_id = 'cffcc8ef-8307-4ea9-bcf3-a3db4b9e646b' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ビンホームズ・タイムズシティ',
    address = 'Khu đô thị Vinhomes Times City, Hà Nội',
    description = 'ビンホームズ・タイムズシティは、ハノイ中心部に広がる西欧風の洗練された大規模近代複合都市です。巨大なショッピングモールの地下には数万匹の海洋生物が泳ぐ水族館「ヴィンパール・アクアリウム」があり、毎夜開催される音と光の噴水ショーが人気を集めています。'
WHERE heritage_id = 'cffcc8ef-8307-4ea9-bcf3-a3db4b9e646b' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Khu Du Lịch Bà Nà Hills',
    address = 'Khu Du Lịch Bà Nà Hills, Đà Nẵng',
    description = 'Bà Nà Hills tọa lạc trên đỉnh núi Chúa ở độ cao 1.487 mét so với mực nước biển, nổi danh với khí hậu bốn mùa trong một ngày và Cầu Vàng nâng đỡ bởi đôi bàn tay khổng lồ. Quần thể sở hữu tuyến cáp treo đạt nhiều kỷ lục thế giới và ngôi làng Pháp cổ kính giữa mây ngàn bồng bềnh.'
WHERE heritage_id = '375ffa07-2563-4480-a085-1e16884bcf6b' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Khu Du Lịch Bà Nà Hills',
    address = 'Khu Du Lịch Bà Nà Hills, Đà Nẵng',
    description = 'Ba Na Hills is a celebrated mountaintop resort perched 1,487 meters above sea level on Mount Chua, famed for its world-renowned Golden Bridge held aloft by giant stone hands. It features record-breaking cable car lines and a picturesque recreation of a medieval French village amid drifting alpine clouds.'
WHERE heritage_id = '375ffa07-2563-4480-a085-1e16884bcf6b' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'バーナーヒルズ観光区',
    address = 'Khu Du Lịch Bà Nà Hills, Đà Nẵng',
    description = 'バーナーヒルズは、標高1,487メートルのチュワ山頂に位置し、巨大な神の手が支える「ゴールデンブリッジ（黄金の橋）」で世界的な名声を誇る高原リゾートです。世界最長級のロープウェイや、中世フランスの街並みを再現したフレンチビレッジなど見どころが満載です。'
WHERE heritage_id = '375ffa07-2563-4480-a085-1e16884bcf6b' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Khu du lịch Đại Nam Văn Hiến',
    address = 'Khu du lịch Đại Nam Văn Hiến, Bình Dương',
    description = 'Khu du lịch Đại Nam Văn Hiến tại thành phố Thủ Dầu Một, Bình Dương, là quần thể du lịch tâm linh và giải trí rộng lớn bậc nhất Việt Nam với diện tích hơn 450 ha. Quần thể nổi bật với Đền Đại Nam dát vàng tráng lệ, vườn bách thú mở đầu tiên tại Việt Nam, trường đua phức hợp và biển nhân tạo tạo sóng khổng lồ.'
WHERE heritage_id = 'de1cafca-0077-4c99-9f4e-560ac5ed4319' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Khu du lịch Đại Nam Văn Hiến',
    address = 'Khu du lịch Đại Nam Văn Hiến, Bình Dương',
    description = 'Dai Nam Wonderland in Thu Dau Mot, Binh Duong, is one of Southeast Asia''''s most ambitious cultural theme parks spanning 450 hectares. Key highlights include the colossal golden Dai Nam Temple, the nation''''s premier open safari zoo, a modern racing circuit, and an expansive artificial wave beach.'
WHERE heritage_id = 'de1cafca-0077-4c99-9f4e-560ac5ed4319' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ダイナム観光テーマパーク',
    address = 'Khu du lịch Đại Nam Văn Hiến, Bình Dương',
    description = 'ダイナム観光区は、ビンズオン省トゥーザウモットにある総面積450ヘクタールを超えるベトナム最大級の複合テーマパークです。純金箔で装飾された壮麗なダイナム寺院、野生動物が自由に暮らすオープンサファリ、巨大な人工波プールなど多彩なアトラクションが揃っています。'
WHERE heritage_id = 'de1cafca-0077-4c99-9f4e-560ac5ed4319' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Khu du lịch Núi Tà Cú',
    address = 'Khu du lịch Núi Tà Cú, Bình Thuận',
    description = 'Núi Tà Cú là thắng cảnh tâm linh nổi tiếng của tỉnh Bình Thuận, sừng sững ở độ cao 649 mét giữa khu bảo tồn thiên nhiên ven biển Hàm Thuận Nam. Trên đỉnh núi có chùa Linh Sơn Trường Thọ ngự trị cùng bức tượng Phật Thích Ca nhập Niết bàn dài 49 mét kỷ lục, nằm thanh thản giữa ngút ngàn mây trời.'
WHERE heritage_id = 'bcbc76fd-c38f-48c7-8db2-840f2eb3e175' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Khu du lịch Núi Tà Cú',
    address = 'Khu du lịch Núi Tà Cú, Bình Thuận',
    description = 'Ta Cu Mountain is a revered spiritual landmark in Binh Thuan, rising 649 meters above sea level within a coastal nature reserve in Ham Thuan Nam. Near the forested summit sits Linh Son Truong Tho Pagoda, home to Vietnam''''s colossal 49-meter reclining Buddha resting peacefully amidst mountain mists.'
WHERE heritage_id = 'bcbc76fd-c38f-48c7-8db2-840f2eb3e175' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'タークー山観光区',
    address = 'Khu du lịch Núi Tà Cú, Bình Thuận',
    description = 'タークー山は、ビントゥアン省の海岸近くにそびえる標高649メートルの霊山です。熱帯雨林に包まれた山頂付近の古寺には、全長49メートルにも及ぶ東南アジア最大級の釈迦涅槃仏像（横たわる巨大仏）が鎮座し、多くの参拝者を集めています。'
WHERE heritage_id = 'bcbc76fd-c38f-48c7-8db2-840f2eb3e175' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Khu Du lịch Văn hóa Suối Tiên',
    address = '120 Xa lộ Hà Nội, Tân Phú, TP. Thủ Đức, TP. Hồ Chí Minh',
    description = 'Khu Du lịch Văn hóa Suối Tiên tại thành phố Thủ Đức là công viên giải trí chuyên đề đầu tiên trên thế giới xây dựng theo các chủ đề thần thoại và truyền thuyết lịch sử dân tộc Việt Nam. Quần thể nổi bật với biển Tiên Đồng Ngọc Nữ nhân tạo kỳ vĩ, bức tượng Vua Hùng khổng lồ tạc vào vách đá và hàng loạt trò chơi giải trí nước công nghệ cao hiện đại.'
WHERE heritage_id = '9e04bbc0-4676-4aae-8fb4-b3d0aabe63da' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Khu Du lịch Văn hóa Suối Tiên',
    address = '120 Xa lộ Hà Nội, Tân Phú, TP. Thủ Đức, TP. Hồ Chí Minh',
    description = 'Suoi Tien Cultural Theme Park in Thu Duc City is a globally unique amusement park themed around Vietnamese mythology, Buddhist folklore, and national creation legends. It features monumental attractions including the artificial Tien Dong - Ngoc Nu surf beach sculpted beneath giant rock-face deities, dynamic roller coasters, and magical water parks.'
WHERE heritage_id = '9e04bbc0-4676-4aae-8fb4-b3d0aabe63da' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'スイティエン文化テーマパーク',
    address = '120 Xa lộ Hà Nội, Tân Phú, TP. Thủ Đức, TP. Hồ Chí Minh',
    description = 'スイティエン文化テーマパークは、ベトナムの建国神話や仏教の伝説を壮大なスケールで具現化した世界唯一の宗教的テーマパークです。巨岩に彫られた歴代王の巨大な顔の彫刻や、ウォータースライダーを備えた巨大人工ビーチ「ティエンドン」、巨大な龍のオブジェなど、ユニークな体験が満喫できます。'
WHERE heritage_id = '9e04bbc0-4676-4aae-8fb4-b3d0aabe63da' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Kỳ Đài Huế',
    address = 'Kinh thành Huế, Thuận Hòa, Thành phố Huế',
    description = 'Kỳ Đài Huế là cột cờ sừng sững trước Ngọ Môn Hoàng Thành Huế, được xây dựng từ năm Gia Long thứ 6 (1807) bằng gạch vồ ba tầng kiên cố. Trải qua bao thăng trầm lịch sử và khói lửa chiến tranh, Kỳ Đài vẫn hiên ngang là biểu tượng uy nghi của vương quyền và chủ quyền dân tộc nơi cố đô.'
WHERE heritage_id = '0d128f84-9ea2-40e6-9627-b65ae5cd3cee' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Kỳ Đài Huế',
    address = 'Kinh thành Huế, Thuận Hòa, Thành phố Huế',
    description = 'Hue Flag Tower stands majestically before the Noon Gate of the Imperial Citadel, erected in 1807 during Emperor Gia Long''''s reign on a three-tier brick fortress. Having weathered turbulent historical epochs and wartime conflicts, the colossal flag bastion remains an enduring emblem of sovereign pride.'
WHERE heritage_id = '0d128f84-9ea2-40e6-9627-b65ae5cd3cee' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'フエの旗台（コット・コー）',
    address = 'Kinh thành Huế, Thuận Hòa, Thành phố Huế',
    description = 'フエの旗台（コット・コー）は、フエ王宮の正門（午門）の正面にそびえ立つ3段の巨大なレンガ造りの要塞台です。1807年にザーロン帝によって築かれ、幾多の歴史の荒波と戦火を潜り抜けながら、古都の尊厳と主権を象徴し続けています。'
WHERE heritage_id = '0d128f84-9ea2-40e6-9627-b65ae5cd3cee' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Lăng Chủ tịch Hồ Chí Minh',
    address = 'Số 2 Hùng Vương, Điện Biên, Ba Đình, Hà Nội',
    description = 'Lăng Chủ tịch Hồ Chí Minh tọa lạc trang nghiêm tại trung tâm Quảng trường Ba Đình, là nơi yên nghỉ vĩnh hằng của vị lãnh tụ kính yêu của dân tộc Việt Nam. Công trình được xây dựng kiên cố bằng đá hoa cương khối xám tự nhiên mang hình tượng đài hoa sen cách điệu, hàng ngày đón hàng vạn đồng bào và bạn bè quốc tế vào lăng viếng Bác.'
WHERE heritage_id = 'b13c8b30-9b00-4fc9-8ddd-63b1e0b255c6' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Lăng Chủ tịch Hồ Chí Minh',
    address = 'Số 2 Hùng Vương, Điện Biên, Ba Đình, Hà Nội',
    description = 'The Ho Chi Minh Mausoleum is the monumental resting place of Vietnam''''s revered revolutionary leader, standing solemnly at the center of Ba Dinh Square. Crafted from grey and dark red polished granite evocative of a lotus blossom, it welcomes thousands of domestic citizens and international dignitaries daily.'
WHERE heritage_id = 'b13c8b30-9b00-4fc9-8ddd-63b1e0b255c6' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ホー・チミン廟',
    address = 'Số 2 Hùng Vương, Điện Biên, Ba Đình, Hà Nội',
    description = 'ホー・チミン廟は、バーディン広場の中央に厳粛に建つベトナム建国の父ホー・チミン主席の遺体が安置されている霊廟です。蓮の花をモチーフにした重厚な花崗岩造りの建物内では、ガラスの棺に眠る生前のままの指導者に敬意を捧げる人々が静かに行列を作ります。'
WHERE heritage_id = 'b13c8b30-9b00-4fc9-8ddd-63b1e0b255c6' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Lăng Gia Long (Thiên Thọ Lăng)',
    address = 'Hương Thọ, Thị xã Hương Trà, Thừa Thiên Huế',
    description = 'Lăng Gia Long, hay Thiên Thọ Lăng, là lăng tẩm của vị vua khai sáng triều Nguyễn, tọa lạc giữa quần sơn Thiên Thọ cách trung tâm Huế 20 km. Khu lăng mang vẻ đẹp trầm mặc, khoáng đạt với sự hòa quyện tuyệt đối giữa công trình kiến trúc lăng mộ với thiên nhiên núi rừng và hồ nước bao la.'
WHERE heritage_id = '47fff1a7-1aa4-4e31-8019-7fdf2a847090' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Lăng Gia Long (Thiên Thọ Lăng)',
    address = 'Hương Thọ, Thị xã Hương Trà, Thừa Thiên Huế',
    description = 'The Tomb of Emperor Gia Long (Thien Tho Tomb) is the final resting place of the founding monarch of the Nguyen Dynasty, set amidst the serene Thien Tho mountains south of Hue. The mausoleum complex exudes profound solemnity, harmonizing minimalist imperial architecture with expansive pine hills and reflecting lakes.'
WHERE heritage_id = '47fff1a7-1aa4-4e31-8019-7fdf2a847090' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ザーロン帝陵（天授陵）',
    address = 'Hương Thọ, Thị xã Hương Trà, Thừa Thiên Huế',
    description = 'ザーロン帝陵（天授陵）は、阮朝の初代皇帝ザーロン帝と皇后が眠る陵墓群で、フエ郊外の静かな山林に位置しています。広大な自然の丘陵地帯と静かな池が巧みに借景として取り入れられ、壮大でありながらも素朴で厳粛な美しさを湛えています。'
WHERE heritage_id = '47fff1a7-1aa4-4e31-8019-7fdf2a847090' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Lăng Thiệu Trị (Xương Lăng)',
    address = 'Thủy Bằng, Hương Thủy, Thừa Thiên Huế',
    description = 'Lăng Thiệu Trị tọa lạc dưới chân núi Thuận Đạo, là lăng tẩm duy nhất của các vua triều Nguyễn quay mặt về hướng tây bắc và không có la thành bao bọc. Mang tính cách khiêm cung, giản dị, lăng hòa mình nhẹ nhàng vào những ruộng lúa xanh rì và vườn cây ăn trái thanh bình chốn đồng quê xứ Huế.'
WHERE heritage_id = 'ef615eeb-b4ba-436a-b688-9b94a171b8ed' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Lăng Thiệu Trị (Xương Lăng)',
    address = 'Thủy Bằng, Hương Thủy, Thừa Thiên Huế',
    description = 'The Tomb of Emperor Thieu Tri (Xuong Tomb) lies nestled at the foot of Thuan Dao Mountain, notable as the only royal mausoleum in Hue facing northwest and built without an enclosing outer wall. Reflecting the emperor''''s humble character, it integrates gently into rural rice paddies and peaceful orchard groves.'
WHERE heritage_id = 'ef615eeb-b4ba-436a-b688-9b94a171b8ed' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ティエウチー帝陵（昌陵）',
    address = 'Thủy Bằng, Hương Thủy, Thừa Thiên Huế',
    description = 'ティエウチー帝陵（昌陵）は、フエ郊外のトゥアンダオ山の麓に位置する阮朝第3代皇帝の陵墓です。周囲を囲む高い城壁を持たず、周囲の長閑な水田や果樹園と一体となった開放的で質素な佇まいが、皇帝の謙虚な人柄を伝えています。'
WHERE heritage_id = 'ef615eeb-b4ba-436a-b688-9b94a171b8ed' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Nghĩa trang Bình An',
    address = 'Nghĩa trang Bình An, Bình Dương',
    description = 'Nghĩa trang Bình An, trước đây là Nghĩa trang Quân đội Biên Hòa, tọa lạc trên đồi Dĩ An thuộc tỉnh Bình Dương. Nơi đây là công trình tưởng niệm lịch sử ghi dấu những mất mát của người lính trong chiến tranh, lưu giữ bức tượng đài Tiếc Thương nổi tiếng một thời và mang ý nghĩa hòa giải, khép lại quá khứ đau thương.'
WHERE heritage_id = 'a2e7d491-30e0-455b-a3b7-254faf2f2149' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Nghĩa trang Bình An',
    address = 'Nghĩa trang Bình An, Bình Dương',
    description = 'Binh An Cemetery, historically known as Bien Hoa Military Cemetery, occupies a quiet hill in Di An, Binh Duong Province. Standing as a solemn historical resting place commemorating soldiers who fell during the war, it reflects poignant wartime memories and the ongoing spirit of national reconciliation.'
WHERE heritage_id = 'a2e7d491-30e0-455b-a3b7-254faf2f2149' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ビンアン墓地（旧軍人墓地）',
    address = 'Nghĩa trang Bình An, Bình Dương',
    description = 'ビンアン墓地は、ビンズオン省ジーアンの丘陵地に広がる旧軍人墓地です。ベトナム戦争で命を落とした兵士たちが眠る歴史的な慰霊の場であり、悲劇的な戦争の記憶を静かに留め、民族の和解と平和を祈念する重要な記念地となっています。'
WHERE heritage_id = 'a2e7d491-30e0-455b-a3b7-254faf2f2149' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Ngôi nhà Đức (Deutsches Haus)',
    address = 'Ngôi nhà Đức (Deutsches Haus), TP. Hồ Chí Minh',
    description = 'Ngôi nhà Đức tọa lạc tại góc đường Lê Duẩn, Quận 1, là tòa cao ốc văn phòng hạng A+ tiên phong đạt tiêu chuẩn công trình xanh LEED Platinum kép danh giá. Với mặt dựng kính hai lớp cách nhiệt hiện đại phản chiếu bầu trời xanh, tòa nhà là biểu tượng kiến trúc bền vững và cầu nối kinh tế - văn hóa hữu nghị giữa Việt Nam và Cộng hòa Liên bang Đức.'
WHERE heritage_id = '04b8b2c8-914a-47c1-bb8a-9a0df69672c1' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Ngôi nhà Đức (Deutsches Haus)',
    address = 'Ngôi nhà Đức (Deutsches Haus), TP. Hồ Chí Minh',
    description = 'Deutsches Haus Ho Chi Minh City on prestigious Le Duan Boulevard is a pioneering commercial development certified with dual LEED Platinum green building ratings. Featuring an innovative double-skin glass curtain wall for energy efficiency, it stands as an architectural beacon of sustainability and German-Vietnamese diplomatic friendship.'
WHERE heritage_id = '04b8b2c8-914a-47c1-bb8a-9a0df69672c1' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ドイツハウス（ドイツ連邦会館）',
    address = 'Ngôi nhà Đức (Deutsches Haus), TP. Hồ Chí Minh',
    description = 'ドイツハウス（ドイチェス・ハウス）は、ホーチミン市1区のレズアン通りに建つ、最高峰の環境性能「LEEDプラチナ認証」を二重取得した超高層エコビルです。最新の二重ガラス構造の外観が美しく、ドイツ総領事館や日欧の多国籍企業が入居するビジネスの拠点となっています。'
WHERE heritage_id = '04b8b2c8-914a-47c1-bb8a-9a0df69672c1' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Nhà hát Lớn Hà Nội',
    address = 'Số 1 Tràng Tiền, Hoàn Kiếm, Hà Nội',
    description = 'Nhà hát Lớn Hà Nội được người Pháp khởi công xây dựng năm 1901 theo nguyên mẫu nhà hát Opéra Garnier tráng lệ tại thủ đô Paris, mang đậm phong cách kiến trúc Tân cổ điển châu Âu. Tòa nhà nổi bật với những cột đá La Mã, mái vòm lợp ngói đá đen và phòng khán giả lộng lẫy, là trung tâm biểu diễn nghệ thuật hàn lâm đỉnh cao của cả nước.'
WHERE heritage_id = '9f7a2381-0e01-456a-bb62-60cb4006af36' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Nhà hát Lớn Hà Nội',
    address = 'Số 1 Tràng Tiền, Hoàn Kiếm, Hà Nội',
    description = 'The Hanoi Opera House was commissioned in 1901, modeled after the opulent Palais Garnier in Paris with French neoclassical grandeur. Characterized by classical Roman pillars, wrought-iron balconies, and an ornate horseshoe auditorium, it remains Vietnam''''s premier venue for symphony concerts and performing arts.'
WHERE heritage_id = '9f7a2381-0e01-456a-bb62-60cb4006af36' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ハノイ市民劇場（ハノイ・オペラハウス）',
    address = 'Số 1 Tràng Tiền, Hoàn Kiếm, Hà Nội',
    description = 'ハノイ市民劇場（オペラハウス）は、パリのオペラ座（ガルニエ宮）を模して1911年に完成したフランス植民地様式の壮麗なネオ・バロック建築です。大理石の階段やクリスタルのシャンデリアが輝く豪奢な劇場ホールでは、現在も国内外の一流のコンサートや演劇が上演されています。'
WHERE heritage_id = '9f7a2381-0e01-456a-bb62-60cb4006af36' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Nhà hát Thành phố Hồ Chí Minh',
    address = '07 Công Trường Lam Sơn, Bến Nghé, Quận 1, TP. Hồ Chí Minh',
    description = 'Nhà hát Thành phố tọa lạc tại trung tâm quảng trường Công trường Lam Sơn, Quận 1, được kiến trúc sư Eugène Ferret khánh thành năm 1900 theo phong cách Tân cổ điển Pháp lãng mạn. Với mặt tiền chạm khắc phù điêu nữ thần nghệ thuật lộng lẫy và khán phòng 500 chỗ ngồi sang trọng, đây là nơi diễn ra các chương trình hòa nhạc giao hưởng, múa ballet và vở diễn nghệ thuật À Ố Show trứ danh.'
WHERE heritage_id = '174598ac-01fc-4bc1-8644-060e3a6f8bbb' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Nhà hát Thành phố Hồ Chí Minh',
    address = '07 Công Trường Lam Sơn, Bến Nghé, Quận 1, TP. Hồ Chí Minh',
    description = 'The Municipal Theatre of Ho Chi Minh City, popularly known as Saigon Opera House, was inaugurated in 1900 on Lam Son Square, designed by French architect Eugene Ferret in flamboyant Belle Epoque styling. Adorned with ornate angelic statues and stone reliefs, it stages premier symphony concerts and the acclaimed ''''A O Show'''' circus performances.'
WHERE heritage_id = '174598ac-01fc-4bc1-8644-060e3a6f8bbb' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ホーチミン市民劇場（サイゴン・オペラハウス）',
    address = '07 Công Trường Lam Sơn, Bến Nghé, Quận 1, TP. Hồ Chí Minh',
    description = 'ホーチミン市民劇場（サイゴン・オペラハウス）は、1900年に落成したドンコイ通りの中心に位置するフランス・ベル・エポック様式の優美な劇場です。華麗な彫刻が施されたファサードと豪奢なドーム天井の下で、オーケストラ公演や世界的に有名な竹のサーカス「アオ・ショー」が上演されています。'
WHERE heritage_id = '174598ac-01fc-4bc1-8644-060e3a6f8bbb' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Nhà máy Thủy điện Hòa Bình',
    address = 'Nhà máy Thủy điện Hòa Bình, Hòa Bình',
    description = 'Thủy điện Hòa Bình trên sông Đà từng là công trình thủy điện lớn nhất Đông Nam Á của thế kỷ XX, được xây dựng với sự hỗ trợ chí tình của các chuyên gia Liên Xô. Đập ngăn sông khổng lồ không chỉ cung cấp nguồn điện năng dồi dào cho đất nước mà còn là công trình chế ngự lũ lụt lịch sử cho toàn vùng đồng bằng Bắc Bộ.'
WHERE heritage_id = '94af7c01-f4b8-4c30-920e-b9c3d1b2239d' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Nhà máy Thủy điện Hòa Bình',
    address = 'Nhà máy Thủy điện Hòa Bình, Hòa Bình',
    description = 'Hoa Binh Dam on the Da River was Southeast Asia''''s largest hydroelectric facility in the 20th century, engineered in close partnership with Soviet specialists. The massive rock-fill dam not only generates vital electrical power for the nation but also provides essential flood control for the entire Red River Delta.'
WHERE heritage_id = '94af7c01-f4b8-4c30-920e-b9c3d1b2239d' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ホアビン水力発電所',
    address = 'Nhà máy Thủy điện Hòa Bình, Hòa Bình',
    description = 'ホアビン水力発電所は、ダー川（黒水河）を堰き止めて建設された20世紀東南アジア最大の水力発電用ロックフィルダムです。旧ソ連の技術支援によって建設され、ベトナム北部の電力供給と紅河デルタの治水・洪水防止に計り知れない貢献を果たしています。'
WHERE heritage_id = '94af7c01-f4b8-4c30-920e-b9c3d1b2239d' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Nhà máy Thủy điện Sơn La',
    address = 'Nhà máy Thủy điện Sơn La, Sơn La',
    description = 'Thủy điện Sơn La nằm trên dòng sông Đà thuộc huyện Mường La, là công trình thủy điện lớn nhất Đông Nam Á với công suất thiết kế 2.400 MW hoàn toàn do các kỹ sư Việt Nam làm tổng thầu thiết kế và thi công. Đập bê tông trọng lực đồ sộ đứng sừng sững giữa núi rừng Tây Bắc là kỳ tích vẻ vang của ngành năng lượng và trí tuệ Việt Nam.'
WHERE heritage_id = '486eb734-cf34-40bc-909c-dcd3ac535e0e' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Nhà máy Thủy điện Sơn La',
    address = 'Nhà máy Thủy điện Sơn La, Sơn La',
    description = 'Son La Dam on the roaring Da River in Muong La District is Southeast Asia''''s largest hydroelectric plant, boasting a monumental generating capacity of 2,400 MW engineered and managed by Vietnamese builders. The colossal roller-compacted concrete dam stands as a proud milestone of modern engineering amidst northwestern peaks.'
WHERE heritage_id = '486eb734-cf34-40bc-909c-dcd3ac535e0e' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ソンラ水力発電所',
    address = 'Nhà máy Thủy điện Sơn La, Sơn La',
    description = 'ソンラ水力発電所は、ソンラ省ムオンラ県のダー川に建設された発電容量2,400MWを誇る東南アジア最大の水力発電所です。ベトナムの技術陣が自らの手で完成させた重力式コンクリートダムであり、山岳地帯にそびえる巨大インフラの壮観な姿は圧巻です。'
WHERE heritage_id = '486eb734-cf34-40bc-909c-dcd3ac535e0e' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Nhà thờ Chính Tòa Long Xuyên',
    address = 'Nhà thờ Chính Tòa Long Xuyên, An Giang',
    description = 'Nhà thờ Chính Tòa Long Xuyên tọa lạc bên bờ rạch Long Xuyên, tỉnh An Giang, là công trình thánh đường Công giáo bề thế khánh thành năm 1973 theo lối kiến trúc hiện đại độc đáo. Tháp chuông cao 55 mét thanh thoát vươn lên giữa bầu trời miền Tây cùng những mảng tranh tường kính màu rực rỡ tạo nên vẻ đẹp tôn nghiêm và thanh tịnh.'
WHERE heritage_id = 'eee0b116-66f6-4a5d-aa3b-07a62697d7ee' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Nhà thờ Chính Tòa Long Xuyên',
    address = 'Nhà thờ Chính Tòa Long Xuyên, An Giang',
    description = 'Long Xuyen Cathedral, dedicated to Queen of Peace, stands proudly along the Long Xuyen Canal in An Giang, consecrated in 1973 with distinct modernist architectural lines. Its slender 55-meter bell tower piercing the southwestern skies and luminous interior stained-glass art make it a prominent religious landmark of the western delta.'
WHERE heritage_id = 'eee0b116-66f6-4a5d-aa3b-07a62697d7ee' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ロングスエン司教座大聖堂',
    address = 'Nhà thờ Chính Tòa Long Xuyên, An Giang',
    description = 'ロングスエン司教座大聖堂（平和の元后大聖堂）は、アンザン省ロングスエン市の運河沿いに1973年に献堂されたモダンな教会建築です。高さ55メートルのスレンダーな鐘楼がメコンデルタの青空にすっきりとそびえ、内部には美しいステンドグラスの光が差し込みます。'
WHERE heritage_id = 'eee0b116-66f6-4a5d-aa3b-07a62697d7ee' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Nhà thờ Con Gà Đà Lạt (Nhà thờ Chính Tòa)',
    address = '15 Trần Phú, Phường 3, Đà Lạt, Lâm Đồng',
    description = 'Nhà thờ Con Gà là công trình kiến trúc tôn giáo tiêu biểu của Đà Lạt được xây dựng từ thời Pháp thuộc theo phong cách Romanesque cổ điển. Đỉnh tháp chuông cao 47 mét nổi bật với bức tượng con gà bằng đồng quay theo hướng gió, mở ra tầm nhìn bao quát toàn thành phố sương mù.'
WHERE heritage_id = '7b8a79e1-4264-4051-99f5-77ecbe406c85' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Nhà thờ Con Gà Đà Lạt (Nhà thờ Chính Tòa)',
    address = '15 Trần Phú, Phường 3, Đà Lạt, Lâm Đồng',
    description = 'St. Nicholas Cathedral, fondly known as the Rooster Church, is an iconic Romanesque religious landmark built during the French colonial era in Da Lat. Its 47-meter bell tower features a distinctive bronze rooster weather vane, offering sweeping vistas of the misty hill station.'
WHERE heritage_id = '7b8a79e1-4264-4051-99f5-77ecbe406c85' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ダラット司教座聖堂（ニワトリ教会）',
    address = '15 Trần Phú, Phường 3, Đà Lạt, Lâm Đồng',
    description = 'ダラット司教座聖堂（通称ニワトリ教会）は、フランス統治時代にロマネスク様式で建設されたダラットの象徴的な教会です。高さ47メートルの鐘楼の頂上には風向計を兼ねたブロンズの雄鶏像が立ち、市内を見渡すランドマークとなっています。'
WHERE heritage_id = '7b8a79e1-4264-4051-99f5-77ecbe406c85' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Nhà thờ đá Phát Diệm',
    address = 'Thị trấn Phát Diệm, Kim Sơn, Ninh Bình',
    description = 'Nhà thờ đá Phát Diệm tại huyện Kim Sơn, Ninh Bình, là kiệt tác kiến trúc Công giáo độc nhất vô nhị do linh mục Phêrô Trần Lục chủ trì xây dựng suốt 24 năm từ thế kỷ XIX. Toàn bộ quần thể kết hợp tài tình giữa kiến trúc đình chùa truyền thống phương Đông với nghệ thuật thánh đường phương Tây hoàn toàn bằng đá và gỗ lim nguyên khối.'
WHERE heritage_id = 'ce0bb861-f6bc-4dbc-9d7a-f2e158470236' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Nhà thờ đá Phát Diệm',
    address = 'Thị trấn Phát Diệm, Kim Sơn, Ninh Bình',
    description = 'Phat Diem Stone Cathedral in Kim Son, Ninh Binh, is an architectural marvel built over 24 years in the late 19th century under the guidance of Father Tran Luc. Crafted entirely from massive stone and ironwood timbers, it ingeniously integrates Vietnamese pagoda rooflines and lotus carvings with Catholic ecclesiastical forms.'
WHERE heritage_id = 'ce0bb861-f6bc-4dbc-9d7a-f2e158470236' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ファットジエム石造大聖堂',
    address = 'Thị trấn Phát Diệm, Kim Sơn, Ninh Bình',
    description = 'ファットジエム石造大聖堂は、ニンビン省キムソンに19世紀末、24年の歳月をかけて建立された世界でも稀に見る石と木造のカトリック建築群です。ヨーロッパの教会建築にベトナム伝統の寺院や瓦屋根の意匠が完璧に融合しており、東西文化の調和の奇跡と称えられます。'
WHERE heritage_id = 'ce0bb861-f6bc-4dbc-9d7a-f2e158470236' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Nhà thờ Domaine de Marie (Nhà thờ Mai Anh)',
    address = '01 Ngô Quyền, Phường 6, Đà Lạt, Lâm Đồng',
    description = 'Nhà thờ Domaine de Marie tọa lạc trên đồi Mai Anh rợp bóng tùng sam, nổi bật với sắc hồng đất ấm áp và mái nhọn gợi nhớ kiến trúc nhà rông Tây Nguyên kết hợp phong cách Gothic Pháp. Bên trong khuôn viên là vườn hoa rực rỡ và khu trưng bày tranh thêu tay tinh xảo.'
WHERE heritage_id = 'a573bbf5-9cc3-415d-a69e-87089bf03d23' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Nhà thờ Domaine de Marie (Nhà thờ Mai Anh)',
    address = '01 Ngô Quyền, Phường 6, Đà Lạt, Lâm Đồng',
    description = 'Perched on Mai Anh Hill, Domaine de Marie Church stands out with its warm terracotta-pink facade, blending 17th-century French architecture with the high roofs of ethnic communal longhouses. The leafy grounds house colorful gardens and intricate hand-embroidered art.'
WHERE heritage_id = 'a573bbf5-9cc3-415d-a69e-87089bf03d23' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ドメーヌ・ド・マリー教会（マイアイン教会）',
    address = '01 Ngô Quyền, Phường 6, Đà Lạt, Lâm Đồng',
    description = 'マイアインの丘に建つドメーヌ・ド・マリー教会は、温かみのあるピンク色の外壁が特徴的なカトリック教会です。17世紀のフランス建築様式に中部高原の先住民族の高床式屋根の意匠が融合しており、美しい庭園が併設されています。'
WHERE heritage_id = 'a573bbf5-9cc3-415d-a69e-87089bf03d23' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Nhà Thờ Đức Bà Huế',
    address = '1 Đường Trần Hưng Đạo, Phường 1, Quận 1, Huế, Thừa Thiên-Huế',
    description = 'Nhà Thờ Đức Bà Huế, còn gọi là Nhà thờ Đức Bà Huế, là một công trình kiến trúc Gothic được xây dựng từ năm 1900-1904 dưới thời Đế quốc Pháp. Nằm ngay trung tâm thành phố Huế, nó là biểu tượng của sự giao thoa văn hóa, tín ngưỡng và lịch sử giữa dân tộc Việt Nam và người Pháp. Kiến trúc của nhà thờ với những cột sông, cửa sổ kính màu và mái vòm cao đã tạo nên một không gian linh thiêng, thu hút du khách và tín đồ. Ngoài ra, nhà thờ còn là nơi lưu giữ nhiều tác phẩm nghệ thuật, tượng trưng cho sự hòa nhập và đa dạng văn hoá của vùng đất Huế.'
WHERE heritage_id = '06a84594-a3b9-44af-b7d0-317c37404dc8' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'St. Joseph''s Cathedral (Nhà Thờ Đức Bà Huế)',
    address = '1 Đường Trần Hưng Đạo, Phường 1, Quận 1, Huế, Thừa Thiên-Huế',
    description = 'Nhà Thờ Đức Bà Huế is an esteemed cultural and scenic landmark located in Thua Thien Hue, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = '06a84594-a3b9-44af-b7d0-317c37404dc8' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'フエ聖母マリア教会 (ノートルダム教会)',
    address = '1 Đường Trần Hưng Đạo, Phường 1, Quận 1, Huế, Thừa Thiên-Huế',
    description = 'Nhà Thờ Đức Bà Huếは、ベトナムトゥアティエン・フエに位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = '06a84594-a3b9-44af-b7d0-317c37404dc8' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Nhà thờ Đức Bà Sài Gòn',
    address = '01 Công xã Paris, Bến Nghé, Quận 1, TP. Hồ Chí Minh',
    description = 'Vương cung thánh đường Đức Bà Sài Gòn khánh thành năm 1880 tại quảng trường Công xã Paris, là kiệt tác kiến trúc Gothic kết hợp Romanesque tuyệt mỹ với toàn bộ gạch ngói và kính màu đều được vận chuyển trực tiếp từ Marseille và Toulouse nước Pháp. Hai tháp chuông vươn cao 60,5 mét cùng tượng Đức Mẹ Hòa Bình bằng đá cẩm thạch trắng là trái tim biểu tượng của thành phố hơn 300 năm tuổi.'
WHERE heritage_id = '488790f5-7f27-43d7-898f-08929e7a1ca4' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Nhà thờ Đức Bà Sài Gòn',
    address = '01 Công xã Paris, Bến Nghé, Quận 1, TP. Hồ Chí Minh',
    description = 'Notre-Dame Cathedral Basilica of Saigon was consecrated in 1880 on Paris Commune Square, built from red bricks and stained-glass fixtures shipped entirely from Marseille and Toulouse. With its soaring 60.5-meter twin spires and the white Carrara marble statue of Our Lady of Peace, it stands as the timeless beating heart of Ho Chi Minh City.'
WHERE heritage_id = '488790f5-7f27-43d7-898f-08929e7a1ca4' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'サイゴン大聖堂（聖母マリア大聖堂）',
    address = '01 Công xã Paris, Bến Nghé, Quận 1, TP. Hồ Chí Minh',
    description = 'サイゴン大聖堂（聖母マリア教会）は、1880年に献堂されたフランス・ネオロマネスク様式の赤レンガ造りの大聖堂です。資材はすべてフランスから運ばれ、60.5メートルの高さを誇る二つの尖塔と広場に立つ白大理石の平和の聖母マリア像が、サイゴンの気品あるランドマークとなっています。'
WHERE heritage_id = '488790f5-7f27-43d7-898f-08929e7a1ca4' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Nhà thờ Lớn Hà Nội',
    address = '40 Nhà Chung, Hàng Trống, Hoàn Kiếm, Hà Nội',
    description = 'Nhà thờ Lớn Hà Nội khánh thành vào dịp Giáng sinh năm 1887 trên phố Nhà Thờ, là ngôi thánh đường Công giáo cổ kính nhất thủ đô mang đậm phong cách kiến trúc Gothic châu Âu mô phỏng Nhà thờ Đức Bà Paris. Bức tường rêu phong cổ kính cùng tháp chuông đôi cao 31 mét là điểm hẹn văn hóa và biểu tượng nhiếp ảnh quen thuộc của du khách khi đến Hà Nội.'
WHERE heritage_id = '9f136a9e-baa9-4d5f-95bd-f43f36b0601e' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Nhà thờ Lớn Hà Nội',
    address = '40 Nhà Chung, Hàng Trống, Hoàn Kiếm, Hà Nội',
    description = 'St. Joseph''''s Cathedral was consecrated on Christmas in 1887, standing as Hanoi''''s oldest Catholic church designed in French neo-Gothic grandeur reminiscent of Notre-Dame de Paris. Its weathered exterior walls, stained-glass rose windows, and twin 31-meter square towers make it an enduring romantic heart of the Old Quarter.'
WHERE heritage_id = '9f136a9e-baa9-4d5f-95bd-f43f36b0601e' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ハノイ大聖堂（聖ヨセフ大聖堂）',
    address = '40 Nhà Chung, Hàng Trống, Hoàn Kiếm, Hà Nội',
    description = 'ハノイ大聖堂（聖ヨセフ大聖堂）は、パリのノートルダム大聖堂を手本として1887年のクリスマスに献堂されたハノイ最古のカトリック教会です。歴史を刻んだ重厚なネオゴシックの双塔と美しいステンドグラスが広場に面して立ち、カフェが並ぶ周辺は若者や観光客で賑わいます。'
WHERE heritage_id = '9f136a9e-baa9-4d5f-95bd-f43f36b0601e' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Nhà thờ Tân Định (Nhà thờ Màu Hồng)',
    address = '289 Hai Bà Trưng, Phường 8, Quận 3, TP. Hồ Chí Minh',
    description = 'Nhà thờ Tân Định tọa lạc trên đường Hai Bà Trưng, Quận 3, được khánh thành năm 1876, là một trong những công trình tôn giáo cổ xưa và nổi tiếng nhất Sài Gòn với sắc hồng ngọt ngào độc nhất vô nhị. Kiến trúc thánh đường kết hợp hài hòa giữa phong cách Gothic thanh thoát với hoa văn vòm cuốn Romanesque và tháp chuông chính cao 52,6 mét kiều diễm.'
WHERE heritage_id = '1fb109b8-19c8-40d1-97ca-3d4c35f58b91' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Nhà thờ Tân Định (Nhà thờ Màu Hồng)',
    address = '289 Hai Bà Trưng, Phường 8, Quận 3, TP. Hồ Chí Minh',
    description = 'Tan Dinh Church on Hai Ba Trung Street in District 3 was consecrated in 1876, famed globally as Saigon''''s enchanting ''''Pink Church'''' with its pastel terracotta facade. Blending neo-Gothic arches, Romanesque details, and an ornate 52.6-meter clock tower, it stands as one of the most recognizable and photographic monuments in the metropolis.'
WHERE heritage_id = '1fb109b8-19c8-40d1-97ca-3d4c35f58b91' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'タンディン教会（ピンクの教会）',
    address = '289 Hai Bà Trưng, Phường 8, Quận 3, TP. Hồ Chí Minh',
    description = 'タンディン教会（通称ピンクの教会）は、ホーチミン市3区ハイバーチュン通りに1876年に完成した、まるでおとぎ話の城のような愛らしいパステルピンクの教会です。ゴシック様式とロマネスク様式が融合した高さ52.6メートルの尖塔を持ち、世界中の旅行者が訪れる屈指のフォトジェニックスポットです。'
WHERE heritage_id = '1fb109b8-19c8-40d1-97ca-3d4c35f58b91' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Nhà thờ Thánh Tâm Nha Trang',
    address = 'Số 2/3, Đường 2/3, Phường Phước Hải, Thành phố Nha Trang, Khánh Hòa, Việt Nam',
    description = 'Nhà thờ Thánh Tâm Nha Trang, còn gọi là Nhà thờ Thánh Tâm, là một công trình kiến trúc tôn giáo tiêu biểu của thời kỳ thực dân Pháp tại miền Trung Việt Nam. Được khánh thành vào năm 1913, nhà thờ mang phong cách Gothic pha trộn các yếu tố kiến trúc Romanesque, với tháp chuông cao vươn lên, cửa sổ kính màu rực rỡ và các họa tiết chạm khắc tinh xảo. Vật liệu chủ yếu là gạch và đá, kết hợp cùng các chi tiết bằng sắt rèn, phản ánh sự giao thoa giữa nghệ thuật châu Âu và điều kiện địa phương. Nhà thờ không chỉ là nơi sinh hoạt tôn giáo của cộng đồng Công giáo Nha Trang mà còn là chứng nhân lịch sử cho quá trình truyền bá đạo Thiên Chúa và ảnh hưởng văn hoá Pháp tại Việt Nam. Hiện nay, công trình được bảo tồn và mở cửa tham quan, là điểm dừng chân quan trọng cho du khách muốn khám phá di sản kiến trúc và lịch sử tôn giáo của khu vực.'
WHERE heritage_id = '40647a6f-7dd0-4256-b8d9-c1de613e4eb6' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'St. Mary''s Cathedral, Nha Trang (Nhà thờ Thánh Tâm)',
    address = 'Số 2/3, Đường 2/3, Phường Phước Hải, Thành phố Nha Trang, Khánh Hòa, Việt Nam',
    description = 'Nhà thờ Thánh Tâm Nha Trang is an esteemed cultural and scenic landmark located in Khanh Hoa, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = '40647a6f-7dd0-4256-b8d9-c1de613e4eb6' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ニャチャン聖心教会',
    address = 'Số 2/3, Đường 2/3, Phường Phước Hải, Thành phố Nha Trang, Khánh Hòa, Việt Nam',
    description = 'Nhà thờ Thánh Tâm Nha Trangは、ベトナムカインホアに位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = '40647a6f-7dd0-4256-b8d9-c1de613e4eb6' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Nhà tù Côn Đảo',
    address = 'Đường Nguyễn Huệ, Côn Đảo, Bà Rịa - Vũng Tàu',
    description = 'Nhà tù Côn Đảo do thực dân Pháp và chính quyền Sài Gòn xây dựng suốt hơn 100 năm, được mệnh danh là ''''địa ngục trần gian'''' giam giữ và tra tấn dã man hàng vạn tù nhân chính trị yêu nước. Hệ thống ''''chuồng cọp'''' kiên cố ngột ngạt cùng Nghĩa trang Hàng Dương linh thiêng là bản anh hùng ca bất diệt về lòng kiên trung bất khuất của dân tộc Việt Nam.'
WHERE heritage_id = '3be77c59-fa87-4fa3-862f-05e98791984e' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Nhà tù Côn Đảo',
    address = 'Đường Nguyễn Huệ, Côn Đảo, Bà Rịa - Vũng Tàu',
    description = 'Con Dao Prison was operated for over a century by colonial and wartime authorities, notorious as ''''hell on Earth'''' where tens of thousands of freedom fighters suffered horrific torture. The infamous claustrophobic ''''tiger cages'''' and the sacred Hang Duong Cemetery stand as enduring testaments to the indomitable courage of patriotic heroes.'
WHERE heritage_id = '3be77c59-fa87-4fa3-862f-05e98791984e' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'コンダオ刑務所跡（虎の檻）',
    address = 'Đường Nguyễn Huệ, Côn Đảo, Bà Rịa - Vũng Tàu',
    description = 'コンダオ刑務所跡は、フランス植民地政府および南ベトナム政権が100年以上にわたり愛国志士や政治犯を収容した悪名高い刑務所です。光を奪い非人道的な拷問が行われた「虎の檻（タイガーケージ）」の遺構は、過酷な歴史の真実を今に伝えています。'
WHERE heritage_id = '3be77c59-fa87-4fa3-862f-05e98791984e' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Nhà Vườn Huế',
    address = 'Số 1, Đường Lê Lợi, Phường Phú Hội, Thành phố Huế, Thừa Thiên Huế',
    description = 'Nhà Vườn Huế là một công trình kiến trúc truyền thống đặc trưng của thành phố Huế, được xây dựng vào cuối thế kỷ XIX dưới thời vua Thành Thái. Toàn bộ ngôi nhà được bố trí hài hòa giữa không gian sống và khu vườn, phản ánh triết lý sống gần gũi với thiên nhiên của người dân Huế. Kiến trúc ngôi nhà mang đậm nét phong cách cung đình Huế với mái ngói âm dương, cột gỗ chạm khắc tinh xảo và các cửa sổ mở ra những góc vườn xanh mát, nơi trồng các loại cây cảnh, cây ăn quả và hoa lá truyền thống. Nội thất được bài trí theo phong cách cổ điển, kết hợp các vật dụng gốm sứ, tranh thêu và đồ gỗ quý, tạo nên một không gian thanh bình, yên tĩnh. Nhà Vườn Huế không chỉ là di sản kiến trúc mà còn là biểu tượng của lối sống tinh tế, tôn trọng thiên nhiên và bảo tồn giá trị văn hoá của người Huế.'
WHERE heritage_id = '1d30dd8e-fd66-42f0-ab06-376b177e29d3' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Hue Garden House (Nhà Vườn Huế)',
    address = 'Số 1, Đường Lê Lợi, Phường Phú Hội, Thành phố Huế, Thừa Thiên Huế',
    description = 'Nhà Vườn Huế is an esteemed cultural and scenic landmark located in Thua Thien Hue, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = '1d30dd8e-fd66-42f0-ab06-376b177e29d3' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'フエ伝統庭園住宅 (ニャーヴオン)',
    address = 'Số 1, Đường Lê Lợi, Phường Phú Hội, Thành phố Huế, Thừa Thiên Huế',
    description = 'Nhà Vườn Huếは、ベトナムトゥアティエン・フエに位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = '1d30dd8e-fd66-42f0-ab06-376b177e29d3' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Núi Bà Đen',
    address = 'Thạnh Tân, Thành phố Tây Ninh, Tây Ninh',
    description = 'Núi Bà Đen được mệnh danh là ''''Nóc nhà Nam Bộ'''' với độ cao 986 mét sừng sững giữa đồng bằng bạt ngàn của tỉnh Tây Ninh. Đỉnh núi là chốn bồng lai mây phủ với đại tượng Phật Bà Tây Bổ Đà Sơn bằng đồng cao kỷ lục 72 mét cùng hệ thống cáp treo hiện đại đưa du khách chiêm bái quần thể chùa Bà linh thiêng.'
WHERE heritage_id = '11bb9125-a589-4651-a34f-65134d7dfd32' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Núi Bà Đen',
    address = 'Thạnh Tân, Thành phố Tây Ninh, Tây Ninh',
    description = 'Black Virgin Mountain (Nui Ba Den) commands the fertile plains of Tay Ninh as the ''''Roof of Southern Vietnam'''', soaring to a proud elevation of 986 meters. The summit has been transformed into a spiritual alpine park crowned by the record-breaking 72-meter bronze statue of Lady Buddha gazing benevolently over the mist-veiled horizon.'
WHERE heritage_id = '11bb9125-a589-4651-a34f-65134d7dfd32' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'バーデン山（黒衣の淑女山）',
    address = 'Thạnh Tân, Thành phố Tây Ninh, Tây Ninh',
    description = 'バーデン山は、タイニン省の平野にそびえ立つ標高986メートルの「南部最高峰」の霊峰です。最新のロープウェイで登れる山頂には、世界記録を持つ高さ72メートルの巨大な青銅製「西補陀山観音菩薩像」が鎮座し、雲海に包まれた神聖な庭園が巡礼者を迎えます。'
WHERE heritage_id = '11bb9125-a589-4651-a34f-65134d7dfd32' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Phố Tây Bùi Viện - Phạm Ngũ Lão',
    address = 'Phố Bùi Viện, Phạm Ngũ Lão, Quận 1, TP. Hồ Chí Minh',
    description = 'Khu phố Tây Bùi Viện - Phạm Ngũ Lão thuộc phường Phạm Ngũ Lão, Quận 1, là tụ điểm vui chơi giải trí đêm sôi động bậc nhất phương Nam dành cho du khách quốc tế. Khi màn đêm buông xuống, con phố đi bộ bùng nổ với âm nhạc rộn ràng từ các quán bar, bia hơi vỉa hè và vô số món ăn đường phố hấp dẫn kéo dài đến tận tờ mờ sáng.'
WHERE heritage_id = 'fdab3324-fc3b-40eb-9c37-96cbb6999919' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Phố Tây Bùi Viện - Phạm Ngũ Lão',
    address = 'Phố Bùi Viện, Phạm Ngũ Lão, Quận 1, TP. Hồ Chí Minh',
    description = 'Bui Vien and Pham Ngu Lao Streets form the vibrant beating heart of Saigon''''s backpacker district in District 1. By nightfall, the pedestrian thoroughfare erupts into an electrifying carnival of neon lights, live music bars, roadside craft beer stools, and tantalizing street food stalls running until dawn.'
WHERE heritage_id = 'fdab3324-fc3b-40eb-9c37-96cbb6999919' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ブイビエン通り（バックパッカー街）',
    address = 'Phố Bùi Viện, Phạm Ngũ Lão, Quận 1, TP. Hồ Chí Minh',
    description = 'ブイビエン通り（ファム・グー・ラオ地区）は、ホーチミン市1区に位置する東南アジア屈指の国際色豊かなバックパッカー街です。夜になると歩行者天国となり、ネオン輝くバーや路上パブから溢れ出る生演奏と、屋台グルメを楽しむ世界中の旅行者で熱気と活気に包まれます。'
WHERE heritage_id = 'fdab3324-fc3b-40eb-9c37-96cbb6999919' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Quần đảo Bà Lụa',
    address = 'Quần đảo Bà Lụa, Kiên Giang',
    description = 'Quần đảo Bà Lụa thuộc vịnh Thái Lan, tỉnh Kiên Giang, được ví như ''''tiểu Hạ Long phương Nam'''' với hơn 40 đảo lớn nhỏ nhấp nhô trên làn nước biển phẳng lặng. Nổi tiếng nhất là nhóm Ba Hòn Đầm với bãi tắm nước nông trong vắt, nơi du khách có thể thỏa thích lội bộ qua lại giữa các đảo nổi và tự tay bắt ốc, sò tươi ngon.'
WHERE heritage_id = 'cb5ac586-2755-49c6-a94c-521910db21ba' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Quần đảo Bà Lụa',
    address = 'Quần đảo Bà Lụa, Kiên Giang',
    description = 'The Ba Lua Archipelago, situated in the Gulf of Thailand off Kien Giang Province, is celebrated as the ''''Miniature Ha Long Bay of the South'''' with over 40 limestone islands. Its most famous cluster, Ba Hon Dam, features crystal-clear shallow waters where visitors can leisurely wade across the sea from one islet to another.'
WHERE heritage_id = 'cb5ac586-2755-49c6-a94c-521910db21ba' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'バールア諸島（南国の小ハロン湾）',
    address = 'Quần đảo Bà Lụa, Kiên Giang',
    description = 'バールア諸島は、キエンザン省のタイランド湾に浮かぶ40以上の島々からなる風光明媚な群島で、「南部の小ハロン湾」と称えられています。特に「バーホンダム」と呼ばれる3つの島の間は遠浅の透き通った海が広がり、島から島へと歩いて渡るユニークな体験が楽しめます。'
WHERE heritage_id = 'cb5ac586-2755-49c6-a94c-521910db21ba' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Quần đảo Côn Đảo',
    address = 'Huyện Côn Đảo, Bà Rịa - Vũng Tàu',
    description = 'Quần đảo Côn Đảo gồm 16 hòn đảo lớn nhỏ nằm giữa biển khơi ngoài khơi Vũng Tàu, từng là ''''địa ngục trần gian'''' thời chiến tranh nhưng nay đã chuyển mình thành thiên đường du lịch sinh thái đẳng cấp. Với những bãi biển hoang sơ nước trong vắt như Đầm Trầu và khu bảo tồn rùa biển đẻ trứng lớn nhất Việt Nam, Côn Đảo là điểm đến kỳ thú tuyệt đỉnh.'
WHERE heritage_id = 'aa4cb4f9-712a-479a-8e5e-4af252a44c67' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Quần đảo Côn Đảo',
    address = 'Huyện Côn Đảo, Bà Rịa - Vũng Tàu',
    description = 'The Con Dao Islands comprise 16 rugged granitic islands off the southern coast, historically notorious as an isolated penal colony but transformed into an eco-paradise today. Fringed by pristine turquoise waters at Dam Trau Beach and home to Southeast Asia''''s foremost green turtle nesting sanctuary, it is an unspoiled tropical haven.'
WHERE heritage_id = 'aa4cb4f9-712a-479a-8e5e-4af252a44c67' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'コンダオ諸島',
    address = 'Huyện Côn Đảo, Bà Rịa - Vũng Tàu',
    description = 'コンダオ諸島は、ブンタウ沖に浮かぶ16の島々からなる自然豊かな群島です。かつて過酷な刑務所が置かれた歴史を持ちつつも、現在は手つかずの白砂のビーチやサンゴ礁、ウミガメの産卵地として世界的なエコリゾート地へと生まれ変わっています。'
WHERE heritage_id = 'aa4cb4f9-712a-479a-8e5e-4af252a44c67' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Quần đảo Hoàng Sa',
    address = 'Huyện đảo Hoàng Sa, Thành phố Đà Nẵng, Việt Nam',
    description = 'Quần đảo Hoàng Sa là một phần lãnh thổ thiêng liêng không thể tách rời của Tổ quốc Việt Nam trên Biển Đông, trực thuộc thành phố Đà Nẵng. Từ các thế kỷ XVII-XIX dưới thời chúa Nguyễn và triều đại nhà Nguyễn, các Đội Hoàng Sa kiêm quản Bắc Hải đã liên tục được cử ra đo đạc hải trình, cắm mốc chủ quyền, thu lượm hải vật và dựng bia khẳng định chủ quyền lãnh thổ lâu đời của dân tộc.'
WHERE heritage_id = 'b3431f84-7623-49fa-919a-04cfab689e54' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Quần đảo Hoàng Sa',
    address = 'Huyện đảo Hoàng Sa, Thành phố Đà Nẵng, Việt Nam',
    description = 'Quần đảo Hoàng Sa is an esteemed cultural and scenic landmark located in Da Nang, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = 'b3431f84-7623-49fa-919a-04cfab689e54' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'パラセル諸島 (ホアンサ諸島)',
    address = 'Huyện đảo Hoàng Sa, Thành phố Đà Nẵng, Việt Nam',
    description = 'Quần đảo Hoàng Saは、ベトナムダナンに位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = 'b3431f84-7623-49fa-919a-04cfab689e54' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Quần đảo Trường Sa',
    address = 'Huyện đảo Trường Sa, Tỉnh Khánh Hòa, Việt Nam',
    description = 'Quần đảo Trường Sa là tiền đồn kiên cường nơi đầu sóng ngọn gió bảo vệ vùng biển trời phía Đông Nam của Tổ quốc. Nơi đây gắn liền với những mốc chủ quyền sừng sững, ngọn hải đăng soi sáng hàng hải quốc tế, ngôi chùa Trường Sa Lớn thanh tịnh và Khu tưởng niệm các anh hùng liệt sĩ Gạc Ma bất tử đã ngã xuống vì sự toàn vẹn lãnh thổ thiêng liêng.'
WHERE heritage_id = 'f38ffb1e-13bc-45b1-9ee5-da1702865358' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Quần đảo Trường Sa',
    address = 'Huyện đảo Trường Sa, Tỉnh Khánh Hòa, Việt Nam',
    description = 'Quần đảo Trường Sa is an esteemed cultural and scenic landmark located in Khanh Hoa, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = 'f38ffb1e-13bc-45b1-9ee5-da1702865358' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'スプラトリー諸島 (チュオンサ諸島)',
    address = 'Huyện đảo Trường Sa, Tỉnh Khánh Hòa, Việt Nam',
    description = 'Quần đảo Trường Saは、ベトナムカインホアに位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = 'f38ffb1e-13bc-45b1-9ee5-da1702865358' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Quần thể Chùa Bái Đính',
    address = 'Xã Gia Sinh, Gia Viễn, Ninh Bình',
    description = 'Chùa Bái Đính là quần thể tâm linh Phật giáo quy mô lớn bậc nhất Đông Nam Á, tọa lạc trên sườn núi đá vôi linh thiêng của vùng đất cố đô Ninh Bình. Ngôi chùa xác lập hàng loạt kỷ lục châu Á với hành lang 500 vị La Hán bằng đá xanh nguyên khối, tượng Phật Thích Ca bằng đồng dát vàng lớn nhất và bảo tháp 13 tầng uy nghi.'
WHERE heritage_id = 'fe533186-23ab-403d-b791-59b3931927d2' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Quần thể Chùa Bái Đính',
    address = 'Xã Gia Sinh, Gia Viễn, Ninh Bình',
    description = 'Bai Dinh Pagoda is Southeast Asia''''s largest Buddhist temple complex, set against the mystical limestone crags of ancient Ninh Binh. The spiritual sanctuary holds numerous regional records, including a 3-kilometer corridor of 500 stone Arhat statues, a colossal bronze Buddha statue, and a soaring 13-story stupa.'
WHERE heritage_id = 'fe533186-23ab-403d-b791-59b3931927d2' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'バイディン寺群',
    address = 'Xã Gia Sinh, Gia Viễn, Ninh Bình',
    description = 'バイディン寺群は、古都ニンビンの山肌に広がる東南アジア最大級の壮大な仏教寺院コンプレックスです。青石で彫られた500体の羅漢像が並ぶ全長約3キロの回廊や、アジア最大級の巨大な黄金釈迦牟尼仏像、高さ100メートルの十三重の仏塔が圧巻の迫力を誇ります。'
WHERE heritage_id = 'fe533186-23ab-403d-b791-59b3931927d2' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Quảng trường Ba Đình',
    address = 'Số 1 Hùng Vương, Ba Đình, Hà Nội',
    description = 'Quảng trường Ba Đình là quảng trường lịch sử lớn nhất Việt Nam, nơi Chủ tịch Hồ Chí Minh đọc bản Tuyên ngôn Độc lập khai sinh ra nước Việt Nam Dân chủ Cộng hòa vào ngày 2 tháng 9 năm 1945. Không gian quảng trường rộng lớn với 168 ô cỏ xanh mướt, hướng thẳng về Lăng Bác và tòa nhà Quốc hội trang nghiêm.'
WHERE heritage_id = 'e0e600dc-fa7e-4b11-a479-7a7b09f161d3' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Quảng trường Ba Đình',
    address = 'Số 1 Hùng Vương, Ba Đình, Hà Nội',
    description = 'Ba Dinh Square is the historic heart of modern Vietnam, where President Ho Chi Minh proclaimed the Declaration of Independence on September 2, 1945, founding the Democratic Republic of Vietnam. Spanning 168 manicured green lawn squares, it faces the grand Ho Chi Minh Mausoleum and the National Assembly building.'
WHERE heritage_id = 'e0e600dc-fa7e-4b11-a479-7a7b09f161d3' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'バーディン広場',
    address = 'Số 1 Hùng Vương, Ba Đình, Hà Nội',
    description = 'バーディン広場は、1945年9月2日にホー・チミン主席が独立宣言を朗読し、ベトナム民主共和国の建国を告げた歴史的な大広場です。市松模様に美しく整えられた168区画の緑の芝生が広がり、正面にはホー・チミン廟や国会議事堂が厳かに建ち並んでいます。'
WHERE heritage_id = 'e0e600dc-fa7e-4b11-a479-7a7b09f161d3' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Sân vận động Chi Lăng',
    address = 'Sân vận động Chi Lăng, Đà Nẵng',
    description = 'Sân vận động Chi Lăng từng là ''''chảo lửa'''' bóng đá huyền thoại gắn liền với những chiến tích vang dội của đội bóng Đà Nẵng và những sự kiện thể thao lớn của miền Trung. Nằm ở vị trí trung tâm thành phố, nơi đây đong đầy ký ức thể thao và đời sống sôi động của bao thế hệ người dân Đà Nẵng.'
WHERE heritage_id = '50e3365f-b62d-4f43-9498-c63bdd5d0e1c' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Sân vận động Chi Lăng',
    address = 'Sân vận động Chi Lăng, Đà Nẵng',
    description = 'Chi Lang Stadium was once the legendary football arena that hosted glorious triumphs of Da Nang''''s local team and major sporting celebrations of Central Vietnam. Located in downtown Da Nang, the venue is etched deeply into the sporting nostalgia and vibrant civic memory of the city.'
WHERE heritage_id = '50e3365f-b62d-4f43-9498-c63bdd5d0e1c' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'チーラン・スタジアム',
    address = 'Sân vận động Chi Lăng, Đà Nẵng',
    description = 'チーラン・スタジアムは、かつてダナンのサッカーチームの黄金期や数々の名勝負の舞台となった歴史あるスタジアムです。ダナン市街中心部に位置し、地元市民の熱狂的な応援とスポーツへの情熱が刻まれたメモリアルな場所です。'
WHERE heritage_id = '50e3365f-b62d-4f43-9498-c63bdd5d0e1c' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Sân vận động Gò Đậu',
    address = 'Sân vận động Gò Đậu, Bình Dương',
    description = 'Sân vận động Gò Đậu tọa lạc tại trung tâm thành phố Thủ Dầu Một, là sân nhà của câu lạc bộ bóng đá danh tiếng Becamex Bình Dương - đội bóng từng 4 lần vô địch V-League. Với sức chứa gần 20.000 khán giả, chảo lửa Gò Đậu là biểu tượng cho sự trỗi dậy mạnh mẽ của phong trào thể thao vùng kinh tế trọng điểm Đông Nam Bộ.'
WHERE heritage_id = 'f3150563-a8dc-492a-88c7-ce04e0fc00ec' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Sân vận động Gò Đậu',
    address = 'Sân vận động Gò Đậu, Bình Dương',
    description = 'Go Dau Stadium in Thu Dau Mot is the venerable home stadium of Becamex Binh Duong FC, one of Vietnamese football''''s most decorated clubs with four V-League titles. Accommodating nearly 20,000 passionate spectators, the venue embodies the surging sporting energy of the southern industrial heartland.'
WHERE heritage_id = 'f3150563-a8dc-492a-88c7-ce04e0fc00ec' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ゴーザウ・スタジアム（ビンズオン）',
    address = 'Sân vận động Gò Đậu, Bình Dương',
    description = 'ゴーザウ・スタジアムは、ビンズオン省トゥーザウモットにある、Vリーグ優勝4回を誇る名門クラブ「ベカメックス・ビンズオン」の本拠地スタジアムです。約2万人を収容し、週末には熱狂的な地元サポーターが集い、南部のサッカー熱を象徴する競技場です。'
WHERE heritage_id = 'f3150563-a8dc-492a-88c7-ce04e0fc00ec' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Sân vận động Hàng Đẫy',
    address = 'Sân vận động Hàng Đẫy, Hà Nội',
    description = 'Sân vận động Hàng Đẫy nằm trên phố Trịnh Hoài Đức, là cái nôi lâu đời của phong trào bóng đá thủ đô và từng là sân nhà của đội tuyển quốc gia Việt Nam suốt nhiều thập kỷ. Khán đài thân thương nơi đây luôn bùng cháy tình yêu thể thao nồng nhiệt của người hâm mộ bóng đá Hà thành qua nhiều thế hệ.'
WHERE heritage_id = '24607de1-f8f4-4662-a31d-d54b869faea4' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Sân vận động Hàng Đẫy',
    address = 'Sân vận động Hàng Đẫy, Hà Nội',
    description = 'Hang Day Stadium on Trinh Hoai Duc Street is the historic cradle of capital football, serving as the home turf for top municipal clubs and historic national team triumphs. Its storied stands have pulsed with the passionate cheers and collective sporting memories of generations of Hanoians.'
WHERE heritage_id = '24607de1-f8f4-4662-a31d-d54b869faea4' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ハンザイ・スタジアム',
    address = 'Sân vận động Hàng Đẫy, Hà Nội',
    description = 'ハンザイ・スタジアムは、ハノイ中心部に位置する半世紀以上の歴史を持つ伝統のサッカースタジアムです。長年にわたりベトナム代表チームや地元クラブの数々の名勝負の舞台となっており、ハノイのスポーツ文化の熱気が凝縮された場所です。'
WHERE heritage_id = '24607de1-f8f4-4662-a31d-d54b869faea4' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Sân vận động Quốc gia Mỹ Đình',
    address = 'Lê Đức Thọ, Mỹ Đình 1, Nam Từ Liêm, Hà Nội',
    description = 'Sân vận động Quốc gia Mỹ Đình khánh thành năm 2003 tại quận Nam Từ Liêm, Hà Nội, là sân vận động hiện đại bậc nhất Việt Nam với sức chứa hơn 40.000 khán giả. Nơi đây là đấu trường chính của các kỳ SEA Games, các giải đấu bóng đá quốc tế danh giá và những đại nhạc hội tầm cỡ thế giới.'
WHERE heritage_id = '2a5dadf0-2d78-4e44-9a6c-e1fe419f66c3' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Sân vận động Quốc gia Mỹ Đình',
    address = 'Lê Đức Thọ, Mỹ Đình 1, Nam Từ Liêm, Hà Nội',
    description = 'My Dinh National Stadium, inaugurated in 2003 in western Hanoi, is Vietnam''''s premier sporting arena boasting a seating capacity of over 40,000 spectators. It serves as the primary home ground for the national football team and hosts major international athletic meets such as the SEA Games.'
WHERE heritage_id = '2a5dadf0-2d78-4e44-9a6c-e1fe419f66c3' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ミーディン国立競技場',
    address = 'Lê Đức Thọ, Mỹ Đình 1, Nam Từ Liêm, Hà Nội',
    description = 'ミーディン国立競技場は、2003年にハノイ西部に開場した4万人以上を収容するベトナム最大の多目的スタジアムです。サッカーベトナム代表の主要なホームスタジアムであり、東南アジア競技大会（SEA Games）や国際的なコンサートの舞台となっています。'
WHERE heritage_id = '2a5dadf0-2d78-4e44-9a6c-e1fe419f66c3' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Sân vận động Thống Nhất',
    address = 'Sân vận động Thống Nhất, TP. Hồ Chí Minh',
    description = 'Sân vận động Thống Nhất nằm trên đường Nguyễn Kim, Quận 10, là thánh địa bóng đá lâu đời và giàu truyền thống bậc nhất phương Nam với lịch sử hình thành từ thập niên 1930 thời Pháp thuộc. Nơi đây từng chứng kiến bao thế hệ danh thủ tài hoa thi đấu và là sân nhà cuồng nhiệt của các câu lạc bộ bóng đá hàng đầu thành phố Hồ Chí Minh.'
WHERE heritage_id = '4b8ef0d9-d8c7-49af-8fdf-1a0a4e83cb85' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Sân vận động Thống Nhất',
    address = 'Sân vận động Thống Nhất, TP. Hồ Chí Minh',
    description = 'Thong Nhat Stadium on Nguyen Kim Street in District 10 is the historic heartland of football in southern Vietnam, with origins tracing back to the 1930s. Having hosted legendary domestic matches and international cup encounters across decades, the iconic arena continues to pulse with the fiery passion of local football enthusiasts.'
WHERE heritage_id = '4b8ef0d9-d8c7-49af-8fdf-1a0a4e83cb85' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'トンニャット・スタジアム（統一競技場）',
    address = 'Sân vận động Thống Nhất, TP. Hồ Chí Minh',
    description = 'トンニャット・スタジアム（統一競技場）は、ホーチミン市10区に位置する1930年代からの歴史を持つ南部サッカーの聖地です。数々の国際試合や国内トップリーグの激戦が繰り広げられた伝統のスタジアムであり、地元ファンの熱狂的な声援が響き渡ります。'
WHERE heritage_id = '4b8ef0d9-d8c7-49af-8fdf-1a0a4e83cb85' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Sông Hương',
    address = 'Sông Hương, thành phố Huế, Thừa Thiên Huế, Việt Nam',
    description = 'Sông Hương, còn gọi là Perfume River, là một trong những con sông quan trọng và biểu tượng của thành phố Huế, Thừa Thiên Huế. Dòng sông bắt nguồn từ dãy Núi Trường Sơn, chảy qua các thung lũng xanh mướt và cuối cùng đổ ra Vịnh Thuận An. Với chiều dài khoảng 80 km, Sông Hương không chỉ tạo nên cảnh quan thiên nhiên thơ mộng, mà còn gắn liền với lịch sử, văn hoá và đời sống của người dân Huế. Hai bên bờ sông hiện diện các di tích kiến trúc cổ kính như Cầu Trường Tiền, Đình Ngọ Môn và các cung điện của triều đại Nguyễn, phản ánh sự hài hòa giữa thiên nhiên và nhân tạo. Sông Hương còn là nguồn cảm hứng cho nhiều tác phẩm thơ ca, âm nhạc và lễ hội truyền thống, được người dân xem là “linh hồn” của cố đô, biểu tượng cho sự bình yên, thanh thản và tinh hoa văn hoá Huế.'
WHERE heritage_id = '2ed02e2a-8131-426e-bfa3-d4d0de3c438b' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Perfume River (Sông Hương)',
    address = 'Sông Hương, thành phố Huế, Thừa Thiên Huế, Việt Nam',
    description = 'Sông Hương is an esteemed cultural and scenic landmark located in Thua Thien Hue, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = '2ed02e2a-8131-426e-bfa3-d4d0de3c438b' AND language_code = 'en';
UPDATE heritage_translations
SET name = '香河 (フォーン川)',
    address = 'Sông Hương, thành phố Huế, Thừa Thiên Huế, Việt Nam',
    description = 'Sông Hươngは、ベトナムトゥアティエン・フエに位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = '2ed02e2a-8131-426e-bfa3-d4d0de3c438b' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Sông Thu Bồn',
    address = 'Sông Thu Bồn, tỉnh Quảng Nam, Việt Nam',
    description = 'Sông Thu Bồn, một trong những con sông quan trọng của miền Trung Việt Nam, chảy qua tỉnh Quảng Nam từ nguồn ở dãy Trường Sơn, qua các huyện Duy Xuyên, Điện Bàn, và cuối cùng đổ ra biển tại Hội An. Với chiều dài khoảng 150 km, sông không chỉ là nguồn nước sinh hoạt, nông nghiệp và công nghiệp mà còn là mạch máu văn hoá, lịch sử của người dân Quảng Nam. Trải dài dọc bờ sông, các làng nghề truyền thống, di tích cổ kính và các khu di sản thế giới như phố cổ Hội An đã hình thành, phát triển nhờ nguồn lợi từ Thu Bồn. Hình ảnh sông Thu Bồn thường được mô tả như biểu tượng của sự gắn bó mật thiết giữa con người và thiên nhiên, là chứng nhân của bao thăng trầm lịch sử, đồng thời là nguồn cảm hứng cho các tác phẩm nghệ thuật, lễ hội và truyền thống địa phương.'
WHERE heritage_id = 'd0751acd-b36f-4e8b-8674-0983d6aaf514' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Thu Bồn River (Sông Thu Bồn)',
    address = 'Sông Thu Bồn, tỉnh Quảng Nam, Việt Nam',
    description = 'Sông Thu Bồn is an esteemed cultural and scenic landmark located in Quang Nam, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = 'd0751acd-b36f-4e8b-8674-0983d6aaf514' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'トゥボン川',
    address = 'Sông Thu Bồn, tỉnh Quảng Nam, Việt Nam',
    description = 'Sông Thu Bồnは、ベトナムクアンナムに位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = 'd0751acd-b36f-4e8b-8674-0983d6aaf514' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Tây An Cổ Tự (Núi Sam, Châu Đốc)',
    address = 'Tây An Cổ Tự (Núi Sam, Châu Đốc), An Giang',
    description = 'Tây An Cổ Tự tọa lạc dưới chân núi Sam, thành phố Châu Đốc, là ngôi danh lam cổ tự do Tổng đốc Doãn Uẩn cho khởi dựng từ năm 1847. Kiến trúc chùa độc nhất vô nhị kết hợp nghệ thuật đền tháp Hồi giáo Ấn Độ với phong cách chùa cổ truyền thống Việt Nam, sở hữu mái vòm hình củ hành độc đáo cùng hơn 11.000 pho tượng Phật gỗ chạm trổ tinh xảo.'
WHERE heritage_id = '640917d8-c66a-4756-ae68-d9c92653c77c' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Tây An Cổ Tự (Núi Sam, Châu Đốc)',
    address = 'Tây An Cổ Tự (Núi Sam, Châu Đốc), An Giang',
    description = 'Tay An Ancient Pagoda rests gracefully at the foot of Sam Mountain in Chau Doc, commissioned in 1847 by Imperial Governor Doan Uan. The spiritual landmark boasts an extraordinary architectural hybrid of Indian Islamic minarets, onion domes, and Vietnamese Buddhist temple styling, housing over 11,000 carved statues.'
WHERE heritage_id = '640917d8-c66a-4756-ae68-d9c92653c77c' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'タイアン古寺（西安古寺・サム山）',
    address = 'Tây An Cổ Tự (Núi Sam, Châu Đốc), An Giang',
    description = 'タイアン古寺（西安古寺）は、アンザン省サム山の麓に1847年に建立された名高い古刹です。インドのイスラム風のオニオンドーム（タマネギ型の屋根）とベトナム伝統の寺院建築が見事に融合した独特の外観を持ち、堂内には1万1千体以上もの精巧な木彫り仏像が安置されています。'
WHERE heritage_id = '640917d8-c66a-4756-ae68-d9c92653c77c' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Thác Bản Giốc',
    address = 'Xã Đàm Thủy, Trùng Khánh, Cao Bằng',
    description = 'Thác Bản Giốc nằm trên dòng sông Quây Sơn thuộc huyện Trùng Khánh, Cao Bằng, là thác nước tự nhiên lớn nhất Đông Nam Á và là một trong bốn thác nước xuyên biên giới kỳ vĩ nhất thế giới. Dòng nước đổ xuống qua nhiều tầng đá vôi tung bọt trắng xóa giữa thung lũng lúa vàng óng và rặng tre xanh ngắt.'
WHERE heritage_id = 'e0e3cb04-0665-4ed1-855f-4bc8a0190ceb' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Thác Bản Giốc',
    address = 'Xã Đàm Thủy, Trùng Khánh, Cao Bằng',
    description = 'Ban Gioc Waterfall, situated along the Quay Son River in Cao Bang, is Southeast Asia''''s largest natural cascade and the world''''s fourth largest border-straddling waterfall. Plunging over multi-tiered limestone terraces into an azure basin, its thunderous white sheets contrast brilliantly against emerald bamboo groves and golden rice terraces.'
WHERE heritage_id = 'e0e3cb04-0665-4ed1-855f-4bc8a0190ceb' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'バンゾック滝',
    address = 'Xã Đàm Thủy, Trùng Khánh, Cao Bằng',
    description = 'バンゾック滝は、カオバン省中越国境のクアイソン川に位置する東南アジア最大の天然名瀑であり、世界で4番目に大きい国境横断滝です。幾重にも連なる石灰岩の段丘からエメラルドグリーンの川面へと豪快に流れ落ちる純白の水煙と、周囲の竹林や田園風景が織りなす絶景は息をのむ美しさです。'
WHERE heritage_id = 'e0e3cb04-0665-4ed1-855f-4bc8a0190ceb' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Thác Bobla (Thác Liên Đầm)',
    address = 'Thác Bobla (Thác Liên Đầm), Lâm Đồng',
    description = 'Thác Bobla, còn gọi là thác Liên Đầm, ẩn mình giữa núi rừng nguyên sơ thuộc huyện Di Linh, Lâm Đồng. Dòng thác trắng xóa đổ từ độ cao hơn 50 mét xuống vực sâu tạo nên khung cảnh thiên nhiên kỳ vĩ và bầu không khí trong lành, hoang sơ của vùng đất cao nguyên.'
WHERE heritage_id = '65086fbb-e1fb-4a0f-83e2-2cd4f491d88b' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Thác Bobla (Thác Liên Đầm)',
    address = 'Thác Bobla (Thác Liên Đầm), Lâm Đồng',
    description = 'Bobla Waterfall, also known as Lien Dam Falls, is hidden within the pristine forests of Di Linh District in Lam Dong. Cascading from a height of over 50 meters into a scenic canyon, it creates a breathtaking highland landscape enveloped by refreshing mist.'
WHERE heritage_id = '65086fbb-e1fb-4a0f-83e2-2cd4f491d88b' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ボブラの滝（リエンダムの滝）',
    address = 'Thác Bobla (Thác Liên Đầm), Lâm Đồng',
    description = 'ボブラの滝（リエンダムの滝）は、ラムドン省ディリン県の原生林に佇む神秘的な名瀑です。50メートル以上の落差から豪快に水しぶきを上げて岩肌を流れ落ち、高原特有の清涼で野趣あふれる景観を作り出しています。'
WHERE heritage_id = '65086fbb-e1fb-4a0f-83e2-2cd4f491d88b' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Thác Datanla',
    address = 'QL20 Đèo Prenn, Phường 3, Đà Lạt, Lâm Đồng',
    description = 'Thác Datanla nằm ven đèo Prenn, sở hữu dòng nước trong vắt len lỏi qua 7 tầng ghềnh đá hoa cương giữa rừng thông bạt ngàn. Du khách đến đây có thể trải nghiệm cảm giác mạnh với hệ thống máng trượt uốn lượn xuyên rừng dài bậc nhất Việt Nam.'
WHERE heritage_id = '487c0718-6060-4f0c-9236-47a61a91b230' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Thác Datanla',
    address = 'QL20 Đèo Prenn, Phường 3, Đà Lạt, Lâm Đồng',
    description = 'Nestled along Prenn Pass, Datanla Waterfall cascades gently through seven granite rock tiers surrounded by lush pine forests. Visitors flock here to enjoy adrenaline-fueled alpine coasters winding gracefully through the highland canopy.'
WHERE heritage_id = '487c0718-6060-4f0c-9236-47a61a91b230' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ダタンラ滝',
    address = 'QL20 Đèo Prenn, Phường 3, Đà Lạt, Lâm Đồng',
    description = 'プレン峠の途中に位置するダタンラ滝は、松林に囲まれた7段の花崗岩の岩肌を清流が流れ落ちる人気の景勝地です。森林の中を爽快に駆け抜ける国内最長級のアルパインコースター（リュージュ）などアクティビティも充実しています。'
WHERE heritage_id = '487c0718-6060-4f0c-9236-47a61a91b230' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Thác Gia Long (Dray Sáp Thượng)',
    address = 'Thác Gia Long (Dray Sáp Thượng), Đắk Nông',
    description = 'Thác Gia Long nằm trên dòng sông Sêrêpôk huyền thoại, mang vẻ đẹp hoang sơ kỳ vĩ với hệ thống hang động bazan đen tuyền và hồ tắm thiên nhiên xanh ngắt. Tương truyền vua Gia Long từng chọn nơi đây làm chốn dừng chân nghỉ ngơi và thưởng ngoạn cảnh sắc đại ngàn.'
WHERE heritage_id = '30099548-b35c-48ca-9b57-36b0279e4598' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Thác Gia Long (Dray Sáp Thượng)',
    address = 'Thác Gia Long (Dray Sáp Thượng), Đắk Nông',
    description = 'Gia Long Falls is an untamed natural wonder along the legendary Serepok River, framed by dramatic black basalt columns and emerald swimming lagoons. Legend holds that Emperor Gia Long once rested by this scenic cascade to admire the virgin highlands.'
WHERE heritage_id = '30099548-b35c-48ca-9b57-36b0279e4598' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ザーロン滝（ドレイサップ・トゥオン滝）',
    address = 'Thác Gia Long (Dray Sáp Thượng), Đắk Nông',
    description = '伝説のセレポック川に位置するザーロン滝は、玄武岩の柱状節理と青く澄んだ天然プールが広がる大自然の名瀑です。かつて阮朝のザーロン（嘉隆）帝が旅の途中に立ち寄ってその雄大さを讃えたと伝えられています。'
WHERE heritage_id = '30099548-b35c-48ca-9b57-36b0279e4598' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Thác Hang Cọp',
    address = 'Thác Hang Cọp, Lâm Đồng',
    description = 'Thác Hang Cọp ẩn mình giữa thung lũng thông rậm rạp thuộc xã Xuân Thọ, Đà Lạt, với dòng nước dội mạnh từ vách đá cao 25 mét xuống hồ sâu. Dưới chân thác có hang đá tự nhiên gắn liền với những truyền thuyết ly kỳ về loài hổ chúa của rừng Tây Nguyên.'
WHERE heritage_id = 'a6db97cd-214b-49d1-8d88-43a2fcd5fbc9' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Thác Hang Cọp',
    address = 'Thác Hang Cọp, Lâm Đồng',
    description = 'Hang Cop Waterfall is tucked inside a dense pine valley in Xuan Tho, plunging 25 meters down steep cliffs into a deep basin. At the waterfall''''s base lies a cavernous natural grotto steeped in local folk legends about the tiger lords of the highlands.'
WHERE heritage_id = 'a6db97cd-214b-49d1-8d88-43a2fcd5fbc9' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ハングコップの滝（虎の洞窟滝）',
    address = 'Thác Hang Cọp, Lâm Đồng',
    description = 'ハングコップの滝（虎の洞窟の滝）は、ダラット東郊の鬱蒼とした松林の谷間に隠れた秘境の滝です。25メートルの断崖から滝壺へ勢いよく水が落下し、かつて虎が棲んでいたとされる洞窟にまつわる伝説が残されています。'
WHERE heritage_id = 'a6db97cd-214b-49d1-8d88-43a2fcd5fbc9' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Thác Pongour',
    address = 'Thác Pongour, Xã Tân Hội, Huyện Đơn Dương, Tỉnh Lâm Đồng, Việt Nam',
    description = 'Thác Pongour, còn được biết đến với tên gọi "Thác Bốn Mùa", nằm trên lưu vực sông Đa Nhim, thuộc xã Tân Hội, huyện Đơn Dương, tỉnh Lâm Đồng. Được hình thành nhờ dòng nước mưa dày đặc của dãy Trường Sơn và địa hình đồi núi đá vôi, thác tạo ra bốn tầng thác rơi xen kẽ, mỗi tầng lại mang một màu sắc và âm thanh riêng, phản ánh rõ nét bốn mùa trong năm. Khí hậu ôn đới nhiệt đới gió mùa của Lâm Đồng, với mưa rải rác quanh năm, giúp thác luôn duy trì dòng chảy mạnh mẽ, tạo nên khung cảnh hùng vĩ và lãng mạn. Thác Pongour không chỉ là điểm du lịch sinh thái mà còn là biểu tượng văn hoá của người dân địa phương, nơi họ tổ chức các lễ hội truyền thống, ca hát và các hoạt động văn nghệ để tôn vinh thiên nhiên và duy trì bản sắc văn hoá vùng cao.'
WHERE heritage_id = '7110e30b-cc7b-422e-9600-1a21565a874b' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Thác Pongour',
    address = 'Thác Pongour, Xã Tân Hội, Huyện Đơn Dương, Tỉnh Lâm Đồng, Việt Nam',
    description = 'Thác Pongour is an esteemed cultural and scenic landmark located in Lam Dong, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = '7110e30b-cc7b-422e-9600-1a21565a874b' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ポンガールの滝',
    address = 'Thác Pongour, Xã Tân Hội, Huyện Đơn Dương, Tỉnh Lâm Đồng, Việt Nam',
    description = 'Thác Pongourは、ベトナムラムドンに位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = '7110e30b-cc7b-422e-9600-1a21565a874b' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Thác Prenn',
    address = 'QL20 Chân đèo Prenn, Phường 3, Đà Lạt, Lâm Đồng',
    description = 'Thác Prenn nằm ngay cửa ngõ tiến vào thành phố Đà Lạt dưới chân đèo Prenn, đổ xuống mềm mại như dải lụa qua một vòm đá tự nhiên. Du khách có thể đi bộ xuyên qua lối mòn đá luồn sau rèm nước đổ và tham gia các hoạt động chèo thuyền, cưỡi voi thú vị.'
WHERE heritage_id = '8cca2cac-4ee0-4c16-a9c7-ba5bdfdd5e84' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Thác Prenn',
    address = 'QL20 Chân đèo Prenn, Phường 3, Đà Lạt, Lâm Đồng',
    description = 'Prenn Waterfall guards the southern gateway to Da Lat, curtaining gracefully over a natural stone archway into a quiet pool. Visitors can walk directly along the rocky path behind the cascading veil and enjoy leisure activities including rafting and cultural exhibitions.'
WHERE heritage_id = '8cca2cac-4ee0-4c16-a9c7-ba5bdfdd5e84' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'プレンの滝',
    address = 'QL20 Chân đèo Prenn, Phường 3, Đà Lạt, Lâm Đồng',
    description = 'プレンの滝は、ダラット市街への南の玄関口であるプレン峠の麓に位置する風光明媚な滝です。緩やかな岩壁から白いカーテンのように流れ落ちる滝の裏側には歩道が整備されており、水しぶきを肌で感じながら滝の裏側を通り抜けることができます。'
WHERE heritage_id = '8cca2cac-4ee0-4c16-a9c7-ba5bdfdd5e84' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Thác Voi (Liêng Rơwoa)',
    address = 'Thị trấn Nam Ban, Lâm Hà, Lâm Đồng',
    description = 'Thác Voi, hay Liêng Rơwoa, là ngọn thác kỳ vĩ bậc nhất Lâm Đồng thuộc thị trấn Nam Ban, đổ từ vách đá cao hơn 30 mét tung bọt trắng xóa như đàn voi khổng lồ. Dưới chân thác là hang Dơi kỳ bí và những tảng đá nhấp nhô rêu phong giữa thảm rừng nhiệt đới đại ngàn.'
WHERE heritage_id = '05c6cecb-1d0c-4d7d-8c4b-b1ccb244385b' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Thác Voi (Liêng Rơwoa)',
    address = 'Thị trấn Nam Ban, Lâm Hà, Lâm Đồng',
    description = 'Elephant Waterfall (Lieng Rowoa) is one of Lam Dong''''s most rugged and impressive cataracts, plunging over 30 meters down craggy basalt bluffs with thunderous power. Deep mossy grottos and massive boulders shaped like crouching elephants await explorers at its misty base.'
WHERE heritage_id = '05c6cecb-1d0c-4d7d-8c4b-b1ccb244385b' AND language_code = 'en';
UPDATE heritage_translations
SET name = '象の滝（エレファント・フォールズ / リエン・ロウォア滝）',
    address = 'Thị trấn Nam Ban, Lâm Hà, Lâm Đồng',
    description = '象の滝（エレファントの滝 / リエン・ロウォア滝）は、ナムバン町にある落差30メートルを超える大迫力の名瀑です。轟音とともに白い水煙を上げて巨岩へと激しく落下する姿は圧巻で、滝壺周辺の苔むした奇岩や洞窟を探検できます。'
WHERE heritage_id = '05c6cecb-1d0c-4d7d-8c4b-b1ccb244385b' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Thánh địa Mỹ Sơn',
    address = 'Xã Duy Phú, Duy Xuyên, Quảng Nam',
    description = 'Thánh địa Mỹ Sơn là quần thể tháp đền Ấn Độ giáo cổ kính ẩn mình giữa thung lũng kín đáo được bao bọc bởi đồi núi linh thiêng tại Quảng Nam. Từng là trung tâm tế lễ của các vương triều Chăm pa từ thế kỷ IV đến thế kỷ XIV, nơi đây được UNESCO vinh danh là Di sản Văn hóa Thế giới với kỹ thuật xây gạch không lộ mạch hồ kỳ bí.'
WHERE heritage_id = 'b954610d-cf26-4ce7-9e4b-7a16606a2534' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Thánh địa Mỹ Sơn',
    address = 'Xã Duy Phú, Duy Xuyên, Quảng Nam',
    description = 'My Son Sanctuary is an ancient Hindu temple complex nestled in a forested valley ringed by sacred mountains in Quang Nam. Serving as the primary religious and burial sanctuary for Champa monarchs from the 4th to 14th centuries, this UNESCO World Heritage site is famed for its mysterious mortar-less brick masonry.'
WHERE heritage_id = 'b954610d-cf26-4ce7-9e4b-7a16606a2534' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ミーソン聖域',
    address = 'Xã Duy Phú, Duy Xuyên, Quảng Nam',
    description = 'ミーソン聖域は、クアンナム省の緑豊かな盆地に佇む古代チャンパ王国のヒンドゥー教聖宮遺跡群です。4世紀から14世紀にかけて歴代国王がシヴァ神に祈りを捧げた聖地であり、漆喰を使わずに積み上げられた謎の赤レンガ建築が世界遺産に登録されています。'
WHERE heritage_id = 'b954610d-cf26-4ce7-9e4b-7a16606a2534' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Thành phố Đà Nẵng',
    address = 'Thành phố Đà Nẵng, Việt Nam',
    description = 'Đà Nẵng, thành phố trực thuộc trung ương miền Trung, là một trong những điểm du lịch hấp dẫn nhất Việt Nam với bờ biển dài, cát trắng mịn và hệ thống hạ tầng hiện đại. Nơi đây hội tụ các danh thắng nổi tiếng như Bán đảo Sơn Trà, Ngũ Hành Sơn, cầu Rồng, cầu Sông Hàn và khu phố cổ Hội An lân cận, phản ánh sự đa dạng văn hoá, lịch sử và tín ngưỡng của vùng. Đà Nẵng còn là trung tâm giao thương, công nghiệp và giáo dục, đồng thời tổ chức nhiều lễ hội truyền thống như Lễ hội Đèn lồng và Lễ hội ẩm thực, góp phần làm phong phú đời sống văn hoá của người dân và du khách.'
WHERE heritage_id = 'f6add28a-73e4-4a6b-985b-61c45f02d04d' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Da Nang',
    address = 'Thành phố Đà Nẵng, Việt Nam',
    description = 'Thành phố Đà Nẵng is an esteemed cultural and scenic landmark located in Da Nang, celebrated for its rich historical heritage and distinctive architectural beauty.'
WHERE heritage_id = 'f6add28a-73e4-4a6b-985b-61c45f02d04d' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ダナン市',
    address = 'Thành phố Đà Nẵng, Việt Nam',
    description = 'Thành phố Đà Nẵngは、ベトナムダナンに位置する名高い遺産であり、豊かな歴史的価値と美しい景観で広く知られています。'
WHERE heritage_id = 'f6add28a-73e4-4a6b-985b-61c45f02d04d' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Thảo Cầm Viên Sài Gòn',
    address = '02 Nguyễn Bỉnh Khiêm, Bến Nghé, Quận 1, TP. Hồ Chí Minh',
    description = 'Thảo Cầm Viên Sài Gòn thành lập năm 1864 bởi nhà thực vật học người Pháp Jean-Baptiste Louis Pierre, là một trong tám vườn thú cổ xưa nhất thế giới còn tồn tại. Ốc đảo sinh thái xanh tươi giữa lòng Quận 1 này bảo tồn hơn 1.000 cá thể động vật quý hiếm cùng hàng nghìn cây cổ thụ trăm tuổi tạo nên không gian thiên nhiên trong lành tuyệt vời.'
WHERE heritage_id = '86734732-eb30-475f-bbac-79e77b693b69' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Thảo Cầm Viên Sài Gòn',
    address = '02 Nguyễn Bỉnh Khiêm, Bến Nghé, Quận 1, TP. Hồ Chí Minh',
    description = 'The Saigon Zoo and Botanical Gardens, founded in 1864 by French botanist Louis Pierre, ranks among the eight oldest surviving zoological gardens in the world. This lush 20-hectare green sanctuary in District 1 protects over 1,000 exotic animals and rare tropical plant collections beneath a canopy of centuries-old heritage trees.'
WHERE heritage_id = '86734732-eb30-475f-bbac-79e77b693b69' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'サイゴン動植物園',
    address = '02 Nguyễn Bỉnh Khiêm, Bến Nghé, Quận 1, TP. Hồ Chí Minh',
    description = 'サイゴン動植物園は、1864年にフランス人植物学者ルイ・ピエールによって創設された、現存する世界最古の動物園の一つ（世界で8番目）です。都心の緑豊かなオアシスとして親しまれ、樹齢100年を超える巨木の下で希少な熱帯動物や熱帯植物のコレクションを観察できます。'
WHERE heritage_id = '86734732-eb30-475f-bbac-79e77b693b69' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Tháp Bà Ponagar',
    address = 'Đường 2 Tháng 4, Vĩnh Phước, Nha Trang, Khánh Hòa',
    description = 'Tháp Bà Ponagar ngự trên ngọn đồi đá hoa cương xanh mát ven sông Cái tại Nha Trang, là quần thể đền tháp Chăm pa cổ kính xây dựng từ thế kỷ VIII đến thế kỷ XIII. Nơi đây thờ nữ thần Thiên Y A Na Thánh Mẫu linh thiêng và là điểm sinh hoạt tín ngưỡng, múa Chăm truyền thống đặc sắc của đồng bào địa phương.'
WHERE heritage_id = '94feba1c-c462-4ee0-83a3-40323c771d82' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Tháp Bà Ponagar',
    address = 'Đường 2 Tháng 4, Vĩnh Phước, Nha Trang, Khánh Hòa',
    description = 'Po Nagar Cham Towers crown a breezy granite knoll beside the Cai River in Nha Trang, constructed between the 8th and 13th centuries. Dedicated to the revered mother goddess Yan Po Nagar, the sacred brick towers host traditional Cham ritual dances and spiritual gatherings.'
WHERE heritage_id = '94feba1c-c462-4ee0-83a3-40323c771d82' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ポー・ナガル・チャム塔',
    address = 'Đường 2 Tháng 4, Vĩnh Phước, Nha Trang, Khánh Hòa',
    description = 'ポー・ナガル塔は、ニャチャンのカイ川河口を望む花崗岩の丘の上に8世紀から13世紀にかけて築かれたチャンパ寺院跡です。国土の母神ヤン・ポー・ナガルを祀り、赤レンガで造られた主塔では現在も伝統的な儀式や華やかなチャムダンスが披露されています。'
WHERE heritage_id = '94feba1c-c462-4ee0-83a3-40323c771d82' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Tháp Chăm Bằng An',
    address = 'Tháp Chăm Bằng An, Quảng Nam',
    description = 'Tháp Chăm Bằng An tọa lạc tại thị xã Điện Bàn, Quảng Nam, là tháp Chăm duy nhất tại Việt Nam có cấu trúc hình bát giác đặc biệt. Xây dựng từ khoảng thế kỷ thứ IX đến X, ngọn tháp cao hơn 21 mét thờ thần Shiva, tượng trưng cho đỉnh cao kỹ thuật nung gạch và nghệ thuật điêu khắc Chăm pa cổ.'
WHERE heritage_id = 'cd377416-cbf9-460b-a4b2-c83d393a83cb' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Tháp Chăm Bằng An',
    address = 'Tháp Chăm Bằng An, Quảng Nam',
    description = 'Bang An Cham Tower, located in Dien Ban, Quang Nam, is the only remaining octagonal Champa tower in Vietnam. Erected between the 9th and 10th centuries and dedicated to Lord Shiva, the 21-meter sanctuary exemplifies the pinnacle of ancient Cham brick firing and sacred architecture.'
WHERE heritage_id = 'cd377416-cbf9-460b-a4b2-c83d393a83cb' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'バンアン・チャム塔',
    address = 'Tháp Chăm Bằng An, Quảng Nam',
    description = 'バンアン・チャム塔は、クアンナム省ディエンバンにあるベトナムで唯一の八角形の平面構造を持つチャンパ遺跡です。9世紀から10世紀にかけてシヴァ神を祀るために建立され、高さ21メートルの赤レンガ造りの塔は古代チャム族の高度な建築技術を今に伝えています。'
WHERE heritage_id = 'cd377416-cbf9-460b-a4b2-c83d393a83cb' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Tháp Chăm Po Sah Inư (Phan Thiết)',
    address = 'Đồi Bà Nài, Phú Hài, Phan Thiết, Bình Thuận',
    description = 'Tháp Chăm Po Sah Inư ngự trên đồi Bà Nài nhìn ra biển Phan Thiết, là cụm tháp cổ thờ thần Shiva theo phong cách kiến trúc Hòa Lai được xây dựng từ cuối thế kỷ thứ VIII. Hàng năm vào tháng 7 Chăm lịch, lễ hội Katê rộn ràng với tiếng kèn Saranai và tiếng trống Paranưng thu hút đông đảo du khách thập phương.'
WHERE heritage_id = '46e45b79-4622-4391-9a9d-f652c73fc5a2' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Tháp Chăm Po Sah Inư (Phan Thiết)',
    address = 'Đồi Bà Nài, Phú Hài, Phan Thiết, Bình Thuận',
    description = 'Po Shanu Cham Towers perch on Ba Nai Hill overlooking the coast of Phan Thiet, built in the late 8th century in the exquisite Hoa Lai architectural tradition. Dedicated to Shiva, the complex comes alive each autumn during the vibrant Kate Festival filled with melodious Saranai horns and traditional dances.'
WHERE heritage_id = '46e45b79-4622-4391-9a9d-f652c73fc5a2' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ポー・シャヌー・チャム塔',
    address = 'Đồi Bà Nài, Phú Hài, Phan Thiết, Bình Thuận',
    description = 'ポー・シャヌー塔は、ファンティエット郊外の小高い丘の上に8世紀末に建てられたホアライ様式の古代チャム塔です。シヴァ神を祀るレンガ造りの塔前では、毎年秋にチャム族最大の伝統祭礼「カテ祭り」が盛大に催されます。'
WHERE heritage_id = '46e45b79-4622-4391-9a9d-f652c73fc5a2' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Tháp Rùa (Hồ Hoàn Kiếm)',
    address = 'Hồ Hoàn Kiếm, Hàng Trống, Hoàn Kiếm, Hà Nội',
    description = 'Tháp Rùa đứng cô liêu mà kiêu hãnh trên gò đất nổi giữa làn nước trong xanh của hồ Hoàn Kiếm, được xây dựng vào cuối thế kỷ XIX với sự giao thoa giữa kiến trúc gô-tích châu Âu và mái cong Á Đông. Ngọn tháp nhỏ bé là linh hồn bất tử của thủ đô, gắn liền với huyền tích Rùa Vàng trả gươm thần gìn giữ nền hòa bình độc lập của non sông.'
WHERE heritage_id = 'e46ce884-5c66-4987-9891-580e803d9801' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Tháp Rùa (Hồ Hoàn Kiếm)',
    address = 'Hồ Hoàn Kiếm, Hàng Trống, Hoàn Kiếm, Hà Nội',
    description = 'Turtle Tower stands serenely atop a tiny islet in the center of Hoan Kiem Lake, constructed in the late 19th century blending French Gothic arches with indigenous pagoda eaves. The solitary stone monument remains the poetic heart of Hanoi, forever linked to the legendary Golden Turtle who reclaimed the divine sword of peace.'
WHERE heritage_id = 'e46ce884-5c66-4987-9891-580e803d9801' AND language_code = 'en';
UPDATE heritage_translations
SET name = '亀の塔（タッパー・ホアンキエム湖）',
    address = 'Hồ Hoàn Kiếm, Hàng Trống, Hoàn Kiếm, Hà Nội',
    description = '亀の塔（タッパー）は、ホアンキエム湖の中央に浮かぶ小島の上にひっそりと佇むハノイの永遠のシンボルです。19世紀末に建てられ、西洋ゴシックとベトナム伝統の建築様式が融合した小さな石塔は、神亀に宝剣を返還した黎利王の伝説を現代に語り継いでいます。'
WHERE heritage_id = 'e46ce884-5c66-4987-9891-580e803d9801' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Thập tự Long Tân',
    address = 'Thập tự Long Tân, Bà Rịa - Vũng Tàu',
    description = 'Thập tự Long Tân tọa lạc giữa cánh rừng cao su bạt ngàn thuộc huyện Đất Đỏ, tỉnh Bà Rịa - Vũng Tàu, là đài tưởng niệm các chiến sĩ thuộc Trung đoàn 6 Quân đội Hoàng gia Úc tử trận trong trận đánh Long Tân năm 1966. Nơi đây là di tích lịch sử chiến trường đặc biệt thu hút đông đảo cựu chiến binh và du khách quốc tế đến thăm để tưởng niệm hòa bình.'
WHERE heritage_id = '85bc378c-c3a8-4142-ade2-402af2c711e7' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Thập tự Long Tân',
    address = 'Thập tự Long Tân, Bà Rịa - Vũng Tàu',
    description = 'The Long Tan Cross sits peacefully within rubber plantations in Dat Do District, Ba Ria - Vung Tau, commemorating the fallen soldiers of the 6th Battalion, Royal Australian Regiment in the pivotal 1966 Battle of Long Tan. As one of the few foreign military monuments preserved in Vietnam, it serves as a solemn site of remembrance and reconciliation.'
WHERE heritage_id = '85bc378c-c3a8-4142-ade2-402af2c711e7' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ロンタン・クロス（オーストラリア軍追悼碑）',
    address = 'Thập tự Long Tân, Bà Rịa - Vũng Tàu',
    description = 'ロンタン・クロスは、バリア・ブンタウ省ダットドーの広大なゴム農園の中にひっそりと立つ白い十字架の慰霊碑です。1966年のベトナム戦争「ロンタンの戦い」で戦死したオーストラリア兵を追悼するために建てられ、現在も多くの豪州退役軍人や平和を願う旅行者が訪れます。'
WHERE heritage_id = '85bc378c-c3a8-4142-ade2-402af2c711e7' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Thế Tổ Miếu (Hoàng thành Huế)',
    address = 'Đại Nội Huế, Thành phố Huế',
    description = 'Thế Tổ Miếu, hay Thế Miếu, là khu đền thờ tôn nghiêm bậc nhất nằm ở góc tây nam Hoàng Thành Huế, được vua Minh Mạng cho xây dựng năm 1821 để thờ cúng các vị hoàng đế triều Nguyễn. Trước sân đền là Cửu Đỉnh đúc bằng đồng tượng trưng cho sự trường tồn vĩnh cửu và bờ cõi non sông đất nước.'
WHERE heritage_id = '6385ca24-79be-4737-8c53-dec887f528cd' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Thế Tổ Miếu (Hoàng thành Huế)',
    address = 'Đại Nội Huế, Thành phố Huế',
    description = 'The Mieu Temple is the premier ancestral temple situated in the southwest corner of Hue''''s Imperial Citadel, commissioned in 1821 by Emperor Minh Mang to venerate Nguyen monarchs. In the front courtyard stand the Nine Dynastic Urns, monumental bronze cauldrons symbolizing national unity and sovereign perpetuity.'
WHERE heritage_id = '6385ca24-79be-4737-8c53-dec887f528cd' AND language_code = 'en';
UPDATE heritage_translations
SET name = '太祖廟（フエ王宮・世祖廟）',
    address = 'Đại Nội Huế, Thành phố Huế',
    description = '太祖廟（世祖廟）は、フエ王宮の南西部に位置し、阮朝の歴代皇帝を合祀するために1821年に建立された最も神聖な祖先祭祀の場です。前庭には国家の安寧と領土の不滅を象徴する巨大な青銅製の「九鼎」が堂々と並んでいます。'
WHERE heritage_id = '6385ca24-79be-4737-8c53-dec887f528cd' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Thiền viện Trúc Lâm Đà Lạt',
    address = 'Đường Trần Thánh Tông, Phường 3, Đà Lạt, Lâm Đồng',
    description = 'Thiền viện Trúc Lâm là thiền viện thuộc dòng Trúc Lâm Yên Tử lớn bậc nhất Việt Nam, tọa lạc trên núi Phụng Hoàng soi bóng xuống hồ Tuyền Lâm phẳng lặng. Không gian thiền môn thanh tịnh giữa ngàn thông reo cùng vườn hoa muôn sắc mang lại cảm giác an yên tuyệt đối cho người hành hương.'
WHERE heritage_id = 'dc9608c0-0f69-4408-b844-edfca764f624' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Thiền viện Trúc Lâm Đà Lạt',
    address = 'Đường Trần Thánh Tông, Phường 3, Đà Lạt, Lâm Đồng',
    description = 'Truc Lam Zen Monastery is one of Vietnam''''s largest sanctuaries of the Truc Lam Yen Tu Buddhist tradition, perched on Phoenix Mountain above calm Tuyen Lam Lake. The tranquil mountain sanctuary is surrounded by serene pine forests and vibrant gardens blooming year-round.'
WHERE heritage_id = 'dc9608c0-0f69-4408-b844-edfca764f624' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'チュックラム禅院（ダラット竹林禅院）',
    address = 'Đường Trần Thánh Tông, Phường 3, Đà Lạt, Lâm Đồng',
    description = 'チュックラム禅院は、フェニックス山頂に位置しトゥエンラム湖を見下ろすベトナム最大級の禅寺です。厳かな伽藍の周囲には手入れされた花園とどこまでも続く松林が広がり、訪れる巡礼者に深い静寂と心の安らぎをもたらします。'
WHERE heritage_id = 'dc9608c0-0f69-4408-b844-edfca764f624' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Thư viện Quốc gia Việt Nam',
    address = 'Thư viện Quốc gia Việt Nam, Hà Nội',
    description = 'Thư viện Quốc gia Việt Nam tọa lạc trên phố Tràng Thi, Hà Nội, được thành lập từ năm 1917 thời Pháp thuộc theo phong cách kiến trúc Đông Dương trang nhã và thanh thoát. Nơi đây là kho tàng tri thức lớn nhất đất nước, lưu trữ hàng triệu tài liệu quý, bản thảo Hán Nôm cổ và các bộ sưu tập sách báo vô giá.'
WHERE heritage_id = '9271f241-8ac1-44a0-ad2a-f9f8fa67c049' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Thư viện Quốc gia Việt Nam',
    address = 'Thư viện Quốc gia Việt Nam, Hà Nội',
    description = 'The National Library of Vietnam, situated on leafy Trang Thi Street in Hanoi, was established in 1917 exhibiting classic Indochine colonial architecture. As the nation''''s foremost repository of literature and historical scholarship, it safeguards millions of volumes alongside rare ancient Nom manuscripts and archival collections.'
WHERE heritage_id = '9271f241-8ac1-44a0-ad2a-f9f8fa67c049' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ベトナム国立図書館',
    address = 'Thư viện Quốc gia Việt Nam, Hà Nội',
    description = 'ベトナム国立図書館は、ハノイのチャンティ通りに1917年創設された、フランス・インドシナ様式の優美な建築美を誇る国立図書館です。ベトナム最大の知識の殿堂として、数百年前の漢字・チュノム古文書から貴重な近代出版物まで数百万冊の資料を保管しています。'
WHERE heritage_id = '9271f241-8ac1-44a0-ad2a-f9f8fa67c049' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Thung Lũng Tình Yêu',
    address = '3 - 5 - 7 Mai Anh Đào, Phường 8, Đà Lạt, Lâm Đồng',
    description = 'Thung Lũng Tình Yêu là thắng cảnh lãng mạn trứ danh của xứ sở ngàn hoa Đà Lạt, nằm ẩn mình bên những sườn đồi thông và hồ Đa Thiện trong xanh. Quần thể sở hữu mê cung tình yêu, các tiểu cảnh hoa nghệ thuật và cầu kính đi bộ ngắm trọn cảnh sắc thiên nhiên thơ mộng.'
WHERE heritage_id = 'dce9ca0f-1b07-46b7-8972-d7cf913f895a' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Thung Lũng Tình Yêu',
    address = '3 - 5 - 7 Mai Anh Đào, Phường 8, Đà Lạt, Lâm Đồng',
    description = 'The Valley of Love is Da Lat''''s quintessential romantic attraction, nestled amidst rolling pine ridges and the emerald waters of Da Thien Lake. The park features lush flower labyrinths, artistic love-themed installations, and glass-bottom bridges offering panoramic mountain panoramas.'
WHERE heritage_id = 'dce9ca0f-1b07-46b7-8972-d7cf913f895a' AND language_code = 'en';
UPDATE heritage_translations
SET name = '愛の谷（タイン・トゥー・ティン・イエウ）',
    address = '3 - 5 - 7 Mai Anh Đào, Phường 8, Đà Lạt, Lâm Đồng',
    description = '愛の谷（トゥンルン・ティンイエウ）は、ダラットを代表するロマンチックな景勝地で、ダティエン湖と緑深い松の丘に囲まれています。巨大な緑の迷路やハートをモチーフにしたアートオブジェ、絶景を望むガラス橋があり、カップルや観光客に大人気です。'
WHERE heritage_id = 'dce9ca0f-1b07-46b7-8972-d7cf913f895a' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Tòa cao ốc Lotte Center Hà Nội',
    address = '54 Liễu Giai, Ba Đình, Hà Nội',
    description = 'Lotte Center Hà Nội cao 65 tầng tại ngã tư Liễu Giai - Đào Tấn, mô phỏng tà áo dài truyền thống Việt Nam thướt tha mềm mại bằng kính phản quang hiện đại. Tòa nhà là tổ hợp thương mại cao cấp với đài quan sát Sky Walk sàn kính trong suốt ở tầng 65 mang lại cảm giác lơ lửng ngắm toàn cảnh thủ đô rực rỡ từ trên cao.'
WHERE heritage_id = 'c8d07d35-fe54-4180-aa13-4e4c8682fe57' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Tòa cao ốc Lotte Center Hà Nội',
    address = '54 Liễu Giai, Ba Đình, Hà Nội',
    description = 'Lotte Center Hanoi stands 65 stories high at the intersection of Lieu Giai and Dao Tan, its sleek curtain-wall facade inspired by the flowing drapery of the Vietnamese Ao Dai. The luxury multi-use complex features the thrilling Sky Walk glass-floor observatory on the 65th floor offering dizzying aerial vistas over Hanoi.'
WHERE heritage_id = 'c8d07d35-fe54-4180-aa13-4e4c8682fe57' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ロッテセンター・ハノイ',
    address = '54 Liễu Giai, Ba Đình, Hà Nội',
    description = 'ロッテセンター・ハノイは、ベトナム伝統衣装のアオザイの優美な曲線をモチーフにデザインされた高さ65階建ての近代的な超高層ランドマークです。最上層の展望台には足元が透けて見えるスリリングなガラス張りデッキ「スカイウォーク」があり、ハノイ市街を一望できます。'
WHERE heritage_id = 'c8d07d35-fe54-4180-aa13-4e4c8682fe57' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Tòa nhà Saigon Trade Center',
    address = 'Tòa nhà Saigon Trade Center, TP. Hồ Chí Minh',
    description = 'Saigon Trade Center cao 33 tầng tại ngã ba Tôn Đức Thắng và Nguyễn Thị Minh Khai, từng là tòa nhà cao nhất Việt Nam khi hoàn thành vào năm 1997. Với hình khối bát giác bọc kính xanh vững chãi và quán bar tầng thượng lộng gió, công trình là biểu tượng mở đầu cho kỷ nguyên hội nhập kinh tế và bùng nổ cao ốc hiện đại của thành phố.'
WHERE heritage_id = '1525cb78-149f-4122-95d0-4dfe2bb62b21' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Tòa nhà Saigon Trade Center',
    address = 'Tòa nhà Saigon Trade Center, TP. Hồ Chí Minh',
    description = 'Saigon Trade Center rises 33 stories at the intersection of Ton Duc Thang and Nguyen Thi Minh Khai, holding the proud record of being Vietnam''''s tallest skyscraper upon its debut in 1997. Featuring an octagonal blue-glass silhouette and a breezy rooftop terrace, it symbolizes the dawn of modern economic integration and high-rise architecture in the South.'
WHERE heritage_id = '1525cb78-149f-4122-95d0-4dfe2bb62b21' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'サイゴン・トレード・センター',
    address = 'Tòa nhà Saigon Trade Center, TP. Hồ Chí Minh',
    description = 'サイゴン・トレード・センターは、1997年の完成時にベトナム国内最高層を誇った地上33階建ての八角形のオフィスビルです。青いガラスカーテンウォールが青空に映える堂々たる姿を持ち、ドイモイ政策以降のベトナムの経済開放と高層ビル時代の幕開けを告げた記念碑的建造物です。'
WHERE heritage_id = '1525cb78-149f-4122-95d0-4dfe2bb62b21' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Tòa nhà The Reverie Saigon (Times Square)',
    address = 'Tòa nhà The Reverie Saigon (Times Square), TP. Hồ Chí Minh',
    description = 'Times Square Saigon tọa lạc giữa hai đại lộ danh giá Nguyễn Huệ và Đồng Khởi, là nơi ngự trị của khách sạn siêu sang 6 sao The Reverie Saigon. Tòa nhà gây choáng ngợp bởi nghệ thuật trang trí nội thất thủ công vương giả của các bậc thầy nước Ý, lát đá cẩm thạch xa hoa và hệ thống đèn chùm pha lê Baccarat lộng lẫy.'
WHERE heritage_id = 'dbba85d6-e8e8-4d32-abc2-b10868abef0f' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Tòa nhà The Reverie Saigon (Times Square)',
    address = 'Tòa nhà The Reverie Saigon (Times Square), TP. Hồ Chí Minh',
    description = 'Saigon Times Square spans the prestigious corridor between Nguyen Hue and Dong Khoi Boulevards, housing the opulent six-star luxury hotel The Reverie Saigon. Renowned for its bespoke Italian royal furnishings, exquisite marble mosaics, and monumental Baccarat crystal chandeliers, it redefines ultra-luxury hospitality in Vietnam.'
WHERE heritage_id = 'dbba85d6-e8e8-4d32-abc2-b10868abef0f' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ザ・レヴェリー・サイゴン（タイムズスクエア）',
    address = 'Tòa nhà The Reverie Saigon (Times Square), TP. Hồ Chí Minh',
    description = 'ザ・レヴェリー・サイゴン（タイムズスクエア）は、グエンフエ通りとドンコイ通りに面する最高級6つ星ラグジュアリーホテルを擁するランドマークビルです。イタリアの一流デザイナーたちが手掛けた豪華絢爛なモザイク大理石やバカラ社製クリスタルシャンデリアが輝き、宮殿のような極上の空間が広がります。'
WHERE heritage_id = 'dbba85d6-e8e8-4d32-abc2-b10868abef0f' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Tòa Thánh Tây Ninh',
    address = 'Phạm Hộ Pháp, Hòa Thành, Tây Ninh',
    description = 'Tòa Thánh Tây Ninh là thánh địa trung ương tối cao của đạo Cao Đài, nổi bật với sự kết hợp kiến trúc kỳ vĩ giữa chùa chiền phương Đông, tháp chuông thánh đường Công giáo và tháp giáo đường Hồi giáo. Nội thất thánh đường rực rỡ sắc màu với những hàng cột rồng đắp nổi tinh xảo dẫn về Quả Càn Khôn và biểu tượng Thiên Nhãn tỏa sáng linh thiêng.'
WHERE heritage_id = 'ec1b0d75-ba8b-424d-b210-272ef3589294' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Tòa Thánh Tây Ninh',
    address = 'Phạm Hộ Pháp, Hòa Thành, Tây Ninh',
    description = 'The Cao Dai Holy See in Tay Ninh serves as the supreme central cathedral of Caodaism, featuring an astonishing synthesis of Buddhist pagodas, Christian spires, and Islamic domes. Its interior dazzles with pastel columns entwined by serpentine dragons, leading toward the Great Sphere adorned with the radiant Divine Eye.'
WHERE heritage_id = 'ec1b0d75-ba8b-424d-b210-272ef3589294' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'タイニン・カオダイ教総本山（聖座）',
    address = 'Phạm Hộ Pháp, Hòa Thành, Tây Ninh',
    description = 'タイニン・カオダイ教総本山（聖座）は、仏教、道教、儒教、キリスト教、イスラム教などを融合したベトナム発祥の宗教「カオダイ教」の総本山です。極彩色の龍が巻き付く柱が並ぶ礼拝堂内部や、ドームに描かれた「天眼（全知の神の目）」が神秘的で異国情緒あふれる空間を作り出しています。'
WHERE heritage_id = 'ec1b0d75-ba8b-424d-b210-272ef3589294' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Tòa tháp Bitexco Financial Tower',
    address = '02 Hải Triều, Bến Nghé, Quận 1, TP. Hồ Chí Minh',
    description = 'Bitexco Financial Tower cao 262 mét gồm 68 tầng tại trung tâm Quận 1, mô phỏng hình tượng búp hoa sen vươn cao tràn đầy sức sống của một Việt Nam đổi mới. Tòa tháp nổi bật với sân đỗ trực thăng nhô ra ở tầng 52 và đài quan sát Saigon Skydeck trên tầng 49 đem đến góc nhìn 360 độ ngoạn mục ngắm trọn khúc uốn lượn của dòng sông Sài Gòn.'
WHERE heritage_id = 'e334cfaf-2ecc-42a9-b265-2713be8710c3' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Tòa tháp Bitexco Financial Tower',
    address = '02 Hải Triều, Bến Nghé, Quận 1, TP. Hồ Chí Minh',
    description = 'Bitexco Financial Tower rises 68 stories and 262 meters above District 1, architecturally inspired by the graceful unfurling bud of Vietnam''''s national flower, the lotus. Renowned for its cantilevered helipad jutting out from the 52nd floor, its 49th-floor Saigon Skydeck commands breathtaking 360-degree vistas over the Saigon River.'
WHERE heritage_id = 'e334cfaf-2ecc-42a9-b265-2713be8710c3' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ビテクスコ・フィナンシャルタワー',
    address = '02 Hải Triều, Bến Nghé, Quận 1, TP. Hồ Chí Minh',
    description = 'ビテクスコ・フィナンシャルタワーは、蓮のつぼみをモチーフにデザインされた高さ262メートル・地上68階建てのホーチミン市を代表する超高層タワーです。52階から空へ突き出たヘリポートが特徴的で、49階の「サイゴンスカイデッキ」からは曲がりくねるサイゴン川と大都会のパノラマを一望できます。'
WHERE heritage_id = 'e334cfaf-2ecc-42a9-b265-2713be8710c3' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Tòa tháp IFC One Saigon (Saigon One Tower)',
    address = 'Tòa tháp IFC One Saigon (Saigon One Tower), TP. Hồ Chí Minh',
    description = 'IFC One Saigon tọa lạc tại góc đường Hàm Nghi và Tôn Đức Thắng nhìn ra sông Sài Gòn, là tòa tháp chọc trời cao 185 mét với 41 tầng nổi bật bởi lớp kính vảy rồng cách điệu lấp lánh phản chiếu ánh sáng. Tòa tháp là điểm nhấn kiến trúc đương đại mạnh mẽ khẳng định tầm vóc của một trung tâm tài chính quốc tế năng động hàng đầu khu vực.'
WHERE heritage_id = '5b539431-25df-4bcb-8a00-b9ffdbdeb409' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Tòa tháp IFC One Saigon (Saigon One Tower)',
    address = 'Tòa tháp IFC One Saigon (Saigon One Tower), TP. Hồ Chí Minh',
    description = 'IFC One Saigon commands the prime corner of Ham Nghi and Ton Duc Thang Boulevards overlooking the Saigon River, soaring 185 meters high with 41 stories. Encased in a shimmering triangular-faceted glass facade evoking stylized dragon scales, the architectural beacon symbolizes Ho Chi Minh City''''s dynamic ascent as a regional financial hub.'
WHERE heritage_id = '5b539431-25df-4bcb-8a00-b9ffdbdeb409' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'IFCワン・サイゴン（サイゴン・ワン・タワー）',
    address = 'Tòa tháp IFC One Saigon (Saigon One Tower), TP. Hồ Chí Minh',
    description = 'IFCワン・サイゴンは、サイゴン川沿いの要衝にそびえ立つ高さ185メートル・41階建ての超高層タワーです。伝統的な龍の鱗（うろこ）をモチーフにした幾何学的なファサードガラスが陽光にきらめき、国際金融都市として躍進するホーチミン市の新世代のスカイラインを形成しています。'
WHERE heritage_id = '5b539431-25df-4bcb-8a00-b9ffdbdeb409' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Tòa tháp Keangnam Hanoi Landmark Tower 72',
    address = 'Khu E6 Đô thị mới Cầu Giấy, Nam Từ Liêm, Hà Nội',
    description = 'Keangnam Hanoi Landmark Tower cao 350 mét với 72 tầng trên đường Phạm Hùng, từng là tòa nhà chọc trời cao nhất Việt Nam trong nhiều năm. Tòa tháp là tổ hợp tài chính, khách sạn 5 sao cao cấp và đài quan sát Sky72 trên đỉnh cao mang lại tầm nhìn toàn cảnh ngoạn mục khắp vùng đô thị Hà Nội.'
WHERE heritage_id = '0b6fe83f-5ee0-4f9c-b20f-be57dc96a26d' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Tòa tháp Keangnam Hanoi Landmark Tower 72',
    address = 'Khu E6 Đô thị mới Cầu Giấy, Nam Từ Liêm, Hà Nội',
    description = 'Keangnam Hanoi Landmark Tower rises 350 meters across 72 floors on Pham Hung Boulevard, long reigning as Vietnam''''s tallest skyscraper. The massive complex features premier financial centers, five-star luxury suites, and the Sky72 observatory offering 360-degree vistas of the expanding capital.'
WHERE heritage_id = '0b6fe83f-5ee0-4f9c-b20f-be57dc96a26d' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'カンナム・ハノイ・ランドマークタワー72',
    address = 'Khu E6 Đô thị mới Cầu Giấy, Nam Từ Liêm, Hà Nội',
    description = 'カンナム・ハノイ・ランドマークタワー72は、高さ350メートル・地上72階建てのハノイを代表する超高層複合ビルです。高級ホテルやオフィス、ショッピングモールが入居し、最上階の展望台「Sky72」からは急速に発展するハノイ市街を一望できます。'
WHERE heritage_id = '0b6fe83f-5ee0-4f9c-b20f-be57dc96a26d' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Tòa tháp Vietcombank Tower',
    address = 'Tòa tháp Vietcombank Tower, TP. Hồ Chí Minh',
    description = 'Vietcombank Tower cao 206 mét với 35 tầng tại công trường Mê Linh, Quận 1, do công ty kiến trúc lừng danh Pelli Clarke Pelli thiết kế theo phong cách hiện đại hình khối giật cấp vươn cao. Mặt ngoài bọc đá granite và kính cường lực xanh ngọc soi bóng xuống dòng sông Sài Gòn, là trụ sở tài chính đẳng cấp và biểu tượng thịnh vượng của thành phố.'
WHERE heritage_id = '7d5ffe1d-8e3f-457a-8c24-99e5b935b914' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Tòa tháp Vietcombank Tower',
    address = 'Tòa tháp Vietcombank Tower, TP. Hồ Chí Minh',
    description = 'Vietcombank Tower rises 206 meters across 35 floors commanding Me Linh Square in District 1, masterfully conceived by the world-renowned firm Pelli Clarke Pelli. Its stepped neoclassical granite and emerald glass silhouette overlooking the Saigon River stands as a prominent pillar of modern corporate prestige.'
WHERE heritage_id = '7d5ffe1d-8e3f-457a-8c24-99e5b935b914' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ベトコムバンク・タワー（サイゴン）',
    address = 'Tòa tháp Vietcombank Tower, TP. Hồ Chí Minh',
    description = 'ベトコムバンク・タワーは、サイゴン川を望むメーリン広場にそびえ立つ高さ206メートル・35階建ての洗練された超高層ビルです。世界的な建築設計事務所ペリ・クラーク・ペリが手掛けた花崗岩とエメラルドグリーンのガラスが織りなす外観は、ホーチミン市の経済的繁栄の象徴となっています。'
WHERE heritage_id = '7d5ffe1d-8e3f-457a-8c24-99e5b935b914' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Trụ sở UBND Thành phố Hồ Chí Minh',
    address = '86 Lê Thánh Tôn, Bến Nghé, Quận 1, TP. Hồ Chí Minh',
    description = 'Trụ sở UBND Thành phố Hồ Chí Minh ngự ở đầu phố đi bộ Nguyễn Huệ, nguyên là Dinh Xã Tây được kiến trúc sư Paul Gardès thiết kế xây dựng từ năm 1898 đến 1909 theo phong cách Phục hưng Pháp. Tòa nhà nổi bật với tháp chuông trung tâm cao vút, các bức phù điêu nữ thần Marianne tinh xảo và hệ thống chiếu sáng nghệ thuật rực rỡ khi đêm về.'
WHERE heritage_id = 'cb1c2271-f4ef-4fda-aa06-b3f807702f42' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Trụ sở UBND Thành phố Hồ Chí Minh',
    address = '86 Lê Thánh Tôn, Bến Nghé, Quận 1, TP. Hồ Chí Minh',
    description = 'The Ho Chi Minh City Hall, originally the Hotel de Ville, anchors the northern terminus of the pedestrianized Nguyen Hue Boulevard, constructed between 1898 and 1909 in French Renaissance styling by Paul Gardes. Crowned by an iconic central bell tower and classical sculptural friezes, it forms Saigon''''s most photographed colonial civic monument.'
WHERE heritage_id = 'cb1c2271-f4ef-4fda-aa06-b3f807702f42' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ホーチミン市人民委員会庁舎（旧市庁舎）',
    address = '86 Lê Thánh Tôn, Bến Nghé, Quận 1, TP. Hồ Chí Minh',
    description = 'ホーチミン市人民委員会庁舎（旧サイゴン市庁舎）は、グエンフエ歩行者天国の正面にそびえる1909年完成のフランス・ルネサンス様式の壮麗なコロニアル建築です。中央の時計塔や精緻なレリーフ彫刻が美しく、夜間のドラマチックなライトアップはサイゴン随一の絶景として愛されています。'
WHERE heritage_id = 'cb1c2271-f4ef-4fda-aa06-b3f807702f42' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Trung tâm Thương mại Tràng Tiền Plaza',
    address = '24 Hai Bà Trưng, Tràng Tiền, Hoàn Kiếm, Hà Nội',
    description = 'Tràng Tiền Plaza ngự tại góc phố Tràng Tiền hướng ra hồ Hoàn Kiếm, là trung tâm thương mại cao cấp và lâu đời bậc nhất của Hà Nội khởi nguyên từ bách hóa tổng hợp thời Pháp thuộc. Tòa nhà được tân trang lộng lẫy theo phong cách kiến trúc cổ điển châu Âu xa hoa, quy tụ các thương hiệu thời trang đẳng cấp quốc tế.'
WHERE heritage_id = 'f590f80e-9718-442e-8b12-2a711f545143' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Trung tâm Thương mại Tràng Tiền Plaza',
    address = '24 Hai Bà Trưng, Tràng Tiền, Hoàn Kiếm, Hà Nội',
    description = 'Trang Tien Plaza commands a prestigious street corner facing Hoan Kiem Lake, evolving from a legendary French colonial department store into Hanoi''''s premier luxury emporium. Restored in lavish European neoclassical architecture with gilded halls, it showcases the world''''s most exclusive haute couture fashion houses.'
WHERE heritage_id = 'f590f80e-9718-442e-8b12-2a711f545143' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'チャンティエン・プラザ',
    address = '24 Hai Bà Trưng, Tràng Tiền, Hoàn Kiếm, Hà Nội',
    description = 'チャンティエン・プラザは、ホアンキエム湖畔の目抜き通りに建つ、フランス植民地時代の大百貨店を起源とするハノイ最古の高級ショッピングモールです。エレガントなヨーロッパ古典様式の白亜の外観と豪華な吹き抜け空間には、世界の高級ブランド店が勢揃いしています。'
WHERE heritage_id = 'f590f80e-9718-442e-8b12-2a711f545143' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Trường THPT Chuyên Quốc Học Huế',
    address = '12 Lê Lợi, Vĩnh Ninh, Thành phố Huế',
    description = 'Trường Quốc Học Huế thành lập năm 1896 bên bờ sông Hương, là một trong những ngôi trường trung học lâu đời và giàu truyền thống hiếu học bậc nhất Việt Nam. Khuôn viên trường gây ấn tượng mạnh với phong cách kiến trúc Pháp cổ điển kết hợp cổng tam quan Á Đông và những bức tường quét vôi đỏ thắm rợp bóng xà cừ cổ thụ.'
WHERE heritage_id = '548b9e71-70df-4996-a606-5ac287dfb4f7' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Trường THPT Chuyên Quốc Học Huế',
    address = '12 Lê Lợi, Vĩnh Ninh, Thành phố Huế',
    description = 'Quoc Hoc - Hue High School, founded in 1896 beside the Perfume River, is one of Vietnam''''s oldest and most prestigious secondary institutions. The historic campus is renowned for its romantic French colonial brick buildings, crimson-hued walls, and leafy corridors under ancient mahogany trees.'
WHERE heritage_id = '548b9e71-70df-4996-a606-5ac287dfb4f7' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'フエ・クオックホック高等学校（国学高校）',
    address = '12 Lê Lợi, Vĩnh Ninh, Thành phố Huế',
    description = 'フエ国学高校は、1896年に創立されたベトナムで最も歴史と伝統のある名門校です。香河のほとりに広がるキャンパスには、鮮やかな赤レンガと西洋建築の美しさが際立つ校舎が並び、多くの偉人を輩出した学び舎として知られています。'
WHERE heritage_id = '548b9e71-70df-4996-a606-5ac287dfb4f7' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Tượng Chúa Kitô Vua (Vũng Tàu)',
    address = 'Đường Thùy Vân, Phường 2, Vũng Tàu, Bà Rịa - Vũng Tàu',
    description = 'Tượng Chúa Kitô Vua sừng sững trên đỉnh Núi Nhỏ ở độ cao 170 mét so với mực nước biển, là bức tượng Chúa Giêsu lớn bậc nhất châu Á với chiều cao 32 mét và sải tay dài 18,3 mét. Du khách vượt qua gần 1.000 bậc đá và leo 133 bậc thang xoắn ốc bên trong thân tượng để bước ra đôi vai Chúa ngắm toàn cảnh phố biển Vũng Tàu tuyệt mỹ.'
WHERE heritage_id = '37028aad-459a-4853-89b7-c32478e4d98b' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Tượng Chúa Kitô Vua (Vũng Tàu)',
    address = 'Đường Thùy Vân, Phường 2, Vũng Tàu, Bà Rịa - Vũng Tàu',
    description = 'The Christ the King of Vung Tau statue crowns the summit of Small Mountain 170 meters above sea level, ranking among Asia''''s largest statues of Jesus at 32 meters tall with an arm span of 18.3 meters. Visitors climb nearly 1,000 hillside steps and a spiral interior staircase to step onto the outstretched shoulders for sweeping coastal panoramas.'
WHERE heritage_id = '37028aad-459a-4853-89b7-c32478e4d98b' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ブンタウのキリスト像（巨像）',
    address = 'Đường Thùy Vân, Phường 2, Vũng Tàu, Bà Rịa - Vũng Tàu',
    description = 'ブンタウのキリスト像は、標高170メートルの小山の頂上に両手を広げて立つ高さ32メートル、両腕の幅18.3メートルに及ぶアジア最大級のキリスト巨像です。像の内部にある133段の螺旋階段を登って肩の展望デッキに出ると、眼下にブンタウ市街と大海原のパノラマが広がります。'
WHERE heritage_id = '37028aad-459a-4853-89b7-c32478e4d98b' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Vịnh Cam Ranh',
    address = 'Thành phố Cam Ranh, Khánh Hòa',
    description = 'Vịnh Cam Ranh là một trong những vịnh nước sâu tự nhiên đẹp và kín gió nhất thế giới, được bao bọc bởi bán đảo Cam Ranh cùng những dãy núi trập trùng. Nơi đây quy tụ nhiều bãi biển hoang sơ tuyệt mỹ như Bãi Dài với bờ cát trắng mịn và làn nước trong vắt như pha lê.'
WHERE heritage_id = '9400573a-310d-44aa-b9b5-4e314e0e14ce' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Vịnh Cam Ranh',
    address = 'Thành phố Cam Ranh, Khánh Hòa',
    description = 'Cam Ranh Bay is renowned as one of the world''''s finest natural deep-water harbors, sheltered by rugged peninsulas and rolling mountain ridges. It boasts stunning, unspoiled coastal stretches such as Bai Dai Beach, admired for powdery white sands and crystal-clear waters.'
WHERE heritage_id = '9400573a-310d-44aa-b9b5-4e314e0e14ce' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'カムラン湾',
    address = 'Thành phố Cam Ranh, Khánh Hòa',
    description = 'カムラン湾は、山々と半島に抱かれた世界有数の天然の良港であり、穏やかな青い海が広がる美しい湾です。バイザイ海岸をはじめとする白砂と透明度の高いエメラルドグリーンのビーチが連なり、極上のリゾート空間を提供しています。'
WHERE heritage_id = '9400573a-310d-44aa-b9b5-4e314e0e14ce' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Vườn Bách Thảo Hà Nội',
    address = 'Vườn Bách Thảo Hà Nội, Hà Nội',
    description = 'Vườn Bách Thảo Hà Nội thành lập từ năm 1890, được ví như ''''lá phổi xanh'''' yên ả nằm ngay phía sau Quảng trường Ba Đình và Phủ Chủ tịch. Công viên lưu giữ hàng trăm loài cây cổ thụ quý hiếm, những đồi cỏ xanh ngắt rợp bóng mát cùng hồ Vị Danh thanh bình, là điểm dạo mát lý tưởng của người dân thủ đô.'
WHERE heritage_id = '65153ddf-07b2-4d5f-8806-f8e167b58a8c' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Vườn Bách Thảo Hà Nội',
    address = 'Vườn Bách Thảo Hà Nội, Hà Nội',
    description = 'The Hanoi Botanical Garden, established in 1890 during the French era, serves as a serene green sanctuary located right behind Ba Dinh Square and the Presidential Palace. Shaded by centuries-old indigenous and exotic trees around peaceful Vi Danh Lake, it provides a quiet refuge from the bustling city streets.'
WHERE heritage_id = '65153ddf-07b2-4d5f-8806-f8e167b58a8c' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ハノイ植物園（バオタオ公園）',
    address = 'Vườn Bách Thảo Hà Nội, Hà Nội',
    description = 'ハノイ植物園は、1890年フランス統治時代に開園したバーディン広場裏手に広がる歴史ある緑のオアシスです。世界中から集められた希少な巨木や熱帯植物が生い茂り、穏やかな池の周りを散策して都会の喧騒を忘れられる憩いの場となっています。'
WHERE heritage_id = '65153ddf-07b2-4d5f-8806-f8e167b58a8c' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Vườn hoa Thành phố Đà Lạt',
    address = 'Vườn hoa Thành phố Đà Lạt, Lâm Đồng',
    description = 'Vườn hoa Thành phố tọa lạc bên bờ hồ Xuân Hương, là nơi hội tụ của hơn 300 loài hoa quý hiếm trong nước và quốc tế. Khí hậu ôn đới quanh năm mát mẻ giúp hàng nghìn luống hoa hồng, cẩm tú cầu, hoa lan đua nhau khoe sắc rực rỡ suốt bốn mùa.'
WHERE heritage_id = '37173f2d-c36a-4ba8-acc7-2542a60a49a9' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Vườn hoa Thành phố Đà Lạt',
    address = 'Vườn hoa Thành phố Đà Lạt, Lâm Đồng',
    description = 'Located beside Xuan Huong Lake, Da Lat Flower Park showcases over 300 rare varieties of domestic and imported flowers. The year-round cool temperate climate allows vast carpets of hydrangeas, orchids, and roses to bloom vividly in every season.'
WHERE heritage_id = '37173f2d-c36a-4ba8-acc7-2542a60a49a9' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ダラット市花園',
    address = 'Vườn hoa Thành phố Đà Lạt, Lâm Đồng',
    description = 'ダラット市花園はスアンフーン湖の北端に位置し、300種以上の国内外の希少な花々が咲き誇る植物園です。高原特有の冷涼な気候のもと、色鮮やかなアジサイやラン、バラの花壇が一年を通して来園者を迎えます。'
WHERE heritage_id = '37173f2d-c36a-4ba8-acc7-2542a60a49a9' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Vườn quốc gia Ba Vì',
    address = 'Huyện Ba Vì, Hà Nội',
    description = 'Vườn quốc gia Ba Vì ôm trọn dãy núi Ba Vì hùng vĩ cách trung tâm Hà Nội khoảng 50 km, sở hữu khí hậu vùng cao mát mẻ quanh năm và thảm thực vật nhiệt đới đa dạng. Nơi đây nổi tiếng với đền thờ Bác Hồ trên đỉnh Vua, phế tích nhà thờ Pháp cổ rêu phong và vườn xương rồng độc đáo giữa mây ngàn.'
WHERE heritage_id = '2b6e93fa-3873-4c89-9713-3b6f0e9562f1' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Vườn quốc gia Ba Vì',
    address = 'Huyện Ba Vì, Hà Nội',
    description = 'Ba Vi National Park encompasses the rugged Ba Vi mountain range located 50 km west of central Hanoi, treasured for its refreshingly cool alpine microclimate and rich biodiversity. Key highlights include the sacred shrine dedicated to President Ho Chi Minh on King Peak, atmospheric mossy French ruins, and a grand cactus sanctuary.'
WHERE heritage_id = '2b6e93fa-3873-4c89-9713-3b6f0e9562f1' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'バヴィ国立公園',
    address = 'Huyện Ba Vì, Hà Nội',
    description = 'バヴィ国立公園は、ハノイ西郊約50キロに位置し、冷涼な気候と豊かな原生林が広がる高原の避暑地です。標高1,296メートルの最高峰にあるホー・チミン廟をはじめ、霧の中に佇む苔むしたフランス植民地時代の教会廃墟や温室サボテン園が見どころです。'
WHERE heritage_id = '2b6e93fa-3873-4c89-9713-3b6f0e9562f1' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Vườn quốc gia Bạch Mã',
    address = 'Vườn quốc gia Bạch Mã, Thừa Thiên Huế',
    description = 'Vườn quốc gia Bạch Mã trải rộng trên dải núi Trường Sơn hùng vĩ, là khu bảo tồn thiên nhiên đa dạng sinh học bậc nhất miền Trung. Đứng từ đỉnh Vọng Hải Đài mây phủ ở độ cao 1.450 mét, du khách có thể phóng tầm mắt bao trọn đầm Cầu Hai và bờ biển xanh ngắt của vịnh Lăng Cô.'
WHERE heritage_id = 'a713bc60-205d-419b-9ca3-fdf4e48e0f63' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Vườn quốc gia Bạch Mã',
    address = 'Vườn quốc gia Bạch Mã, Thừa Thiên Huế',
    description = 'Bach Ma National Park stretches across the majestic Truong Son range, recognized as one of Central Vietnam''''s most biologically diverse nature reserves. From the cloud-veiled Hai Vong Dai summit at 1,450 meters, visitors can enjoy sweeping panoramic views over Cau Hai Lagoon and Lang Co Bay.'
WHERE heritage_id = 'a713bc60-205d-419b-9ca3-fdf4e48e0f63' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'バクマ国立公園',
    address = 'Vườn quốc gia Bạch Mã, Thừa Thiên Huế',
    description = 'バクマ国立公園は、アンナン山脈（チュオンソン山脈）に広がる中部有数の生物多様性を誇る大自然の保護区です。標高1,450メートルの山頂展望台「望海台」からは、雲海に浮かぶ美しいラグーンやランコー湾のエメラルドグリーンの海を一望できます。'
WHERE heritage_id = 'a713bc60-205d-419b-9ca3-fdf4e48e0f63' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Vườn quốc gia Cát Bà',
    address = 'Vườn quốc gia Cát Bà, Hải Phòng',
    description = 'Vườn quốc gia Cát Bà được UNESCO công nhận là Khu dự trữ sinh quyển thế giới, là nơi cư trú duy nhất trên hành tinh của loài voọc Cát Bà cực kỳ quý hiếm. Hệ sinh thái rừng nhiệt đới nguyên sinh trên núi đá vôi cùng hồ ếch tự nhiên mở ra những cung đường trekking kỳ thú băng qua thung lũng nguyên sơ.'
WHERE heritage_id = '0b350de9-d15c-415d-be86-8b9ccf438345' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Vườn quốc gia Cát Bà',
    address = 'Vườn quốc gia Cát Bà, Hải Phòng',
    description = 'Cat Ba National Park is a UNESCO-designated World Biosphere Reserve, sheltering the planet''''s sole remaining wild population of the critically endangered golden-headed langur. Its lush tropical karst rainforests and inland freshwater lakes offer world-class trekking trails through pristine limestone valleys.'
WHERE heritage_id = '0b350de9-d15c-415d-be86-8b9ccf438345' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'カットバ国立公園',
    address = 'Vườn quốc gia Cát Bà, Hải Phòng',
    description = 'カットバ国立公園は、世界でここにしか生息しない絶滅危惧種「ゴールデンヘッドラングール（カットバラングール）」の最後の生息地として知られるユネスコ生物圏保存地域です。熱帯カルスト原生林やカエルの湖を抜ける本格的なトレッキングコースが整備されています。'
WHERE heritage_id = '0b350de9-d15c-415d-be86-8b9ccf438345' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Vườn quốc gia Cát Tiên',
    address = 'Tân Phú, Đồng Nai',
    description = 'Vườn quốc gia Cát Tiên trải dài trên địa bàn Đồng Nai, Lâm Đồng và Bình Phước, là Khu dự trữ sinh quyển thế giới bảo tồn hệ sinh thái rừng nhiệt đới đất thấp lớn nhất Nam Bộ. Nơi đây là vương quốc hoang dã của loài bò tót, chim công, cá sấu đầm lầy Bàu Sấu và những cây tùng cổ thụ nghìn năm tuổi khổng lồ.'
WHERE heritage_id = '0539ea0e-6063-46e9-afdb-d5c42467ba4b' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Vườn quốc gia Cát Tiên',
    address = 'Tân Phú, Đồng Nai',
    description = 'Cat Tien National Park is an internationally renowned UNESCO World Biosphere Reserve safeguarding the largest lowland tropical rainforest ecosystem in southern Vietnam. It provides a sanctuary for wild gaurs, Siamese crocodiles at Bau Sau Lake, exotic hornbills, and colossal centuries-old Tung trees.'
WHERE heritage_id = '0539ea0e-6063-46e9-afdb-d5c42467ba4b' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'カッティエン国立公園',
    address = 'Tân Phú, Đồng Nai',
    description = 'カッティエン国立公園は、ユネスコ生物圏保存地域に指定されたベトナム南部最大の低地熱帯雨林保護区です。野生の野牛（ガウル）や絶滅危惧種のシャムワニが生息するワニ沼（バウサウ）、樹齢数百年の巨大なツングの巨木があり、サファリやナイトハイクが人気です。'
WHERE heritage_id = '0539ea0e-6063-46e9-afdb-d5c42467ba4b' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Vườn quốc gia Cúc Phương',
    address = 'Vườn quốc gia Cúc Phương, Ninh Bình',
    description = 'Vườn quốc gia Cúc Phương thành lập năm 1962, là vườn quốc gia đầu tiên của Việt Nam nằm trên vùng ranh giới ba tỉnh Ninh Bình, Hòa Bình và Thanh Hóa. Nơi đây bảo tồn hệ sinh thái rừng mưa nhiệt đới nguyên sinh với cây Chò ngàn năm tuổi sừng sững, hang động người tiền sử và mùa bướm rừng bay rợp trời tuyệt mỹ vào đầu hạ.'
WHERE heritage_id = 'de8fca7f-fb63-46a5-82e4-246e6ee7ecf3' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Vườn quốc gia Cúc Phương',
    address = 'Vườn quốc gia Cúc Phương, Ninh Bình',
    description = 'Cuc Phuong National Park, established in 1962, is Vietnam''''s pioneering national park sprawling across the limestone boundaries of Ninh Binh, Hoa Binh, and Thanh Hoa. The virgin rainforest protects millennial trees, prehistoric human grottos, and a breathtaking seasonal spectacle of millions of fluttering butterflies in early summer.'
WHERE heritage_id = 'de8fca7f-fb63-46a5-82e4-246e6ee7ecf3' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'クックフォン国立公園',
    address = 'Vườn quốc gia Cúc Phương, Ninh Bình',
    description = 'クックフォン国立公園は、1962年に指定されたベトナム最古の国立公園であり、豊かな熱帯雨林が保護されています。樹齢千年の巨木や先史時代の人類が暮らした洞窟、野生動植物の保護センターがあり、初夏には数十万匹の蝶が乱舞する神秘的な光景が見られます。'
WHERE heritage_id = 'de8fca7f-fb63-46a5-82e4-246e6ee7ecf3' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Vườn quốc gia Phong Nha - Kẻ Bàng',
    address = 'Bố Trạch, Quảng Bình',
    description = 'Vườn quốc gia Phong Nha - Kẻ Bàng là Di sản Thiên nhiên Thế giới UNESCO hai lần vinh danh, sở hữu vùng núi đá vôi cổ xưa nhất châu Á với niên đại hơn 400 triệu năm. Quần thể ẩn chứa hệ thống hàng trăm hang động kỳ vĩ, những dòng sông ngầm huyền ảo và hệ sinh thái rừng nhiệt đới nguyên sinh bạt ngàn.'
WHERE heritage_id = '45be95b2-3ce3-4369-b63d-b41a105e032d' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Vườn quốc gia Phong Nha - Kẻ Bàng',
    address = 'Bố Trạch, Quảng Bình',
    description = 'Phong Nha-Ke Bang National Park is a two-time UNESCO World Natural Heritage site sheltering Asia''''s oldest karst formation dating back over 400 million years. The park is renowned for hundreds of colossal caverns, subterranean rivers, and biologically rich primary rainforests.'
WHERE heritage_id = '45be95b2-3ce3-4369-b63d-b41a105e032d' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'フォンニャ＝ケバン国立公園',
    address = 'Bố Trạch, Quảng Bình',
    description = 'フォンニャ＝ケバン国立公園は、4億年以上前に形成されたアジア最古のカルスト地形を有し、ユネスコ世界自然遺産に二度登録された大自然の宝庫です。世界屈指の規模を誇る鍾乳洞群や地下河川、原生熱帯雨林が手つかずのまま残されています。'
WHERE heritage_id = '45be95b2-3ce3-4369-b63d-b41a105e032d' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Vườn quốc gia Tràm Chim',
    address = 'Tam Nông, Đồng Tháp',
    description = 'Vườn quốc gia Tràm Chim tại huyện Tam Nông, Đồng Tháp, là khu Ramsar đất ngập nước quý giá của đồng bằng sông Cửu Long, nơi lưu giữ trọn vẹn cảnh quan hoang sơ của vùng Đồng Tháp Mười thu nhỏ. Nơi đây là vương quốc của hơn 230 loài chim nước, đặc biệt là loài Sếu đầu đỏ quý hiếm nằm trong Sách đỏ thế giới về đây nhảy múa vào mùa khô.'
WHERE heritage_id = 'a2e3dbab-fcde-4eca-98aa-cb603782105d' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Vườn quốc gia Tràm Chim',
    address = 'Tam Nông, Đồng Tháp',
    description = 'Tram Chim National Park in Tam Nong, Dong Thap, is an internationally designated Ramsar wetland preserving the pristine marshlands of the historical Plain of Reeds. Home to over 230 waterbird species, it is globally celebrated as the crucial winter sanctuary for the endangered Sarus Crane, the world''''s tallest flying bird.'
WHERE heritage_id = 'a2e3dbab-fcde-4eca-98aa-cb603782105d' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'トラムチム国立公園（サシオヅル保護区）',
    address = 'Tam Nông, Đồng Tháp',
    description = 'トラムチム国立公園は、ドンタップ省の広大な湿原地帯「ドンタップムオイ」の原生自然を保護するラムサール条約登録湿地です。世界最大の飛翔鳥である絶滅危惧種「サシオヅル」をはじめとする230種以上の野鳥の楽園であり、ボートで蓮の花咲く水路を進む自然探訪が魅力です。'
WHERE heritage_id = 'a2e3dbab-fcde-4eca-98aa-cb603782105d' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Vườn quốc gia U Minh Thượng',
    address = 'An Minh, Kiên Giang',
    description = 'Vườn quốc gia U Minh Thượng thuộc tỉnh Kiên Giang, là khu bảo tồn đất ngập nước trên nền than bùn quý hiếm bậc nhất khu vực Đông Nam Á, được công nhận là Vườn Di sản ASEAN và khu Ramsar thế giới. Rừng tràm bạt ngàn soi bóng xuống mặt nước màu hổ phách đặc trưng là nơi sinh sống của rái cá lông mũi, dơi ngựa và hàng trăm loài động thực vật hoang dã quý hiếm.'
WHERE heritage_id = '1c75319f-e1d9-4cb6-84c2-669f239f2d8e' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Vườn quốc gia U Minh Thượng',
    address = 'An Minh, Kiên Giang',
    description = 'U Minh Thuong National Park in Kien Giang preserves one of Southeast Asia''''s rarest peat swamp wetland ecosystems, honored as an ASEAN Heritage Park and Ramsar wetland. Its sprawling melaleuca cajeput forests over dark amber waters shelter endangered hairy-nosed otters, fruit bats, and prolific bird colonies.'
WHERE heritage_id = '1c75319f-e1d9-4cb6-84c2-669f239f2d8e' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ウーミン・トゥオン国立公園（泥炭湿地林）',
    address = 'An Minh, Kiên Giang',
    description = 'ウーミン・トゥオン国立公園は、キエンザン省に広がる東南アジア極めて希少な泥炭湿地林の生態系を保護するASEAN遺産公園およびラムサール湿地です。琥珀色に輝く水面にどこまでも続くカユプテ（白樹）の原生林が広がり、絶滅危惧種ハナジロカワウソなどの野生動物の楽園となっています。'
WHERE heritage_id = '1c75319f-e1d9-4cb6-84c2-669f239f2d8e' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Vườn quốc gia Xuân Thủy',
    address = 'Vườn quốc gia Xuân Thủy, Nam Định',
    description = 'Vườn quốc gia Xuân Thủy tọa lạc tại cửa sông Hồng thuộc huyện Giao Thủy, Nam Định, là khu đất ngập nước đầu tiên của Đông Nam Á được công nhận theo Công ước Ramsar quốc tế. Vùng đầm lầy ngập mặn trù phú này là ''''ga quốc tế'''' của hàng triệu cánh chim di cư quý hiếm từ phương Bắc dừng chân tránh rét hàng năm.'
WHERE heritage_id = '17ac0b0f-5ce5-4e0e-9941-5914aeb638e6' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Vườn quốc gia Xuân Thủy',
    address = 'Vườn quốc gia Xuân Thủy, Nam Định',
    description = 'Xuan Thuy National Park in Giao Thuy, Nam Dinh, covers a vast estuarine wetland at the mouth of the Red River, designated as Southeast Asia''''s first international Ramsar site. The rich mangrove swamps serve as a vital global transit station for hundreds of rare migratory bird species navigating the East Asian-Australasian flyway.'
WHERE heritage_id = '17ac0b0f-5ce5-4e0e-9941-5914aeb638e6' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'スアントゥイ国立公園',
    address = 'Vườn quốc gia Xuân Thủy, Nam Định',
    description = 'スアントゥイ国立公園は、紅河の河口部に広がる湿地帯であり、東南アジアで初めてラムサール条約湿地に登録された自然保護区です。広大なマングローブ林が広がり、シベリアなどから越冬のために飛来するヘラシギなど世界的希少鳥類の楽園となっています。'
WHERE heritage_id = '17ac0b0f-5ce5-4e0e-9941-5914aeb638e6' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Vương cung thánh đường Đức Mẹ La Vang',
    address = 'Vương cung thánh đường Đức Mẹ La Vang, Quảng Trị',
    description = 'Vương cung thánh đường Đức Mẹ La Vang thuộc tỉnh Quảng Trị là trung tâm hành hương Công giáo lớn và linh thiêng bậc nhất Việt Nam. Nơi đây gắn liền với sự tích Đức Mẹ hiển linh an ủi các tín đồ vào năm 1798 giữa cánh rừng rậm rạp, thu hút hàng triệu lượt khách hành hương mỗi năm.'
WHERE heritage_id = 'd0bb89f5-8300-4044-a90a-99bf8c0dec65' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Vương cung thánh đường Đức Mẹ La Vang',
    address = 'Vương cung thánh đường Đức Mẹ La Vang, Quảng Trị',
    description = 'The Basilica of Our Lady of La Vang in Quang Tri is the foremost national Marian pilgrimage center for Catholics in Vietnam. It commemorates the sacred 1798 apparition of the Virgin Mary comforting believers in the deep jungle, drawing millions of pilgrims seeking peace and blessings annually.'
WHERE heritage_id = 'd0bb89f5-8300-4044-a90a-99bf8c0dec65' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'ラ・ヴァン聖母大聖堂',
    address = 'Vương cung thánh đường Đức Mẹ La Vang, Quảng Trị',
    description = 'ラ・ヴァン聖母大聖堂は、クアンチ省に位置するベトナム最大のカトリック巡礼地です。1798年に深い森の中で聖母マリアが出現し信仰者を慰めたという奇跡の伝承が残されており、国内外から多くの巡礼者が祈りを捧げに訪れます。'
WHERE heritage_id = 'd0bb89f5-8300-4044-a90a-99bf8c0dec65' AND language_code = 'ja';
UPDATE heritage_translations
SET name = 'Vương cung thánh đường Phú Nhai',
    address = 'Vương cung thánh đường Phú Nhai, Nam Định',
    description = 'Vương cung thánh đường Phú Nhai tọa lạc tại huyện Xuân Trường, Nam Định, là một trong những nhà thờ Công giáo lớn và tráng lệ bậc nhất Việt Nam mang đậm phong cách kiến trúc Gothic Tây Ban Nha. Hai tháp chuông sừng sững cao 44 mét cùng hệ thống mái vòm uốn cong chạm trổ phù điêu tinh xảo tạo nên vẻ đẹp tôn nghiêm và lộng lẫy.'
WHERE heritage_id = 'ade0405a-b1c8-43f0-bb8d-81a655c51004' AND language_code = 'vi';
UPDATE heritage_translations
SET name = 'Vương cung thánh đường Phú Nhai',
    address = 'Vương cung thánh đường Phú Nhai, Nam Định',
    description = 'The Basilica of the Immaculate Conception in Phu Nhai, Nam Dinh, is one of Vietnam''''s most imposing and splendid Catholic shrines, built in magnificent Spanish Gothic style. Featuring soaring 44-meter twin bell towers and ornate vaulted ceiling bas-reliefs, it stands as a monumental masterpiece of Christian heritage in Northern Vietnam.'
WHERE heritage_id = 'ade0405a-b1c8-43f0-bb8d-81a655c51004' AND language_code = 'en';
UPDATE heritage_translations
SET name = 'フーニャイ無原罪の御宿り大聖堂',
    address = 'Vương cung thánh đường Phú Nhai, Nam Định',
    description = 'フーニャイ無原罪の御宿り大聖堂は、ナムディン省スアントゥオン県に位置する東南アジア屈指の規模を誇る壮麗なゴシック様式のカトリック大聖堂です。高さ44メートルの双塔と、精緻な彫刻が施された高いアーチ状の天井が、ヨーロッパの大聖堂を思わせる神聖な輝きを放っています。'
WHERE heritage_id = 'ade0405a-b1c8-43f0-bb8d-81a655c51004' AND language_code = 'ja';
INSERT INTO heritage_translations (heritage_id, language_code, name, category, province, address, description)
VALUES ('a1000001-0000-4000-a000-000000000003', 'vi', 'Tượng Cá Chép Hóa Rồng Đà Nẵng', 'Kiến trúc & Cung đình', 'Đà Nẵng', 'Bến du thuyền DHC Marina, Đường Trần Hưng Đạo, Phường An Hải Tây, Quận Sơn Trà, TP. Đà Nẵng', 'Tượng Cá Chép Hóa Rồng tọa lạc tại bờ đông sông Hàn, ngay sát Cầu Tình Yêu và gần Cầu Rồng. Tác phẩm điêu khắc nặng gần 200 tấn, cao 7,5m, được chế tác tinh xảo từ khối đá cẩm thạch trắng tự nhiên Non Nước bởi các nghệ nhân làng đá Non Nước Ngũ Hành Sơn. Bức tượng mang ý nghĩa phong thủy sâu sắc về sự thăng tiến, kiên trì vượt vũ môn để hóa rồng, đồng thời liên tục phun nước ra sông Hàn tạo cảnh quan độc đáo thu hút đông đảo du khách.')
ON CONFLICT (heritage_id, language_code) DO UPDATE SET
    name = EXCLUDED.name,
    category = EXCLUDED.category,
    province = EXCLUDED.province,
    address = EXCLUDED.address,
    description = EXCLUDED.description;
INSERT INTO heritage_translations (heritage_id, language_code, name, category, province, address, description)
VALUES ('a1000001-0000-4000-a000-000000000003', 'en', 'Da Nang Dragon Carp Statue', 'Architecture & Palaces', 'Da Nang', 'DHC Marina, Tran Hung Dao Street, An Hai Tay Ward, Son Tra District, Da Nang', 'The Dragon Carp Statue is located on the eastern bank of the Han River, right beside the Love Lock Bridge and near Dragon Bridge. Weighing nearly 200 tons and standing 7.5 meters tall, it is meticulously carved from natural white Non Nuoc marble by artisans of the Marble Mountains. Symbolizing perseverance and transformation into a dragon, the statue sprays water into the Han River, creating an iconic landmark of modern Da Nang.')
ON CONFLICT (heritage_id, language_code) DO UPDATE SET
    name = EXCLUDED.name,
    category = EXCLUDED.category,
    province = EXCLUDED.province,
    address = EXCLUDED.address,
    description = EXCLUDED.description;
INSERT INTO heritage_translations (heritage_id, language_code, name, category, province, address, description)
VALUES ('a1000001-0000-4000-a000-000000000003', 'ja', '鯉の滝登り像 (ダナン・カーチェップ・ホア・ロン)', '建築・宮廷', 'ダナン', 'ダナン市ソンチャ区アンハイタイ坊DHCマリーナチャンフンダオ通り', 'ダナンの鯉の滝登り像（カーチェップ・ホア・ロン）は、ハン川東岸の愛の桟橋のすぐ隣に設置されたモニュメントです。重さ約200トン、高さ7.5メートルに達し、五行山（ノンヌオック）の伝統石彫職人によって天然白大理石から精巧に彫り出されました。難関を突破して龍へと昇華する縁起の良い伝説を象徴し、口からハン川へ水を吹き出す姿が多くの観光客に親しまれています。')
ON CONFLICT (heritage_id, language_code) DO UPDATE SET
    name = EXCLUDED.name,
    category = EXCLUDED.category,
    province = EXCLUDED.province,
    address = EXCLUDED.address,
    description = EXCLUDED.description;

-- ------------------------------------------------------------------------------
-- 4. KIỂM TOÁN TỰ ĐỘNG SAU KHI CHẠY (VERIFICATION)
-- ------------------------------------------------------------------------------
-- 4.1. Tổng số địa danh chuẩn (Kỳ vọng: 240)
SELECT count(*) AS total_heritage_240 FROM heritage_info;

-- 4.2. Tổng số bản dịch chuẩn (Kỳ vọng: 720 = 240 x 3)
SELECT count(*) AS total_translations_720 FROM heritage_translations;

-- 4.3. Kiểm tra Cầu Tình Yêu và Tượng Cá Chép Hóa Rồng (Kỳ vọng: 2 dòng riêng biệt)
SELECT id, name, latitude, longitude, image_url FROM heritage_info WHERE id IN ('63baaf3f-8e8d-4d3d-9475-0475978adbb9', 'a1000001-0000-4000-a000-000000000003');

-- 4.4. Đảm bảo ảnh chùa ngói đỏ cũ train_49144_1.jpg không còn được dùng cho các địa danh Đà Nẵng / du lịch
SELECT count(*) AS count_train_49144 FROM heritage_info WHERE image_url ILIKE '%train_49144_1.jpg%';

COMMIT;