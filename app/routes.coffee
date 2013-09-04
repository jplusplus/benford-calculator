fs = require 'fs'
mongodb = require 'mongodb'

title = 'Benford&#39;s law checker'

#Connect to database
connectURL = 'mongodb://localhost:27017/benford'
coll = null
mongodb.MongoClient.connect connectURL, (err, db) =>
    coll = db.collection 'data'

#Index page
exports.index = (req, res) =>
	res.render 'index', { title : title }

renderCheckedPage = (doc, req, res, share = yes) =>
    locals =
        percents : doc.percents
        magnitudes : doc.magnitudes
        total : doc.total
        title : title
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
    if share
        locals.shareUrl = req.protocol + '://' + (req.get 'host') + req.url
    res.render 'checker', locals

exports.checker = (req, res) =>
    globalString = req.body.data

    if req.files.file.name isnt '' || Array.isArray req.files.file
        if not Array.isArray req.files.file
            req.files.file = [req.files.file]
        for file in req.files.file
            globalString += "\n" + do (fs.readFileSync file.path).toString
            fs.unlink file.path

    #Extract numbers from the text
    regex = /\d+([.,]?\d+)*/gm
    numbers = globalString.match regex

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

    locals =
        percents : percents
        magnitudes : magnitudePercents
        total : total

    if req.body.keep == 'on'
        #Insert data in DB
        coll.insert locals, {safe : yes}, (err, item) =>
            #Finally, render the page
            res.redirect '/checker/' + item[0]._id
    else
        renderCheckedPage locals, req, res, no

exports.checked = (req, res) =>
    id = new mongodb.ObjectID req.params.id

    coll.findOne {_id : id}, (err, doc) =>
        if err? or not doc?
            res.redirect '/'
        else
            renderCheckedPage doc, req, res