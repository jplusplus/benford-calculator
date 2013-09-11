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

    @getLawChartOptions : (percents, data2) ->
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
#                {
#                    type : 'columnrange'
#                    name : "Benford's law"
#                    data : data2
#                }
                {
                    type : "column"
                    name : 'Your data'
                    data : percents
                }
                {
                    type : "spline"
                    name : "Benford's law"
                    data : data2
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

    @getZChartOptions : (z) ->
        xAxis = [0]
        xAxis.push item[0] for item in z
        angular.extend (do Checker.getGlobalOptions), {
            chart :
                backgroundColor : '#ddd'
                height : 400
            title :
                text : "z-statistic"
                style :
                    color : '#000'
                    'font-weight' : 'bold'
            series : [{
                type : 'column'
                name : 'z-statistic'
                data : z
            }]
            legend :
                enabled : no
            yAxis :
                title : ''
            xAxis :
                categories : xAxis
            tooltip :
                shared : yes
                followPointer : yes
        }

window.Checker = Checker