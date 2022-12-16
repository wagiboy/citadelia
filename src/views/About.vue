<template>
  <div>
    <CitadeliaBanner />
    
    <v-sheet class="ma-10">
      <p class="primary--text text-h6">Q: What problem does Citadelia solve?</p>
      <p class="bluegrey--text">A: Municipal governments tend to mismanage funds for public works projects. For example, bound by law, German cities must advertise the project publicly and assign the contract to the lowest bidder. In order to win the bid, contractors submit bits below the project's profitability point. This leads to the use of low-quality materials, extends project completion times, and/or requires additional funds from the local government. </p>

      <p class="primary--text text-h6">Q: Isn't Citadelia similar to the Kickstarter Website?</p>
      <p class="bluegrey--text">A: Yes and no. The answer is yest because just like Kickstarter,
        Citadelia raises funds for projects. However, Citadelia represents an innovation over Kickstarter, 
        specifically, it is impossible for contractors to misuse the funds they are entrusted with.
        Another way to describe the difference between Kickstarter and Citadelia is that the former is web 2.0 and the latter web 3.0.
        Citadelia, at its core, is a funds management system algorithm that runs on top of a blockchain.
      </p>
      
      <p class="primary--text text-h6">Why blockchain technology a solution to the funds-mismanagement problem?</p>
      <p class="bluegrey--text">A: Blockchain technology together with a consensus algorithm and cryptography 
        is the solution to producing trust in a trustless environment, 
        such as computer networks and larger communities. Even though a project contributor may not trust the contractor's use of funds,
        Citadelia leverages web 3 technologies such that trust is imbued within the system</p>

      <p class="primary--text text-h6">In which other way does Citadelia stand out?</p>
      <p class="bluegrey--text">A: Citadelia harnesses of the knowledge of the crowds: contributors vote on which projects are viable, 
        thus funds are spent wisely. Moreover, Citadelia is very transparent to its users. Project contributors can easily see how the funds are used.</p>

      <p class="primary--text text-h6">Which benefits presents Citadelia to Free Cities?</p>
      <p class="bluegrey--text">
        <v-list dense>
          <v-list-item-group>
            <v-list-item> 
              <v-list-item-icon>
                <v-icon>mdi-cash</v-icon>
              </v-list-item-icon>
              <v-list-item-content class="bluegrey--text">
                Cost savings: no need to spend funds on public works, no need to manage them.
              </v-list-item-content>       
            </v-list-item>
            <v-list-item> 
              <v-list-item-icon>
                <v-icon>mdi-lan</v-icon>
              </v-list-item-icon>
              <v-list-item-content class="bluegrey--text">
                Increase in the decentralization of Free Cities
              </v-list-item-content>       
            </v-list-item>
          </v-list-item-group>
        </v-list> 
      </p>     
      <p class="primary--text text-h6">How is Citadelia architected?</p>
      <p class="bluegrey--text">A: In web 3 terms, Citadelia is a distributed autonomous application or DAPP. It runs on top of the Polygon blockchain. 
        It uses the wrapped bitcoin WBTC to store value.  The DAPP is written in solidity on the smart contract layer.  
        Facing the users, the DAPP utilizes the VUEjs front-end web framework.
      </p>
    </v-sheet>
  </div>
</template>

<script>
import CitadeliaBanner from '@/components/CitadeliaBanner'
export default {
  components: { CitadeliaBanner }
}
</script>

<style>

</style>