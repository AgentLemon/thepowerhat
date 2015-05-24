module Concerns

  module PresentsDebts

    extend ActiveSupport::Concern

    included do

      def total_debt
        @total_debt ||= @user.paids.sum(:amount) - @user.debts.sum(:amount)
      end

      def debts
        @debts ||= get_debts_or_paids(:debts, :whom, DebtPresenter)
      end

      def paids
        @paids ||= get_debts_or_paids(:paids, :who, PaidPresenter)
      end

      private

      def get_debts_or_paids(method, include, presenter)
        @user.send(method).where{ amount != 0 }.includes(include).map{ |i| presenter.new(i) }
      end

    end

  end

end
