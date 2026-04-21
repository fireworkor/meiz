package com.beautyshop.repository;

import com.beautyshop.entity.Coupon;
import com.beautyshop.entity.Customer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface CouponRepository extends JpaRepository<Coupon, Long> {
    List<Coupon> findByCustomer(Customer customer);
    List<Coupon> findByStatus(String status);
}