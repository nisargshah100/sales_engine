module SalesEngine
  class Invoice < Model

    def initialize(attributes)
      super(attributes)
    end

    def merchant_id
      @attributes[:merchant_id].to_i
    end

    def customer_id
      @attributes[:customer_id].to_i
    end

    def customer
      @customer = Customer.find_by_id(customer_id)
    end

    def merchant
      @merchant = Merchant.find_by_id(merchant_id)
    end

    def status
      @attributes[:status]
    end

    def revenue
      @revenue ||= InvoiceItem.find_all_by_invoice_id(id).collect do |it|
        it.revenue
      end.inject(:+)
    end

    def revenue
      if @revenue.nil?
        @revenue = 0

        invoice_items.each do |it|
          @revenue += it.revenue
        end
      end
      @revenue
    end

    def successful_invoice?
      transactions.any? { |t| t.successful_transaction? }
    end

    def transactions
      @transactions ||= Transaction.find_all_by_invoice_id(id)
    end

    def invoice_items
      @invoice_items ||= InvoiceItem.find_all_by_invoice_id(id)
    end

    def items
      @items ||= invoice_items.map { |i| i.item }
    end

    def charge(attributes)
      attributes[:invoice_id] = id
      attributes[:id] = Transaction.unique_id
      date = DateTime.now.to_s

      @transactions = nil
      Transaction.new(attributes)
    end

    class << self
      def create(attributes)
        attributes[:customer_id] = attributes[:customer].id
        attributes[:merchant_id] = attributes[:merchant].id
        attributes[:id] = Invoice.unique_id
        date = DateTime.now.to_s

        invoice = Invoice.new(attributes)
        attributes[:items].each do |item|
          InvoiceItem.new(
            :id => InvoiceItem.unique_id,
            :unit_price => item.unit_price,
            :invoice_id => invoice.id,
            :item_id => item.id,
            :quantity => 1,
            :created_at => date,
            :updated_at => date,
          )
        end

        invoice
      end
    end

  end
end
