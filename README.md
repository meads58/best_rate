#BEST RATE MATCHER

This script will match the amount you want to borrow and return the best available rate from our lender pot.

##Set up
* Make sure ruby is installed. 
* run ```bundle install``` from within the best_rate dir
* The script to run is main.rb with the arguments full path to csv file and the borrower amount e.g. 
** ```ruby main.rb __fullPathTo__market.csv 1000```

##Running the tests
* From within best_rate dir run ```rspec```