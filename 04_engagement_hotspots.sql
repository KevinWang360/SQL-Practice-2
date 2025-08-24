-- 04_engagement_hotspots.sql
-- Manager rollup (latest survey before 2025-06-01)
WITH latest AS (
  SELECT er.employee_id, MAX(er.survey_date) AS survey_date
  FROM engagement_responses er
  WHERE er.survey_date <= '2025-06-01'
  GROUP BY 1
),
joined AS (
  SELECT e.manager_id, er.*
  FROM latest l
  JOIN engagement_responses er
    ON er.employee_id=l.employee_id AND er.survey_date=l.survey_date
  JOIN employees e ON e.employee_id=er.employee_id
)
SELECT manager_id,
       AVG(manager_effectiveness) AS avg_mgr_effectiveness,
       AVG(workload) AS avg_workload,
       AVG(intent_to_stay) AS avg_stay_intent,
       COUNT(*) AS n_reports
FROM joined
GROUP BY manager_id
ORDER BY avg_mgr_effectiveness ASC, avg_workload DESC;
