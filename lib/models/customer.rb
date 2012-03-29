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
      @transactions ||= invoices.map { |i| i.transactions }
    end

    def favorite_merchant
      top_merchant_transaction = invoices.map do |i| 
        [i.merchant, i.transactions.count]
      end.sort_by { |v| v[1] }.last

      top_merchant_transaction.first
    end

  end
end