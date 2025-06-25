// checkout.js

// Utilidades globales
const API_BASE = 'http://localhost:3000/api';

// Estado del checkout
const checkoutState = {
    clientes: [],
    clienteSeleccionado: null,
    puntosCliente: 0,
    metodosPago: {},
    tasaCambio: [],
    carrito: [],
    pagos: [], // {tipo, metodoId, monto, detalles}
    total: 0,
    subtotal: 0,
    iva: 0,
    puntosUsados: 0,
    puntosBs: 0,
    tasaUsd: 0,
};

// --- INICIALIZACIÓN ---
document.addEventListener('DOMContentLoaded', async () => {
    await cargarClientes();
    await cargarMetodosPago();
    await cargarTasaCambio();
    cargarCarrito();
    renderClientes();
    renderMetodosPago();
    renderResumen();
    renderDatosClienteVisual();
    bindEventosCheckout();
});

// --- CARGA DE DATOS ---
async function cargarClientes() {
    const res = await fetch(`${API_BASE}/clientes`);
    checkoutState.clientes = await res.json();
}

async function cargarMetodosPago() {
    const res = await fetch(`${API_BASE}/metodos-pago`);
    checkoutState.metodosPago = await res.json();
}

async function cargarTasaCambio() {
    const res = await fetch(`${API_BASE}/tasa-cambio`);
    const tasas = await res.json();
    checkoutState.tasaCambio = tasas;
    // Buscar USD
    const usd = tasas.find(t => t.moneda_origen === 'USD');
    checkoutState.tasaUsd = usd ? parseFloat(usd.tasa) : 0;
}

function cargarCarrito() {
    const carrito = JSON.parse(localStorage.getItem('acaucab_cart')) || [];
    checkoutState.carrito = carrito;
}

// --- RENDER CLIENTES Y SELECCIÓN ---
function renderClientes() {
    const cont = document.createElement('div');
    cont.className = 'form-group';
    cont.innerHTML = `
        <label for="clienteSelect">Cliente</label>
        <select id="clienteSelect" class="form-control">
            <option value="">Seleccione un cliente...</option>
            ${checkoutState.clientes.map(c => `<option value="${c.rif}">${c.rif} - ${c.tipo_cliente} - ${c.numero_carnet}${c.correo ? ' - ' + c.correo : ''}</option>`).join('')}
        </select>
        <div id="puntosClienteInfo" style="margin-top:8px;"></div>
    `;
    const form = document.querySelector('.checkout-form .form-section');
    if (form) form.prepend(cont);
    document.getElementById('clienteSelect').addEventListener('change', onClienteSeleccionado);
}

function renderDatosClienteVisual() {
    const cont = document.getElementById('datosClienteVisual');
    if (!cont) return;
    const c = checkoutState.clienteSeleccionado;
    if (!c) {
        cont.innerHTML = '<em>Seleccione un cliente para ver sus datos.</em>';
        return;
    }
    cont.innerHTML = `
        <div class="cliente-datos-box">
            <strong>Nombre:</strong> ${c.nombre || '-'}<br>
            <strong>Apellido:</strong> ${c.apellido || '-'}<br>
            <strong>Email:</strong> ${c.correo || '-'}<br>
            <strong>Teléfono:</strong> ${c.telefono || '-'}
        </div>
    `;
}

async function onClienteSeleccionado(e) {
    const rif = e.target.value;
    if (!rif) {
        checkoutState.clienteSeleccionado = null;
        checkoutState.puntosCliente = 0;
        renderPuntosCliente();
        renderDatosClienteVisual();
        return;
    }
    checkoutState.clienteSeleccionado = checkoutState.clientes.find(c => c.rif == rif);
    // Cargar puntos
    const res = await fetch(`${API_BASE}/clientes/${rif}/puntos`);
    const data = await res.json();
    checkoutState.puntosCliente = data.puntos;
    renderPuntosCliente();
    renderDatosClienteVisual();
}

function renderPuntosCliente() {
    const info = document.getElementById('puntosClienteInfo');
    if (!info) return;
    if (!checkoutState.clienteSeleccionado) {
        info.innerHTML = '';
        return;
    }
    info.innerHTML = `
        <strong>Puntos disponibles:</strong> ${checkoutState.puntosCliente} (<span id="puntosBs">${checkoutState.puntosCliente} Bs</span>)
        <br><small>1 punto = 1 Bs</small>
    `;
    // Campo para usar puntos
    info.innerHTML += `
        <div style="margin-top:8px;">
            <label for="usarPuntos">Usar puntos:</label>
            <input type="number" id="usarPuntos" min="0" max="${checkoutState.puntosCliente}" value="0" style="width:80px;">
        </div>
    `;
    document.getElementById('usarPuntos').addEventListener('input', onPuntosUsados);
}

function onPuntosUsados(e) {
    let val = parseInt(e.target.value) || 0;
    if (val < 0) val = 0;
    if (val > checkoutState.puntosCliente) val = checkoutState.puntosCliente;
    checkoutState.puntosUsados = val;
    checkoutState.puntosBs = val;
    renderResumen();
}

// --- RENDER MÉTODOS DE PAGO ---
function renderMetodosPago() {
    const metodosDiv = document.getElementById('metodosPagoCont');
    if (!metodosDiv) {
        console.error('No se encontró el contenedor #metodosPagoCont en el HTML');
        return;
    }
    metodosDiv.innerHTML = '';
    // Efectivo
    metodosDiv.innerHTML += `
        <div class="metodo-grupo"><strong>Efectivo</strong>
            <div style="margin-left:16px; margin-bottom:6px;">
                <label>Divisa:
                    <select id="efectivoDivisa">
                        <option value="VES">VES</option>
                        <option value="USD">USD</option>
                        <option value="EUR">EUR</option>
                    </select>
                </label>
                <input type="number" class="montoMetodo" id="monto_efectivo" placeholder="Monto" min="0" step="0.01" style="width:100px;">
            </div>
        </div>
    `;
    // Débito
    metodosDiv.innerHTML += `
        <div class="metodo-grupo"><strong>Débito</strong>
            <div style="margin-left:16px; margin-bottom:6px;">
                <label>Banco: <input type="text" id="debitoBanco" placeholder="Banco" style="width:100px;"></label>
                <label>Cuenta: <input type="text" id="debitoCuenta" placeholder="Cuenta" style="width:100px;"></label>
                <label>Tarjeta: <input type="text" id="debitoTarjeta" placeholder="N° Tarjeta" style="width:100px;"></label>
                <input type="number" class="montoMetodo" id="monto_debito" placeholder="Monto" min="0" step="0.01" style="width:100px;">
            </div>
        </div>
    `;
    // Crédito
    metodosDiv.innerHTML += `
        <div class="metodo-grupo"><strong>Crédito</strong>
            <div style="margin-left:16px; margin-bottom:6px;">
                <label>Banco: <input type="text" id="creditoBanco" placeholder="Banco" style="width:100px;"></label>
                <label>Cuenta: <input type="text" id="creditoCuenta" placeholder="Cuenta" style="width:100px;"></label>
                <label>Tarjeta: <input type="text" id="creditoTarjeta" placeholder="N° Tarjeta" style="width:100px;"></label>
                <input type="number" class="montoMetodo" id="monto_credito" placeholder="Monto" min="0" step="0.01" style="width:100px;">
            </div>
        </div>
    `;
    // Cheque
    metodosDiv.innerHTML += `
        <div class="metodo-grupo"><strong>Cheque</strong>
            <div style="margin-left:16px; margin-bottom:6px;">
                <label>Banco: <input type="text" id="chequeBanco" placeholder="Banco" style="width:100px;"></label>
                <label>N° Cuenta: <input type="text" id="chequeCuenta" placeholder="N° Cuenta" style="width:100px;"></label>
                <label>N° Cheque: <input type="text" id="chequeNumero" placeholder="N° Cheque" style="width:100px;"></label>
                <input type="number" class="montoMetodo" id="monto_cheque" placeholder="Monto" min="0" step="0.01" style="width:100px;">
            </div>
        </div>
    `;
    // Punto
    metodosDiv.innerHTML += `
        <div class="metodo-grupo"><strong>Punto (Puntos de fidelidad)</strong>
            <div style="margin-left:16px; margin-bottom:6px;">
                <input type="number" class="montoMetodo" id="monto_punto" placeholder="Puntos a usar" min="0" step="1" style="width:100px;">
            </div>
        </div>
    `;
    // Eventos para actualizar resumen
    metodosDiv.querySelectorAll('.montoMetodo').forEach(inp => {
        inp.addEventListener('input', renderResumen);
    });
}

// --- RENDER RESUMEN Y TOTAL ---
function renderResumen() {
    // Calcular subtotal, iva, total
    const subtotal = checkoutState.carrito.reduce((sum, item) => sum + (item.price * item.quantity), 0);
    const iva = subtotal * 0.16;
    let total = subtotal + iva;
    // Restar puntos usados
    total -= checkoutState.puntosBs;
    if (total < 0) total = 0;
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
    // Mostrar tasa de cambio
    mostrarTasaCambio(total);
    // Render items
    const orderItems = document.getElementById('orderItems');
    if (orderItems) {
        orderItems.innerHTML = checkoutState.carrito.map(item => `
            <div class="order-item">
                <div class="item-info">
                    <h4>${item.name}</h4>
                    <p>Cantidad: ${item.quantity}</p>
                </div>
                <div class="item-price">$${(item.price * item.quantity).toFixed(2)}</div>
            </div>
        `).join('');
    }
}

function mostrarTasaCambio(total) {
    let div = document.getElementById('tasaCambioInfo');
    if (!div) {
        div = document.createElement('div');
        div.id = 'tasaCambioInfo';
        const resumen = document.querySelector('.order-summary');
        if (resumen) resumen.appendChild(div);
    }
    if (checkoutState.tasaUsd) {
        div.innerHTML = `<small>Tasa USD: ${checkoutState.tasaUsd} Bs/USD</small><br><strong>Total en Bs: ${(total * checkoutState.tasaUsd).toFixed(2)} Bs</strong>`;
    } else {
        div.innerHTML = '';
    }
}

// --- EVENTOS PRINCIPALES ---
function bindEventosCheckout() {
    const placeOrderBtn = document.getElementById('placeOrderBtn');
    if (placeOrderBtn) {
        placeOrderBtn.addEventListener('click', onPlaceOrder);
    }
}

async function onPlaceOrder(e) {
    e.preventDefault();
    // Validar cliente
    if (!checkoutState.clienteSeleccionado) {
        mostrarNotificacion('Debes seleccionar un cliente', 'error');
        return;
    }
    // Tomar montos de los métodos de pago estáticos
    const pagos = [];
    let sumaPagos = 0;
    // Efectivo
    const montoEfectivo = parseFloat(document.getElementById('monto_efectivo').value) || 0;
    if (montoEfectivo > 0) {
        pagos.push({
            tipo: 'Efectivo',
            monto: montoEfectivo,
            detalles: { divisa: document.getElementById('efectivoDivisa').value }
        });
        sumaPagos += montoEfectivo;
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
        sumaPagos += montoDebito;
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
        sumaPagos += montoCredito;
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
        sumaPagos += montoCheque;
    }
    // Punto
    const montoPunto = parseInt(document.getElementById('monto_punto').value) || 0;
    if (montoPunto > 0) {
        pagos.push({
            tipo: 'Punto',
            monto: montoPunto,
            detalles: { descripcion: 'Puntos de fidelidad' }
        });
        sumaPagos += montoPunto;
    }
    if (pagos.length === 0) {
        mostrarNotificacion('Debes ingresar al menos un monto en un método de pago', 'error');
        return;
    }
    // Validar suma
    if (Math.abs(sumaPagos - checkoutState.total) > 0.01) {
        mostrarNotificacion('La suma de los pagos no coincide con el total', 'error');
        return;
    }
    // Preparar datos para el backend
    const tasaUsdObj = checkoutState.tasaCambio.find(t => t.moneda_origen === 'USD');
    const tasaCambioId = tasaUsdObj ? tasaUsdObj.tasa_cambio_id || 1 : 1;
    const compraPayload = {
        clienteRif: checkoutState.clienteSeleccionado.rif,
        carrito: checkoutState.carrito.map(item => ({
            id: item.id,
            quantity: item.quantity,
            price: item.price,
            cerveza_id: item.cerveza_id,
            presentacion_id: item.presentacion_id
        })),
        metodosPago: pagos,
        puntosUsados: montoPunto,
        tasaCambioId: tasaCambioId,
        subtotal: checkoutState.subtotal,
        iva: checkoutState.iva,
        total: checkoutState.total
    };
    // Enviar al backend
    fetch('http://localhost:3000/api/compras/realizar', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(compraPayload)
    })
    .then(async resp => {
        if (!resp.ok) {
            const err = await resp.json();
            throw new Error(err.error || 'Error al registrar la compra');
        }
        return resp.json();
    })
    .then(data => {
        localStorage.removeItem('acaucab_cart');
        mostrarNotificacion('¡Compra realizada exitosamente!', 'success');
        setTimeout(() => {
            window.location.href = 'products.html';
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