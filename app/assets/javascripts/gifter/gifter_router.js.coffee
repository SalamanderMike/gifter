class Router
  constructor: (@routeProvider, @locationProvider) ->
    @routeProvider.
      when "/",
        templateUrl: "/gifter_templates",
        controller: "GifterCtrl as gifter"

    @locationProvider.html5Mode(true)

GifterRouter = angular.module("GifterRouter", [
  "ngRoute"
  ])

GifterRouter.config(["$routeProvider", "$locationProvider", Router])

# Define Config for CSRF token (security)
GifterRouter.config ["$httpProvider", ($httpProvider)->
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
]

