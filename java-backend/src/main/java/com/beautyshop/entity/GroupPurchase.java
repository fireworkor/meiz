package com.beautyshop.entity;

import lombok.Data;
import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;

@Data
@Entity
@Table(name = "group_purchases")
public class GroupPurchase {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;
    private String subtitle;
    private String description;
    private String image;

    @Column(name = "original_price", precision = 10, scale = 2)
    private BigDecimal originalPrice = BigDecimal.ZERO;

    @Column(name = "group_price", precision = 10, scale = 2)
    private BigDecimal groupPrice = BigDecimal.ZERO;

    @Column(name = "min_members")
    private Integer minMembers = 2;

    @Column(name = "max_members")
    private Integer maxMembers = 10;

    @Column(name = "current_members")
    private Integer currentMembers = 0;

    @Column(name = "stock")
    private Integer stock = 100;

    @Column(name = "sold_count")
    private Integer soldCount = 0;

    @Temporal(TemporalType.DATE)
    @Column(name = "start_date")
    private Date startDate;

    @Temporal(TemporalType.DATE)
    @Column(name = "end_date")
    private Date endDate;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "group_deadline")
    private Date groupDeadline;

    @Column(name = "status")
    private String status = "pending";

    @Column(name = "category")
    private String category;

    @Column(name = "location")
    private String location;

    @Column(name = "validity_days")
    private Integer validityDays = 30;

    @Column(name = "details", length = 2000)
    private String details;

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
