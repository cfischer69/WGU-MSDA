-- Chris Fischer
-- Student ID: 011933891

-- Using database churn
-- Show tables node

--------------------------------
-- Create a user-defined data type
--------------------------------
CREATE DOMAIN survey_answer AS smallint
	NOT NULL
	CHECK (VALUE BETWEEN 1 AND 8);

--------------------------------
-- Create a table to hold the imported survey response data
--------------------------------
CREATE TABLE survey_responses (
	 customer_id 				VARCHAR(128)
	,timely_responses 			survey_answer 
	,timely_fixes 				survey_answer
	,timely_replacements		survey_answer
	,reliability 				survey_answer
	,have_options 				survey_answer
	,respectful_response		survey_answer
	,courteous_exchange			survey_answer
	,active_listening 			survey_answer
	,CONSTRAINT pk_survey_responses
		PRIMARY KEY (customer_id)
	,CONSTRAINT fk_survey_responses_customer
		FOREIGN KEY (customer_id) 
		REFERENCES customer(customer_id)
);

-- Refresh tables node

-- Demonstrate that the table is empty
SELECT *
  FROM survey_responses;

--------------------------------
-- Import the survey response CSV file 
-- into the table just created
--------------------------------
COPY survey_responses (customer_id
					  ,timely_responses
					  ,timely_fixes
					  ,timely_replacements
					  ,reliability
					  ,have_options
					  ,respectful_response
					  ,courteous_exchange
					  ,active_listening) 
	FROM 'c:/LabFiles/SURVEY~1.CSV' 
	CSV HEADER QUOTE '"' ESCAPE '''';

--------------------------------
-- Verify the number of rows imported
--------------------------------
SELECT COUNT(*)
  FROM survey_responses;

--------------------------------
-- Examine a sample of the imported data
--------------------------------
SELECT * 
  FROM survey_responses
 LIMIT 10;

--------------------------------
-- Answer the research question
--------------------------------
-- First, define a CTE to segment customers by decade of age
WITH customer_segments AS (
		SELECT customer_id
			  ,age - MOD(age,10) AS decade
		  FROM customer
		),
-- Next, define a CTE which computes the average total score for each segment
	decade_groups AS (
		SELECT c.decade AS decade
			  ,COUNT(*) AS customer_count
			  ,ROUND(AVG(timely_responses + 
			  			 timely_fixes + 
						 timely_replacements + 
						 reliability + 
						 have_options + 
						 respectful_response + 
						 courteous_exchange + 
						 active_listening)
				    ,2) AS avg_total_score
		  FROM customer_segments AS c
		  JOIN survey_responses AS s USING (customer_id)
		 GROUP BY decade
		)
-- Last, rank the segments by total score, highest best, and sort results in rank order
SELECT RANK() 
	   OVER (ORDER BY d.avg_total_score DESC) AS ranked
      ,d.decade
      ,d.avg_total_score
  FROM decade_groups AS d
 ORDER BY ranked ASC;