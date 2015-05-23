services.ServiceBuilder = ($http, recordName, singularRecordName) ->
  builder = @
  singularRecordName ||= _.singularize(recordName)

  builder.extendWithCRUD = (api) ->
    api.newRecord = ->
      return $http(
        method: "GET"
        url: "/#{recordName}/new.json"
      )

    api.loadRecord = (id) ->
      return $http(
        method: "GET"
        url: "/#{recordName}/#{id}.json"
      )

    api.saveRecord = (record) ->
      method = if record.id then "PUT" else "POST"

      url = "/#{recordName}"
      url += "/#{record.id}" if !record.isNew()
      url += ".json"

      data = {}
      data[singularRecordName] = record.getAttributes()

      return $http(
        method: method
        url: url
        data: data
      )

    api.deleteRecord = (record) ->
      if record.id
        $http(
          method: "DELETE"
          url: "/#{recordName}/" + record.id + ".json"
        )
      else
        success: (callback) ->
          callback()

    api

  builder
