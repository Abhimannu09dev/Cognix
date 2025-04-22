package com.cognix.model;

public class Model {
    private int id;
    private String name;
    private String category;
    private String listedDate;
    private double price;
    private int sales;
    private double revenue;

    // Empty constructor
    public Model() {}

    // Full constructor
    public Model(int id, String name, String category, String listedDate, double price, int sales, double revenue) {
        this.id = id;
        this.name = name;
        this.category = category;
        this.listedDate = listedDate;
        this.price = price;
        this.sales = sales;
        this.revenue = revenue;
    }

    // Getters and Setters
    public int getId() {return id;}
    public void setId(int id) {this.id = id;}
    
    public String getName() {return name;}
    public void setName(String name) {this.name = name;}
    
    public String getCategory() {return category;}
    public void setCategory(String category) {this.category = category;}
    
    public String getListedDate() {return listedDate;}
    public void setListedDate(String listedDate) {this.listedDate = listedDate;}
    
    public double getPrice() {return price;}
    public void setPrice(double price) {this.price = price;}
    
    public int getSales() {return sales;}
    public void setSales(int sales) {this.sales = sales;}
    
    public double getRevenue() {return revenue;}
    public void setRevenue(double revenue) {this.revenue = revenue;}
    
}
