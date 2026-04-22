package com.beautyshop.dto;

import java.math.BigDecimal;
import java.util.Date;

public class CustomerRequest {
    private String name;
    private String phone;
    private String gender;
    private Date birthday;
    private String wechat;
    private String occupation;
    private String sourceChannel;
    private String sourcePlatform;
    private String skinType;
    private String allergyHistory;
    private String skinProblems;
    private String preferredItems;
    private String preferredEmployee;
    private String preferredTime;
    private BigDecimal averageSpending;
    private String tags;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Date getBirthday() {
        return birthday;
    }

    public void setBirthday(Date birthday) {
        this.birthday = birthday;
    }

    public String getWechat() {
        return wechat;
    }

    public void setWechat(String wechat) {
        this.wechat = wechat;
    }

    public String getOccupation() {
        return occupation;
    }

    public void setOccupation(String occupation) {
        this.occupation = occupation;
    }

    public String getSourceChannel() {
        return sourceChannel;
    }

    public void setSourceChannel(String sourceChannel) {
        this.sourceChannel = sourceChannel;
    }

    public String getSourcePlatform() {
        return sourcePlatform;
    }

    public void setSourcePlatform(String sourcePlatform) {
        this.sourcePlatform = sourcePlatform;
    }

    public String getSkinType() {
        return skinType;
    }

    public void setSkinType(String skinType) {
        this.skinType = skinType;
    }

    public String getAllergyHistory() {
        return allergyHistory;
    }

    public void setAllergyHistory(String allergyHistory) {
        this.allergyHistory = allergyHistory;
    }

    public String getSkinProblems() {
        return skinProblems;
    }

    public void setSkinProblems(String skinProblems) {
        this.skinProblems = skinProblems;
    }

    public String getPreferredItems() {
        return preferredItems;
    }

    public void setPreferredItems(String preferredItems) {
        this.preferredItems = preferredItems;
    }

    public String getPreferredEmployee() {
        return preferredEmployee;
    }

    public void setPreferredEmployee(String preferredEmployee) {
        this.preferredEmployee = preferredEmployee;
    }

    public String getPreferredTime() {
        return preferredTime;
    }

    public void setPreferredTime(String preferredTime) {
        this.preferredTime = preferredTime;
    }

    public BigDecimal getAverageSpending() {
        return averageSpending;
    }

    public void setAverageSpending(BigDecimal averageSpending) {
        this.averageSpending = averageSpending;
    }

    public String getTags() {
        return tags;
    }

    public void setTags(String tags) {
        this.tags = tags;
    }
}
