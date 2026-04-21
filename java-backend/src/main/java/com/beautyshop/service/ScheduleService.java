package com.beautyshop.service;

import com.beautyshop.entity.Employee;
import com.beautyshop.entity.Schedule;
import com.beautyshop.repository.ScheduleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
public class ScheduleService {
    @Autowired
    private ScheduleRepository scheduleRepository;

    public Schedule saveSchedule(Schedule schedule) {
        return scheduleRepository.save(schedule);
    }

    public List<Schedule> getAllSchedules() {
        return scheduleRepository.findAll();
    }

    public Optional<Schedule> getScheduleById(Long id) {
        return scheduleRepository.findById(id);
    }

    public List<Schedule> getSchedulesByEmployee(Employee employee) {
        return scheduleRepository.findByEmployee(employee);
    }

    public List<Schedule> getSchedulesByEmployeeAndDateRange(Employee employee, Date startDate, Date endDate) {
        return scheduleRepository.findByEmployeeAndDateRange(employee, startDate, endDate);
    }

    public List<Schedule> getSchedulesByDateRange(Date startDate, Date endDate) {
        return scheduleRepository.findByDateRange(startDate, endDate);
    }

    public Schedule getScheduleByEmployeeAndDate(Long employeeId, Date date) {
        return scheduleRepository.findByEmployeeAndDate(employeeId, date);
    }

    public void deleteSchedule(Long id) {
        scheduleRepository.deleteById(id);
    }

    public Schedule updateSchedule(Long id, Schedule schedule) {
        schedule.setId(id);
        return scheduleRepository.save(schedule);
    }
}