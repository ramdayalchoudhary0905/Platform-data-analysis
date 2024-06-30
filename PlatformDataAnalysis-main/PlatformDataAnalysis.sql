--Top User-TimeUSage/Amount
WITH cte1 AS (
SELECt ProductPlan.PlanID,
SUM(Pricing.net) AS TotalNet
FROM ProductPlan
JOIN Pricing ON ProductPlan.PlanType = Pricing.Plan_Type
GROUP BY ProductPlan.PlanID
)
SELECT cte1.planid AS USERID, cte1.TotalNet as Amount, PlanData.totaltimeusage as TimeUsage
FROM cte1
JOIN PlanData ON cte1.PlanID = PlanData.UserID
order by totalnet desc;

-----------------------------------------------------------------------------------------------------------

--Payment Mode Count
Select PaymentMode, count(PaymentMode) as Total 
from ProductPlan
group by PaymentMode
order by Total desc;

-----------------------------------------------------------------------------------------------------------

--Plans Sold/Revenue Generated-Per PlanType
select ProductPlan.PlanType,count(ProductPlan.PlanType) as count, Sum(Pricing.net) as Amount
from ProductPlan 
join Pricing on ProductPlan.PlanType=Pricing.Plan_Type
group by ProductPlan.PlanType
order by Amount;

-----------------------------------------------------------------------------------------------------------

--Plans Sold/Revenue Generated-InTotal
WITH CTE2 AS (
SELECT ProductPlan.PlanType, COUNT(ProductPlan.PlanType) AS counts, SUM(Pricing.net) AS Amount
FROM ProductPlan
JOIN Pricing ON ProductPlan.PlanType = Pricing.Plan_Type
GROUP BY ProductPlan.PlanType
)
SELECT sum(Counts) as Total_Plans, sum(amount) as Total_Revenue
FROM CTE2
ORDER BY sum(amount);

-----------------------------------------------------------------------------------------------------------

--Daily Registration
Select RegistrationDate, count(*) as Total
from UserPlans
Group by RegistrationDate
ORDER BY RegistrationDate ;

-----------------------------------------------------------------------------------------------------------

--Monthly Registration
SELECT 
Substring(RegistrationDate, 6, 2) AS month, 
COUNT(*) AS Total,
CASE 
WHEN Substring(RegistrationDate, 6, 2) = '01' THEN 'JAN'
WHEN Substring(RegistrationDate, 6, 2) = '02' THEN 'FEB'
WHEN Substring(RegistrationDate, 6, 2) = '03' THEN 'MAR'
ELSE 'APR'
END AS MonthAbbreviation
FROM UserPlans
GROUP BY Substring(RegistrationDate, 6, 2)
ORDER BY month;

-----------------------------------------------------------------------------------------------------------

--User not retained / Upgraded / Degraded
WITH PlanCases AS (
SELECT
CASE
WHEN NumberOfPlans = 1 THEN 'Not Retained'
WHEN NumberOfPlans IN (2, 3) THEN
CASE
WHEN StartingPlan = CurrentPlan THEN 'Unchanged'
WHEN StartingPlan = 'Basic' AND CurrentPlan IN ('Standard', 'Premium') THEN 'Upgrade'
WHEN StartingPlan = 'Standard' AND CurrentPlan = 'Premium' THEN 'Upgrade'
WHEN StartingPlan = 'Standard' AND CurrentPlan = 'Basic' THEN 'Downgrade'
WHEN StartingPlan = 'Premium' AND CurrentPlan IN ('Basic', 'Standard') THEN 'Downgrade'
END
END AS PlanCase
FROM
UserPlans  
)
SELECT PlanCase AS Cases, COUNT(*) AS Total
FROM PlanCases
GROUP BY PlanCase;

-----------------------------------------------------------------------------------------------------------

--Tables
Select *
From PlanData;

Select *
From ProductPlan;

Select *
From UserPlans;

Select *
From Pricing;
