package com.beautyshop.controller;

import com.beautyshop.dto.CommissionRequest;
import com.beautyshop.entity.Commission;
import com.beautyshop.entity.Employee;
import com.beautyshop.entity.Order;
import com.beautyshop.service.CommissionService;
import com.beautyshop.service.EmployeeService;
import com.beautyshop.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/commissions")
public class CommissionController {
    @Autowired
    private CommissionService commissionService;

    @Autowired
    private EmployeeService employeeService;

    @Autowired
    private OrderService orderService;

    @GetMapping
    public List<Commission> getAllCommissions() {
        return commissionService.getAllCommissions();
    }

    @GetMapping("/{id}")
    public Optional<Commission> getCommissionById(@PathVariable Long id) {
        return commissionService.getCommissionById(id);
    }

    @PostMapping
    public Commission createCommission(@RequestBody CommissionRequest request) {
        Employee employee = employeeService.getEmployeeById(request.getEmployeeId()).orElse(null);
        if (employee == null) {
            return null;
        }
        Order order = orderService.getOrderById(request.getOrderId()).orElse(null);
        if (order == null) {
            return null;
        }
        Commission commission = new Commission();
        commission.setEmployee(employee);
        commission.setOrder(order);
        commission.setCommissionType(request.getCommissionType());
        commission.setAmount(request.getAmount());
        commission.setCommissionDate(request.getCommissionDate());
        commission.setStatus(request.getStatus());
        return commissionService.saveCommission(commission);
    }

    @PutMapping("/{id}")
    public Commission updateCommission(@PathVariable Long id, @RequestBody CommissionRequest request) {
        Optional<Commission> existingCommission = commissionService.getCommissionById(id);
        if (!existingCommission.isPresent()) {
            return null;
        }
        Commission commission = existingCommission.get();
        if (request.getEmployeeId() != null) {
            Employee employee = employeeService.getEmployeeById(request.getEmployeeId()).orElse(null);
            commission.setEmployee(employee);
        }
        if (request.getOrderId() != null) {
            Order order = orderService.getOrderById(request.getOrderId()).orElse(null);
            commission.setOrder(order);
        }
        if (request.getCommissionType() != null) {
            commission.setCommissionType(request.getCommissionType());
        }
        if (request.getAmount() != null) {
            commission.setAmount(request.getAmount());
        }
        if (request.getCommissionDate() != null) {
            commission.setCommissionDate(request.getCommissionDate());
        }
        if (request.getStatus() != null) {
            commission.setStatus(request.getStatus());
        }
        return commissionService.saveCommission(commission);
    }

    @DeleteMapping("/{id}")
    public void deleteCommission(@PathVariable Long id) {
        commissionService.deleteCommission(id);
    }

    @GetMapping("/employee/{employeeId}")
    public List<Commission> getCommissionsByEmployee(@PathVariable Long employeeId) {
        Employee employee = employeeService.getEmployeeById(employeeId).orElse(null);
        if (employee == null) {
            return null;
        }
        return commissionService.getCommissionsByEmployee(employee);
    }

    @GetMapping("/employee/{employeeId}/date-range")
    public List<Commission> getCommissionsByEmployeeAndDateRange(
            @PathVariable Long employeeId,
            @RequestParam Date startDate,
            @RequestParam Date endDate) {
        Employee employee = employeeService.getEmployeeById(employeeId).orElse(null);
        if (employee == null) {
            return null;
        }
        return commissionService.getCommissionsByEmployeeAndDateRange(employee, startDate, endDate);
    }

    @GetMapping("/employee/{employeeId}/summary")
    public BigDecimal getCommissionSummary(
            @PathVariable Long employeeId,
            @RequestParam Date startDate,
            @RequestParam Date endDate) {
        Employee employee = employeeService.getEmployeeById(employeeId).orElse(null);
        if (employee == null) {
            return BigDecimal.ZERO;
        }
        return commissionService.sumAmountByEmployeeAndDateRange(employee, startDate, endDate);
    }

    @GetMapping("/status/{status}")
    public List<Commission> getCommissionsByStatus(@PathVariable String status) {
        return commissionService.getCommissionsByStatus(status);
    }

    @PutMapping("/{id}/status")
    public Commission updateCommissionStatus(@PathVariable Long id, @RequestParam String status) {
        return commissionService.updateCommissionStatus(id, status);
    }
}