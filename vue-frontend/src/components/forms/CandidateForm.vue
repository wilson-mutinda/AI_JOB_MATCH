<template>
    <div class="bg-gray-100 min-h-screen flex items-center justify-center">
        <!-- candidate-form -->
         <div class="bg-white p-4 rounded-md shadow-md w-full max-w-lg relative">
            <form @submit.prevent="createCandidate" action="" method="post">

                <!-- close button -->
                 <button @click="closeButton" class="absolute right-4 top-3">
                    <img src="/close.png" alt="close" width="20">
                 </button>
                <h3 class="text-2xl text-center mb-2">Create Candidate</h3>

                <!-- general error -->
                 <span v-if="errors.general" class="text-red-600 text-sm text-center">{{ errors.general }}</span>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-2">
                    <!-- first name -->
                    <div class="">
                        <label class="block text-xl text-gray-600 mb-2" for="first_name">First name</label>
                        <input @input="clearError('first_name')" v-model="first_name" class="rounded-md p-2 w-full outline-none ring-1 ring-gray-600 hover:ring-blue-600 mb-2" type="text" name="first_name" id="first_name">

                        <!-- first_name error -->
                        <span v-if="errors.first_name" class="text-red-600 text-sm">{{ errors.first_name }}</span>

                    </div>

                    <!-- last name -->
                    <div class="">
                        <label class="block text-xl text-gray-600 mb-2" for="last_name">Last name</label>
                        <input @input="clearError('last_name')" v-model="last_name" class="rounded-md p-2 w-full outline-none ring-1 ring-gray-600 hover:ring-blue-600 mb-2" type="text" name="last_name" id="last_name">

                        <!-- last_name error -->
                        <span v-if="errors.last_name" class="text-red-600 text-sm">{{ errors.last_name }}</span>

                    </div>

                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-2">
                    <!-- email -->
                    <div class="">
                        <label class="block text-xl text-gray-600 mb-2" for="email">Email</label>
                        <input @input="clearError('email')" v-model="email" class="rounded-md p-2 w-full outline-none ring-1 ring-gray-600 hover:ring-blue-600 mb-2" type="email" name="email" id="email">

                        <!-- email error -->
                        <span v-if="errors.email" class="text-red-600 text-sm">{{ errors.email }}</span>

                    </div>

                    <!-- phone -->
                    <div class="">
                        <label class="block text-xl text-gray-600 mb-2" for="phone">Phone</label>
                        <input @input="clearError('phone')" v-model="phone" class="rounded-md p-2 w-full outline-none ring-1 ring-gray-600 hover:ring-blue-600 mb-2" type="tel" name="phone" id="phone">

                        <!-- phone error -->
                        <span v-if="errors.phone" class="text-red-600 text-sm">{{ errors.phone }}</span>

                    </div>

                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-2">
                    <!-- username -->
                    <div class="">
                        <label class="block text-xl text-gray-600 mb-2" for="username">Username</label>
                        <input @input="clearError('username')" v-model="username" class="rounded-md p-2 w-full outline-none ring-1 ring-gray-600 hover:ring-blue-600 mb-2" type="text" name="username" id="username">

                        <!-- username error -->
                        <span v-if="errors.username" class="text-red-600 text-sm">{{ errors.username }}</span>

                    </div>

                    <!-- dob -->
                    <div class="">
                        <label class="block text-xl text-gray-600 mb-2" for="date_of_birth">Date of Birth</label>
                        <input @input="clearError('date_of_birth')" v-model="date_of_birth" class="rounded-md p-2 w-full outline-none ring-1 ring-gray-600 hover:ring-blue-600 mb-2" type="date" name="date_of_birth" id="date_of_birth">

                        <!-- date_of_birth error -->
                        <span v-if="errors.date_of_birth" class="text-red-600 text-sm">{{ errors.date_of_birth }}</span>

                    </div>

                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-2">
                    <!-- password -->
                    <div class="relative">
                        <label class="block text-xl text-gray-600 mb-2" for="password">Password</label>
                        <input
                         @input="clearError('password')" 
                         v-model="password" 
                         class="rounded-md p-2 w-full outline-none ring-1 ring-gray-600 hover:ring-blue-600 mb-2" 
                         :type="showPassword ? 'text' : 'password'" 
                         name="password" 
                         id="password">

                        <!-- hide and show button -->
                         <button @click="togglePassword" type="button" class="absolute left-48 top-10">
                            <img :src="showPassword ? '/show.png' : '/hide.png'" alt="show" width="30">
                         </button>

                        <!-- password error -->
                        <span v-if="errors.password" class="text-red-600 text-sm">{{ errors.password }}</span>

                    </div>

                    <!-- password_confiramtion -->
                    <div class="relative">
                        <label class="block text-xl text-gray-600 mb-2" for="password_confiramtion">Password Confirmation</label>
                        <input
                         @input="clearError('password_confirmation')" 
                         v-model="password_confirmation" 
                         class="rounded-md p-2 w-full outline-none ring-1 ring-gray-600 hover:ring-blue-600 mb-2" 
                         :type="showPassword ? 'text' : 'password'" 
                         name="password" 
                         id="password">

                        <!-- hide and show buton -->
                         <button @click="togglePassword" type="button" class="absolute right-4 top-10">
                            <img :src="showPassword ? '/show.png' : '/hide.png'" alt="show" width="30">
                         </button>

                        <!-- password confiramtion erros -->
                        <span v-if="errors.password_confirmation" class="text-red-600 text-sm">{{ errors.password_confirmation }}</span>

                    </div>
                </div>

                <!-- create button -->
                <div class="">
                    <button type="submit" class="w-full mt-2 mb-2 bg-blue-600 rounded-md p-2 text-white text-xl">Create</button>
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
            date_of_birth: '',
            password: '',
            password_confirmation: '',

            errors: {},

            showPassword: false,
        }
    },

    methods: {

        togglePassword(){
            this.showPassword = !this.showPassword
        },

        closeButton(){
            router.push('/')
        },

        clearError(field){
            if (this.errors[field]) {
                this.errors = ''
            }
        },

        clearForm(){
            this.first_name = '',
            this.last_name = '',
            this.email = '',
            this.phone = '',
            this.username = '',
            this.date_of_birth = '',
            this.password = '',
            this.password_confirmation = ''
        },
        
        async createCandidate() {

            this.errors = {}
            try {
                const payload = {
                    user: {
                        email: this.email,
                        phone: this.phone,
                        password: this.password,
                        password_confirmation: this.password_confirmation
                    },
                    candidate: {
                        first_name: this.first_name,
                        last_name: this.last_name,
                        username: this.username,
                        date_of_birth: this.date_of_birth
                    }
                };
    
                const response = await api.post('create_candidate', payload);
                console.log("Login successful!")

                this.errors = {};

                this.clearForm();

            } catch (error) {
                if (error.response && error.response.data && error.response.data.errors) {
                    this.errors = error.response.data.errors
                } else {
                    this.errors.general = "Something went wrong! Try again later..."
                }
            }
        }
    }
}
</script>
