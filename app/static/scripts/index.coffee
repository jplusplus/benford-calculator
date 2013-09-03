class IndexCtl
    #Inject dependencies
    @$inject : ['$scope', '$http']

    constructor : (@scope, @http) ->
        #Scope properties
        @scope.title = 'Benford\'s law online checker'
        @scope.textareaData = ''

        #Scope methods
        @scope.sampleData = (sampleName) =>
            (@http.get "/samples/#{sampleName}").success (data) =>
                @scope.textareaData = data

window.IndexCtl = IndexCtl