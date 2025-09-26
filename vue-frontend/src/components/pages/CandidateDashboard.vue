<template>
    <div class="bg-gray-100 min-h-screen flex flex-col md:flex-row w-full">
        <!-- left -->
         <div class="w-full md:w-[15%] bg-white p-2">
            <!-- sidebar -->
             <div class="space-y-4">

                <!-- home -->
                 <div class="">
                    <button class="flex items-center gap-2 bg-blue-200 w-full rounded-md p-2 mb-2 hover:bg-blue-600 hover:text-white text-xl">
                        <img src="/logo.png" alt="logo" width="30">
                        <span>Home</span>
                    </button>
                 </div>

                 <!-- jobs -->
                  <div class="">
                    <button class="flex items-center gap-2 bg-blue-200 w-full rounded-md p-2 mb-2 hover:bg-blue-600 hover:text-white text-xl">
                        <img src="/job.png" alt="job" width="30">
                        <span>Jobs</span>
                    </button>
                  </div>

                  <!-- logout -->
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
                        <span class="text-gray-600 text-xl">{{ flag }}</span>
                    </div>

                    <!-- info -->
                    <div class="">
                        <button @click="toggleInfo">
                            <img :src="showInfo ? 'arrow-up.png' : '/arrow-down.png'" alt="up" width="20">
                        </button>
                    </div>

                    <div v-if="showInfo" class="absolute bg-white shadow-lg rounded-md p-2 z-50 top-20 right-0 w-60">
                        <ul class="space-y-1">
                            <li>First name: {{ first_name }} </li>
                            <li>Last name: {{ last_name }} </li>
                            <li>Username: {{ username }} </li>
                            <li>Date of Birth: {{ date_of_birth }} </li>
                            <li>Email: {{ email }}</li>
                            <li>Phone: {{ formattedPhone }}</li>
                            <button @click="logoutButton" class="w-full bg-blue-600 rounded-md mt-2 p-1 text-white">Logout</button>
                        </ul>
                    </div>

                  </div>

             </div>

             <!-- body -->
              <div class="">
                <h3 class="text-xl font-bold">Welcome back <span class="text-blue-600">@{{ first_name }} </span></h3>
                
                <div class="flex flex-col md:flex-row gap-4 w-full">
                    <!-- posted jobs -->
                 <div class="bg-white p-4 rounded-md md:w-1/2">
                    <h3 class="text-xl mb-2 text-center">Posted Jobs</h3>
                    <table class="w-full border-collapse">
                        <thead>
                            <tr class="bg-gray-100">
                                <th class="border p-2">#</th>
                                <th class="border p-2">Job</th>
                                <th class="border p-2">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(job, index) in filteredJobs" :key="job.id" class="hover:bg-gray-50">
                                <td class="border p-2 text-center">{{ index + 1 }}.</td>
                                <td class="border p-2 text-lg">{{ job.title }}</td>
                                <td class="border p-2">
                                    <button @click="viewJobInfo(job)" class="bg-blue-600 rounded-md px-4 py-2 text-center text-white">View Info</button>
                                </td>
                            </tr>
                            <tr v-if="filteredJobs.length === 0">
                                <td colspan="3" class="text-center text-gray-600 mt-4 text-lg">No Matches!</td>
                            </tr>
                        </tbody>
                    </table>
                 </div>

                 <div class="md:w-1/2 bg-white p-4 rounded-md">
                    <h3 class="text-xl mb-2 text-center">My Recent applications</h3>
                    <table class="w-full border-collapse">
                        <thead>
                            <tr class="bg-gray-100">
                                <th class="border p-2">#</th>
                                <th class="border p-2">Job</th>
                                <th class="border p-2">Company</th>
                                <th class="border p-2">Date Applied</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(app, index) in myApplications" :key="app.id">
                                <td class="border p-2 text-center">{{ index + 1 }}</td>
                                <td class="border p-2">{{ app.job_title }}</td>
                                <td class="border p-2">{{ app.recruiter_company }}</td>
                                <td class="border p-2">{{ new Date(app.date_of_application).toLocaleDateString() }}</td>
                            </tr>
                            <tr v-if="myApplications.length === 0">
                                <td colspan="3" class="text-center text-gray-600 text-lg">No Recent Application</td>
                            </tr>
                        </tbody>
                    </table>
                 </div>
                </div>
              </div>
          </div>
    </div>

    <!-- job info modal -->
     <div v-if="viewInfo" class="bg-black bg-opacity-50 fixed inset-0 flex items-center justify-center z-50">
        <div class="bg-white rounded-md p-4 shadow-md w-full max-w-md relative">

            <!-- close button -->
             <button @click="closeModal" class="absolute right-4 top-4 hover:scale-110 transition">
                <img src="/close.png" alt="close" width="20">
             </button>

             <!-- modal title -->
             <h3 class="text-center mb-6 text-gray-800 text-2xl font-semibold">About Job</h3>

             <!-- job details -->
              <div class="space-y-4">

                <!-- title -->
                 <div class="">
                    <p class="text-lg font-medium text-gray-700">Job Title</p>
                    <p class="text-gray-900">{{ title }}</p>
                 </div>

                 <!-- description -->
                  <div class="">
                    <p class="text-lg font-medium text-gray-700">Job Description</p>
                    <p class="text-gray-600 whitespace-pre-line leading-relaxed">{{ description }}</p>
                  </div>

                  <!-- recruiter info -->
                   <div class="bg-gray-50 p-3 rounded-md border">
                    <p class="text-lg font-medium text-gray-700 mb-2">Recruiter Info</p>
                    <ul class="text-gray-600 space-y-1 text-sm">
                        <li><span class="font-semibold">Company/Firm:</span> {{ company }}</li>
                        <li><span class="font-semibold">Email:</span> {{ email }}</li>
                        <li><span class="font-semibold">Phone:</span> {{ formattedPhone }}</li>
                    </ul>
                   </div>

                <!-- apply button -->
                 <div class="flex items-center justify-between mt-4">
                    <span class="text-gray-700 text-lg">Interested?</span>
                    <button @click="aplicationButton" class="bg-blue-700 hover:bg-blue-700 px-5 py-2 rounded-md text-white font-medium shadow">Apply Now</button>
                 </div>
              </div>
        </div>
     </div>

     <!-- application modal -->
      <div v-if="showApplication" class="bg-black bg-opacity-50 fixed flex items-center justify-center z-50 inset-0">
        <div class="bg-white rounded-lg p-6 shadow-lg w-full max-w-md relative">

            <!-- close button -->
             <button @click="showApplication = false" class="absolute right-4 top-4 hover:scale-110 transition">
                <img src="/close.png" alt="close" width="20">
             </button>

             <!-- title -->
            <h3 class="text-center text-2xl font-semibold text-gray-800 mb-2">Application Form</h3>
            <p class="text-center text-gray-600 mb-6">To complete your application, please upload your cv</p>

            <!-- form -->
            <form @submit.prevent="submitApplication" action="" method="post">
                <div class="">
                    <label class="block text-gray-700 font-medium mb-2" for="curriculum-vitae">Curriculum Vitae</label>
                    <input
                    accept=".pdf, .doc, .docx"
                    class="block w-full text-sm text-gray-600 
                            file:mr-4 file:py-2 file:px-4
                            file:rounded-md file:border-0
                            file:text-sm file:font-semibold
                            file:bg-blue-600 file:text-white
                            hover:file:bg-blue-700
                            cursor-pointer"
                    required
                    type="file" 
                    name="cv"
                    @change="handleFileUpload" 
                    id="cv">
                    <p class="text-xs text-gray-500 mt-1">Accepted formats: .pdf, .doc, .docx</p>
                </div>

                <!-- actions -->
                 <div class="flex gap-3 justify-end pt-4">
                    <button type="button" @click="showApplication = false">Cancel</button>
                    <button type="submit" class="px-4 py-2 rounded-md bg-blue-600 text-white font-medium hover:bg-blue-700 shadow">Submit Application</button>
                 </div>
            </form>
        </div>
      </div>
</template>

<script>
import router from '@/router'
import api from '@/services/api'

export default {
    data() {
        return {
            showInfo: false,

            showApplication: false,

            flag: '',
            first_name: '',
            last_name: '',
            username: '',
            date_of_birth: '',
            email: '',
            phone: '',

            title: '',
            description: '',
            company: '',

            postedJobs: [],
            errors: {},

            viewInfo: false,

            jobId: '',
            cvFile: null,

            searchQuery: '',

            myApplications: [],
        }
    },

    methods: {

        async getRecentApplications(){
            try {
                const token = localStorage.getItem('access_token')
                const response = await api.get('candidate_applications', {
                    headers: {
                        'Authorization': `Bearer ${token}`
                    }
                })
                this.myApplications = response.data
            } catch (error) {
                console.error("Error fetching candidate applications:", error.response)
            }
        },

        handleFileUpload(event){
            this.cvFile = event.target.files[0]
        },        

        async submitApplication(){

            if (!this.cvFile) {
                alert("Please upload your cv before submitting.")
                return
            }

            const token = localStorage.getItem('access_token')
            const formData = new FormData()
            formData.append('application[job_id]', this.jobId)
            formData.append('application[curriculum_vitae]', this.cvFile)

            try {
                const response = await api.post('create_application', formData, {
                    headers: {
                        'Authorization': `Bearer ${token}`,
                        'Content-Type': 'multipart/form-data'
                    }
                });
                alert("Application submitted successfully!")
                this.showApplication = false
                this.getRecentApplications()
            } catch (error) {
                console.error("Error submitting application:", error)
                alert("Something went wrong. Please try again.")
            }

        },

        aplicationButton(){
            this.showApplication = true
            this.viewInfo = false
        },
        
        closeModal(){
            this.viewInfo = false
        },

        viewJobInfo(job){
            this.jobId = job.id
            if (this.jobId) {
                this.viewInfo = true
                this.title = job.title
                this.description = job.description
                this.company = job.recruiter_company
                this.email = job.recruiter_email
                this.phone = job.recruiter_phone
            }

        },

        async getPostedJobs(){
            try {
                const token = localStorage.getItem('access_token')
                const response = await api.get('posted_jobs', {
                    headers: {
                        'Authorization': `Bearer ${token}`
                    }
                })
                this.postedJobs = response.data
            } catch (error) {
                if (error.response && error.response.data && error.response.data.errors) {
                    this.errors = error.response.data.errors
                } else {
                    this.errors = 'Something went wrong!'
                }
            }
        },

        logoutButton(){
            localStorage.removeItem('access_token')
            localStorage.removeItem('refresh_token')
            router.push('/login')
        },

        toggleInfo() {
            this.showInfo = !this.showInfo
        }
    },

    mounted() {
        this.flag = localStorage.getItem('flag')
        this.first_name = localStorage.getItem('first_name')
        this.last_name = localStorage.getItem('last_name')
        this.username = localStorage.getItem('username')
        this.date_of_birth = localStorage.getItem('date_of_birth')
        this.email = localStorage.getItem('email')
        this.phone = localStorage.getItem('phone')

        this.getPostedJobs();
        this.getRecentApplications();
        
    },

    computed: {

        filteredJobs(){
            return this.postedJobs.filter(job => 
                job.title.toLowerCase().includes(this.searchQuery.toLowerCase())
            )
        },

        formattedPhone() {
            if (this.phone && this.phone.startsWith("254")) {
                return this.phone.replace(/^254/, "0");
            }
            return this.phone;
        }
    }
}
</script>
