import Vue from 'vue'

/* Vue.observable transforms an object into a reactive entity.
 * It's a store for VUE apps, similar to VUEX or Pinia */
const store = Vue.observable({ 
  
  // blockchain data
  gasPriceInGwei: null,
  blockNumber: null,
  
  // contract 
  tokenName: 'TutorZ Token',
  tokenSymbol: 'TTZ',
  totalSupply: 1000000000000000000000000,
})

export default store;