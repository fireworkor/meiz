package com.beautyshop.service;

import com.beautyshop.entity.Reservation;
import com.beautyshop.entity.Customer;
import com.beautyshop.entity.Employee;
import com.beautyshop.repository.ReservationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
public class ReservationService {
    @Autowired
    private ReservationRepository reservationRepository;

    public Reservation createReservation(Reservation reservation) {
        reservation.setStatus("待确认");
        return reservationRepository.save(reservation);
    }

    public Optional<Reservation> getReservationById(Long id) {
        return reservationRepository.findById(id);
    }

    public List<Reservation> getAllReservations() {
        return reservationRepository.findAll();
    }

    public List<Reservation> getReservationsByCustomer(Customer customer) {
        return reservationRepository.findByCustomer(customer);
    }

    public List<Reservation> getReservationsByEmployee(Employee employee) {
        return reservationRepository.findByEmployee(employee);
    }

    public List<Reservation> getReservationsByDateRange(Date startDate, Date endDate) {
        return reservationRepository.findByReservationDateBetween(startDate, endDate);
    }

    public List<Reservation> getReservationsByStatus(String status) {
        return reservationRepository.findByStatus(status);
    }

    public List<Reservation> getEmployeeReservationsByDateRange(Employee employee, Date startDate, Date endDate) {
        return reservationRepository.findByEmployeeAndReservationDateBetween(employee, startDate, endDate);
    }

    public Reservation updateReservationStatus(Long id, String status) {
        Optional<Reservation> reservationOptional = reservationRepository.findById(id);
        if (reservationOptional.isPresent()) {
            Reservation reservation = reservationOptional.get();
            reservation.setStatus(status);
            return reservationRepository.save(reservation);
        }
        return null;
    }
}