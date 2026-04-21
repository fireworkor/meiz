package com.beautyshop.service;

import com.beautyshop.entity.Attendance;
import com.beautyshop.entity.Employee;
import com.beautyshop.repository.AttendanceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
public class AttendanceService {
    @Autowired
    private AttendanceRepository attendanceRepository;

    public Attendance checkIn(Employee employee, Date checkInTime, String location, String photo) {
        Attendance attendance = new Attendance();
        attendance.setEmployee(employee);
        attendance.setCheckInTime(checkInTime);
        attendance.setCheckInLocation(location);
        attendance.setCheckInPhoto(photo);
        attendance.setStatus("正常");
        
        // 检查是否迟到
        // 这里可以根据实际的上班时间规则判断是否迟到
        
        return attendanceRepository.save(attendance);
    }

    public Attendance checkOut(Long attendanceId, Date checkOutTime, String location, String photo) {
        Optional<Attendance> attendanceOptional = attendanceRepository.findById(attendanceId);
        if (attendanceOptional.isPresent()) {
            Attendance attendance = attendanceOptional.get();
            attendance.setCheckOutTime(checkOutTime);
            attendance.setCheckOutLocation(location);
            attendance.setCheckOutPhoto(photo);
            return attendanceRepository.save(attendance);
        }
        return null;
    }

    public List<Attendance> getAttendancesByEmployee(Employee employee) {
        return attendanceRepository.findByEmployee(employee);
    }

    public List<Attendance> getAttendancesByEmployeeAndDateRange(Employee employee, Date startDate, Date endDate) {
        return attendanceRepository.findByEmployeeAndCheckInTimeBetween(employee, startDate, endDate);
    }

    public Attendance getTodayAttendance(Employee employee) {
        Date now = new Date();
        Date startOfDay = new Date(now.getYear(), now.getMonth(), now.getDate());
        Date endOfDay = new Date(now.getYear(), now.getMonth(), now.getDate(), 23, 59, 59);
        List<Attendance> attendances = attendanceRepository.findByEmployeeAndCheckInTimeBetween(employee, startOfDay, endOfDay);
        return attendances.isEmpty() ? null : attendances.get(0);
    }
}