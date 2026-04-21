package com.beautyshop.repository;

import com.beautyshop.entity.GroupPurchase;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.Date;
import java.util.List;

@Repository
public interface GroupPurchaseRepository extends JpaRepository<GroupPurchase, Long> {
    List<GroupPurchase> findByStatus(String status);

    List<GroupPurchase> findByCategory(String category);

    List<GroupPurchase> findByStatusOrderByCreatedAtDesc(String status);

    @Query("SELECT g FROM GroupPurchase g WHERE g.status = 'active' AND g.startDate <= :date AND g.endDate >= :date")
    List<GroupPurchase> findActiveGroupPurchases(@Param("date") Date date);

    @Query("SELECT g FROM GroupPurchase g WHERE g.status = 'active' AND g.stock > 0")
    List<GroupPurchase> findAvailableGroupPurchases();
}
