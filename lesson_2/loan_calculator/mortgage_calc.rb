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



#TODO: Figure out how to create blocks that will loop through a prompt and validate
#      - without needing to create new methods for every single prompter and validator

require 'yaml'

PROMPTS = YAML.load_file('prompts.yml')
ERRORS = YAML.load_file('errors.yml')
RESULT = YAML.load_file('result.yml')

def interpolate_prompt(prompt, interp = {})
  format(prompt, interp)
end

def format_prompt(prompt, prompt_type, interps = {})
  prompt = interpolate_prompt(prompt, interps) unless interps.empty?
  case prompt_type
  when :error then "ERROR: " << prompt << "\n"
  when :prompt then prompt + "\n=>"
  else prompt << "\n"
  end
end

def display_message(prompt, prompt_type = nil, interps = {})
  print format_prompt(prompt, prompt_type, interps)
end

def prompt_input(prompt_for_user, interps = {})
  display_message(PROMPTS[prompt_for_user], :prompt, interps)
  gets.chomp
end

def welcome_message
  display_message(PROMPTS['welcome'])
end

# ADD to word validator: deny use of special characters. low priority
word_valid = lambda do |word = ''|
  true if word.to_i == 0 && word != '0' && word != ''
end

y_n_valid = lambda do |response = ''|
  response.downcase!
  true if response.include?('y') || response.include?('n')
end

num_valid = lambda do |response = 0|
  return true if response.to_i.to_s == response
  true if response.to_f.to_s == response
end

VALIDATORS = {
  word: word_valid,
  y_n: y_n_valid,
  num: num_valid
}

def validate_input(prompt, check_input, error_code)
  user_input = ''
  loop do
    user_input = prompt_input(prompt)
    break if check_input.call(user_input)
    display_message(ERRORS[error_code], :error, user_input: user_input)
  end
  user_input
end

def ask_for_info
  loan_data = {
    amount: validate_input('ask_amount', VALIDATORS[:num], 'amount_error'),
    length_years: validate_input('ask_length', VALIDATORS[:num], 'length_error'),
    apr: validate_input('ask_apr', VALIDATORS[:num], 'apr_error')
  }
  loan_data
end

def convert_data(loan_data)
  loan_data[:name] = loan_data[:name].capitalize
  loan_data[:amount] = loan_data[:amount].to_f
  loan_data[:length_years] = loan_data[:length_years].to_i
  loan_data[:apr] = loan_data[:apr].to_f
  loan_data
end

def calculate_loan(loan_data)
  principal = loan_data[:amount]
  monthly_rate = loan_data[:apr] / 12
  duration = loan_data[:length_years] * 12
  m_payment = principal * (monthly_rate / (1 - (1 + monthly_rate)**(-duration)))
  loan_data[:length_months] = duration
  loan_data[:monthly_payment] = m_payment
  loan_data
end

welcome_message
loan_data = {}
loan_data[:name] = validate_input('ask_name', VALIDATORS[:word], 'name_error')
loan_data.merge!(ask_for_info)
loan_data = convert_data(loan_data)
loan_data = calculate_loan(loan_data)

p loan_data