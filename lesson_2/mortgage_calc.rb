=begin
Pseudocode for mortgage/car loan calculator

Ask the user for a couple bits of info, including:
  - What kind of loan (Not necessary to calculate, just allows for better prompting)
    - 
  - The loan amount
    - Store as float
  - The Annual Percentage Rate (APR)
  - The loan duration
Store all data collected in a hash
Get type of loan from user
  - Prompt as "What type of loan are you calculating? [Car/Mortgage]: "
  - Accept 'c', 'm', 'car', 'mortgage', or any variation on capital letters
  - Store in hash as loan_type: "Car"/"Mortage"
Get the loan amount from user
  - prompt as "Give loan amount blah blah: $"
  - Accept non-negative floats or integers
  - Store in hash as loan_amount: (user_input converted to a float)
Get the APR from user
  - Prompt as "What is the annual interest rate (APR) on the loan?"
  - Accept an answer with a % sign or a float, convert to float accordingly
  - Store in hash as apr: (user_input converted to a float)
Get the loan length from the user
  - Prompt as "How long is the loan, in years? "
  - Accept a non-negative integer
  - Store  in hash as loan_length_in_months: (user_input * 12)
Run the data through the formula
Present the monthly interest rate, loan duration in months, and monthly payment to the user
Prompt if they want to calculate another loan
  - Loop above code if yes
  - Exit if no
=end
