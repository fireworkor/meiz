package com.beautyshop.controller;

import com.beautyshop.entity.CardType;
import com.beautyshop.service.CardTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/card-types")
public class CardTypeController {
    @Autowired
    private CardTypeService cardTypeService;

    @GetMapping
    public List<CardType> getAllCardTypes() {
        return cardTypeService.getAllCardTypes();
    }

    @GetMapping("/{id}")
    public Optional<CardType> getCardTypeById(@PathVariable Long id) {
        return cardTypeService.getCardTypeById(id);
    }

    @PostMapping
    public CardType createCardType(@RequestBody CardType cardType) {
        return cardTypeService.saveCardType(cardType);
    }

    @PutMapping("/{id}")
    public CardType updateCardType(@PathVariable Long id, @RequestBody CardType cardType) {
        cardType.setId(id);
        return cardTypeService.saveCardType(cardType);
    }

    @DeleteMapping("/{id}")
    public void deleteCardType(@PathVariable Long id) {
        cardTypeService.deleteCardType(id);
    }

    @GetMapping("/status/{status}")
    public List<CardType> getCardTypesByStatus(@PathVariable String status) {
        return cardTypeService.getCardTypesByStatus(status);
    }
}