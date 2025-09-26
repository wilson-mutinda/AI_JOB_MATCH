class CreateRecruiters < ActiveRecord::Migration[8.0]
  def change
    create_table :recruiters do |t|
      t.references :user, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :company

      t.timestamps
    end
  end
end
