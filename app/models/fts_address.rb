class FtsAddress < ActiveRecord::Base
  belongs_to :address, primary_key :rowid
end
