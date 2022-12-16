<template>  
    <v-card>
      <v-img src="@/assets/banner.jpg">          
        <v-row no-gutters class="mt-10">                  
          <v-col cols="6" align="right">          
            <v-img
              alt="Citadelia Logo"					
              src="@/assets/logo.png"
              transition="scale-transition"
              contain
              height="45"
              width="40"
              class="mr-0"	            
            /> 
          </v-col>
          <v-col cols="6" class="text-h5 pa-0 mt-2 blue-grey--text font-weight-regular">
            citadelia
          </v-col>               
       </v-row>
       <p class="text-h6 bluegrey--text text-center font-weight-regular ml-15 mt-5">A Funds Management System for Public Projects in Free Cities</p>             
      </v-img>
    </v-card>
</template>

<script>
export default {
  name: 'CitadeliaBanner'
}
</script>
