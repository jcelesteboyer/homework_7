# homework_7

In class assignment: 

Dirty data: 
1. Extra space in the column name
2. The use of symbols 
3. Too many uneeded columns
4. Missing data points
5. Wrong data type for the function needed. 

How to fix the ditry data:
1. Replace spaces in the column name or rename the column. 
2. Loop through the data and remove the symbol. 
3. Remove columns 
4. Use dropna, drop duplicates, or fillna functions. 
5. Change the data needed to the correct data type with str or int. 

Choosing interesting APIs: 
1. FBI Crime Data API - https://crime-data-explorer.fr.cloud.gov/api 
2. Petfinder API - https://www.petfinder.com/developers/

![Grocery Store RD](https://github.com/jcelesteboyer/homework_7/blob/fc5889f0efe3f04d590031954a367d51665dc0cf/Grocery%20Store%20ERD.png)


Autoincrementing in SQL is a way to automatically count up by each new record in the table. This is similar to a counter in python. 
In order to use the autoincrementing function you will need to use the keyword IDENTITY. Naturally, it will start off at one and then 
count up by one each time. The syntax is typically creating a new column where the count is put into, followed by IDENTITY(). In the 
paraentheses you can specify what number to start at and how much to increment. Then finally you end that statement with the keywork PRIMARY KEY. 

The difference between a subque and a join is the syntax and the cost of each. A subquery is a SELECT query inside of another query. This is usually much faster to type out and has a higher readability. One of the advantages to a subquery is that you can use that subquery in the outter query. A join is when you combine two or more tables together. You can do this many ways and by using either full tables or just chuncks of tables. The syntax for joins can be hard to read and difficult to type out. Choosing the right type of join can be difficult and cause more problems if you choose the wrong one. 

![Data Camp Joins](https://github.com/jcelesteboyer/homework_7/blob/a6fb2e34d083fefc88ce124b4287d27ce46bddc9/Data%20Camp%20Joins.png)
