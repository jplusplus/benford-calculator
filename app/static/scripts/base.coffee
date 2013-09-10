class BaseCtl
    constructor : () ->
        #Scope properties
        @scope.title = 'Benford\'s law online checker'
        @scope.headerLink = '[+] Read more...'
        @scope.hidden = yes

        #Scope methods
        @scope.toggleHead = () =>
            @scope.hidden = !@scope.hidden
            @scope.headerLink = if @scope.hidden then '[+] Read more...' else '[x] Close'

window.BaseCtl = BaseCtl