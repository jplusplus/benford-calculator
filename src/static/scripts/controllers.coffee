class IndexCtl
    #Inject dependencies
    @$inject : ['$scope']

    constructor : (@scope) ->
        #Scope properties
        @scope.title = 'Benford\'s law online checker'
        @scope.textarea = ''

#Export controller outside the closure
(angular.module 'benford').controller 'indexCtl', IndexCtl