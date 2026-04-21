package com.beautyshop.repository;

import com.beautyshop.entity.MarketingActivity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface MarketingActivityRepository extends JpaRepository<MarketingActivity, Long> {
    List<MarketingActivity> findByStatus(String status);
}