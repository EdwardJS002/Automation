const express = require('express')

let sms = require('./sms/index')

// Client

const router = () => {
	let router = express.Router()

	router.use('/sms', sms)

	return router
}

module.exports = router
