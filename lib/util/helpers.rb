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
end
