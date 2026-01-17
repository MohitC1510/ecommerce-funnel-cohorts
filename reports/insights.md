# E-commerce Performance & Cohort Retention Report
**Project:** E-commerce Funnel + Cohort Retention (Postgres + SQL + Python)  
**Dataset:** Olist (Brazilian e-commerce marketplace)  
**Period Covered:** Sep 2016 – Sep 2018  

---

## 1) Executive Summary
This project analyzes marketplace performance through monthly KPIs, customer behavior, and cohort retention. Revenue and order volume increase sharply through 2017 and stabilize at a higher baseline in 2018. However, repeat purchase behavior is low, with most customers making a single purchase and rarely returning in later months. Revenue is primarily driven by a small set of top categories, with Health & Beauty leading overall contribution.

---

## 2) Dataset & Modeling Approach
### Data tables used
- **customers** (customer_id, customer_unique_id, location)
- **orders** (order timestamps + status)
- **order_items** (line-level prices + freight)
- **payments** (payment types, values)
- **products** (category + product attributes)
- **category_translation** (category name mapping to English)

### Metric definitions (high level)
- **Revenue:** `SUM(price + freight_value)` at the order level  
- **Orders:** count of unique `order_id`  
- **Unique Customers:** count of unique `customer_unique_id`  
- **AOV:** `Revenue / Orders`
- **Orders per Customer:** `Orders / Unique Customers`
- **Cohort Month:** first purchase month for each `customer_unique_id`
- **Retention %:** active customers in month `N` / cohort size (month 0)

---

## 3) KPI Insights (Monthly Trends)

### 3.1 Revenue Trend
Revenue grows steadily from early 2017 and reaches a much higher plateau during 2018. There are clear spikes in late 2017 and early-to-mid 2018, suggesting seasonal effects and/or major campaign periods.

**Note:** The final month shows an extreme drop, which is likely caused by incomplete data for that month rather than an actual business collapse.

**Implication:** The marketplace successfully scaled demand, but month-to-month volatility suggests performance is sensitive to campaigns, seasonality, and fulfillment capacity.

---

### 3.2 Orders vs Unique Customers
Orders and unique customers move almost perfectly together across months. This indicates monthly growth is largely driven by acquiring new buyers rather than repeat purchasing.

**What this suggests:**
- Customer base expanded significantly through 2017.
- The business behaves like a “first-purchase heavy” marketplace, not a subscription-style repeat product.

---

### 3.3 AOV (Average Order Value)
AOV stabilizes in a relatively tight band after early volatility. After the initial months, the typical order value remains fairly consistent, with only mild fluctuations.

**Interpretation:**
- Revenue growth appears to be driven more by order volume than by larger baskets.
- Stable AOV usually means product mix and pricing remained consistent over time.

---

### 3.4 Orders per Customer
Orders per customer stays close to **1.00–1.02** throughout the timeline.

**Meaning:**  
In a given month, most customers place only one order. Repeat purchases inside the same month are rare.

This reinforces the insight that **growth is acquisition-driven**, not retention-driven.

---

## 4) Cohort Retention Analysis

### 4.1 Average Retention Curve (Across Cohorts)
Retention drops sharply after the first purchase:
- Month 0 is always 100% (definition of the cohort).
- Month 1 drops to a very small percentage.
- Beyond month 2, retention is near zero for most cohorts.

This pattern is typical in marketplaces where purchasing is infrequent and customer needs are episodic (buy-and-leave behavior).

---

### 4.2 Cohort Heatmap (Scaled 0–3%)
After rescaling the heatmap, retention becomes visible across months, but remains consistently low. There are small pockets of activity (light-to-medium teal) in some cohorts, but no cohort demonstrates sustained long-term repeat behavior.

**Practical takeaway:**  
The dataset suggests a large proportion of customers behave like one-time shoppers. Even small improvements to early retention (month 1–2) would likely have an outsized impact on long-term value.

---

## 5) Revenue Concentration by Category
The top revenue-driving categories include:
1. **Health & Beauty**
2. **Watches & Gifts**
3. **Bed/Bath/Table**
4. **Sports & Leisure**
5. **Computers & Accessories**

This indicates revenue is concentrated in a small number of high-performing categories, which can be leveraged for growth initiatives (cross-sell, bundling, loyalty incentives).

---

## 6) Recommendations (Actionable + Business-Ready)

### Retention & Repeat Purchase
1. **Second-purchase activation (7–14 days):**  
   Trigger post-purchase messaging to encourage a return visit before the customer churns permanently.
2. **Retention offers for specific categories:**  
   Incentivize follow-up purchases in categories that naturally support repeats (beauty, household, accessories).
3. **Free shipping threshold / loyalty points:**  
   Encourage customers to come back by making the 2nd purchase more rewarding.
4. **Personalized cross-sell on order confirmation pages:**  
   Recommend related products while purchase intent is still high.

### Revenue Growth & Category Strategy
1. **Double down on top categories:**  
   Maintain inventory strength and seller quality in the top 5 categories.
2. **Bundle pricing experiments:**  
   Improve conversion and AOV using bundled discounts (especially bed/bath/table and household-related categories).
3. **Seasonality planning:**  
   Revenue spikes suggest campaign effectiveness — align inventory and marketing cycles around high-performing months.

---

## 7) What I Would Do Next (If This Were a Real Business)
If given more time and deeper data access, I would add:
- **Customer segmentation** (high AOV vs low AOV, category preferences)
- **Repeat buyer profile analysis** (who returns and why)
- **Delivery speed impact** (does faster delivery increase repeat probability?)
- **Payment method analysis** (whether installments affect AOV or churn)
- **Churn prediction model** (Python: logistic regression / XGBoost with explainability)

---

## 8) Limitations
- The dataset appears to have an incomplete final month, which impacts trend interpretation.
- Marketplace buying behavior naturally has low frequency, so “low retention” is not automatically negative — it depends on category and customer intent.
- Without marketing spend or campaign metadata, attribution is directional rather than causal.

---

## 9) Deliverables
- SQL views and marts for dashboard-ready analytics
- Python visualizations (teal theme):
  - Monthly Revenue Trend
  - Orders vs Unique Customers
  - AOV Trend
  - Orders per Customer Trend
  - Cohort Retention Heatmap (scaled)
  - Average Retention Curve
  - Top Categories by Revenue

