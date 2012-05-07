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
      total_invoices_by_merchant.sort_by { |k, v| v }.first.key
    end
    
    def total_invoices_by_merchant
      result = {}
      invoices.each do |inv|
        result[inv.merchant] += 1
      end
      result
    end
  end
end
