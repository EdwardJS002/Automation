import { Router } from 'express'
import router from './sms'

import sms from './sms'

// Client

const Router = () => {
	const router = Router({ mergeParams: true })

	router.use('/sms', sms)

	return router
}

export default Router
