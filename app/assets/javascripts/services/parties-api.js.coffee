services.factory("partiesAPI", ($http) ->
  partiesAPI = {}

  partiesAPI.getRecords = (search, startDate, endDate, page) ->
    $http(
      method: "GET"
      url: "/parties.json"
      params:
        search: search
        start_date: helpers.convertToDate(startDate)
        end_date: helpers.convertToDate(endDate)
        page: page
    )

  builder = new services.ServiceBuilder($http, "parties")
  builder.extendWithCRUD(partiesAPI)

  partiesAPI.getTotalDebts = ->
    $http(
      method: "GET"
      url: "/parties/total_debts.json"
    )

  partiesAPI
)
