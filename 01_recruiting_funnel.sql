-- 01_recruiting_funnel.sql
-- Stage conversion by source & department
WITH base AS (
  SELECT a.*, j.department, j.level
  FROM applications a
  JOIN jobs j USING(job_id)
),
counts AS (
  SELECT department, source,
         COUNT(*) AS applied,
         SUM(final_stage IN ('screen','onsite','offer','accepted')) AS screened,
         SUM(final_stage IN ('onsite','offer','accepted')) AS onsites,
         SUM(final_stage IN ('offer','accepted')) AS offers,
         SUM(outcome='Hired') AS hires
  FROM base
  GROUP BY 1,2
)
SELECT department, source,
       ROUND(screened*1.0/applied,3) AS p_screen,
       ROUND(onsites*1.0/screened,3) AS p_onsite_given_screen,
       ROUND(offers*1.0/onsites,3) AS p_offer_given_onsite,
       ROUND(hires*1.0/offers,3) AS p_accept_given_offer,
       ROUND(hires*1.0/applied,3) AS p_overall_hire
FROM counts
ORDER BY department, source;

-- Time-to-fill (open -> hired decision)
SELECT j.department, j.level,
       ROUND(AVG(julianday(a.decision_date) - julianday(j.opening_date)),1) AS avg_days_to_fill
FROM applications a
JOIN jobs j USING(job_id)
WHERE a.outcome='Hired'
GROUP BY 1,2
ORDER BY 1,2;
