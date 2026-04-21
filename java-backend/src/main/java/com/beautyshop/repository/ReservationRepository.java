package com.beautyshop.repository;

import com.beautyshop.entity.Reservation;
import com.beautyshop.entity.Customer;
import com.beautyshop.entity.Employee;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Date;

public interface ReservationRepository extends JpaRepository<Reservation, Long> {
    List<Reservation> findByCustomer(Customer customer);
    List<Reservation> findByEmployee(Employee employee);
    List<Reservation> findByReservationDateBetween(Date startDate, Date endDate);
    List<Reservation> findByStatus(String status);
    List<Reservation> findByEmployeeAndReservationDateBetween(Employee employee, Date startDate, Date endDate);
}