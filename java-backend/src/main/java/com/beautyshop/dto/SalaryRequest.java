package com.beautyshop.dto;

import lombok.Data;

@Data
public class SalaryRequest {
    private Long employeeId;
    private Integer year;
    private Integer month;
    private String notes;
}
