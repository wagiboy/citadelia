<template>
  <div>      
    <CitadeliaBanner />
    
    <!-- projects -->  
    <v-sheet class="text-center mt-10">
      <v-icon class="bluegrey--text" x-large>mdi-hammer-wrench</v-icon>
      <p class="text-h4 bluegrey--text font-weight-regular">List of Projects</p> 
      <p class="text-title bluegrey--text mx-15">This is the list of current projects being constructed in the Gebel City.  If interested, you can fund them.</p>            
    </v-sheet>                                    

    <v-row>
      <v-col cols="12" sm="6" lg="4" v-for="project in projects" :key="project.id">    
        <v-card class="mx-auto my-12" max-width="446">
          <!-- vue loader does not automatically files in custom code, need require -->
          <v-img width="446" :src="require(`@/assets/project-${project.id}.jpg`)"></v-img>

          <v-card-text>
            <p class="text-h5 mb-1">{{ project.title }}</p>
            <p>project #{{ project.id }}<br>
              minimum contribution: {{ project.min }} ether
              <v-tooltip top>
                <template v-slot:activator="{ on }">                  
                  <v-icon  v-on="on" style="margin-top:-0.2em" small>mdi-help-circle-outline</v-icon>
                </template>  
                <span>The minimum amount of ether to be contributed to become a project sponsor.</span>    
              </v-tooltip> 
            </p>

            <v-divider class="my-4"></v-divider>
            <p class="text-subtitle-1">{{ project.description }}</p>
      
            <v-btn 
              color="primary"          
              small
              class="text-capitalize" 
              @click="gotoProject(project.id)"
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
import CitadeliaBanner from '@/components/CitadeliaBanner'
export default {
  components: { CitadeliaBanner },  
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
    }]
  }),
  methods: {
    gotoProject(pid) {
      console.log('pid='+pid)
      window.location = '/project/' + pid
    }
  }
}
</script> 