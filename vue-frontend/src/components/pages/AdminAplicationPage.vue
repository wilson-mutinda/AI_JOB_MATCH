<template>
    <div class="bg-white min-h-screen">
        
        <!-- applications table -->
         <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Name</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="(application, index) in applications" :key="index">
                    <td>{{ index + 1 }}</td>
                </tr>
            </tbody>
         </table>
    </div>
</template>

<script>
import api from '@/services/api';

export default {

    data() {
        return {
            applications: [],
            errors: {}
        }
    },


    methods: {
        async fetchApplications(){
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
        }
    },

    mounted() {
        this.fetchApplications()
    },

}
</script>