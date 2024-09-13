select state, counties, high_churn_counties, ROUND(high_churn_counties::numeric(10,2)/counties::numeric(10,2),2) pct_counties_high_churn FROM (
select state, count(county) counties, sum(CASE WHEN churn_rate > 0.2 THEN 1 ELSE 0 END) high_churn_counties FROM (
select state, county, customers, churners, ROUND(churners::numeric(10,2)/customers::numeric(10,2),2) churn_rate FROM ( 
select state, county, count(customer_id) customers, sum(churn_int) churners  FROM (
SELECT C.CUSTOMER_ID,
  C.CHURN,
  CASE c.churn WHEN 'Yes' THEN 1 ELSE 0 END churn_int,
  L.STATE,
  L.county
FROM  
  CUSTOMER
  C INNER JOIN LOCATION L ON L.LOCATION_ID = C.LOCATION_ID
)
GROUP BY state, county
)
) 
group by state
)
order by pct_counties_high_churn desc