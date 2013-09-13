class BaseCtl
    constructor : () ->
        #Scope properties
        @scope.title = 'Benford\'s law online checker'
        @scope.hidden = yes

window.BaseCtl = BaseCtl