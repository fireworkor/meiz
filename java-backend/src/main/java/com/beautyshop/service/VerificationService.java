package com.beautyshop.service;

import com.beautyshop.entity.Verification;
import com.beautyshop.entity.Customer;
import com.beautyshop.entity.Employee;
import com.beautyshop.repository.VerificationRepository;
import com.beautyshop.repository.CustomerRepository;
import com.beautyshop.repository.EmployeeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

@Service
public class VerificationService {

    @Autowired
    private VerificationRepository verificationRepository;

    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    private EmployeeRepository employeeRepository;

    public List<Verification> getAllVerifications() {
        return verificationRepository.findAll();
    }

    public Optional<Verification> getVerificationById(Long id) {
        return verificationRepository.findById(id);
    }

    public Optional<Verification> getVerificationByCode(String code) {
        return verificationRepository.findByVerificationCode(code);
    }

    public List<Verification> getVerificationsByCustomer(Customer customer) {
        return verificationRepository.findByCustomer(customer);
    }

    public List<Verification> getVerificationsByStatus(String status) {
        return verificationRepository.findByStatus(status);
    }

    public List<Verification> getVerificationsByType(String type) {
        return verificationRepository.findByType(type);
    }

    public List<Verification> getVerificationsByCustomerId(Long customerId) {
        return customerRepository.findById(customerId)
                .map(verificationRepository::findByCustomer)
                .orElse(null);
    }

    public Map<String, Object> getVerificationStats() {
        List<Verification> all = verificationRepository.findAll();
        Map<String, Object> stats = new HashMap<>();
        stats.put("total", all.size());
        stats.put("unused", all.stream().filter(v -> "unused".equals(v.getStatus())).count());
        stats.put("used", all.stream().filter(v -> "used".equals(v.getStatus())).count());
        stats.put("cancelled", all.stream().filter(v -> "cancelled".equals(v.getStatus())).count());
        stats.put("todayUsed", all.stream().filter(v -> {
            if (v.getUsedAt() == null) return false;
            return isToday(v.getUsedAt());
        }).count());
        return stats;
    }

    private boolean isToday(Date date) {
        if (date == null) return false;
        Date today = new Date();
        return date.getYear() == today.getYear() &&
               date.getMonth() == today.getMonth() &&
               date.getDate() == today.getDate();
    }

    @Transactional
    public Verification createCouponVerification(Long customerId, String itemName, Double amount) {
        Customer customer = customerRepository.findById(customerId).orElse(null);
        if (customer == null) {
            throw new RuntimeException("Customer not found");
        }

        Verification verification = new Verification();
        verification.setVerificationCode(generateCode());
        verification.setCustomer(customer);
        verification.setCustomerName(customer.getName());
        verification.setCustomerPhone(customer.getPhone());
        verification.setType("coupon");
        verification.setItemName(itemName);
        verification.setAmount(amount);
        verification.setStatus("unused");

        return verificationRepository.save(verification);
    }

    @Transactional
    public Verification createPointsVerification(Long customerId, String itemName, Integer points) {
        Customer customer = customerRepository.findById(customerId).orElse(null);
        if (customer == null) {
            throw new RuntimeException("Customer not found");
        }

        Verification verification = new Verification();
        verification.setVerificationCode(generateCode());
        verification.setCustomer(customer);
        verification.setCustomerName(customer.getName());
        verification.setCustomerPhone(customer.getPhone());
        verification.setType("points");
        verification.setItemName(itemName);
        verification.setPoints(points);
        verification.setStatus("unused");

        return verificationRepository.save(verification);
    }

    @Transactional
    public Verification createProductVerification(Long customerId, String itemName, Integer quantity, Double amount) {
        Customer customer = customerRepository.findById(customerId).orElse(null);
        if (customer == null) {
            throw new RuntimeException("Customer not found");
        }

        Verification verification = new Verification();
        verification.setVerificationCode(generateCode());
        verification.setCustomer(customer);
        verification.setCustomerName(customer.getName());
        verification.setCustomerPhone(customer.getPhone());
        verification.setType("product");
        verification.setItemName(itemName);
        verification.setQuantity(quantity);
        verification.setAmount(amount);
        verification.setStatus("unused");

        return verificationRepository.save(verification);
    }

    @Transactional
    public Verification verify(String code, Long employeeId) {
        Verification verification = verificationRepository.findByVerificationCode(code).orElse(null);
        if (verification == null) {
            throw new RuntimeException("Verification code not found");
        }

        if ("used".equals(verification.getStatus())) {
            throw new RuntimeException("Verification code already used");
        }

        Employee employee = employeeRepository.findById(employeeId).orElse(null);
        if (employee == null) {
            throw new RuntimeException("Employee not found");
        }

        verification.setStatus("used");
        verification.setUsedAt(new Date());
        verification.setEmployee(employee);
        verification.setEmployeeName(employee.getName() != null ? employee.getName() : "Staff");

        return verificationRepository.save(verification);
    }

    @Transactional
    public Verification cancelVerification(Long id) {
        Verification verification = verificationRepository.findById(id).orElse(null);
        if (verification == null) {
            throw new RuntimeException("Verification not found");
        }

        verification.setStatus("cancelled");
        return verificationRepository.save(verification);
    }

    @Transactional
    public void deleteVerification(Long id) {
        verificationRepository.deleteById(id);
    }

    private String generateCode() {
        return "VS" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }
}
