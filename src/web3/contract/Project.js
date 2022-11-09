/* ---------------------------------------------------------------
 * Represents the TTZ ERC20 smart contract
 * --------------------------------------------------------------- */  
import env      from '@/env.js'
import store    from '@/store.js'
import eventBus from '@/eventBus.js'
import abi      from '@/web3/abi.js'
import web3     from '@/web3/web3.js'

class ProjectContract {
 /* Represents the TTZ Smart contract object. 
  * This object interacts with the polygon blockchain 
  * Provides getter methods to fetch data from the smart contract. 
  * --------------------------------------------------------------*/

  constructor() {  
   /* Inititializes the TTZ smart contract object
    */
    const gasPrice = 2 * store.gasPriceInGwei * 10 ** 9

    this.contract = new web3.web3lib.eth.Contract(abi, env.contractAddress, { from: env.walletAddress, gasPrice: gasPrice }) 
    
    // console.log('Contract::constructor() instantiated TTZToken contract')
    // console.log(this.contract)
  }
}

export default new ProjectContract()