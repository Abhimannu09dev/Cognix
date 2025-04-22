# 📈 Cognix Seller Dashboard

A modern, JSP-powered dashboard for AI model sellers on the Cognix platform. It provides sellers with real-time analytics, model management, and sales tracking to empower decision-making and growth.

---

## 🌟 Features

### 📊 Dashboard (`dashboard.jsp`)
- Personalized greeting
- Key metrics:
  - Total Models Listed
  - Total Sales
  - Total Revenue
  - Most Popular Model
- Table of best-selling models

### 🧠 Model Management (`models.jsp`)
- Search and filter models
- Category/date filtering
- Actions: Add / Edit / Delete (UI-ready)
- Metrics: Price, Sales, Revenue per model

### 📦 Orders Received (`orders.jsp`)
- Summary cards:
  - Total Orders
  - Revenue
  - Latest Purchase Date
- Filtering:
  - By model type or date range
  - Search by order ID, buyer, model
- Table of order details (ID, price, buyer, etc.)

### 📈 Seller Reports (`reports.jsp`)
- 📌 Summary Cards:
  - Models Listed
  - Orders Received
  - Revenue
  - Best Selling Model
- 📉 Revenue Over Time:
  - Line chart with filters (month/date range/sort)
- 📊 Model Sales Insights:
  - Bar chart with model filtering & sorting
  - Track most/least sold and new/old listings

---

## 💻 Technologies Used

- **Java EE**: JSP
- **Taglibs**: JSTL (`c`, `fmt`, `fn`)
- **Frontend**: HTML5, CSS3, Font Awesome
- **Charts**: [Chart.js](https://www.chartjs.org/)
- **Expected Backend**: Java Servlets / Spring MVC
- **Server**: Apache Tomcat 9+

---

## 📂 Project Structure

📁 WEB-INF   
│ └── 📁 pages │   
└── 📁 component │    ├── SellerNav.jsp │    └── SerachBar.jsp │    ├── dashboard.jsp │    ├── models.jsp │    ├── orders.jsp │    └── reports.jsp 
# 📊 This is the analytics page! 📁 lib │ └── jstl.jar + standard.jar


---

## 🧪 Dynamic Variables (Injected from Backend)

| Variable             | Purpose                                 |
|----------------------|------------------------------------------|
| `${totalModelsListed}` | Total models uploaded by seller         |
| `${totalOrdersReceived}` | Total orders placed for their models    |
| `${totalRevenue}`     | Total revenue generated                  |
| `${bestSellingModel}` | Most sold model                          |
| `${revenueReport}`    | Contains `.labels` and `.data` for chart |
| `${soldReport}`       | Same structure for sales bar chart       |

---

## 🚀 Getting Started

1. Set up a **Dynamic Web Project** in Eclipse/IntelliJ.
2. Add JSTL JARs into `WEB-INF/lib`.
3. Deploy to **Apache Tomcat**.
4. Access via:
```
http://localhost:8080/your-app/pages/HomeSeller.jsp
```
```
http://localhost:8080/your-app/pages/SellerModel.jsp
```
```
http://localhost:8080/your-app/pages/SellerOrder.jsp
```
```
 http://localhost:8080/your-app/pages/SellerReport.jsp
```

---

## 🛠️ To-Do & Enhancements

- [ ] Backend logic for Add/Edit/Delete models
- [ ] Export reports as CSV or PDF
- [ ] Real-time dashboard updates (AJAX/WebSockets)
- [ ] Pagination and sorting for orders
- [ ] More granular filters (buyer geography, model tags)



## 👨‍💻 Author

**Abhimannu Singh Kunwar**  
GitHub: https://github.com/Abhimannu09dev   
Email: anmolkunwar07@gmail.com


> Feedback and PRs welcome. Let’s empower AI sellers with data!

