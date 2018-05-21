class AddGeneralDeltaToCheckins < ActiveRecord::Migration
  def change
    add_column :checkins, :general_delta, :decimal
  end
end
