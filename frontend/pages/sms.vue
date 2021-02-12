<template>
	<v-form ref="form" v-model="valid" lazy-validation>
		<v-textarea name="numbers" label="Phone Numbers"> </v-textarea>

		<v-textarea name="messages" label="Messages"> </v-textarea>

		<v-btn :disabled="!valid" color="success" class="mr-4" @click="validate"> Envoyer </v-btn>

		<v-btn class="mr-4" @click="fetchSomething"> Nettoyer </v-btn>
	</v-form>
</template>

<script>
export default {
	data: () => ({
		valid: true
	}),

	methods: {
		validate() {
			this.$refs.form.validate()
			this.$refs.form.reset()
		},
		reset() {
			this.$refs.form.reset()
		},
		notif: () => ({
			snackbar: false,
			text: `SMS Envoyé`
		}),
		async fetchSomething() {
			const ip = await this.$axios.$get('http://icanhazip.com')
			this.ip = ip
			console.log(ip)
		}
	}
}
</script>

<style lang="scss" scoped></style>
