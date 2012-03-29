module SalesEngine
  class Transaction < Model
    
    def initialize(attributes)
      super(attributes)
    end

    def successful_transaction?
      @attributes[:result] == "success"
    end

    def invoice_id
      @invoice_id ||= @attributes[:invoice_id].to_i
    end
  
    def credit_card_number
      @credit_card_number ||= @attributes[:credit_card_number]
    end

    def result
      @result ||= @attributes[:result]
    end

    def invoice
      @invoice ||= Invoice.find_by_id(invoice_id)
    end

  end
end