package com.beautyshop.repository;

import com.beautyshop.entity.Employee;
import com.beautyshop.entity.Schedule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.Date;
import java.util.List;

@Repository
public interface ScheduleRepository extends JpaRepository<Schedule, Long> {
    List<Schedule> findByEmployee(Employee employee);

    @Query("SELECT s FROM Schedule s WHERE s.employee = :employee AND s.scheduleDate BETWEEN :startDate AND :endDate")
    List<Schedule> findByEmployeeAndDateRange(@Param("employee") Employee employee, @Param("startDate") Date startDate, @Param("endDate") Date endDate);

    @Query("SELECT s FROM Schedule s WHERE s.scheduleDate BETWEEN :startDate AND :endDate")
    List<Schedule> findByDateRange(@Param("startDate") Date startDate, @Param("endDate") Date endDate);

    @Query("SELECT s FROM Schedule s WHERE s.employee.id = :employeeId AND s.scheduleDate = :date")
    Schedule findByEmployeeAndDate(@Param("employeeId") Long employeeId, @Param("date") Date date);
}