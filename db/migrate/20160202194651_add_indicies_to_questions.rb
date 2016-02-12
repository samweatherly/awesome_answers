class AddIndiciesToQuestions < ActiveRecord::Migration
  def change

    add_index :questions, :title
    add_index :questions, :body

    # This creats a unique index
    # add_index :questions, :body, unique: true

    # To create a composite index you can do :
    # add_index :questions, [:title, :body]

    
  end
end
