package com.beautyshop.repository;

import com.beautyshop.entity.BeautyService;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ServiceRepository extends JpaRepository<BeautyService, Long> {
    List<BeautyService> findByCategory(String category);
    List<BeautyService> findByStatus(String status);
    List<BeautyService> findByNameContaining(String name);
}
