/* ---------------------------------------------------------------
 * Represents the TTZ ERC20 smart contract
 * --------------------------------------------------------------- */  
import env      from '@/env.js'
import store    from '@/store.js'
import eventBus from '@/eventBus.js'
import abi      from '@/web3/abi.js'
import web3     from '@/web3/web3.js'

class CitadeliaContract {
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

  async fetchTokenName() {
    try {
      // console.log('Contract::fetchTokenName()')
      
      store.tokenName = await this.contract.methods.name().call()
      // console.log('store.tokenName=' + store.tokenName)
    }
    catch (error) {
      console.log("Caught exception in Contract::fetchTokenName() " + error)
    }    
  }

  async fetchTokenSymbol() {
    try {
      // console.log('Contract::fetchTokenSymbol()')
      
      store.tokenSymbol = await this.contract.methods.symbol().call()
      // console.log('store.tokenSymbol=' + store.tokenSymbol)
    }
    catch (error) {
      console.log("Caught exception in Contract::fetchTokenSymbol() " + error)
    }    
  }

  async fetchTotalSupply() {
    try {
      // console.log('Contract::totalSupply()')
      
      store.totalSupply = await this.contract.methods.totalSupply().call()
      // console.log('totalSupply=' + store.totalSupply)

      // insert commas: 1000000000000000000000000 -> 1,000,000
      store.totalSupplyFormatted = web3.balanceInTTZ(store.totalSupply)
      // console.log('totalSupplyFormatted='+store.totalSupplyFormatted)
    }
    catch (error) {
      console.log("Caught exception in Contract::fetchTotalSupply() " + error)
    }    
  }

  async fetchCirculatingSupply() {
   /* Fetches the balance of TTZToken of Dirk's account ('0xb84')
    * ----------------------------------------------------------- */
    try {
      const balanceOfDirk = await this.contract.methods.balanceOf(env.walletAddress).call()  
      // console.log("Contract::fetchCirculatingSupply() balanceOfDirk="+balanceOfDirk) 

      const circulatingSupply = BigInt(store.totalSupply - balanceOfDirk)
      // console.log("circulatingSupply="+circulatingSupply) 

      const circulatingSupplyInFullUnits = web3.web3lib.utils.fromWei(circulatingSupply.toString(), 'ether')
      // console.log("Contract::fetchCirculatingSupply() circulatingSupplyInFullUnits="+circulatingSupplyInFullUnits)

      var circulatingSupplyFormatted = Math.ceil(circulatingSupplyInFullUnits)
          circulatingSupplyFormatted = Number(circulatingSupplyFormatted).toLocaleString('en-US').toString() 
      // console.log("Contract::fetchCirculatingSupply() circulatingSupplyFormatted="+circulatingSupplyFormatted) 
      store.circulatingSupplyFormatted = circulatingSupplyFormatted

      const percentage = Math.ceil(Number(circulatingSupply) / store.totalSupply * 100)
      // console.log("percentage="+percentage)
      store.circulatingSupplyAsPercentage = percentage   
    }
    catch (error) {
      console.log("Caught exception in Contract::fetchCirculatingSupply() " + error)
    }    
  }
  
  async fetchBalances() {
    try {
      // console.log('Contract::fetchBalances()')
      
      const balances = await this.contract.methods.getBalances().call()
      // console.log(balances)
      store.addressesWithBalance = balances[0]
      store.balances             = balances[1]
      // console.log(store.addressesWithBalance)
      // console.log(store.balances)
    }
    catch (error) {
      console.log("Caught exception in Contract::fetchBalances() " + error)
    }    
  }

 /* -----------------------------------------------
  * event handling
  * ----------------------------------------------- */
  listenToEvents() {
    // console.log('Contract::listenToEvents() instantiated contract with websocket provider')

    const gasPrice = 2 * 10000 * 10 ** 9
    const wsContract = new web3.web3socket.eth.Contract(abi, env.contractAddress, { from: env.walletAddress, gasPrice: gasPrice }) 
    //console.log(wsContract)

    wsContract.events.Drip({})
      .on('data', async function(event) {
        // console.log('Drip event - on data')
        // console.log(event)
        eventBus.$emit('drip-success', event.transactionHash)        
      })
      .on('error', async function(error) {
        // console.log('Drip event - on error')
        // console.log(error)
        eventBus.$emit('drip-failure')        
      })
  }

  async drip(address) {
    /**
     * Creates, signs and sends the drip transaction .
     * This results in calling the drip() method on the TTZ smart contractin 
     * and the drippping of 10 TTZ to the address provided by the website user.
     * 
     * Testing wallet addresses in Dirk's MetaMask wallet
     * 2nd - 0xe83Bc36AB088eE9DEBf0EdC358836013D1cfa18c
     * 3rd - 0xCB45ad9D8fC670b94A93504Deb0Dc00C25ec370a
     */
    // console.log("Contract::drip( address="+address+" )")

    // The number of previous transactions sent from wallet address.
    // This txCount is needed for security purposes and to prevent replay attacks 
    const txCount = await web3.web3lib.eth.getTransactionCount(env.walletAddress)
    //console.log("txCount="+txCount)

    const transferABI = await this.contract.methods.drip(address).encodeABI()
    //console.log("transverABI="+transferABI)

    /** --------------------------------
     * The unsigned (raw) transaction object
     * nonce: number of transactions sent up until now
     * to: the address to send eth to or in our case TTZ token to
     * gas: the amount of gas provided in the transaction
     * data: hexidecimal representation of the function we want to call on the smart contract
     */ 
    const gasLimit = 1000000
    const txObject = {
      nonce: web3.web3lib.utils.toHex(txCount),
      to:    env.contractAddress,
      gas:   web3.web3lib.utils.toHex(gasLimit),
      data:  transferABI
    }

    //sign the transaction
    const signedTx = await web3.web3lib.eth.accounts.signTransaction(txObject, env.privateKey);
    //console.log(signedTx)
   
    // Broadcast the transaction
    let txHash 
    try {
      await web3.web3lib.eth.sendSignedTransaction(signedTx.rawTransaction, function(error, txHashInBlock) {
        if (!error) {
          // console.log("Transaction started. Transaction hash: ", txHashInBlock);
          txHash = txHashInBlock 
          eventBus.$emit('drip-start', txHash)
        } 
        else {
          // console.log("Something went wrong while submitting your transaction:")
          // console.log(error)
          eventBus.$emit('drip-failure', "Error in web3.eth.sendSignedTransaction()")
        }
      })
    } 
    catch(error) {
      this.handleException(txHash)
    }
  }

  async handleException(txHash) {
   /* Handles the exception thrown from the smart contract by 
    *
    * 1) Extracting the reason for the transaction revert by calling the same transaction again
    * and catching that throw again. Unlike a web.eth.sendSignedTransaction()  
    * a web3.web3lib.eth.call() includes the reason for the revert, that is the text in 
    * the smart contract's require precondition within the exception text.
    * This exception is parsed and the revert reason extracted.
    * 
    * 2) emitting an event to VUE js to display the reason to the user
    */
    // console.log('handleException( txHash='+txHash+' )')

    const tx = await web3.web3lib.eth.getTransaction(txHash)
    this.callErroneousTransactionAndEmit(tx)
  }   
  
  async callErroneousTransactionAndEmit(tx) {
    await web3.web3lib.eth.call(tx, tx.blockNumber).catch( error => {
      const errmsg = error.toString()
      // console.log("errmsg="+errmsg)
      if (errmsg.length > 0 ) {
        const reason = this.extractRevertReason(errmsg)
        // console.log('reason='+reason)   
        eventBus.$emit('drip-failure', reason)
      }
    })
  }

  extractRevertReason(errmsg) {
    return errmsg.substr(43)+'.'
  }
}

export default new CitadeliaContract()