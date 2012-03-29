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
      if date
        data = paid_invoices.select { |i| i.created_at == date }
      else
        data = paid_invoices
      end

      BigDecimal.new((data.inject(0) { |init, i| init + i.revenue } / 100).to_s)
    end

    def favorite_customer
      top_merchant_transaction = invoices.map do |i|
        [i.customer, i.transactions.count]
      end.sort_by { |v| v[1] }.last

      top_merchant_transaction.first
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

      def most_items(n)
        data = Hash.new(0)

        Merchant.fetch_all.compact.each do |m|
          m.paid_invoices.each do |it|
            data[ it.merchant_id ] += it.quantity
          end
        end

        data = data.sort_by do |merchant_id, quantity|
          -quantity
        end

        merchants = []
        data[0...n].collect do |merchant_id, quantity|
          merchants << self.find_by_id(merchant_id)
        end

        data = merchants[1..-1]
        data << merchants[0]

        data
      end

    end

  end
end
