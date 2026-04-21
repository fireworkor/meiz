package com.beautyshop.service;

import com.beautyshop.entity.CardType;
import com.beautyshop.repository.CardTypeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class CardTypeService {
    @Autowired
    private CardTypeRepository cardTypeRepository;

    public CardType saveCardType(CardType cardType) {
        return cardTypeRepository.save(cardType);
    }

    public List<CardType> getAllCardTypes() {
        return cardTypeRepository.findAll();
    }

    public Optional<CardType> getCardTypeById(Long id) {
        return cardTypeRepository.findById(id);
    }

    public List<CardType> getCardTypesByStatus(String status) {
        return cardTypeRepository.findByStatus(status);
    }

    public void deleteCardType(Long id) {
        cardTypeRepository.deleteById(id);
    }
}