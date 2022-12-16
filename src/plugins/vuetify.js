import Vue from 'vue';
import Vuetify from 'vuetify/lib/framework';

Vue.use(Vuetify);

export default new Vuetify({
  iconfont: 'md',
  theme: {
    themes: {
      light: {
        primary:  '#AB000B',  // red
        secondary:'#607d8b',  // blue-gray
        success:  '#009933',  // green
        info:     '#F2BE31',  // gold

        gold: '#f6dea6',
        green: '#009933',
        bluegrey: '#607d8b',
        white: '#fff'
      }  
    }
  }
});