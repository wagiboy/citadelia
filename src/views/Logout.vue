<template> 
  <div>
    <!-- shrink space above -->
    <div class="spacer-md hidden-xs-only"></div>
    <div class="spacer-md hidden-sm-and-down"></div>
    <div class="spacer-md hidden-md-and-down"></div>
    <div class="spacer-md hidden-lg-and-down"></div>

    <p class="title blue-grey--text text-center">You have succefully logged out of your account.</p> 
    <p class="text-center"><v-icon class="blue-grey--text" large>mdi-clover</v-icon></p>
    <p class="title text-center"><a class="blue-grey--text" href="/login">Log back</a> into your acount.</p>  
  </div>
</template>

<script>
import store from '@/utils/store.js'
export default {
  name: 'Logout',
  created() {
      // storing logout globally communicates logout to navbar's list
      store.isUserLoggedIn = false

      // storing lougout in cookie communictes logout to next session
      this.$cookies.remove('login'); 
    }
  }
</script>

<style scoped>
.spacer-sm {
  height: 1em;
}
.spacer-md {
  height: 1.5em;
}
.indent {
  margin-left: 1.9em;
}
.indent-more {
  margin-left: 2.3em;
}
</style>
