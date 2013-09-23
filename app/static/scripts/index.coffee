class IndexCtl extends BaseCtl
    #Inject dependencies
    @$inject : ['$scope', '$http']

    constructor : (@scope, @http)->
        super arguments

        #Scope properties
        @scope.textareaData = ''
        @scope.step2 = 'disable'

        #Scope methods
        @scope.sampleData = (sampleName) =>
            (@http.get "/samples/#{sampleName}").success (data) =>
                @scope.textareaData = data

        @scope.onFileUpload = () =>
            @scope.textareaData = ''
            do (document.getElementsByTagName 'form')[0].submit

window.benford.controller 'IndexCtl', IndexCtl