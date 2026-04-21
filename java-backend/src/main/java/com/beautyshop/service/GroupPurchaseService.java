package com.beautyshop.service;

import com.beautyshop.entity.GroupPurchase;
import com.beautyshop.entity.GroupPurchaseMember;
import com.beautyshop.entity.Customer;
import com.beautyshop.repository.GroupPurchaseRepository;
import com.beautyshop.repository.GroupPurchaseMemberRepository;
import com.beautyshop.repository.CustomerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Service
public class GroupPurchaseService {

    @Autowired
    private GroupPurchaseRepository groupPurchaseRepository;

    @Autowired
    private GroupPurchaseMemberRepository memberRepository;

    @Autowired
    private CustomerRepository customerRepository;

    public List<GroupPurchase> getAllGroupPurchases() {
        return groupPurchaseRepository.findAll();
    }

    public GroupPurchase getGroupPurchaseById(Long id) {
        return groupPurchaseRepository.findById(id).orElse(null);
    }

    public List<GroupPurchase> getActiveGroupPurchases() {
        return groupPurchaseRepository.findByStatus("active");
    }

    public List<GroupPurchase> getGroupPurchasesByCategory(String category) {
        return groupPurchaseRepository.findByCategory(category);
    }

    public List<GroupPurchase> getAvailableGroupPurchases() {
        return groupPurchaseRepository.findAvailableGroupPurchases();
    }

    @Transactional
    public GroupPurchase createGroupPurchase(GroupPurchase groupPurchase) {
        groupPurchase.setStatus("active");
        groupPurchase.setCurrentMembers(0);
        groupPurchase.setSoldCount(0);
        return groupPurchaseRepository.save(groupPurchase);
    }

    @Transactional
    public GroupPurchase updateGroupPurchase(Long id, GroupPurchase groupPurchase) {
        GroupPurchase existing = groupPurchaseRepository.findById(id).orElse(null);
        if (existing == null) {
            throw new RuntimeException("Group purchase not found");
        }
        groupPurchase.setId(id);
        return groupPurchaseRepository.save(groupPurchase);
    }

    @Transactional
    public void deleteGroupPurchase(Long id) {
        groupPurchaseRepository.deleteById(id);
    }

    @Transactional
    public GroupPurchaseMember joinGroupPurchase(Long groupPurchaseId, Long customerId, Boolean isLeader) {
        GroupPurchase groupPurchase = groupPurchaseRepository.findById(groupPurchaseId).orElse(null);
        if (groupPurchase == null) {
            throw new RuntimeException("Group purchase not found");
        }

        Customer customer = customerRepository.findById(customerId).orElse(null);
        if (customer == null) {
            throw new RuntimeException("Customer not found");
        }

        if (groupPurchase.getStock() <= 0) {
            throw new RuntimeException("Out of stock");
        }

        GroupPurchaseMember member = new GroupPurchaseMember();
        member.setGroupPurchase(groupPurchase);
        member.setGroupPurchaseTitle(groupPurchase.getTitle());
        member.setCustomer(customer);
        member.setCustomerName(customer.getName() != null ? customer.getName() : "Customer");
        member.setCustomerPhone(customer.getPhone());
        member.setIsLeader(isLeader != null && isLeader);
        member.setStatus("pending");

        member = memberRepository.save(member);

        groupPurchase.setCurrentMembers(groupPurchase.getCurrentMembers() + 1);
        groupPurchaseRepository.save(groupPurchase);

        if (groupPurchase.getCurrentMembers() >= groupPurchase.getMinMembers()) {
            member.setStatus("success");
            member.setSuccessAt(new Date());
            memberRepository.save(member);
        }

        return member;
    }

    @Transactional
    public void processExpiredGroups() {
        List<GroupPurchaseMember> pendingMembers = memberRepository.findByStatus("pending");
        Date now = new Date();

        for (GroupPurchaseMember member : pendingMembers) {
            GroupPurchase gp = member.getGroupPurchase();
            if (gp.getGroupDeadline() != null && gp.getGroupDeadline().before(now)) {
                member.setStatus("failed");
                member.setFailedAt(now);
                member.setFailureReason("Group expired");
                memberRepository.save(member);
            }
        }
    }
}
