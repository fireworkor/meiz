package com.beautyshop.dto;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class PaymentResponse {
    private String code;
    private String message;
    private String paymentNo;
    private String orderNo;
    private String paymentType;
    private BigDecimal totalAmount;
    private String paymentUrl;
    private String mwebUrl;
    private String alipayUrl;
    private String status;
    
    public static PaymentResponse success(String paymentNo, String orderNo, String paymentType, BigDecimal amount) {
        PaymentResponse resp = new PaymentResponse();
        resp.setCode("200");
        resp.setMessage("success");
        resp.setPaymentNo(paymentNo);
        resp.setOrderNo(orderNo);
        resp.setPaymentType(paymentType);
        resp.setTotalAmount(amount);
        resp.setStatus("SUCCESS");
        return resp;
    }
    
    public static PaymentResponse fail(String message) {
        PaymentResponse resp = new PaymentResponse();
        resp.setCode("400");
        resp.setMessage(message);
        resp.setStatus("FAILED");
        return resp;
    }
}
