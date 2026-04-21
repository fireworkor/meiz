package com.beautyshop.repository;

import com.beautyshop.entity.GroupPurchaseMember;
import com.beautyshop.entity.GroupPurchase;
import com.beautyshop.entity.Customer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface GroupPurchaseMemberRepository extends JpaRepository<GroupPurchaseMember, Long> {
    List<GroupPurchaseMember> findByGroupPurchase(GroupPurchase groupPurchase);

    List<GroupPurchaseMember> findByCustomer(Customer customer);

    List<GroupPurchaseMember> findByGroupPurchaseAndStatus(GroupPurchase groupPurchase, String status);

    List<GroupPurchaseMember> findByStatus(String status);

    int countByGroupPurchaseAndStatus(GroupPurchase groupPurchase, String status);

    List<GroupPurchaseMember> findByCustomerAndStatus(Customer customer, String status);
}
