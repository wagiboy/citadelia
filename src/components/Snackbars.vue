<template>
  <div>
  	<!-- displays the blockchain transactions in form of snackbars -->
    <v-snackbar v-model="events.txnStart.show" color="secondary" top right>
      <span>Transaction in progress. {{ events.txnStart.msg }}</span>
      <template v-slot:action="{ attrs }">
        <v-btn text v-bind="attrs" @click="events.txnStart.show = false">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </template>
    </v-snackbar>

    <v-snackbar v-model="events.txnFailure.show" color="secondary" top right>
      <span>Failed. {{ events.txnFailure.msg }}</span>
      <template v-slot:action="{ attrs }">
        <v-btn text v-bind="attrs" @click="events.txnFailure.show = false">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </template>
    </v-snackbar>			

    <v-snackbar v-model="events.txnSuccess.show" color="secondary"  top right>
      <span>Drip transaction success. {{ events.txnSuccess.msg }}</span>
      <template v-slot:action="{ attrs }">
        <v-btn text v-bind="attrs" @click="events.txnSuccess.show = false">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </template>
    </v-snackbar>	
  </div>		
</template>

<script>
import eventBus from '@/eventBus.js'
export default {
  name: 'Snackbars',
  data: () => ({
  	events: {
			txnStart: {
        msg: '',
        show: false
      },
			txnFailure: {
        msg: '',
        show: false
      },
			txnSuccess: {
        msg: '',
        show: false
		  }
    }
  }),
  created() {
    eventBus.$on("drip-start", (txHash) => {
      // console.log("Snackbars() eventBus.on('drip-start')")
      this.events.txnStart.msg = 'txHash='+txHash
      this.events.txnStart.show = true
    }),
		eventBus.$on("drip-failure", (msg) => {
      // console.log("Snackbars() eventBus.on('drip-failure')")
      this.events.txnFailure.msg = msg
      this.events.txnFailure.show = true
    }),
		eventBus.$on("drip-success", (txHash) => {
      // console.log("Snackbars() eventBus.on('drip-success')")
      this.events.txnSuccess.msg = 'txHash='+txHash
      this.events.txnSuccess.show = true
    })
  }    
}
</script>