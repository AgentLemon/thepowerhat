directives.directive("ngTagsHighlight", () ->
  link: (scope, element, attrs) ->
    $(element).tagsHighlight(select: (value) ->
      model = scope
      fields = attrs.ngModel.split(".")
      last = fields.pop()
      _.each(fields, (i) -> model = model[i])
      model[last] = value
    )
)
