package com.beautyshop.repository;

import com.beautyshop.entity.Attendance;
import com.beautyshop.entity.Employee;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Date;

public interface AttendanceRepository extends JpaRepository<Attendance, Long> {
    List<Attendance> findByEmployee(Employee employee);
    List<Attendance> findByEmployeeAndCheckInTimeBetween(Employee employee, Date startDate, Date endDate);
}