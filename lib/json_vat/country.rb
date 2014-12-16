require 'json_vat/period'

module JSONVAT
  class Country

    def initialize(attributes)
      @attributes = attributes
    end

    def name
      @attributes['name']
    end

    def country_code
      @attributes['country_code']
    end

    def code
      @attributes['code']
    end

    def periods
      @periods ||= @attributes['periods'].map { |p| Period.new(self, p) }
    end

    def period_on(date)
      periods.select { |p| p.effective_from <= date }.sort_by(&:effective_from).last
    end

    def rate_on(date, type = :standard)
      if period = period_on(date)
        period.rates[type.to_s]
      else
        nil
      end
    end

    def rate(type = :standard)
      rate_on(Date.today, type)
    end

  end
end
