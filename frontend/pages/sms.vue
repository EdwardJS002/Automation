<template>
	<div>
		<v-form ref="form" v-model="valid" lazy-validation>
			<v-textarea name="numbers" label="Phone Numbers" v-model="phones" required> </v-textarea>

			<v-textarea name="messages" label="Messages" v-model="message" required></v-textarea>

			<v-btn :disabled="!valid" color="success" class="mr-4" @click="validate"> Envoyer </v-btn>

			<v-btn class="mr-4" @click="reset"> Nettoyer </v-btn>
		</v-form>

		<div class="text-center ma-2">
			<v-btn dark @click="snackbar = true"> Open Snackbar </v-btn>
			<v-snackbar v-model="snackbar" :timeout="timeout" color="teal">
				{{ snackbarText }}
			</v-snackbar>
		</div>
	</div>
</template>

<script>
export default {
	data: () => ({
		valid: false,
		message: '',
		phones: '',
		snackbar: false,
		snackbarText: '',
		timeout: 2000
	}),

	methods: {
		validate() {
			this.$refs.form.validate()
			this.sendSMS(this.message, this.phones)
			this.$refs.form.reset()
		},
		reset() {
			this.notify('Formulaire Nettoyé')
			this.$refs.form.reset()
		},
		async sendSMS(message, phones) {
			const response = await this.$axios.$get(`/sms?phone=${phones}&message=${message}`)
			this.response = response
			console.log(response)
			this.notify('Message Envoyé !')
		},

		async notify(text) {
			this.snackbar = true
			this.snackbarText = text
		}
	}
}
</script>

<style lang="scss" scoped></style>
