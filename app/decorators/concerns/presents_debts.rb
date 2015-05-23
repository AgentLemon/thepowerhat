module Concerns

  module PresentsDebts

    extend ActiveSupport::Concern

    included do

      def total_debt
        @total_debt ||= @user.paids.sum(:amount) - @user.debts.sum(:amount)
      end

      def debts
        @debts ||= @user.debts.where{ amount != 0 }.includes(:whom).map{ |i| DebtPresenter.new(i) }
      end

      def paids
        @paids ||= @user.paids.where{ amount != 0 }.includes(:who).map{ |i| PaidPresenter.new(i) }
      end

    end

  end

end
