const getUserRole = (): string | null => {
    const token = localStorage.getItem('access_token')

    if (!token) {
        return null
    }
    try {
        const payload = JSON.parse(atob(token.split('.')[1]))
        const userRole = payload.flag
        return userRole
    } catch {
        return null
    }
}

export default getUserRole
