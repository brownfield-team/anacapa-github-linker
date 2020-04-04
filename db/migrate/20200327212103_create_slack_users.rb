class CreateSlackUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :slack_users do |t|
      t.string :uid
      t.string :username
      t.string :display_name
      t.string :email
      t.belongs_to :roster_student
    end
  end
end
