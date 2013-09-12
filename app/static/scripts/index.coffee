class IndexCtl extends BaseCtl
    #Inject dependencies
    @$inject : ['$scope', '$http']

    constructor : (@scope, @http)->
        super arguments
        #Scope properties
        @scope.textareaData = ''
        @scope.step1 = 'strong'
        #Scope methods
        @scope.sampleData = (sampleName) =>
            (@http.get "/samples/#{sampleName}").success (data) =>
                @scope.textareaData = data

window.IndexCtl = IndexCtl