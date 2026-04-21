package com.beautyshop.repository;

import com.beautyshop.entity.Customer;
import com.beautyshop.entity.MembershipCard;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface MembershipCardRepository extends JpaRepository<MembershipCard, Long> {
    List<MembershipCard> findByCustomer(Customer customer);
    List<MembershipCard> findByStatus(String status);
}