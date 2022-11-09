/**
 * These enviroment variables should have been defined in an .env-file.
 * Unfortunately, I couldn't access .env files due to the "webpack < 5" error.
 * Thus instead, use module.exports (for the CLI2).
 * Upon upgrating to the CLI 3, the use of .env file and VUE_APP_ access should work.
 **/
 module.exports = {
  /* ------------------------------------------------------------------------
   * Quiknode, Infura and Alchemy offer free RPC endpoints to the Ethereum 
   * network. TTZ uses Quiknode, Citadelia uses Alchemy.
   */
   httpsProvider: 'https://eth-goerli.g.alchemy.com/v2/v7rzO7yiJlfodZWIHj0gGjTUTkLyYVox',
 
   // reading real-time events necessitates web sockets
   wssProvider:   'wss://eth-goerli.g.alchemy.com/v2/v7rzO7yiJlfodZWIHj0gGjTUTkLyYVox',
 
   // the address of the main Citadelia smart contract on the goerli-network
   mainContrAddr: '0x9f0e1d5e10f212a0c6c2b191e72452fdc9835814',
   
   // the address of the wallet which pays for the transactions fees (gas)
   gasWalletAddr: '0xb842ffb5196a0ee01546478e1a993a3e16e0445d',
   
   // private key of the gas wallet to sign transactions with
   privateKey:    '',
 }
