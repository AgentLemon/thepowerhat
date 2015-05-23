class PartyPresenter < SimpleDelegator

  include Concerns::Taggable

  def initialize(obj)
    @obj = obj
    super(obj)
  end

  def date_formatted
    @obj.date.strftime("%d %b<br/>%Y")
  end

  def members
    @obj.party_members.map{ |u| PartyMemberPresenter.new(u) }
  end

end
