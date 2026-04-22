package com.beautyshop.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;
import javax.persistence.*;
import java.util.Date;

@Data
@Entity
@Table(name = "verifications")
public class Verification {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "verification_code", unique = true)
    private String verificationCode;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id")
    @JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
    private Customer customer;

    @Column(name = "customer_name")
    private String customerName;

    @Column(name = "customer_phone")
    private String customerPhone;

    @Column(name = "type")
    private String type;

    @Column(name = "related_id")
    private Long relatedId;

    @Column(name = "item_name")
    private String itemName;

    @Column(name = "quantity")
    private Integer quantity = 1;

    @Column(name = "points")
    private Integer points = 0;

    @Column(name = "amount")
    private Double amount = 0.0;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "employee_id")
    @JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
    private Employee employee;

    @Column(name = "employee_name")
    private String employeeName;

    @Column(name = "status")
    private String status = "unused";

    @Column(name = "used_at")
    private Date usedAt;

    @Column(name = "notes", length = 500)
    private String notes;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "created_at")
    private Date createdAt;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "updated_at")
    private Date updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = new Date();
        updatedAt = new Date();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = new Date();
    }
}
