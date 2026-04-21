package com.beautyshop.controller;

import com.beautyshop.entity.Verification;
import com.beautyshop.service.VerificationService;
import com.beautyshop.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/verifications")
public class VerificationController {

    @Autowired
    private VerificationService verificationService;

    @Autowired
    private CustomerService customerService;

    @GetMapping
    public List<Verification> getAllVerifications() {
        return verificationService.getAllVerifications();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Verification> getVerificationById(@PathVariable Long id) {
        return verificationService.getVerificationById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/code/{code}")
    public ResponseEntity<Verification> getVerificationByCode(@PathVariable String code) {
        return verificationService.getVerificationByCode(code)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/customer/{customerId}")
    public List<Verification> getVerificationsByCustomer(@PathVariable Long customerId) {
        return customerService.getCustomerById(customerId)
                .map(customer -> verificationService.getVerificationsByCustomer(customer))
                .orElse(null);
    }

    @GetMapping("/status/{status}")
    public List<Verification> getVerificationsByStatus(@PathVariable String status) {
        return verificationService.getVerificationsByStatus(status);
    }

    @GetMapping("/type/{type}")
    public List<Verification> getVerificationsByType(@PathVariable String type) {
        return verificationService.getVerificationsByType(type);
    }

    @GetMapping("/stats")
    public Map<String, Object> getVerificationStats() {
        return verificationService.getVerificationStats();
    }

    @PostMapping("/coupon")
    public ResponseEntity<Verification> createCouponVerification(@RequestBody Map<String, Object> request) {
        try {
            Long customerId = Long.valueOf(request.get("customerId").toString());
            String itemName = request.get("itemName").toString();
            Double amount = Double.valueOf(request.get("amount").toString());
            Verification verification = verificationService.createCouponVerification(customerId, itemName, amount);
            return ResponseEntity.ok(verification);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @PostMapping("/points")
    public ResponseEntity<Verification> createPointsVerification(@RequestBody Map<String, Object> request) {
        try {
            Long customerId = Long.valueOf(request.get("customerId").toString());
            String itemName = request.get("itemName").toString();
            Integer points = Integer.valueOf(request.get("points").toString());
            Verification verification = verificationService.createPointsVerification(customerId, itemName, points);
            return ResponseEntity.ok(verification);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @PostMapping("/product")
    public ResponseEntity<Verification> createProductVerification(@RequestBody Map<String, Object> request) {
        try {
            Long customerId = Long.valueOf(request.get("customerId").toString());
            String itemName = request.get("itemName").toString();
            Integer quantity = Integer.valueOf(request.get("quantity").toString());
            Double amount = Double.valueOf(request.get("amount").toString());
            Verification verification = verificationService.createProductVerification(customerId, itemName, quantity, amount);
            return ResponseEntity.ok(verification);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @PostMapping("/verify")
    public ResponseEntity<Map<String, Object>> verify(@RequestBody Map<String, Object> request) {
        try {
            String code = request.get("code").toString();
            Long employeeId = Long.valueOf(request.get("employeeId").toString());
            Verification verification = verificationService.verify(code, employeeId);

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("message", "核销成功");
            result.put("verification", verification);
            return ResponseEntity.ok(result);
        } catch (RuntimeException e) {
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(result);
        }
    }

    @PostMapping("/{id}/cancel")
    public ResponseEntity<Verification> cancelVerification(@PathVariable Long id) {
        try {
            Verification verification = verificationService.cancelVerification(id);
            return ResponseEntity.ok(verification);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteVerification(@PathVariable Long id) {
        verificationService.deleteVerification(id);
        return ResponseEntity.ok().build();
    }
}
