package com.beautyshop.controller;

import com.beautyshop.dto.DashboardData;
import com.beautyshop.entity.*;
import com.beautyshop.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.math.BigDecimal;
import java.util.*;

@RestController
@RequestMapping("/api/dashboard")
public class DashboardController {
    @Autowired
    private OrderService orderService;

    @Autowired
    private ReservationService reservationService;

    @Autowired
    private CustomerService customerService;

    @Autowired
    private EmployeeService employeeService;

    @GetMapping("/data")
    public DashboardData getDashboardData() {
        DashboardData data = new DashboardData();

        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        Date todayStart = calendar.getTime();

        calendar.add(Calendar.MONTH, 1);
        Date monthStart = calendar.getTime();
        calendar.add(Calendar.MONTH, -1);
        calendar.add(Calendar.DAY_OF_MONTH, 1);
        Date monthEnd = calendar.getTime();

        List<Order> allOrders = orderService.getAllOrders();
        List<Order> monthOrders = new ArrayList<>();
        List<Order> todayOrders = new ArrayList<>();

        for (Order order : allOrders) {
            Date orderDate = order.getOrderDate();
            if (orderDate != null) {
                if (orderDate.compareTo(monthStart) >= 0 && orderDate.compareTo(monthEnd) < 0) {
                    monthOrders.add(order);
                }
                if (orderDate.compareTo(todayStart) >= 0) {
                    todayOrders.add(order);
                }
            }
        }

        BigDecimal todayRevenue = BigDecimal.ZERO;
        for (Order order : todayOrders) {
            if (order.getTotalAmount() != null) {
                todayRevenue = todayRevenue.add(BigDecimal.valueOf(order.getTotalAmount()));
            }
        }

        BigDecimal monthRevenue = BigDecimal.ZERO;
        for (Order order : monthOrders) {
            if (order.getTotalAmount() != null) {
                monthRevenue = monthRevenue.add(BigDecimal.valueOf(order.getTotalAmount()));
            }
        }

        data.setTodayRevenue(todayRevenue);
        data.setMonthRevenue(monthRevenue);
        data.setTodayOrders(todayOrders.size());
        data.setMonthOrders(monthOrders.size());

        List<Reservation> allReservations = reservationService.getAllReservations();
        int todayReservations = 0;
        for (Reservation reservation : allReservations) {
            Date reservationDate = reservation.getReservationDate();
            if (reservationDate != null && reservationDate.compareTo(todayStart) >= 0) {
                todayReservations++;
            }
        }
        data.setTodayReservations(todayReservations);

        List<Customer> allCustomers = customerService.getAllCustomers();
        int newCustomers = 0;
        for (Customer customer : allCustomers) {
            data.setNewCustomers(0);
        }
        data.setNewCustomers(newCustomers);

        return data;
    }

    @GetMapping("/employee-performance")
    public List<DashboardData.EmployeePerformance> getEmployeePerformance() {
        List<DashboardData.EmployeePerformance> performances = new ArrayList<>();
        List<Employee> employees = employeeService.getAllEmployees();
        List<Order> allOrders = orderService.getAllOrders();

        Map<Long, Integer> orderCountMap = new HashMap<>();
        Map<Long, BigDecimal> amountMap = new HashMap<>();

        for (Employee employee : employees) {
            orderCountMap.put(employee.getId(), 0);
            amountMap.put(employee.getId(), BigDecimal.ZERO);
        }

        for (Order order : allOrders) {
            if (order.getEmployee() != null) {
                Long employeeId = order.getEmployee().getId();
                orderCountMap.put(employeeId, orderCountMap.getOrDefault(employeeId, 0) + 1);
                amountMap.put(employeeId, amountMap.getOrDefault(employeeId, BigDecimal.ZERO).add(BigDecimal.valueOf(order.getTotalAmount())));
            }
        }

        for (Employee employee : employees) {
            DashboardData.EmployeePerformance performance = new DashboardData.EmployeePerformance();
            performance.setEmployeeId(employee.getId());
            performance.setEmployeeName(employee.getUser() != null ? employee.getUser().getName() : "");
            performance.setOrderCount(orderCountMap.get(employee.getId()));
            performance.setTotalAmount(amountMap.get(employee.getId()));
            performances.add(performance);
        }

        performances.sort((a, b) -> b.getTotalAmount().compareTo(a.getTotalAmount()));
        return performances.size() > 10 ? performances.subList(0, 10) : performances;
    }
}