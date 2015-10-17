services.factory("budgetAPI", ($http) ->
  budgetAPI = {}

  budgetAPI.getRecords = (search, startDate, endDate) ->
    $.HttpDecorator($http(
      method: "GET"
      url: "/budget.json"
      params:
        search: search
        start_date: helpers.convertToDate(startDate)
        end_date: helpers.convertToDate(endDate)
    ))

  builder = new services.ServiceBuilder($http, "budget", "budget")
  builder.extendWithCRUD(budgetAPI)

  budgetAPI
)
