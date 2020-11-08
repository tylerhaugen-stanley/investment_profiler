require 'active_record'
require 'active_support/concern'

module UniversalScopes
  extend ActiveSupport::Concern

  module ClassMethods

    def newest(by: :created_at)
      order(by => :desc).first
    end
    alias_method :most_recent, :newest

  end
end
