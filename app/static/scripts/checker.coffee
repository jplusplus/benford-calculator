class Checker
    #Inject dependencies
    @$inject : ['$scope']

    constructor : (@scope) ->
        #Scope properties

        #Scope methods

(angular.module 'benford', []).
    config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) =>
        $locationProvider.html5Mode yes
        $routeProvider.when('/',
                            {templateUrl : 'partials/checker.html', controller : Checker})
                      .otherwise({redirectTo : '/'})
    ]
