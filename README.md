# Data processing for large files workshop

The workshop will show you how to process large csv and Excel files using powerful command line tools, without the need to open Excel.

## Setup

To get our work environment started log in to the server I sent on the Slack channel, and run (don't forget to substitute your name):
```
cd csv_workshop
./run_workshop <your name here>
```
This will create a Docker container with your name - This is a sandbox with all the tools that we need already pre-installed.

## Conversion
You will find a sample file in your root directory: `Profile.xls`. As a first step, let's convert it to a csv file for easier processing:
```
in2csv Profile.xls > categories.csv
```
This command takes the first worksheet and pipes its contents into a file called `categories.csv`. But what if we want to take a different worksheet? Let's do that for the prospecting terms worksheet:
```
in2csv --sheet "Prospecting Terms" Profile.xls > prospecting.csv
```
So now we also have a csv for the prospecting terms. In this way you can easily break apart a multiple worksheet excel file.
## Peek-a-boo
So now that we have a file, let's see what it looks like:
```
csvlook categories.csv
```
Ouch! That's a mess. Too many columns and too many lines. Let's try and do better.
## What do you column?
Let's try this (the '|' --pipe-- operator takes one command's output and uses it as input for the next):
```
csvcut -c1,3,5 categories.csv | csvlook
```
This way, we only refer to the first, third and fifth columns. Better, but still too long. Let's add one more thing:
```
csvcut -c1,3,5 categories.csv > short_categories.csv
csvlook short_categories.csv | head
```
With these two commands, we created a new smaller file, and sent the formatted view of the file to a utility that only shows the first 10 lines. 
What if we want to see the first 20 lines?
```
cat short_categories.csv | head -20
```
## Insights
Now that we know how to look at a file, let's see what we can learn about it:
```
csvstat short_categories.csv
```
The result:
```
  1. Keyword
        <type 'unicode'>
        Nulls: False
        Unique values: 398
        5 most frequent values:
                Call Center Management: 5
                Infrastructure Engineer:        4
                Security Architecture Engineer: 4
                Chief Customer Officer: 4
                Infrastructure Manager: 4
        Max length: 35
  2. Type
        <type 'unicode'>
        Nulls: False
        Values: Field, Indicator, Technology, indicator, field
  3. Strength
        <type 'unicode'>
        Nulls: True
        Values: Strong, Medium, Weak, strong

Row count: 648
```
You can get an amazing amount of information with a short command!
## Filtering & Sorting
Let's say we want to see a subset of the data, filtered by a line's strength (Weak) and sorted by it's type:
```
csvgrep -c Strength -m Weak short_categories.csv | csvsort -c Type | csvlook
```
To create a file with the results:
```
csvgrep -c Strength -m Weak short_categories.csv | csvsort -c Type > weak_categories_by_type.csv
```
## Deep diving into the data
If we really want to dive into the data and manipulate it beyond a simple search, we can take the csv file and refer to it as an SQL table. First up, let's see what our file would look like if it were an SQL table:
```
csvsql categories.csv
```
The result:
```
CREATE TABLE categories (
        "Keyword" VARCHAR(35) NOT NULL,
        "Keyword is alias" BOOLEAN NOT NULL,
        "Type" VARCHAR(10) NOT NULL,
        "Aliases" VARCHAR(609),
        "Strength" VARCHAR(6),
        "Category" VARCHAR(33),
        "Type_2" VARCHAR(10),
        CHECK ("Keyword is alias" IN (0, 1))
);
```
From this we see that our table name is categories, as well as the names of the columns we can refer to. Let's make use of this. First run a script that starts a MySQL instance:
```
./init_mysql.sh
```
Now let's import our categories and prospecting files into tables. The following commands create tables and import rows from the files:
```
csvsql --db mysql://localhost:3306/workshop --insert categories.csv
csvsql --db mysql://localhost:3306/workshop --insert prospecting.csv
```
Let's run mysql. First thing, let's switch to the "workshop" database (already created by the script we ran):
```
mysql
```
In MySql:
```
use workshop;
```
You can now go crazy and do whatever MySQL allows you. For example:
```
select distinct c.keyword from categories c, prospecting p where c.aliases like '%'||p.`key term`||'%' and p.levels = 'Staff';
```



