class CreateBlogModels < ActiveRecord::Migration[7.1]
  def change
    create_table :blog_models do |t|

      t.timestamps
    end
  end
end
