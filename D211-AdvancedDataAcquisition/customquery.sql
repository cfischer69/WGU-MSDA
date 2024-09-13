SELECT
	c.customer_id,
	c.lat,
	c.lng,
	c.age,
	c.marital,
	c.gender,
	c.tenure,
	c.monthly_charge,
	c.income,
	c.churn,
	l.city,
	l.zip,
	l.county,
	l.state,
	s.region,
	ct.duration,
	p.payment_type
FROM
	customer c
	INNER JOIN location l ON l.location_id = c.location_id
	INNER JOIN stateregion s ON s.state = l.state
	INNER JOIN contract ct ON ct.contract_id = c.contract_id
	INNER JOIN payment p ON p.payment_id = c.payment_id
WHERE l.state NOT IN ('AK','HI','PR')