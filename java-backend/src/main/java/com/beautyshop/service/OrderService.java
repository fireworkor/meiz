package com.beautyshop.service;

import com.beautyshop.entity.Order;
import com.beautyshop.entity.OrderItem;
import com.beautyshop.entity.Customer;
import com.beautyshop.entity.Employee;
import com.beautyshop.repository.OrderRepository;
import com.beautyshop.repository.CustomerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
public class OrderService {
    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private CustomerRepository customerRepository;

    public Order createOrder(Order order) {
        order.setOrderDate(new Date());
        order.setStatus("待支付");

        // 计算总金额
        double totalAmount = 0;
        for (OrderItem item : order.getOrderItems()) {
            totalAmount += item.getPrice() * item.getQuantity();
            item.setOrder(order);
        }
        order.setTotalAmount(totalAmount);

        return orderRepository.save(order);
    }

    public Optional<Order> getOrderById(Long id) {
        return orderRepository.findById(id);
    }

    public List<Order> getAllOrders() {
        return orderRepository.findAll();
    }

    public List<Order> getOrdersByCustomer(Long customerId) {
        Optional<Customer> customer = customerRepository.findById(customerId);
        return customer.map(orderRepository::findByCustomer).orElse(null);
    }

    public List<Order> getOrdersByCustomer(Customer customer) {
        return orderRepository.findByCustomer(customer);
    }

    public List<Order> getOrdersByEmployee(Employee employee) {
        return orderRepository.findByEmployee(employee);
    }

    public List<Order> getOrdersByDateRange(Date startDate, Date endDate) {
        return orderRepository.findByOrderDateBetween(startDate, endDate);
    }

    public List<Order> getOrdersByStatus(String status) {
        return orderRepository.findByStatus(status);
    }

    public Order saveOrder(Order order) {
        // 确保订单日期和状态
        if (order.getOrderDate() == null) {
            order.setOrderDate(new Date());
        }
        if (order.getStatus() == null) {
            order.setStatus("待支付");
        }

        // 计算总金额并设置order引用
        double totalAmount = 0;
        if (order.getOrderItems() != null) {
            for (OrderItem item : order.getOrderItems()) {
                totalAmount += item.getPrice() * item.getQuantity();
                item.setOrder(order);
                // 清除OrderItem的id，确保Hibernate将其视为新实体
                item.setId(null);
            }
        }
        order.setTotalAmount(totalAmount);

        return orderRepository.save(order);
    }

    public void deleteOrder(Long id) {
        orderRepository.deleteById(id);
    }

    public Order updateOrderStatus(Long id, String status) {
        Optional<Order> orderOptional = orderRepository.findById(id);
        if (orderOptional.isPresent()) {
            Order order = orderOptional.get();
            order.setStatus(status);
            return orderRepository.save(order);
        }
        return null;
    }
    
    public BigDecimal getOrderAmount(Long orderId) {
        Optional<Order> orderOptional = orderRepository.findById(orderId);
        if (orderOptional.isPresent()) {
            Order order = orderOptional.get();
            if (order.getTotalAmount() != null) {
                return BigDecimal.valueOf(order.getTotalAmount());
            }
        }
        return BigDecimal.ZERO;
    }
}