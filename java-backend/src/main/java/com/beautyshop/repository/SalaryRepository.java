package com.beautyshop.repository;

import com.beautyshop.entity.Salary;
import com.beautyshop.entity.Employee;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface SalaryRepository extends JpaRepository<Salary, Long> {
    List<Salary> findByEmployee(Employee employee);

    List<Salary> findByYearAndMonth(Integer year, Integer month);

    Optional<Salary> findByEmployeeAndYearAndMonth(Employee employee, Integer year, Integer month);

    List<Salary> findByStatus(String status);

    List<Salary> findByYearAndMonthAndStatus(Integer year, Integer month, String status);
}
