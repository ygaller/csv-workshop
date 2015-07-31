# Data processing for large files workshop

The workshop will show you how to process large csv and Excel files using powerful command line tools, without the need to open Excel.

## Setup

To get our work environment started, let's go to our work directory and run the script:
```
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
csvlook profile.csv
```
Ouch! That's a mess. Too many columns and too many lines. Let's try and do better.
## What do you column?
Let's try this (the '|' --pipe-- operator takes one command's output and uses it as input for the next):
```
csvcut -c1,3,5 profile.csv | csvlook
```
This way, we only refer to the first, third and fifth columns. Better, but still too long. Let's add one more thing:
```
csvcut -c1,3,5 profile.csv > short_profile.csv
csvlook short_profile.csv | head
```
With these two commands, we created a new smaller file, and sent the formatted view of the file to a utility that only shows the first 10 lines. 
What if we want to see the first 20 lines?
```
cat short_profile.csv | head -20
```
## Insights
Now that we know how to look at a file, let's see what we can learn about it:
```
csvstats short_profile.csv
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
csvgrep -c Strength -m Weak short_profile.csv | csvsort -c Type | csvlook
```
To create a file with the results:
```
csvgrep -c Strength -m Weak short_profile.csv | csvsort -c Type > weak_categories_by_type.csv
```

