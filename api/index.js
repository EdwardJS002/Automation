const bodyParser = require('body-parser')
const express = require('express')
const cors = require('cors')
/****************/
/* Init Express */
/****************/

const app = express()
const port = parseInt(process.env.NODE_PORT || process.env.PORT || '4000')

/***************/
/* Middlewares */
/***************/

// Body Parsing
app.use(bodyParser.urlencoded({ extended: true }))
app.use(bodyParser.json())

// Custom

app.use((req, res, next) => {
	// Save request start time
	req.startTime = Date.now()

	// Log all requests
	res.on('finish', () => {
		console.info(`${req.method} ${req.originalUrl} ${req.ip} (${Date.now() - req.startTime}ms)`)
	})

	// Security
	res.removeHeader('X-Powered-By')

	return next()
})

// CORS
app.use(cors())

/************/
/* Database */
/************/

const { Sequelize } = require('sequelize')

// const sequelize = new Sequelize('sqlite:./../database/example.db')

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
