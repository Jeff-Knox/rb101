# Get user input in the form of num1, num2, operation type, return a hash with values. Check if user wanted to input a number stored in memory
# Calculate based on the given hash
# Ask if user wants to store the value to memory, and if they want to continue
# If store to memory, output a prompt that lets the user know what memory index it was stored to ex. "mem0", "mem1"

def get_number(pass_mem = [])
  num = ''
  loop do
    puts "Enter number. If value is stored in memory, type 'mem' followed by the index it was stored at. i.e. 'mem1'."
    num = gets.chomp
    if num =~ /mem/
        num_index = num.delete('mem').to_i
        puts "Found number: #{pass_mem[num_index]}"
        num = pass_mem[num_index]
        if num == nil
          puts "Number not found in memory slot #{num_index}. Try again!" 
          next
        end
      break
    elsif num.to_i.to_s == num
      num = num.to_i
      break
    end
    puts "Number invalid. Try again."
  end
  num
end

def get_operation
  operation_to_perform = ''
  loop do
    puts "Enter the operation you would like to perform [add][subtract][multiply][divide][modulo][exponent]"
    operation_to_perform = gets.chomp
    option_valid = false
    options = ['add', 'subtract', 'multiply', 'divide', 'modulo', 'exponent']
    options.each do |option|
      if operation_to_perform == option
        option_valid = true
      end
      break if option_valid
    end
    if option_valid
      puts "operation valid"
      break
    end
    puts "Operator invalid. Try again."
  end
  operation_to_perform 
end


def calculate_result(info = {})
  first_num = info[:num1]
  second_num = info[:num2]
  operation_to_perform = info[:operation]

  case operation_to_perform
  when "add"
    puts "Calculating result..."
    result = first_num + second_num
    puts "#{first_num} + #{second_num} = #{result}"
    result
  when "subtract"
    result = first_num - second_num
    puts "Calculating result..."
    puts "#{first_num} - #{second_num} = #{result}"
    result
  when "multiply"
    result = first_num * second_num
    puts "Calculating result..."
    puts "#{first_num} * #{second_num} = #{result}"
    result
  when "divide"
    result = first_num / second_num
    puts "Calculating result..."
    puts "#{first_num} / #{second_num} = #{result}"
    result
  when "modulo"
    result = first_num % second_num
    puts "Calculating result..."
    puts "#{first_num} % #{second_num} = #{result}"
    result
  when "exponent"
    result = first_num**second_num
    puts "Calculating result..."
    puts "#{first_num} ^ #{second_num} = #{result}"
    result
  else
    puts "What the heck did you just put?!?"
  end
end

def store_in_mem?
  loop do
    puts "Do you want to store the result to memory? [y/n]"
    user_input = gets.chomp
    if user_input == 'y'
      return true
      break
    elsif user_input == 'n'
      return false
      break
    else
      puts "Invalid input. Try again."
      next
    end
  end
end

def continue?
  loop do
    puts "Do you want to continue using the calculator? [y/n]"
    user_input = gets.chomp
    if user_input == 'y'
      return true
      break
    elsif user_input == 'n'
      return false
      break
    else
      puts "Invalid input. Try again."
      next
    end
  end
end


def main
  info_hash = {}
  mem = []
  loop do
    info_hash[:num1] = get_number(mem)
    info_hash[:operation] = get_operation
    info_hash[:num2] = get_number
    result = calculate_result(info_hash)
    if store_in_mem?
      mem.push(result) 
      puts "#{result} stored at mem#{mem.length - 1}"
    end 
    unless continue?
      puts "Thanks for using my calculator!"
      break
    end
  end
end

main