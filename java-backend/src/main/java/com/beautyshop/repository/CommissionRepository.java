package com.beautyshop.repository;

import com.beautyshop.entity.Commission;
import com.beautyshop.entity.Employee;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@Repository
public interface CommissionRepository extends JpaRepository<Commission, Long> {
    @Query("SELECT c FROM Commission c JOIN FETCH c.employee JOIN FETCH c.order WHERE c.employee = :employee")
    List<Commission> findByEmployee(@Param("employee") Employee employee);

    @Query("SELECT c FROM Commission c JOIN FETCH c.employee JOIN FETCH c.order WHERE c.employee = :employee AND c.status = :status")
    List<Commission> findByEmployeeAndStatus(@Param("employee") Employee employee, @Param("status") String status);

    @Query("SELECT c FROM Commission c JOIN FETCH c.employee JOIN FETCH c.order WHERE c.employee = :employee AND c.commissionDate BETWEEN :startDate AND :endDate")
    List<Commission> findByEmployeeAndDateRange(@Param("employee") Employee employee, @Param("startDate") Date startDate, @Param("endDate") Date endDate);

    @Query("SELECT c FROM Commission c JOIN FETCH c.employee JOIN FETCH c.order WHERE c.status = :status")
    List<Commission> findByStatus(@Param("status") String status);

    @Query("SELECT c FROM Commission c JOIN FETCH c.employee JOIN FETCH c.order")
    List<Commission> findAllWithFetch();

    @Query("SELECT SUM(c.amount) FROM Commission c WHERE c.employee = :employee AND c.commissionDate BETWEEN :startDate AND :endDate")
    BigDecimal sumAmountByEmployeeAndDateRange(@Param("employee") Employee employee, @Param("startDate") Date startDate, @Param("endDate") Date endDate);
}