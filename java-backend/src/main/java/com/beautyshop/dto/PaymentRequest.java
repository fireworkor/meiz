package com.beautyshop.dto;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class PaymentRequest {
    private Long orderId;
    private String paymentType; // WXPAY, ALIPAY, MEMBERCARD
}
