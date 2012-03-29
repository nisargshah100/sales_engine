require 'csv'
require 'bigdecimal'

require './lib/db/persistence'
require './lib/models/model'
require './lib/models/merchant'
require './lib/models/customer'
require './lib/models/item'
require './lib/models/invoice'
require './lib/models/invoice_item'
require './lib/models/transaction'

module SalesEngine

  FILENAME_TO_CLASS = {
    "merchants.csv" => SalesEngine::Merchant,
    "customers.csv" => SalesEngine::Customer,
    "items.csv" => SalesEngine::Item,
    "invoices.csv" => SalesEngine::Invoice,
    "invoice_items.csv" => SalesEngine::InvoiceItem,
    "transactions.csv" => SalesEngine::Transaction
  }

  def self.start
    Dir.glob('./data/*.csv').each do |f|
      filename = File.basename(f)
      klass = FILENAME_TO_CLASS[filename]

      if klass
        contents = Parser.fetch_data(f)
        contents.map { |attributes| klass.new(attributes) }
      end
    end
  end

  class Parser
    def self.fetch_data(filename)
      rows = []
      CSV.foreach(filename, { :headers => true, :header_converters => :symbol }) do |row|
        rows << Hash[row]
      end

      rows
    end
  end

end