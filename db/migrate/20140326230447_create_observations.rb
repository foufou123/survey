class CreateObservations < ActiveRecord::Migration
  def change
    create_table :observations do |t|
      t.column :feedback, :string
      t.column :answer_id, :integer

      t.timestamps
    end
  end
end
