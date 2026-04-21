package com.beautyshop.controller;

import com.beautyshop.entity.Order;
import com.beautyshop.entity.OrderItem;
import com.beautyshop.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.List;

@RestController
@RequestMapping("/api/orders")
public class OrderController {

    @Autowired
    private OrderService orderService;

    @GetMapping
    public List<Order> getAllOrders() {
        return orderService.getAllOrders();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Order> getOrderById(@PathVariable Long id) {
        return orderService.getOrderById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/customer/{customerId}")
    public List<Order> getOrdersByCustomer(@PathVariable Long customerId) {
        return orderService.getOrdersByCustomer(customerId);
    }

    @GetMapping("/status/{status}")
    public List<Order> getOrdersByStatus(@PathVariable String status) {
        return orderService.getOrdersByStatus(status);
    }

    @GetMapping("/date-range")
    public List<Order> getOrdersByDateRange(
            @RequestParam Date startDate,
            @RequestParam Date endDate) {
        return orderService.getOrdersByDateRange(startDate, endDate);
    }

    @PostMapping
    public Order createOrder(@RequestBody Order order) {
        return orderService.saveOrder(order);
    }

    @PostMapping("/checkout")
    public Order checkout(@RequestBody Order order) {
        return orderService.createOrder(order);
    }

    @PutMapping("/{id}/status")
    public ResponseEntity<Order> updateOrderStatus(@PathVariable Long id, @RequestParam String status) {
        return orderService.getOrderById(id)
                .map(order -> {
                    order.setStatus(status);
                    return ResponseEntity.ok(orderService.saveOrder(order));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @PutMapping("/{id}/pay")
    public ResponseEntity<Order> payOrder(@PathVariable Long id, @RequestParam String paymentMethod) {
        return orderService.getOrderById(id)
                .map(order -> {
                    order.setPaymentMethod(paymentMethod);
                    order.setStatus("paid");
                    return ResponseEntity.ok(orderService.saveOrder(order));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteOrder(@PathVariable Long id) {
        orderService.deleteOrder(id);
        return ResponseEntity.ok().build();
    }
}
