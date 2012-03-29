module SalesEngine
  class Customer < Model

    def initialize(attributes)
      super(attributes)
    end

    def last_name
      @attributes[:last_name]
    end

    def first_name
      @attributes[:first_name]
    end

    def invoices
      @invoices ||= Invoice.find_all_by_customer_id(id)
    end

    def transactions
      @transactions ||= invoices.map { |inv| inv.transactions }
    end

    def favorite_merchant
      top_merchant_transaction = invoices.map do |inv|
        [inv.merchant, inv.transactions.count]
      end.sort_by { |value| value[1] }.last

      top_merchant_transaction.first
    end

  end
end
