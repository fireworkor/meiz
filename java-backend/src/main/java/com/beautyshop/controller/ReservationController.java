package com.beautyshop.controller;

import com.beautyshop.entity.Reservation;
import com.beautyshop.entity.Customer;
import com.beautyshop.entity.Employee;
import com.beautyshop.entity.BeautyService;
import com.beautyshop.entity.Room;
import com.beautyshop.service.ReservationService;
import com.beautyshop.service.CustomerService;
import com.beautyshop.service.EmployeeService;
import com.beautyshop.service.ServiceService;
import com.beautyshop.service.RoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/reservations")
public class ReservationController {
    @Autowired
    private ReservationService reservationService;

    @Autowired
    private CustomerService customerService;

    @Autowired
    private EmployeeService employeeService;

    @Autowired
    private ServiceService serviceService;

    @Autowired
    private RoomService roomService;

    @PostMapping
    public Reservation createReservation(@RequestBody Reservation reservation) {
        // 验证必要字段
        if (reservation.getReservationDate() == null) {
            throw new IllegalArgumentException("预约日期不能为空");
        }
        if (reservation.getSource() == null) {
            throw new IllegalArgumentException("预约来源不能为空");
        }
        
        // 处理客户关联
        if (reservation.getCustomer() == null || reservation.getCustomer().getId() == null) {
            throw new IllegalArgumentException("客户信息不能为空");
        }
        Optional<Customer> customer = customerService.getCustomerById(reservation.getCustomer().getId());
        if (!customer.isPresent()) {
            throw new IllegalArgumentException("客户不存在");
        }
        reservation.setCustomer(customer.get());
        
        // 处理员工关联
        if (reservation.getEmployee() == null || reservation.getEmployee().getId() == null) {
            throw new IllegalArgumentException("员工信息不能为空");
        }
        Optional<Employee> employee = employeeService.getEmployeeById(reservation.getEmployee().getId());
        if (!employee.isPresent()) {
            throw new IllegalArgumentException("员工不存在");
        }
        reservation.setEmployee(employee.get());
        
        // 处理服务关联
        if (reservation.getService() == null || reservation.getService().getId() == null) {
            throw new IllegalArgumentException("服务信息不能为空");
        }
        Optional<BeautyService> service = serviceService.getServiceById(reservation.getService().getId());
        if (!service.isPresent()) {
            throw new IllegalArgumentException("服务不存在");
        }
        reservation.setService(service.get());
        
        // 处理房间关联
        if (reservation.getRoom() == null || reservation.getRoom().getId() == null) {
            throw new IllegalArgumentException("房间信息不能为空");
        }
        Optional<Room> room = roomService.getRoomById(reservation.getRoom().getId());
        if (!room.isPresent()) {
            throw new IllegalArgumentException("房间不存在");
        }
        reservation.setRoom(room.get());
        
        return reservationService.createReservation(reservation);
    }

    @GetMapping("/{id}")
    public Optional<Reservation> getReservationById(@PathVariable Long id) {
        return reservationService.getReservationById(id);
    }

    @GetMapping
    public List<Reservation> getAllReservations() {
        return reservationService.getAllReservations();
    }

    @GetMapping("/customer/{customerId}")
    public List<Reservation> getReservationsByCustomer(@PathVariable Long customerId) {
        return reservationService.getReservationsByCustomer(customerService.getCustomerById(customerId).orElse(null));
    }

    @GetMapping("/employee/{employeeId}")
    public List<Reservation> getReservationsByEmployee(@PathVariable Long employeeId) {
        return reservationService.getReservationsByEmployee(employeeService.getEmployeeById(employeeId).orElse(null));
    }

    @GetMapping("/date-range")
    public List<Reservation> getReservationsByDateRange(@RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate, @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate) {
        return reservationService.getReservationsByDateRange(startDate, endDate);
    }

    @GetMapping("/status/{status}")
    public List<Reservation> getReservationsByStatus(@PathVariable String status) {
        return reservationService.getReservationsByStatus(status);
    }

    @GetMapping("/employee/{employeeId}/date-range")
    public List<Reservation> getEmployeeReservationsByDateRange(
            @PathVariable Long employeeId, 
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate, 
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate) {
        return reservationService.getEmployeeReservationsByDateRange(
                employeeService.getEmployeeById(employeeId).orElse(null), 
                startDate, 
                endDate);
    }

    @PutMapping("/{id}/status")
    public Reservation updateReservationStatus(@PathVariable Long id, @RequestParam String status) {
        return reservationService.updateReservationStatus(id, status);
    }
}