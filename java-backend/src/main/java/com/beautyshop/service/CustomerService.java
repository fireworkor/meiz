package com.beautyshop.service;

import com.beautyshop.dto.CustomerRequest;
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

    public Customer createCustomer(CustomerRequest request) {
        Customer customer = new Customer();
        User user = new User();
        user.setUsername(request.getPhone());
        user.setName(request.getName());
        user.setPhone(request.getPhone());
        user.setRole("customer");
        userRepository.save(user);

        customer.setUser(user);
        customer.setName(request.getName());
        customer.setPhone(request.getPhone());
        customer.setGender(request.getGender());
        customer.setBirthday(request.getBirthday());
        customer.setWechat(request.getWechat());
        customer.setOccupation(request.getOccupation());
        customer.setSourceChannel(request.getSourceChannel());
        customer.setSkinType(request.getSkinType());
        customer.setAllergyHistory(request.getAllergyHistory());
        customer.setSkinProblems(request.getSkinProblems());
        customer.setPreferredItems(request.getPreferredItems());
        customer.setPreferredEmployee(request.getPreferredEmployee());
        customer.setPreferredTime(request.getPreferredTime());
        customer.setAverageSpending(request.getAverageSpending() != null ? request.getAverageSpending().doubleValue() : null);
        customer.setTags(request.getTags());

        return customerRepository.save(customer);
    }

    public Customer updateCustomer(Long id, CustomerRequest request) {
        Optional<Customer> existingOpt = customerRepository.findById(id);
        if (!existingOpt.isPresent()) {
            return null;
        }
        Customer customer = existingOpt.get();
        User user = customer.getUser();
        
        if (request.getName() != null) {
            user.setName(request.getName());
            customer.setName(request.getName());
        }
        if (request.getPhone() != null) {
            user.setPhone(request.getPhone());
            customer.setPhone(request.getPhone());
        }
        userRepository.save(user);
        
        if (request.getGender() != null) {
            customer.setGender(request.getGender());
        }
        if (request.getBirthday() != null) {
            customer.setBirthday(request.getBirthday());
        }
        if (request.getWechat() != null) {
            customer.setWechat(request.getWechat());
        }
        if (request.getOccupation() != null) {
            customer.setOccupation(request.getOccupation());
        }
        if (request.getSourceChannel() != null) {
            customer.setSourceChannel(request.getSourceChannel());
        }
        if (request.getSkinType() != null) {
            customer.setSkinType(request.getSkinType());
        }
        if (request.getAllergyHistory() != null) {
            customer.setAllergyHistory(request.getAllergyHistory());
        }
        if (request.getSkinProblems() != null) {
            customer.setSkinProblems(request.getSkinProblems());
        }
        if (request.getPreferredItems() != null) {
            customer.setPreferredItems(request.getPreferredItems());
        }
        if (request.getPreferredEmployee() != null) {
            customer.setPreferredEmployee(request.getPreferredEmployee());
        }
        if (request.getPreferredTime() != null) {
            customer.setPreferredTime(request.getPreferredTime());
        }
        if (request.getAverageSpending() != null) {
            customer.setAverageSpending(request.getAverageSpending().doubleValue());
        }
        if (request.getTags() != null) {
            customer.setTags(request.getTags());
        }
        
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