package com.beautyshop.service;

import com.beautyshop.entity.Employee;
import com.beautyshop.entity.User;
import com.beautyshop.repository.EmployeeRepository;
import com.beautyshop.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class EmployeeService {
    @Autowired
    private EmployeeRepository employeeRepository;

    @Autowired
    private UserRepository userRepository;

    public List<Employee> getAllEmployees() {
        return employeeRepository.findAll();
    }

    public Optional<Employee> getEmployeeById(Long id) {
        return employeeRepository.findById(id);
    }

    public Employee saveEmployee(Employee employee) {
        // 先保存用户信息
        User user = employee.getUser();
        user.setRole("staff");
        User savedUser = userRepository.save(user);
        
        // 将保存后的用户对象设置回员工对象
        employee.setUser(savedUser);
        
        // 同步用户信息到员工表
        if (savedUser != null) {
            employee.setName(savedUser.getName());
            employee.setPhone(savedUser.getPhone());
        }
        
        // 再保存员工信息
        return employeeRepository.save(employee);
    }

    public void deleteEmployee(Long id) {
        employeeRepository.deleteById(id);
    }

    public List<Employee> getEmployeesByStatus(String status) {
        return employeeRepository.findByStatus(status);
    }

    public List<Employee> getEmployeesByPosition(String position) {
        return employeeRepository.findByPosition(position);
    }
}