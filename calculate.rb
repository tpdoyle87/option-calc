puts "What is your starting cash value?"
starting_cash = gets.chomp.to_i
puts "How many weeks do you want to run the calculation?"
weeks = gets.chomp.to_i

current_cash = starting_cash
win_rate = 0.92
base_profit_per_contract = 11
loss_per_contract = base_profit_per_contract * 2
commission_per_contract = 0.65 * 2 # $0.65 commission per contract for two contracts
cumulative_withdrawals = 0
cumulative_loss = 0
trades_per_week = 3
contract_cap = 1000
max_cash = 2_000_000

weeks.times do |week|
  weekly_gain = 0
  weekly_loss = 0

  # Adjust trading frequency based on week number and current cash
  trades_per_week = 4 if current_cash >= 27000 && trades_per_week == 3
  trades_per_week = 5 if week >= 124

  puts "In week #{week + 1}, trading #{trades_per_week} times a week." if week == 0 || week == 124 || (current_cash >= 27000 && trades_per_week == 4 && week < 124)

  trades_per_week.times do |day|
    profit_per_contract = base_profit_per_contract

    # Calculate the number of contracts, adjust if exceeds 300
    number_of_contracts = ((current_cash * 0.7) / 200).floor
    if number_of_contracts > 300
      number_of_contracts = ((current_cash * 0.7) / 1000).floor
      profit_per_contract = 21
      commission_per_contract = 1.2 * 2 # $1.20 commission per contract for two contracts
    end

    # Cap the number of contracts at 500
    number_of_contracts = [number_of_contracts, contract_cap].min

    # puts "Number of contracts for the day: #{number_of_contracts}"

    winning_contracts = (number_of_contracts * win_rate).floor
    losing_contracts = number_of_contracts - winning_contracts

    daily_gain = winning_contracts * profit_per_contract
    daily_loss = losing_contracts * loss_per_contract
    total_commission = number_of_contracts * commission_per_contract

    net_daily_gain = daily_gain - daily_loss - total_commission
    weekly_loss += daily_loss
    # puts "Net daily gain after commissions: #{net_daily_gain}"

    weekly_gain += net_daily_gain
  end

  weekly_withdrawal = (weekly_gain * 0.3).floor
  current_cash += (weekly_gain * 0.7).floor
  cumulative_withdrawals += weekly_withdrawal
  cumulative_loss += weekly_loss

  # Withdraw excess amount if current cash exceeds $1,000,000
  if current_cash > max_cash
    excess_amount = current_cash - max_cash
    weekly_withdrawal += excess_amount
    cumulative_withdrawals += excess_amount
    current_cash = max_cash
    puts "Excess amount of #{excess_amount} withdrawn."
  end

  puts "Week #{week + 1}: Current cash is #{current_cash}. Withdrawn this week: #{weekly_withdrawal}. Total withdrawn: #{cumulative_withdrawals}. Loss this week: #{weekly_loss}. Total loss: #{cumulative_loss}."
end

puts "Final cash after #{weeks} weeks is #{current_cash}. Total amount withdrawn: #{cumulative_withdrawals}. Total loss: #{cumulative_loss}. This assumes a #{(win_rate*100).floor}% win rate and a 200% loss on losing contracts."
