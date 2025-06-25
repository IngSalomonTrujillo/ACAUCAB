// Authentication System
class AuthSystem {
  constructor() {
    this.currentUser = null;
    this.API_BASE_URL = 'http://localhost:3000/api';
    this.init();
  }

  init() {
    this.checkAuthStatus();
    this.bindEvents();
  }

  async checkAuthStatus() {
    const userData = localStorage.getItem("acaucab_current_user") || sessionStorage.getItem("acaucab_current_user");
    
    if (userData) {
      try {
        this.currentUser = JSON.parse(userData);
        
        // Verificar si el usuario aún es válido en la base de datos
        const response = await fetch(`${this.API_BASE_URL}/auth/verify?userId=${this.currentUser.id}`);
        
        if (response.ok) {
          const result = await response.json();
          if (result.success) {
            if (window.location.pathname.includes("login.html") || window.location.pathname.includes("register.html")) {
              window.location.href = "admin.html";
            }
          } else {
            this.logout();
          }
        } else {
          this.logout();
        }
      } catch (e) {
        console.error("Error verificando usuario:", e);
        this.logout();
      }
    } else {
      if (
        window.location.pathname.includes("admin.html") ||
        window.location.pathname.includes("products.html") ||
        window.location.pathname.includes("profile.html") ||
        window.location.pathname.includes("checkout.html")
      ) {
        window.location.href = "login.html";
      }
    }
  }

  bindEvents() {
    const loginForm = document.getElementById("loginForm");
    if (loginForm) {
      loginForm.addEventListener("submit", (e) => this.handleLogin(e));
    }

    const registerForm = document.getElementById("registerForm");
    if (registerForm) {
      registerForm.addEventListener("submit", (e) => this.handleRegister(e));
    }

    document.querySelectorAll(".toggle-password").forEach((btn) => {
      btn.addEventListener("click", (e) => this.togglePassword(e));
    });

    document.querySelectorAll("#logoutBtn").forEach((btn) => {
      btn.addEventListener("click", (e) => this.handleLogout(e));
    });
  }

  async handleLogin(e) {
    e.preventDefault();

    const formData = new FormData(e.target);
    const username = formData.get("username");
    const password = formData.get("password");
    const remember = formData.get("remember") === "on";

    console.log("Login attempt:", { username, password, remember });

    if (!username || !password) {
      this.showNotification("Por favor, completa todos los campos", "error");
      return;
    }

    try {
      const response = await fetch(`${this.API_BASE_URL}/auth/login`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ username, password })
      });

      const result = await response.json();

      if (response.ok && result.success) {
        this.currentUser = result.user;

        // Almacenar sesión
        if (remember) {
          localStorage.setItem("acaucab_current_user", JSON.stringify(result.user));
        } else {
          sessionStorage.setItem("acaucab_current_user", JSON.stringify(result.user));
        }

        this.showNotification(`¡Bienvenido ${result.user.fullName}!`, "success");

        // Redirigir según el rol
        setTimeout(() => {
          if (result.user.role.name === 'Administrador' || result.user.role.name === 'Supervisor') {
            window.location.href = "admin.html";
          } else {
            window.location.href = "products.html";
          }
        }, 1500);
      } else {
        this.showNotification(result.error || "Credenciales incorrectas", "error");
      }
    } catch (error) {
      console.error("Error en login:", error);
      this.showNotification("Error de conexión. Intenta nuevamente.", "error");
    }
  }

  async handleRegister(e) {
    e.preventDefault();

    const formData = new FormData(e.target);
    const userData = {
      id: Date.now(),
      firstName: formData.get("firstName"),
      lastName: formData.get("lastName"),
      username: formData.get("username"),
      email: formData.get("email"),
      password: formData.get("password"),
      phone: formData.get("phone"),
      address: formData.get("address"),
      createdAt: new Date().toISOString(),
    };

    if (!userData.firstName || !userData.lastName || !userData.username || !userData.password) {
      this.showNotification("Por favor, completa todos los campos obligatorios", "error");
      return;
    }

    const confirmPassword = formData.get("confirmPassword");
    if (userData.password !== confirmPassword) {
      this.showNotification("Las contraseñas no coinciden", "error");
      return;
    }

    const terms = formData.get("terms");
    if (!terms) {
      this.showNotification("Debes aceptar los términos y condiciones", "error");
      return;
    }

    this.showNotification("Registro exitoso. Redirigiendo...", "success");

    setTimeout(() => {
      window.location.href = "login.html";
    }, 1500);
  }

  handleLogout(e) {
    e.preventDefault();
    this.logout();
  }

  logout() {
    this.currentUser = null;
    localStorage.removeItem("acaucab_current_user");
    sessionStorage.removeItem("acaucab_current_user");
    
    this.showNotification("Sesión cerrada", "info");
    
    setTimeout(() => {
      window.location.href = "login.html";
    }, 1000);
  }

  togglePassword(e) {
    e.preventDefault();
    const button = e.currentTarget;
    const input = button.parentElement.querySelector("input");
    const icon = button.querySelector("i");

    if (input.type === "password") {
      input.type = "text";
      icon.classList.remove("fa-eye");
      icon.classList.add("fa-eye-slash");
    } else {
      input.type = "password";
      icon.classList.remove("fa-eye-slash");
      icon.classList.add("fa-eye");
    }
  }

  showNotification(message, type = "info") {
    const notification = document.getElementById("notification");
    if (!notification) return;

    notification.textContent = message;
    notification.className = `notification ${type}`;
    notification.style.display = "block";

    setTimeout(() => {
      notification.style.display = "none";
    }, 3000);
  }

  getCurrentUser() {
    return this.currentUser;
  }

  updateUser(userData) {
    this.currentUser = { ...this.currentUser, ...userData };
    localStorage.setItem("acaucab_current_user", JSON.stringify(this.currentUser));
  }

  // Verificar si el usuario tiene un privilegio específico
  hasPrivilege(privilegeName) {
    if (!this.currentUser || !this.currentUser.privileges) return false;
    return this.currentUser.privileges.some(p => p.nombre_privilegio === privilegeName);
  }

  // Verificar si el usuario tiene un rol específico
  hasRole(roleName) {
    if (!this.currentUser || !this.currentUser.role) return false;
    return this.currentUser.role.name === roleName;
  }

  // Verificar si el usuario puede acceder a una sección
  canAccess(section) {
    if (!this.currentUser) return false;
    
    switch (section) {
      case 'admin':
        return this.hasRole('Administrador') || this.hasRole('Supervisor');
      case 'users':
        return this.hasRole('Administrador') || this.hasPrivilege('Gestionar Usuarios');
      case 'reports':
        return this.hasPrivilege('Ver Reportes');
      case 'products':
        return this.hasPrivilege('Gestionar Productos') || this.hasPrivilege('Acceso Básico');
      default:
        return this.hasPrivilege('Acceso Básico');
    }
  }
}

// Inicializar el sistema de autenticación
const auth = new AuthSystem();