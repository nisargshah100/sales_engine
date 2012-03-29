module SalesEngine
  class Merchant < Model
    
    def initialize(attributes)
      super(attributes)
    end

    def name
      @name ||= @attributes[:name]
    end

    def items
      @items ||= Item.find_all_by_merchant_id(id)
    end
  
    def invoices
      @invoices ||= Invoice.find_all_by_merchant_id(id)
    end

    def paid_invoices
      invoices.select { |i| i if i.successful_invoice? }
    end

    def customers_with_pending_invoices
      (invoices - paid_invoices).collect { |i| i.customer }
    end

    class << self
      
      def revenue(date)
        invoices = Invoice.find_all_by_updated_at(date)
        invoices_sum = invoices.collect do |i| 
          if i.successful_invoice?
            i.revenue
          else
            0
          end
        end.inject(:+)

        BigDecimal.new((invoices_sum/100).to_s)
      end

    end

  end
end