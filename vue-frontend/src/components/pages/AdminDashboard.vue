<template>
    <div class="bg-gray-100 min-h-screen">
        <!-- right and left sections -->
         <div class="flex flex-col md:flex-row w-full h-screen gap-2">
            <!-- left section -->
             <div class="md:w-[15%] bg-white p-4">
                <!-- buttons -->
                 <div class="space-y-8">

                    <!-- home butons -->
                     <div class="">
                        <button type="button" class="bg-blue-500 rounded-md flex text-white items-center gap-2 text-lg p-2 hover:bg-blue-400 w-full">
                            <img src="/logo.png" alt="logo" width="30">
                            <span>Home</span>
                        </button>
                     </div>

                     <!-- recruiters -->
                      <div class="">
                        <button type="button" class="bg-blue-500 rounded-md flex text-white items-center gap-2 text-lg p-2 hover:bg-blue-400 w-full">
                            <img src="/recruiter.png" alt="recruiter" width="30">
                            <span>Recruiters</span>
                        </button>
                      </div>

                      <!-- candidates -->
                       <div class="">
                        <button type="button" class="bg-blue-500 rounded-md flex text-white items-center gap-2 text-lg p-2 hover:bg-blue-400 w-full">
                            <img src="/candidate.png" alt="candidate" width="30">
                            <span>Candidates</span>
                        </button>
                       </div>

                     <!-- logout button -->
                      <div class="">
                        <button @click="logoutButton" type="button" class="bg-blue-500 rounded-md flex text-white items-center gap-2 text-lg p-2 hover:bg-blue-400 w-full">
                            <img src="/logout.png" alt="logout" width="30">
                            <span>Logout</span>
                        </button>
                      </div>
                 </div>
             </div>
             <!-- right section -->
              <div class="md:w-[85%] p-2">
                <!-- search bar and body -->
                 <div class="">
                    <!-- search bar -->
                     <div class="">
                        <!-- search and user info -->
                         <div class="flex items-center justify-between bg-white p-4 rounded-md shadow-md">
                            <!-- search bar -->
                             <div class="flex rounded-md gap-2 ring-1 p-2 ring-gray-600 hover:ring-blue-600">
                                <img src="/search.png" alt="search" width="30">
                                <input class="bg-transparent outline-none" type="text" name="search" id="search">
                             </div>
                             <!-- user info -->
                              <div class="flex items-center gap-4 relative">
                                <!-- avatar -->
                                 <div class="text-center">
                                    <img src="/user.png" alt="avatar" width="50">
                                    <span class="font-semibold text-gray-600">{{flag.charAt(0).toUpperCase() + flag.slice(1)}}</span>
                                 </div>
                                 <button @click="toggleInfo" type="button">
                                    <img :src="showInfo ? '/arrow-up.png' : '/arrow-down.png'" alt="arrow-up" width="20"></img>
                                 </button>

                                 <!-- info -->
                                  <div v-if="showInfo" class="absolute top-16 right-0 bg-white p-4 rounded-xl shadow-lg border border-gray-200 animate-fade-in">
                                    <!-- user details -->
                                     <div class="space-y-2 text-sm text-gray-600">
                                        <p class="flex justify-between">
                                            <span class="font-semibold text-gray-800">Email:</span>
                                            <span class="truncate">{{ email }}</span>
                                        </p>
                                        <p class="flex justify-between">
                                            <span class="font-semibold text-gray-800">Phone:</span>
                                            <span class="">{{ formattedPhone }}</span>
                                        </p>
                                     </div>
                                     <!-- divider -->
                                      <div class="border-t my-3"></div>

                                      <!-- logout button -->
                                       <button @click="logoutButton" class="w-full bg-red-500 text-white text-sm font-medium px-4 py-2 rounded-lg hover:bg-red-600 transition duration-200">
                                        Logout
                                       </button>
                                  </div>
                              </div>
                         </div>
                     </div>
                     <!-- body -->
                      <div class="mt-4">
                        <!-- recruiters and candidates -->
                        <div class="flex items-center gap-4">
                            <!-- recruiters -->
                             <div class="bg-white w-full md:w-1/2 rounded-md p-2">
                                <h3>Active Recruiters</h3>
                                <table class="w-full border-collapse">
                                    <thead>
                                        <tr>
                                            <th class="border p-2">#</th>
                                            <th class="border p-2">Email</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr v-for="(recruiter, index) in recruiters" :key="index">
                                            <td class="border p-2">{{ index + 1 }}</td>
                                            <td class="border p-2">{{ recruiter.email }}</td>
                                        </tr>
                                    </tbody>
                                </table>
                             </div>
                             <!-- candidates -->
                              <div class="bg-white w-full md:w-1/2 p-2">
                                <h3>Active Candidates</h3>
                                <table class="w-full border-collapse">
                                    <thead>
                                        <tr>
                                            <th class="border p-2">#</th>
                                            <th class="border p-2">Email</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr v-for="(candidate, index) in candidates" :key="index">
                                            <td class="border p-2">{{ index + 1 }}</td>
                                            <td class="border p-2">{{ candidate.email }}</td>
                                        </tr>
                                    </tbody>
                                </table>
                              </div>
                        </div>
                      </div>
                 </div>
              </div>
         </div>
    </div>
</template>

<script>
import router from '@/router';
import api from '@/services/api';

export default {
    data() {
        return {
            flag: '',
            email: '',
            phone: '',
            id: '',
            showInfo: false,

            errors: {},

            candidates: [],
            recruiters: [],
        }
    },

    methods: {
        logoutButton() {
            localStorage.removeItem('access_token');
            localStorage.removeItem('refresh_token');
            router.push('/login')
        },

        toggleInfo() {
            this.showInfo = !this.showInfo
        },

        async fetchCandidates() {
            try {
                const response = await api.get('all_candidates')
                this.candidates = response.data
            } catch (error) {
                if (error.response && error.response.data && error.response.data.errors) {
                    this.errors = error.response.data.errors
                } else{
                    this.errors.general = "Something went wrong!"
                }
            }
        },

        async fetchRecruiters() {
            try {
                const response = await api.get('all_recruiters')
                this.recruiters = response.data
            } catch (error) {
                if (error.response && error.response.data && error.response.data.errors) {
                    this.errors = error.response.data.errors
                } else {
                    this.errors.general = "Something went wrong!"
                }
            }
        },

    },

    mounted() {

        this.fetchRecruiters();
        this.fetchCandidates();

        this.flag = localStorage.getItem('flag');
        this.email = localStorage.getItem('email');
        this.phone = localStorage.getItem('phone');
        this.id = localStorage.getItem('id')
    },

    computed: {
        formattedPhone() {
            if (this.phone && this.phone.startsWith("254")) {
                return this.phone.replace(/^254/, "0")
            }
        }
    }
}
</script>
