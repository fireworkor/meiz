package com.beautyshop.service;

import com.beautyshop.dto.PaymentRequest;
import com.beautyshop.dto.PaymentResponse;
import com.beautyshop.entity.PaymentRecord;
import com.beautyshop.repository.PaymentRecordRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Date;
import java.util.UUID;

@Service
public class PaymentService {
    
    @Autowired
    private PaymentRecordRepository paymentRepository;
    
    @Autowired
    private OrderService orderService;
    
    // 创建支付记录
    @Transactional
    public PaymentRecord createPayment(PaymentRequest request) {
        PaymentRecord payment = new PaymentRecord();
        payment.setPaymentNo(generatePaymentNo());
        payment.setOrderId(request.getOrderId());
        payment.setOrderNo("ORD" + request.getOrderId());
        payment.setPaymentType(request.getPaymentType());
        payment.setPaymentStatus("UNPAID");
        payment.setTotalAmount(orderService.getOrderAmount(request.getOrderId()));
        return paymentRepository.save(payment);
    }
    
    // 会员卡支付
    @Transactional
    public PaymentResponse processMemberCard(PaymentRecord payment) {
        // 模拟会员卡支付成功
        payment.setPaymentStatus("SUCCESS");
        payment.setTransactionId("MEMBERCARD_" + System.currentTimeMillis());
        payment.setPayTime(new Date());
        paymentRepository.save(payment);
        
        // 更新订单状态
        orderService.updateOrderStatus(payment.getOrderId(), "PAID");
        
        return PaymentResponse.success(
            payment.getPaymentNo(),
            payment.getOrderNo(),
            payment.getPaymentType(),
            payment.getTotalAmount()
        );
    }
    
    // 模拟微信支付（返回沙箱URL）
    public PaymentResponse createWxpay(PaymentRecord payment) {
        PaymentResponse resp = PaymentResponse.success(
            payment.getPaymentNo(),
            payment.getOrderNo(),
            payment.getPaymentType(),
            payment.getTotalAmount()
        );
        resp.setMwebUrl("https://pay.weixin.qq.com/static/sandbox.html");
        resp.setPaymentUrl("https://pay.weixin.qq.com/static/sandbox.html");
        return resp;
    }
    
    // 模拟支付宝支付
    public PaymentResponse createAlipay(PaymentRecord payment) {
        PaymentResponse resp = PaymentResponse.success(
            payment.getPaymentNo(),
            payment.getOrderNo(),
            payment.getPaymentType(),
            payment.getTotalAmount()
        );
        resp.setAlipayUrl("https://open.alipay.com/sandbox.htm");
        resp.setPaymentUrl("https://open.alipay.com/sandbox.htm");
        return resp;
    }
    
    // 查询支付状态
    public PaymentResponse queryPaymentStatus(String paymentNo) {
        return paymentRepository.findByPaymentNo(paymentNo)
            .map(p -> {
                PaymentResponse resp = new PaymentResponse();
                resp.setPaymentNo(p.getPaymentNo());
                resp.setOrderNo(p.getOrderNo());
                resp.setStatus(p.getPaymentStatus());
                resp.setTotalAmount(p.getTotalAmount());
                return resp;
            })
            .orElse(PaymentResponse.fail("支付记录不存在"));
    }
    
    // 模拟支付成功（沙箱回调用）
    @Transactional
    public PaymentResponse processPaymentSuccess(String paymentNo) {
        return paymentRepository.findByPaymentNo(paymentNo)
            .map(p -> {
                if (!"UNPAID".equals(p.getPaymentStatus())) {
                    return PaymentResponse.fail("支付状态不是待支付");
                }
                p.setPaymentStatus("SUCCESS");
                p.setTransactionId(p.getPaymentType() + "_" + System.currentTimeMillis());
                p.setPayTime(new Date());
                paymentRepository.save(p);
                
                orderService.updateOrderStatus(p.getOrderId(), "PAID");
                
                return PaymentResponse.success(
                    p.getPaymentNo(),
                    p.getOrderNo(),
                    p.getPaymentType(),
                    p.getTotalAmount()
                );
            })
            .orElse(PaymentResponse.fail("支付记录不存在"));
    }
    
    private String generatePaymentNo() {
        return "PAY" + System.currentTimeMillis() + UUID.randomUUID().toString().substring(0, 4).toUpperCase();
    }
}
