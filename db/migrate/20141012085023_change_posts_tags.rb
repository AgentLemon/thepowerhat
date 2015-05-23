class ChangePostsTags < ActiveRecord::Migration

  def up
    rename_table(:posts_tags, :tag_links)
    rename_column(:tag_links, :post_id, :link_id)
    add_column(:tag_links, :link_type, :string)
    add_column(:tag_links, :id, :primary_key)
    add_index(:tag_links, :link_type)
    ActiveRecord::Base.connection.execute(%Q{
      update tag_links
      set link_type = 'Post'
    })
  end

  def down
    remove_column(:tag_links, :link_type)
    remove_column(:tag_links, :id)
    rename_column(:tag_links, :link_id, :post_id)
    rename_table(:tag_links, :posts_tags)
  end

end
