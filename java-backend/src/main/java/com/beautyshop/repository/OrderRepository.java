package com.beautyshop.repository;

import com.beautyshop.entity.Order;
import com.beautyshop.entity.Customer;
import com.beautyshop.entity.Employee;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Date;

public interface OrderRepository extends JpaRepository<Order, Long> {
    List<Order> findByCustomer(Customer customer);
    List<Order> findByEmployee(Employee employee);
    List<Order> findByOrderDateBetween(Date startDate, Date endDate);
    List<Order> findByStatus(String status);
}