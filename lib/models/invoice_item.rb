module SalesEngine
  class InvoiceItem < Model

    def initialize(attributes)
      super(attributes)
    end

    def unit_price
      @unit_price ||= @attributes[:unit_price].to_f
    end

    def quantity
      @quantity ||= @attributes[:quantity].to_i
    end

    def invoice_id
      @invoice_id ||= @attributes[:invoice_id].to_i
    end

    def item_id
      @item_id ||= @attributes[:item_id].to_i
    end

    def item
      @item ||= Item.find_by_id(item_id)
    end

    def invoice
      @invoice ||= Invoice.find_by_id(invoice_id)
    end

    def revenue
      unit_price * quantity
    end

    def transactions
      @transactions = Transaction.find_all_by_invoice_id(self.id)
    end

  end
end
