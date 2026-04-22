package com.beautyshop.controller;

import com.beautyshop.dto.ScheduleRequest;
import com.beautyshop.entity.Employee;
import com.beautyshop.entity.Schedule;
import com.beautyshop.service.EmployeeService;
import com.beautyshop.service.ScheduleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/schedules")
public class ScheduleController {
    @Autowired
    private ScheduleService scheduleService;

    @Autowired
    private EmployeeService employeeService;

    @GetMapping
    public List<Schedule> getAllSchedules() {
        return scheduleService.getAllSchedules();
    }

    @GetMapping("/{id}")
    public Optional<Schedule> getScheduleById(@PathVariable Long id) {
        return scheduleService.getScheduleById(id);
    }

    @PostMapping
    public Schedule createSchedule(@RequestBody ScheduleRequest request) {
        Employee employee = employeeService.getEmployeeById(request.getEmployeeId()).orElse(null);
        if (employee == null) {
            return null;
        }
        Schedule schedule = new Schedule();
        schedule.setEmployee(employee);
        schedule.setScheduleDate(request.getScheduleDate());
        schedule.setShiftType(request.getShiftType());
        schedule.setStartTime(request.getStartTime());
        schedule.setEndTime(request.getEndTime());
        schedule.setStatus(request.getStatus());
        schedule.setNotes(request.getNotes());
        return scheduleService.saveSchedule(schedule);
    }

    @PutMapping("/{id}")
    public Schedule updateSchedule(@PathVariable Long id, @RequestBody ScheduleRequest request) {
        Optional<Schedule> existingSchedule = scheduleService.getScheduleById(id);
        if (!existingSchedule.isPresent()) {
            return null;
        }
        Schedule schedule = existingSchedule.get();
        if (request.getEmployeeId() != null) {
            Employee employee = employeeService.getEmployeeById(request.getEmployeeId()).orElse(null);
            schedule.setEmployee(employee);
        }
        if (request.getScheduleDate() != null) {
            schedule.setScheduleDate(request.getScheduleDate());
        }
        if (request.getShiftType() != null) {
            schedule.setShiftType(request.getShiftType());
        }
        if (request.getStartTime() != null) {
            schedule.setStartTime(request.getStartTime());
        }
        if (request.getEndTime() != null) {
            schedule.setEndTime(request.getEndTime());
        }
        if (request.getStatus() != null) {
            schedule.setStatus(request.getStatus());
        }
        if (request.getNotes() != null) {
            schedule.setNotes(request.getNotes());
        }
        return scheduleService.updateSchedule(id, schedule);
    }

    @DeleteMapping("/{id}")
    public void deleteSchedule(@PathVariable Long id) {
        scheduleService.deleteSchedule(id);
    }

    @GetMapping("/employee/{employeeId}")
    public List<Schedule> getSchedulesByEmployee(@PathVariable Long employeeId) {
        Employee employee = employeeService.getEmployeeById(employeeId).orElse(null);
        if (employee == null) {
            return null;
        }
        return scheduleService.getSchedulesByEmployee(employee);
    }

    @GetMapping("/employee/{employeeId}/date-range")
    public List<Schedule> getSchedulesByEmployeeAndDateRange(
            @PathVariable Long employeeId,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate) {
        Employee employee = employeeService.getEmployeeById(employeeId).orElse(null);
        if (employee == null) {
            return null;
        }
        return scheduleService.getSchedulesByEmployeeAndDateRange(employee, startDate, endDate);
    }

    @GetMapping("/date-range")
    public List<Schedule> getSchedulesByDateRange(
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate) {
        return scheduleService.getSchedulesByDateRange(startDate, endDate);
    }

    @GetMapping("/employee/{employeeId}/date/{date}")
    public Schedule getScheduleByEmployeeAndDate(
            @PathVariable Long employeeId,
            @PathVariable @DateTimeFormat(pattern = "yyyy-MM-dd") Date date) {
        return scheduleService.getScheduleByEmployeeAndDate(employeeId, date);
    }
}