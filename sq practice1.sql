create database healthcare;
use healthcare;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50),
    age INT
);
CREATE TABLE policies (
    policy_id INT PRIMARY KEY,
    customer_id INT,
    policy_type VARCHAR(20),
    premium_amount INT,
    start_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
CREATE TABLE claims (
    claim_id INT PRIMARY KEY,
    policy_id INT,
    claim_amount INT,
    claim_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id)
);
CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    policy_id INT,
    payment_date DATE,
    amount INT,
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id)
);

INSERT INTO customers (customer_id, name, city, age) VALUES
(1, 'Akhila', 'Hyderabad', 25),
(2, 'Ravi', 'Bangalore', 35),
(3, 'Sneha', 'Chennai', 28),
(4, 'Arjun', 'Delhi', 40),
(5, 'Meena', 'Mumbai', 32);
INSERT INTO policies (policy_id, customer_id, policy_type, premium_amount, start_date) VALUES
(101, 1, 'Health', 5000, '2023-01-01'),
(102, 2, 'Car', 8000, '2023-02-01'),
(103, 3, 'Health', 6000, '2023-03-01'),
(104, 4, 'Life', 10000, '2023-01-15');
INSERT INTO claims (claim_id, policy_id, claim_amount, claim_date, status) VALUES
(201, 101, 2000, '2023-06-01', 'Approved'),
(202, 102, 5000, '2023-07-01', 'Rejected'),
(203, 103, 3000, '2023-08-01', 'Approved'),
(204, 104, 7000, '2023-09-01', 'Pending');
INSERT INTO payments (payment_id, policy_id, payment_date, amount) VALUES
(301, 101, '2023-01-05', 5000),
(302, 102, '2023-02-05', 8000),
(303, 103, '2023-03-05', 6000),
(304, 104, '2023-01-20', 10000),
(305, 105, '2023-04-05', 7000);
select * from customers;
select * from policies;
select * from claims;
select * from payments;

##Q1: Get all customers from Hyderabad
select * from customers where city='Hyderabad';
##Q2: Count total policies  
select count(*) from policies;
##Q3: Show unique policy types  
select distinct policy_type from policies;
##Q4: Customers with age > 30
select name from customers where age>30;

##Q5: Show customer name and their policy type  
select name,policy_type
from customers as c
left join policies as p
on c.customer_id=p.customer_id;

##Q6: Get all customers who have policies  
select name 
from customers as c
join policies as p
on c.customer_id=p.customer_id;
##Q7: Show customers who don’t have any policy  
select c.name 
from customers as c
left join policies as p
on c.customer_id=p.customer_id
where policy_id is null;
##Q8: Show policy_id and claim status
select p.policy_id,c.status
from policies as p
left join claims as c
on p.policy_id=c.policy_id;
#Q9: Total premium collected  
select sum(premium_amount) from policies;
#Q10: Average claim amount  
select avg(claim_amount) from claims;
#Q11: Total claims per policy  
select p.policy_type,count(c.claim_id)
from policies as p
left join claims as c
on p.policy_id=c.policy_id
group by p.policy_id;
#Q12: Highest premium policy  
select max(premium_amount) from policies;

select policy_id,premium_amount 
from policies
order by premium_amount desc
limit 1;

select c.name,p.policy_type
from customers as c
left join policies as p
on c.customer_id=p.customer_id;

select distinct c.name
from customers c
inner join policies p
on c.customer_id=p.customer_id;

select p.policy_id,c.status
from policies p
left join claims c
on p.policy_id=c.policy_id;

select name,policy_type
from customers c
left join policies p
on c.customer_id=p.customer_id;

#🔴 Q6: Show all policies that have NO claims
select p.policy_id ,c.claim_id
from policies p
left join claims c
on p.policy_id=c.policy_id
where c2.claim_id is null;

#🔴 Q7: Show customers who have NO claims
select distinct c1.customer_id,c1.name,p.policy_id,c2.claim_id
from customers c1
left join policies p
on c1.customer_id=p.customer_id
left join claims c2
on p.policy_id=c2.policy_id
where c2.claim_id is null;

#🔴 Q8: Show customer name + claim status
select c1.name, c2.status
from customers c1
left join policies p
on c1.customer_id=p.customer_id
left join claims c2
on c2.policy_id=p.policy_id
where c2claim_id is not null;

#🔴 Q9: Show customers who have policies AND claims
select c1.customer_id,p.policy_id,c2.claim_id
from customers c1
inner join policies p
on c1.customer_id=p.customer_id
inner join claims c2
on p.policy_id=c2.policy_id;

#❓ “Show customers who have policies but NO claims”
select distinct c1.customer_id,p.policy_id,c2.claim_id
from customers c1
left join policies p
on c1.customer_id=p.customer_id
left join claims c2
on c2.policy_id=p.policy_id
where c2.claim_id is null 
and p.policy_id is not null;

#Show customer name and total number of policies.Include customers who have zero policies.
select c.customer_id, c.name, count(policy_id)
from customers c
left join policies p
on c.customer_id=p.customer_id
group by c.customer_id,c.name;

#Show policy_id and total number of claims.Include policies that have no claims.
select p.policy_id,count(claim_id) 
from policies p
left join claims c
on p.policy_id=c.policy_id
group by p.policy_id;

#Show customer_id and number of policies.Only include customers who have more than 1 policy.
select c.customer_id, count(policy_id)
from customers c
left join policies p
on c.customer_id=p.customer_id
group by c.customer_id
having count(policy_id)>1;

#Show customer names who have at least one claim.
select c1.name,count(c2.claim_id) as claim_no
from customers c1
left join policies p
on c1.customer_id=p.customer_id
left join claims c2
on c2.policy_id=p.policy_id
group by c1.name
having claim_no>=1;

#or
SELECT DISTINCT c1.name
FROM customers c1
JOIN policies p
ON c1.customer_id = p.customer_id
JOIN claims c2
ON p.policy_id = c2.policy_id;

#Show customer name and number of policies.Only include customers who have policies but no claims.
select c1.name,count(p.policy_id)
from customers c1
left join policies p
on c1.customer_id=p.customer_id
left join claims c2
on p.policy_id=c2.policy_id
where p.policy_id is not null 
and c2.claim_id is null
group by c1.name;
#Show customer name and total number of policies.Include all customers.
#Sort by total policies in descending order.
select c.name,count(p.policy_id) as total_policies
from customers c
left join policies p 
on c.customer_id=p.customer_id
group by c.name
order by total_policies desc;

#Show policy_id and number of claims.Only include policies having more than 1 claim.
#Sort by claim count descending.

select p.policy_id,count(c.claim_id)
from policies p
left join claims c
on p.policy_id=c.policy_id
group by p.policy_id
having count(c.claim_id)>1
order by count(c.claim_id) desc;

#Show top 2 customers who paid the highest total amount.(Display customer name and total payment)

#Show customers who have policies but no claims.Display customer name and number of policies.
select c.name,count(p.policy_id) 
from customers c 
left join policies p
on c.customer_id=p.customer_id
left join claims c1
on p.policy_id=c1.policy_id
where p.policy_id is not null and c1.claim_id is null
group by c.name;
#Show policy_id where:policy has at least one payment but no claims exist
select c.name,count(p.policy_id) 
from customers c 
left join policies p
on c.customer_id=p.customer_id
left join claims c1
on p.policy_id=c1.policy_id
where p.policy_id >=1 and c1.claim_id is null
group by c.name;

#Show customer name, policy_type, and claim status.Include all customers even if they don’t have policies.
select c.name,p.policy_type,c1.status
from customers c
left join policies p
on c.customer_id=p.customer_id
left join claims c1
on c1.policy_id=p.policy_id;
#Update premium_amount by increasing 10% for all policies where policy_type = 'Health'

select (premium_amount)+(10% premium_amount)
from policies
where policy_type = 'Health';

##or##

UPDATE policies
SET premium_amount = premium_amount * 1.10
WHERE policy_type = 'Health';

select * from policies;

#Add a new column email to customers table.Then update email values for any 2 customers.
alter table customers
add email varchar(20) unique;
update customers
set email="akhila970@gmail.com"
where name="Akhila";
update customers
set email="kanna2003gmail.com"
where city="Delhi";
select * from customers;

#Show customers who have more than 1 policy AND total payment > 10000
select c.name, p1.amount,count(p.policy_id)
from customers c
left join policies p
on c.customer_id=p.customer_id
left join claims c1
on c1.policy_id=p.policy_id
left join payments p1
on c1.policy_id=p1.policy_id
group by c.name,p1.amount
having count(p.policy_id)>1 and p1.amount>10000;


select premium_amount ,
case
when premium_amount>8000 then 'High'
when premium_amount >5000 and premium_amount<=8000 then 'Medium'
else 'Low'
end as levels
from policies;

select 
case when premium_amount>8000 then 'High' 
when premium_amount >5000 then 'medium'
else 'low' end as levels
,count(*) as total
from policies
group by levels;

select * from policies;
select
sum(case when premium_amount>8000 then 1 else 0 end) as high_count
from policies;

select customer_id,count(*) ,
sum(case when premium_amount>8000 then 1 else 0 end) as high_policy
from policies 
group by customer_id;


select *
from policies 
where start_date>=date_sub(current_date(),interval 60 day);

select policy_id,datediff(curdate(),start_date) as no_days
from policies;

select year(start_date) as yea,count(*) as total_policies
from policies 
group by year(start_date);
