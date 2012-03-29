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

    def revenue(date=nil)
      invoices.inject(0) { |init, i| init + i.revenue }
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

      def most_revenue(n)
        merchants = Persistence.instance.data[self].compact
        sorted_merchants = merchants.sort_by { |merchant| -merchant.revenue }
        sorted_merchants[0...n]
      end

    end

  end
end
