require 'active_record'
require 'active_support/concern'

module UniversalScopes
  extend ActiveSupport::Concern

  module ClassMethods

    def most_recent(by: :created_at)
      order(by => :desc).first
    end

  end
end
