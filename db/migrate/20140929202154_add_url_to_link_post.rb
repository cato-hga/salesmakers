class AddUrlToLinkPost < ActiveRecord::Migration
  def change
    add_column :link_posts, :url, :string, null: false
  end
end
