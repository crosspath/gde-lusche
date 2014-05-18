class Address < ActiveRecord::Base
  has_many :addresses, class_name: 'Address', foreign_key: 'parent_id'
  belongs_to :parent, class_name: 'Address'
  
  has_many :houses
  
  has_one :fts_address, foreign_key: :rowid
  
  validates_with AddressValidator
  
  enum type: [:no_type, :city, :district, :street]
  
  after_save do
    # parents = self.parents
    self.fts_address = FtsAddress.new unless fts_address
    fts_address.name = (parents.map { |x| x.name } + [self.name]).join(', ')
    fts_address.save!
  end
  
  def parents
    res = []
    a = self
    until a.parent.nil?
        a = a.parent
        res << a
    end
    res.reverse
  end
  
  class << self
    # http://www.sqlite.org/fts3.html
    def fts(q)
      q << '*' unless q.last == ' ' # space
      FtsAddress.where('name MATCH ?', q)
    end
  end
end

class AddressValidator < ActiveModel::Validator
  def validate(record)
    parents = record.parents
    # типы не должны повторяться, а их индексы должны расти (кроме 0)
    a = parents.map { |x| x.type }.reject { |x| x == 0 }
    record.errors[:type] << 'Hierarhy of types is not correct' unless a.sort.uniq == a
  end
end
