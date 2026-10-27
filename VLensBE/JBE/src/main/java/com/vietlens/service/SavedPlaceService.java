package com.vietlens.service;

import com.vietlens.dto.BookmarkToggleResponse;
import com.vietlens.dto.HeritageResponseDTO;
import com.vietlens.entity.HeritageInfo;
import com.vietlens.entity.SavedPlaceEntity;
import com.vietlens.repository.HeritageInfoRepository;
import com.vietlens.repository.SavedPlaceRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Service xử lý tính năng Yêu thích (Bookmark / Saved Place) của người dùng.
 */
@Slf4j
@Service
public class SavedPlaceService {

    private final SavedPlaceRepository savedPlaceRepository;
    private final HeritageInfoRepository heritageRepository;

    public SavedPlaceService(SavedPlaceRepository savedPlaceRepository,
                             HeritageInfoRepository heritageRepository) {
        this.savedPlaceRepository = savedPlaceRepository;
        this.heritageRepository = heritageRepository;
    }

    /**
     * Bật/Tắt lưu địa danh yêu thích (Toggle Bookmark)
     * - Nếu đã lưu -> Bỏ lưu
     * - Nếu chưa lưu -> Thêm vào danh sách đã lưu
     */
    @Transactional
    public BookmarkToggleResponse toggleBookmark(UUID userId, UUID heritageId) {
        if (userId == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Người dùng chưa xác thực!");
        }

        HeritageInfo heritage = heritageRepository.findById(heritageId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy di sản với ID: " + heritageId));

        Optional<SavedPlaceEntity> existing = savedPlaceRepository.findByUserIdAndHeritageId(userId, heritageId);

        if (existing.isPresent()) {
            savedPlaceRepository.delete(existing.get());
            log.info("User {} đã bỏ lưu di sản {}", userId, heritageId);
            return BookmarkToggleResponse.builder()
                    .heritageId(heritageId)
                    .bookmarked(false)
                    .message("Đã bỏ lưu di sản khỏi danh sách yêu thích.")
                    .build();
        } else {
            SavedPlaceEntity savedPlace = SavedPlaceEntity.builder()
                    .userId(userId)
                    .heritage(heritage)
                    .build();
            savedPlaceRepository.save(savedPlace);
            log.info("User {} đã lưu di sản {}", userId, heritageId);
            return BookmarkToggleResponse.builder()
                    .heritageId(heritageId)
                    .bookmarked(true)
                    .message("Đã lưu di sản vào danh sách yêu thích thành công.")
                    .build();
        }
    }

    /**
     * Lấy danh sách các di sản mà người dùng hiện tại đã lưu
     */
    @Transactional(readOnly = true)
    public List<HeritageResponseDTO> getUserBookmarks(UUID userId) {
        if (userId == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Người dùng chưa xác thực!");
        }

        List<HeritageInfo> savedList = savedPlaceRepository.findSavedHeritagesByUserId(userId);
        return savedList.stream()
                .map(HeritageResponseDTO::fromEntity)
                .toList();
    }
}
