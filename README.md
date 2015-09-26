#BEST RATE MATCHER

This script will match the amount you want to borrow and return the best available rate from our lender pot.

##Features
* Given a list of lenders and an amount to borrow it will return the best interest rate, total and monthly repayments.
* Currently all loans are for a 36 month term.
* Only borrower amounts between £1000-£15000 and in increments of £100 will be accepted.

##Set up
* Make sure ruby is installed. 
* run ```bundle install``` from within the best_rate dir
* The script to run is main.rb with the arguments full path to csv file and the borrower amount e.g. 
 ```ruby main.rb __fullPathTo__market.csv 1000```
* There is a test market.csv file in the spec folder that can be used when running the script. Just provide the full path to this file.

##Running the tests
* From within best_rate dir run ```rspec```

##Improvements
* Details about the borrow could be put into it's own class if the loan duration became dynamic or more rules where needed to valid a borrower.
* Split the matcher class out into interest rate and repayment modules if there are more rules.
