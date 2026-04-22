package com.beautyshop.service;

import com.beautyshop.entity.Coupon;
import com.beautyshop.entity.Customer;
import com.beautyshop.repository.CouponRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
public class CouponService {
    @Autowired
    private CouponRepository couponRepository;

    public Coupon saveCoupon(Coupon coupon) {
        return couponRepository.save(coupon);
    }

    public List<Coupon> getAllCoupons() {
        List<Coupon> coupons = couponRepository.findAll();
        for (Coupon coupon : coupons) {
            updateExpiredStatus(coupon);
        }
        return coupons;
    }

    public Optional<Coupon> getCouponById(Long id) {
        Optional<Coupon> couponOpt = couponRepository.findById(id);
        if (couponOpt.isPresent()) {
            Coupon coupon = couponOpt.get();
            updateExpiredStatus(coupon);
        }
        return couponOpt;
    }

    public List<Coupon> getCouponsByCustomer(Customer customer) {
        List<Coupon> coupons = couponRepository.findByCustomer(customer);
        for (Coupon coupon : coupons) {
            updateExpiredStatus(coupon);
        }
        return coupons;
    }

    public List<Coupon> getCouponsByStatus(String status) {
        List<Coupon> coupons = couponRepository.findByStatus(status);
        for (Coupon coupon : coupons) {
            updateExpiredStatus(coupon);
        }
        return coupons;
    }

    public void deleteCoupon(Long id) {
        couponRepository.deleteById(id);
    }

    public Coupon useCoupon(Long id) {
        Optional<Coupon> couponOpt = couponRepository.findById(id);
        if (couponOpt.isPresent()) {
            Coupon coupon = couponOpt.get();
            if (!"unused".equals(coupon.getStatus())) {
                throw new RuntimeException("卡券状态不允许核销");
            }
            coupon.setStatus("used");
            coupon.setUsedDate(new Date());
            return couponRepository.save(coupon);
        }
        return null;
    }

    private void updateExpiredStatus(Coupon coupon) {
        if (coupon.getExpiryDate() != null && !"used".equals(coupon.getStatus())) {
            Date now = new Date();
            if (now.after(coupon.getExpiryDate())) {
                coupon.setStatus("expired");
            }
        }
    }
}