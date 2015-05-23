models.User = (attributes) ->
  self = @

  builder = new models.ModelBuilder()
  builder.extendWithBase(self)
  builder.extendWithReassign(self, (attrs) ->
    if attrs
      attrs.paid = parseFloat(attrs.paid) || 0
      attrs.debt = parseFloat(attrs.debt) || 0
    attrs
  )

  self.reassignAttributes(attributes)
  self
