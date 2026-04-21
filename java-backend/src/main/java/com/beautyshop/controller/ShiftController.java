package com.beautyshop.controller;

import com.beautyshop.dto.ShiftRequest;
import com.beautyshop.entity.Employee;
import com.beautyshop.entity.Shift;
import com.beautyshop.service.EmployeeService;
import com.beautyshop.service.ShiftService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/shifts")
public class ShiftController {
    @Autowired
    private ShiftService shiftService;

    @Autowired
    private EmployeeService employeeService;

    @GetMapping
    public List<Shift> getAllShifts() {
        return shiftService.getAllShifts();
    }

    @GetMapping("/{id}")
    public Optional<Shift> getShiftById(@PathVariable Long id) {
        return shiftService.getShiftById(id);
    }

    @PostMapping
    public Shift createShift(@RequestBody ShiftRequest request) {
        Employee employee = employeeService.getEmployeeById(request.getEmployeeId()).orElse(null);
        if (employee == null) {
            return null;
        }
        Shift shift = new Shift();
        shift.setEmployee(employee);
        shift.setShiftDate(request.getShiftDate());
        shift.setCashAmount(request.getCashAmount());
        shift.setWechatAmount(request.getWechatAmount());
        shift.setAlipayAmount(request.getAlipayAmount());
        shift.setCardAmount(request.getCardAmount());
        shift.setMemberCardAmount(request.getMemberCardAmount());
        shift.setCouponAmount(request.getCouponAmount());
        shift.setTotalAmount(request.getTotalAmount());
        shift.setSystemAmount(request.getSystemAmount());
        shift.setDifference(request.getDifference());
        shift.setDifferenceReason(request.getDifferenceReason());
        shift.setStatus(request.getStatus());
        shift.setNextEmployeeId(request.getNextEmployeeId());
        shift.setNotes(request.getNotes());
        return shiftService.saveShift(shift);
    }

    @PutMapping("/{id}")
    public Shift updateShift(@PathVariable Long id, @RequestBody ShiftRequest request) {
        Optional<Shift> existingShift = shiftService.getShiftById(id);
        if (!existingShift.isPresent()) {
            return null;
        }
        Shift shift = existingShift.get();
        if (request.getEmployeeId() != null) {
            Employee employee = employeeService.getEmployeeById(request.getEmployeeId()).orElse(null);
            shift.setEmployee(employee);
        }
        if (request.getCashAmount() != null) {
            shift.setCashAmount(request.getCashAmount());
        }
        if (request.getWechatAmount() != null) {
            shift.setWechatAmount(request.getWechatAmount());
        }
        if (request.getAlipayAmount() != null) {
            shift.setAlipayAmount(request.getAlipayAmount());
        }
        if (request.getCardAmount() != null) {
            shift.setCardAmount(request.getCardAmount());
        }
        if (request.getMemberCardAmount() != null) {
            shift.setMemberCardAmount(request.getMemberCardAmount());
        }
        if (request.getCouponAmount() != null) {
            shift.setCouponAmount(request.getCouponAmount());
        }
        if (request.getTotalAmount() != null) {
            shift.setTotalAmount(request.getTotalAmount());
        }
        if (request.getSystemAmount() != null) {
            shift.setSystemAmount(request.getSystemAmount());
        }
        if (request.getDifference() != null) {
            shift.setDifference(request.getDifference());
        }
        if (request.getDifferenceReason() != null) {
            shift.setDifferenceReason(request.getDifferenceReason());
        }
        if (request.getStatus() != null) {
            shift.setStatus(request.getStatus());
        }
        if (request.getNextEmployeeId() != null) {
            shift.setNextEmployeeId(request.getNextEmployeeId());
        }
        if (request.getNotes() != null) {
            shift.setNotes(request.getNotes());
        }
        return shiftService.saveShift(shift);
    }

    @DeleteMapping("/{id}")
    public void deleteShift(@PathVariable Long id) {
        shiftService.deleteShift(id);
    }

    @PutMapping("/{id}/status")
    public Shift updateShiftStatus(@PathVariable Long id, @RequestParam String status) {
        return shiftService.updateShiftStatus(id, status);
    }

    @GetMapping("/employee/{employeeId}")
    public List<Shift> getShiftsByEmployee(@PathVariable Long employeeId) {
        Employee employee = employeeService.getEmployeeById(employeeId).orElse(null);
        if (employee == null) {
            return null;
        }
        return shiftService.getShiftsByEmployee(employee);
    }

    @GetMapping("/status/{status}")
    public List<Shift> getShiftsByStatus(@PathVariable String status) {
        return shiftService.getShiftsByStatus(status);
    }
}