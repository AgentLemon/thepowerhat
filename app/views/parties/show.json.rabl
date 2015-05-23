object @party

attributes :id,
           :title,
           :date,
           :leader_id,
           :tags_line

node :tags do |party|
  party.tags_array
end

node :tags_line_formatted do |party|
  text_with_tags(party.tags_line)
end

child members: "party_members_attributes" do |member|
  attributes :id,
             :user_id,
             :username,
             :avatar_url,
             :debt,
             :paid

  node :total do |m|
    (m.paid || 0) - (m.debt || 0)
  end

  node :you do |m|
    m.user_id == current_user.id
  end
end
