package com.beautyshop.controller;

import com.beautyshop.dto.CustomerRequest;
import com.beautyshop.entity.Customer;
import com.beautyshop.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/customers")
public class CustomerController {
    @Autowired
    private CustomerService customerService;

    @GetMapping
    public List<Customer> getAllCustomers() {
        return customerService.getAllCustomers();
    }

    @GetMapping("/{id}")
    public Optional<Customer> getCustomerById(@PathVariable Long id) {
        return customerService.getCustomerById(id);
    }

    @PostMapping
    public Customer createCustomer(@RequestBody CustomerRequest request) {
        return customerService.createCustomer(request);
    }

    @PutMapping("/{id}")
    public Customer updateCustomer(@PathVariable Long id, @RequestBody CustomerRequest request) {
        return customerService.updateCustomer(id, request);
    }

    @DeleteMapping("/{id}")
    public void deleteCustomer(@PathVariable Long id) {
        customerService.deleteCustomer(id);
    }

    @GetMapping("/gender/{gender}")
    public List<Customer> getCustomersByGender(@PathVariable String gender) {
        return customerService.getCustomersByGender(gender);
    }

    @GetMapping("/tag/{tag}")
    public List<Customer> getCustomersByTag(@PathVariable String tag) {
        return customerService.getCustomersByTag(tag);
    }

    @GetMapping("/phone/{phone}")
    public Customer getCustomerByPhone(@PathVariable String phone) {
        return customerService.getCustomerByPhone(phone);
    }

    @GetMapping("/source/{sourceChannel}")
    public List<Customer> getCustomersBySourceChannel(@PathVariable String sourceChannel) {
        return customerService.getCustomersBySourceChannel(sourceChannel);
    }
}