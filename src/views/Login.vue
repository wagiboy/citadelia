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
          <!-- email input -->
          <v-text-field
            outlined
            label="Username"
            prepend-icon="mdi-account"
            v-model="email"
            @blur="onBlurEmail"
            @focus="resetEmailError"
            :rules="[emailRules]"
            :error="bCredentialsUnconfirmed"
            :error-messages="errMsg.email"
            :append-icon="appendIcon.email"
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
export default {
  name: 'App',
  components: {},
  data() {
    return {
      email: '',
      password: '',
      rememberMe: '',
      bShowPassword: false,
      rulesEnabled: {
        email: false,
        password: false
      },
      errMsg: {
        email: '',
        password: ''
      },      
      appendIcon: {
        email: '',
        password: ''
      },
      bPasswordInvalid: false,
      bCredentialsUnconfirmed: null,
      bLoadingLogin: false,
      bLoadingSignup: false,
    }
  },
  methods: {
    // ----------------------------------
    //     email methods
    // ----------------------------------
    emailRules(value) {
      if (value.length == 0) {
        return true
      }
      if (!this.rulesEnabled.email && value.length < 6) {
        return true
      }
      if (value.length >= 6) {
        this.rulesEnabled.email = true
      }
      if (this.rulesEnabled.email && value.length < 6) {        
        this.appendIcon.email = 'mdi-exclamation'
        return "Your email address is too short."  
      } 
      if (value.length > 64) {      
        this.appendIcon.email = 'mdi-exclamation'
        return "Your email address is too long."
      } 
      if ( /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(value) ) {      
        this.appendIcon.email = 'mdi-check'
      } 
      return true
    },  
    onBlurEmail() {
      if (this.email.length == 0 ) {
        this.rulesEnabled.email = false
        this.appendIcon.email = ''
      }
      else {
        this.validateEmail()
      }
    },
    validateEmail() {
      if (this.email.length == 0 ) {
        this.appendIcon.email = 'mdi-exclamation'
        this.errMsg.email = "Please enter your TutorZ email address."
      }
      else if ( /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(this.email) ) {      
        this.appendIcon.email = 'mdi-check'
        this.errMsg.email = ''
      } 
      else {
        this.appendIcon.email = 'mdi-exclamation'
        this.errMsg.email = "Invalid email address. An email looks like info@tutorz.com"
      }
    },
    resetEmailError() {
      this.errMsg.email = ''
      this.bCredentialsUnconfirmed = false
      this.appendIcon.email = ''
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
        this.appendIcon.password = 'mdi-check'
      }
      if (this.rulesEnabled.password && value.length < 6) {        
        this.appendIcon.password = 'mdi-exclamation'
        return "Your password must be 6 characters or more."  
      } 
      if (this.rulesEnabled.password && value.length > 64) {        
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
        this.errMsg.password = "Please enter your TutorZ password."
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
      this.validateEmail()
      this.validatePassword()
      if (this.errMsg.email == '' && this.errMsg.password == '') {
        this.bLoadingLogin = true;      
        this.confirmCredentials()
      } 
    },
    confirmCredentials() {
      // axios
      //   .post("http://127.0.0.1/api/login/", { email: this.email, password: this.password, rememberMe: this.rememberMe } )
      //   .then(response => {
      //     this.handleConfirmation( response )
      //   })
      //   .catch(error => {
      //     console.log("Axios error in api/login/ " + error) // eslint-disable-line
      //   })       
    },
    handleConfirmation( response ) {
      if( response.data.status == 'success' ) {            
        //console.log("Credentials confirmed. response.data=" + JSON.stringify(response) ) // eslint-disable-line
        window.location = 'http://127.0.0.1/tutor?UD5fxQ=' + response.data.UD5fxQ;     
      } 
      else if( response.data.status == 'error' ) {         
        //console.log("Credentials unconfirmed. " + response.data.errmsg ) // eslint-disable-line
        this.bCredentialsUnconfirmed = true
        this.bShowPassword = true      
        this.bLoadingLogin = false 
        this.errMsg.password  = "Email and/or password didn't match our records. Try again."
        this.appendIcon.email = 'mdi-exclamation'
        this.appendIcon.password = 'mdi-exclamation'
      }
      else {
        // console.log("Error in api/login. --- dumping response ---" + response.data ) // eslint-disable-line
      }
    },
    redirectToSignup() {
      this.bLoadingSignup = true;      
      window.location = '/user'      
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