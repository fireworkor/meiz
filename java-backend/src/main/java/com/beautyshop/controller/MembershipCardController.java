package com.beautyshop.controller;

import com.beautyshop.dto.MembershipCardRequest;
import com.beautyshop.entity.MembershipCard;
import com.beautyshop.entity.Customer;
import com.beautyshop.service.MembershipCardService;
import com.beautyshop.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/membership-cards")
public class MembershipCardController {
    @Autowired
    private MembershipCardService membershipCardService;

    @Autowired
    private CustomerService customerService;

    @GetMapping
    public List<MembershipCard> getAllMembershipCards() {
        return membershipCardService.getAllMembershipCards();
    }

    @GetMapping("/{id}")
    public Optional<MembershipCard> getMembershipCardById(@PathVariable Long id) {
        return membershipCardService.getMembershipCardById(id);
    }

    @PostMapping
    public MembershipCard createMembershipCard(@RequestBody MembershipCardRequest request) {
        Customer customer = customerService.getCustomerById(request.getCustomerId()).orElse(null);
        if (customer == null) {
            return null;
        }
        MembershipCard card = new MembershipCard();
        card.setCustomer(customer);
        card.setCardNumber(request.getCardNumber());
        card.setCardType(request.getCardType());
        card.setBalance(request.getBalance());
        card.setTotalAmount(request.getTotalAmount());
        card.setDiscountRate(request.getDiscountRate());
        card.setPoints(request.getPoints());
        card.setIssueDate(request.getIssueDate());
        card.setExpiryDate(request.getExpiryDate());
        card.setStatus(request.getStatus());
        return membershipCardService.saveMembershipCard(card);
    }

    @PutMapping("/{id}")
    public MembershipCard updateMembershipCard(@PathVariable Long id, @RequestBody MembershipCardRequest request) {
        Optional<MembershipCard> existingCard = membershipCardService.getMembershipCardById(id);
        if (!existingCard.isPresent()) {
            return null;
        }
        MembershipCard card = existingCard.get();
        if (request.getCustomerId() != null) {
            Customer customer = customerService.getCustomerById(request.getCustomerId()).orElse(null);
            card.setCustomer(customer);
        }
        if (request.getCardNumber() != null) {
            card.setCardNumber(request.getCardNumber());
        }
        if (request.getCardType() != null) {
            card.setCardType(request.getCardType());
        }
        if (request.getBalance() != null) {
            card.setBalance(request.getBalance());
        }
        if (request.getTotalAmount() != null) {
            card.setTotalAmount(request.getTotalAmount());
        }
        if (request.getDiscountRate() != null) {
            card.setDiscountRate(request.getDiscountRate());
        }
        if (request.getPoints() != null) {
            card.setPoints(request.getPoints());
        }
        if (request.getExpiryDate() != null) {
            card.setExpiryDate(request.getExpiryDate());
        }
        if (request.getStatus() != null) {
            card.setStatus(request.getStatus());
        }
        return membershipCardService.saveMembershipCard(card);
    }

    @DeleteMapping("/{id}")
    public void deleteMembershipCard(@PathVariable Long id) {
        membershipCardService.deleteMembershipCard(id);
    }

    @PostMapping("/{id}/recharge")
    public MembershipCard recharge(@PathVariable Long id, @RequestParam BigDecimal amount) {
        return membershipCardService.recharge(id, amount);
    }

    @PostMapping("/{id}/consume")
    public MembershipCard consume(@PathVariable Long id, @RequestParam BigDecimal amount) {
        return membershipCardService.consume(id, amount);
    }

    @GetMapping("/customer/{customerId}")
    public List<MembershipCard> getMembershipCardsByCustomer(@PathVariable Long customerId) {
        Customer customer = customerService.getCustomerById(customerId).orElse(null);
        if (customer == null) {
            return null;
        }
        return membershipCardService.getMembershipCardsByCustomer(customer);
    }

    @GetMapping("/status/{status}")
    public List<MembershipCard> getMembershipCardsByStatus(@PathVariable String status) {
        return membershipCardService.getMembershipCardsByStatus(status);
    }
}