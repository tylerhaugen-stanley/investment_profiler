module Newest
  extend ActiveSupport::Concern

  included do
    scope :newest, -> (table = self.table_name){
      order("#{table}.created_at DESC").last
    }
  end
end
