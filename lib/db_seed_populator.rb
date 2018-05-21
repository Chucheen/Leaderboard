class DbSeedPopulator

  def initialize(populator_class, rows)
    @populator = populator_class.new(rows)
  end

  def record_block
    @populator.record_block
  end

  def prepare
    @populator.try(:prepare)
  end

end

Dir["db_seed_populators/*.rb"].each {|file| require file }