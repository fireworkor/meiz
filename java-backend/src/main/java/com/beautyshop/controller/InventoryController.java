package com.beautyshop.controller;

import com.beautyshop.dto.InventoryRequest;
import com.beautyshop.entity.Inventory;
import com.beautyshop.service.InventoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/inventory")
public class InventoryController {
    @Autowired
    private InventoryService inventoryService;

    @GetMapping
    public List<Inventory> getAllInventories() {
        return inventoryService.getAllInventories();
    }

    @GetMapping("/{id}")
    public Optional<Inventory> getInventoryById(@PathVariable Long id) {
        return inventoryService.getInventoryById(id);
    }

    @PostMapping
    public Inventory createInventory(@RequestBody InventoryRequest request) {
        return inventoryService.addStock(
            request.getProductId(),
            request.getQuantity(),
            request.getBatchNumber(),
            request.getSupplier(),
            request.getExpiryDate()
        );
    }

    @PutMapping("/{id}")
    public Inventory updateInventory(@PathVariable Long id, @RequestBody Inventory inventory) {
        inventory.setId(id);
        return inventoryService.saveInventory(inventory);
    }

    @DeleteMapping("/{id}")
    public void deleteInventory(@PathVariable Long id) {
        inventoryService.deleteInventory(id);
    }

    @GetMapping("/low-stock")
    public List<Inventory> getLowStockInventories(@RequestParam(defaultValue = "10") Integer threshold) {
        return inventoryService.getLowStockInventories(threshold);
    }

    @GetMapping("/expiring")
    public List<Inventory> getExpiringInventories(@RequestParam Date date) {
        return inventoryService.getExpiringInventories(date);
    }

    @PostMapping("/add-stock")
    public Inventory addStock(@RequestBody InventoryRequest request) {
        return inventoryService.addStock(
            request.getProductId(),
            request.getQuantity(),
            request.getBatchNumber(),
            request.getSupplier(),
            request.getExpiryDate()
        );
    }

    @PostMapping("/reduce-stock")
    public Inventory reduceStock(@RequestBody InventoryRequest request) {
        return inventoryService.reduceStock(request.getProductId(), request.getQuantity());
    }
}