package com.beautyshop.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;
import javax.persistence.*;
import java.util.Date;

@Data
@Entity
@Table(name = "customers")
public class Customer {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    @JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
    private User user;

    private String name;
    private String phone;
    private String level;
    private Integer points;

    private Date birthday;
    private String gender;
    private String wechat;
    private String occupation;
    private String sourceChannel;
    private String skinType;
    private String allergyHistory;
    private String skinProblems;
    private String preferredItems;
    private String preferredEmployee;
    private String preferredTime;
    private Double averageSpending;
    private String tags;

    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;

    @Temporal(TemporalType.TIMESTAMP)
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