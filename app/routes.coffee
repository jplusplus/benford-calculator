exports.index = (req, res) =>
	res.render 'index'

exports.checker = (req, res) =>
    #Extract numbers from the text
    regex = /\d+([.,]?\d+)*/gm
    numbers = req.body.data.match regex

    #Get the first digit for each
    #Compute magnitudes in the same loop
    total = 0
    results = {}
    magnitudes = {0 : 0}
    lastMagnitude = 0
    results[i] = 0 for i in [1..9]
    for i of numbers
        numbers[i] = parseInt (String numbers[i]).replace /[.,]/, ''
        if String(numbers[i])[0] > 0
            ++total
            ++results[String(numbers[i])[0]]
            pow = 0
            tmp = numbers[i]
            while tmp >= 10
                tmp /= 10
                ++pow
            if pow > lastMagnitude
                magnitudes[j] = 0 for j in [lastMagnitude..pow]
                lastMagnitude = pow
            ++magnitudes[pow]

    #Compute %
    percents = []
    for key, value of results
        percents.push [parseInt(key),
                       (Math.round (value * 100 / total) * 10) / 10]

    #Compute magnitudes %
    magnitudePercents = []
    for key, val of magnitudes
        magnitudePercents.push [key,
                         (Math.round (magnitudes[key] * 100 / total) * 10) / 10]

    #Finally, render the page
    locals =
        results : results
        total : total
        percents : percents
        law : [
            [1, 30.1]
            [2, 17.6]
            [3, 12.5]
            [4, 9.7]
            [5, 7.9]
            [6, 6.7]
            [7, 5.8]
            [8, 5.1]
            [9, 4.6]
        ]
        magnitudes : magnitudePercents
    res.render 'checker', locals