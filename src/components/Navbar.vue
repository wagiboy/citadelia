<template>
  <nav>
		<v-app-bar max-height="64" color="white" flat>

			<v-app-bar-nav-icon @click="toggleDrawer()" width="54" class="blue-grey--text ml-0 hidden-md-and-up"></v-app-bar-nav-icon>

			<!-- logo -->
			<div>
				<a href="/">
					<v-img
						alt="Citadelia Logo"					
						src="@/assets/logo.png"
						transition="scale-transition"
						contain
						height="45"
						width="40"			
					/>
				</a>
			</div>	

			<!-- brand name -->
			<a href="/" class="hidden-sm-and-down text-decoration-none">
				<p class="title pa-0 ma-0 blue-grey--text font-weight-regular">citadelia</p>
			</a>
			<v-spacer></v-spacer>

			<!-- navigation menu -->
			<v-card flat class="hidden-sm-and-down">
				<v-btn text class="text-capitalize" v-for="link in links" :key="link.title" :to="link.route" v-show="showLink(link)">
					<v-icon class="blue-grey--text">mdi-{{ link.icon }}</v-icon>
					<span class="blue-grey--text">{{ link.title }}</span>
				</v-btn>
			</v-card>

		</v-app-bar>

		<!-- navigation drawer -->
		<v-navigation-drawer app v-model="drawer">
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
export default {
  name: 'Navbar',
  components: { },  
  data: () => ({
		drawer: false,
		links: [
			{ title: 'Home', route: '/', icon: 'home' },
			{ title: 'Login', route: '/login',  icon: 'login' },
			{ title: 'User', route: '/user',  icon: 'account' }
		]
	}),
 	methods: {
		toggleDrawer() {
			this.drawer = !this.drawer
		}
	},
	computed: {
		showLink(link) {
			if (link.title == 'Login') {
				if ($route.meta.hideLogin) return false;
			}
			else if (condition) {
				
			} else {
				
			}
		}
	}
}
</script>