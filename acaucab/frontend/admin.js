class AdminPanel {
  constructor() {
    this.currentSection = "dashboard"
    this.API_BASE_URL = 'http://localhost:3000/api'
    this.currentUser = null
    this.init()
  }

  init() {
    this.checkAuth()
    this.setupEventListeners()
    this.loadDashboard()
    this.loadInitialData()
  }

  checkAuth() {
    const userData = localStorage.getItem("acaucab_current_user") || sessionStorage.getItem("acaucab_current_user")
    
    if (!userData) {
      window.location.href = "login.html"
      return
    }

    try {
      this.currentUser = JSON.parse(userData)
      
      if (!this.canAccessAdmin()) {
        this.showNotification("No tienes permisos para acceder al panel de administración", "error")
        setTimeout(() => {
          window.location.href = "products.html"
        }, 2000)
        return
      }

      this.updateUserInfo()
      this.setupMenuPermissions()
      
    } catch (error) {
      console.error("Error verificando autenticación:", error)
      window.location.href = "login.html"
    }
  }

  canAccessAdmin() {
    if (!this.currentUser || !this.currentUser.role) return false
    return this.currentUser.role.name === 'Administrador' || this.currentUser.role.name === 'Supervisor'
  }

  hasPrivilege(privilegeName) {
    if (!this.currentUser || !this.currentUser.privileges) return false
    return this.currentUser.privileges.some(p => p.nombre_privilegio === privilegeName)
  }

  hasRole(roleName) {
    if (!this.currentUser || !this.currentUser.role) return false
    return this.currentUser.role.name === roleName
  }

  updateUserInfo() {
    const userInfoElement = document.getElementById("user-info")
    if (userInfoElement && this.currentUser) {
      userInfoElement.innerHTML = `
        <div class="user-details">
          <span class="user-name">${this.currentUser.fullName}</span>
          <span class="user-role">${this.currentUser.role.name}</span>
        </div>
      `
    }
  }

  setupMenuPermissions() {
    const menuItems = {
      'usuarios': this.hasRole('Administrador') || this.hasPrivilege('Gestionar Usuarios'),
      'empleados': this.hasRole('Administrador') || this.hasPrivilege('Gestionar Usuarios'),
      'roles': this.hasRole('Administrador'),
      'reportes': this.hasPrivilege('Ver Reportes')
    }

    Object.entries(menuItems).forEach(([section, hasPermission]) => {
      const menuItem = document.querySelector(`[data-section="${section}"]`)
      if (menuItem) {
        if (!hasPermission) {
          menuItem.style.display = 'none'
        }
      }
    })

    this.setupActionPermissions()
  }

  setupActionPermissions() {
    const addButtons = {
      'add-usuario-btn': this.hasRole('Administrador') || this.hasPrivilege('Gestionar Usuarios'),
      'add-empleado-btn': this.hasRole('Administrador') || this.hasPrivilege('Gestionar Usuarios'),
      'add-rol-btn': this.hasRole('Administrador')
    }

    Object.entries(addButtons).forEach(([buttonId, hasPermission]) => {
      const button = document.getElementById(buttonId)
      if (button) {
        button.style.display = hasPermission ? 'block' : 'none'
      }
    })
  }

  setupEventListeners() {
    document.querySelectorAll(".menu-item").forEach((item) => {
      item.addEventListener("click", (e) => {
        e.preventDefault()
        const section = item.dataset.section
        
        if (!this.canAccessSection(section)) {
          this.showNotification("No tienes permisos para acceder a esta sección", "error")
          return
        }
        
        this.showSection(section)
      })
    })

    const refreshBtn = document.getElementById("refresh-btn")
    if (refreshBtn) {
      refreshBtn.addEventListener("click", () => {
      this.refreshCurrentSection()
    })
    }

    this.setupModalForms()

    const addButtons = {
      'add-usuario-btn': () => this.openUsuarioModal(),
      'add-empleado-btn': () => this.openEmpleadoModal(),
      'add-rol-btn': () => this.openRolModal()
    }

    Object.entries(addButtons).forEach(([buttonId, handler]) => {
      const button = document.getElementById(buttonId)
      if (button) {
        button.addEventListener("click", handler)
      }
    })

    // Event listener para guardar permisos
    const savePermisosBtn = document.getElementById("save-permisos-btn")
    if (savePermisosBtn) {
      savePermisosBtn.addEventListener("click", () => {
        this.savePermisos()
      })
    }

    const logoutBtn = document.getElementById("logoutBtn")
    if (logoutBtn) {
      logoutBtn.addEventListener("click", (e) => {
        e.preventDefault()
        this.logout()
      })
    }
  }

  canAccessSection(section) {
    switch (section) {
      case 'dashboard':
        return this.canAccessAdmin()
      case 'usuarios':
        return this.hasRole('Administrador') || this.hasPrivilege('Gestionar Usuarios')
      case 'empleados':
        return this.hasRole('Administrador') || this.hasPrivilege('Gestionar Usuarios')
      case 'roles':
        return this.hasRole('Administrador')
      case 'permisos':
        return this.hasRole('Administrador')
      case 'reportes':
        return this.hasPrivilege('Ver Reportes')
      default:
        return this.hasPrivilege('Acceso Básico')
    }
  }

  setupModalForms() {
    const usuarioForm = document.getElementById("usuario-form")
    if (usuarioForm) {
      usuarioForm.addEventListener("submit", (e) => {
      e.preventDefault()
        this.saveUsuario()
    })
    }

    const empleadoForm = document.getElementById("empleado-form")
    if (empleadoForm) {
      empleadoForm.addEventListener("submit", (e) => {
      e.preventDefault()
      this.saveEmpleado()
    })
    }

    const rolForm = document.getElementById("rol-form")
    if (rolForm) {
      rolForm.addEventListener("submit", (e) => {
        e.preventDefault()
        this.saveRol()
      })
    }
  }

  showSection(section) {
    document.querySelectorAll(".menu-item").forEach((item) => {
      item.classList.remove("active")
    })
    const activeMenuItem = document.querySelector(`[data-section="${section}"]`)
    if (activeMenuItem) {
      activeMenuItem.classList.add("active")
    }

    document.querySelectorAll(".content-section").forEach((sec) => {
      sec.classList.remove("active")
    })
    const activeSection = document.getElementById(`${section}-section`)
    if (activeSection) {
      activeSection.classList.add("active")
    }

    const titles = {
      dashboard: "Dashboard",
      usuarios: "Gestión de Usuarios",
      empleados: "Gestión de Empleados",
      roles: "Gestión de Roles",
      permisos: "Gestión de Permisos por Rol",
      reportes: "Reportes"
    }
    const titleElement = document.getElementById("page-title")
    if (titleElement) {
      titleElement.textContent = titles[section] || section
    }

    this.currentSection = section
    this.loadSectionData(section)
  }

  async loadSectionData(section) {
    switch (section) {
      case 'dashboard':
        await this.loadDashboard()
        break
      case 'usuarios':
        await this.loadUsuarios()
        break
      case 'empleados':
        await this.loadEmpleados()
        break
      case 'roles':
        await this.loadRoles()
        break
      case 'permisos':
        await this.loadPermisos()
        break
      case 'reportes':
        await this.loadReportes()
        break
    }
  }

  refreshCurrentSection() {
    this.loadSectionData(this.currentSection)
    this.showNotification("Datos actualizados", "success")
  }

  async loadInitialData() {
    await this.loadEmpleados()
    await this.loadRoles()
    await this.loadCervezas()
  }

  async loadDashboard() {
    try {
      const response = await fetch(`${this.API_BASE_URL}/dashboard/stats`)
      const data = await response.json()

      const statsElements = {
        'total-usuarios': data.totalUsuarios,
        'total-empleados': data.totalEmpleados,
        'total-roles': data.totalRoles
      }

      Object.entries(statsElements).forEach(([elementId, value]) => {
        const element = document.getElementById(elementId)
        if (element) {
          element.textContent = value
        }
      })
    } catch (error) {
      console.error("Error loading dashboard:", error)
      this.showNotification("Error al cargar dashboard", "error")
    }
  }

  async loadUsuarios() {
    try {
      const response = await fetch(`${this.API_BASE_URL}/usuarios`)
      const usuarios = await response.json()

      const tbody = document.getElementById("usuarios-table-body")
      if (!tbody) return

      tbody.innerHTML = ""

      usuarios.forEach((usuario) => {
        const row = document.createElement("tr")
        row.innerHTML = `
          <td>${usuario.usuario_id}</td>
          <td>${usuario.nombre_usuario}</td>
          <td>${usuario.nombre_empleado}</td>
          <td>${usuario.nombre_rol}</td>
          <td>${usuario.estado}</td>
                    <td class="action-buttons">
            ${this.canEditUsuario() ? `
              <button class="btn btn-warning" onclick="adminPanel.editUsuario(${usuario.usuario_id})">
                            <i class="fas fa-edit"></i>
                        </button>
            ` : ''}
            ${this.canDeleteUsuario() ? `
              <button class="btn btn-danger" onclick="adminPanel.deleteUsuario(${usuario.usuario_id})">
                            <i class="fas fa-trash"></i>
                        </button>
            ` : ''}
                    </td>
                `
        tbody.appendChild(row)
      })
    } catch (error) {
      console.error("Error loading usuarios:", error)
      this.showNotification("Error al cargar usuarios", "error")
    }
  }

  canEditUsuario() {
    return this.hasRole('Administrador') || this.hasPrivilege('Gestionar Usuarios')
  }

  canDeleteUsuario() {
    return this.hasRole('Administrador')
  }

  openUsuarioModal(usuario = null) {
    const modal = document.getElementById("usuario-modal")
    if (modal) {
      modal.style.display = "block"
      
      if (usuario) {
        this.fillUsuarioForm(usuario)
      } else {
        this.clearUsuarioForm()
      }
    }
  }

  clearUsuarioForm() {
    const form = document.getElementById("usuario-form")
    if (form) {
      form.reset()
      form.dataset.mode = "create"
      form.dataset.usuarioId = ""
    }
  }

  async fillUsuarioForm(usuario) {
    const form = document.getElementById("usuario-form")
    if (!form) return

    form.dataset.mode = "edit"
    form.dataset.usuarioId = usuario.usuario_id

    const fields = {
      'usuario-empleado': usuario.empleado_id,
      'usuario-rol': usuario.rol_id,
      'usuario-nombre': usuario.nombre_usuario,
      'usuario-contraseña': usuario.contraseña_usuario
    }

    Object.entries(fields).forEach(([fieldId, value]) => {
      const field = document.getElementById(fieldId)
      if (field) {
        field.value = value || ""
      }
    })
  }

  async editUsuario(id) {
    try {
      const response = await fetch(`${this.API_BASE_URL}/usuarios/${id}`)
      if (response.ok) {
        const usuario = await response.json()
        this.openUsuarioModal(usuario)
      } else {
        this.showNotification("Error al cargar usuario", "error")
      }
    } catch (error) {
      console.error("Error editing usuario:", error)
      this.showNotification("Error al editar usuario", "error")
    }
  }

  async saveUsuario() {
    const form = document.getElementById("usuario-form")
    if (!form) return

    const formData = new FormData(form)
    const mode = form.dataset.mode
    const usuarioId = form.dataset.usuarioId

    const userData = {
      empleadoId: formData.get("empleado"),
      rolId: formData.get("rol"),
      nombreUsuario: formData.get("nombre"),
      contraseñaUsuario: formData.get("contraseña")
    }

    try {
      const url = mode === "edit" 
        ? `${this.API_BASE_URL}/usuarios/${usuarioId}`
        : `${this.API_BASE_URL}/usuarios`
      
      const method = mode === "edit" ? "PUT" : "POST"

      const response = await fetch(url, {
        method: method,
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(userData)
      })

      if (response.ok) {
        this.showNotification(`Usuario ${mode === "edit" ? "actualizado" : "creado"} exitosamente`, "success")
        this.closeModal("usuario-modal")
        this.loadUsuarios()
      } else {
        const error = await response.json()
        this.showNotification(error.error || "Error al guardar usuario", "error")
      }
    } catch (error) {
      console.error("Error saving usuario:", error)
      this.showNotification("Error al guardar usuario", "error")
    }
  }

  async deleteUsuario(id) {
    if (!confirm("¿Estás seguro de que quieres eliminar este usuario?")) {
      return
    }

    try {
      const response = await fetch(`${this.API_BASE_URL}/usuarios/${id}`, {
        method: "DELETE"
      })

      if (response.ok) {
        this.showNotification("Usuario eliminado exitosamente", "success")
        this.loadUsuarios()
      } else {
        const error = await response.json()
        this.showNotification(error.error || "Error al eliminar usuario", "error")
      }
    } catch (error) {
      console.error("Error deleting usuario:", error)
      this.showNotification("Error al eliminar usuario", "error")
    }
  }

  async loadEmpleados() {
    try {
      const response = await fetch(`${this.API_BASE_URL}/empleados`)
      const empleados = await response.json()

      const tbody = document.getElementById("empleados-table-body")
      if (!tbody) return

      tbody.innerHTML = ""

      empleados.forEach((empleado) => {
        const row = document.createElement("tr")
        row.innerHTML = `
                    <td>${empleado.empleado_id}</td>
          <td>${empleado.cédula_identidad}</td>
          <td>${empleado.nombre_completo}</td>
          <td>${empleado.fecha_ingreso}</td>
          <td>$${empleado.salario}</td>
                    <td class="action-buttons">
            ${this.canEditEmpleado() ? `
                        <button class="btn btn-warning" onclick="adminPanel.editEmpleado(${empleado.empleado_id})">
                            <i class="fas fa-edit"></i>
                        </button>
            ` : ''}
            ${this.canDeleteEmpleado() ? `
                        <button class="btn btn-danger" onclick="adminPanel.deleteEmpleado(${empleado.empleado_id})">
                            <i class="fas fa-trash"></i>
                        </button>
            ` : ''}
                    </td>
                `
        tbody.appendChild(row)
      })

      this.fillEmpleadosSelect(empleados)
    } catch (error) {
      console.error("Error loading empleados:", error)
      this.showNotification("Error al cargar empleados", "error")
    }
  }

  canEditEmpleado() {
    return this.hasRole('Administrador') || this.hasPrivilege('Gestionar Usuarios')
  }

  canDeleteEmpleado() {
    return this.hasRole('Administrador')
  }

  fillEmpleadosSelect(empleados) {
    const select = document.getElementById("usuario-empleado")
    if (!select) return

    select.innerHTML = '<option value="">Seleccionar empleado...</option>'
    empleados.forEach((empleado) => {
      const option = document.createElement("option")
      option.value = empleado.empleado_id
      option.textContent = empleado.nombre_completo
      select.appendChild(option)
    })
  }

  openEmpleadoModal(empleado = null) {
    const modal = document.getElementById("empleado-modal")
    if (modal) {
      modal.style.display = "block"

    if (empleado) {
      this.fillEmpleadoForm(empleado)
    } else {
        this.clearEmpleadoForm()
      }
    }
  }

  clearEmpleadoForm() {
    const form = document.getElementById("empleado-form")
    if (form) {
      form.reset()
      form.dataset.mode = "create"
      form.dataset.empleadoId = ""
    }
  }

  fillEmpleadoForm(empleado) {
    const form = document.getElementById("empleado-form")
    if (!form) return

    form.dataset.mode = "edit"
    form.dataset.empleadoId = empleado.empleado_id

    const fields = {
      'empleado-cedula': empleado.cédula_identidad,
      'empleado-primer-nombre': empleado.primer_nombre,
      'empleado-segundo-nombre': empleado.segundo_nombre || "",
      'empleado-primer-apellido': empleado.primer_apellido,
      'empleado-segundo-apellido': empleado.segundo_apellido || "",
      'empleado-fecha-ingreso': empleado.fecha_ingreso,
      'empleado-salario': empleado.salario
    }

    Object.entries(fields).forEach(([fieldId, value]) => {
      const field = document.getElementById(fieldId)
      if (field) {
        field.value = value || ""
      }
    })
  }

  async editEmpleado(id) {
    try {
      const response = await fetch(`${this.API_BASE_URL}/empleados/${id}`)
      if (response.ok) {
      const empleado = await response.json()
      this.openEmpleadoModal(empleado)
      } else {
      this.showNotification("Error al cargar empleado", "error")
      }
    } catch (error) {
      console.error("Error editing empleado:", error)
      this.showNotification("Error al editar empleado", "error")
    }
  }

  async saveEmpleado() {
    const form = document.getElementById("empleado-form")
    if (!form) return

    const formData = new FormData(form)
    const mode = form.dataset.mode
    const empleadoId = form.dataset.empleadoId

    const empleadoData = {
      cédula_identidad: formData.get("cedula"),
      primer_nombre: formData.get("primerNombre"),
      segundo_nombre: formData.get("segundoNombre"),
      primer_apellido: formData.get("primerApellido"),
      segundo_apellido: formData.get("segundoApellido"),
      fecha_ingreso: formData.get("fechaIngreso"),
      salario: parseFloat(formData.get("salario"))
    }

    try {
      const url = mode === "edit" 
        ? `${this.API_BASE_URL}/empleados/${empleadoId}`
        : `${this.API_BASE_URL}/empleados`
      
      const method = mode === "edit" ? "PUT" : "POST"

      const response = await fetch(url, {
        method: method,
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(empleadoData)
      })

      if (response.ok) {
        this.showNotification(`Empleado ${mode === "edit" ? "actualizado" : "creado"} exitosamente`, "success")
        this.closeModal("empleado-modal")
        this.loadEmpleados()
      } else {
        const error = await response.json()
        this.showNotification(error.error || "Error al guardar empleado", "error")
      }
    } catch (error) {
      console.error("Error saving empleado:", error)
      this.showNotification("Error al guardar empleado", "error")
    }
  }

  async deleteEmpleado(id) {
    if (!confirm("¿Estás seguro de que quieres eliminar este empleado?")) {
      return
    }

    try {
      const response = await fetch(`${this.API_BASE_URL}/empleados/${id}`, {
        method: "DELETE"
      })

      if (response.ok) {
        this.showNotification("Empleado eliminado exitosamente", "success")
        this.loadEmpleados()
      } else {
        const error = await response.json()
        this.showNotification(error.error || "Error al eliminar empleado", "error")
      }
    } catch (error) {
      console.error("Error deleting empleado:", error)
      this.showNotification("Error al eliminar empleado", "error")
    }
  }

  async loadRoles() {
    try {
      const response = await fetch(`${this.API_BASE_URL}/roles`)
      const roles = await response.json()

      const tbody = document.getElementById("roles-table-body")
      if (!tbody) return

      tbody.innerHTML = ""

      roles.forEach((rol) => {
        const row = document.createElement("tr")
        row.innerHTML = `
          <td>${rol.rol_id}</td>
          <td>${rol.nombre_rol}</td>
          <td>${rol.descripción_rol}</td>
                    <td class="action-buttons">
            ${this.canEditRol() ? `
              <button class="btn btn-info" onclick="adminPanel.verPermisosRol(${rol.rol_id}, '${rol.nombre_rol}')" title="Ver Permisos">
                <i class="fas fa-eye"></i>
              </button>
              <button class="btn btn-warning" onclick="adminPanel.editRol(${rol.rol_id})">
                <i class="fas fa-edit"></i>
              </button>
            ` : ''}
            ${this.canDeleteRol() ? `
              <button class="btn btn-danger" onclick="adminPanel.deleteRol(${rol.rol_id})">
                            <i class="fas fa-trash"></i>
                        </button>
            ` : ''}
                    </td>
                `
        tbody.appendChild(row)
      })

      this.fillRolesSelect(roles)
    } catch (error) {
      console.error("Error loading roles:", error)
      this.showNotification("Error al cargar roles", "error")
    }
  }

  canEditRol() {
    return this.hasRole('Administrador')
  }

  canDeleteRol() {
    return this.hasRole('Administrador')
  }

  fillRolesSelect(roles) {
    const select = document.getElementById("usuario-rol")
    if (!select) return

    select.innerHTML = '<option value="">Seleccionar rol...</option>'
    roles.forEach((rol) => {
      const option = document.createElement("option")
      option.value = rol.rol_id
      option.textContent = rol.nombre_rol
      select.appendChild(option)
    })
  }

  async loadCervezas() {
    try {
      const response = await fetch(`${this.API_BASE_URL}/cervezas`)
      const cervezas = await response.json()

      const tbody = document.getElementById("cervezas-table-body")
      if (!tbody) return

      tbody.innerHTML = ""

      cervezas.forEach((cerveza) => {
        const row = document.createElement("tr")
        row.innerHTML = `
          <td>${cerveza.cerveza_id}</td>
          <td>${cerveza.nombre_cerveza}</td>
          <td>${cerveza.descripción || "N/A"}</td>
          <td>${cerveza.tipo_cerveza}</td>
          <td>${cerveza.presentacion}</td>
                    <td class="action-buttons">
            ${this.canEditCerveza() ? `
              <button class="btn btn-warning" onclick="adminPanel.editCerveza(${cerveza.cerveza_id})">
                <i class="fas fa-edit"></i>
              </button>
            ` : ''}
            ${this.canDeleteCerveza() ? `
              <button class="btn btn-danger" onclick="adminPanel.deleteCerveza(${cerveza.cerveza_id})">
                            <i class="fas fa-trash"></i>
                        </button>
            ` : ''}
                    </td>
                `
        tbody.appendChild(row)
      })
    } catch (error) {
      console.error("Error loading cervezas:", error)
      this.showNotification("Error al cargar cervezas", "error")
    }
  }

  canEditCerveza() {
    return this.hasPrivilege('Gestionar Productos')
  }

  canDeleteCerveza() {
    return this.hasPrivilege('Gestionar Productos')
  }

  async loadReportes() {
    // La funcionalidad de reportes ya está implementada en el HTML
    // Los botones llaman a adminPanel.generateReport() con diferentes parámetros
    console.log("Sección de reportes cargada")
  }

  closeModal(modalId) {
    const modal = document.getElementById(modalId)
    if (modal) {
      modal.style.display = "none"
    }
  }

  showNotification(message, type = "info") {
    const notification = document.getElementById("notification")
    if (!notification) return

    notification.textContent = message
    notification.className = `notification ${type}`
    notification.style.display = "block"

    setTimeout(() => {
      notification.style.display = "none"
    }, 3000)
  }

  logout() {
    this.currentUser = null
    localStorage.removeItem("acaucab_current_user")
    sessionStorage.removeItem("acaucab_current_user")
    
    this.showNotification("Sesión cerrada", "info")
    
    setTimeout(() => {
      window.location.href = "login.html"
    }, 1000)
  }

  openRolModal(rol = null) {
    const modal = document.getElementById("rol-modal")
    if (modal) {
      modal.style.display = "block"
      
      if (rol) {
        this.fillRolForm(rol)
      } else {
        this.clearRolForm()
      }
    }
  }

  clearRolForm() {
    const form = document.getElementById("rol-form")
    if (form) {
      form.reset()
      form.dataset.mode = "create"
      form.dataset.rolId = ""
    }
  }

  fillRolForm(rol) {
    const form = document.getElementById("rol-form")
    if (!form) return

    form.dataset.mode = "edit"
    form.dataset.rolId = rol.rol_id

    const fields = {
      'rol-nombre': rol.nombre_rol,
      'rol-descripcion': rol.descripción_rol
    }

    Object.entries(fields).forEach(([fieldId, value]) => {
      const field = document.getElementById(fieldId)
      if (field) {
        field.value = value || ""
      }
    })
  }

  async editRol(id) {
    try {
      const response = await fetch(`${this.API_BASE_URL}/roles/${id}`)
      if (response.ok) {
        const rol = await response.json()
        this.openRolModal(rol)
      } else {
        this.showNotification("Error al cargar rol", "error")
      }
    } catch (error) {
      console.error("Error editing rol:", error)
      this.showNotification("Error al editar rol", "error")
    }
  }

  async saveRol() {
    const form = document.getElementById("rol-form")
    if (!form) return

    const formData = new FormData(form)
    const mode = form.dataset.mode
    const rolId = form.dataset.rolId

    const rolData = {
      nombre_rol: formData.get("nombre"),
      descripción_rol: formData.get("descripcion")
    }

    try {
      const url = mode === "edit" 
        ? `${this.API_BASE_URL}/roles/${rolId}`
        : `${this.API_BASE_URL}/roles`
      
      const method = mode === "edit" ? "PUT" : "POST"

      const response = await fetch(url, {
        method: method,
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(rolData)
      })

      if (response.ok) {
        this.showNotification(`Rol ${mode === "edit" ? "actualizado" : "creado"} exitosamente`, "success")
        this.closeModal("rol-modal")
        this.loadRoles()
      } else {
        const error = await response.json()
        this.showNotification(error.error || "Error al guardar rol", "error")
      }
    } catch (error) {
      console.error("Error saving rol:", error)
      this.showNotification("Error al guardar rol", "error")
    }
  }

  async deleteRol(id) {
    if (!confirm("¿Estás seguro de que quieres eliminar este rol?")) {
      return
    }

    try {
      const response = await fetch(`${this.API_BASE_URL}/roles/${id}`, {
        method: "DELETE"
      })

      if (response.ok) {
        this.showNotification("Rol eliminado exitosamente", "success")
        this.loadRoles()
      } else {
        const error = await response.json()
        this.showNotification(error.error || "Error al eliminar rol", "error")
      }
    } catch (error) {
      console.error("Error deleting rol:", error)
      this.showNotification("Error al eliminar rol", "error")
    }
  }

  openCervezaModal(cerveza = null) {
    const modal = document.getElementById("cerveza-modal")
    if (modal) {
      modal.style.display = "block"
      
      if (cerveza) {
        this.fillCervezaForm(cerveza)
      } else {
        this.clearCervezaForm()
      }
    }
  }

  clearCervezaForm() {
    const form = document.getElementById("cerveza-form")
    if (form) {
      form.reset()
      form.dataset.mode = "create"
      form.dataset.cervezaId = ""
    }
  }

  fillCervezaForm(cerveza) {
    const form = document.getElementById("cerveza-form")
    if (!form) return

    form.dataset.mode = "edit"
    form.dataset.cervezaId = cerveza.cerveza_id

    const fields = {
      'cerveza-nombre': cerveza.nombre_cerveza,
      'cerveza-descripcion': cerveza.descripción || "",
      'cerveza-tipo': cerveza.tipo_cerveza_id || "",
      'cerveza-presentacion': cerveza.presentación_id || ""
    }

    Object.entries(fields).forEach(([fieldId, value]) => {
      const field = document.getElementById(fieldId)
      if (field) {
        field.value = value || ""
      }
    })
  }

  async editCerveza(id) {
    try {
      const response = await fetch(`${this.API_BASE_URL}/cervezas/${id}`)
      if (response.ok) {
        const cerveza = await response.json()
        this.openCervezaModal(cerveza)
      } else {
        this.showNotification("Error al cargar cerveza", "error")
      }
    } catch (error) {
      console.error("Error editing cerveza:", error)
      this.showNotification("Error al editar cerveza", "error")
    }
  }

  async saveCerveza() {
    const form = document.getElementById("cerveza-form")
    if (!form) return

    const formData = new FormData(form)
    const mode = form.dataset.mode
    const cervezaId = form.dataset.cervezaId

    const cervezaData = {
      nombre_cerveza: formData.get("nombre"),
      descripción: formData.get("descripcion"),
      tipo_cerveza_id: formData.get("tipo") || null,
      presentación_id: formData.get("presentacion") || null
    }

    try {
      const url = mode === "edit" 
        ? `${this.API_BASE_URL}/cervezas/${cervezaId}`
        : `${this.API_BASE_URL}/cervezas`
      
      const method = mode === "edit" ? "PUT" : "POST"

      const response = await fetch(url, {
        method: method,
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(cervezaData)
      })

      if (response.ok) {
        this.showNotification(`Cerveza ${mode === "edit" ? "actualizada" : "creada"} exitosamente`, "success")
        this.closeModal("cerveza-modal")
        this.loadCervezas()
      } else {
        const error = await response.json()
        this.showNotification(error.error || "Error al guardar cerveza", "error")
      }
    } catch (error) {
      console.error("Error saving cerveza:", error)
      this.showNotification("Error al guardar cerveza", "error")
    }
  }

  async deleteCerveza(id) {
    if (!confirm("¿Estás seguro de que quieres eliminar esta cerveza?")) {
      return
    }

    try {
      const response = await fetch(`${this.API_BASE_URL}/cervezas/${id}`, {
        method: "DELETE"
      })

      if (response.ok) {
        this.showNotification("Cerveza eliminada exitosamente", "success")
        this.loadCervezas()
      } else {
        const error = await response.json()
        this.showNotification(error.error || "Error al eliminar cerveza", "error")
      }
    } catch (error) {
      console.error("Error deleting cerveza:", error)
      this.showNotification("Error al eliminar cerveza", "error")
    }
  }

  generateEmployeeReport() {
    this.showNotification("Generando reporte de empleados...", "info")
    // Implementar generación de reporte
  }

  generateReport(reportType) {
    switch (reportType) {
      case 'ranking-proveedores':
        this.showNotification("Generando ranking de miembros proveedores...", "info")
        // TODO: Implementar reporte de ranking de proveedores
      break
      case 'puntos-canjeados':
        this.showNotification("Generando reporte de puntos canjeados...", "info")
        // TODO: Implementar reporte de puntos canjeados
      break
      case 'flujo-pago':
        this.showNotification("Generando reporte de flujo de pago...", "info")
        // TODO: Implementar reporte de flujo de pago
      break
      case 'duracion-pedidos':
        this.showNotification("Generando reporte de duración de pedidos...", "info")
        // TODO: Implementar reporte de duración de pedidos
      break
      case 'incumplimientos-horarios':
        this.showNotification("Generando reporte de incumplimientos horarios...", "info")
        // TODO: Implementar reporte de incumplimientos horarios
      break
      default:
        this.showNotification("Tipo de reporte no reconocido", "error")
    }
  }

  async loadPermisos() {
    try {
      // Cargar roles para el selector
      const rolesResponse = await fetch(`${this.API_BASE_URL}/roles`)
      const roles = await rolesResponse.json()
      
      this.fillRolesSelector(roles)
      
      // Cargar todas las tablas de la base de datos
      const tablesResponse = await fetch(`${this.API_BASE_URL}/tables`)
      const tables = await tablesResponse.json()
      
      this.renderPermisosGrid(tables)
      
    } catch (error) {
      console.error("Error loading permisos:", error)
      this.showNotification("Error al cargar permisos", "error")
    }
  }

  fillRolesSelector(roles) {
    const selector = document.getElementById("rol-selector")
    if (!selector) return

    selector.innerHTML = '<option value="">Seleccionar rol...</option>'
    roles.forEach((rol) => {
      const option = document.createElement("option")
      option.value = rol.rol_id
      option.textContent = rol.nombre_rol
      selector.appendChild(option)
    })

    // Agregar event listener para cambiar rol
    selector.addEventListener('change', (e) => {
      const rolId = e.target.value
      if (rolId) {
        this.loadRolPermisos(rolId)
        document.getElementById("save-permisos-btn").disabled = false
      } else {
        this.clearPermisosGrid()
        document.getElementById("save-permisos-btn").disabled = true
      }
    })
  }

  renderPermisosGrid(tables) {
    const grid = document.getElementById("permisos-grid")
    if (!grid) return

    grid.innerHTML = ""

    tables.forEach((table) => {
      const card = this.createPermisoCard(table)
      grid.appendChild(card)
    })
  }

  createPermisoCard(table) {
    const card = document.createElement("div")
    card.className = "permiso-card"
    card.dataset.table = table

    const tableName = table.charAt(0).toUpperCase() + table.slice(1).replace(/_/g, ' ')
    
    card.innerHTML = `
      <div class="permiso-header">
        <div class="permiso-icon">
          <i class="fas fa-table"></i>
        </div>
        <div>
          <h4 class="permiso-title">${tableName}</h4>
          <p class="permiso-description">Tabla: ${table}</p>
        </div>
      </div>
      
      <div class="crud-permissions">
        <div class="crud-permission create">
          <input type="checkbox" id="${table}-create" data-operation="create">
          <label for="${table}-create">Crear</label>
        </div>
        <div class="crud-permission read">
          <input type="checkbox" id="${table}-read" data-operation="read">
          <label for="${table}-read">Leer</label>
        </div>
        <div class="crud-permission update">
          <input type="checkbox" id="${table}-update" data-operation="update">
          <label for="${table}-update">Actualizar</label>
        </div>
        <div class="crud-permission delete">
          <input type="checkbox" id="${table}-delete" data-operation="delete">
          <label for="${table}-delete">Eliminar</label>
        </div>
      </div>
      
      <div class="permiso-stats">
        <span class="active">0 activos</span>
        <span class="inactive">4 total</span>
      </div>
    `

    // Agregar event listeners a los checkboxes
    const checkboxes = card.querySelectorAll('input[type="checkbox"]')
    checkboxes.forEach(checkbox => {
      checkbox.addEventListener('change', () => {
        this.updatePermisosStats()
      })
    })

    return card
  }

  async loadRolPermisos(rolId) {
    try {
      const response = await fetch(`${this.API_BASE_URL}/roles/${rolId}/permisos`)
    const data = await response.json()

      this.updatePermisosGrid(data.privilegios)
      
    } catch (error) {
      console.error("Error loading rol permisos:", error)
      this.showNotification("Error al cargar permisos del rol", "error")
    }
  }

  updatePermisosGrid(privilegios) {
    // Limpiar todos los checkboxes
    const checkboxes = document.querySelectorAll('.crud-permission input[type="checkbox"]')
    checkboxes.forEach(checkbox => {
      checkbox.checked = false
    })

    // Marcar los privilegios que tiene el rol
    privilegios.forEach(privilegio => {
      const nombre = privilegio.nombre_privilegio
      const parts = nombre.split('_')
      
      if (parts.length >= 2) {
        const tabla = parts[0]
        const operacion = parts[1].toLowerCase()
        
        const checkbox = document.getElementById(`${tabla}-${operacion}`)
        if (checkbox) {
          checkbox.checked = true
        }
      }
    })

    // Actualizar estadísticas
    this.updatePermisosStats()
  }

  updatePermisosStats() {
    const cards = document.querySelectorAll('.permiso-card')
    
    cards.forEach(card => {
      const table = card.dataset.table
      const checkboxes = card.querySelectorAll('input[type="checkbox"]')
      const activos = Array.from(checkboxes).filter(cb => cb.checked).length
      const total = checkboxes.length
      
      const stats = card.querySelector('.permiso-stats')
      if (stats) {
        stats.innerHTML = `
          <span class="active">${activos} activos</span>
          <span class="inactive">${total} total</span>
        `
      }
    })
  }

  clearPermisosGrid() {
    const checkboxes = document.querySelectorAll('.crud-permission input[type="checkbox"]')
    checkboxes.forEach(checkbox => {
      checkbox.checked = false
    })
    
    this.updatePermisosStats()
  }

  async savePermisos() {
    const rolId = document.getElementById("rol-selector").value
    if (!rolId) {
      this.showNotification("Selecciona un rol primero", "warning")
      return
    }

    try {
      const permisos = this.collectPermisosData()
      
      const response = await fetch(`${this.API_BASE_URL}/roles/${rolId}/permisos-crud`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ permisos })
      })

      if (response.ok) {
        this.showNotification("Permisos guardados exitosamente", "success")
        // Recargar permisos para confirmar
        await this.loadRolPermisos(rolId)
      } else {
        const error = await response.json()
        this.showNotification(error.error || "Error al guardar permisos", "error")
      }
    } catch (error) {
      console.error("Error saving permisos:", error)
      this.showNotification("Error al guardar permisos", "error")
    }
  }

  collectPermisosData() {
    const permisos = []
    const cards = document.querySelectorAll('.permiso-card')
    
    cards.forEach(card => {
      const table = card.dataset.table
      const checkboxes = card.querySelectorAll('input[type="checkbox"]')
      
      const permiso = {
        tabla: table,
        create: false,
        read: false,
        update: false,
        delete: false
      }
      
      checkboxes.forEach(checkbox => {
        const operation = checkbox.dataset.operation
        if (operation && permiso.hasOwnProperty(operation)) {
          permiso[operation] = checkbox.checked
        }
      })
      
      permisos.push(permiso)
    })
    
    return permisos
  }

  async verPermisosRol(rolId, rolNombre) {
    try {
      // Obtener información del rol
      const rolResponse = await fetch(`${this.API_BASE_URL}/roles/${rolId}`)
      if (!rolResponse.ok) {
        this.showNotification("Error al cargar información del rol", "error")
        return
      }
      const rol = await rolResponse.json()

      // Obtener permisos del rol
      const permisosResponse = await fetch(`${this.API_BASE_URL}/roles/${rolId}/permisos`)
      if (!permisosResponse.ok) {
        this.showNotification("Error al cargar permisos del rol", "error")
        return
      }
      const permisosData = await permisosResponse.json()

      // Obtener usuarios con este rol
      const usuariosResponse = await fetch(`${this.API_BASE_URL}/usuarios`)
      if (!usuariosResponse.ok) {
        this.showNotification("Error al cargar usuarios", "error")
        return
      }
      const usuarios = await usuariosResponse.json()
      const usuariosConRol = usuarios.filter(u => u.rol_id == rolId)

      // Llenar el modal con la información
      this.fillVerPermisosModal(rol, permisosData.privilegios, usuariosConRol)
      
      // Mostrar el modal
      const modal = document.getElementById("ver-permisos-modal")
      if (modal) {
        modal.style.display = "block"
      }

  } catch (error) {
      console.error("Error verificando permisos del rol:", error)
      this.showNotification("Error al cargar permisos del rol", "error")
    }
  }

  fillVerPermisosModal(rol, privilegios, usuariosConRol) {
    // Información del rol
    document.getElementById("rol-nombre-info").textContent = rol.nombre_rol
    document.getElementById("rol-descripcion-info").textContent = rol.descripción_rol

    // Lista de privilegios
    const privilegiosLista = document.getElementById("privilegios-lista")
    if (privilegios.length === 0) {
      privilegiosLista.innerHTML = '<p class="text-muted">No tiene privilegios asignados</p>'
    } else {
      privilegiosLista.innerHTML = privilegios.map(privilegio => `
        <div class="privilegio-item">
          <div class="privilegio-icon">
            <i class="fas fa-check"></i>
          </div>
          <div class="privilegio-text">
            <strong>${privilegio.nombre_privilegio}</strong><br>
            <small>${privilegio.descripción_privilegio}</small>
          </div>
        </div>
      `).join('')
    }

    // Resumen CRUD por tabla
    const crudResumen = document.getElementById("crud-resumen")
    const crudPrivilegios = privilegios.filter(p => 
      p.nombre_privilegio.includes('_CREATE') || 
      p.nombre_privilegio.includes('_READ') || 
      p.nombre_privilegio.includes('_UPDATE') || 
      p.nombre_privilegio.includes('_DELETE')
    )

    if (crudPrivilegios.length === 0) {
      crudResumen.innerHTML = '<p class="text-muted">No tiene permisos CRUD configurados</p>'
    } else {
      // Agrupar por tabla
      const tablas = {}
      crudPrivilegios.forEach(privilegio => {
        const parts = privilegio.nombre_privilegio.split('_')
        if (parts.length >= 2) {
          const tabla = parts[0]
          const operacion = parts[1]
          
          if (!tablas[tabla]) {
            tablas[tabla] = []
          }
          tablas[tabla].push(operacion)
        }
      })

      crudResumen.innerHTML = Object.entries(tablas).map(([tabla, operaciones]) => `
        <div class="tabla-crud">
          <div class="tabla-nombre">${tabla}</div>
          <div class="operaciones-crud">
            ${operaciones.map(op => {
              const icon = {
                'CREATE': '✅',
                'READ': '👁️',
                'UPDATE': '✏️',
                'DELETE': '🗑️'
              }[op] || '❓'
              const clase = op.toLowerCase()
              return `<span class="operacion-badge ${clase}">${icon} ${op}</span>`
            }).join('')}
          </div>
        </div>
      `).join('')
    }

    // Lista de usuarios con este rol
    const usuariosLista = document.getElementById("usuarios-rol-lista")
    if (usuariosConRol.length === 0) {
      usuariosLista.innerHTML = '<p class="text-muted">No hay usuarios con este rol</p>'
    } else {
      usuariosLista.innerHTML = usuariosConRol.map(usuario => `
        <div class="usuario-item">
          <div class="usuario-avatar">
            ${usuario.nombre_empleado ? usuario.nombre_empleado.charAt(0).toUpperCase() : 'U'}
          </div>
          <div class="usuario-info">
            <div class="usuario-nombre">${usuario.nombre_empleado || 'N/A'}</div>
            <div class="usuario-username">@${usuario.nombre_usuario}</div>
          </div>
        </div>
      `).join('')
    }
  }

  editarPermisosRol() {
    // Cerrar el modal actual
    this.closeModal("ver-permisos-modal")
    
    // Obtener el ID del rol del título del modal
    const rolNombre = document.getElementById("rol-nombre-info").textContent
    
    // Buscar el rol en la lista de roles
    fetch(`${this.API_BASE_URL}/roles`)
      .then(response => response.json())
      .then(roles => {
        const rol = roles.find(r => r.nombre_rol === rolNombre)
        if (rol) {
          // Cambiar a la sección de permisos y seleccionar el rol
          this.showSection('permisos')
          setTimeout(() => {
            const selector = document.getElementById("rol-selector")
            if (selector) {
              selector.value = rol.rol_id
              selector.dispatchEvent(new Event('change'))
            }
          }, 100)
        }
      })
      .catch(error => {
        console.error("Error obteniendo roles:", error)
        this.showNotification("Error al cambiar a edición de permisos", "error")
      })
  }
}

const adminPanel = new AdminPanel() 