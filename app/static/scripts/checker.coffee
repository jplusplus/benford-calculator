class Checker
    #Inject dependencies
    @$inject : ['$scope']

    constructor : (@scope) ->
        #Scope properties

        #Scope methods

    @getGlobalOptions : () ->
        {
            chart :
                backgroundColor : '#eee'
            colors: ['#e6501d', '#e6b371', '#cf7131', '#907761',
                     '#f29a02', '#f8fbf4', '#fffdfb', '#ece3de',
                     '#f7f7db']
            yAxis :
                title : '%'
                labels :
                    formatter : () ->
                        @value + '%'
            tooltip :
                formatter : () ->
                    @y + '%'
            credits :
                enabled : no
            legend :
                verticalAlign : 'top'
                align : 'right'
                floating : yes
                y : 35
        }

    @getLawChartOptions : (percents, law) ->
        angular.extend (do Checker.getGlobalOptions), {
            title :
                text : "Benford's law vs. your data"
                style :
                    color : '#000'
            xAxis :
                labels :
                    formatter : () ->
                        @value
            series : [
                {
                    type : "column"
                    name : 'Your data'
                    data : percents
                }
                {
                    type : 'spline'
                    name : "Benford's distribution"
                    data : law
                }
            ]
        }

    @getMagnitudeChartOptions : (magnitudes) ->
        xAxis = []
        xAxis.push key for key of magnitudes
        angular.extend (do Checker.getGlobalOptions), {
            title :
                text : "Orders of magnitude"
                style :
                    color : '#000'
            series : [{
                type : 'column'
                data : magnitudes
            }]
            legend :
                enabled : no
            xAxis :
                categories : xAxis
                labels :
                    formatter : () ->
                        '10^' + @value
        }

window.Checker = Checker