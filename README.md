# Kickstarter Project Analysis with SQL  

This project demonstrates how to use SQL to analyze crowdfunding success patterns on Kickstarter.
The goal is to replicate a real-world data analytics workflow: preparing a structured schema, running exploratory queries, and uncovering insights into what makes projects succeed or fail.

---

## Dataset  

- Source: [Kickstarter Projects on Kaggle](https://www.kaggle.com/datasets/kemical/kickstarter-projects)  
- Records: ~375,000 Kickstarter campaigns across multiple categories and countries 
- Each row contains:
  - Project ID 
  - Project Name 
  - Category
  - Main Category
  - Currency 
  - Deadline
  - Goal
  - Launch Date
  - Amount Pledged
  - Current Condition (failed, succcessful, etc.)
  - Backers
  - Country
  - USD Pledged, USD Pledged Real, and USD Goal Real

---

## Data Preparation (ETL)  

The dataset was loaded into MySQL Workbench and structured in a single analysis table.

The table mirrors the Kaggle dataset, enabling analysis of goals, pledges, backers, timelines and outcomes.

---

## Analysis Queries  

I wrote several SQL queries to explore trends and business questions:  

1. **Failed Projects and Goal Ratios**  
   - Checked how close failed projects were to achieving their goal targets.  

2. **Goal Ranges and Success Rates**  
   - Grouped projects into funding goal buckets (0-1k, 1k-5k, 5k-10k, 10k-50k, 50k+).  
   - Calculated total projects and success rates.

3. **Overfunded Projects**
   - Found categories with the highest 'overfunding ratio' (pledged > goal).
  
4. **Trends by Category**
   - Average pledge-to-goal ratios across failed projects.

5. **Funding Variability**  
   - Used STDDEV(pledged/goal) to measure how consistent or volatile funding success is per category.

6. **Deep Dives**
   - The fashion category returned a considerably high variability, so I wanted to see the top and bottom 10 projects by pledge-to-goal ratio.
  
7. **Backer Analysis**
   - Compared average backers per category.
   - Grouped projects by backer ranges (under 50, 50-200, etc.) and success rate.
   - Calculated average pledge per backer.
  
8. **Success vs Failure**
   - Count of projects by outcomes across categories.
  
9. **Temporal Trends**
    - Measured project durations and their relationship to success.
    - Checked best-performing campaign lengths.
  
10. **Geography**
    - Counted successful vs failed projects by country.

---

## Key Insights  

- **Success Rates vs Goals:** Smaller goals succeed more often, with goals between $0-$1k USD succeeding 53.23% of the time and goals between $5k-$10k succeeding 53.42% of the time.
- **Fashion Category:** Fashion has a considerably high variability, with many successful campaigns but the overall outcomes are less predictable due to a few massively overfunded projects.
- **Average Backers:** Successful projects tend to have roughly 264 backers on average.
- **Pledge per Backer:** Technology saw the highest pledge per backer, at about $283 per backer. More than double the second category of design, which has about $86 per backer.
- **Best Month to Launch:** November has the most successful projects while August tends to have the most failed projects.
- **Overfunded Projects:** Fashion, Design and Technoloy were the top 3 overfunded categories.

---

## How to Run  

1. Clone this repo.  
2. Download the [Kickstarter Projects on Kaggle](https://www.kaggle.com/datasets/kemical/kickstarter-projects).
3. Specifically, download the `ks-projects-201801.csv` file.
4. Import the CSV file into MySQL via the Workbench Table Data Import Wizard.  
5. Run the single SQL script kickstarter.sql to:
   - Create schema and table 
   - Execute analysis queries  

---

## Repository Structure 

├── kickstarter.sql 

├── README.md

---
 
## Takeaway  

This project highlights SQL skills for exploratory data analysis on real-world business-style data.

It covers:
- Aggregation and grouping
- Conditional bucketing and case logic
- Statistical measures (standard deviation, averages, ratios)

The result is a clear picture of what drives success on Kickstarter, actionable for creators, investors or platforms.
