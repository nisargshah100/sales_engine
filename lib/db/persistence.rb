require 'singleton'

module SalesEngine
  class Persistence
    include Singleton

    def data
      @data || {}
    end

    def persist(obj)
      @data = {} if @data.nil?
      @data[obj.class] = [] if @data[obj.class].nil?

      @data[obj.class][obj.id] = obj
    end
  end
end