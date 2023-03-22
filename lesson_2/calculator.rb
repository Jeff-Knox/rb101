# Calculator2.1
# Changes:
# - Mostly just commenting code
# - A couple methods added to create more readability (hopefully)
# - A couple methods refactored
# - Fixed displaying multiple unnecessary error messages
# Calculator2.0
# Changes:
# - Almost entirely refactored, goal of creating more modular, readable code.
# - Run through Rubocop, only gets 1 offense: calculate_result() does too much.
# -- I could refactor to two methods, one that gets the operator type, and the other calculates based on that input
# -- I don't feel that is particularly necessary as of right now, so we will leave it
# Order of methods is still pretty all over the place. Haven't learned proper ordering of methods, so I'll likely come back and work on that

OPERATORS = ['add', 'subtract', 'multiply', 'divide', 'modulo', 'exponent']

# Converts OPERATORS to a string that allows easier prompting
def convert_operators_to_s(operators)
  op_string = ''
  operators.each do |operator|
    op_string += "[#{operator}]"
  end
  op_string
end

# Checks user input for 'mem'
def accessing_mem?(input)
  input =~ /mem/ ? true : false
end

# Checks if the user input a valid memory index
def memory_valid?(memory_arr, mem_index)
  !memory_arr[mem_index].nil?
end

# If the user uses proper input to access memory
# And is accessing a valid memory slot
# Returns true
def is_in_mem?(user_input, memory_arr)
  return unless accessing_mem?(user_input)
  mem_index = user_input.delete('mem').to_i
  if memory_valid?(memory_arr, mem_index)
    display_prompt("Value found: #{memory_arr[mem_index]}")
    return true
  end
end

# Checks if input is a float or integer
def num_valid?(input)
  return true if input.to_f.to_s == input
  return true if input.to_i.to_s == input
end

# Checks if given operation matches any of the OPERATORS
def operator_valid?(input)
  options = OPERATORS
  options.each do |option|
    return true if input.downcase == option
  end
  false
end

# Generic yes/no checker
def y_n?(input)
  input.downcase == 'y' || input.downcase == 'n'
end

# Checks if the user's input type matches with the expected type
# If the check fails, prompts with error
def type_match?(user_input_type, expected_type)
  return true if expected_type.include? user_input_type
  display_error("user input invalid or memory not found. Try again.")
end

# Generic prompter for a yes/no question
def get_yes_no(prompt)
  user_in = get_user_input(prompt, [:y_n])
  return true if user_in == 'y'
  return false if user_in == 'n'
end

# Prepends prompts with "=> " for clarity
def display_prompt(prompt, error = false)
  if error
    prompt = "=> ERROR: " << prompt
    puts prompt
    return
  end
  prompt = "=> " << prompt
  puts "=> " << prompt
end

# Allows for distinction in code between prompting with an error
# and prompting with other text
def display_error(prompt)
  display_prompt(prompt, true)
end

# Sets the user input type based on their input
# returns nil if it doesn't match any of the checks
def set_user_input_type(user_input, memory_arr)
  return :mem if is_in_mem?(user_input, memory_arr)
  return :num if num_valid?(user_input)
  return :op if operator_valid?(user_input)
  return :y_n if y_n?(user_input)
end

# Returns the value "in memory" at the specified index
def mem_to_num(pass_mem_array, mem_index)
  pass_mem_array[mem_index]
end

# Returns the correctly converted user input from string
# To whatever it needs to be depending on the input type
def convert_input(user_input, input_type, memory_arr)
  case input_type
  when :num then user_input.to_f
  when :mem then memory_arr[user_input.delete('mem').to_i]
  when :op  then user_input.downcase
  when :y_n then user_input.downcase
  end
end

# Gets the user's input and converts it to the appropiate value
# As long as it matches the expected types
# Method will loop until the user's input matches the expected types
def get_user_input(prompt_for_user, expected_type, memory_arr = [])
  loop do
    display_prompt(prompt_for_user)
    user_input = gets.chomp
    user_input_type = set_user_input_type(user_input, memory_arr)
    new_input = convert_input(user_input, user_input_type, memory_arr)
    return new_input if type_match?(user_input_type, expected_type)
  end
end

# Prompts the user for a number, either 1 or 2
# Returns the value gotten from the user
def prompt_for_number(memory_array, ordinal)
  set_num_prompt = "Enter #{ordinal} number."
  set_num_prompt << " Type 'mem' followed by the memory index to access memory"
  set_num_prompt << " i.e. 'mem1'."
  get_user_input(set_num_prompt, [:mem, :num], memory_array)
end

# Prompts the user for an operator type
# Returns the value gotten from the user
def prompt_for_operator
  set_op_prompt = 'Enter the operation you would like to perform: '
  set_op_prompt << convert_operators_to_s(OPERATORS)
  get_user_input(set_op_prompt, [:op])
end

# Sets a hash of the user's inputs and returns it
def set_inputs(memory_arr)
  inputs_hash = {
    num1: prompt_for_number(memory_arr, '1st'),
    operator: prompt_for_operator,
    num2: prompt_for_number(memory_arr, '2nd')
  }
  inputs_hash
end

# Case statement that calculates the result of the passed hash of info
# Returns the result
def calculate_result(info = {})
  case info[:operator]
  when 'add'      then info[:num1] + info[:num2]
  when 'subtract' then info[:num1] - info[:num2]
  when 'multiply' then info[:num1] * info[:num2]
  when 'divide'   then info[:num1] / info[:num2]
  when 'modulo'   then info[:num1] % info[:num2]
  when 'exponent' then info[:num1]**info[:num2]
  end
end

# Displays the passed in result
def display_result(result, info = {})
  display_prompt('Calculating results...')
  results = "#{info[:num1]} #{info[:operator]} #{info[:num2]} = #{result}"
  display_prompt(results)
end

# Prompts user if they want to end the session
# Terminates program if yes
def end_session
  if get_yes_no("Are you finished Calculating? [y/n]: ")
    display_prompt("GOODBYE")
    exit
  end
end

# Prompts the user if they want to add
# the passed in result to memory
# Mutates the passed in array with the appended result if yes
def add_to_mem(memory_arr, value)
  if get_yes_no("Add #{value} to memory? [y/n]: ")
    memory_arr.push(value.to_f)
    display_prompt("#{value} added to mem#{memory_arr.length - 1}")
  end
end

# Main loop idk if this is conventionally how it might be done
# But it gets the job done
def main
  mem = []
  loop do
    inputs_hash = set_inputs(mem)
    result = calculate_result(inputs_hash)
    display_result(result, inputs_hash)
    add_to_mem(mem, result)
    end_session
  end
end

main
