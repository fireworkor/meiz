package com.beautyshop.service;

import com.beautyshop.entity.Inventory;
import com.beautyshop.entity.Product;
import com.beautyshop.repository.InventoryRepository;
import com.beautyshop.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
public class InventoryService {
    @Autowired
    private InventoryRepository inventoryRepository;

    @Autowired
    private ProductRepository productRepository;

    public Inventory saveInventory(Inventory inventory) {
        return inventoryRepository.save(inventory);
    }

    public List<Inventory> getAllInventories() {
        return inventoryRepository.findAll();
    }

    public Optional<Inventory> getInventoryById(Long id) {
        return inventoryRepository.findById(id);
    }

    public List<Inventory> getInventoriesByProduct(Product product) {
        return inventoryRepository.findByProduct(product);
    }

    public List<Inventory> getLowStockInventories(Integer threshold) {
        return inventoryRepository.findLowStock(threshold);
    }

    public List<Inventory> getExpiringInventories(Date date) {
        return inventoryRepository.findExpiringBefore(date);
    }

    public void deleteInventory(Long id) {
        inventoryRepository.deleteById(id);
    }

    public Inventory addStock(Long productId, Integer quantity, String batchNumber, String supplier, Date expiryDate) {
        Product product = productRepository.findById(productId).orElse(null);
        if (product == null) {
            return null;
        }
        Inventory inventory = new Inventory();
        inventory.setProduct(product);
        inventory.setQuantity(quantity);
        inventory.setBatchNumber(batchNumber);
        inventory.setSupplier(supplier);
        inventory.setExpiryDate(expiryDate);
        return inventoryRepository.save(inventory);
    }

    public Inventory reduceStock(Long productId, Integer quantity) {
        List<Inventory> inventories = inventoryRepository.findByProduct(
            productRepository.findById(productId).orElse(null)
        );
        if (inventories.isEmpty()) {
            return null;
        }
        Inventory inventory = inventories.get(0);
        inventory.setQuantity(inventory.getQuantity() - quantity);
        return inventoryRepository.save(inventory);
    }
}