class CreateQuestions < ActiveRecord::Migration
  def change
    # no need to specify an 'id' coumn. ActiveRecord automatically
    # created an integer field called 'id' with AUTOINCREMENT
    create_table :questions do |t|
      t.string :title, null: false
      t.text :body

      t.timestamps null: false
    end
  end
end
