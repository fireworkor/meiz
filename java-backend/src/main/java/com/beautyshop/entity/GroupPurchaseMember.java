package com.beautyshop.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;
import javax.persistence.*;
import java.util.Date;

@Data
@Entity
@Table(name = "group_purchase_members")
public class GroupPurchaseMember {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "group_purchase_id")
    @JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
    private GroupPurchase groupPurchase;

    @Column(name = "group_purchase_title")
    private String groupPurchaseTitle;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id")
    @JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
    private Customer customer;

    @Column(name = "customer_name")
    private String customerName;

    @Column(name = "customer_phone")
    private String customerPhone;

    @Column(name = "status")
    private String status = "pending";

    @Column(name = "is_leader")
    private Boolean isLeader = false;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "joined_at")
    private Date joinedAt;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "success_at")
    private Date successAt;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "failed_at")
    private Date failedAt;

    @Column(name = "failure_reason")
    private String failureReason;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "created_at")
    private Date createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = new Date();
        joinedAt = new Date();
    }
}
