exports.index = (req, res) =>
	res.render 'index'

exports.checker = (req, res) =>
    #Extract numbers from the text
    regex = /\d+([.,]?\d+)*/gm
    numbers = req.body.data.match regex

    #Get the first digit for each
    total = 0
    results = {}
    results[i] = 0 for i in [1..9]
    for num in numbers
        if String(num)[0] > 0
            ++total
            ++results[String(num)[0]]

    #Compute %
    percents = []
    for key, value of results
        percents.push [parseInt(key),
                       (Math.round (value * 100 / total) * 10) / 10]

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
    res.render 'checker', locals