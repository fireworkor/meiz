package com.beautyshop.service;

import com.beautyshop.entity.Employee;
import com.beautyshop.entity.Shift;
import com.beautyshop.repository.ShiftRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class ShiftService {
    @Autowired
    private ShiftRepository shiftRepository;

    public Shift saveShift(Shift shift) {
        return shiftRepository.save(shift);
    }

    public List<Shift> getAllShifts() {
        return shiftRepository.findAll();
    }

    public Optional<Shift> getShiftById(Long id) {
        return shiftRepository.findById(id);
    }

    public List<Shift> getShiftsByEmployee(Employee employee) {
        return shiftRepository.findByEmployee(employee);
    }

    public List<Shift> getShiftsByStatus(String status) {
        return shiftRepository.findByStatus(status);
    }

    public List<Shift> getShiftsByEmployeeAndStatus(Employee employee, String status) {
        return shiftRepository.findByEmployeeAndStatus(employee, status);
    }

    public void deleteShift(Long id) {
        shiftRepository.deleteById(id);
    }

    public Shift updateShiftStatus(Long id, String status) {
        Optional<Shift> shiftOpt = shiftRepository.findById(id);
        if (shiftOpt.isPresent()) {
            Shift shift = shiftOpt.get();
            shift.setStatus(status);
            return shiftRepository.save(shift);
        }
        return null;
    }
}