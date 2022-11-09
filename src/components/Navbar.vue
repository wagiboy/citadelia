<template>
  <nav>
		<v-app-bar max-height="64" color="white" flat>

			<!-- website logo and name -->
			<v-app-bar-nav-icon @click="toggleDrawer()" width="54" class="blue-grey--text ml-0 hidden-md-and-up"></v-app-bar-nav-icon>
			<div class="hidden-sm-and-down">
				<a href="/">
					<v-img
						alt="Citadelia Logo"					
						src="@/assets/citadelia.gif"
						transition="scale-transition"
						contain
						height="50"
					/>
				</a>
			</div>	
			<a href="/">
				<v-app-bar-title class="">
					<span class="font-weight-bold primary--text">Citadelia</span>
					<span class="font-weight-light blue-grey--text"> - Public Works Funds Managment</span>
				</v-app-bar-title>			
			</a>
			<v-spacer></v-spacer>

			<!-- navigation menu -->
			<v-card flat class="hidden-sm-and-down">
				<v-btn text class="text-capitalize" v-for="link in links" :key="link.title" :to="link.route">
					<v-icon class="blue-grey--text">mdi-{{ link.icon }}</v-icon>
					<span class="blue-grey--text">{{ link.title }}</span>
				</v-btn>
			</v-card>

			<Snackbars/>

		</v-app-bar>

		<!-- navigation drawer -->
		<v-navigation-drawer app v-model="drawer">
			<v-row>
				<v-col cols="2" class="ml-15 mt-1">
					<v-img src="@/assets/hat.gif"	contain height="50" />
				</v-col>
				<v-col cols="2" class="pa-0 mt-6 blue-grey--text title">
					<span class="font-weight-bold">TTZ</span>
					<span class="font-weight-light">Coin</span>
				</v-col>
			</v-row>

			<v-list dense>
				<v-list-item v-for="(link, i) in links" :key="i" router :to="link.route" class="blue-grey--text">
					<v-list-item-icon>
						<v-icon>mdi-{{ link.icon }}</v-icon>
					</v-list-item-icon>						
					<v-list-item-content>
						<v-list-item-title>{{ link.title }}</v-list-item-title>
					</v-list-item-content>
				</v-list-item>
			</v-list>
		</v-navigation-drawer>

	<v-divider></v-divider>
  </nav>
</template>

<script>
import Snackbars from '@/components/Snackbars.vue'
export default {
  name: 'Navbar',
  components: { d },  
  data: () => ({
		drawer: false,
		links: [
			{ title: 'Home', route: '/', icon: 'home' },
			{ title: 'Login', route: '/login',  icon: 'account' }
		]
	}),
 	methods: {
		toggleDrawer() {
			this.drawer = !this.drawer
		}
	}
}
</script>