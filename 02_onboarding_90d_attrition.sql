-- 02_onboarding_90d_attrition.sql
WITH hires AS (
  SELECT e.employee_id, e.department, e.role, e.level, DATE(e.hire_date) AS hire_date
  FROM employees e
),
early_exit AS (
  SELECT h.employee_id,
         MIN(DATE(x.exit_date)) AS exit_date,
         (julianday(MIN(DATE(x.exit_date))) - julianday(h.hire_date)) AS days_to_exit
  FROM hires h
  LEFT JOIN exits x USING(employee_id)
  GROUP BY 1
),
first_training AS (
  SELECT t.employee_id, MIN(DATE(t.date)) AS first_training_date
  FROM training t
  GROUP BY 1
)
SELECT h.department, h.level,
       ROUND(AVG(CASE WHEN ee.days_to_exit IS NOT NULL AND ee.days_to_exit<=90 THEN 1 ELSE 0 END),3) AS p_90d_attrition,
       ROUND(AVG(CASE WHEN ft.first_training_date IS NOT NULL 
                      AND julianday(ft.first_training_date) - julianday(h.hire_date) <= 60 THEN 1 ELSE 0 END),3) AS pct_trained_60d
FROM hires h
LEFT JOIN early_exit ee USING(employee_id)
LEFT JOIN first_training ft USING(employee_id)
GROUP BY 1,2
ORDER BY 1,2;
