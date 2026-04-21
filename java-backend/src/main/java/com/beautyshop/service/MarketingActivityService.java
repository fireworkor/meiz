package com.beautyshop.service;

import com.beautyshop.entity.MarketingActivity;
import com.beautyshop.repository.MarketingActivityRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class MarketingActivityService {
    @Autowired
    private MarketingActivityRepository marketingActivityRepository;

    public MarketingActivity saveMarketingActivity(MarketingActivity activity) {
        return marketingActivityRepository.save(activity);
    }

    public List<MarketingActivity> getAllMarketingActivities() {
        return marketingActivityRepository.findAll();
    }

    public Optional<MarketingActivity> getMarketingActivityById(Long id) {
        return marketingActivityRepository.findById(id);
    }

    public List<MarketingActivity> getMarketingActivitiesByStatus(String status) {
        return marketingActivityRepository.findByStatus(status);
    }

    public void deleteMarketingActivity(Long id) {
        marketingActivityRepository.deleteById(id);
    }
}