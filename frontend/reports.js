// Verificar autenticación al cargar la página
document.addEventListener('DOMContentLoaded', function() {
    checkAuth();
    setupLogout();
    setupFilters();
    setDefaultDates();
});

// Verificar si el usuario está autenticado
async function checkAuth() {
    const userId = localStorage.getItem('userId');
    if (!userId) {
        window.location.href = 'login.html';
        return;
    }

    try {
        const response = await fetch(`http://localhost:3000/api/auth/verify?userId=${userId}`);
        if (!response.ok) {
            localStorage.removeItem('userId');
            localStorage.removeItem('userData');
            window.location.href = 'login.html';
        }
    } catch (error) {
        console.error('Error verificando autenticación:', error);
        localStorage.removeItem('userId');
        localStorage.removeItem('userData');
        window.location.href = 'login.html';
    }
}

// Configurar el botón de logout
function setupLogout() {
    const logoutBtn = document.getElementById('logoutBtn');
    if (logoutBtn) {
        logoutBtn.addEventListener('click', function() {
            localStorage.removeItem('userId');
            localStorage.removeItem('userData');
            window.location.href = 'login.html';
        });
    }
}

// Configurar filtros de fecha
function setupFilters() {
    const applyFiltersBtn = document.getElementById('applyFilters');
    if (applyFiltersBtn) {
        applyFiltersBtn.addEventListener('click', function() {
            const startDate = document.getElementById('startDate').value;
            const endDate = document.getElementById('endDate').value;
            
            if (!startDate || !endDate) {
                showNotification('Por favor selecciona ambas fechas', 'error');
                return;
            }
            
            if (startDate > endDate) {
                showNotification('La fecha de inicio no puede ser mayor a la fecha fin', 'error');
                return;
            }
            
            showNotification('Filtros aplicados correctamente', 'success');
        });
    }
}

// Establecer fechas por defecto (último mes)
function setDefaultDates() {
    const today = new Date();
    const lastMonth = new Date(today.getFullYear(), today.getMonth() - 1, today.getDate());
    
    const startDateInput = document.getElementById('startDate');
    const endDateInput = document.getElementById('endDate');
    
    if (startDateInput && endDateInput) {
        startDateInput.value = lastMonth.toISOString().split('T')[0];
        endDateInput.value = today.toISOString().split('T')[0];
    }
}

// Función para generar reportes
async function generateReport(tipo) {
    const loadingOverlay = document.getElementById('loadingOverlay');
    const button = event.target;
    
    // Obtener fechas de filtro
    const startDate = document.getElementById('startDate').value;
    const endDate = document.getElementById('endDate').value;
    
    try {
        // Mostrar loading
        loadingOverlay.classList.add('show');
        button.disabled = true;
        button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Generando...';
        
        // Construir URL con parámetros
        let url = `http://localhost:3000/api/reports/${tipo}`;
        const params = new URLSearchParams();
        
        if (startDate && endDate) {
            params.append('startDate', startDate);
            params.append('endDate', endDate);
        }
        
        if (params.toString()) {
            url += `?${params.toString()}`;
        }
        
        // Hacer la petición al servidor
        const response = await fetch(url, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            }
        });

        if (!response.ok) {
            const errorData = await response.json();
            throw new Error(errorData.error || 'Error generando reporte');
        }

        // Obtener el blob del PDF
        const blob = await response.blob();
        
        // Crear URL para descarga
        const urlBlob = window.URL.createObjectURL(blob);
        
        // Crear elemento de descarga
        const a = document.createElement('a');
        a.href = urlBlob;
        a.download = `reporte-${tipo}-${new Date().toISOString().split('T')[0]}.pdf`;
        document.body.appendChild(a);
        a.click();
        
        // Limpiar
        window.URL.revokeObjectURL(urlBlob);
        document.body.removeChild(a);
        
        // Mostrar mensaje de éxito
        showNotification('Reporte generado exitosamente', 'success');
        
    } catch (error) {
        console.error('Error generando reporte:', error);
        showNotification(`Error generando reporte: ${error.message}`, 'error');
    } finally {
        // Ocultar loading
        loadingOverlay.classList.remove('show');
        button.disabled = false;
        button.innerHTML = '<i class="fas fa-download"></i> Generar PDF';
    }
}

// Función para mostrar notificaciones
function showNotification(message, type = 'info') {
    // Crear elemento de notificación
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.innerHTML = `
        <div class="notification-content">
            <i class="fas fa-${type === 'success' ? 'check-circle' : type === 'error' ? 'exclamation-circle' : 'info-circle'}"></i>
            <span>${message}</span>
        </div>
    `;
    
    // Agregar estilos si no existen
    if (!document.getElementById('notification-styles')) {
        const styles = document.createElement('style');
        styles.id = 'notification-styles';
        styles.textContent = `
            .notification {
                position: fixed;
                top: 20px;
                right: 20px;
                padding: 15px 20px;
                border-radius: 10px;
                color: white;
                font-weight: 500;
                z-index: 10000;
                animation: slideIn 0.3s ease-out;
                max-width: 400px;
            }
            
            .notification-success {
                background: linear-gradient(135deg, #28a745, #20c997);
            }
            
            .notification-error {
                background: linear-gradient(135deg, #dc3545, #e74c3c);
            }
            
            .notification-info {
                background: linear-gradient(135deg, #17a2b8, #20c997);
            }
            
            .notification-content {
                display: flex;
                align-items: center;
                gap: 10px;
            }
            
            @keyframes slideIn {
                from {
                    transform: translateX(100%);
                    opacity: 0;
                }
                to {
                    transform: translateX(0);
                    opacity: 1;
                }
            }
            
            @keyframes slideOut {
                from {
                    transform: translateX(0);
                    opacity: 1;
                }
                to {
                    transform: translateX(100%);
                    opacity: 0;
                }
            }
        `;
        document.head.appendChild(styles);
    }
    
    // Agregar al DOM
    document.body.appendChild(notification);
    
    // Remover después de 5 segundos
    setTimeout(() => {
        notification.style.animation = 'slideOut 0.3s ease-out';
        setTimeout(() => {
            if (notification.parentNode) {
                notification.parentNode.removeChild(notification);
            }
        }, 300);
    }, 5000);
}

// Función para obtener información del reporte
async function getReportInfo() {
    try {
        const response = await fetch('http://localhost:3000/api/reports');
        if (response.ok) {
            const reportes = await response.json();
            console.log('Reportes disponibles:', reportes);
            return reportes;
        }
    } catch (error) {
        console.error('Error obteniendo información de reportes:', error);
    }
}

// Cargar información de reportes al iniciar
document.addEventListener('DOMContentLoaded', function() {
    getReportInfo();
}); 