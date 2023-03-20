
# Gets number, checks if user is trying to access memory. If they are, returns the number stored at index specified
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

# Gets the operation type the user wishes to perform, checks it against a list of options allowed.
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

# Calculates and prints result based on the info passed in through a hash.
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

# Generic [y/n] prompt. Can modify the prompt message by passing in a string.
def get_y_n?(prompt = "Default y/n prompt")
  loop do
    puts prompt << " [y/n]"
    user_input = gets.chomp
    if user_input == 'y'
      return true
    elsif user_input == 'n'
      return false
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
    if get_y_n?("Do you want to store in mem?")
      mem.push(result) 
      puts "#{result} stored at mem#{mem.length - 1}"
    end 
    unless get_y_n?("Do you want to continue?")
      puts "Thanks for using my calculator!"
      break
    end
  end
end

main