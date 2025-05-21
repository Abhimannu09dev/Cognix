// src/main/java/com/cognix/model/Model.java
package com.cognix.model;

import java.math.BigDecimal;
import java.util.Date;

public class Model {
    private int modelId;
    private int sn;
    private String name;
    private String category;
    private Date listedDate;
    private double price;
    private String imagePath;
    private String bannerUrl;
    private String description;

    // buyer-dashboard fields
    private String sellerUsername;
    private Date   purchaseDate;

    // product-details stats
    private double accuracy;
    private double precision;
    private double recall;
    private double f1Score;
    private long   parameters;
    private int    inferenceTime;
    
    private int sales;
    private BigDecimal revenue;
    private String docsUrl;
    private String githubUrl;
    
    private String version;
    private String modelUrl;
    private int    sellerUserId;

    public Model() {}

    // —— getters & setters —— //

    public int getModelId() {
        return modelId;
    }
    public void setModelId(int modelId) {
        this.modelId = modelId;
    }

    public int getSn() {
        return sn;
    }
    public void setSn(int sn) {
        this.sn = sn;
    }

    // for shorthand in JSP tables
    public String getModelName() {
        return name;
    }
    public void setModelName(String modelName) {
        this.name = modelName;
    }

    // full name field
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }

    public String getCategory() {
        return category;
    }
    public void setCategory(String category) {
        this.category = category;
    }

    public Date getListedDate() {
        return listedDate;
    }
    public void setListedDate(Date listedDate) {
        this.listedDate = listedDate;
    }

    public double getPrice() {
        return price;
    }
    public void setPrice(double price) {
        this.price = price;
    }

    public String getImagePath() {
        return imagePath;
    }
    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public String getBannerUrl() {
        return bannerUrl;
    }
    public void setBannerUrl(String bannerUrl) {
        this.bannerUrl = bannerUrl;
    }

    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }

    // buyer‐dashboard
    public String getSellerUsername() {
        return sellerUsername;
    }
    public void setSellerUsername(String sellerUsername) {
        this.sellerUsername = sellerUsername;
    }

    public Date getPurchaseDate() {
        return purchaseDate;
    }
    public void setPurchaseDate(Date purchaseDate) {
        this.purchaseDate = purchaseDate;
    }

    // product‐details stats
    public double getAccuracy() {
        return accuracy;
    }
    public void setAccuracy(double accuracy) {
        this.accuracy = accuracy;
    }

    public double getPrecision() {
        return precision;
    }
    public void setPrecision(double precision) {
        this.precision = precision;
    }

    public double getRecall() {
        return recall;
    }
    public void setRecall(double recall) {
        this.recall = recall;
    }

    public double getF1Score() {
        return f1Score;
    }
    public void setF1Score(double f1Score) {
        this.f1Score = f1Score;
    }

    public long getParameters() {
        return parameters;
    }
    public void setParameters(long parameters) {
        this.parameters = parameters;
    }

    public int getInferenceTime() {
        return inferenceTime;
    }
    public void setInferenceTime(int inferenceTime) {
        this.inferenceTime = inferenceTime;
    }
    
    // ── New getters/setters ──
    public int getSales() {
        return sales;
    }
    public void setSales(int sales) {
        this.sales = sales;
    }

    public BigDecimal getRevenue() {
        return revenue;
    }
    public void setRevenue(BigDecimal revenue) {
        this.revenue = revenue;
    }
    

    public String getDocsUrl() {
        return docsUrl;
    }
    public void setDocsUrl(String docsUrl) {
        this.docsUrl = docsUrl;
    }

    public String getGithubUrl() {
        return githubUrl;
    }
    public void setGithubUrl(String githubUrl) {
        this.githubUrl = githubUrl;
    }
    public String getVersion() {
        return version;
    }
    public void setVersion(String version) {
        this.version = version;
    }

    public String getModelUrl() {
        return modelUrl;
    }
    public void setModelUrl(String modelUrl) {
        this.modelUrl = modelUrl;
    }

    public int getSellerUserId() {
        return sellerUserId;
    }
    public void setSellerUserId(int sellerUserId) {
        this.sellerUserId = sellerUserId;
    }
}
