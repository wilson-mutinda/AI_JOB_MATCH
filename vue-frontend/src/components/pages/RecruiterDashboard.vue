<template>
    <div class="bg-gray-100 min-h-screen w-full flex gap-2 flex-col md:flex-row">
        <!-- left -->
         <div class="w-full md:w-[15%] bg-white p-2">
            <div class="space-y-4">
                <!-- home -->
             <div class="">
                <button class="flex items-center gap-2 bg-blue-200 w-full rounded-md p-2 mb-2 hover:bg-blue-600 hover:text-white text-xl">
                    <img src="/logo.png" alt="home" width="30">
                    <span>Home</span>
                </button>
             </div>

             <!-- jobs -->
              <div class="">
                <button class="flex items-center gap-2 bg-blue-200 w-full rounded-md p-2 mb-2 hover:bg-blue-600 hover:text-white text-xl">
                    <img src="/job.png" alt="logo" width="30">
                    <span>Jobs</span>
                </button>
              </div>

              <!-- logout button -->
               <div class="">
                <button @click="logoutButton" class="flex items-center gap-2 bg-blue-200 w-full rounded-md p-2 mb-2 hover:bg-blue-600 hover:text-white text-xl">
                    <img src="/logout.png" alt="logout" width="30">
                    <span>Logout</span>
                </button>
               </div>
            </div>
         </div>
         <!-- right -->
          <div class="w-full md:w-[85%] p-2">

            <!-- navbar -->
             <div class="flex items-center justify-between bg-white p-4 mb-2">
                <!-- search bar -->
                 <div class="flex items-center ring-1 ring-gray-600 hover:ring-blue-600 p-2 rounded-md">
                    <img src="/search.png" alt="search" width="30">
                    <input
                     v-model="searchQuery" 
                     class="outline-none p-2 bg-transparent" 
                     placeholder="Search here..." 
                     type="text" 
                     name="" 
                     id="">
                 </div>
                 <!-- user-info -->
                  <div class="flex items-center justify-between gap-2 relative">

                    <!-- image -->
                    <div class="">
                        <img src="/user.png" alt="avatar" width="40"></img>
                        <span class="text-gray-600 text-xl">{{ flag.charAt(0).toUpperCase() + flag.slice(1) }}</span>
                    </div>

                    <!-- info -->
                    <div class="">
                        <button @click="toggleInfo">
                            <img :src="showInfo ? '/arrow-up.png' : '/arrow-down.png'" alt="up" width="20">
                        </button>
                    </div>

                    <div v-if="showInfo" class="absolute bg-white shadow-lg rounded-md p-2 z-50 top-20 right-0 w-60">
                        <ul class="space-y-1">
                            <li>First name: {{ first_name }}</li>
                            <li>Last name: {{ last_name }}</li>
                            <li>Username: {{ username }}</li>
                            <li>Company: {{ company }}</li>
                            <li>Email: {{ email }}</li>
                            <li>Phone: {{ formattedPhone }}</li>
                            <button @click="logoutButton" class="w-full bg-blue-600 rounded-md mt-2 p-1 text-white">Logout</button>
                        </ul>
                    </div>

                  </div>

             </div>

             <!-- body -->
              <div class="">

                <!-- toasts -->
                 <div class="grid md:grid-cols-4 grid-cols-1 mt-4 gap-2">

                    <!-- jobs toast -->
                     <div class="bg-white rounded-md p-2 text-center">
                        <h2 class="text-lg font-bold text-gray-600">My Jobs</h2>
                        <p>Total: {{ jobs.length }}</p>
                     </div>

                     <!-- candidates toast -->
                      <div class="bg-white rounded-md p-2 text-center">
                        <h3 class="text-lg font-bold text-gray-600">My candidates</h3>
                        <p>Total: {{ candidates.length }}</p>
                      </div>
                 </div>

                 <!-- tables -->
                  <div class="flex flex-col md:flex-row gap-4 mt-4">

                    <!-- jobs table -->
                     <div class="w-full md:w-1/2 bg-white shadow rounded-lg p-4">

                        <div class="flex items-center justify-between mb-4">
                            <!-- header with button -->
                            <h2 class="text-lg font-bold text-gray-700">My Jobs</h2>
                            <button @click="showCreateForm = true" class="bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-600">Add Job</button>

                        </div>
                        <table class="w-full text-left border-collapse">
                            <thead>
                                <tr class="bg-gray-100 text-gray-700">
                                    <th class="p-2 border">#</th>
                                    <th class="p-2 border">Title</th>
                                    <th class="p-2 border">Description</th>
                                    <th class="p-2 border">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="(job, index) in filteredJobs" :key="job.id" class="hover:bg-gray-50">
                                    <td class="p-2 border">{{ index + 1 }}.</td>
                                    <td class="p-2 border">{{ job.title }}</td>
                                    <td class="p-2 border" v-html="job.description.replace(/\d+\./g, '<br>$&')"></td>
                                    <td class="p-2 border">
                                        <div class="flex items-center justify-center gap-4">
                                            <button @click="editJob(job)" class="bg-blue-400 rounded-md p-2">
                                                <img src="/edit.png" alt="edit" width="20">
                                            </button>
                                            <button @click="deleteJob(job)" class="bg-red-400 rounded-md p-2">
                                                <img src="/delete.png" alt="delete" width="20">
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <tr v-if="filteredJobs.length === 0">
                                    <td colspan="4" class="text-center p-4 text-gray-500">
                                        No Jobs Found.
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                     </div>

                     <!-- candidates table -->
                      <div class="w-full md:w-1/2 bg-white shadow rounded-lg p-4">
                        <h3 class="text-lg font-bold text-gray-700 mb-4">My Candidates</h3>
                        <table class="w-full text-left border-collapse">
                            <thead>
                                <tr class="bg-gray-100 text-gray-700">
                                    <th class="p-2 border">#</th>
                                    <th class="p-2 border">Username</th>
                                    <th class="p-2 border">Email</th>
                                    <th class="p-2 border">Phone</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="(candidate, index) in candidates" :key="candidate.id" class="hover:bg-gray-50">
                                    <td class="p-2 border">{{ index + 1 }}.</td>
                                    <td class="p-2 border">{{ candidate.candidate_username }}</td>
                                    <td class="p-2 border">{{ candidate.candidate_email }}</td>
                                    <td class="p-2 border">{{ candidate.candidate_phone }}</td>
                                </tr>
                            </tbody>
                        </table>
                      </div>
                  </div>
              </div>
          </div>
    </div>

    <div v-if="showCreateForm" class="bg-black bg-opacity-50 fixed inset-0 flex items-center justify-center z-50">
        <div class="bg-white p-4 rounded-md shadow-md w-full max-w-lg relative">
            <!-- recruiter form -->
            <form @submit.prevent="createJob" action="" method="post">

                <!-- general error -->
                 <span v-if="errors.general" class="text-red-600 text-sm text-center">{{ errors.general }}</span>

                 <!-- close button -->
                  <button @click="closeButton" class="absolute right-4 top-4">
                    <img src="/close.png" alt="close" width="20">
                  </button>
                <h3 class="text-center text-2xl mb-2">{{ job_id ? 'Update Job' : 'Create Job' }}</h3>
                
                <!-- job title -->
                <div class="">
                    <label class="text-lg text-gray-600 block mb-2" for="title">Job Title</label>
                    <input
                     v-model="title"
                     @input="clearError('title')" 
                     class="mb-2 rounded-md p-2 w-full outline-none ring-1 ring-gray-600 hover:ring-blue-600" 
                     type="text" 
                     name="title" 
                     id="title">

                     <!-- title error -->
                      <span v-if="errors.title" class="text-red-600 text-sm">{{ errors.title }}</span>
                </div>

                <!-- job description -->
                <div class="">
                    <label class="text-lg text-gray-600 block mb-2" for="description">Job Description</label>
                    <textarea
                     v-model="description" 
                     @input="clearError('description')"
                     class="w-full rounded-md outline-none ring-1 p-2 ring-gray-600 md:ring-blue-600" 
                     name="description" 
                     id="description" 
                     rows="6"></textarea>

                     <!-- description error -->
                      <span v-if="errors.description" class="text-red-600 text-sm">{{ errors.description }}</span>
                </div>

                <!-- button -->
                 <div class="">
                    <button
                     type="submit" 
                     class="w-full mt-2 mb-2 text-white bg-blue-600 rounded-md p-2 text-xl">{{job_id ? 'Update' : 'Create'}}</button>
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
            flag: '',
            first_name: '',
            last_name: '',
            username: '',
            company: '',
            email: '',
            phone: '',

            showInfo: false,

            jobs: [],

            candidates: [],

            errors: {},

            showCreateForm: false,

            title: '',
            description: '',

            job_id: '',

            searchQuery: ''
        }
    },

    methods: {

        async getMyCandidates(){
            try {
                const token = localStorage.getItem('access_token')
                const response = await api.get('job_candidates', {
                    headers: {
                        'Authorization': `Bearer ${token}`
                    }
                })
                this.candidates = response.data
            } catch (error) {
                console.error("Error fetching recruiter candidates:", error.response)
            }
        },

        logoutButton(){
            localStorage.removeItem('access_token')
            localStorage.removeItem('refresh_token')
            router.push('/login')
        },

        async editJob(jobObject){
            this.job_id = jobObject.id;
            this.showCreateForm = true
            this.title = jobObject.title
            this.description = jobObject.description
        },

        clearError(field) {
            if (this.errors[field]) {
                this.errors = ''
            }
        },

        async createJob() {

            this.errors = {}

            try {
                const token = localStorage.getItem('access_token');

                const payload = {
                    job: {
                        title: this.title,
                        description: this.description
                    }
                };
    
                if (this.job_id) {
                    const response = await api.patch(`update_job/${this.job_id}`, payload, {
                        headers: {
                            'Authorization': `Bearer ${token}`
                        }
                    });
                    console.log('Job updated successfully!', response.data)
                } else {
                    const response = await api.post('create_job', payload, {
                    headers: {
                        Authorization: `Bearer ${token}`
                    }
                });
                console.log('Job created successfully!', response.data)
                }

                this.showCreateForm = !this.showCreateForm

                this.getMyJobs();
    
                this.title = ''
                this.description = ''

            } catch (error) {
                if (error.response && error.response.data && error.response.data.errors) {
                    this.errors = error.response.data.errors;
                } else {
                    this.errors.general = "Something went wrong!"
                }
            }
        },

        closeButton() {
            this.showCreateForm = !this.showCreateForm
        },

        async deleteJob(jobObject) {
            try {
                const iswindow = window.confirm(`Sure to delete job entitled '${jobObject.title}'?`)
                if (iswindow) {
                    const token = localStorage.getItem('access_token');
                    const response = await api.delete(`delete_job/${jobId}`, {
                        headers: {
                            'Authorization': `Bearer ${token}`
                        }
                    });
                    console.log('Job deleted successfully!', response.data)

                    this.getMyJobs();
                }

            } catch (error) {
                if (error.response && error.response.data && error.response.data.errors) {
                    this.errors = error.response.data.errors
                } else {
                    this.errors.general = "Something went wrong. Please try again later..."
                }
            }
        },

        async getMyJobs() {
            try {
                const token = localStorage.getItem('access_token');
                const response = await api.get('all_jobs', {
                    headers: {
                        'Authorization': `Bearer ${token}`
                    }
                });
                this.jobs = response.data
            } catch (error) {
                console.error("Failed to fetch jobs:", error);
            }
        },

        toggleInfo() {
            this.showInfo = !this.showInfo
        }
    },

    computed: {

        filteredJobs(){
            if (!this.searchQuery) {
                return this.jobs;
            }
            return this.jobs.filter(job => 
            (job.title.toLowerCase().includes(this.searchQuery.toLowerCase()) || (job.description.toLowerCase().includes(this.searchQuery.toLowerCase())))
            );
        },

        formattedPhone() {
            if (this.phone && this.phone.startsWith("254")) {
                return this.phone.replace(/^254/, "0");
            }
            return this.phone;
        }
    },

    mounted() {
        this.flag = localStorage.getItem('flag');
        this.first_name = localStorage.getItem('first_name');
        this.last_name = localStorage.getItem('last_name');
        this.username = localStorage.getItem('username');
        this.company = localStorage.getItem('company');
        this.email = localStorage.getItem('email');
        this.phone = localStorage.getItem('phone');

        this.getMyJobs();
        this.getMyCandidates();
    },

}

</script>
