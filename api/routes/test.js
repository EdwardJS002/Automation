const express = require('express')
const router = express.Router()

const Inbox = require('./../models/inbox')

router.get(
	'/',

	async (req, res) => {
		try {
			//const inbox = await Inbox.console.log(inbox.every((user) => user instanceof Inbox)) // true
			//console.log('All users:', JSON.stringify(inbox, null, 2))

			const users = await Inbox.findAll()
			console.log(users.every((user) => user instanceof Inbox)) // true
			console.log('All users:', JSON.stringify(users, null, 2))

			return res.status(205).json(users)
		} catch (error) {
			throw error
			return res.status(500).json(error)
		}
	}
)

module.exports = router
