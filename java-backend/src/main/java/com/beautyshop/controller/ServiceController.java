package com.beautyshop.controller;

import com.beautyshop.entity.BeautyService;
import com.beautyshop.service.ServiceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/services")
public class ServiceController {

    @Autowired
    private ServiceService serviceService;

    @GetMapping
    public List<BeautyService> getAllServices() {
        return serviceService.getAllServices();
    }

    @GetMapping("/{id}")
    public ResponseEntity<BeautyService> getServiceById(@PathVariable Long id) {
        return serviceService.getServiceById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/category/{category}")
    public List<BeautyService> getServicesByCategory(@PathVariable String category) {
        return serviceService.getServicesByCategory(category);
    }

    @GetMapping("/status/{status}")
    public List<BeautyService> getServicesByStatus(@PathVariable String status) {
        return serviceService.getServicesByStatus(status);
    }

    @GetMapping("/search")
    public List<BeautyService> searchServices(@RequestParam String name) {
        return serviceService.searchServices(name);
    }

    @PostMapping
    public BeautyService createService(@RequestBody BeautyService service) {
        return serviceService.saveService(service);
    }

    @PutMapping("/{id}")
    public ResponseEntity<BeautyService> updateService(@PathVariable Long id, @RequestBody BeautyService service) {
        return serviceService.getServiceById(id)
                .map(existing -> {
                    service.setId(id);
                    return ResponseEntity.ok(serviceService.saveService(service));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteService(@PathVariable Long id) {
        serviceService.deleteService(id);
        return ResponseEntity.ok().build();
    }

    @PutMapping("/{id}/status")
    public ResponseEntity<BeautyService> updateServiceStatus(@PathVariable Long id, @RequestParam String status) {
        return serviceService.getServiceById(id)
                .map(service -> {
                    service.setStatus(status);
                    return ResponseEntity.ok(serviceService.saveService(service));
                })
                .orElse(ResponseEntity.notFound().build());
    }
}
