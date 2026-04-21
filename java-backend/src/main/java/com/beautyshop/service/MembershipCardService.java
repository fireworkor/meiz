package com.beautyshop.service;

import com.beautyshop.entity.MembershipCard;
import com.beautyshop.entity.Customer;
import com.beautyshop.repository.MembershipCardRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Service
public class MembershipCardService {
    @Autowired
    private MembershipCardRepository membershipCardRepository;

    public MembershipCard saveMembershipCard(MembershipCard card) {
        return membershipCardRepository.save(card);
    }

    public List<MembershipCard> getAllMembershipCards() {
        return membershipCardRepository.findAll();
    }

    public Optional<MembershipCard> getMembershipCardById(Long id) {
        return membershipCardRepository.findById(id);
    }

    public List<MembershipCard> getMembershipCardsByCustomer(Customer customer) {
        return membershipCardRepository.findByCustomer(customer);
    }

    public List<MembershipCard> getMembershipCardsByStatus(String status) {
        return membershipCardRepository.findByStatus(status);
    }

    public void deleteMembershipCard(Long id) {
        membershipCardRepository.deleteById(id);
    }

    public MembershipCard recharge(Long id, BigDecimal amount) {
        Optional<MembershipCard> cardOpt = membershipCardRepository.findById(id);
        if (cardOpt.isPresent()) {
            MembershipCard card = cardOpt.get();
            card.setBalance(card.getBalance().add(amount));
            card.setTotalAmount(card.getTotalAmount().add(amount));
            return membershipCardRepository.save(card);
        }
        return null;
    }

    public MembershipCard consume(Long id, BigDecimal amount) {
        Optional<MembershipCard> cardOpt = membershipCardRepository.findById(id);
        if (cardOpt.isPresent()) {
            MembershipCard card = cardOpt.get();
            if (card.getBalance().compareTo(amount) >= 0) {
                card.setBalance(card.getBalance().subtract(amount));
                return membershipCardRepository.save(card);
            }
        }
        return null;
    }
}