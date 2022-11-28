import Vue from 'vue'

/**
 * global eventBus
 * Communicate events across components
 * (as to vertically between parent and child components)
 * Besides not being limited to vertical communication,
 * the eventBus allows the passing of data together with the event.
 * This eventBus feature only exists at the VUE CLI 2, no longer with CLI 3
 */

 /** 
  * For named imports use this definition
  */
 //export const eventBus = new Vue();

 /** 
  * For default imports use this definition
  */
 export default new Vue()