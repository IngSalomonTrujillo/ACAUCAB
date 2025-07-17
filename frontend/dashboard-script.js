// Dashboard Panel Manager
const dashboardPanel = {
    currentUser: null,
    currentSection: 'resumen',

  init() {
        this.checkAuth();
        this.bindEvents();
        this.loadUserData();
        this.loadStats();
        this.loadDashboardIndicators();
    },

  checkAuth() {
        const userData = localStorage.getItem('acaucab_user') || sessionStorage.getItem('acaucab_user');

    if (!userData) {
            window.location.href = 'login.html';
            return;
    }

        try {
            this.currentUser = JSON.parse(userData);
        } catch (error) {
            console.error('Error parsing user data:', error);
            window.location.href = 'login.html';
  }
    },

  bindEvents() {
        // Menu navigation
        document.querySelectorAll('.menu-item').forEach(item => {
            item.addEventListener('click', (e) => {
                e.preventDefault();
                const section = e.target.closest('.menu-item').dataset.section;
                this.showSection(section);
            });
        });

        // Logout button
        document.getElementById('logoutBtn').addEventListener('click', () => {
            this.logout();
        });

        // Refresh button
        document.getElementById('refresh-btn').addEventListener('click', () => {
            this.loadStats();
        });
    },

  loadUserData() {
        if (!this.currentUser) return;

        const userName = this.currentUser.type === 'natural' 
        ? `${this.currentUser.nombres} ${this.currentUser.apellidos}`
            : this.currentUser.denominacionComercial;

        // Update user info in header
        document.getElementById('user-info').textContent = `Usuario: ${userName}`;
        
        // Update welcome message
        const welcomeName = this.currentUser.type === 'natural' 
            ? this.currentUser.nombres 
            : this.currentUser.denominacionComercial;
        document.getElementById('welcomeUserName').textContent = welcomeName;

        // Update profile section
        document.getElementById('profile-name').textContent = userName;
        document.getElementById('profile-email').textContent = this.currentUser.email;
        document.getElementById('profile-type').textContent = 
            `Tipo de Cliente: ${this.currentUser.type === 'natural' ? 'Persona Natural' : 'Persona Jurídica'}`;
    },

    async loadStats() {
        try {
            // Simulate loading stats from API
            const stats = {
                pedidos: 0,
                puntos: 0,
                favoritos: 0,
                productos: 12 // Mock data
            };

            // Update stats display
            document.getElementById('total-pedidos').textContent = stats.pedidos;
            document.getElementById('total-puntos').textContent = stats.puntos;
            document.getElementById('total-favoritos').textContent = stats.favoritos;
            document.getElementById('total-productos').textContent = stats.productos;

            // Update puntos section
            document.getElementById('puntos-actuales').textContent = stats.puntos;
            
            // Calculate progress (0-100 points for next level)
            const progress = Math.min((stats.puntos % 100), 100);
            document.querySelector('.progress-fill').style.width = `${progress}%`;
            document.querySelector('.puntos-progress p').textContent = 
                `${stats.puntos % 100} / 100 puntos para el siguiente nivel`;

            this.showNotification('Datos actualizados correctamente', 'success');
        } catch (error) {
            console.error('Error loading stats:', error);
            this.showNotification('Error al cargar estadísticas', 'error');
        }
    },

    async loadDashboardIndicators() {
        try {
            // Obtener ventas totales por tienda (física y online)
            const params = new URLSearchParams();
            // Puedes agregar aquí filtros de fecha si lo deseas, por ejemplo:
            // params.append('fecha_inicio', '2024-01-01');
            // params.append('fecha_fin', '2024-12-31');
            const res = await fetch('http://localhost:3000/api/dashboard/ventas-totales?' + params.toString());
            const data = await res.json();

            // Sumar totales
            let totalFisica = 0;
            let totalOnline = 0;
            if (data.fisica) {
                totalFisica = data.fisica.reduce((acc, t) => acc + Number(t.total || 0), 0);
            }
            if (data.online) {
                totalOnline = data.online.reduce((acc, t) => acc + Number(t.total || 0), 0);
            }
            const total = totalFisica + totalOnline;

            // Mostrar en el dashboard
            const ventasTotalesElem = document.getElementById('ventas-totales');
            ventasTotalesElem.textContent = `$${total.toLocaleString(undefined, {minimumFractionDigits:2, maximumFractionDigits:2})}`;
            ventasTotalesElem.title = `Físicas: $${totalFisica.toLocaleString(undefined, {minimumFractionDigits:2, maximumFractionDigits:2})}\nOnline: $${totalOnline.toLocaleString(undefined, {minimumFractionDigits:2, maximumFractionDigits:2})}`;
        } catch (error) {
            console.error('Error cargando ventas totales:', error);
            document.getElementById('ventas-totales').textContent = 'Error';
        }
    },

    showSection(sectionName) {
        // Update active menu item
        document.querySelectorAll('.menu-item').forEach(item => {
            item.classList.remove('active');
        });
        document.querySelector(`[data-section="${sectionName}"]`).classList.add('active');

        // Hide all sections
        document.querySelectorAll('.content-section').forEach(section => {
            section.classList.remove('active');
        });

        // Show selected section
        const targetSection = document.getElementById(`${sectionName}-section`);
        if (targetSection) {
            targetSection.classList.add('active');
            this.currentSection = sectionName;
            
            // Update page title
            const pageTitle = document.getElementById('page-title');
            const titles = {
                'resumen': 'Resumen',
                'pedidos': 'Mis Pedidos',
                'puntos': 'Mis Puntos',
                'favoritos': 'Mis Favoritos',
                'perfil': 'Mi Perfil',
                'productos': 'Productos'
            };
            pageTitle.textContent = titles[sectionName] || 'Dashboard';
        }
    },

    editProfile() {
        this.showNotification('Función de edición de perfil próximamente', 'info');
    },

    logout() {
        // Clear user data
        localStorage.removeItem('acaucab_user');
        sessionStorage.removeItem('acaucab_user');
        
        // Redirect to login
        window.location.href = 'login.html';
    },

    showNotification(message, type = 'info') {
        const notification = document.getElementById('notification');
        notification.textContent = message;
        notification.className = `notification ${type}`;
        
        // Auto hide after 3 seconds
        setTimeout(() => {
            notification.style.transform = 'translateX(100%)';
        }, 3000);
  }
};

// Initialize dashboard when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    dashboardPanel.init();
});
