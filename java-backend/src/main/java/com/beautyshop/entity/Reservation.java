package com.beautyshop.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;
import javax.persistence.*;
import java.util.Date;

@Data
@Entity
@Table(name = "reservations")
public class Reservation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "customer_id")
    @JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
    private Customer customer;

    @ManyToOne
    @JoinColumn(name = "employee_id")
    @JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
    private Employee employee;

    @ManyToOne
    @JoinColumn(name = "service_id")
    @JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
    private BeautyService service;

    @ManyToOne
    @JoinColumn(name = "room_id")
    @JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
    private Room room;

    private Date reservationDate;
    private String status; // 待确认/已确认/已到店/已完成/已取消/爽约
    private String source; // 前台代约/顾客自助预约

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