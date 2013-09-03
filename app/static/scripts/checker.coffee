class Checker
    #Inject dependencies
    @$inject : ['$scope']

    constructor : (@scope) ->
        #Scope properties

        #Scope methods
        @scope.showChart = () =>
            ($ '#chart').highcharts window.chartOptions

#Define Highcharts options
window.chartOptions =
    chart :
        backgroundColor : '#eee'
    title :
        text : "Benford's law vs. your data"
        style :
            color : '#000'
    colors: ['#e6501d', '#e6b371', '#cf7131', '#907761',
             '#f29a02', '#f8fbf4', '#fffdfb', '#ece3de',
             '#f7f7db']
    xAxis :
        categories : [ '0', '1', '2', '3', '4', '5',
                       '6', '7', '8', '9' ],
        labels :
            formatter : () ->
                @value
    yAxis :
        title : '%'
        labels :
            formatter : () ->
                @value + '%'
    tooltip :
        formatter : () ->
            @y + '%'
    series : [
        {
            type : "column"
            name : 'Your data'
            data : locals.percents
        }
        {
            type : 'spline'
            name : "Benford's distribution"
            data : locals.law
        }
    ]
window.Checker = Checker