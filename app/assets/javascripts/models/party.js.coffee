models.Party = (attributes) ->
  self = this;
  builder = new models.ModelBuilder()
  builder.extendWithBase(self)
  builder.extendWithReassign(self, (attrs) ->
    attrs["date"] = new Date(attrs["date"])
    if attrs.party_members_attributes
      attrs.total = 0
      attrs.paid = 0
      attrs.debt = 0
      _.each(attrs.party_members_attributes, (i) ->
        i.debt = parseFloat(i.debt) || 0
        i.paid = parseFloat(i.paid) || 0
        i.total = parseFloat(i.total) || 0
        if i.you
          attrs.total += i.paid - i.debt
          attrs.paid += i.paid
          attrs.debt += i.debt
      )
    attrs
  )
  self.reassignAttributes(attributes)

  rollback = self.rollback
  self.rollback = ->
    self.party_members_attributes_original = _.reject(self.party_members_attributes, (i) -> !i.id)
    _.each(self.party_members_attributes, (i) -> i._destroy = undefined)
    rollback()

  self
