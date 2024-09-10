-- rank states by obesity prevalence, descending. Calculate the difference between each state's median household income and the nationwide median
SELECT i.state, 
	o.prevalence, 
    i.median_household_income, 
    ROUND(AVG(o.prevalence) OVER(), 1) AS avg_prevalence,
    (SELECT median_household_income
	 FROM median_household_income_2022
	 WHERE state = 'The United States') AS US_median_income,
	i.median_household_income -
    (SELECT median_household_income
     FROM median_household_income_2022
     WHERE state = 'The United States') AS income_diff
FROM median_household_income_2022 AS i
INNER JOIN obesity_overall_2022 AS o
ON i.state = o.state
ORDER BY o.prevalence DESC;

-- calculate Pearson correlation coefficient between median household income and obesity prevalence
SELECT (n * sum_ip - sum_i * sum_p) / SQRT((n * sum_i2 - sum_i * sum_i) * (n * sum_p2 - sum_p * sum_p)) AS pearson_correlation
FROM (
	SELECT COUNT(*) AS n,
		SUM(i.median_household_income) AS sum_i,
        SUM(o.prevalence) AS sum_p,
        SUM(i.median_household_income * o.prevalence) AS sum_ip,
        SUM(i.median_household_income * i.median_household_income) AS sum_i2,
        SUM(o.prevalence * o.prevalence) AS sum_p2
	FROM median_household_income_2022 AS i
    INNER JOIN obesity_overall_2022 AS o
    ON i.state = o.state
	) AS terms; -- pearson_correlation = -0.7676439594808927
    
-- average obesity prevalence and average median household income, grouped by region
SELECT o.region, AVG(o.prevalence) AS avg_prevalence, AVG(i.median_household_income) AS avg_median_household_income
FROM median_household_income_2022 AS i
INNER JOIN obesity_overall_2022 AS o
ON i.state = o.state
GROUP BY o.region
ORDER BY avg_prevalence DESC;

-- average obesity prevalence and average median household income, grouped by division
SELECT o.division, AVG(o.prevalence) AS avg_prevalence, AVG(i.median_household_income) AS avg_median_household_income
FROM median_household_income_2022 AS i
INNER JOIN obesity_overall_2022 AS o
ON i.state = o.state
GROUP BY o.division
ORDER BY avg_prevalence DESC;