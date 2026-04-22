package com.beautyshop.service;

import com.beautyshop.dto.MarketingActivityRequest;
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

    public MarketingActivity updateMarketingActivity(Long id, MarketingActivityRequest request) {
        Optional<MarketingActivity> existingOpt = marketingActivityRepository.findById(id);
        if (!existingOpt.isPresent()) {
            return null;
        }
        MarketingActivity activity = existingOpt.get();
        if (request.getName() != null) {
            activity.setName(request.getName());
        }
        if (request.getType() != null) {
            activity.setType(request.getType());
        }
        if (request.getDescription() != null) {
            activity.setDescription(request.getDescription());
        }
        if (request.getStartDate() != null) {
            activity.setStartDate(request.getStartDate());
        }
        if (request.getEndDate() != null) {
            activity.setEndDate(request.getEndDate());
        }
        if (request.getDiscountAmount() != null) {
            activity.setDiscountAmount(request.getDiscountAmount());
        }
        if (request.getDiscountRate() != null) {
            activity.setDiscountRate(request.getDiscountRate());
        }
        if (request.getMinAmount() != null) {
            activity.setMinAmount(request.getMinAmount());
        }
        if (request.getTargetCount() != null) {
            activity.setTargetCount(request.getTargetCount());
        }
        if (request.getParticipationCount() != null) {
            activity.setParticipationCount(request.getParticipationCount());
        }
        if (request.getStatus() != null && !request.getStatus().isEmpty()) {
            activity.setStatus(request.getStatus());
        }
        return marketingActivityRepository.save(activity);
    }
}