class Checker extends BaseCtl
    #Inject dependencies
    @$inject : ['$scope']

    constructor : (@scope) ->
        super arguments
        #Scope properties
        @scope.magHidden = yes

    @getGlobalOptions : () ->
        {
            plotOptions:
                column:
                    borderWidth: 0
                spline:
                    borderWidth: 0
            chart :
                backgroundColor : 'transparent'  
                height : 400      
            colors: ['#A5A8AA', '#F4E895']
            yAxis :           
                gridLineWidth: 0
                tickColor: "#8A9093"
                title: false
                title : '%'
                labels :
                    style:
                        color: '#8A9093'                          
                        fontSize: 16
                        fontFamily: '"Helvetica Neue", Helvetica, Arial, geneva, sans-serif'
                    formatter : () ->
                        @value + '%'            
            xAxis:
                lineColor: '#A5A8AA'
                tickWidth: 0
                labels:
                    style:
                        color: '#8A9093'  
                        fontSize: 16
                        fontFamily: '"Helvetica Neue", Helvetica, Arial, geneva, sans-serif'
                    formatter: ->@value  
            tooltip :
                shared : yes
                followPointer : yes
                valueSuffix : '%'
                backgroundColor: "#0C1016"
                borderRadius: 2
                style:
                    color: '#8A9093'                      
                    fontSize: 16
                    fontFamily: '"Helvetica Neue", Helvetica, Arial, geneva, sans-serif'
            credits :
                enabled : no
            legend :
                verticalAlign : 'top'
                align : 'center'
                floating : yes
                y : 35
                borderWidth: 0
                itemStyle:
                    color: '#C5C8C9'                      
                    fontSize: 16
                    fontFamily: '"Helvetica Neue", Helvetica, Arial, geneva, sans-serif'
                itemHoverStyle:
                    color: '#E2E3E4'  
        }

    @getLawChartOptions : (percents, data2) ->
        angular.extend (do Checker.getGlobalOptions),
            title:
                style:
                    color: '#fff'
                    'font-weight': 'bold'
                text: "Benford's law vs. your data"           
            series: [
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

    @getMagnitudeChartOptions : (magnitudes) ->
        xAxis = []
        xAxis.push "10e#{key}" for key of magnitudes
        angular.extend (do Checker.getGlobalOptions), {
            title :
                style:
                    color: '#fff'
                    'font-weight': 'bold'
                text : "Orders of magnitude"
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