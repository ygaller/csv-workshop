#/bin/bash

in2csv Profile.xls > categories.csv
in2csv --sheet "Prospecting Terms" Profile.xls > prospecting.csv
csvcut -c1,3,5 categories.csv > short_categories.csv
csvgrep -c Strength -m Weak short_categories.csv | csvsort -c Type > weak_categories_by_type.csv

