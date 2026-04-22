package com.beautyshop.controller;

import com.beautyshop.dto.AttendanceRequest;
import com.beautyshop.dto.AttendanceCheckOutRequest;
import com.beautyshop.entity.Attendance;
import com.beautyshop.entity.Employee;
import com.beautyshop.service.AttendanceService;
import com.beautyshop.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;
import java.util.Date;
import java.util.List;

@RestController
@RequestMapping("/api/attendances")
public class AttendanceController {
    @Autowired
    private AttendanceService attendanceService;

    @Autowired
    private EmployeeService employeeService;

    @PostMapping("/check-in")
    public Attendance checkIn(@RequestBody AttendanceRequest request) {
        Employee employee = employeeService.getEmployeeById(request.getEmployeeId()).orElse(null);
        if (employee == null) {
            return null;
        }
        return attendanceService.checkIn(employee, new Date(), request.getLocation(), request.getPhoto());
    }

    @PostMapping("/check-out")
    public Attendance checkOut(@RequestBody AttendanceCheckOutRequest request) {
        return attendanceService.checkOut(request.getAttendanceId(), new Date(), request.getLocation(), request.getPhoto());
    }

    @GetMapping("/employee/{employeeId}")
    public List<Attendance> getAttendancesByEmployee(@PathVariable Long employeeId) {
        Employee employee = employeeService.getEmployeeById(employeeId).orElse(null);
        if (employee == null) {
            return null;
        }
        return attendanceService.getAttendancesByEmployee(employee);
    }

    @GetMapping("/employee/{employeeId}/date-range")
    public List<Attendance> getAttendancesByDateRange(
            @PathVariable Long employeeId, 
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate, 
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate) {
        Employee employee = employeeService.getEmployeeById(employeeId).orElse(null);
        if (employee == null) {
            return null;
        }
        return attendanceService.getAttendancesByEmployeeAndDateRange(employee, startDate, endDate);
    }

    @GetMapping("/employee/{employeeId}/today")
    public Attendance getTodayAttendance(@PathVariable Long employeeId) {
        Employee employee = employeeService.getEmployeeById(employeeId).orElse(null);
        if (employee == null) {
            return null;
        }
        return attendanceService.getTodayAttendance(employee);
    }
}