package com.beautyshop.repository;

import com.beautyshop.entity.Employee;
import com.beautyshop.entity.Shift;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ShiftRepository extends JpaRepository<Shift, Long> {
    List<Shift> findByEmployee(Employee employee);
    List<Shift> findByStatus(String status);
    List<Shift> findByEmployeeAndStatus(Employee employee, String status);
}