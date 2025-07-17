// Métodos de pago disponibles (puedes adaptar estos IDs a los de tu base de datos)
const METODOS_PAGO = [
  { id: 1, nombre: 'Efectivo' },
  { id: 2, nombre: 'Débito' },
  { id: 3, nombre: 'Crédito' },
  { id: 4, nombre: 'Puntos' },
  { id: 5, nombre: 'Cheque' }
];

class TiendaOnline {
  constructor() {
    this.API_BASE_URL = 'http://localhost:3000/api';
    this.currentUser = null;
    this.products = [];
    this.cart = [];
    this.categories = [];
    this.currentPage = 1;
    this.filters = {
      categoria: '',
      precioMin: '',
      precioMax: '',
      ordenar: 'nombre',
      search: ''
    };
    this.metodosPagoDisponibles = {};
    this.metodosPagoSeleccionados = [];
    this.init();
  }

  async init() {
    console.log('🚀 Inicializando Tienda Online...');
    
    // Verificar autenticación
    await this.checkAuth();
    
    // Cargar datos iniciales
    await this.loadCategories();
    await this.loadProducts();
    
    // Configurar event listeners
    this.bindEvents();
    
    // Cargar carrito desde localStorage
    this.loadCart();
    this.updateCartUI();
    
    console.log('✅ Tienda Online inicializada');
  }

  async checkAuth() {
    try {
      // Verificar si hay usuario en localStorage o sessionStorage
      const userFromStorage = localStorage.getItem('acaucab_current_user') || 
                             sessionStorage.getItem('acaucab_current_user');
      
      if (userFromStorage) {
        this.currentUser = JSON.parse(userFromStorage);
        this.updateUserUI();
      } else {
        // Redirigir al login si no hay usuario
        window.location.href = 'login.html';
        return;
      }

      // Verificar que el usuario tenga rol de Cliente o Comprador
      if (!this.currentUser.role || 
          !['Cliente', 'Comprador'].includes(this.currentUser.role.name)) {
        this.showNotification('No tienes permisos para acceder a la tienda online', 'error');
        setTimeout(() => {
          window.location.href = 'login.html';
        }, 2000);
        return;
      }

    } catch (error) {
      console.error('Error verificando autenticación:', error);
      window.location.href = 'login.html';
    }
  }

  updateUserUI() {
    const userNameElement = document.getElementById('userName');
    if (userNameElement && this.currentUser) {
      const fullName = this.currentUser.fullName || 
                      `${this.currentUser.firstName || ''} ${this.currentUser.lastName || ''}`.trim();
      userNameElement.textContent = fullName || 'Mi Cuenta';
    }
  }

  async loadCategories() {
    try {
      const response = await fetch(`${this.API_BASE_URL}/tienda/categorias`);
      if (!response.ok) throw new Error('Error cargando categorías');
      
      this.categories = await response.json();
      this.populateCategoryFilter();
    } catch (error) {
      console.error('Error cargando categorías:', error);
    }
  }

  populateCategoryFilter() {
    const categoryFilter = document.getElementById('categoryFilter');
    if (!categoryFilter) return;

    // Limpiar opciones existentes (mantener la primera)
    categoryFilter.innerHTML = '<option value="">Todas las categorías</option>';
    
    // Agregar categorías
    this.categories.forEach(category => {
      const option = document.createElement('option');
      option.value = category.nombre;
      option.textContent = category.nombre;
      categoryFilter.appendChild(option);
    });
  }

  async loadProducts(page = 1) {
    try {
      this.showLoading(true);
      const params = new URLSearchParams({
        page: page,
        pageSize: 12,
        ordenar: this.filters.ordenar
      });
      if (this.filters.categoria) params.append('categoria', this.filters.categoria);
      if (this.filters.precioMin) params.append('precioMin', this.filters.precioMin);
      if (this.filters.precioMax) params.append('precioMax', this.filters.precioMax);

      // Obtener productos (cervezas)
      const response = await fetch(`${this.API_BASE_URL}/tienda/productos?${params}`);
      if (!response.ok) throw new Error('Error cargando productos');
      const data = await response.json();
      this.products = data.productos;
      this.currentPage = data.paginacion.page;

      // Obtener eventos y agregarlos a la lista de productos
      const eventosRes = await fetch(`${this.API_BASE_URL.replace('/api','')}/api/eventos`);
      if (eventosRes.ok) {
        const eventos = await eventosRes.json();
        // Adaptar eventos al formato de producto
        const eventosAdaptados = eventos.map(ev => ({
          id: `evento-${ev.evento_id}`,
          nombre: ev.nombre_evento,
          descripcion: ev.descripción_evento || 'Evento',
          precio: ev.requiere_entrada_paga ? (ev.precio_entrada || 0) : 0,
          categoria: 'Evento',
          stock: ev.cupos_disponibles || 9999,
          fecha: ev.fecha_inicio,
          esEvento: true,
          lugar: ev.direccion_evento || '',
        }));
        this.products = [...eventosAdaptados, ...this.products];
      }

      this.displayProducts();
      this.renderPagination(data.paginacion);
    } catch (error) {
      console.error('Error cargando productos:', error);
      this.showNotification('Error cargando productos', 'error');
      this.showNoProducts();
    } finally {
      this.showLoading(false);
    }
  }

  displayProducts() {
    const grid = document.getElementById('productsGrid');
    if (!grid) return;

    grid.innerHTML = '';

    if (!this.products || this.products.length === 0) {
      this.showNoProducts();
      return;
    }

    this.products.forEach(product => {
      const card = this.createProductCard(product);
      grid.appendChild(card);
    });
  }

  createProductCard(product) {
    const card = document.createElement('div');
    card.className = 'product-card';
    if (product.esEvento) {
      card.innerHTML = `
        <div class="product-image">
          <i class="fas fa-calendar-alt" style="font-size:2.5rem;color:#007bff;"></i>
        </div>
        <div class="product-info">
          <div class="product-category">${product.categoria}</div>
          <h3 class="product-name">${product.nombre}</h3>
          <p class="product-description">${product.descripcion || 'Sin descripción disponible'}</p>
          <div class="product-stock">Fecha: ${product.fecha ? product.fecha.split('T')[0] : 'Próximamente'}</div>
          <div class="product-stock">Lugar: ${product.lugar || 'Por definir'}</div>
          <div class="product-footer">
            <span class="product-price">${product.precio > 0 ? `$${product.precio.toLocaleString()}` : 'Entrada libre'}</span>
            <button class="add-to-cart" data-id="${product.id}">
              <i class="fas fa-ticket-alt"></i> Comprar entrada
            </button>
          </div>
        </div>
      `;
    } else {
      card.innerHTML = `
        <div class="product-image">
          <i class="fas fa-beer"></i>
        </div>
        <div class="product-info">
          <div class="product-category">${product.categoria}</div>
          <h3 class="product-name">${product.nombre}</h3>
          <p class="product-description">${product.descripcion || 'Sin descripción disponible'}</p>
          <div class="product-stock">Stock: ${product.stock} disponibles</div>
          <div class="product-footer">
            <span class="product-price">$${product.precio.toLocaleString()}</span>
            <button class="add-to-cart" data-id="${product.id}">
              <i class="fas fa-cart-plus"></i>
            </button>
          </div>
        </div>
      `;
    }
    // Event listeners
    card.addEventListener('click', (e) => {
      if (!e.target.closest('.add-to-cart')) {
        this.showProductModal(product);
      }
    });
    const addToCartBtn = card.querySelector('.add-to-cart');
    addToCartBtn.addEventListener('click', (e) => {
      e.stopPropagation();
      this.addToCart(product);
    });
    return card;
  }

  showProductModal(product) {
    const modal = document.getElementById('productModal');
    const modalBody = document.getElementById('modalBody');
    
    if (!modal || !modalBody) return;

    modalBody.innerHTML = `
      <div class="product-modal-content">
        <div class="product-modal-image">
          <i class="fas fa-beer"></i>
        </div>
        <div class="modal-info">
          <div class="product-category">${product.categoria}</div>
          <h2>${product.nombre}</h2>
          <p class="product-description">${product.descripcion || 'Sin descripción disponible'}</p>
          
          <div class="product-modal-details">
            <div class="product-spec">
              <span>Presentación:</span>
              <span>${product.presentacion}</span>
            </div>
            <div class="product-spec">
              <span>Stock disponible:</span>
              <span>${product.stock} unidades</span>
            </div>
            <div class="product-spec">
              <span>Categoría:</span>
              <span>${product.categoria}</span>
            </div>
            <div class="product-spec">
              <span>Familia:</span>
              <span>${product.familia}</span>
            </div>
          </div>
          
          <div class="modal-footer">
            <span class="product-price">$${product.precio.toLocaleString()}</span>
            <button class="btn btn-primary" onclick="tienda.addToCart(${JSON.stringify(product).replace(/"/g, '&quot;')})">
              <i class="fas fa-cart-plus"></i>
              Agregar al Carrito
            </button>
          </div>
        </div>
      </div>
    `;

    this.showModal(modal);
  }

  renderPagination(pagination) {
    const paginationContainer = document.getElementById('pagination');
    if (!paginationContainer) return;

    paginationContainer.innerHTML = '';

    if (pagination.totalPages <= 1) return;

    // Botón anterior
    if (pagination.page > 1) {
      const prevBtn = document.createElement('button');
      prevBtn.textContent = '← Anterior';
      prevBtn.addEventListener('click', () => this.loadProducts(pagination.page - 1));
      paginationContainer.appendChild(prevBtn);
    }

    // Números de página
    for (let i = 1; i <= pagination.totalPages; i++) {
      const pageBtn = document.createElement('button');
      pageBtn.textContent = i;
      pageBtn.className = i === pagination.page ? 'active' : '';
      pageBtn.addEventListener('click', () => this.loadProducts(i));
      paginationContainer.appendChild(pageBtn);
    }

    // Botón siguiente
    if (pagination.page < pagination.totalPages) {
      const nextBtn = document.createElement('button');
      nextBtn.textContent = 'Siguiente →';
      nextBtn.addEventListener('click', () => this.loadProducts(pagination.page + 1));
      paginationContainer.appendChild(nextBtn);
    }
  }

  addToCart(product) {
    // Forzar que el id sea el inventario_id
    const id = product.inventario_id || product.id;
    const existingItem = this.cart.find(item => item.id === id);
    
    if (existingItem) {
      if (existingItem.quantity < product.stock) {
        existingItem.quantity++;
      } else {
        this.showNotification('No hay más stock disponible', 'error');
        return;
      }
    } else {
      this.cart.push({
        ...product,
        id, // asegurar que el id es inventario_id
        quantity: 1
      });
    }

    this.saveCart();
    this.updateCartUI();
    this.showNotification(`${product.nombre} agregado al carrito`, 'success');
  }

  removeFromCart(productId) {
    this.cart = this.cart.filter(item => item.id !== productId);
    this.saveCart();
    this.updateCartUI();
  }

  updateQuantity(productId, newQuantity) {
    const item = this.cart.find(item => item.id === productId);
    if (!item) return;

    if (newQuantity <= 0) {
      this.removeFromCart(productId);
    } else if (newQuantity <= item.stock) {
      item.quantity = newQuantity;
      this.saveCart();
      this.updateCartUI();
    } else {
      this.showNotification('No hay suficiente stock disponible', 'error');
    }
  }

  saveCart() {
    localStorage.setItem('acaucab_tienda_cart', JSON.stringify(this.cart));
  }

  loadCart() {
    const savedCart = localStorage.getItem('acaucab_tienda_cart');
    if (savedCart) {
      this.cart = JSON.parse(savedCart);
    }
  }

  updateCartUI() {
    const cartCount = document.getElementById('cartCount');
    const cartItems = document.getElementById('cartItems');
    const cartTotal = document.getElementById('cartTotal');
    const checkoutBtn = document.getElementById('checkoutBtn');

    if (cartCount) {
      const totalItems = this.cart.reduce((sum, item) => sum + item.quantity, 0);
      cartCount.textContent = totalItems;
    }

    if (cartItems) {
      cartItems.innerHTML = '';
      
      if (this.cart.length === 0) {
        cartItems.innerHTML = '<p style="text-align: center; color: var(--gray);">Tu carrito está vacío</p>';
      } else {
        this.cart.forEach(item => {
          const cartItem = document.createElement('div');
          cartItem.className = 'cart-item';
          cartItem.innerHTML = `
            <div class="cart-item-info">
              <div class="cart-item-name">${item.nombre}</div>
              <div class="cart-item-presentation">${item.presentacion || ''}</div>
              <div class="cart-item-price">$${(item.precio * item.quantity).toLocaleString()}</div>
            </div>
            <div class="cart-item-quantity">
              <button class="quantity-btn" onclick="tienda.updateQuantity('${item.id}', ${item.quantity - 1})">-</button>
              <span>${item.quantity}</span>
              <button class="quantity-btn" onclick="tienda.updateQuantity('${item.id}', ${item.quantity + 1})">+</button>
            </div>
            <button class="cart-item-remove" onclick="tienda.removeFromCart('${item.id}')">
              <i class="fas fa-trash"></i>
            </button>
          `;
          cartItems.appendChild(cartItem);
        });
      }
    }

    if (cartTotal) {
      const total = this.cart.reduce((sum, item) => sum + (item.precio * item.quantity), 0);
      cartTotal.textContent = total.toLocaleString();
    }

    if (checkoutBtn) {
      checkoutBtn.disabled = this.cart.length === 0;
    }
  }

  toggleCart() {
    const cartSidebar = document.getElementById('cartSidebar');
    if (cartSidebar) {
      cartSidebar.classList.toggle('open');
    }
  }

  showModal(modal) {
    if (modal) {
      modal.classList.add('show');
    }
  }

  hideModal(modal) {
    if (modal) {
      modal.classList.remove('show');
    }
  }

  showLoading(show) {
    const loading = document.getElementById('loading');
    const productsGrid = document.getElementById('productsGrid');
    
    if (loading) loading.style.display = show ? 'flex' : 'none';
    if (productsGrid) productsGrid.style.display = show ? 'none' : 'grid';
  }

  showNoProducts() {
    const noProducts = document.getElementById('noProducts');
    const productsGrid = document.getElementById('productsGrid');
    
    if (noProducts) noProducts.style.display = 'block';
    if (productsGrid) productsGrid.style.display = 'none';
  }

  applyFilters() {
    const categoryFilter = document.getElementById('categoryFilter');
    const priceFilter = document.getElementById('priceFilter');
    const sortFilter = document.getElementById('sortFilter');

    this.filters.categoria = categoryFilter ? categoryFilter.value : '';
    this.filters.ordenar = sortFilter ? sortFilter.value : 'nombre';

    // Procesar filtro de precio
    if (priceFilter && priceFilter.value) {
      const [min, max] = priceFilter.value.split('-');
      this.filters.precioMin = min || '';
      this.filters.precioMax = max || '';
    } else {
      this.filters.precioMin = '';
      this.filters.precioMax = '';
    }

    this.loadProducts(1);
  }

  clearFilters() {
    const categoryFilter = document.getElementById('categoryFilter');
    const priceFilter = document.getElementById('priceFilter');
    const sortFilter = document.getElementById('sortFilter');
    const searchInput = document.getElementById('searchInput');

    if (categoryFilter) categoryFilter.value = '';
    if (priceFilter) priceFilter.value = '';
    if (sortFilter) sortFilter.value = 'nombre';
    if (searchInput) searchInput.value = '';

    this.filters = {
      categoria: '',
      precioMin: '',
      precioMax: '',
      ordenar: 'nombre',
      search: ''
    };

    this.loadProducts(1);
  }

  async handleSearch() {
    const searchInput = document.getElementById('searchInput');
    if (!searchInput) return;

    this.filters.search = searchInput.value.trim();
    
    // Por ahora, recargamos todos los productos
    // En el futuro se puede implementar búsqueda en el backend
    await this.loadProducts(1);
  }

  async showCheckoutModal() {
    await this.fetchMetodosPago();
    this.renderMetodosPagoForms();
    if (this.cart.length === 0) {
      this.showNotification('Tu carrito está vacío', 'error');
      return;
    }

    const modal = document.getElementById('checkoutModal');
    if (!modal) return;

    // Cargar puntos del usuario si es cliente
    if (this.currentUser && this.currentUser.cliente_rif) {
      await this.loadUserPoints();
    }

    // Actualizar resumen del pedido
    this.updateOrderSummary();

    this.showModal(modal);
  }

  updateOrderSummary() {
    const orderItems = document.getElementById('orderItems');
    const orderTotal = document.getElementById('orderTotal');

    if (orderItems) {
      orderItems.innerHTML = '';
      this.cart.forEach(item => {
        const orderItem = document.createElement('div');
        orderItem.className = 'order-item';
        orderItem.innerHTML = `
          <span>${item.nombre} (${item.presentacion}) x ${item.quantity}</span>
          <span>$${(item.precio * item.quantity).toLocaleString()}</span>
        `;
        orderItems.appendChild(orderItem);
      });
    }

    if (orderTotal) {
      const total = this.cart.reduce((sum, item) => sum + (item.precio * item.quantity), 0);
      orderTotal.textContent = total.toLocaleString();
    }
  }

  async loadUserPoints() {
    if (!this.currentUser || !this.currentUser.cliente_rif) return;

    try {
      const response = await fetch(`${this.API_BASE_URL}/tienda/puntos/${this.currentUser.cliente_rif}`);
      if (response.ok) {
        const data = await response.json();
        
        const cartPoints = document.getElementById('cartPoints');
        const availablePoints = document.getElementById('availablePoints');
        const checkoutPoints = document.getElementById('checkoutPoints');
        const pointsSection = document.getElementById('pointsSection');

        if (data.puntos > 0) {
          if (cartPoints) {
            cartPoints.style.display = 'block';
            if (availablePoints) availablePoints.textContent = data.puntos;
          }
          if (pointsSection) pointsSection.style.display = 'block';
          if (checkoutPoints) checkoutPoints.textContent = data.puntos;
        }
      }
    } catch (error) {
      console.error('Error cargando puntos:', error);
    }
  }

  async fetchMetodosPago() {
    try {
      const res = await fetch(`${this.API_BASE_URL}/metodos-pago`);
      if (!res.ok) throw new Error('No se pudieron cargar los métodos de pago');
      this.metodosPagoDisponibles = await res.json();
    } catch (e) {
      this.metodosPagoDisponibles = {};
      this.showNotification('Error cargando métodos de pago', 'error');
    }
  }

  renderMetodosPagoForms() {
    const container = document.getElementById('metodosPagoContainer');
    if (!container) return;
    container.innerHTML = '';
    // Mostrar todos los métodos agrupados por tipo
    Object.entries(this.metodosPagoDisponibles).forEach(([tipo, metodos]) => {
      const tipoDiv = document.createElement('div');
      tipoDiv.className = 'metodo-pago-tipo';
      const tipoTitle = document.createElement('h4');
      tipoTitle.textContent = tipo;
      tipoDiv.appendChild(tipoTitle);
      metodos.forEach(metodo => {
        const formDiv = document.createElement('div');
        formDiv.className = 'metodo-pago-form';
        formDiv.dataset.metodoId = metodo.id;
        // Título identificador
        const label = document.createElement('label');
        label.textContent = `Método #${metodo.id}`;
        formDiv.appendChild(label);
        // Monto
        const monto = document.createElement('input');
        monto.type = 'number';
        monto.placeholder = 'Monto';
        monto.min = '0';
        monto.step = '0.01';
        monto.className = 'metodo-pago-monto';
        monto.dataset.metodoId = metodo.id;
        formDiv.appendChild(monto);
        // Campos específicos según tipo
        if (metodo.tipo === 'Débito' || metodo.tipo === 'Crédito') {
          const ref = document.createElement('input');
          ref.type = 'text';
          ref.placeholder = 'Referencia o número de transacción';
          ref.className = 'metodo-pago-ref';
          ref.dataset.metodoId = metodo.id;
          formDiv.appendChild(ref);
          const banco = document.createElement('input');
          banco.type = 'text';
          banco.placeholder = 'Banco';
          banco.className = 'metodo-pago-banco';
          banco.dataset.metodoId = metodo.id;
          formDiv.appendChild(banco);
          const tarjeta = document.createElement('input');
          tarjeta.type = 'text';
          tarjeta.placeholder = 'Número de tarjeta';
          tarjeta.className = 'metodo-pago-tarjeta';
          tarjeta.dataset.metodoId = metodo.id;
          formDiv.appendChild(tarjeta);
        } else if (metodo.tipo === 'Cheque') {
          const ref = document.createElement('input');
          ref.type = 'text';
          ref.placeholder = 'Número de cheque';
          ref.className = 'metodo-pago-ref';
          ref.dataset.metodoId = metodo.id;
          formDiv.appendChild(ref);
          const banco = document.createElement('input');
          banco.type = 'text';
          banco.placeholder = 'Banco';
          banco.className = 'metodo-pago-banco';
          banco.dataset.metodoId = metodo.id;
          formDiv.appendChild(banco);
          const cuenta = document.createElement('input');
          cuenta.type = 'text';
          cuenta.placeholder = 'Número de cuenta';
          cuenta.className = 'metodo-pago-cuenta';
          cuenta.dataset.metodoId = metodo.id;
          formDiv.appendChild(cuenta);
        } else if (metodo.tipo === 'Efectivo') {
          const divisa = document.createElement('input');
          divisa.type = 'text';
          divisa.placeholder = 'Divisa';
          divisa.className = 'metodo-pago-divisa';
          divisa.value = metodo.detalles.divisa || '';
          divisa.disabled = true;
          divisa.dataset.metodoId = metodo.id;
          formDiv.appendChild(divisa);
        } else if (metodo.tipo === 'Punto') {
          // Solo monto y fecha
        }
        // Fecha
        const fecha = document.createElement('input');
        fecha.type = 'date';
        fecha.className = 'metodo-pago-fecha';
        fecha.dataset.metodoId = metodo.id;
        fecha.value = this.getToday();
        formDiv.appendChild(fecha);
        container.appendChild(formDiv);
      });
      container.appendChild(tipoDiv);
    });
  }

  getPagosFromForm() {
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

  getMetodoTipoById(id) {
    for (const [tipo, metodos] of Object.entries(this.metodosPagoDisponibles)) {
      if (metodos.some(m => m.id === id)) return tipo;
    }
    return '';
  }

  bindEvents() {
    // Filtros
    const categoryFilter = document.getElementById('categoryFilter');
    const priceFilter = document.getElementById('priceFilter');
    const sortFilter = document.getElementById('sortFilter');
    const clearFiltersBtn = document.getElementById('clearFiltersBtn');

    if (categoryFilter) categoryFilter.addEventListener('change', () => this.applyFilters());
    if (priceFilter) priceFilter.addEventListener('change', () => this.applyFilters());
    if (sortFilter) sortFilter.addEventListener('change', () => this.applyFilters());
    if (clearFiltersBtn) clearFiltersBtn.addEventListener('click', () => this.clearFilters());

    // Búsqueda
    const searchInput = document.getElementById('searchInput');
    const searchBtn = document.getElementById('searchBtn');

    if (searchInput) {
      searchInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') this.handleSearch();
      });
    }
    if (searchBtn) searchBtn.addEventListener('click', () => this.handleSearch());

    // Carrito
    const cartBtn = document.getElementById('cartBtn');
    const closeCart = document.getElementById('closeCart');
    const checkoutBtn = document.getElementById('checkoutBtn');

    if (cartBtn) cartBtn.addEventListener('click', () => this.toggleCart());
    if (closeCart) closeCart.addEventListener('click', () => this.toggleCart());
    if (checkoutBtn) checkoutBtn.addEventListener('click', () => {
      // Guardar el carrito en localStorage antes de redirigir
      localStorage.setItem('acaucab_tienda_cart', JSON.stringify(this.cart));
      window.location.href = 'checkout-online.html';
    });

    // Modales
    const closeModal = document.getElementById('closeModal');
    const closeCheckoutModal = document.getElementById('closeCheckoutModal');
    const closeProfileModal = document.getElementById('closeProfileModal');
    const cancelCheckout = document.getElementById('cancelCheckout');

    if (closeModal) closeModal.addEventListener('click', () => this.hideModal(document.getElementById('productModal')));
    if (closeCheckoutModal) closeCheckoutModal.addEventListener('click', () => this.hideModal(document.getElementById('checkoutModal')));
    if (closeProfileModal) closeProfileModal.addEventListener('click', () => this.hideModal(document.getElementById('profileModal')));
    if (cancelCheckout) cancelCheckout.addEventListener('click', () => this.hideModal(document.getElementById('checkoutModal')));

    // Perfil
    const profileBtn = document.getElementById('profileBtn');
    if (profileBtn) profileBtn.addEventListener('click', () => this.showProfileModal());

    // Logout
    const logoutBtn = document.getElementById('logoutBtn');
    if (logoutBtn) logoutBtn.addEventListener('click', () => this.logout());

    // Checkout form
    const checkoutForm = document.getElementById('checkoutForm');
    if (checkoutForm) {
      checkoutForm.addEventListener('submit', (e) => {
        e.preventDefault();
        this.processCheckout();
      });
    }

    // Métodos de pago dinámicos en checkout
    const addMetodoPagoBtn = document.getElementById('addMetodoPagoBtn');
    if (addMetodoPagoBtn) {
      addMetodoPagoBtn.addEventListener('click', () => this.addMetodoPagoForm());
    }
    // Inicializar con un método de pago por defecto
    this.resetMetodosPago();

    // Métodos de pago fijos en checkout
    const metodosPagoContainer = document.getElementById('metodosPagoContainer');
    if (metodosPagoContainer) {
      metodosPagoContainer.querySelectorAll('.metodo-pago-monto, .metodo-pago-ref, .metodo-pago-fecha, .metodo-pago-banco').forEach(inp => {
        inp.addEventListener('input', () => this.renderPagosResumen());
        inp.addEventListener('change', () => this.renderPagosResumen());
      });
    }
    this.renderPagosResumen();

    // Cerrar modales al hacer clic fuera
    document.addEventListener('click', (e) => {
      const modals = document.querySelectorAll('.modal');
      modals.forEach(modal => {
        if (e.target === modal) {
          this.hideModal(modal);
        }
      });
    });
  }

  resetMetodosPago() {
    this.metodosPago = [];
    this.renderMetodosPagoForms();
    this.renderPagosResumen();
  }

  addMetodoPagoForm() {
    if (!this.metodosPago) this.metodosPago = [];
    this.metodosPago.push({ metodo_pago_id: 1, monto: '', referencia: '', fecha: this.getToday(), puntos: 0 });
    this.renderMetodosPagoForms();
    this.renderPagosResumen();
  }

  removeMetodoPagoForm(idx) {
    this.metodosPago.splice(idx, 1);
    this.renderMetodosPagoForms();
    this.renderPagosResumen();
  }

  renderMetodosPagoForms() {
    const container = document.getElementById('metodosPagoContainer');
    if (!container) return;
    container.innerHTML = '';
    if (!this.metodosPago || this.metodosPago.length === 0) {
      this.addMetodoPagoForm();
      return;
    }
    this.metodosPago.forEach((pago, idx) => {
      const div = document.createElement('div');
      div.className = 'metodo-pago-form';
      div.innerHTML = `
        <select class="metodo-pago-select" data-idx="${idx}">
          ${METODOS_PAGO.map(m => `<option value="${m.id}" ${pago.metodo_pago_id == m.id ? 'selected' : ''}>${m.nombre}</option>`).join('')}
        </select>
        <input type="number" class="metodo-pago-monto" data-idx="${idx}" placeholder="Monto" min="0" value="${pago.monto}">
        <input type="text" class="metodo-pago-ref" data-idx="${idx}" placeholder="Referencia" value="${pago.referencia}">
        <input type="date" class="metodo-pago-fecha" data-idx="${idx}" value="${pago.fecha}">
        <button type="button" class="remove-metodo-pago-btn" data-idx="${idx}">&times;</button>
      `;
      container.appendChild(div);
    });
    // Eventos
    container.querySelectorAll('.metodo-pago-select').forEach(sel => {
      sel.addEventListener('change', e => {
        const idx = e.target.dataset.idx;
        this.metodosPago[idx].metodo_pago_id = parseInt(e.target.value);
        this.renderPagosResumen();
      });
    });
    container.querySelectorAll('.metodo-pago-monto').forEach(inp => {
      inp.addEventListener('input', e => {
        const idx = e.target.dataset.idx;
        this.metodosPago[idx].monto = e.target.value;
        this.renderPagosResumen();
      });
    });
    container.querySelectorAll('.metodo-pago-ref').forEach(inp => {
      inp.addEventListener('input', e => {
        const idx = e.target.dataset.idx;
        this.metodosPago[idx].referencia = e.target.value;
      });
    });
    container.querySelectorAll('.metodo-pago-fecha').forEach(inp => {
      inp.addEventListener('change', e => {
        const idx = e.target.dataset.idx;
        this.metodosPago[idx].fecha = e.target.value;
      });
    });
    container.querySelectorAll('.remove-metodo-pago-btn').forEach(btn => {
      btn.addEventListener('click', e => {
        const idx = e.target.dataset.idx;
        this.removeMetodoPagoForm(idx);
      });
    });
  }

  renderPagosResumen() {
    const resumen = document.getElementById('pagosResumen');
    const errorDiv = document.getElementById('pagoError');
    if (!resumen) return;
    const total = this.cart.reduce((sum, item) => sum + (item.precio * item.quantity), 0);
    let suma = 0;
    const pagos = this.getPagosFromForm();
    resumen.innerHTML = '<strong>Resumen de pagos:</strong><ul>' +
      pagos.map(p => {
        suma += parseFloat(p.monto) || 0;
        const metodo = METODOS_PAGO.find(m => m.id == p.metodo_pago_id);
        return `<li>${metodo ? metodo.nombre : 'Método'}: $${p.monto || 0} Ref: ${p.referencia || '-'} Fecha: ${p.fecha || '-'}${p.banco ? ' Banco: ' + p.banco : ''}</li>`;
      }).join('') +
      '</ul>';
    resumen.innerHTML += `<strong>Total pagado: $${suma.toFixed(2)} / Total compra: $${total.toFixed(2)}</strong>`;
    if (errorDiv) {
      if (Math.abs(suma - total) > 0.01) {
        errorDiv.textContent = 'La suma de los pagos debe coincidir con el total de la compra';
      } else {
        errorDiv.textContent = '';
      }
    }
  }

  getPagosFromForm() {
    const pagos = [];
    const container = document.getElementById('metodosPagoContainer');
    if (!container) return pagos;
    METODOS_PAGO.forEach(metodo => {
      const monto = container.querySelector(`.metodo-pago-monto[data-metodo="${metodo.id}"]`)?.value;
      if (parseFloat(monto) > 0) {
        pagos.push({
          metodo_pago_id: metodo.id,
          monto: parseFloat(monto),
          referencia: container.querySelector(`.metodo-pago-ref[data-metodo="${metodo.id}"]`)?.value || '',
          fecha: container.querySelector(`.metodo-pago-fecha[data-metodo="${metodo.id}"]`)?.value || this.getToday(),
          banco: container.querySelector(`.metodo-pago-banco[data-metodo="${metodo.id}"]`)?.value || ''
        });
      }
    });
    return pagos;
  }

  async processCheckout() {
    if (!this.currentUser || !this.currentUser.cliente_rif) {
      this.showNotification('Usuario no válido', 'error');
      return;
    }
    const shippingAddress = document.getElementById('shippingAddress').value;
    const shippingPhone = document.getElementById('shippingPhone').value;
    const pointsToUse = parseInt(document.getElementById('pointsToUse').value) || 0;
    if (!shippingAddress || !shippingPhone) {
      this.showNotification('Por favor completa todos los campos obligatorios', 'error');
      return;
    }
    // Validar pagos
    const total = this.cart.reduce((sum, item) => sum + (item.precio * item.quantity), 0);
    const pagos = this.getPagosFromForm();
    let suma = pagos.reduce((acc, p) => acc + (parseFloat(p.monto) || 0), 0);
    if (Math.abs(suma - total) > 0.01) {
      this.showNotification('La suma de los pagos debe coincidir con el total de la compra', 'error');
      return;
    }
    // Preparar datos de pago
    const metodosPago = pagos.map(p => ({
      metodo_pago_id: p.metodo_pago_id,
      monto: p.monto,
      referencia: p.referencia,
      fecha: p.fecha,
      banco: p.banco,
      puntos: p.metodo_pago_id == 4 ? pointsToUse : 0
    }));
    try {
      const checkoutData = {
        clienteRif: this.currentUser.cliente_rif,
        productos: this.cart.map(item => ({
          inventario_id: item.id,
          cantidad: item.quantity,
          precio: item.precio
        })),
        metodosPago,
        direccionEnvio: shippingAddress,
        puntosUsados: pointsToUse
      };
      const response = await fetch(`${this.API_BASE_URL}/tienda/checkout`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(checkoutData)
      });
      if (response.ok) {
        const result = await response.json();
        this.cart = [];
        this.saveCart();
        this.updateCartUI();
        this.hideModal(document.getElementById('checkoutModal'));
        this.showNotification('¡Pedido realizado con éxito!', 'success');
        setTimeout(() => {
          this.showProfileModal();
        }, 2000);
      } else {
        const error = await response.json();
        this.showNotification(error.error || 'Error procesando el pedido', 'error');
      }
    } catch (error) {
      console.error('Error procesando checkout:', error);
      this.showNotification('Error procesando el pedido', 'error');
    }
  }

  getToday() {
    const d = new Date();
    return d.toISOString().slice(0, 10);
  }

  logout() {
    localStorage.removeItem('acaucab_current_user');
    sessionStorage.removeItem('acaucab_current_user');
    localStorage.removeItem('acaucab_tienda_cart');
    
    this.showNotification('Sesión cerrada', 'info');
    setTimeout(() => {
      window.location.href = 'login.html';
    }, 1000);
  }

  showNotification(message, type = 'info') {
    const notification = document.getElementById('notification');
    if (!notification) return;

    notification.textContent = message;
    notification.className = `notification ${type}`;
    notification.classList.add('show');

    setTimeout(() => {
      notification.classList.remove('show');
    }, 3000);
  }

  showProfileModal() {
    const modal = document.getElementById('profileModal');
    if (!modal) return;
    // Cargar información del usuario
    const userInfo = document.getElementById('userInfo');
    if (userInfo && this.currentUser) {
      userInfo.innerHTML = `
        <p><strong>Usuario:</strong> ${this.currentUser.nombre_usuario || this.currentUser.username || ''}</p>
        <p><strong>RIF:</strong> ${this.currentUser.cliente_rif || ''}</p>
        <p><strong>Rol:</strong> ${this.currentUser.nombre_rol || (this.currentUser.role && this.currentUser.role.name) || ''}</p>
      `;
    }
    // Cargar puntos
    const userPoints = document.getElementById('userPoints');
    if (userPoints && this.puntos !== undefined) {
      userPoints.innerHTML = `<p><strong>Puntos disponibles:</strong> ${this.puntos}</p>`;
    }
    // Cargar pedidos (puedes mejorar esto con una llamada AJAX si lo deseas)
    const userOrders = document.getElementById('userOrders');
    if (userOrders) {
      userOrders.innerHTML = '<p>Cargando pedidos...</p>';
      // Aquí podrías hacer un fetch a /api/tienda/mis-pedidos/:cliente_rif y mostrar el historial
    }
    this.showModal(modal);
  }
}

// Inicializar la tienda cuando el DOM esté listo
document.addEventListener('DOMContentLoaded', () => {
  const eventosBtn = document.getElementById('eventosBtn');
  if (eventosBtn) {
    eventosBtn.addEventListener('click', () => {
      window.location.href = 'eventos.html';
    });
  }
  window.tienda = new TiendaOnline();
}); 