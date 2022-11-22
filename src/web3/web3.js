/* ---------------------------------------------------------------
 * Instantiates the Web3 library. 
 *
 * One instance for each blockchain in case the client wants 
 * to talk multiple blockchains, be it unlikely.
 * --------------------------------------------------------------- */  

/* ------------------------------------------------------------------------
 * When importing this way: "import Web3 from 'web3'" the error comes up:
 * Error: Can't resolve ‘stream’ in ‘app/node_modules/cipher-base’
 * BREAKING CHANGE: webpack < 5 used to include polyfills for node.js core
 * The solution is to import the ESM module which includes all dependencies. */
import Web3 from 'web3/dist/web3.min.js'
import env  from '@/web3/env.js'

class Web3Library {
 /* Represents the web3 library. 
  * ----------------------------*/
  
  constructor() {  
   /* Inititializes the Web3 library object and
    * the web socket object
    */
    this.web3Library = new Web3(env.httpsProvider)
    console.log('instantiated Web3 library (v'+this.web3Library.version+')')
  
    this.web3Socket = new Web3(new Web3.providers.WebsocketProvider(env.wssProvider)) 
    console.log('instantiated Web3 socket provider (v'+this.web3Socket.version+')')
  }
 
  get web3lib() {
    return this.web3Library
  }

  get web3socket() {
    return this.web3Socket
  }

  weiToEther(wei) {
    const ether = this.web3Library.utils.fromWei(wei, 'ether')
    return Number(ether).toLocaleString('en-US').toString() 
  }
}

export default new Web3Library()