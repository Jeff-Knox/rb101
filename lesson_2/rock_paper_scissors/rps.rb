require 'yaml'

PROMPT = YAML.load_file('prompts.yml')
ERROR = YAML.load_file('errors.yml')
CHOICES = ['Rock', 'Paper', "Scissors"]

def assign_weapon_winners(choices)
  weapon_winners_chart = {}
  choices.each_with_index do |weapon, i|
    weapon_winners_chart[weapon] = choices[i - 1]
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
  end
end

def ask_input(prompt_message, error_message, input_valid)
  user_input = ''
  loop do
    display(:p, prompt_message)
    user_input = gets.chomp
    return user_input if input_valid.call(user_input)
    display(:e, error_message, { invalid_input: user_input })
  end
end

def normalize_user_choice(choice)
  WEAPON_WINNERS.each do |option, _|
    return option if choice.downcase.start_with?(option[0].downcase)
  end
end

valid_wep = lambda do |input = ''|
  return true if CHOICES.include?(input.capitalize)
end

valid_yn = lambda do |input = ''|
  input = input.downcase
  return true if input.start_with?('y') || input.start_with?('n')
  false
end

def assign_choices(valid_wep)
  choice = ask_input(PROMPT['choose_wep'], ERROR['invalid_wep'], valid_wep)
  chosen_weapons = {
    user: normalize_user_choice(choice),
    cpu: CHOICES.sample(1)[0]
  }
  chosen_weapons
end

def calculate_winner(choices)
  return 'tie' if choices[:user] == choices[:cpu]
  WEAPON_WINNERS.each do |winner, loser|
    return 'user_wins' if choices[:user] == winner && choices[:cpu] == loser
    return 'user_loses' if choices[:cpu] == winner && choices[:user] == loser
  end
end

def play_again?(valid_yn)
  play_again = ask_input(PROMPT['play_again'], ERROR['invalid_y_n'], valid_yn)
  puts play_again
  play_again.downcase!
  user_choice = true if play_again.start_with?('y')
  user_choice = false if play_again.start_with?('n')
  user_choice
end

def calculate_user_stats(winner, w_l_data)
  case winner
  when 'user_wins' then w_l_data[:win] += 1.0
  when 'user_loses' then w_l_data[:loss] += 1
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

display(:m, PROMPT['welcome'])
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
