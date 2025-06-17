// Authentication System
class AuthSystem {
  constructor() {
    this.currentUser = null
    this.users = JSON.parse(localStorage.getItem("acaucab_users")) || []
    this.init()
  }

  init() {
    this.checkAuthStatus()
    this.bindEvents()
    this.initializeDefaultUsers()
  }

  initializeDefaultUsers() {
    // Add some default users for testing
    if (this.users.length === 0) {
      const defaultUsers = [
        {
          id: 1,
          firstName: "Juan",
          lastName: "Pérez",
          email: "juan@ejemplo.com",
          password: "123456",
          phone: "+58 414 123-4567",
          address: "Caracas, Venezuela",
          createdAt: new Date().toISOString(),
        },
        {
          id: 2,
          firstName: "María",
          lastName: "González",
          email: "maria@ejemplo.com",
          password: "123456",
          phone: "+58 424 987-6543",
          address: "Valencia, Venezuela",
          createdAt: new Date().toISOString(),
        },
      ]

      this.users = defaultUsers
      localStorage.setItem("acaucab_users", JSON.stringify(this.users))
    }
  }

  checkAuthStatus() {
    const userData = localStorage.getItem("acaucab_current_user")
    if (userData) {
      this.currentUser = JSON.parse(userData)

      // Redirect to products if on auth pages
      if (window.location.pathname.includes("login.html") || window.location.pathname.includes("register.html")) {
        window.location.href = "products.html"
      }
    } else {
      // Redirect to login if on protected pages
      if (
        window.location.pathname.includes("products.html") ||
        window.location.pathname.includes("profile.html") ||
        window.location.pathname.includes("checkout.html")
      ) {
        window.location.href = "login.html"
      }
    }
  }

  bindEvents() {
    // Login form
    const loginForm = document.getElementById("loginForm")
    if (loginForm) {
      loginForm.addEventListener("submit", (e) => this.handleLogin(e))
    }

    // Register form
    const registerForm = document.getElementById("registerForm")
    if (registerForm) {
      registerForm.addEventListener("submit", (e) => this.handleRegister(e))
    }

    // Password toggle buttons
    document.querySelectorAll(".toggle-password").forEach((btn) => {
      btn.addEventListener("click", (e) => this.togglePassword(e))
    })

    // Logout buttons
    document.querySelectorAll("#logoutBtn").forEach((btn) => {
      btn.addEventListener("click", (e) => this.handleLogout(e))
    })
  }

  async handleLogin(e) {
    e.preventDefault()

    const formData = new FormData(e.target)
    const email = formData.get("email")
    const password = formData.get("password")
    const remember = formData.get("remember")

    // Validate inputs
    if (!email || !password) {
      this.showNotification("Por favor, completa todos los campos", "error")
      return
    }

    // Find user
    const user = this.users.find((u) => u.email === email && u.password === password)

    if (user) {
      this.currentUser = user

      // Store session
      if (remember) {
        localStorage.setItem("acaucab_current_user", JSON.stringify(user))
      } else {
        sessionStorage.setItem("acaucab_current_user", JSON.stringify(user))
      }

      this.showNotification("¡Bienvenido de vuelta!", "success")

      // Redirect to products
      setTimeout(() => {
        window.location.href = "products.html"
      }, 1500)
    } else {
      this.showNotification("Credenciales incorrectas", "error")
    }
  }

  async handleRegister(e) {
    e.preventDefault()

    const formData = new FormData(e.target)
    const userData = {
      id: Date.now(),
      firstName: formData.get("firstName"),
      lastName: formData.get("lastName"),
      email: formData.get("email"),
      password: formData.get("password"),
      phone: formData.get("phone"),
      address: formData.get("address"),
      createdAt: new Date().toISOString(),
    }

    // Validate inputs
    if (!userData.firstName || !userData.lastName || !userData.email || !userData.password) {
      this.showNotification("Por favor, completa todos los campos obligatorios", "error")
      return
    }

    // Check password confirmation
    const confirmPassword = formData.get("confirmPassword")
    if (userData.password !== confirmPassword) {
      this.showNotification("Las contraseñas no coinciden", "error")
      return
    }

    // Check if email already exists
    if (this.users.find((u) => u.email === userData.email)) {
      this.showNotification("Este email ya está registrado", "error")
      return
    }

    // Check terms acceptance
    const terms = formData.get("terms")
    if (!terms) {
      this.showNotification("Debes aceptar los términos y condiciones", "error")
      return
    }

    // Add user
    this.users.push(userData)
    localStorage.setItem("acaucab_users", JSON.stringify(this.users))

    this.showNotification("¡Cuenta creada exitosamente!", "success")

    // Redirect to login
    setTimeout(() => {
      window.location.href = "login.html"
    }, 1500)
  }

  handleLogout(e) {
    e.preventDefault()

    // Clear session
    localStorage.removeItem("acaucab_current_user")
    sessionStorage.removeItem("acaucab_current_user")
    this.currentUser = null

    this.showNotification("Sesión cerrada exitosamente", "success")

    // Redirect to login
    setTimeout(() => {
      window.location.href = "login.html"
    }, 1000)
  }

  togglePassword(e) {
    const button = e.target.closest(".toggle-password")
    const input = button.parentElement.querySelector("input")
    const icon = button.querySelector("i")

    if (input.type === "password") {
      input.type = "text"
      icon.className = "fas fa-eye-slash"
    } else {
      input.type = "password"
      icon.className = "fas fa-eye"
    }
  }

  showNotification(message, type = "info") {
    const notification = document.getElementById("notification")
    if (!notification) return

    notification.textContent = message
    notification.className = `notification ${type} show`

    setTimeout(() => {
      notification.classList.remove("show")
    }, 4000)
  }

  getCurrentUser() {
    return this.currentUser
  }

  updateUser(userData) {
    if (!this.currentUser) return false

    // Update in users array
    const userIndex = this.users.findIndex((u) => u.id === this.currentUser.id)
    if (userIndex !== -1) {
      this.users[userIndex] = { ...this.users[userIndex], ...userData }
      localStorage.setItem("acaucab_users", JSON.stringify(this.users))

      // Update current user
      this.currentUser = this.users[userIndex]
      localStorage.setItem("acaucab_current_user", JSON.stringify(this.currentUser))

      return true
    }
    return false
  }
}

// Initialize auth system
const authSystem = new AuthSystem()

// Make it globally available
window.authSystem = authSystem
