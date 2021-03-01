export default {
	API_ENDPOINT:
		process.env.NODE_ENV === 'development'
			? 'http://localhost:4000'
			: 'http://localhost:4000',
};
