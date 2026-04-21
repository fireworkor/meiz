package com.beautyshop.controller;

import com.beautyshop.dto.CouponRequest;
import com.beautyshop.entity.Coupon;
import com.beautyshop.entity.Customer;
import com.beautyshop.service.CouponService;
import com.beautyshop.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/coupons")
public class CouponController {
    @Autowired
    private CouponService couponService;

    @Autowired
    private CustomerService customerService;

    @GetMapping
    public List<Coupon> getAllCoupons() {
        return couponService.getAllCoupons();
    }

    @GetMapping("/{id}")
    public Optional<Coupon> getCouponById(@PathVariable Long id) {
        return couponService.getCouponById(id);
    }

    @PostMapping
    public Coupon createCoupon(@RequestBody CouponRequest request) {
        Coupon coupon = new Coupon();
        if (request.getCustomerId() != null) {
            Customer customer = customerService.getCustomerById(request.getCustomerId()).orElse(null);
            coupon.setCustomer(customer);
        }
        coupon.setCouponNumber(request.getCouponNumber());
        coupon.setName(request.getName());
        coupon.setType(request.getType());
        coupon.setDiscountAmount(request.getDiscountAmount());
        coupon.setMinAmount(request.getMinAmount());
        coupon.setDiscountRate(request.getDiscountRate());
        coupon.setIssueDate(request.getIssueDate());
        coupon.setExpiryDate(request.getExpiryDate());
        coupon.setStatus(request.getStatus());
        return couponService.saveCoupon(coupon);
    }

    @PutMapping("/{id}")
    public Coupon updateCoupon(@PathVariable Long id, @RequestBody CouponRequest request) {
        Optional<Coupon> existingCoupon = couponService.getCouponById(id);
        if (!existingCoupon.isPresent()) {
            return null;
        }
        Coupon coupon = existingCoupon.get();
        if (request.getCustomerId() != null) {
            Customer customer = customerService.getCustomerById(request.getCustomerId()).orElse(null);
            coupon.setCustomer(customer);
        }
        if (request.getCouponNumber() != null) {
            coupon.setCouponNumber(request.getCouponNumber());
        }
        if (request.getName() != null) {
            coupon.setName(request.getName());
        }
        if (request.getType() != null) {
            coupon.setType(request.getType());
        }
        if (request.getDiscountAmount() != null) {
            coupon.setDiscountAmount(request.getDiscountAmount());
        }
        if (request.getMinAmount() != null) {
            coupon.setMinAmount(request.getMinAmount());
        }
        if (request.getDiscountRate() != null) {
            coupon.setDiscountRate(request.getDiscountRate());
        }
        if (request.getExpiryDate() != null) {
            coupon.setExpiryDate(request.getExpiryDate());
        }
        if (request.getStatus() != null) {
            coupon.setStatus(request.getStatus());
        }
        return couponService.saveCoupon(coupon);
    }

    @DeleteMapping("/{id}")
    public void deleteCoupon(@PathVariable Long id) {
        couponService.deleteCoupon(id);
    }

    @PostMapping("/{id}/use")
    public Coupon useCoupon(@PathVariable Long id) {
        return couponService.useCoupon(id);
    }

    @GetMapping("/customer/{customerId}")
    public List<Coupon> getCouponsByCustomer(@PathVariable Long customerId) {
        Customer customer = customerService.getCustomerById(customerId).orElse(null);
        if (customer == null) {
            return null;
        }
        return couponService.getCouponsByCustomer(customer);
    }

    @GetMapping("/status/{status}")
    public List<Coupon> getCouponsByStatus(@PathVariable String status) {
        return couponService.getCouponsByStatus(status);
    }
}