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
        percents.push [parseInt(key), value * 100 / total]
    console.log percents

    #Finally, render the page
    locals =
        results : results
        total : total
        percents : percents
    res.render 'checker', locals