module Hetzner
  class API
    module Traffic
      # returns the traffic information for an IP and/or subnet according to the selected time frame.
      def traffic?(options = {})

        ips     = options[:ips]
        subnets = options[:subnets]
        from    = options[:from]
        to      = options[:to]
        type    = options[:type].to_sym

        from = DateTime.parse(from) unless from.is_a? Date
        to   = DateTime.parse(to)   unless to.is_a?   Date

        case type
        when :year
          format = "%Y-%m"       # 2010-01
          from_date = from.strftime format
          to_date   = to.strftime   format
        when :month
          format = "%Y-%m-%d"    # 2010-12-30
          from_date = from.strftime format
          to_date   = to.strftime   format
        when :day
          format = "%Y-%m-%dT%H" # 2010-01-01T15
          from_date = from.strftime format
          to_date   = to.strftime   format
        else
          raise ArgumentError, 'Invalid time frame type. Must be one of:  :year, :month, :day'
        end
        
        validate_dates_and_type from, to, type
        
        perform_post "/traffic", :query => { 
          :ip     => ips,
          :subnet => subnets,
          :from   => from_date,
          :to     => to_date,
          :type   => type
        }
      end

      private

      def validate_dates_and_type(from, to, type)
        today = DateTime.now

        case type
        when :month
          #if (same_year_and_month?(today, from) || same_year_and_month?(today, to))
          #  raise ArgumentError, 'Invalid timeframe: Time frame :month for this date is available AFTER CURRENT MONTH ONLY! => try :day instead'
          #end

        when :day
          unless same_day?(from, to)
            raise ArgumentError, 'Invalid date for timeframe. for type == :day queries both dates have to be on the same *day*'
          end
        end
      end

      def same_year_and_month?(a,b)
        a.strftime("%Y-%m") == b.strftime("%Y-%m")
      end

      def same_day?(a,b)
        a.strftime("%Y-%m-%d") == b.strftime("%Y-%m-%d")
      end
    end
  end
end