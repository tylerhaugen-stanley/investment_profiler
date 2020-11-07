class AddCompanyModel < ActiveRecord::Migration[6.0]
  def change
    create_table :companies do |t|
      t.integer :stock_id, unique: true, null: false

      t.string :name
      t.string :exchange
      t.string :industry
      t.string :website
      t.string :description
      t.string :ceo
      t.string :security_name
      t.string :issue_type
      t.string :sector
      t.string :employees

      t.timestamps
    end
  end
end
