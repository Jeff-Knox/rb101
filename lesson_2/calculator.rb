# Calculator2.0
# Changes:
# - Almost entirely refactored, goal of creating more modular, readable code.
# - Run through Rubocop, only gets 1 offense: calculate_result() does too much.
# -- I could refactor to two methods, one that gets the operator type, and the other calculates based on that input
# -- I don't feel that is particularly necessary as of right now, so we will leave it
# Order of methods is still pretty all over the place. Haven't learned proper ordering of methods, so I'll likely come back and work on that

OPERATORS = ['add', 'subtract', 'multiply', 'divide', 'modulo', 'exponent']

def convert_operators_to_s(operators)
  op_string = ''
  operators.each do |operator|
    op_string += "[#{operator}]"
  end
  op_string
end

def display_prompt(prompt, y_n = false)
  prompt << ' [y/n]' if y_n
  puts "=> " << prompt
end

def accessing_mem?(input)
  input =~ /mem/ ? true : false
end

def memory_valid?(memory_arr, mem_index)
  !memory_arr[mem_index].nil?
end

def num_valid?(input)
  input.to_i.to_s == input
end

def operator_valid?(input)
  options = OPERATORS
  options.each do |option|
    return true if input.downcase == option
  end
  false
end

def y_n?(input)
  return true if input.downcase == 'y' || input.downcase == 'n'
  false
end

def check_mem(user_input, memory_arr)
  return unless accessing_mem?(user_input)
  if memory_valid?(memory_arr, user_input.delete('mem').to_i)
    display_prompt("Value found: #{memory_arr[user_input.delete('mem').to_i]}")
    return true
  end
  display_prompt('value not found at memory index.')
  false
end

def get_user_input_type(user_input, memory_arr)
  return :mem if check_mem(user_input, memory_arr)
  return :num if num_valid?(user_input)
  return :op if operator_valid?(user_input)
  return :y_n if y_n?(user_input)
  nil
end

def mem_to_num(pass_mem_array, mem_index)
  pass_mem_array[mem_index]
end

def convert_input(user_input, input_type, memory_arr)
  case input_type
  when :num then user_input.to_i
  when :mem then memory_arr[user_input.delete('mem').to_i]
  when :op  then user_input.downcase
  when :y_n then user_input.downcase
  else display_prompt("ERROR: I DONT KNOW HOW I GOT HERE")
  end
end

def get_user_input(prompt_for_user, type_out, memory_arr = [])
  loop do
    display_prompt(prompt_for_user)
    user_input = gets.chomp
    user_input_type = get_user_input_type(user_input, memory_arr)
    new_input = convert_input(user_input, user_input_type, memory_arr)
    return new_input if type_out.include? user_input_type
    display_prompt("ERROR: user input does not match desired input. Try again.")
  end
end

def set_number(memory_array, ordinal)
  set_num_prompt = "Enter #{ordinal} number."
  set_num_prompt << " Type 'mem' followed by the memory index to access memory"
  set_num_prompt << " i.e. 'mem1'."
  get_user_input(set_num_prompt, [:mem, :num], memory_array)
end

def set_operator
  set_op_prompt = 'Enter the operation you would like to perform: '
  set_op_prompt << convert_operators_to_s(OPERATORS)
  get_user_input(set_op_prompt, [:op])
end

def set_inputs(memory_arr)
  inputs_hash = {
    num1: set_number(memory_arr, '1st'),
    operator: set_operator,
    num2: set_number(memory_arr, '2nd')
  }
  inputs_hash
end

def calculate_result(info = {})
  case info[:operator]
  when 'add'      then info[:num1] + info[:num2]
  when 'subtract' then info[:num1] - info[:num2]
  when 'multiply' then info[:num1] * info[:num2]
  when 'divide'   then info[:num1] / info[:num2]
  when 'modulo'   then info[:num1] % info[:num2]
  when 'exponent' then info[:num1]**info[:num2]
  else display_prompt('aahhhhhhhhhhhhhhh')
  end
end

def display_result(result, info = {})
  display_prompt('Calculating results...')
  results = "#{info[:num1]} #{info[:operator]} #{info[:num2]} = #{result}"
  display_prompt(results)
end

def end_session
  if get_yes_no("Are you finished Calculating? [y/n] ")
    display_prompt("GOODBYE")
    exit
  end
end

def get_yes_no(prompt)
  user_in = get_user_input(prompt, [:y_n])
  return true if user_in == 'y'
  return false if user_in == 'n'
end

def add_to_mem(memory_arr, value)
  if get_yes_no("Add #{value} to memory? [y/n] ")
    memory_arr.push(value.to_i)
    display_prompt("#{value} added to mem#{memory_arr.length - 1}")
  end
end

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
