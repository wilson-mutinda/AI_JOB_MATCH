class CreateApplications < ActiveRecord::Migration[8.0]
  def change
    create_table :applications do |t|
      t.references :candidate, null: false, foreign_key: true
      t.references :job, null: false, foreign_key: true
      t.datetime :date_of_application

      t.timestamps
    end
  end
end
