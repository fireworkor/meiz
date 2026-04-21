package com.beautyshop.service;

import com.beautyshop.entity.Commission;
import com.beautyshop.entity.Employee;
import com.beautyshop.repository.CommissionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
public class CommissionService {
    @Autowired
    private CommissionRepository commissionRepository;

    public Commission saveCommission(Commission commission) {
        return commissionRepository.save(commission);
    }

    public List<Commission> getAllCommissions() {
        return commissionRepository.findAll();
    }

    public Optional<Commission> getCommissionById(Long id) {
        return commissionRepository.findById(id);
    }

    public List<Commission> getCommissionsByEmployee(Employee employee) {
        return commissionRepository.findByEmployee(employee);
    }

    public List<Commission> getCommissionsByEmployeeAndDateRange(Employee employee, Date startDate, Date endDate) {
        return commissionRepository.findByEmployeeAndDateRange(employee, startDate, endDate);
    }

    public List<Commission> getCommissionsByStatus(String status) {
        return commissionRepository.findByStatus(status);
    }

    public BigDecimal sumAmountByEmployeeAndDateRange(Employee employee, Date startDate, Date endDate) {
        BigDecimal sum = commissionRepository.sumAmountByEmployeeAndDateRange(employee, startDate, endDate);
        return sum != null ? sum : BigDecimal.ZERO;
    }

    public void deleteCommission(Long id) {
        commissionRepository.deleteById(id);
    }

    public Commission updateCommissionStatus(Long id, String status) {
        Optional<Commission> commissionOpt = commissionRepository.findById(id);
        if (commissionOpt.isPresent()) {
            Commission commission = commissionOpt.get();
            commission.setStatus(status);
            return commissionRepository.save(commission);
        }
        return null;
    }
}