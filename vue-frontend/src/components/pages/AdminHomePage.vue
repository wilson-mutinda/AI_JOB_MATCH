<template>
    <div class="p-6 bg-gray-100 min-h-screen">
        <!-- recruiters and candidates -->
        <div class="flex gap-6 flex-col md:flex-row">

            <!-- recruiters -->
                <div class="bg-white shadow-md w-full md:w-1/2 rounded-xl p-4">
                <div class="flex items-center justify-between mb-4">
                    <h3 class="text-lg font-semibold text-gray-700">Active Recruiters</h3>
                    <!-- search bar -->
                    <div class="flex items-center bg-gray-50 rounded-full ring-1 px-3 py-2 shadow-sm ring-gray-300 focus-within:ring-blue-600">
                        <img src="/search.png" alt="search" width="30" class="w-5 h-5 opacity-60">
                        <input v-model="recruiterSearch" class="bg-transparent outline-none ml-2 text-sm w-full" type="text" name="search" id="search" placeholder="Search recruiters...">
                    </div>
                    
                </div>

                <!-- recruiters table -->
                <table class="w-full text-sm text-left border-collapse">
                    <thead>
                        <tr class="bg-gray-100 text-gray-700">
                            <th class="border p-3">#</th>
                            <th class="border p-3">Name</th>
                            <th class="border p-3">Company</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(recruiter, index) in filteredRecruiters" :key="index" class="hover:bg-blue-50 transition">
                            <td class="border p-3">{{ index + 1 }}.</td>
                            <td class="border p-3 font-medium text-gray-800">{{ recruiter.first_name + ' ' + recruiter.last_name }}</td>
                            <td class="border p-3 text-gray-600">{{ recruiter.company }}</td>
                        </tr>
                        <tr v-if="filteredRecruiters.length === 0">
                            <td colspan="3" class="p-6 text-center text-gray-500 italic bg-gray-50">No Matches</td>
                        </tr>
                    </tbody>
                </table>
                </div>

                <!-- candidates -->
                <div class="bg-white shadow-md w-full md:w-1/2 p-4 rounded-xl">
                    <div class="flex items-center justify-between mb-4">
                        <h3 class="text-lg font-semibold text-gray-700 mb-4">Active Candidates</h3>

                    <!-- search bar -->
                    <div class="flex items-center bg-gray-50 rounded-full ring-1 px-3 py-2 shadow-sm ring-gray-300 focus-within:ring-blue-600">
                        <img src="/search.png" alt="search" width="30" class="w-5 h-5 opacity-60">
                        <input v-model="candidateSearch" class="bg-transparent outline-none ml-2 text-sm w-full" type="text" name="search" id="search" placeholder="Search candidates...">
                    </div>
                </div>

                <!-- candidates table -->
                <table class="w-full text-sm text-left border-collapse">
                    <thead>
                        <tr class="bg-gray-100 text-gray-700">
                            <th class="border p-3">#</th>
                            <th class="border p-3">Email</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(candidate, index) in filterdCandidates" :key="index" class="hover:bg-green-50 transition">
                            <td class="border p-3">{{ index + 1 }}.</td>
                            <td class="border p-3 font-medium text-gray-800">{{ candidate.email }}</td>
                        </tr>
                        <tr v-if="filterdCandidates.length === 0">
                            <td colspan="3" class="italic text-center text-gray-500 bg-gray-50 p-6">No Matches</td>
                        </tr>
                    </tbody>
                </table>
                </div>
        </div>
    </div>
</template>

<script>
import api from '@/services/api';

export default {
    data() {
        return {
            recruiters: [],
            candidates: [],
            errors: {},
            recruiterSearch: '',
            candidateSearch: ''
        }
    },

    methods: {

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

    mounted(){
        this.fetchRecruiters();
        this.fetchCandidates();
    },

    computed: {

        filteredRecruiters() {
            return this.recruiters.filter(recruiter => 
                recruiter.email.toLowerCase().includes(this.recruiterSearch.toLowerCase()) ||
                recruiter.first_name.toLowerCase().includes(this.recruiterSearch.toLowerCase()) ||
                recruiter.last_name.toLowerCase().includes(this.recruiterSearch.toLowerCase()) ||
                recruiter.company.toLowerCase().includes(this.recruiterSearch.toLowerCase())
            )
        },

        filterdCandidates(){
            return this.candidates.filter(candidate => 
                candidate.email.toLowerCase().includes(this.candidateSearch.toLowerCase()) ||
                candidate.first_name.toLowerCase().includes(this.candidateSearch.toLowerCase()) ||
                candidate.last_name.toLowerCase().includes(this.candidateSearch.toLowerCase())
            )
        }
    }
}
</script>
