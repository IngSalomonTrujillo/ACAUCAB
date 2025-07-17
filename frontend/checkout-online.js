// checkout-online.js

const API_BASE = 'http://localhost:3000/api';

const checkoutState = {
    currentUser: null,
    carrito: [],
    subtotal: 0,
    iva: 0,
    total: 0,
};

document.addEventListener('DOMContentLoaded', async () => {
    await cargarUsuario();
    cargarCarrito();
    renderResumen();
    bindEventosCheckout();
});

async function cargarUsuario() {
    // Tomar usuario logueado de localStorage/sessionStorage
    const userFromStorage = localStorage.getItem('acaucab_current_user') || sessionStorage.getItem('acaucab_current_user');
    if (userFromStorage) {
        checkoutState.currentUser = JSON.parse(userFromStorage);
    } else {
        window.location.href = 'login.html';
    }
}

function cargarCarrito() {
    const carrito = JSON.parse(localStorage.getItem('acaucab_tienda_cart')) || [];
    checkoutState.carrito = carrito;
}

function renderResumen() {
    const subtotal = checkoutState.carrito.reduce((sum, item) => sum + (item.precio * item.quantity), 0);
    const iva = subtotal * 0.16;
    let total = subtotal + iva;
    checkoutState.subtotal = subtotal;
    checkoutState.iva = iva;
    checkoutState.total = total;
    // Mostrar en el resumen
    const subtotalEl = document.getElementById('subtotal');
    const taxEl = document.getElementById('tax');
    const totalEl = document.getElementById('total');
    if (subtotalEl) subtotalEl.textContent = subtotal.toFixed(2);
    if (taxEl) taxEl.textContent = iva.toFixed(2);
    if (totalEl) totalEl.textContent = total.toFixed(2);
    // Render items
    const orderItems = document.getElementById('orderItems');
    if (orderItems) {
        orderItems.innerHTML = checkoutState.carrito.map(item => `
            <div class="order-item">
                <div class="item-info">
                    <h4>${item.nombre}</h4>
                    <p>Cantidad: ${item.quantity}</p>
                </div>
                <div class="item-price">$${(item.precio * item.quantity).toFixed(2)}</div>
            </div>
        `).join('');
    }
}

function bindEventosCheckout() {
    const placeOrderBtn = document.getElementById('placeOrderBtn');
    if (placeOrderBtn) {
        placeOrderBtn.addEventListener('click', onPlaceOrder);
    }
}

function getPagosFromForm() {
    const pagos = [];
    // Efectivo
    const montoEfectivo = parseFloat(document.getElementById('monto_efectivo').value) || 0;
    if (montoEfectivo > 0) {
        pagos.push({
            tipo: 'Efectivo',
            monto: montoEfectivo,
            detalles: { divisa: document.getElementById('efectivoDivisa').value }
        });
    }
    // Débito
    const montoDebito = parseFloat(document.getElementById('monto_debito').value) || 0;
    if (montoDebito > 0) {
        pagos.push({
            tipo: 'Débito',
            monto: montoDebito,
            detalles: {
                banco: document.getElementById('debitoBanco').value,
                cuenta: document.getElementById('debitoCuenta').value,
                numero_tarjeta: document.getElementById('debitoTarjeta').value
            }
        });
    }
    // Crédito
    const montoCredito = parseFloat(document.getElementById('monto_credito').value) || 0;
    if (montoCredito > 0) {
        pagos.push({
            tipo: 'Crédito',
            monto: montoCredito,
            detalles: {
                banco: document.getElementById('creditoBanco').value,
                cuenta: document.getElementById('creditoCuenta').value,
                numero_tarjeta: document.getElementById('creditoTarjeta').value
            }
        });
    }
    // Cheque
    const montoCheque = parseFloat(document.getElementById('monto_cheque').value) || 0;
    if (montoCheque > 0) {
        pagos.push({
            tipo: 'Cheque',
            monto: montoCheque,
            detalles: {
                banco: document.getElementById('chequeBanco').value,
                numero_cuenta: document.getElementById('chequeCuenta').value,
                numero_cheque: document.getElementById('chequeNumero').value
            }
        });
    }
    // Punto
    const montoPunto = parseInt(document.getElementById('monto_punto').value) || 0;
    if (montoPunto > 0) {
        pagos.push({
            tipo: 'Punto',
            monto: montoPunto,
            detalles: { descripcion: 'Puntos de fidelidad' }
        });
    }
    return pagos;
}

async function onPlaceOrder(e) {
    e.preventDefault();
    // Validar usuario
    if (!checkoutState.currentUser || !checkoutState.currentUser.cliente_rif) {
        mostrarNotificacion('Usuario no válido', 'error');
        return;
    }
    // Validar dirección y teléfono
    const shippingAddress = document.getElementById('shippingAddress').value;
    const shippingPhone = document.getElementById('shippingPhone').value;
    if (!shippingAddress || !shippingPhone) {
        mostrarNotificacion('Por favor completa todos los campos obligatorios', 'error');
        return;
    }
    // Tomar montos de los métodos de pago
    const pagos = getPagosFromForm();
    let sumaPagos = pagos.reduce((acc, p) => acc + (parseFloat(p.monto) || 0), 0);
    if (pagos.length === 0) {
        mostrarNotificacion('Debes ingresar al menos un monto en un método de pago', 'error');
        return;
    }
    if (Math.abs(sumaPagos - checkoutState.total) > 0.01) {
        mostrarNotificacion('La suma de los pagos no coincide con el total', 'error');
        return;
    }
    // Preparar datos para el backend
    const checkoutData = {
        clienteRif: checkoutState.currentUser.cliente_rif,
        productos: checkoutState.carrito.map(item => ({
            inventario_id: item.id,
            cantidad: item.quantity,
            precio: item.precio
        })),
        metodosPago: pagos,
        direccionEnvio: shippingAddress,
        telefonoEnvio: shippingPhone
    };
    // Enviar al backend
    fetch(`${API_BASE}/tienda/checkout`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(checkoutData)
    })
    .then(async resp => {
        if (!resp.ok) {
            const err = await resp.json();
            throw new Error(err.error || 'Error al registrar la compra');
        }
        return resp.json();
    })
    .then(data => {
        localStorage.removeItem('acaucab_tienda_cart');
        mostrarNotificacion('¡Pedido realizado exitosamente!', 'success');
        setTimeout(() => {
            window.location.href = 'tienda.html';
        }, 2000);
    })
    .catch(err => {
        mostrarNotificacion('Error: ' + err.message, 'error');
    });
}

function mostrarNotificacion(msg, tipo) {
    const notif = document.getElementById('notification');
    if (!notif) return;
    notif.textContent = msg;
    notif.className = 'notification ' + tipo;
    notif.style.display = 'block';
    setTimeout(() => {
        notif.style.display = 'none';
    }, 2500);
} 