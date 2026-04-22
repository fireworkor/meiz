package com.beautyshop.entity;

import lombok.Data;
import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;

@Data
@Entity
@Table(name = "payment_record")
public class PaymentRecord {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "payment_no", unique = true, nullable = false, length = 32)
    private String paymentNo;

    @Column(name = "order_id", nullable = false)
    private Long orderId;

    @Column(name = "order_no", nullable = false, length = 32)
    private String orderNo;

    @Column(name = "payment_type", nullable = false, length = 20)
    private String paymentType; // WXPAY, ALIPAY, MEMBERCARD

    @Column(name = "total_amount", nullable = false, precision = 10, scale = 2)
    private BigDecimal totalAmount;

    @Column(name = "payment_status", nullable = false, length = 20)
    private String paymentStatus = "UNPAID"; // UNPAID, SUCCESS, FAILED, REFUNDED

    @Column(name = "transaction_id", length = 64)
    private String transactionId;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "pay_time")
    private Date payTime;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "create_time", nullable = false, updatable = false)
    private Date createTime;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "update_time", nullable = false)
    private Date updateTime;

    @PrePersist
    protected void onCreate() {
        createTime = new Date();
        updateTime = new Date();
    }

    @PreUpdate
    protected void onUpdate() {
        updateTime = new Date();
    }
}
