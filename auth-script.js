// Authentication Script
class AuthManager {
  constructor() {
    this.currentUser = null
    this.init()
  }

  init() {
    // Check if user is already logged in
    this.checkAuthStatus()
    this.bindEvents()
  }

  bindEvents() {
    // Login form
    const loginForm = document.getElementById("loginForm")
    if (loginForm) {
      loginForm.addEventListener("submit", (e) => this.handleLogin(e))
    }

    // Register forms
    const registerNaturalForm = document.getElementById("registerNaturalForm")
    if (registerNaturalForm) {
      registerNaturalForm.addEventListener("submit", (e) => this.handleRegisterNatural(e))
    }

    const registerJuridicaForm = document.getElementById("registerJuridicaForm")
    if (registerJuridicaForm) {
      registerJuridicaForm.addEventListener("submit", (e) => this.handleRegisterJuridica(e))
    }

    // Password toggle buttons
    document.querySelectorAll(".toggle-password").forEach((btn) => {
      btn.addEventListener("click", (e) => this.togglePassword(e))
    })

    // Logout buttons
    document.querySelectorAll(".logout-btn").forEach((btn) => {
      btn.addEventListener("click", (e) => this.handleLogout(e))
    })
  }

  checkAuthStatus() {
    const userData = localStorage.getItem("acaucab_user")
    if (userData) {
      this.currentUser = JSON.parse(userData)
      this.updateUIForLoggedInUser()
    }
  }

  handleLogin(e) {
    e.preventDefault()

    const formData = new FormData(e.target)
    const email = formData.get("email")
    const password = formData.get("password")
    const remember = formData.get("remember")

    // Validate form
    if (!email || !password) {
      this.showNotification("Por favor, completa todos los campos", "error")
      return
    }

    // Check if user exists in localStorage
    const users = JSON.parse(localStorage.getItem("acaucab_users") || "[]")
    const user = users.find((u) => u.email === email && u.password === password)

    if (user) {
      // Login successful
      this.currentUser = user

      // Store user session
      if (remember) {
        localStorage.setItem("acaucab_user", JSON.stringify(user))
      } else {
        sessionStorage.setItem("acaucab_user", JSON.stringify(user))
      }

      this.showNotification("¡Bienvenido de vuelta!", "success")

      // Redirect to dashboard
      setTimeout(() => {
        window.location.href = "dashboard.html"
      }, 1500)
    } else {
      this.showNotification("Credenciales incorrectas", "error")
    }
  }

  handleRegisterNatural(e) {
    e.preventDefault()

    const formData = new FormData(e.target)
    const userData = {
      id: Date.now(),
      type: "natural",
      nombres: formData.get("nombres"),
      apellidos: formData.get("apellidos"),
      tipoDocumento: formData.get("tipoDocumento"),
      numeroDocumento: formData.get("numeroDocumento"),
      rif: formData.get("rif"),
      telefonoPersonal: formData.get("telefonoPersonal"),
      telefonoCasa: formData.get("telefonoCasa"),
      metodoPago1: formData.get("metodoPago1"),
      metodoPago2: formData.get("metodoPago2"),
      direccion: formData.get("direccion"),
      email: formData.get("correo"),
      password: formData.get("contrasena"),
      createdAt: new Date().toISOString(),
    }

    // Validate passwords match
    if (userData.password !== formData.get("confirmarContrasena")) {
      this.showNotification("Las contraseñas no coinciden", "error")
      return
    }

    // Check if email already exists
    const users = JSON.parse(localStorage.getItem("acaucab_users") || "[]")
    if (users.find((u) => u.email === userData.email)) {
      this.showNotification("Este correo ya está registrado", "error")
      return
    }

    // Save user
    users.push(userData)
    localStorage.setItem("acaucab_users", JSON.stringify(users))

    this.showNotification("¡Cuenta creada exitosamente!", "success")

    // Redirect to login
    setTimeout(() => {
      window.location.href = "login.html"
    }, 1500)
  }

  handleRegisterJuridica(e) {
    e.preventDefault()

    const formData = new FormData(e.target)
    const userData = {
      id: Date.now(),
      type: "juridica",
      denominacionComercial: formData.get("denominacionComercial"),
      razonSocial: formData.get("razonSocial"),
      tipoDocumento: formData.get("tipoDocumento"),
      numeroDocumento: formData.get("numeroDocumento"),
      telefonoOficina1: formData.get("telefonoOficina1"),
      telefonoOficina2: formData.get("telefonoOficina2"),
      metodoPago1: formData.get("metodoPago1"),
      metodoPago2: formData.get("metodoPago2"),
      paginaWeb: formData.get("paginaWeb"),
      capitalDisponible: formData.get("capitalDisponible"),
      personaContacto1: formData.get("personaContacto1"),
      personaContacto2: formData.get("personaContacto2"),
      direccionFiscal: formData.get("direccionFiscal"),
      direccionFisica: formData.get("direccionFisica"),
      email: formData.get("correo"),
      password: formData.get("contrasena"),
      createdAt: new Date().toISOString(),
    }

    // Validate passwords match
    if (userData.password !== formData.get("confirmarContrasena")) {
      this.showNotification("Las contraseñas no coinciden", "error")
      return
    }

    // Check if email already exists
    const users = JSON.parse(localStorage.getItem("acaucab_users") || "[]")
    if (users.find((u) => u.email === userData.email)) {
      this.showNotification("Este correo ya está registrado", "error")
      return
    }

    // Save user
    users.push(userData)
    localStorage.setItem("acaucab_users", JSON.stringify(users))

    this.showNotification("¡Cuenta creada exitosamente!", "success")

    // Redirect to login
    setTimeout(() => {
      window.location.href = "login.html"
    }, 1500)
  }

  handleLogout(e) {
    e.preventDefault()

    // Clear user data
    localStorage.removeItem("acaucab_user")
    sessionStorage.removeItem("acaucab_user")
    this.currentUser = null

    this.showNotification("Sesión cerrada exitosamente", "success")

    // Redirect to home
    setTimeout(() => {
      window.location.href = "index.html"
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

  updateUIForLoggedInUser() {
    if (!this.currentUser) return

    // Update user info in UI
    const userName =
      this.currentUser.type === "natural"
        ? `${this.currentUser.nombres} ${this.currentUser.apellidos}`
        : this.currentUser.denominacionComercial

    // Update dropdown
    const userNameElement = document.getElementById("userName")
    const userEmailElement = document.getElementById("userEmail")

    if (userNameElement) userNameElement.textContent = userName
    if (userEmailElement) userEmailElement.textContent = this.currentUser.email

    // Update sidebar
    const sidebarUserName = document.getElementById("sidebarUserName")
    const userType = document.getElementById("userType")
    const welcomeUserName = document.getElementById("welcomeUserName")

    if (sidebarUserName) sidebarUserName.textContent = userName
    if (userType) userType.textContent = this.currentUser.type === "natural" ? "Persona Natural" : "Persona Jurídica"
    if (welcomeUserName)
      welcomeUserName.textContent =
        this.currentUser.type === "natural" ? this.currentUser.nombres : this.currentUser.denominacionComercial
  }

  showNotification(message, type = "info") {
    const notification = document.createElement("div")
    notification.className = `notification notification-${type}`
    notification.textContent = message

    // Add styles
    Object.assign(notification.style, {
      position: "fixed",
      top: "100px",
      right: "20px",
      padding: "1rem 1.5rem",
      borderRadius: "8px",
      color: "white",
      fontWeight: "500",
      zIndex: "9999",
      transform: "translateX(100%)",
      transition: "transform 0.3s ease",
      maxWidth: "300px",
    })

    // Set background color based on type
    const colors = {
      success: "#10b981",
      error: "#ef4444",
      info: "#3b82f6",
    }
    notification.style.backgroundColor = colors[type] || colors.info

    document.body.appendChild(notification)

    // Animate in
    setTimeout(() => {
      notification.style.transform = "translateX(0)"
    }, 100)

    // Remove after 4 seconds
    setTimeout(() => {
      notification.style.transform = "translateX(100%)"
      setTimeout(() => {
        if (document.body.contains(notification)) {
          document.body.removeChild(notification)
        }
      }, 300)
    }, 4000)
  }
}

// Initialize auth manager
document.addEventListener("DOMContentLoaded", () => {
  new AuthManager()
})
