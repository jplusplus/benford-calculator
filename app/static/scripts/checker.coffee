class Checker
    #Inject dependencies
    @$inject : ['$scope']

    constructor : (@scope) ->
        #Scope properties

        #Scope methods

#Define Highcharts options
window.chartOptions =
    chart :
        backgroundColor : '#eee'
    title :
        text : ''
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
    credits :
        enabled : no
    legend :
        verticalAlign : 'top'
        align : 'right'
        floating : yes
        y : 35

window.lawOptions = angular.copy window.chartOptions
window.lawOptions.title.text = "Benford's law vs. your data"
window.lawOptions.series = [
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

window.magnitudesOptions = angular.copy window.chartOptions
window.magnitudesOptions.title.text = "Orders of magnitude"
window.magnitudesOptions.xAxis.labels.formatter = () ->
    '10^' + @value
window.magnitudesOptions.legend.enabled = no
window.magnitudesOptions.series = [
    {
        type : "column"
        data : locals.magnitudes
    }
]


window.Checker = Checker