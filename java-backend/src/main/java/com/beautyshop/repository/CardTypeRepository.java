package com.beautyshop.repository;

import com.beautyshop.entity.CardType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface CardTypeRepository extends JpaRepository<CardType, Long> {
    List<CardType> findByStatus(String status);
}