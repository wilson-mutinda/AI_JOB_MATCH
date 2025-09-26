<template>
    <div class="bg-gray-100 min-h-screen flex items-center justify-center">
        <!-- recruiter-form -->
         <div class="bg-white rounded-md p-4 w-full max-w-lg relative">
            <form @submit.prevent="createRecruiter" action="" method="post">

                <!-- close button -->
                 <button @click="closeButton" type="button" class="absolute right-4 top-4">
                    <img src="/close.png" alt="close" width="20">
                 </button>
                <h3 class="text-2xl text-center mb-2">Create Recruiter</h3>

                <!-- general error -->
                 <span v-if="errors.general" class="text-red-600 text-sm text-center">{{ errors.general }}</span>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-2">
                    <!-- first_name -->
                    <div class="">
                        <label class="block mb-2 text-gray-600 text-xl" for="first_name">First name</label>
                        <input 
                         v-model="first_name" 
                         class="w-full rounded-md p-2 outline-none ring-1 ring-gray-600 mb-2 hover:ring-blue-600" 
                         type="text" 
                         name="first_name" 
                         id="first_name"
                         @input="clearError('first_name')">

                         <!-- first_name error -->
                          <span v-if="errors.first_name" class="text-red-600 text-sm">{{ errors.first_name }}</span>

                    </div>

                    <!-- last_name -->
                    <div class="">
                        <label class="block mb-2 text-gray-600 text-xl" for="last_name">Last name</label>
                        <input
                         v-model="last_name" 
                         class="w-full rounded-md p-2 outline-none ring-1 ring-gray-600 mb-2 hover:ring-blue-600" 
                         type="text" 
                         name="last_name" 
                         id="last_name"
                         @input="clearError('last_name')">

                         <!-- last_name error -->
                          <span v-if="errors.last_name" class="text-red-600 text-sm">{{ errors.last_name }}</span>

                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-2">
                    <!-- email -->
                    <div class="">
                        <label class="block mb-2 text-gray-600 text-xl" for="email">Email</label>
                        <input
                         v-model="email" 
                         class="w-full rounded-md p-2 outline-none ring-1 ring-gray-600 mb-2 hover:ring-blue-600" 
                         type="email" 
                         name="email" 
                         id="email"
                         @input="clearError('email')">

                         <!-- email error -->
                          <span v-if="errors.email" class="text-red-600 text-sm">{{ errors.email }}</span>

                    </div>

                    <!-- phone -->
                    <div class="">
                        <label class="block mb-2 text-gray-600 text-xl" for="phone">Phone</label>
                        <input
                         v-model="phone" 
                         class="w-full rounded-md p-2 outline-none ring-1 ring-gray-600 mb-2 hover:ring-blue-600" 
                         type="tel" 
                         name="phone" 
                         id="phone"
                         @input="clearError('phone')">

                         <!-- phone error -->
                          <span v-if="errors.phone" class="text-red-600 text-sm">{{ errors.phone }}</span>

                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-2">
                    <!-- username -->
                    <div class="">
                        <label class="block mb-2 text-gray-600 text-xl" for="username">Username</label>
                        <input
                         v-model="username" 
                         class="w-full rounded-md p-2 outline-none ring-1 ring-gray-600 mb-2 hover:ring-blue-600" 
                         type="text" 
                         name="username" 
                         id="username"
                         @input="clearError('username')">

                         <!-- username error -->
                          <span v-if="errors.username" class="text-red-600 text-sm">{{ errors.username }}</span>

                    </div>

                    <!-- company -->
                    <div class="">
                        <label class="block mb-2 text-gray-600 text-xl" for="company">Company</label>
                        <input
                         v-model="company" 
                         class="w-full rounded-md p-2 outline-none ring-1 ring-gray-600 mb-2 hover:ring-blue-600" 
                         type="text" 
                         name="company" 
                         id="company"
                         @input="clearError('company')">

                         <!-- company error -->
                          <span v-if="errors.company" class="text-red-600 text-sm">{{ errors.company }}</span>

                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-2">
                    <!-- password -->
                    <div class="relative">
                        <label class="block mb-2 text-gray-600 text-xl" for="password">Password</label>
                        <input
                         v-model="password" 
                         class="w-full rounded-md p-2 outline-none ring-1 ring-gray-600 mb-2 hover:ring-blue-600" 
                         :type="showPassword ? 'text' : 'password'" 
                         name="password" 
                         id="password"
                         @input="clearError('password')">

                         <!-- show and hide buttons -->
                          <button @click="togglePassword" type="button" class="absolute right-4 top-10">
                            <img :src="showPassword ? 'show.png' : '/hide.png'" alt="hide" width="30">
                          </button>

                         <!-- password error -->
                          <span v-if="errors.password" class="text-red-600 text-sm">{{ errors.password }}</span>

                    </div>

                    <!-- password_confirmation -->
                    <div class="relative">
                        <label class="block mb-2 text-gray-600 text-xl" for="password_confirmation">Password Confirmation</label>
                        <input
                         v-model="password_confirmation" 
                         class="w-full rounded-md p-2 outline-none ring-1 ring-gray-600 mb-2 hover:ring-blue-600" 
                         :type="showPassword ? 'text' : 'password'" 
                         name="password_confirmation" 
                         id="password_confirmation"
                         @input="clearError('password_confirmation')">

                         <!-- hide and shoe button -->
                          <button @click="togglePassword" type="button" class="absolute right-4 top-10">
                            <img :src="showPassword ? 'show.png' : '/hide.png'" alt="hide" width="30">
                          </button>

                         <!-- password confirmation error -->
                          <span v-if="errors.password_confirmation" class="text-red-600 text-sm">{{ errors.password_confirmation }}</span>
                    </div>
                </div>

                <!-- create button -->
                <div class="">
                    <button type="submit" class="text-white bg-blue-600 rounded-md mt-2 mb-2 w-full p-2 text-xl">Create</button>
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

            first_name: '',
            last_name: '',
            email: '',
            phone: '',
            username: '',
            company: '',
            password: '',
            password_confirmation: '',

            errors: {},

            showPassword: false

        }
    },

    methods: {

        togglePassword() {
            this.showPassword = !this.showPassword
        },

        closeButton() {
            router.push('/')
        },

        clearError(field) {
            if (this.errors[field]) {
                this.errors[field] = ''
            }
        },

        clearForm(){
            this.first_name = '',
            this.last_name = '',
            this.username = '',
            this.company = '',
            this.email = '',
            this.phone = '',
            this.password = '',
            this.password_confirmation = ''
        },

        async createRecruiter() {
            try {
                const payload = {
                    user: {
                        email: this.email,
                        phone: this.phone,
                        password: this.password,
                        password_confirmation: this.password_confirmation
                    },
    
                    recruiter: {
                        first_name: this.first_name,
                        last_name: this.last_name,
                        username: this.username,
                        company: this.company
                    }
                };
    
                const response = await api.post('create_recruiter', payload);
                console.log('Recruiter created successfully')
    
                this.clearForm();
    
                this.errors = {}
            } catch (error) {
                if (error.response && error.response.data && error.response.data.errors) {
                    this.errors = error.response.data.errors
                } else {
                    this.errors.general = "Something went wrong!"
                }
            }
        }
    }
}
</script>
