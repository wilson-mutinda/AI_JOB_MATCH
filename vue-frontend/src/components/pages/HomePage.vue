<template>
    <div class="bg-gray-100 min-h-screen">
        <!-- navbar -->
         <nav class="bg-white py-3">
            <div class="container mx-auto px-4 flex justify-between items-center">
                <!-- logo -->
                 <div class="flex items-center gap-2">
                    <img src="/logo.png" alt="logo" width="40">
                    <span class="font-bold text-2xl text-blue-600">AIJOBMATCH</span>
                 </div>

                 <!-- desktop-menu -->
                  <div class="hidden md:flex items-center justify-center gap-4">
                    <a class="font-bold text-gray-600 hover:text-blue-600" href="#">Home</a>
                    <a class="font-bold text-gray-600 hover:text-blue-600" href="#">About Us</a>
                    <a class="font-bold text-gray-600 hover:text-blue-600" href="#">Features</a>
                    <a class="font-bold text-gray-600 hover:text-blue-600" href="#">Contact Us</a>
                    <router-link to="/login" class="font-bold bg-blue-600 rounded-md px-4 py-2 text-white hover:bg-transparent hover:text-gray-600">Login</router-link>
                  </div>

                  <!-- mobile-menu -->
                   <div class="block md:hidden">
                    <button @click="toggleMenu">
                        <img src="/dial-pad.png" alt="dial-pad" width="40">
                    </button>
                   </div>
            </div>

            <!-- menu -->
             <div v-if="viewMenu" class="md:hidden flex flex-col items-center gap-2">
                <a class="font-bold text-gray-600 hover:text-blue-600" href="#">Home</a>
                <a class="font-bold text-gray-600 hover:text-blue-600" href="#">About Us</a>
                <a class="font-bold text-gray-600 hover:text-blue-600" href="#">Features</a>
                <a class="font-bold text-gray-600 hover:text-blue-600" href="#">Contact Us</a>
                <router-link to="/login" class="font-bold bg-blue-600 rounded-md px-4 py-2 text-white hover:bg-transparent hover:text-gray-600">Login</router-link>
             </div>
         </nav>
    </div>
</template>

<script>
export default {
    data() {
        return {
            viewMenu: false
        }
    },

    methods: {
        toggleMenu() {
            this.viewMenu = !this.viewMenu
        }
    }
}
</script>
