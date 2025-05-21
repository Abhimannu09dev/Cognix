// src/main/java/com/cognix/model/ReceivedOrder.java
package com.cognix.model;

import java.util.Date;

public class Order {
    private int orderId;
    private String modelName;
    private String buyerUsername;
    private String category;
    private Date   purchaseDate;
    private double price;

    // —— getters & setters —— 
    public int    getOrderId()      { return orderId; }
    public void   setOrderId(int id){ this.orderId = id; }

    public String getModelName()           { return modelName; }
    public void   setModelName(String n)   { this.modelName = n; }

    public String getBuyerUsername()           { return buyerUsername; }
    public void   setBuyerUsername(String b)   { this.buyerUsername = b; }

    public String getCategory()           { return category; }
    public void   setCategory(String c)   { this.category = c; }

    public Date   getPurchaseDate()           { return purchaseDate; }
    public void   setPurchaseDate(Date purchaseDate)     { this.purchaseDate = purchaseDate; }

    public double getPrice()           { return price; }
    public void   setPrice(double price)   { this.price = price; }
}
