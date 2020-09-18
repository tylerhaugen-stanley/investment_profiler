module Helpers
  def ensure_period(period:)
    raise StandardError "Unsupported period type #{period}" unless [:ttm, :quarterly, :annually].include?(period)
  end

  def ensure_date(date:)
    raise StandardError "Unsupported date #{date}" unless date.class == Date
  end

  def ensure_year(year:)
    raise StandardError "Unsupported date #{date}" unless year.to_s =~ /\d{4}/
  end

  # TODO move this to the api layer. It is the one that should know it needs to sleep.
  def api_wait(seconds:)
    puts "Waiting #{seconds} seconds due to API rate limit"
    (0...seconds).each do |second|
      print '.'
      sleep(1)
    end
    puts ''
  end
end