class CreateJobs < ActiveRecord::Migration[8.0]
  def change
    create_table :jobs do |t|
      t.references :recruiter, null: false, foreign_key: true
      t.text :title
      t.text :description

      t.timestamps
    end
  end
end
