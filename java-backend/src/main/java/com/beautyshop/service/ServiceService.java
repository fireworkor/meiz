package com.beautyshop.service;

import com.beautyshop.entity.BeautyService;
import com.beautyshop.repository.ServiceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class ServiceService {
    @Autowired
    private ServiceRepository serviceRepository;

    public List<BeautyService> getAllServices() {
        return serviceRepository.findAll();
    }

    public Optional<BeautyService> getServiceById(Long id) {
        return serviceRepository.findById(id);
    }

    public List<BeautyService> getServicesByCategory(String category) {
        return serviceRepository.findByCategory(category);
    }

    public List<BeautyService> getServicesByStatus(String status) {
        return serviceRepository.findByStatus(status);
    }

    public List<BeautyService> searchServices(String name) {
        return serviceRepository.findByNameContaining(name);
    }

    public BeautyService saveService(BeautyService service) {
        return serviceRepository.save(service);
    }

    public void deleteService(Long id) {
        serviceRepository.deleteById(id);
    }
}
