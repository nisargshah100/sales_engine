require 'date'

module SalesEngine
  class Model

    def initialize(attributes)
      @attributes = attributes
      Model.persistance.persist(self)
    end

    def self.included includer
        includer.extend ClassMethods
    end

    def id
      @id ||= @attributes[:id].to_i
    end

    def created_at
      if @attributes[:created_at]
        @created_at ||= Date.parse(@attributes[:created_at])
      else
        @created_at = Date.today
      end
    end

    def updated_at
      if @attributes[:updated_at]
        @created_at ||= Date.parse(@attributes[:updated_at])
      else
        @created_at = Date.today
      end
    end

    class << self
      def persistance
        SalesEngine::Persistence.instance
      end

      def random
        fetch_all.compact.sample
      end

      def fetch_all
        persistance.data[self]
      end

      def method_missing(sym, *args, &block)
        if match = sym.to_s.match(/^find_by_(.+)$/)
          find_by(match[1], args)
        elsif match = sym.to_s.match(/^find_all_by_(.+)$/)
          find_all_by(match[1], args)
        end
      end

      def find_by_id(id)
        persistance.data[self][id]
      end

      def find_by(sym, args)
        persistance.data[self].find { |x| x.send(sym) == args[0] if x }
      end

      def find_all_by(sym, args)
        persistance.data[self].find_all do |x|
          x.send(sym.to_sym) == args[0] if x
        end
      end

      def unique_id
        persistance.data[self].last.id + 1
      end
    end

  end
end
