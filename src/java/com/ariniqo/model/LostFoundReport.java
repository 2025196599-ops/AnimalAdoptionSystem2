/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ariniqo.model;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

public class LostFoundReport {
    private int reportId;
    private String reportType; // LOST/FOUND
    private String status;     // ACTIVE/RESOLVED

    private String petName;
    private String petType;
    private String breed;
    private String ageDesc;
    private String gender;
    private String colorMarkings;

    private String description;
    private String distinctiveFeatures;
    private String collarDetails;
    private String reward;

    private Date eventDate;
    private Time eventTime;

    private String locationText;
    private String city;
    private String state;
    private String postcode;

    private String reporterName;
    private String reporterEmail;
    private String reporterPhone;
    private String reporterPhone2;

    private String photoPath;

    private Timestamp createdDate;
    private Timestamp resolvedDate;

    // getters/setters (generate in IDE)
    // (keeping short: you can auto-generate)
    public int getReportId() { return reportId; }
    public void setReportId(int reportId) { this.reportId = reportId; }

    public String getReportType() { return reportType; }
    public void setReportType(String reportType) { this.reportType = reportType; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getPetName() { return petName; }
    public void setPetName(String petName) { this.petName = petName; }

    public String getPetType() { return petType; }
    public void setPetType(String petType) { this.petType = petType; }

    public String getBreed() { return breed; }
    public void setBreed(String breed) { this.breed = breed; }

    public String getAgeDesc() { return ageDesc; }
    public void setAgeDesc(String ageDesc) { this.ageDesc = ageDesc; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getColorMarkings() { return colorMarkings; }
    public void setColorMarkings(String colorMarkings) { this.colorMarkings = colorMarkings; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getDistinctiveFeatures() { return distinctiveFeatures; }
    public void setDistinctiveFeatures(String distinctiveFeatures) { this.distinctiveFeatures = distinctiveFeatures; }

    public String getCollarDetails() { return collarDetails; }
    public void setCollarDetails(String collarDetails) { this.collarDetails = collarDetails; }

    public String getReward() { return reward; }
    public void setReward(String reward) { this.reward = reward; }

    public Date getEventDate() { return eventDate; }
    public void setEventDate(Date eventDate) { this.eventDate = eventDate; }

    public Time getEventTime() { return eventTime; }
    public void setEventTime(Time eventTime) { this.eventTime = eventTime; }

    public String getLocationText() { return locationText; }
    public void setLocationText(String locationText) { this.locationText = locationText; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getState() { return state; }
    public void setState(String state) { this.state = state; }

    public String getPostcode() { return postcode; }
    public void setPostcode(String postcode) { this.postcode = postcode; }

    public String getReporterName() { return reporterName; }
    public void setReporterName(String reporterName) { this.reporterName = reporterName; }

    public String getReporterEmail() { return reporterEmail; }
    public void setReporterEmail(String reporterEmail) { this.reporterEmail = reporterEmail; }

    public String getReporterPhone() { return reporterPhone; }
    public void setReporterPhone(String reporterPhone) { this.reporterPhone = reporterPhone; }

    public String getReporterPhone2() { return reporterPhone2; }
    public void setReporterPhone2(String reporterPhone2) { this.reporterPhone2 = reporterPhone2; }

    public String getPhotoPath() { return photoPath; }
    public void setPhotoPath(String photoPath) { this.photoPath = photoPath; }

    public Timestamp getCreatedDate() { return createdDate; }
    public void setCreatedDate(Timestamp createdDate) { this.createdDate = createdDate; }

    public Timestamp getResolvedDate() { return resolvedDate; }
    public void setResolvedDate(Timestamp resolvedDate) { this.resolvedDate = resolvedDate; }
}

