# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'csv'
require 'db_seed_populator'
require 'db_seed_populators/people'
require 'db_seed_populators/checkins'

%w{Person Checkin}.each do |model_name|
  collection_name = model_name.downcase.pluralize
  csv_file = Rails.root.join('lib','seeds',"#{collection_name}.csv")
  csv = File.open(csv_file)
  csv_rows = CSV.parse(csv, :headers => true)
  populator = DbSeedPopulator.new("DbSeedPopulators::#{model_name.pluralize}".constantize, csv_rows)
  populator.prepare
  rows = csv_rows.map do |row|
    populator.record_block.call(row)
  end.select(&:present?)
  model_name.constantize.import(rows)
end
