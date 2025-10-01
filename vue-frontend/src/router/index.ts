import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import LoginForm from '@/components/forms/LoginForm.vue'
import HomePage from '@/components/pages/HomePage.vue'
import CandidateForm from '@/components/forms/CandidateForm.vue'
import RecruiterForm from '@/components/forms/RecruiterForm.vue'
import AdminDashboard from '@/components/pages/AdminDashboard.vue'
import CandidateDashboard from '@/components/pages/CandidateDashboard.vue'
import RecruiterDashboard from '@/components/pages/RecruiterDashboard.vue'
import getUserRole from '@/services/auth'
import AdminRecruiterPage from '@/components/pages/AdminRecruiterPage.vue'
import AdminHomePage from '@/components/pages/AdminHomePage.vue'
import AdminCandidatePage from '@/components/pages/AdminCandidatePage.vue'
import AdminJobsPage from '@/components/pages/AdminJobsPage.vue'
import AdminAplicationPage from '@/components/pages/AdminAplicationPage.vue'
import AdminReportPage from '@/components/pages/AdminReportPage.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    { path: '/', name: 'home', component: HomePage },
    { path: '/login', name: 'login', component: LoginForm },
    { path: '/create-candidate', name: 'create-candidate', component: CandidateForm },
    { path: '/create-recruiter', name: 'create-recruiter', component: RecruiterForm },
    { path: '/admin-dashboard', name: 'admin-dashboard', component: AdminDashboard, children: [
      { path: '', redirect: '/admin-dashboard/home'},
      { path: 'home', name: 'admin-home', component: AdminHomePage },
      { path: 'recruiters', name: 'admin-recruiters', component: AdminRecruiterPage },
      { path: 'candidates', name: 'admin-candidates', component: AdminCandidatePage },
      { path: 'jobs', name: 'admin-jobs', component: AdminJobsPage },
      { path: 'applications', name: 'admin-applications', component: AdminAplicationPage },
      { path: 'reports', name: 'admin-reports', component: AdminReportPage },
    ] },
    { path: '/candidate-dashboard', name: 'candidate-dashboard', component: CandidateDashboard },
    { path: '/recruiter-dashboard', name: 'recruiter-dashboard', component: RecruiterDashboard },

    { path: '/:pathMatch(.*)*', redirect: '/' },
  ],
});

router.beforeEach((to, from, next) => {
  const isAuthenticated = localStorage.getItem('access_token');
  const publicRoutes = ['/', '/login'];
  const userRole = getUserRole()?.toLowerCase();

  // allow public routes
  if (publicRoutes.includes(to.path)) {
    return next();
  }

  // redirect unauthorized users
  if (!isAuthenticated) {
    return next('/login');
  }

  // role-based routing
  if (to.path.startsWith('/candidate') && userRole !== 'candidate') {
    return next(`/${userRole}-dashboard`);
  }

  if (to.path.startsWith('/admin') && userRole !== 'admin') {
    return next(`/${userRole}-dashboard`);
  }

  if (to.path.startsWith('/recruiter') && userRole !== 'recruiter') {
    return next(`/${userRole}-dashboard`);
  }

  // allow navigation
  next();
});

export default router
