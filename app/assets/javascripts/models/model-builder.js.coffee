models.ModelBuilder = () ->
  builder = @

  builder.extendWithReassign = (model, assignAttributesCallback) ->
    model.reassignAttributes = (attrs) ->
      attrs = $.extend({}, attrs)
      assignAttributesCallback(attrs) if assignAttributesCallback
      model.keys = []
      for key of attrs
        model.keys.push(key)
        model[key] = attrs[key]
        model[key + "_original"] = attrs[key]

  builder.extendWithBase = (model) ->
    model.isDirty = ->
      result = false
      $.each(model.keys, (index, key) ->
        if model[key] != model[key + "_original"]
          result = true
          return false
      )
      result

    model.isNew = ->
      !model.id

    model.rollback = ->
      $.each(model.keys, (index, key) ->
        model[key] = model[key + "_original"]
      )

    model.flush = ->
      $.each(model.keys, (index, key) ->
        model[key + "_original"] = model[key]
      )

    model.getAttributes = ->
      result = {}
      $.each(model.keys, (index, key) ->
        result[key] = model[key]
      )
      result.date = helpers.convertToDate(result.date)
      result

  builder
