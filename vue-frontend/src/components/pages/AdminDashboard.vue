<template>
    <div class="bg-gray-100 min-h-screen">
        <!-- right and left sections -->
         <div class="flex flex-col md:flex-row w-full h-screen gap-2">
            <!-- left section -->
             <div class="w-full md:w-[15%] bg-white p-4 fixed top-0 left-0 h-screen shadow-md">
                <!-- buttons -->
                 <div class="space-y-8">

                    <!-- home butons -->
                     <div class="">
                        <router-link to="/admin-dashboard/home" class="bg-blue-500 rounded-md flex text-white items-center gap-2 text-lg p-2 hover:bg-blue-400 w-full">
                            <img src="/logo.png" alt="logo" width="30">
                            <span>Home</span>
                        </router-link>
                     </div>

                     <!-- recruiters -->
                      <div class="">
                        <router-link to="/admin-dashboard/recruiters" class="bg-blue-500 rounded-md flex text-white items-center gap-2 text-lg p-2 hover:bg-blue-400 w-full">
                            <img src="/recruiter.png" alt="recruiter" width="30">
                            <span>Recruiters</span>
                        </router-link>
                      </div>

                      <!-- candidates -->
                       <div class="">
                        <router-link to="/admin-dashboard/candidates" class="bg-blue-500 rounded-md flex text-white items-center gap-2 text-lg p-2 hover:bg-blue-400 w-full">
                            <img src="/candidate.png" alt="candidate" width="30">
                            <span>Candidates</span>
                        </router-link>
                       </div>

                       <!-- jobs -->
                        <div class="">
                            <router-link to="/admin-dashboard/jobs" class="bg-blue-500 rounded-md flex text-white items-center gap-2 text-lg p-2 hover:bg-blue-400 w-full">
                                <img src="/jobs.png" alt="jobs" width="30">
                                <span>Jobs</span>
                            </router-link>
                        </div>

                        <!-- applications -->
                         <div class="">
                            <router-link to="/admin-dashboard/applications" class="bg-blue-500 rounded-md flex text-white items-center gap-2 text-lg p-2 hover:bg-blue-400 w-full">
                                <img src="/application.png" alt="application" width="30">
                                <span>Applications</span>
                            </router-link>
                         </div>

                         <!-- reports -->
                          <div class="">
                            <router-link to="/admin-dashboard/reports" class="bg-blue-500 rounded-md flex text-white items-center gap-2 text-lg p-2 hover:bg-blue-400 w-full">
                                <img src="/report.png" alt="report" width="30">
                                <span>Reports</span>
                            </router-link>
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
              <div class="w-full md:w-[85%] p-2 md:ml-[15%] md:mt-20">
                <!-- search bar and body -->
                 <div class="">
                    <!-- search bar -->
                     <div class="fixed top-0 right-0 z-50 md:w-[85%]">
                        <!-- search and user info -->
                         <div class="flex items-center justify-between bg-white p-4 rounded-md shadow-md">

                            <!-- recruiters -->
                            <div class="flex flex-col items-center bg-blue-50 px-4 py-2 rounded-lg">
                                <h3 class="text-sm font-semibold text-gray-600">Recruiters</h3>
                                <p class="text-xl font-bold text-blue-600">{{recruiters.length}}</p>
                            </div>

                            <!-- candidates -->
                            <div class="flex flex-col items-center bg-green-50 px-4 py-2 rounded-lg">
                                <h3 class="text-sm font-semibold text-gray-600">Candidates</h3>
                                <p class=" text-xl font-bold text-green-600">{{ candidates.length }}</p>
                            </div>

                            <!-- jobs -->
                            <div class="flex flex-col items-center bg-purple-50 px-4 py-2 rounded-lg">
                                <h3 class="text-sm font-semibold text-gray-600">Jobs</h3>
                                <span class="text-xl font-bold text-purple-600">3</span>
                            </div>

                            <!-- applications -->
                             <div class="flex flex-col items-center bg-yellow-50 px-4 py-2 rounded-lg">
                                <h3 class="text-sm font-semibold text-gray-600">Applications</h3>
                                <span class="text-xl font-bold text-yellow-600">9</span>
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
                        <router-view/>
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
            first_name: '',
            last_name: '',
            id: '',
            showInfo: false,

            searchQuery: '',

            errors: {},

            candidates: [],
            recruiters: [],

            jobs: [],
            applications: [],
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

        async fetchApplications() {
            try {
                const response = await api.get('all_applications')
                this.applications = response.data
            } catch (error) {
                if (error.response && error.response.data && error.response.data.errors) {
                    this.errors = error.response.data.errors
                } else {
                    this.errors.general = "Something went wrong!"
                }
            }
        },

        async fetchJobs() {
            try {
                const response = await api.get('all_jobs')
                this.jobs = response.data
            } catch (error) {
                if (error.response && error.response.data && error.response.data.errors) {
                    this.errors = error.response.data.errors
                } else {
                    this.errors.general = "Something went wrong!"
                }
            }
        }

    },

    mounted() {

        this.fetchApplications();
        this.fetchJobs();

        this.fetchRecruiters();
        this.fetchCandidates();

        this.flag = localStorage.getItem('flag');
        this.email = localStorage.getItem('email');
        this.phone = localStorage.getItem('phone');
        this.id = localStorage.getItem('id')
    },

    computed: {

        filteredRecruiters(){
            return this.recruiters.filter(recruiter => 
                recruiter.email.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
                recruiter.first_name.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
                recruiter.last_name.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
                recruiter.company.toLowerCase().includes(this.searchQuery.toLowerCase())
            )
        },

        formattedPhone() {
            if (this.phone && this.phone.startsWith("254")) {
                return this.phone.replace(/^254/, "0")
            }
        }
    }
}
</script>
