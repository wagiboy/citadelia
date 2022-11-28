<template>
  <div>
    <!-- shrink space above the login card -->
    <div class="spacer-md hidden-xs-only"></div>
    <div class="spacer-md hidden-sm-and-down"></div>
    <div class="spacer-md hidden-md-and-down"></div>
    <div class="spacer-md hidden-lg-and-down"></div>

    <!-- card is centered and has an inside padding     -->
    <v-card class="pa-2 pb-9 mx-auto" max-width="500">
      <!-- close button is small to move better top-right -->
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn icon small to="/">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </v-card-actions>

      <!-- card title consist only of the logo -->
      <v-card-title class="pt-0 mb-2 ">
        <v-row>
          <v-col cols="6" class="text-right pr-2">
            <img src="@/assets/logo.png"/>
          </v-col>
          <v-col cols="6" align-self="center" class="mb-2 pl-0 headline blue-grey--text" >   
            citadelia
          </v-col>
        </v-row>
      </v-card-title>

      <v-card-text>
        <v-form>
          <!-- username input -->
          <v-text-field
            outlined
            label="Username"
            prepend-icon="mdi-account"
            v-model="username"
            @blur="onBlurUsername"
            @focus="resetUsernameError"
            :rules="[usernameRules]"
            :error="bCredentialsUnconfirmed"
            :error-messages="errMsg.username"
            :append-icon="appendIcon.username"
          />

          <!-- password input -->
          <v-text-field
            outlined
            label="Password"
            class="mb-0"
            :type="bShowPassword ? 'text' : 'password'"
            prepend-icon="mdi-lock"
            v-model="password"
            @blur="onBlurPassword"
            @focus="resetPasswordError"
            :rules="[passwordRules]"
            :error="bCredentialsUnconfirmed"
            :error-messages="errMsg.password"
            :append-icon="appendIcon.password"
            @click:append="appendIconPasswordClick"
          />

          <div class="indent-more">
            <!-- Sign-in button in primary color with loading spinner  -->
            <v-btn
              x-large
              block
              color="primary"
              @click="submit"          
              :loading="bLoadingLogin"
              >Sign in</v-btn
            >
          </div>
        </v-form>
      </v-card-text>
    </v-card>
  </div>
</template>

<script>
import store from '@/utils/store.js'
export default {
  name: 'Login',
  components: {},
  data() {
    return {
      username: '',
      password: '',    
      bShowPassword: false,
      rulesEnabled: {
        username: false,
        password: false
      },
      errMsg: {
        username: '',
        password: ''
      },      
      appendIcon: {
        username: '',
        password: ''
      },
      bPasswordInvalid: false,
      bCredentialsUnconfirmed: null,
      bLoadingLogin: false,
      bLoadingSignup: false,
      credentials: [{ 
        username: 'dirk', 
        password: 'frh5MrKwX7VoXR',
      },{
        username: 'jens', 
        password: 'N7sQ3DO3mVPOkh',
      },{
        username: 'peter', 
        password: 'ppba9JokJxaYqf',
      }
		]      
    }
  },
  methods: {
    // ----------------------------------
    //     username methods
    // ----------------------------------
    usernameRules(value) {
      if (value.length > 10) {      
        this.appendIcon.username = 'mdi-exclamation'
        return "Your username is too long."
      } 
      if (value.length <= 10) {      
        this.resetUsernameError()
      } 
      return true
    },  
    onBlurUsername() {
      if (this.username.length == 0 ) {
        this.rulesEnabled.username = false
        this.appendIcon.username = ''
      }
      else {
        this.validateUsername()
      }
    },
    validateUsername() {
      if (this.username.length == 0 ) {
        this.appendIcon.username = 'mdi-exclamation'
        this.errMsg.username = "Please enter your Citadelia username."
      }
      if (this.username.length < 4) {        
        this.appendIcon.username = 'mdi-exclamation'
         this.errMsg.username = "Your username is too short."  
      } 
      if (this.username.length > 10) {      
        this.appendIcon.username = 'mdi-exclamation'
        this.errMsg.username = "Your username is too long."
      }       
      else {    
        this.appendIcon.username = 'mdi-check'
        this.errMsg.username = ''
      } 
    },
    resetUsernameError() {
      this.errMsg.username = ''
      this.bCredentialsUnconfirmed = false
      this.appendIcon.username = ''
    },  

    // ----------------------------------
    //    password methods 
    // ----------------------------------
    passwordRules(value) {
      if (value.length == 0) {
        return true
      }
      if (!this.rulesEnabled.password && value.length < 6) {
        return true
      }
      if (value.length >= 6) {
        this.rulesEnabled.password = true
        this.appendIcon.password = this.eyeIcon
      }
      if (this.rulesEnabled.password && value.length < 6) {        
        this.appendIcon.password = 'mdi-exclamation'
        return "Your password must be 6 characters or more."  
      } 
      if (this.rulesEnabled.password && value.length > 20) {        
        this.appendIcon.password = 'mdi-exclamation'
        return "Your password is too long."
      } 
      return true
    },  
    onBlurPassword() {
      if (this.password.length == 0 ) {
        this.appendIcon.password = this.eyeIcon
      }
      else {
        this.validatePassword()
      }
    },    
    validatePassword() {
      if (this.password.length == 0 ) {
        this.appendIcon.password = 'mdi-exclamation'
        this.errMsg.password = "Please enter your Citadelia password."
      }
      else if (this.password.length < 6 ) {
        this.appendIcon.password = 'mdi-exclamation'
        this.errMsg.password = "Your password must be at least 6 characters."
      }
      else {
        this.appendIcon.password = 'mdi-check'
        this.errMsg.password = ''
      }
    },      
    resetPasswordError() {
      this.errMsg.password = ''
      this.appendIcon.password = this.eyeIcon
      this.rulesEnabled.password = false
    }, 
    appendIconPasswordClick() {
      this.bShowPassword = !this.bShowPassword
      if( this.appendIcon.password != 'mdi-exclamation' ) {
        this.appendIcon.password = this.eyeIcon
      }
    },

    // ----------------------------------
    //    submit methods 
    // ----------------------------------
    submit() {
      console.log('submit() username=')
      this.validateUsername()
      this.validatePassword()
      if (this.errMsg.username == '' && this.errMsg.password == '') {
        console.log('no login error')
        this.bLoadingLogin = true;      
        if (this.areCredentialsValid()) {
          console.log("Credentials match. username='"+this.username+"' password='"+this.password+"'") // eslint-disable-line
          this.logUserIn()
        } 
        else {
          console.log("Credentials unconfirmed. username='"+this.username+"' password='"+this.password+"'") // eslint-disable-line
          this.bCredentialsUnconfirmed = true
          this.bShowPassword = true      
          this.bLoadingLogin = false 
          this.errMsg.password = "Username and/or password didn't match our records. Try again."
          this.appendIcon.username = 'mdi-exclamation'
          this.appendIcon.password = 'mdi-exclamation'
        }
      } else {
        console.log('login failure')
      }
    },
    areCredentialsValid() {
      console.log('areCredentialsValid()')
      var valid = false
      this.credentials.every(credential => {
        console.log("user provided username='"+this.username+"' password='"+this.password+"'")
        console.log("on record username='"+credential.username+"' password='"+credential.password+"'")

        if (this.username === credential.username && this.password === credential.password) {
          console.log("username and password are correct")
          valid = true
          return false // returning false ends the iteration
        }

        // need to return true from the callback function to continue iteration
        return true
      });
      return valid;
    },
    logUserIn() {  
      store.isUserLoggedIn = true
      this.$router.push('/myaccount');  
      this.$cookies.set('login', true);      
    }
  },
  computed: {
    eyeIcon() {
      if( this.bShowPassword ) {
        return 'mdi-eye'
      }
      else {
        return 'mdi-eye-off'
      }
    },
  } 
};
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