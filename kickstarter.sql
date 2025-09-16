create database kickstarter_analysis;

create table kickstarter_data (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    category VARCHAR(100),
    main_category VARCHAR(100),
    currency VARCHAR(50),
    deadline DATE,
    goal DECIMAL(15, 2),
    launched DATE,
    pledged DECIMAL(15, 2),
    state VARCHAR(50),
    backers INT,
    country VARCHAR(50),
    usd_pledged DECIMAL(15, 2),
    usd_pledged_real DECIMAL(15, 2),
    usd_goal_real DECIMAL(15, 2)
);

-- Failed Projects' Relation to Goals
SELECT 
    main_category,
    backers,
    pledged,
    goal,
    CASE 
        WHEN goal > 0 THEN pledged / goal 
        ELSE 0 
    END AS pct_pledged,
    CASE 
        WHEN goal > 0 AND pledged / goal >= 1 THEN 'Fully funded'
        WHEN goal > 0 AND pledged / goal >= 0.75 AND pledged / goal < 1 THEN 'Nearly funded'
        ELSE 'Not nearly funded'
    END AS funding_status
FROM kickstarter_data
WHERE state = 'failed'   
  AND backers >= 50       
  AND pledged >= 100        
ORDER BY main_category, pct_pledged DESC;

-- Goal ranges
select case 
          when usd_goal_real < 1000 then '$0–$1k'
          when usd_goal_real between 1000 and 5000 then '$1k–$5k'
          when usd_goal_real between 5001 and 10000 then '$5k–$10k'
          when usd_goal_real between 10001 and 50000 then '$10k–$50k'
          else '$50k+' 
       end as goal_range,
       count(*) as total_projects,
       count(case when state='successful' then 1 else null end) as successful_projects,
       round(100.0 * count(case when state='successful' then 1 else null end)/count(*), 2) as success_rate
from kickstarter_data
group by goal_range
order by success_rate desc;

-- Overfunded Projects
select main_category,
	count(*) as overfunded_count,
    round(avg(pledged/goal), 2) as avg_overfunded_ratio
from kickstarter_data
where state = 'successful' and pledged > goal
group by main_category
order by avg_overfunded_ratio desc;

-- Trends by Category
select main_category, count(*) as total_projects, round(avg(pledged/goal), 2) as avg_pct_pledged
from kickstarter_data
where state='failed'
group by main_category
order by avg_pct_pledged desc;

-- Categories with High Variability
select main_category,
	round(stddev(pledged/goal), 2) as funding_variability
from kickstarter_data
group by main_category
order by funding_variability desc;

-- Delving deeper into Fashion category
-- Over-performers
SELECT id, name, pledged, goal, ROUND(pledged/NULLIF(goal,0),2) AS ratio
FROM kickstarter_data
WHERE main_category = 'Fashion' AND goal > 0
ORDER BY ratio DESC
LIMIT 10;

-- Bottom Projects
SELECT id, name, pledged, goal, ROUND(pledged/NULLIF(goal,0),2) AS ratio
FROM kickstarter_data
WHERE main_category = 'Fashion' AND goal > 0
ORDER BY ratio ASC
LIMIT 10;

-- Failed vs Successful Projects
select state, count(*) as total_projects, round(avg(pledged/goal), 2) as avg_pct_pledged
from kickstarter_data
group by state;

-- Backer Distribution
select main_category, round(avg(backers), 2) as avg_backers
from kickstarter_data
group by main_category
order by avg_backers desc;

-- Success vs Failure
select main_category, count(*) as total_projects, round(avg(pledged/goal), 2) as avg_pct_pledged,
count(case when state = 'failed' then 1 else null end) as failed_count,
count(case when state = 'successful' then 1 else null end) as succcess_count,
count(case when state = 'canceled' then 1 else null end) as canceled_count,
count(case when state = 'live' then 1 else null end) as live_count,
count(case when state = 'suspended' then 1 else null end) as suspended_count
from kickstarter_data
group by main_category
order by avg_pct_pledged desc;

-- Backer Analysis
select state, round(avg(backers), 2) as avg_backers
from kickstarter_data
group by state
order by avg_backers desc;

-- Average Pledge per Backer
select main_category, round(avg(pledged/backers), 2) as avg_pledge_per_backer
from kickstarter_data
where backers > 0
group by main_category
order by avg_pledge_per_backer desc;

-- Backers vs Success
select case
	when backers < 50 then 'Under 50'
    when backers between 50 and 200 then '50-200'
    when backers between 201 and 1000 then '201-1000'
    else 'Over 1000'
end as backer_range,
count(*) as total_projects,
count(case when state='successful' then 1 else null end) as successful_projects,
round(100.0 * count(case when state='successful' then 1 else null end)/count(*),2) as success_rate
from kickstarter_data
group by backer_range
order by success_rate desc;

-- Temporal trends
select DATE_FORMAT(launched, '%Y-%m') AS month,
round(AVG(DATEDIFF(deadline, launched)), 2) AS avg_days_active,
count(case when state = 'failed' then 1 else null end) as failed_count,
count(case when state = 'successful' then 1 else null end) as succcess_count
from kickstarter_data
group by month
order by month;

-- Best Duration for Success
select round(avg(DATEDIFF(deadline, launched)), 0) as avg_duration, 
	count(*) as total_projects, 
    round(100.0 * count(case when state='successful' then 1 else null end)/count(*), 2) as success_rate
from kickstarter_data
group by DATEDIFF(deadline, launched)
order by success_rate desc
limit 15;

-- Geography
select country, 
count(case when state = 'failed' then 1 else null end) as failed_count,
count(case when state = 'successful' then 1 else null end) as succcess_count
from kickstarter_data
group by country;
