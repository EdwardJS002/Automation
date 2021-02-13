const path = require('path');

const bodyParser = require('body-parser');
const express = require('express');
const cors = require('cors');

const sms = require('./routes/sms');

// EXPRESS INITIALIZATION

app.use(cors());

const app = express();
const port = 4000;

// PARSING

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

// HBS CONFIGURATIONS
express.static.mime.define({ 'text/plain': ['md'] });

app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'hbs');

//app.use(express.static(path.join(__dirname,"public")));
app.use(express.static(__dirname + '/public'));

// ROUTES

app.use('/sms', sms);
app.get('/', (req, res) => {
	return res.render('index');
});

// LISTENING

app.listen(port, () => {
	console.log(`SMS Api listening at http://localhost:${port}`);
});
