<template>
  <div>
    <v-carousel
      cycle
      show-arrows-on-hover
      height="100%"   
    >
      <v-carousel-item 
        v-for="(src, i) in slides" 
        :key="i"
        :src="src" 
       >
      </v-carousel-item>
    </v-carousel>

    <v-spacer />

    <p class="display-2 mt-15 gold--text text-center">Citadelia</p>

    <p class="title text-center">Public Works Funds Management System for Free Cities</p>  

     <p class="title text-center">Scheduled go live on October 3rd, 2022</p>    

  </div>
</template>

<script>
export default {
  data: () => ({ 
    slides: [
      require('@/assets/1-carousel.png'),
      require('@/assets/2-carousel.png'),
      require('@/assets/3-carousel.png')
    ]
  }),
}
</script> 