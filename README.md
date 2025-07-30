# COGNIX

## Overview
COGNIX is a team-based e-commerce platform for listing and selling AI models. It is designed to connect AI model developers (sellers) with buyers in a structured, admin-controlled environment. The platform supports secure user registration, AI model listing with performance metrics, and browsing/purchasing features for buyers.

## Technologies Used
- JSP (JavaServer Pages)
- Java Servlets
- MySQL
- Apache Tomcat Server

## User Roles
- **Admin**: Full system control, including user and model management.
- **Seller**: Can register, log in, and list AI models with performance details.
- **Buyer**: Can browse and purchase AI models listed by sellers.

---

## My Contributions

This project was developed as part of a team. Below are the components and features I directly worked on:

### Frontend (JSP Pages)
- Developed seller-side interfaces:
  - `HomeSeller.jsp`: Seller dashboard home page
  - `SellerModel.jsp`: Form and display page for listing AI models
  - `SellerOrder.jsp`: Interface for viewing and managing orders received by the seller
  - `SellerReport.jsp`: Interface for sellers to generate and view reports of their model sales and activity

### Backend (Servlet Controllers)
- Implemented corresponding servlets (controllers) to handle business logic and routing for each of the above JSP pages.

### Data Access Layer (DAO Classes)
- Created and maintained:
  - `ReportDAO`: Handles data operations related to seller reports
  - `ModelDAO`: Manages CRUD operations for AI model listings
  - `OrderDAO`: Processes and retrieves order data

### Database Design
- Designed and created the database schema:
  - Defined tables for Users, Models, Orders, and Reports
  - Set up foreign key relationships to support seller-buyer interactions
  - Wrote and tested SQL queries for all CRUD operations

### Integration & Testing
- Integrated frontend, backend, and database layers for seller modules
- Conducted unit and functional testing to ensure reliable seller-side operations


---

## 🔗 Project Link
This is a fork of the original team repository: [Original Repository](https://github.com/utpalogic/Cognix)

---
