package com.beautyshop.entity;

import lombok.Data;
import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;

@Data
@Entity
@Table(name = "salaries")
public class Salary {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "employee_id", nullable = false)
    private Employee employee;

    @Column(name = "year", nullable = false)
    private Integer year;

    @Column(name = "month", nullable = false)
    private Integer month;

    @Column(name = "base_salary", precision = 10, scale = 2)
    private BigDecimal baseSalary = BigDecimal.ZERO;

    @Column(name = "commission", precision = 10, scale = 2)
    private BigDecimal commission = BigDecimal.ZERO;

    @Column(name = "bonus", precision = 10, scale = 2)
    private BigDecimal bonus = BigDecimal.ZERO;

    @Column(name = "full_attendance_bonus", precision = 10, scale = 2)
    private BigDecimal fullAttendanceBonus = BigDecimal.ZERO;

    @Column(name = "social_security", precision = 10, scale = 2)
    private BigDecimal socialSecurity = BigDecimal.ZERO;

    @Column(name = "tax", precision = 10, scale = 2)
    private BigDecimal tax = BigDecimal.ZERO;

    @Column(name = "other_deduction", precision = 10, scale = 2)
    private BigDecimal otherDeduction = BigDecimal.ZERO;

    @Column(name = "net_salary", precision = 10, scale = 2)
    private BigDecimal netSalary = BigDecimal.ZERO;

    @Column(name = "status")
    private String status = "unpaid";

    @Column(name = "paid_at")
    private Date paidAt;

    @Column(name = "notes", length = 500)
    private String notes;

    @Column(name = "created_at")
    private Date createdAt;

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
