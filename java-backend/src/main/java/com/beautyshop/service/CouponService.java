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
        return couponRepository.findAll();
    }

    public Optional<Coupon> getCouponById(Long id) {
        return couponRepository.findById(id);
    }

    public List<Coupon> getCouponsByCustomer(Customer customer) {
        return couponRepository.findByCustomer(customer);
    }

    public List<Coupon> getCouponsByStatus(String status) {
        return couponRepository.findByStatus(status);
    }

    public void deleteCoupon(Long id) {
        couponRepository.deleteById(id);
    }

    public Coupon useCoupon(Long id) {
        Optional<Coupon> couponOpt = couponRepository.findById(id);
        if (couponOpt.isPresent()) {
            Coupon coupon = couponOpt.get();
            coupon.setStatus("已使用");
            coupon.setUsedDate(new Date());
            return couponRepository.save(coupon);
        }
        return null;
    }
}