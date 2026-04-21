package com.beautyshop.repository;

import com.beautyshop.entity.Employee;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface EmployeeRepository extends JpaRepository<Employee, Long> {
    List<Employee> findByStatus(String status);
    Employee findByEmployeeId(String employeeId);
    List<Employee> findByPosition(String position);
}