const bodyParser = require('body-parser')
const express = require('express')
const cors = require('cors')

// const router = require('./routes/router')

// EXPRESS INITIALIZATION

const app = express()
const port = parseInt(process.env.NODE_PORT || process.env.PORT || '4000')

/***************/
/* Middlewares */
/***************/

// Body Parsing
app.use(bodyParser.urlencoded({ extended: true }))
app.use(bodyParser.json())

// CORS
app.use(cors())

/**********/
/* Router */
/**********/

let router = require('./routes/router')
app.use(router())

/*******************/
/* Clients & Start */
/*******************/

app.listen(port, () => {
	console.log(`SMS Api listening at http://localhost:${port}`)
})
