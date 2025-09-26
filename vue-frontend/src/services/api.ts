import axios from "axios";

const api = await axios.create({
    baseURL: 'http://127.0.0.1:3000/api/v1/',
    headers: {
        'Content-Type': 'application/json'
    }
})

// check whether token in expired
function isTokenExpired(token: string | null): boolean {
    if (!token) return true;

    try {
        const payload = JSON.parse(atob(token.split('.')[1]));
        const tokenExp = payload.exp
        const currentTime = Date.now() / 1000
    
        const isExpired = tokenExp < currentTime
        return isExpired
    } catch {
        return true
    }
}

// refresh_token
async function refreshAuthToken(): Promise<string | null> {
    const refreshToken = localStorage.getItem('refresh_token')
    if (!refreshToken || isTokenExpired(refreshToken)){
        console.error('Missing or Expired Refresh Token!');

        localStorage.removeItem('access_token');
        localStorage.removeItem('refresh_token');

        window.location.href = '/login';

        return null;
    }

    // send request to backend to refresh the token
    try {
        const response = await axios.post(
            'http://127.0.0.1:3000/api/v1/refresh_token',
            {},
            {
            headers: {
                Authorization: `Bearer ${refreshToken}`
            }
        });
    
        const newAccessToken = response.data.new_access_token
        const newRefreshToken = response.data.new_refresh_token
        if (newAccessToken && newRefreshToken) {
            localStorage.setItem('access_token', newAccessToken);
            localStorage.setItem('refresh_token', newRefreshToken);
            return newAccessToken;
        }

        throw new Error('Invalid token response')
    } catch (error) {
        console.error('Failed to refresh token:', error);

        localStorage.removeItem('refresh_token');
        localStorage.removeItem('access_token');

        window.location.href = '/login'
        return null;
    }
}

// request interceptors
api.interceptors.request.use(
    async (config) => {
        const accessToken = localStorage.getItem('access_token');
        if (accessToken) {
            // ensure token is not expired
            if (!isTokenExpired(accessToken)){
                config.headers.Authorization = `Bearer ${accessToken}`
            } else {
                console.error('Access Token is Expired. Try refresh...');
                // refresh token
                await refreshAuthToken()
                const newToken = localStorage.getItem('access_token')

                if (newToken) {
                    config.headers['Authorization'] = `Bearer ${newToken}`;
                }
            }
        }
        return config;
    },
    (error) => {
        return Promise.reject(error)
    }
)

// response interceptor
api.interceptors.response.use(
    (response) => {
        return response;
    },

    async (error) => {
        // get the originalRequest
        const originalRequest = error.config;
        if (error.response && error.response?.status === 401 && !originalRequest._retry) {
            const errorMessage = error.response.data?.message || error.response.data?.error || '';
            if (typeof errorMessage === 'string' && (errorMessage.includes('Token Expired') || errorMessage.includes('Unauthorized'))){
                originalRequest._retry = true;

                // refresh_token
                try {
                    const newAccessToken = await refreshAuthToken();
                    if (newAccessToken) {
                        originalRequest.headers.Authorization = `Bearer ${newAccessToken}`;
                        return api(originalRequest);
                    }
                } catch (refreshError) {
                    console.error('Refresh Failed:', refreshError);

                    localStorage.removeItem('refresh_token');
                    localStorage.removeItem('access_token');

                    window.location.href = '/login';
                    return Promise.reject(refreshError);
                }
            }
        }
    }
)

export default api
