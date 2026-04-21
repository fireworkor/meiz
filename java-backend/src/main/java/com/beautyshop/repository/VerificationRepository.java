package com.beautyshop.repository;

import com.beautyshop.entity.Verification;
import com.beautyshop.entity.Customer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface VerificationRepository extends JpaRepository<Verification, Long> {
    Optional<Verification> findByVerificationCode(String verificationCode);

    List<Verification> findByCustomer(Customer customer);

    List<Verification> findByCustomerAndStatus(Customer customer, String status);

    List<Verification> findByStatus(String status);

    List<Verification> findByType(String type);

    List<Verification> findByRelatedIdAndType(Long relatedId, String type);
}
