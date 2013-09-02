(angular.module 'benford', []).
    config ['$routeProvider', ($routeProvider) =>
        $routeProvider.when('/', {templateUrl : 'partials/index.html', controller: "indexCtl"})
                      .otherwise({redirectTo : '/'})
    ]