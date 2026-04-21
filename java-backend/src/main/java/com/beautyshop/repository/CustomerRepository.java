package com.beautyshop.repository;

import com.beautyshop.entity.Customer;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface CustomerRepository extends JpaRepository<Customer, Long> {
    List<Customer> findByGender(String gender);
    List<Customer> findByTagsContaining(String tag);
    Customer findByUserPhone(String phone);
    List<Customer> findBySourceChannel(String sourceChannel);
}