const express = require('express')

let sms = require('./sms/index')
let test = require('./test')

// Client

const router = () => {
	let router = express.Router()

	router.use('/sms', sms)
	router.use('/test', test)

	return router
}

module.exports = router
