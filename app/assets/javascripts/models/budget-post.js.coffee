models.BudgetPost = (attributes) ->
  self = this;
  builder = new models.ModelBuilder()
  builder.extendWithBase(self)
  builder.extendWithReassign(self, (attrs) ->
    attrs["date"] = new Date(attrs["date"])
    attrs["amount"] = parseFloat(attrs["amount"])
    attrs
  )

  self.reassignAttributes(attributes)
  self
