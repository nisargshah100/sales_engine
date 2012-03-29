$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__))) unless
  $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))
  
require 'csv'
require 'bigdecimal'

require 'db/persistence'
require 'models/model'
require 'models/merchant'
require 'models/customer'
require 'models/item'
require 'models/invoice'
require 'models/invoice_item'
require 'models/transaction'

module SalesEngine

  FILENAME_TO_CLASS = {
    "merchants.csv" => SalesEngine::Merchant,
    "customers.csv" => SalesEngine::Customer,
    "items.csv" => SalesEngine::Item,
    "invoices.csv" => SalesEngine::Invoice,
    "invoice_items.csv" => SalesEngine::InvoiceItem,
    "transactions.csv" => SalesEngine::Transaction
  }

  def self.startup
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
      options = { :headers => true, :header_converters => :symbol }
      CSV.foreach(filename, options) do |row|
        rows << Hash[row]
      end

      rows
    end
  end

end
