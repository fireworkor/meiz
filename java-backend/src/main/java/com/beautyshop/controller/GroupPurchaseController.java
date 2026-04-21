package com.beautyshop.controller;

import com.beautyshop.entity.GroupPurchase;
import com.beautyshop.entity.GroupPurchaseMember;
import com.beautyshop.service.GroupPurchaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/group-purchases")
public class GroupPurchaseController {

    @Autowired
    private GroupPurchaseService groupPurchaseService;

    @GetMapping
    public List<GroupPurchase> getAllGroupPurchases() {
        return groupPurchaseService.getAllGroupPurchases();
    }

    @GetMapping("/{id}")
    public ResponseEntity<GroupPurchase> getGroupPurchaseById(@PathVariable Long id) {
        GroupPurchase gp = groupPurchaseService.getGroupPurchaseById(id);
        if (gp == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(gp);
    }

    @GetMapping("/active")
    public List<GroupPurchase> getActiveGroupPurchases() {
        return groupPurchaseService.getActiveGroupPurchases();
    }

    @GetMapping("/category/{category}")
    public List<GroupPurchase> getGroupPurchasesByCategory(@PathVariable String category) {
        return groupPurchaseService.getGroupPurchasesByCategory(category);
    }

    @GetMapping("/available")
    public List<GroupPurchase> getAvailableGroupPurchases() {
        return groupPurchaseService.getAvailableGroupPurchases();
    }

    @PostMapping
    public ResponseEntity<GroupPurchase> createGroupPurchase(@RequestBody GroupPurchase groupPurchase) {
        GroupPurchase created = groupPurchaseService.createGroupPurchase(groupPurchase);
        return ResponseEntity.ok(created);
    }

    @PutMapping("/{id}")
    public ResponseEntity<GroupPurchase> updateGroupPurchase(@PathVariable Long id, @RequestBody GroupPurchase groupPurchase) {
        try {
            GroupPurchase updated = groupPurchaseService.updateGroupPurchase(id, groupPurchase);
            return ResponseEntity.ok(updated);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteGroupPurchase(@PathVariable Long id) {
        groupPurchaseService.deleteGroupPurchase(id);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/{id}/join")
    public ResponseEntity<Map<String, Object>> joinGroupPurchase(
            @PathVariable Long id,
            @RequestParam Long customerId,
            @RequestParam(required = false) Boolean isLeader) {
        try {
            GroupPurchaseMember member = groupPurchaseService.joinGroupPurchase(id, customerId, isLeader);
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("message", "Join successful");
            result.put("member", member);
            return ResponseEntity.ok(result);
        } catch (RuntimeException e) {
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(result);
        }
    }

    @PostMapping("/process-expired")
    public ResponseEntity<Void> processExpiredGroups() {
        groupPurchaseService.processExpiredGroups();
        return ResponseEntity.ok().build();
    }
}
