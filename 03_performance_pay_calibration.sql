-- 03_performance_pay_calibration.sql
-- Ratings distribution
SELECT p.period, e.department, e.level, p.rating, COUNT(*) AS n
FROM performance_reviews p
JOIN employees e USING(employee_id)
GROUP BY 1,2,3,4
ORDER BY 1,2,3,4;

-- Pay vs. department-level median by level
WITH comp AS (
  SELECT c.employee_id, e.department, e.level, c.base_salary
  FROM compensation c
  JOIN employees e USING(employee_id)
),
dept_level AS (
  SELECT department, level, 
         PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY base_salary) AS median_pay
  FROM comp
  GROUP BY 1,2
)
SELECT c.employee_id, c.department, c.level, c.base_salary, d.median_pay,
       ROUND((c.base_salary - d.median_pay)*1.0/d.median_pay,3) AS pct_from_median
FROM comp c
JOIN dept_level d USING(department, level)
ORDER BY ABS(pct_from_median) DESC;
