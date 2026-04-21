package com.beautyshop.repository;

import com.beautyshop.entity.Inventory;
import com.beautyshop.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface InventoryRepository extends JpaRepository<Inventory, Long> {
    List<Inventory> findByProduct(Product product);
    List<Inventory> findByQuantityLessThan(Integer quantity);

    @Query("SELECT i FROM Inventory i WHERE i.quantity < :threshold")
    List<Inventory> findLowStock(@Param("threshold") Integer threshold);

    @Query("SELECT i FROM Inventory i WHERE i.expiryDate IS NOT NULL AND i.expiryDate < :date")
    List<Inventory> findExpiringBefore(@Param("date") java.util.Date date);
}