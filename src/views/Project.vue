<template>
  <div>        
    <!-- project -->
    <v-card height="500" width="700" class="text-center mt-15 mx-auto" style="border:1px solid #000">  

      <v-card max-width="446" class="mt-n5 ml-n10" elevation="15" rounded="30">
        <v-img width="446" :src="require(`@/assets/project-1.jpg`)"></v-img>  
      </v-card>

      <p>pid #{{ pid }}</p>

      <!-- <p class="text-h5 mb-1">{{ project.title }}</p>
        <p>project #{{ project.id }}<br>
          minimum contribution: {{ project.min }} ether
          <v-tooltip top>
            <template v-slot:activator="{ on }">                  
              <v-icon  v-on="on" style="margin-top:-0.2em" small>mdi-help-circle-outline</v-icon>
            </template>  
            <span>The minimum amount of ether to be contributed to become a project sponsor.</span>    
          </v-tooltip> 
        </p> -->

        <!-- <v-divider class="my-4"></v-divider>
        <p class="text-subtitle-1">{{ project.description }}</p> -->
    </v-card>

    <!-- spending requests for project -->
    <!-- <v-row class="mx-7">
      <v-col cols="12" md="6" v-for="spendingRequest in spendingRequests" :key="spendingRequest.vid">    
        <v-card class="mx-auto my-12" max-width="748">
          <v-img width="748" :src="require(`@/assets/vendor-${spendingRequest.vid}.jpg`)"></v-img>

          <v-card-text>
            <p class="text-h5 mb-1">{{ spendingRequest.name }}</p>
            <p>spendingRequest id: #{{ spendingRequest.vid }}<br>
              spendingRequest address: {{ spendingRequest.walletAddress }}
              <v-tooltip top>
                <template v-slot:activator="{ on }">                  
                  <v-icon  v-on="on" style="margin-top:-0.2em" small>mdi-help-circle-outline</v-icon>
                </template>  
                <span>The ethereum wallet address used to transfer funds to as a payment of products and services.</span>    
              </v-tooltip> 
            </p>            

            <v-divider class="my-4"></v-divider>
            <p class="text-subtitle-1">{{ spendingRequest.description }}</p>                
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>     -->
  </div>
</template>

<script>
export default {
  props: {
    pid: 0
  },  
  data: () => ({ 
    projects: [{
      id: 1,
      title: "Shoreline Park",
      description: "Construct a narrow and long park in Gebel City along the shoreline.", 
      min: 1,
    },{
      id: 2,
      title: "Streetlights Installation",
      description: "Install eight streetlights on Liberty street consisting of lamppost, lamp and electing wiring.", 
      min: 0.1
    },{
      id: 3,
      title: "Erect statue of Titus Gebel",
      description: "Artist Patrik Schuhmacher has completed his statue of Titus Gebel. Concrete and Anchor this statue in concrete and erect on the town square.", 
      min: 0.2       
    }],        
    spendingRequests: [{
      srid: 1,
      name: "Wood for Picknick area and Playground",
      description: "The Shoreline Park includes picknick area and playground. To construct such, we need approximately 10 cubic meters of fir wood to build benches, tables, slides, swings, and fencing.",       
      amoundInWei: 1000000000000000000,
      vid: 1
    },{
      srid: 2,
      name: "Material for Base of Titus Gebel Statue",
      description: "Titus Gebels statue must be anchored in concrete. We need to purchase 1/2 cubic meters of cement, 1 cubic meter of gravel and one cubic meter of sand. The cement will be blended with water and combined with gravel and sand to build a base.",       
      amoundInWei: 200000000000000000,
      vid: 1   
    },{
      srid: 3,
      name: "Errection of Titus Gebel Statue",
      description: "Titus Gebels statue must be anchored in concrete. We need to purchase 1/2 cubic meters of cement, 1 cubic meter of gravel and one cubic meter of sand. The cement will be blended with water and combined with gravel and sand to build a base.",       
      amoundInWei: 200000000000000000,
      vid: 2           
    }]
  })
}
</script> 