package com.beautyshop.service;

import com.beautyshop.entity.Customer;
import com.beautyshop.entity.User;
import com.beautyshop.repository.CustomerRepository;
import com.beautyshop.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class CustomerService {
    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    private UserRepository userRepository;

    public List<Customer> getAllCustomers() {
        return customerRepository.findAll();
    }

    public Optional<Customer> getCustomerById(Long id) {
        return customerRepository.findById(id);
    }

    public Customer saveCustomer(Customer customer) {
        // 先保存用户信息
        User user = customer.getUser();
        user.setRole("customer");
        userRepository.save(user);
        // 再保存顾客信息
        return customerRepository.save(customer);
    }

    public void deleteCustomer(Long id) {
        customerRepository.deleteById(id);
    }

    public List<Customer> getCustomersByGender(String gender) {
        return customerRepository.findByGender(gender);
    }

    public List<Customer> getCustomersByTag(String tag) {
        return customerRepository.findByTagsContaining(tag);
    }

    public Customer getCustomerByPhone(String phone) {
        return customerRepository.findByUserPhone(phone);
    }

    public List<Customer> getCustomersBySourceChannel(String sourceChannel) {
        return customerRepository.findBySourceChannel(sourceChannel);
    }
}