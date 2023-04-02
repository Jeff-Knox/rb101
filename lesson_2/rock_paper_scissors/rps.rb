require 'yaml'

PROMPT = YAML.load_file('prompts.yml')
ERROR = YAML.load_file('errors.yml')
CHOICE_DOC = YAML.load_file('choice_doc.yml')
CHOICES = CHOICE_DOC['choices']
CHOICE_S = "[" << CHOICES.join("][") << "]"

def assign_weapon_winners(choices)
  weapon_winners_chart = {}
  choices.each_with_index do |weapon, i|
    loser_arr = []
    (choices.length / 2).times do |j|
      loser_arr << choices[i - ((2 * j) + 1)]
    end
    weapon_winners_chart[weapon] = loser_arr
  end
  weapon_winners_chart
end

WEAPON_WINNERS = assign_weapon_winners(CHOICES)

def display(message_type, message, interps = {})
  message = format(message, interps) unless interps.empty?
  case message_type
  when :p
    print "=> " + message + "\nUser: "
  when :m
    print "=> " + message + "\n"
  when :e
    print "ERROR: " + message + "\n"
  when :t
    print_table(message)
  end
end

def print_table(hash)
  # Determine the maximum length of the key and values in the hash
  key_length = hash.keys.map(&:length).max
  value_length = hash.values.flatten.map(&:length).max

  # Calculate the border length based on the maximum key and value length
  border_length = key_length + value_length + 7

  # Print the header row
  printf("| %#{key_length}s | %#{value_length}s |\n", "Option", "Beats")
  printf("|%s|\n", "-" * border_length)

  # Print each row of the table
  hash.each do |key, value|
    words = value.join(', ')
    printf("| %#{key_length}s | %-#{value_length}s |\n", key, words)
  end

  # Print the bottom border
  printf("|%s|\n", "-" * border_length)
end

def ask(prompt_message, error_message, input_valid, options = {})
  user_input = ''
  loop do
    display(:p, prompt_message, options)
    user_input = gets.chomp.downcase
    return user_input if input_valid.call(user_input)
    display(:e, error_message, { invalid_input: user_input })
  end
end

valid_wep = lambda do |input = ''|
  true if CHOICES.include?(input)
end

valid_yn = lambda do |input = ''|
  return true if input.start_with?('y') || input.start_with?('n')
  false
end

def welcome_message
  display(:m, PROMPT['welcome'])
  display(:m, PROMPT['display_rules1'], { option_count: CHOICES.length.to_s })
  display(:m, PROMPT['display_rules2'], { options: CHOICE_S })
  display(:m, PROMPT['display_rules3'])
  display(:t, WEAPON_WINNERS)
end

def assign_choices(valid_wep)
  c = ask(PROMPT['which_wep'], ERROR['wep'], valid_wep, { options: CHOICE_S })
  chosen_weapons = {
    user: c,
    cpu: CHOICES.sample(1)[0]
  }
  chosen_weapons
end

def calculate_winner(choices)
  return 'tie' if choices[:user] == choices[:cpu]
  WEAPON_WINNERS.each do |win, lose|
    return 'user_won' if choices[:user] == win && lose.include?(choices[:cpu])
    return 'user_lost' if choices[:cpu] == win && lose.include?(choices[:user])
  end
end

def play_again?(valid_yn)
  play_again = ask(PROMPT['play_again'], ERROR['y_n'], valid_yn)
  user_choice = true if play_again.start_with?('y')
  user_choice = false if play_again.start_with?('n')
  user_choice
end

def calculate_user_stats(winner, w_l_data)
  case winner
  when 'user_won' then w_l_data[:win] += 1.0
  when 'user_lost' then w_l_data[:loss] += 1
  else w_l_data[:tie] += 1
  end
  w_l_data[:total] = w_l_data[:win] + w_l_data[:loss] + w_l_data[:tie]
  winrate = (w_l_data[:win] / w_l_data[:total] * 100).round(2).to_s
  w_l_data[:wr] = winrate + "%"
  w_l_data
end

user_stats = {
  win: 0,
  loss: 0,
  tie: 0,
  total: 0,
  wr: 0
}

welcome_message
loop do
  weapon_choices = assign_choices(valid_wep)
  display(:m, PROMPT['choices'], weapon_choices)
  winner = calculate_winner(weapon_choices)
  display(:m, PROMPT[winner])
  user_stats = calculate_user_stats(winner, user_stats)
  display(:m, PROMPT['display_stats'], user_stats)
  break if !play_again?(valid_yn)
end
display(:m, PROMPT['goodbye'])
