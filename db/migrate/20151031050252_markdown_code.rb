class MarkdownCode < ActiveRecord::Migration
  def change
    Post.where("message ilike '%[code]%'").each do |p|
      p.message.gsub!(/\[\/?code\]/m, '`')
      p.save!
    end
  end
end
