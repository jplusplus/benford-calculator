fs = require 'fs'
mongodb = require 'mongodb'

title = 'Find the bad guys with Benford&#39;s Law'

#Connect to database
connectURL = process.env.MONGOLAB_URI || process.env.MONGO_URI || 'mongodb://localhost:27017/benford'
coll = null
mongodb.MongoClient.connect connectURL, (err, db) =>
    if not err?
        coll = db.collection 'data'
    else
        console.error err

#Index page
exports.index = (req, res) =>
    res.render 'index', { title : title, ngController : 'IndexCtl' }

renderCheckedPage = (doc, req, res, share = yes, onlychart = no) =>
    locals =
        charts :
            percents : doc.percents
            magnitudes : doc.magnitudes
            law : [1..9].map (d) -> [d, (Math.log 1 + 1 / d) / Math.LN10 * 100]
        total : doc.total
        title : title
        ngController : 'Checker'
        range : []
        z : 0

    sorted = (locals.charts.magnitudes.map (mag) -> parseFloat mag[1]).sort (a, b) -> if a < b then 1 else -1
    applicable = 0
    [0..4].map (i) ->
        if applicable >= 0 and sorted[i] > 0
            applicable += sorted[i]
        else
            applicable = -1
    locals.applicable = applicable > 50

    #Compute some statistical values...
    l1 = "X axis"
    l2 = "Benford's law"
    l3 = "Your data"
    for i of locals.charts.law
        l1 += ',' + locals.charts.law[i][0]
        l2 += ',' + Math.round(locals.charts.law[i][1] * 10) / 10
        l3 += ',' + Math.round(locals.charts.percents[i][1] * 10) / 10
        n = locals.total

        #Expected proportion
        pe = locals.charts.law[i][1] / 100
        #Observed proportion
        po = locals.charts.percents[i][1] / 100

        #Standard deviation
        si = Math.pow (pe * (1 - pe)) / n, (1 / 2)

        #Lower and upper bounds
        up = (pe + 1.96 * si + (1 / (2 * n))) * 100
        low = (pe - 1.96 * si - (1 / (2 * n))) * 100

        abs = (Math.abs po - pe)
        #Z-statistic
        z = null
        if abs > (1 / (2 * n))
            z = (abs - (1 / (2 * n))) / si
        else
            z = abs / si

        index = locals.charts.law[i][0]
        locals.range[i] = [index, low, up]
        locals.z = z if z > locals.z
    locals.z = (Math.round locals.z * 1000) / 1000
    locals.csvdata = l1 + '\n' + l2 + '\n' + l3;

    if share
        #If the results were stored in DB, display the `share URL`
        locals.shareUrl = req.protocol + '://' + (req.get 'host') + req.url
    res.render (if onlychart then 'onlychart' else 'checker'), locals

exports.checker = (req, res) =>
    globalString = req.body.data

    #If there's uploaded file, concatenate its content with
    # req.body.data (textarea's content)
    if req.files.file.name isnt '' || Array.isArray req.files.file
        if not Array.isArray req.files.file
            req.files.file = [req.files.file]
        #If there's more than one file, we iterate trough each
        req.files.file.map (file) =>
            globalString += "\n" + do (fs.readFileSync file.path).toString
            fs.unlink file.path

    thousand = ','
    #Attempt to detect if the decimal separator is `.` or `,`
    #First, compare the proportions of numbers matching XX,XXX.X and XX.XXX,X
    comma = (globalString.match /\d{1,3}(,\d{3})+(\.\d+)+/gm) or []
    dot = (globalString.match /\d{1,3}(\.\d{3})+(,\d+)+/gm) or []
    if (comma.length > 0 or dot.length > 0) and comma.length isnt dot.length
        thousand = comma.length > dot.length and ',' or '.'
    else
        #If this is not concluding, compare the proportions of numbers matching
        # XX,XXX and XX.XXX
        comma = (globalString.match /\d{1,3}(,\d{3})+/gm) or []
        dot = (globalString.match /\d{1,3}(\.\d{3})+/gm) or []
        if (comma.length > 0 or dot.length > 0) and comma.length isnt dot.length
            thousand = comma.length > dot.length and ',' or '.'

    #Extract numbers from the text
    regex = /\d+([.,]?\d+)*/gm
    numbers = globalString.match regex

    #Get the first digit of each number
    #Compute orders of magnitudes in the same loop
    total = 0
    results = {}
    magnitudes = {0 : 0}
    lastMagnitude = 0
    results[i] = 0 for i in [1..9]
    for i of numbers
        #Remove all `,` or `.` from the number depending of detected `thousand separator`
        numbers[i] = parseInt (String numbers[i]).replace (RegExp "[#{thousand}]", 'g'), ''
        if String(numbers[i])[0] > 0
            ++total
            ++results[String(numbers[i])[0]]
            #Cast number into String and use (.length - 1) as order of magnitude
            pow = parseInt (String(numbers[i]).length - 1)
            if pow > lastMagnitude
                magnitudes[j] = 0 for j in [(lastMagnitude + 1)..pow]
                lastMagnitude = pow
            ++magnitudes[String(pow)]

    #Compute %
    percents = []
    for key, value of results
        percents.push [parseInt(key),
                       (value * 100 / total)]

    #Compute magnitudes %
    magnitudePercents = []
    for key, val of magnitudes
        magnitudePercents.push [key,
                         (magnitudes[key] * 100 / total)]

    locals =
        numbers : results
        percents : percents
        magnitudes : magnitudePercents
        total : total

    if req.body.keep == 'on' and locals.total > 0
        #Insert data in DB
        coll.insert locals, {safe : yes}, (err, item) =>
            #Finally, render the page
            res.redirect '/checker/' + item[0]._id
    else
        #Finally, render the page
        renderCheckedPage locals, req, res, no

exports.checked = (req, res) =>
    id = new mongodb.ObjectID req.params.id

    #Retrieve information from the database
    coll.findOne {_id : id}, (err, doc) =>
        if err? or not doc?
            #If the specified ID isn't valid, redirect to home page
            res.redirect '/'
        else
            #Finally, render the page
            renderCheckedPage doc, req, res

exports.chart = (req, res) =>
    id = new mongodb.ObjectID req.params.id

    #Retrieve information from the database
    coll.findOne {_id : id}, (err, doc) =>
        if err? or not doc?
            #If the specified ID isn't valid, redirect to home page
            res.redirect '/'
        else
            #Finally, render the page
            renderCheckedPage doc, req, res, yes, yes

