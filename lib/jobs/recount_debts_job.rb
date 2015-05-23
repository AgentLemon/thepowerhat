# Used algorithm by
# N.N.Kalitkin
# Optimal debts netting
# Mathematical modelling, 1995, book 7, no 1, pages 11-21
# http://www.mathnet.ru/php/archive.phtml?wshow=paper&jrnid=mm&paperid=1655&option_lang=rus

class RecountDebtsJob

  def initialize(users)
    @users = {}
    users.each.with_index { |user, i| @users[user.id] = i }
    @size = users.size
  end

  def self.perform(users)
    RecountDebtsJob.new(users).recount!
  end

  def recount!
    final = nil

    ActiveRecord::Base.transaction do
      matrix = get_debt_matrix
      betas = get_betas_array(matrix)
      lambdas = get_lambdas_array(betas)
      final = get_final_matrix(lambdas)

      update_debts!(final)
    end

    final
  end

  def update_debts!(final)
    (0..(@size - 1)).each do |n|
      (0..(n - 1)).each do |m|
        update_debt!(n, m, final[n][m])
      end
    end
  end

  def update_debt!(who_index, whom_index, amount)
    debt = Debt.find_debt(@users.keys[who_index], @users.keys[whom_index])
    reversed = debt.reversed

    if amount == 0
      debt.destroy!
      reversed.destroy!
    elsif amount > 0
      debt.update_attributes!(amount: amount)
      reversed.destroy!
    elsif amount < 0
      reversed.update_attributes!(amount: -amount)
      debt.destroy!
    end
  end

  def get_debt_matrix
    matrix = Array.new(@size)
    @size.times{ |i| matrix[i - 1] = Array.new(@size, 0) }
    ids = @users.keys
    debts = Debt.lock.where("who_id in (?) and whom_id in (?)", ids, ids)
    debts.each do |d|
      matrix[@users[d.who_id ]][@users[d.whom_id]] += d.amount
      matrix[@users[d.whom_id]][@users[d.who_id ]] -= d.amount
    end
    matrix
  end

  def get_betas_array(matrix)
    betas = Array.new(@size, 0)
    (0..(@size - 1)).each do |n|
      beta = 0
      (0..(n - 1)).each { |m| beta += matrix[n][m] }
      ((n + 1)..(@size - 1)).each { |m| beta -= matrix[m][n] }
      betas[n] = beta
    end
    betas
  end

  def get_lambdas_array(betas)
    lambdas = Array.new(@size, 0)

    lambdas[-1] = 0
    (1..(@size - 2)).each { |n| lambdas[n] = (betas.last - betas[n]) / @size }

    lambdas[0] = 2 * betas.last
    (1..(@size - 2)).each{ |m| lambdas[0] += betas[m] }
    lambdas[0] /= @size

    lambdas
  end

  def get_final_matrix(lambdas)
    final_matrix = Array.new(@size)
    @size.times{ |i| final_matrix[i - 1] = Array.new(@size, 0) }
    (0..(@size - 1)).each do |n|
      (0..(n - 1)).each do |m|
        final_matrix[n][m] = lambdas[m] - lambdas[n]
      end
    end
    final_matrix
  end

end
