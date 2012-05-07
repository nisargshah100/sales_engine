module SalesEngine
  class Item < Model

    def initialize(attributes)
      super(attributes)
    end

    def merchant_id
      @merchant_id ||= @attributes[:merchant_id].to_i
    end

    def name
      @name ||= @attributes[:name]
    end

    def unit_price
      if @unit_price.nil?
        unit_price = @attributes[:unit_price].to_s
        new_unit_price = "#{unit_price[0..-3]}.#{unit_price[-2..-1]}"
        @unit_price ||= BigDecimal.new new_unit_price
      end
      @unit_price
    end

    def invoice_items
      @invoice_items ||= InvoiceItem.find_all_by_item_id(id)
    end

    def merchant
      @merchant ||= Merchant.find_by_id(merchant_id)
    end

    def revenue
      @revenue ||= self.invoice_items.inject(0) do |sum, it|
         sum += it.unit_price * it.quantity
       end
    end

    def total_items_sold
      sum = 0
      @items_sold ||= invoice_items.each do |it|
        if it.invoice.successful_invoice?
          sum += it.quantity
        end
      end
      @total_items_sold ||= sum
    end

    def best_day
      if @best_day.nil?
        days = Hash.new(0)
        invoice_items.each do |it|
          days[it.invoice.created_at] += it.quantity
        end
        @best_day ||= days.sort_by { |date,quantity| -quantity }.first.first
      end
      @best_day
    end

    class << self
      def with_greatest_revenue(n)
        most_something(:revenue, n)
      end

      def with_greatest_number_sold(n)
        most_something(:total_items_sold, n)
      end

      def most_something(thing, n)
        items = Persistence.instance.data[self].compact
        sorted_items = items.sort_by { |item| -item.send(thing) }
        sorted_items[0...n]
      end
    end
  end
end
