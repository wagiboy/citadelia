<template>
  <v-app>
    <Navbar v-if="!$route.meta.hideNavbar" />
    <v-main>
      <v-container class="pa-0" fluid>
        <router-view/>
      </v-container>
    </v-main>
    <Footer />
  </v-app>
</template>

<script>
import Navbar from '@/components/Navbar'
import Footer from '@/components/Footer'

export default {
  name: 'App',
  components: { Navbar, Footer },  
  data: () => ({
    //
  }),
  created() {
    console.log('App::created()')
  }
};
</script>
