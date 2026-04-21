package com.beautyshop.controller;

import com.beautyshop.entity.Order;
import com.beautyshop.service.OrderService;
import com.beautyshop.service.CustomerService;
import com.beautyshop.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/orders")
public class OrderController {
    @Autowired
    private OrderService orderService;

    @Autowired
    private CustomerService customerService;

    @Autowired
    private EmployeeService employeeService;

    @PostMapping
    public Order createOrder(@RequestBody Order order) {
        return orderService.createOrder(order);
    }

    @GetMapping("/{id}")
    public Optional<Order> getOrderById(@PathVariable Long id) {
        return orderService.getOrderById(id);
    }

    @GetMapping
    public List<Order> getAllOrders() {
        return orderService.getAllOrders();
    }

    @GetMapping("/customer/{customerId}")
    public List<Order> getOrdersByCustomer(@PathVariable Long customerId) {
        return orderService.getOrdersByCustomer(customerService.getCustomerById(customerId).orElse(null));
    }

    @GetMapping("/employee/{employeeId}")
    public List<Order> getOrdersByEmployee(@PathVariable Long employeeId) {
        return orderService.getOrdersByEmployee(employeeService.getEmployeeById(employeeId).orElse(null));
    }

    @GetMapping("/date-range")
    public List<Order> getOrdersByDateRange(@RequestParam Date startDate, @RequestParam Date endDate) {
        return orderService.getOrdersByDateRange(startDate, endDate);
    }

    @GetMapping("/status/{status}")
    public List<Order> getOrdersByStatus(@PathVariable String status) {
        return orderService.getOrdersByStatus(status);
    }

    @PutMapping("/{id}/status")
    public Order updateOrderStatus(@PathVariable Long id, @RequestParam String status) {
        return orderService.updateOrderStatus(id, status);
    }
}