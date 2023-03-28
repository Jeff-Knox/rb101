require 'yaml'
require 'terminal-table'

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
  loan_data[:monthly_payment] = m_payment.round(2)
  loan_data[:interest] = ((m_payment * duration) - principal).round(2)
  loan_data[:total] = (m_payment * duration).round(2)
  loan_data
end

def format_for_table(loan_data)
  data = {
    years: ['Years', loan_data[:length_years]],
    payments: ['Payments', loan_data[:length_months]],
    apr: ['(APR)', "#{(loan_data[:apr] * 100)}%"],
    monthly: ['Monthly Payment', loan_data[:monthly_payment]],
    principal: ['Principal', loan_data[:amount]],
    interest: ['Interest', loan_data[:interest]],
    total: ['Total Amount', loan_data[:total]]
  }
  data
end

def create_rows(formatted_data)
  rows = []
  formatted_data.each do |k, v|
    rows << v
  end
  rows
end


welcome_message
loan_data = {}
loan_data[:name] = validate_input('ask_name', VALIDATORS[:word], 'name_error')
loan_data.merge!(ask_for_info)
loan_data = convert_data(loan_data)
loan_data = calculate_loan(loan_data)
table_data = format_for_table(loan_data)

table = Terminal::Table.new :rows => create_rows(table_data), :style => {:all_separators => true}
puts table