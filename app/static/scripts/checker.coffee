class Checker extends BaseCtl
    #Inject dependencies
    @$inject : ['$scope']

    constructor : (@scope) ->
        super arguments

        #Scope properties
        @scope.step2 = 'strong'
        @scope.magHidden = yes

    @getGlobalOptions : () ->
        {
            chart :
                backgroundColor : '#ddd'
            colors: ['#e6501d', '#494989', '#000', '#907761',
                     '#f29a02', '#f8fbf4', '#fffdfb', '#ece3de',
                     '#f7f7db']
            yAxis :
                title : '%'
                labels :
                    formatter : () ->
                        @value + '%'
            tooltip :
                shared : yes
                followPointer : yes
                valueSuffix : '%'
            credits :
                enabled : no
            legend :
                verticalAlign : 'top'
                align : 'right'
                floating : yes
                y : 35
        }

    @getLawChartOptions : (percents, law, range) ->
        angular.extend (do Checker.getGlobalOptions), {
            title :
                text : "Benford's law vs. your data"
                style :
                    color : '#000'
                    'font-weight' : 'bold'
            xAxis :
                labels :
                    formatter : () ->
                        @value
            series : [
                {
                    type : 'columnrange'
                    name : "Benford's law"
                    data : range
                }
                {
                    type : "spline"
                    name : 'Your data'
                    data : percents
                }
            ]
        }

    @getMagnitudeChartOptions : (magnitudes) ->
        xAxis = []
        xAxis.push "10^#{key}" for key of magnitudes
        angular.extend (do Checker.getGlobalOptions), {
            title :
                text : "Orders of magnitude"
                style :
                    color : '#000'
                    'font-weight' : 'bold'
            series : [{
                type : 'column'
                name : 'Orders of magnitude'
                data : magnitudes
            }]
            legend :
                enabled : no
            xAxis :
                categories : xAxis
        }

window.Checker = Checker