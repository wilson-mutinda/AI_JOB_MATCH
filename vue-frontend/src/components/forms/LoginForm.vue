<template>
    <div class="bg-gray-100 min-h-screen flex items-center justify-center">
        <!-- login form -->
         <div class="bg-white rounded-md p-6 shadow-md w-full max-w-md relative">
            <form @submit.prevent="userLogin" action="" method="post">

                <!-- close buton -->
                 <button @click="closeForm" class="absolute right-4 top-4">
                    <img src="/close.png" alt="close" width="20">
                 </button>
                <h3 class="text-2xl text-center mb-2">Login Form</h3>

                <!-- general error -->
                 <span v-if="errors.general" class="text-red-600 text-sm text-center">{{ errors.general }}</span>

                <!-- email label -->
                 <div class="">
                    <label class="block text-xl text-gray-600 mb-2" for="email">Email</label>
                    <input
                     @input="clearError('email')" 
                     v-model="email" 
                     class="w-full p-2 rounded-md mb-2 outline-none ring-1 ring-gray-600 hover:ring-blue-600" 
                     placeholder="email@gmail.com" 
                     type="email" 
                     name="email" 
                     id="email">
                 </div>

                 <!-- email errros -->
                  <span v-if="errors.email" class="text-red-600 text-sm text-center">{{ errors.email }}</span>

                 <!-- pasword input -->
                  <div class="relative">
                    <label class="block text-xl text-gray-600 mb-2" for="password">Password</label>
                    <input
                     @input="clearError('password')" 
                     v-model="password" 
                     class="w-full p-2 rounded-md mb-2 outline-none ring-1 ring-gray-600 hover:ring-blue-600" 
                     placeholder="mypassword" 
                     :type="showPassword ? 'text' : 'password'" 
                     name="password" 
                     id="password">

                     <!-- hide and show buttons -->
                    <button @click="togglePassword" type="button" class="absolute right-4 bottom-3">
                        <img :src="showPassword ? '/show.png' : '/hide.png'" alt="hide" width="30">
                    </button>
                  </div>

                  <!-- password error -->
                   <span v-if="errors.password" class="text-red-600 text-sm text-center">{{ errors.password }}</span>

                   <!-- forgot password -->
                    <a class="text-blue-600 flex items-center justify-end mt-2 mb-2" href="#">Forgot Password?</a>

                  <!-- login button -->
                   <button type="submit" class="w-full mb-2 rounded-md bg-blue-600 p-2 text-white text-xl">Login</button>

                   <!-- OR separator -->
                    <div class="flex items-center mt-4 mb-4">
                        <div class="bg-gray-300 h-px flex-grow"></div>
                        <span class="px-3 text-gray-600">OR</span>
                        <div class="bg-gray-300 h-px flex-grow"></div>
                    </div>

                   <!-- google button -->
                    <button @click="googleLogin" type="button" class="flex gap-2 justify-center items-center w-full bg-gray-600 rounded-md p-2 mb-2 text-white text-xl mt-2">
                        <img src="/google.png" alt="logo" width="20">
                        <span>Login with Google</span>
                    </button>

                    <!-- create account -->
                     <div class="flex items-center justify-center mt-4">
                        <span>New here? <a class="text-green-400 font-bold" href="#">Create an account</a></span>
                     </div>
            </form>
         </div>
    </div>
</template>

<script>
import router from '@/router';
import api from '@/services/api';

export default {
    data() {
        return {
            email: '',
            password: '',

            errors: {},

            showPassword: false
        }
    },

    methods: {

        googleLogin(){
            const client = google.accounts.oauth2.initTokenClient({
                client_id: "979587310022-saad40rantvv4227jgast63d8bitcqad.apps.googleusercontent.com",
                scope: "email profile",
                callback: async (response) => {
                    try {
                        const payload = { token: response.access_token };
                        const res = await api.post("google_login", payload);
    
                        console.log("Google Login Successful: ", res.data);
                        router.push('/');
                    } catch (error) {
                        console.error("Google login error", error);
                        this.errors.general = "Google login failed. Try again.";
                    }
                }
            });

            // open Google popup when button is clicked
            client.requestAccessToken();
        },

        clearError(field) {
            if (this.errors[field]) {
                this.errors[field] = ''
            }
        },

        togglePassword() {
            this.showPassword = !this.showPassword
        },

        closeForm(){
            router.push('/')
        },

        clearLoginForm(){
            this.email = '';
            this.password = ''
        },

        async userLogin() {
            this.errors = {};

            try {
                const payload = {
                    email: this.email,
                    password: this.password
                };
    
                const response = await api.post('user_login', payload);
                
                const flag = response.data.flag.toLowerCase()
                const email = response.data.email
                const id = response.data.id
                const phone = response.data.phone

                const access_token = response.data.access_token
                const refresh_token = response.data.refresh_token

                const first_name = response.data.first_name
                const last_name = response.data.last_name
                const username = response.data.username
                const company = response.data.company
                const date_of_birth = response.data.date_of_birth

                localStorage.setItem("flag", flag)
                localStorage.setItem("email", email)
                localStorage.setItem("id", id)
                localStorage.setItem("phone", phone)

                localStorage.setItem("access_token", access_token)
                localStorage.setItem("refresh_token", refresh_token)

                if (first_name) {
                    localStorage.setItem("first_name", first_name)
                }

                if (last_name) {
                    localStorage.setItem("last_name", last_name)
                }

                if (username) {
                    localStorage.setItem("username", username)
                }

                if (company) {
                    localStorage.setItem("company", company)
                }

                if (date_of_birth) {
                    localStorage.setItem("date_of_birth", date_of_birth)
                }

                if (flag == 'admin') {
                    console.log("Flag:", flag)
                    console.log("Redirecting to:", `/${flag}-dashboard`)
                    router.push(`/${flag}-dashboard`)
                } else if (flag == 'recruiter') {
                    router.push(`/${flag}-dashboard`)
                } else {
                    router.push(`/${flag}-dashboard`)
                }

                console.log("Login Successful!");

                this.clearLoginForm();
                this.errors = {};

            } catch (error) {
                if (error.response && error.response.data && error.response.data.errors) {
                    this.errors = error.response.data.errors
                } else {
                    this.errors.general = "Something went wrong!"
                }
            }
        },
    }
}
</script>
