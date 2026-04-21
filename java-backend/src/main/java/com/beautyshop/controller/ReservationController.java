package com.beautyshop.controller;

import com.beautyshop.entity.Reservation;
import com.beautyshop.service.ReservationService;
import com.beautyshop.service.CustomerService;
import com.beautyshop.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
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

    @PostMapping
    public Reservation createReservation(@RequestBody Reservation reservation) {
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
    public List<Reservation> getReservationsByDateRange(@RequestParam Date startDate, @RequestParam Date endDate) {
        return reservationService.getReservationsByDateRange(startDate, endDate);
    }

    @GetMapping("/status/{status}")
    public List<Reservation> getReservationsByStatus(@PathVariable String status) {
        return reservationService.getReservationsByStatus(status);
    }

    @GetMapping("/employee/{employeeId}/date-range")
    public List<Reservation> getEmployeeReservationsByDateRange(
            @PathVariable Long employeeId, 
            @RequestParam Date startDate, 
            @RequestParam Date endDate) {
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