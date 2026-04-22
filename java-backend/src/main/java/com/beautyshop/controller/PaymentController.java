package com.beautyshop.controller;

import com.beautyshop.dto.PaymentRequest;
import com.beautyshop.dto.PaymentResponse;
import com.beautyshop.entity.PaymentRecord;
import com.beautyshop.service.PaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/payments")
public class PaymentController {
    
    @Autowired
    private PaymentService paymentService;
    
    // 创建支付
    @PostMapping("/create")
    public PaymentResponse createPayment(@RequestBody PaymentRequest request) {
        try {
            PaymentRecord payment = paymentService.createPayment(request);
            
            if ("MEMBERCARD".equals(request.getPaymentType())) {
                return paymentService.processMemberCard(payment);
            } else if ("WXPAY".equals(request.getPaymentType())) {
                return paymentService.createWxpay(payment);
            } else if ("ALIPAY".equals(request.getPaymentType())) {
                return paymentService.createAlipay(payment);
            } else {
                return PaymentResponse.fail("不支持的支付方式");
            }
        } catch (Exception e) {
            return PaymentResponse.fail(e.getMessage());
        }
    }
    
    // 查询支付状态
    @GetMapping("/status/{paymentNo}")
    public PaymentResponse queryPaymentStatus(@PathVariable String paymentNo) {
        return paymentService.queryPaymentStatus(paymentNo);
    }
    
    // 模拟支付成功回调（沙箱用）
    @PostMapping("/sandbox/{paymentNo}/success")
    public PaymentResponse sandboxSuccess(@PathVariable String paymentNo) {
        return paymentService.processPaymentSuccess(paymentNo);
    }
    
    // 微信支付回调
    @PostMapping("/wxpay/notify")
    public String wxpayNotify() {
        // 实际项目中实现微信回调验签和处理
        return "SUCCESS";
    }
    
    // 支付宝支付回调
    @PostMapping("/alipay/notify")
    public String alipayNotify() {
        // 实际项目中实现支付宝回调验签和处理
        return "success";
    }
}
