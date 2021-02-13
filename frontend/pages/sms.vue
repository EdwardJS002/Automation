<template>
	<v-form ref="form" v-model="valid" lazy-validation>
		<v-textarea name="numbers" label="Phone Numbers" v-model="phones" required> </v-textarea>

		<v-textarea name="messages" label="Messages" v-model="message" required></v-textarea>

		<v-btn :disabled="!valid" color="success" class="mr-4" @click="validate"> Envoyer </v-btn>

		<v-btn class="mr-4" @click="fetchSomething"> Nettoyer </v-btn>
	</v-form>
</template>

<script>
export default {
	data: () => ({
		valid: false,
		message: '',
		phones: ''
	}),

	methods: {
		validate() {
			this.$refs.form.validate()
			this.fetchSomething()
			this.$refs.form.reset()
		},
		reset() {
			this.$refs.form.reset()
		},
		async fetchSomething(event) {
			const ip = await this.$axios.$get(`/sms?phone=${this.phones}&message=${this.message}`)
			this.ip = ip
			console.log(ip)
		}
	}
}
</script>

<style lang="scss" scoped></style>
