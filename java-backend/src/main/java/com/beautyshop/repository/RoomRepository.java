package com.beautyshop.repository;

import com.beautyshop.entity.Room;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface RoomRepository extends JpaRepository<Room, Long> {
    List<Room> findByStatus(String status);
    List<Room> findByType(String type);
    
    @Query("SELECT r FROM Room r WHERE " +
           "(:keyword IS NULL OR :keyword = '' OR r.name LIKE %:keyword% OR r.description LIKE %:keyword%) " +
           "AND (:status IS NULL OR :status = '' OR r.status = :status) " +
           "AND (:type IS NULL OR :type = '' OR r.type = :type) " +
           "ORDER BY r.displayOrder ASC, r.id ASC")
    List<Room> searchRooms(@Param("keyword") String keyword, 
                          @Param("status") String status, 
                          @Param("type") String type);
    
    List<Room> findAllByOrderByDisplayOrderAscIdAsc();
}