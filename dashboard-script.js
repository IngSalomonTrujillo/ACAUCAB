// Dashboard Script
class DashboardManager {
  constructor() {
    this.currentUser = null
    this.init()
  }

  init() {
    this.checkAuth()
    this.bindEvents()
    this.loadUserData()
  }

  checkAuth() {
    const userData = localStorage.getItem("acaucab_user") || sessionStorage.getItem("acaucab_user")

    if (!userData) {
      // Redirect to login if not authenticated
      window.location.href = "login.html"
      return
    }

    this.currentUser = JSON.parse(userData)
  }

  bindEvents() {
    // Tab navigation
    document.querySelectorAll(".dashboard-nav-item[data-tab]").forEach((item) => {
      item.addEventListener("click", (e) => this.switchTab(e))
    })

    // View all links
    document.querySelectorAll(".view-all[data-tab]").forEach((link) => {
      link.addEventListener("click", (e) => this.switchTab(e))
    })
  }

  loadUserData() {
    if (!this.currentUser) return

    // Update user info
    const userName =
      this.currentUser.type === "natural"
        ? `${this.currentUser.nombres} ${this.currentUser.apellidos}`
        : this.currentUser.denominacionComercial

    // Update all user name elements
    document.querySelectorAll("#userName, #sidebarUserName").forEach((el) => {
      if (el) el.textContent = userName
    })

    document.querySelectorAll("#userEmail").forEach((el) => {
      if (el) el.textContent = this.currentUser.email
    })

    document.querySelectorAll("#userType").forEach((el) => {
      if (el) el.textContent = this.currentUser.type === "natural" ? "Persona Natural" : "Persona Jurídica"
    })

    document.querySelectorAll("#welcomeUserName").forEach((el) => {
      if (el)
        el.textContent =
          this.currentUser.type === "natural" ? this.currentUser.nombres : this.currentUser.denominacionComercial
    })
  }

  switchTab(e) {
    e.preventDefault()

    const tabName = e.target.closest("[data-tab]").dataset.tab

    // Update active nav item
    document.querySelectorAll(".dashboard-nav-item").forEach((item) => {
      item.classList.remove("active")
    })

    document.querySelectorAll(`[data-tab="${tabName}"]`).forEach((item) => {
      item.classList.add("active")
    })

    // Show corresponding tab content
    this.showTabContent(tabName)
  }

  showTabContent(tabName) {
    // Hide all tabs
    document.querySelectorAll(".dashboard-tab").forEach((tab) => {
      tab.classList.remove("active")
    })

    // Show selected tab or create it if it doesn't exist
    let tabContent = document.getElementById(tabName)

    if (!tabContent) {
      tabContent = this.createTabContent(tabName)
    }

    if (tabContent) {
      tabContent.classList.add("active")
    }
  }

  createTabContent(tabName) {
    const dashboardContent = document.querySelector(".dashboard-content")
    const tabContent = document.createElement("div")
    tabContent.className = "dashboard-tab"
    tabContent.id = tabName

    switch (tabName) {
      case "pedidos":
        tabContent.innerHTML = this.getPedidosContent()
        break
      case "puntos":
        tabContent.innerHTML = this.getPuntosContent()
        break
      case "favoritos":
        tabContent.innerHTML = this.getFavoritosContent()
        break
      case "perfil":
        tabContent.innerHTML = this.getPerfilContent()
        break
      case "direcciones":
        tabContent.innerHTML = this.getDireccionesContent()
        break
      case "seguridad":
        tabContent.innerHTML = this.getSeguridadContent()
        break
      default:
        return null
    }

    dashboardContent.appendChild(tabContent)
    return tabContent
  }

  getPedidosContent() {
    return `
      <div class="dashboard-welcome">
        <h2>Mis Pedidos</h2>
        <p>Aquí puedes ver el historial de todos tus pedidos.</p>
      </div>
      
      <div class="empty-state">
        <div class="empty-icon">
          <i class="fas fa-shopping-bag"></i>
        </div>
        <h4>No tienes pedidos aún</h4>
        <p>Cuando realices tu primer pedido, aparecerá aquí con toda la información de seguimiento.</p>
        <a href="index.html#productos" class="btn btn-primary">Explorar Productos</a>
      </div>
    `
  }

  getPuntosContent() {
    return `
      <div class="dashboard-welcome">
        <h2>Mis Puntos</h2>
        <p>Acumula puntos con cada compra y canjéalos por descuentos especiales.</p>
      </div>
      
      <div class="stats-grid">
        <div class="stat-card">
          <div class="stat-icon">
            <i class="fas fa-star"></i>
          </div>
          <div class="stat-info">
            <h3>0</h3>
            <p>Puntos Disponibles</p>
          </div>
        </div>
        
        <div class="stat-card">
          <div class="stat-icon">
            <i class="fas fa-gift"></i>
          </div>
          <div class="stat-info">
            <h3>0</h3>
            <p>Puntos Canjeados</p>
          </div>
        </div>
      </div>
      
      <div class="empty-state">
        <div class="empty-icon">
          <i class="fas fa-star"></i>
        </div>
        <h4>Comienza a acumular puntos</h4>
        <p>Por cada compra que realices, ganarás puntos que podrás canjear por descuentos y productos especiales.</p>
      </div>
    `
  }

  getFavoritosContent() {
    return `
      <div class="dashboard-welcome">
        <h2>Productos Favoritos</h2>
        <p>Guarda tus cervezas favoritas para encontrarlas fácilmente.</p>
      </div>
      
      <div class="empty-state">
        <div class="empty-icon">
          <i class="fas fa-heart"></i>
        </div>
        <h4>No tienes favoritos aún</h4>
        <p>Marca como favoritos los productos que más te gusten para acceder a ellos rápidamente.</p>
        <a href="index.html#productos" class="btn btn-primary">Explorar Productos</a>
      </div>
    `
  }

  getPerfilContent() {
    const user = this.currentUser
    const isNatural = user.type === "natural"

    return `
      <div class="dashboard-welcome">
        <h2>Editar Perfil</h2>
        <p>Actualiza tu información personal y de contacto.</p>
      </div>
      
      <form class="auth-form" id="updateProfileForm">
        ${
          isNatural
            ? `
          <div class="form-row">
            <div class="form-group">
              <label for="nombres">Nombres</label>
              <input type="text" id="nombres" name="nombres" value="${user.nombres || ""}" required>
            </div>
            <div class="form-group">
              <label for="apellidos">Apellidos</label>
              <input type="text" id="apellidos" name="apellidos" value="${user.apellidos || ""}" required>
            </div>
          </div>
        `
            : `
          <div class="form-row">
            <div class="form-group">
              <label for="denominacionComercial">Denominación Comercial</label>
              <input type="text" id="denominacionComercial" name="denominacionComercial" value="${user.denominacionComercial || ""}" required>
            </div>
            <div class="form-group">
              <label for="razonSocial">Razón Social</label>
              <input type="text" id="razonSocial" name="razonSocial" value="${user.razonSocial || ""}" required>
            </div>
          </div>
        `
        }
        
        <div class="form-group">
          <label for="email">Correo Electrónico</label>
          <input type="email" id="email" name="email" value="${user.email || ""}" required>
        </div>
        
        <button type="submit" class="btn btn-primary">Actualizar Perfil</button>
      </form>
    `
  }

  getDireccionesContent() {
    return `
      <div class="dashboard-welcome">
        <h2>Mis Direcciones</h2>
        <p>Gestiona las direcciones de entrega para tus pedidos.</p>
      </div>
      
      <div class="empty-state">
        <div class="empty-icon">
          <i class="fas fa-map-marker-alt"></i>
        </div>
        <h4>No tienes direcciones guardadas</h4>
        <p>Agrega direcciones de entrega para hacer más rápido el proceso de compra.</p>
        <button class="btn btn-primary">Agregar Dirección</button>
      </div>
    `
  }

  getSeguridadContent() {
    return `
      <div class="dashboard-welcome">
        <h2>Seguridad</h2>
        <p>Cambia tu contraseña y gestiona la seguridad de tu cuenta.</p>
      </div>
      
      <form class="auth-form" id="changePasswordForm">
        <div class="form-group">
          <label for="currentPassword">Contraseña Actual</label>
          <div class="password-input">
            <input type="password" id="currentPassword" name="currentPassword" required>
            <button type="button" class="toggle-password">
              <i class="fas fa-eye"></i>
            </button>
          </div>
        </div>
        
        <div class="form-group">
          <label for="newPassword">Nueva Contraseña</label>
          <div class="password-input">
            <input type="password" id="newPassword" name="newPassword" required>
            <button type="button" class="toggle-password">
              <i class="fas fa-eye"></i>
            </button>
          </div>
        </div>
        
        <div class="form-group">
          <label for="confirmPassword">Confirmar Nueva Contraseña</label>
          <div class="password-input">
            <input type="password" id="confirmPassword" name="confirmPassword" required>
            <button type="button" class="toggle-password">
              <i class="fas fa-eye"></i>
            </button>
          </div>
        </div>
        
        <button type="submit" class="btn btn-primary">Cambiar Contraseña</button>
      </form>
    `
  }
}

// Initialize dashboard
document.addEventListener("DOMContentLoaded", () => {
  new DashboardManager()
})
