module GeneralHelper

  def purge_database
    [Post, Tag, User].each(&:destroy_all)
  end

  def create_party!(*params)
    Party.create!(
      party_members_attributes:
        params.each_slice(3).to_a.map do |i|
          { user: i[0], debt: i[1], paid: i[2] }
        end
    )
  end

end