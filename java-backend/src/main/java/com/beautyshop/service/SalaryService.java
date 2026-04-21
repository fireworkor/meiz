package com.beautyshop.service;

import com.beautyshop.entity.Salary;
import com.beautyshop.entity.Employee;
import com.beautyshop.entity.Commission;
import com.beautyshop.repository.SalaryRepository;
import com.beautyshop.repository.CommissionRepository;
import com.beautyshop.repository.EmployeeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
public class SalaryService {

    @Autowired
    private SalaryRepository salaryRepository;

    @Autowired
    private CommissionRepository commissionRepository;

    @Autowired
    private EmployeeRepository employeeRepository;

    public List<Salary> getAllSalaries() {
        return salaryRepository.findAll();
    }

    public Optional<Salary> getSalaryById(Long id) {
        return salaryRepository.findById(id);
    }

    public List<Salary> getSalariesByEmployee(Employee employee) {
        return salaryRepository.findByEmployee(employee);
    }

    public List<Salary> getSalariesByYearAndMonth(Integer year, Integer month) {
        return salaryRepository.findByYearAndMonth(year, month);
    }

    public Optional<Salary> getSalaryByEmployeeAndYearAndMonth(Employee employee, Integer year, Integer month) {
        return salaryRepository.findByEmployeeAndYearAndMonth(employee, year, month);
    }

    public List<Salary> getSalariesByStatus(String status) {
        return salaryRepository.findByStatus(status);
    }

    @Transactional
    public Salary calculateSalary(Long employeeId, Integer year, Integer month) {
        Employee employee = employeeRepository.findById(employeeId).orElse(null);
        if (employee == null) {
            throw new RuntimeException("Employee not found");
        }

        Optional<Salary> existingSalary = salaryRepository.findByEmployeeAndYearAndMonth(employee, year, month);
        if (existingSalary.isPresent()) {
            return existingSalary.get();
        }

        Salary salary = new Salary();
        salary.setEmployee(employee);
        salary.setYear(year);
        salary.setMonth(month);

        if (employee.getBaseSalary() != null) {
            salary.setBaseSalary(employee.getBaseSalary());
        } else {
            salary.setBaseSalary(BigDecimal.ZERO);
        }

        List<Commission> commissions = commissionRepository.findByEmployeeAndStatus(employee, "unpaid");
        BigDecimal totalCommission = commissions.stream()
                .map(Commission::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        salary.setCommission(totalCommission);

        salary.setBonus(BigDecimal.ZERO);
        salary.setFullAttendanceBonus(new BigDecimal("500"));

        salary.setSocialSecurity(new BigDecimal("800"));

        BigDecimal grossSalary = salary.getBaseSalary()
                .add(salary.getCommission())
                .add(salary.getBonus())
                .add(salary.getFullAttendanceBonus());
        BigDecimal tax = calculateTax(grossSalary.subtract(salary.getSocialSecurity()));
        salary.setTax(tax);

        salary.setOtherDeduction(BigDecimal.ZERO);

        BigDecimal netSalary = grossSalary
                .subtract(salary.getSocialSecurity())
                .subtract(tax)
                .subtract(salary.getOtherDeduction());
        salary.setNetSalary(netSalary);

        salary.setStatus("unpaid");

        return salaryRepository.save(salary);
    }

    private BigDecimal calculateTax(BigDecimal taxableIncome) {
        if (taxableIncome.compareTo(new BigDecimal("5000")) <= 0) {
            return BigDecimal.ZERO;
        } else if (taxableIncome.compareTo(new BigDecimal("10000")) <= 0) {
            return taxableIncome.subtract(new BigDecimal("5000")).multiply(new BigDecimal("0.1"));
        } else if (taxableIncome.compareTo(new BigDecimal("20000")) <= 0) {
            return new BigDecimal("500").add(taxableIncome.subtract(new BigDecimal("10000")).multiply(new BigDecimal("0.2")));
        } else if (taxableIncome.compareTo(new BigDecimal("50000")) <= 0) {
            return new BigDecimal("2500").add(taxableIncome.subtract(new BigDecimal("20000")).multiply(new BigDecimal("0.25")));
        } else {
            return new BigDecimal("10000").add(taxableIncome.subtract(new BigDecimal("50000")).multiply(new BigDecimal("0.3")));
        }
    }

    @Transactional
    public Salary save(Salary salary) {
        return salaryRepository.save(salary);
    }

    @Transactional
    public Salary paySalary(Long salaryId) {
        Salary salary = salaryRepository.findById(salaryId).orElse(null);
        if (salary == null) {
            throw new RuntimeException("Salary not found");
        }
        salary.setStatus("paid");
        salary.setPaidAt(new Date());
        return salaryRepository.save(salary);
    }

    @Transactional
    public void delete(Long id) {
        salaryRepository.deleteById(id);
    }
}
