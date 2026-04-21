package com.beautyshop.controller;

import com.beautyshop.entity.Salary;
import com.beautyshop.entity.Employee;
import com.beautyshop.service.SalaryService;
import com.beautyshop.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/salaries")
public class SalaryController {

    @Autowired
    private SalaryService salaryService;

    @Autowired
    private EmployeeService employeeService;

    @GetMapping
    public List<Salary> getAllSalaries() {
        return salaryService.getAllSalaries();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Salary> getSalaryById(@PathVariable Long id) {
        return salaryService.getSalaryById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/employee/{employeeId}")
    public List<Salary> getSalariesByEmployee(@PathVariable Long employeeId) {
        Employee employee = employeeService.getEmployeeById(employeeId).orElse(null);
        if (employee == null) {
            return null;
        }
        return salaryService.getSalariesByEmployee(employee);
    }

    @GetMapping("/year-month")
    public List<Salary> getSalariesByYearAndMonth(
            @RequestParam Integer year,
            @RequestParam Integer month) {
        return salaryService.getSalariesByYearAndMonth(year, month);
    }

    @GetMapping("/status/{status}")
    public List<Salary> getSalariesByStatus(@PathVariable String status) {
        return salaryService.getSalariesByStatus(status);
    }

    @PostMapping("/calculate")
    public ResponseEntity<Salary> calculateSalary(
            @RequestParam Long employeeId,
            @RequestParam Integer year,
            @RequestParam Integer month) {
        try {
            Salary salary = salaryService.calculateSalary(employeeId, year, month);
            return ResponseEntity.ok(salary);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @PostMapping("/calculate-all")
    public List<Salary> calculateAllSalaries(
            @RequestParam Integer year,
            @RequestParam Integer month) {
        List<Employee> employees = employeeService.getAllEmployees();
        for (Employee employee : employees) {
            try {
                salaryService.calculateSalary(employee.getId(), year, month);
            } catch (Exception e) {
                // Skip employees that fail
            }
        }
        return salaryService.getSalariesByYearAndMonth(year, month);
    }

    @PostMapping("/{id}/pay")
    public ResponseEntity<Salary> paySalary(@PathVariable Long id) {
        try {
            Salary salary = salaryService.paySalary(id);
            return ResponseEntity.ok(salary);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @PostMapping("/batch-pay")
    public ResponseEntity<Map<String, Object>> batchPaySalaries(@RequestBody List<Long> salaryIds) {
        int paidCount = 0;
        for (Long id : salaryIds) {
            try {
                salaryService.paySalary(id);
                paidCount++;
            } catch (Exception e) {
                // Skip failures
            }
        }
        Map<String, Object> result = new HashMap<>();
        result.put("total", salaryIds.size());
        result.put("paid", paidCount);
        return ResponseEntity.ok(result);
    }

    @PostMapping
    public Salary createSalary(@RequestBody Salary salary) {
        return salaryService.save(salary);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Salary> updateSalary(@PathVariable Long id, @RequestBody Salary salary) {
        return salaryService.getSalaryById(id)
                .map(existing -> {
                    salary.setId(id);
                    return ResponseEntity.ok(salaryService.save(salary));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteSalary(@PathVariable Long id) {
        salaryService.delete(id);
        return ResponseEntity.ok().build();
    }
}
