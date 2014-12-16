require 'date'

module JSONVAT
  class Period

    def initialize(country, attributes)
      @country, @attributes = country, attributes
    end

    def effective_from
      @effective_from ||= Date.parse(@attributes['effective_from'])
    end

    def rates
      @attributes['rates'] || {}
    end

  end
end
