package com.beautyshop.repository;

import com.beautyshop.entity.PaymentRecord;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface PaymentRecordRepository extends JpaRepository<PaymentRecord, Long> {
    Optional<PaymentRecord> findByPaymentNo(String paymentNo);
    Optional<PaymentRecord> findByOrderId(Long orderId);
    List<PaymentRecord> findByOrderNo(String orderNo);
    List<PaymentRecord> findByPaymentStatus(String paymentStatus);
}
