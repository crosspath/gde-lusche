class House < ActiveRecord::Base
  belongs_to :address
  
  validates_presence_of :name
end
