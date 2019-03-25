select * from NYC

/* Q1. How many flights were there to go from NYC to Seattle in 2013. */

select count(*) as flight_count
from NYC
where dest ='SEA' and year =2013

/* Q2. How many airlines fly from NYC to seattle */

select count(distinct carrier) airline_count
from NYC
where dest ='SEA' and year =2013

/*Q3. How many unique airplanes fly from NYC to seattle */
select count(distinct tailnum) airplane_count
from NYC
where dest ='SEA' 

/* Q4. What is the average arrival delay of the flights from NYC to Seattle */

select avg(arr_delay) avg_arrival_delay
from nyc
where dest = 'SEA'

select avg(arr_delay) avg_arrival_delay
from nyc
where dest = 'SEA' and arr_delay>0

/* Q5. What's the proportion of all the flights travelling to seattle from different NYC airports? */

select origin, round(count(*)*100/(select count(*) from nyc where dest ='SEA'),2)
from nyc
where dest='SEA'
group by origin 

with 
temp as (select * from nyc where dest='SEA')

select origin, count(*)*100/(select count(*) from temp) as proportion
from temp
group by origin
order by 2 desc

/* Q6. Which date has the largest average departure delay? Which date has the largest average arrival
delay? */


select year,month,day, avg(dep_delay) as del
from nyc
group by year,month,day 
order by 4 desc

/*Q7. What was the worst day to fly out of NYC in 2013 if you dislike delayed flights? (This one is less
straightforward in SQL than you may expect.) */

select year,month,day,max(dep_delay)
from nyc
group by year,month,day
order by 4 desc


/*Q8.Is Autumn (September, October, November) worse than Summer (June, July, August) for flight delays
for flights from NYC? */

select case when temp.month in (9,10,11) then 'Autumn'
		when temp.month in (6,7,8) then 'Summer' end as seasons,
		sum(temp.delays)
	from(select month,avg(dep_delay) as delays
	from nyc
	group by month) as temp
	group by 1

select b.Seasons,sum(avg_dep_delay) as total_delay
from(
	select
	case when a.month in (6,7,8) then 'Summer'
	when a.month in (9,10,11) then 'Autumn'
	when a.month in (12,1,2) then 'Winter'
	when a.month in (3,4,5) then 'Spring'
	END as Seasons,
	avg_dep_delay
	from
		(SELECT month, avg(dep_delay) as avg_dep_delay FROM nyc
		where dep_delay>0
		group by month
		)a
	)b
	group by b.Seasons
	order by 2 desc

/*Q9. On average, how do departure delays vary over the course of a day? You can compute the average
delay by hour of day, such that your result will have 24 records (be careful -- there are records with hour
0 and hour 24. Consider lumping these together or justify any other solution you come up with.) No
need to plot the results.*/

select distinct hour from nyc order by 1

select hour, avg(dep_delay)
from nyc
group by hour
order by hour

select case when hour =0 then 0 
			when hour = 24 then 24
			else hour end as hour1,
			avg(dep_delay)
			from nyc
			group by hour

/*Q10. Velocity: Which flight departing NYC in 2013 flew the fastest?*/

select flight, (distance*60/air_time) as speed
from nyc
where year=2013
order by 2 desc

select air_time from nyc

/*Q11. Routine flights: Which flights (i.e. carrier + flight + dest) happen every day? */

select carrier,flight,dest, count(distinct concat(year,'',month,'',day))as dat
from nyc
group by carrier,flight,dest
having count(distinct concat(year,'',month,'',day))=365


/*Q12. Question: For which combination of origin and destination is the average arrival delay significant?
What carrier causes most of these delays? */

select origin, dest,carrier, avg(dep_delay) as delays
from nyc
group by origin,dest,carrier
order by avg(dep_delay) desc