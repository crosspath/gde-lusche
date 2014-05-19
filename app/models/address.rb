class Address < ActiveRecord::Base
  class AddressValidator < ActiveModel::Validator
    def validate(record)
      parents = record.parents
      # типы не должны повторяться, а их индексы должны расти
      a = parents.map { |x| x.adrtype }.reject { |x| x.nil? }
      record.errors[:type] << 'Hierarhy of types is not correct' unless a.sort.uniq == a
    end
  end

  has_many :addresses, class_name: 'Address', foreign_key: 'parent_id'
  belongs_to :parent, class_name: 'Address'
  
  has_many :houses
  
  # has_one :fts_address, foreign_key: :docid
  
  validates_presence_of :name
  validates_with AddressValidator
  
  enum adrtype: [:city, :district, :street]
  
  after_save do
    c = Address.connection
    new_fts = id_was.nil?
    new_fts ||= c.select_value("select count(*) from fts_addresses where docid = #{c.quote id_was}") == 0
    fts_address = {'docid' => self.id}
    fts_address['name'] = (parents.map { |x| x.name } + [self.name]).join(', ')
    if new_fts
      cols = fts_address.keys.map { |x| c.quote x }
      values = fts_address.values.map { |x| c.quote x }
      c.execute "insert into fts_addresses(#{cols.join(',')}) values (#{values.join(',')})"
    else
      changes = fts_address.to_a.map { |k, v| "#{k}=#{c.quote v}" }
      c.execute "update fts_addresses set #{changes.join(',')} where docid = #{c.quote id_was}"
    end
  end
  
  after_destroy do
    Address.connection.execute "delete from fts_addresses where docid = #{c.quote id_was}"
  end
  
  def fullname
    c = Address.connection
    c.select_value("select name from fts_addresses where docid = #{c.quote id_was}")
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
      q ||= ''
      q << '*' unless q.last == ' ' # space
      c = Address.connection
      c.select_rows("select docid, name from fts_addresses where name MATCH #{c.quote q} LIMIT 8")
    end
  end
  
end
