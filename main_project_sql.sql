use human_resource;
select * from hr;

# describe function helps to see overview of data
describe hr;

# in raw data em_id column name changed permanently
alter table hr
change column ï»¿id em_id varchar(20);

#setting the software to update
set sql_safe_updates =0;

#birthdate column datatype must be in date 
UPDATE hr
SET birthdate = CASE
	WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;
alter table hr
modify column birthdate date;

#for hire date same as birthdate
UPDATE hr
SET hire_date = CASE
	WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;
alter table hr
modify column hire_date date;

#for term date keep the null value as it is
select * from hr;

UPDATE hr
SET termdate = CASE
    WHEN termdate IS NOT NULL AND termdate != '' THEN DATE(STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC'))
    ELSE NULL
END
WHERE termdate IS NOT NULL AND termdate != ' ';

update hr
set termdate = case 
when termdate is null then '0000-00-00'
else termdate
end;


#need age column 
alter table hr
add column age int after birthdate;

#finding age by their date of birth
update hr
set age = timestampdiff(year,birthdate,current_date()) ;
 
 #22214 total rows in that 1477 rows are error due to improper data collection
select count(*) from hr
where termdate > current_date(); 

#22214 under the age 967 they cannot be employee
select count(*) from hr
where age < 18;
 
-- 1. What is the gender breakdown of employees in the company?
select count(*),gender from hr 
where age > 18 and termdate ='0000-00-00'
group by gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?
select race,count(*) from hr
where age > 18 and termdate ='0000-00-00'
group by race;

-- 3. What is the age distribution of employees in the company?
select case when age between 18 and 25 then '18-25'
 when age between 26 and 35 then '26-35'
  when age between 36 and 45 then '36-45'
   when age between 46 and 55 then '46-55'
   else '55+'
   end as age_group,count(*) as count from hr
where age > 18 and termdate ='0000-00-00'
group by age_group;

-- 4. How many employees work at headquarters versus remote locations?
select location,count(*) from hr
where age > 18 and termdate ='0000-00-00'
group by location;

-- 5. What is the average length of employment for employees who have been terminated?
select round(avg(datediff(termdate,hire_date))/365,0) as avg_len_employement from hr
where termdate < current_date() and termdate !='0000-00-00' and age>18;

-- 6. How does the gender distribution vary across departments ?
select department,gender,count(*) from hr
where age > 18 and termdate ='0000-00-00'
group by gender,department;

-- 7. What is the distribution of job titles across the company?
select jobtitle,gender,count(*) from hr
where age > 18 and termdate ='0000-00-00'
group by jobtitle,gender;

-- 8. Which department has the highest turnover rate?
select department,total_count,turnover,concat(round(turnover/total_count*100,0),'%') as turnover_rate from 
(select department,count(*) as total_count,
 sum(case when termdate != '0000-00-00' and termdate < current_date() then 1 else 0  end) as turnover
 from hr
 where age > 18
group by department) as subquery
order by turnover_rate desc;

-- 9. What is the distribution of employees across locations by city and state?
select location_city,location_state,count(*) from hr
where age > 18 and termdate ='0000-00-00'
group by location_city,location_state
order by count(*);

-- 10. How has the company's employee count changed over time based on hire and term dates?
select year,hire,term,hire-term as net_change,
 (hire-term)/hire*100 as percentage from 
 (select
year(hire_date) as year,
count(*) as hire,
sum(case when termdate != '0000-00-00' and termdate < current_date() then 1 else 0 end) as term
from hr
where age > 18 
group  by year(hire_date)) as subquery
order by year asc;

-- 11. What is the tenure distribution for each department?
select department,round(avg(datediff(termdate,hire_date)/365),2) as avg_tenure from hr
where termdate != '0000-00-00' and termdate < curdate()
group by department;


