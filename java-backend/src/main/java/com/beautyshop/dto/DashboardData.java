package com.beautyshop.dto;

import java.math.BigDecimal;
import java.util.List;

public class DashboardData {
    private BigDecimal todayRevenue;
    private BigDecimal monthRevenue;
    private Integer todayOrders;
    private Integer monthOrders;
    private Integer todayReservations;
    private Integer newCustomers;
    private List<EmployeePerformance> topEmployees;
    private List<ServiceStats> topServices;

    public BigDecimal getTodayRevenue() {
        return todayRevenue;
    }

    public void setTodayRevenue(BigDecimal todayRevenue) {
        this.todayRevenue = todayRevenue;
    }

    public BigDecimal getMonthRevenue() {
        return monthRevenue;
    }

    public void setMonthRevenue(BigDecimal monthRevenue) {
        this.monthRevenue = monthRevenue;
    }

    public Integer getTodayOrders() {
        return todayOrders;
    }

    public void setTodayOrders(Integer todayOrders) {
        this.todayOrders = todayOrders;
    }

    public Integer getMonthOrders() {
        return monthOrders;
    }

    public void setMonthOrders(Integer monthOrders) {
        this.monthOrders = monthOrders;
    }

    public Integer getTodayReservations() {
        return todayReservations;
    }

    public void setTodayReservations(Integer todayReservations) {
        this.todayReservations = todayReservations;
    }

    public Integer getNewCustomers() {
        return newCustomers;
    }

    public void setNewCustomers(Integer newCustomers) {
        this.newCustomers = newCustomers;
    }

    public List<EmployeePerformance> getTopEmployees() {
        return topEmployees;
    }

    public void setTopEmployees(List<EmployeePerformance> topEmployees) {
        this.topEmployees = topEmployees;
    }

    public List<ServiceStats> getTopServices() {
        return topServices;
    }

    public void setTopServices(List<ServiceStats> topServices) {
        this.topServices = topServices;
    }

    public static class EmployeePerformance {
        private Long employeeId;
        private String employeeName;
        private Integer orderCount;
        private BigDecimal totalAmount;

        public Long getEmployeeId() {
            return employeeId;
        }

        public void setEmployeeId(Long employeeId) {
            this.employeeId = employeeId;
        }

        public String getEmployeeName() {
            return employeeName;
        }

        public void setEmployeeName(String employeeName) {
            this.employeeName = employeeName;
        }

        public Integer getOrderCount() {
            return orderCount;
        }

        public void setOrderCount(Integer orderCount) {
            this.orderCount = orderCount;
        }

        public BigDecimal getTotalAmount() {
            return totalAmount;
        }

        public void setTotalAmount(BigDecimal totalAmount) {
            this.totalAmount = totalAmount;
        }
    }

    public static class ServiceStats {
        private Long serviceId;
        private String serviceName;
        private Integer count;
        private BigDecimal totalAmount;

        public Long getServiceId() {
            return serviceId;
        }

        public void setServiceId(Long serviceId) {
            this.serviceId = serviceId;
        }

        public String getServiceName() {
            return serviceName;
        }

        public void setServiceName(String serviceName) {
            this.serviceName = serviceName;
        }

        public Integer getCount() {
            return count;
        }

        public void setCount(Integer count) {
            this.count = count;
        }

        public BigDecimal getTotalAmount() {
            return totalAmount;
        }

        public void setTotalAmount(BigDecimal totalAmount) {
            this.totalAmount = totalAmount;
        }
    }
}