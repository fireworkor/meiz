package com.beautyshop.controller;

import com.beautyshop.dto.MarketingActivityRequest;
import com.beautyshop.entity.MarketingActivity;
import com.beautyshop.service.MarketingActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/marketing-activities")
public class MarketingActivityController {
    @Autowired
    private MarketingActivityService marketingActivityService;

    @GetMapping
    public List<MarketingActivity> getAllMarketingActivities() {
        return marketingActivityService.getAllMarketingActivities();
    }

    @GetMapping("/{id}")
    public Optional<MarketingActivity> getMarketingActivityById(@PathVariable Long id) {
        return marketingActivityService.getMarketingActivityById(id);
    }

    @PostMapping
    public MarketingActivity createMarketingActivity(@RequestBody MarketingActivity activity) {
        return marketingActivityService.saveMarketingActivity(activity);
    }

    @PutMapping("/{id}")
    public MarketingActivity updateMarketingActivity(@PathVariable Long id, @RequestBody MarketingActivityRequest request) {
        return marketingActivityService.updateMarketingActivity(id, request);
    }

    @DeleteMapping("/{id}")
    public void deleteMarketingActivity(@PathVariable Long id) {
        marketingActivityService.deleteMarketingActivity(id);
    }

    @GetMapping("/status/{status}")
    public List<MarketingActivity> getMarketingActivitiesByStatus(@PathVariable String status) {
        return marketingActivityService.getMarketingActivitiesByStatus(status);
    }
}