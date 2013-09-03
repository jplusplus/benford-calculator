(angular.module 'benford', []).
    config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) =>
        $locationProvider.html5Mode yes
        $routeProvider.when('/', {templateUrl : 'partials/index.html', controller: "indexCtl"})
                      .when('/checker', {templateUrl : 'partials/checker.html', controller: "indexCtl"})
                      .otherwise({redirectTo : '/'})
    ]
