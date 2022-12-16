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
				<v-btn text class="text-capitalize" v-for="link in links" :key="link.title" :to="link.route" v-show="showLink(link.title)">
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
import store from '@/utils/store.js'
export default {
  name: 'Navbar',
  components: { },  
  data: () => ({
		drawer: false,
		links: [
			{ title: 'Home', route: '/', icon: 'home' },
			{ title: 'Vendors', route: '/vendor',  icon: 'cart' },
			{ title: 'Projects', route: '/project',  icon: 'hammer-wrench' },
			{ title: 'About', route: '/about',  icon: 'city-variant' },
			{ title: 'MyAccount', route: '/myaccount',  icon: 'account' },
			{ title: 'Login', route: '/login',  icon: 'login' },
			{ title: 'Logout', route: '/logout',  icon: 'logout' }
		]
	}),
	created() {
		store.isUserLoggedIn = this.$cookies.get('login')
	},
 	methods: {
		toggleDrawer() {
			this.drawer = !this.drawer
		},
		showLink(title) {
			switch(title) {
				case 'MyAccount':					
					if (!store.isUserLoggedIn) return false;
					break;

				case 'Login':
					if (store.isUserLoggedIn) return false;
					break;

				case 'Logout':
					if (!store.isUserLoggedIn) return false;
					break;

				default: // e.g. Home
					return true;
			}
			return true;
		}
	}
}
</script>