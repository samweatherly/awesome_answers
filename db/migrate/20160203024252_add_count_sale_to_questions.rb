class AddCountSaleToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :count_sale, :integer
  end
end
