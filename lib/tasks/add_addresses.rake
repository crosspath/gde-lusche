desc 'Add addresses to DB'
task add_addresses: :environment do
  10.times do |t1|
    city = Address.create(name: Faker::Address.city, adrtype: Address.adrtypes[:city])
    case rand(2)
    when 0
      10.times do |t2|
        district = Address.create(name: Faker::Address.city, adrtype: Address.adrtypes[:district], parent: city)
        10.times do |t3|
          street = Address.create(name: Faker::Address.street_name, adrtype: Address.adrtypes[:street], parent: district)
          10.times do |t4|
            House.create(name: Faker::Address.building_number, address: street)
          end
        end
      end
    when 1
      100.times do |t2|
        street = Address.create(name: Faker::Address.street_name, adrtype: Address::adrtypes[:street], parent: city)
        10.times do |t3|
          House.create(name: Faker::Address.building_number, address: street)
        end
      end
    end
  end
end
