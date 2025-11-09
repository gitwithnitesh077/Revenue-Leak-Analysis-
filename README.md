# Revenue-Leak-Analysis-
This project identifies and analyzes revenue leakages using **SQL** for data extraction and **Power BI** for visualization.   It helps business users track payment discrepancies, identify leakage trends, and take data-driven corrective actions.

## 🎯 Objective
The **Revenue Leak Analysis Dashboard** identifies and visualizes **revenue leakage** across regions, plans, and customer segments.  
This project integrates **SQL Server** for data modeling and **Power BI** for insightful, interactive dashboards — helping businesses take corrective actions to minimize losses.



## 🧰 Tech Stack

| Tool | Purpose |
|------|----------|
| **SQL Server** | Data storage, transformations, and leak calculations |
| **Power BI** | KPI visualization and interactive reporting |
| **DAX** | Custom measures for revenue leak %, rankings, and KPIs |
| **GitHub** | Documentation and version control |

---

## 📊 Key Performance Indicators (KPIs)

| KPI | Value | Description |
|-----|--------|-------------|
| 💰 **Total Expected Revenue** | ₹4.57M | Total billable revenue |
| 💵 **Total Actual Revenue** | ₹4.40M | Actual collected payments |
| ⚠️ **Total Revenue Leak** | ₹178.40K | Difference between expected and paid |
| 📉 **Leak Percentage** | 3.9% | (Leak / Expected) × 100 |

---

## 🧩 Project Workflow

### 1️⃣ Data Preparation
- Created structured tables: `customers`, `plans`, `subscriptions`, and `payments`.
- Used SQL joins and `ISNULL()` for handling nulls.
- Verified relationships to ensure clean model import in Power BI.

### 2️⃣ SQL Analysis Views
- **`vw_revenue_leak`** → Calculates expected, paid, and leak values per customer.  
- **`vw_revenue_leak_summary_all`** → Summarizes revenue leak % by region, plan, and payment status.

### 3️⃣ Power BI Dashboard Development
- Connected SQL Server to Power BI.
- Built KPIs for financial overview.
- Created visuals:
  - **Leak by Region**
  - **Leak by Plan**
  - **Leak by Payment Status**
  - **Top Leaking Customers**
- Added slicers for `Plan Name`, `Region`, and `Payment Status`.

### 4️⃣ Insight Generation
- West region shows **highest revenue leak**.
- **Enterprise plans** contribute major portion of the loss.
- Main issue found: **unpaid and partially paid invoices**.
- Overall leak = **3.9% (₹178K)**.

### 5️⃣ Summary Table
- Created a combined matrix view showing total expected, paid, and leak across all business dimensions.

---

## 📈 Dashboard Visuals

### 🧮 KPI Dashboard  
<img width="1123" height="660" alt="Screenshot 2025-11-09 112649" src="https://github.com/user-attachments/assets/8e2767ea-f6d0-4363-ab53-eaef80a0ae97" />


### 🌍 Revenue Leak by Region  
<img width="1434" height="731" alt="Screenshot 2025-11-09 160710" src="https://github.com/user-attachments/assets/0aa8a14c-4835-4707-9883-dca1e69fdd50" />

### 💳 Revenue Leak by Payment Status  
<img width="1187" height="733" alt="Screenshot 2025-11-09 160912" src="https://github.com/user-attachments/assets/94a74ad5-a28f-4e89-ae25-69654760dc54" />

### 👥 Top Leaking Customers  
<img width="1387" height="741" alt="image" src="https://github.com/user-attachments/assets/618a07ba-2cd6-48a8-80d5-5a8879be6766" />


### 📋 Summary Table  
<img width="1347" height="731" alt="image" src="https://github.com/user-attachments/assets/93b48bed-82d5-4385-8bfc-31570f889bb1" />


---

## 💬 Insights
- **West Region** shows the **highest leak** of all regions.  
- **Enterprise Plan** customers have higher default rates.  
- **Unpaid** and **Partial** payment statuses contribute most to revenue loss.  
- Potential recovery value = **₹178K (3.9%)**.

---

## 💡 Recommendations
✅ Strengthen follow-ups for **Enterprise** customers in **West Region**.  
✅ Offer **early-payment discounts** to reduce leakage.  
✅ Automate **billing reminders** and payment status alerts.  
✅ Build a **monthly trend report** to monitor leakage proactively.

---

## 🗂️ Folder Structure
