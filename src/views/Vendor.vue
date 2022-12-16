<template>
  <div>        
    <!-- intro -->
    <v-sheet elevation="0" height="150" class="text-center my-10">    
      <v-icon class="bluegrey--text" x-large>mdi-cart</v-icon>
      <p class="text-h4 bluegrey--text font-weight-regular">List of Vendors</p> 
      <p class="text-title bluegrey--text mx-15 px-15">Vendors provide products and services to Free Cities projects. They are paid directly out of the project's treasury, thus avoiding any chance of embezzlement.</p>            
    </v-sheet>

    <v-row class="mx-7">
      <v-col cols="12" md="6" v-for="vendor in vendors" :key="vendor.vid">    
        <v-card class="mx-auto my-12" max-width="748">
          <v-img width="748" :src="require(`@/assets/vendor-${vendor.vid}.jpg`)"></v-img>

          <v-card-text>
            <p class="text-h5 mb-1">{{ vendor.name }}</p>
            <p>vendor id: #{{ vendor.vid }}<br>
              vendor address: {{ shortenAddress(vendor.walletAddress) }}
              <v-tooltip top>
                <template v-slot:activator="{ on }">                  
                  <v-icon  v-on="on" style="margin-top:-0.2em" small>mdi-help-circle-outline</v-icon>
                </template>  
                <span>The ethereum wallet address used to transfer funds to as a payment of products and services.</span>    
              </v-tooltip> 
            </p>            

            <v-divider class="my-4"></v-divider>
            <p class="text-subtitle-1">{{ vendor.description }}</p>
      
            <v-btn 
              color="primary"          
              small
              class="text-capitalize" 
              @click="details(project.id)"
            >
              View Project Details
            </v-btn>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>    
  </div>
</template>

<script>
export default {
  data: () => ({ 
    vendors: [{
      vid: 1,
      name: "Freedom Supply",
      description: "Freedom Supply is Gebel City's primer distributor of construction supplies, including lighting, furnishings, landscape supplies, steel framing, gypsum wallboard, construction equipments along with tools and accessories.",       
      walletAddress: "0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB",
    },{
      vid: 2,
      name: "Liberty Labor",
      description: "Liberty Labor is Gebel City's first construction company specializing in the construction of city parks, sidewalks, and lighting.", 
      walletAddress: "0x617F2E2fD72FD9D5503197092aC168c91465E7f2",
    }]
  }),
  methods: {
    shortenAddress(address) {
      return address.substring(0,5)+"..."+address.substring(address.length - 3, address.length)
    }
  }
}
</script> 