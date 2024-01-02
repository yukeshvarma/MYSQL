SELECT * FROM moviesdb.movies;

#1.Print all movie titles and release year for all Marvel Studios movies.
select title,release_year from movies
where studio='Marvel Studios';

#2. Print all movies that have Avenger in their name.
select * from movies
where title like '%avenger%';

#3. Print the year when the movie "The Godfather" was released.
select title,release_year from movies
where title ='The Godfather';

#4. Print all distinct movie studios in the Bollywood industry.
select distinct(studio) from movies
where industry = 'bollywood';

#5  Print all movies in the order of their release year (latest first)
select title,release_year from movies
order by release_year asc;

#6  All movies released in the year 2022
select title,release_year from movies
where release_year='2022';

#7 Now all the movies released after 2020
select * from movies
where release_year > 2020;

#8 All movies after the year 2020 that have more than 8 rating
select * from movies
where release_year > 2020
having imdb_rating>8;

#9 Select all movies that are by Marvel studios and Hombale Films
select * from movies
where studio in ('Marvel studios' ,'Hombale Films');

#10 Select all THOR movies by their release year
select title,release_year from movies
where title like '%thor%';

#11 Select all movies that are not from Marvel Studios
select * from movies
where studio != 'Marvel Studios';

#12  How many movies were released between 2015 and 2022
select * from movies
where release_year between 2015 and 2022;

#13  Print the max and min movie release year
(SELECT release_year AS MAX_MIN_YEAR FROM MOVIES
group by release_year
order by RELEASE_YEAR desc
LIMIT 1)
UNION ALL
(SELECT release_year AS MAX_MIN_YEAR FROM MOVIES
group by release_year
order by RELEASE_YEAR ASC
LIMIT 1);

#14 Print a year and how many movies were released in that year starting with the latest year
SELECT COUNT(title) as count ,release_year from movies
group by release_year
order by release_year desc;

#15  Print profit % for all the movies
SELECT * FROM FINANCIALS;
create view profit as
SELECT *, (revenue-budget) as profit from financials;
CREATE VIEW INR_PROFIT AS
select *, if (currency='USD',profit*80,profit) as INR_PROFIT from profit;
select *, 
case
when unit='billions' then INR_PROFIT*1000
when unit='thousands' then INR_PROFIT/1000
when unit='millions' then INR_PROFIT

end as INR_PROFIT_MLN FROM INR_PROFIT;

# Show all the movies with their language names
select title,name from movies as m
inner join languages as l on l.language_id=m.language_id;

#Show all Telugu movie names (assuming you don't know the languageid for Telugu)
select title from movies as m
inner join languages as l on l.language_id=m.language_id
where name = 'telugu';

# Show the language and number of movies released in that language
select name,count(*) as num from movies as m
inner join languages as l on l.language_id=m.language_id
group by name;





