// Products and Cart System
class ProductsSystem {
  constructor() {
    this.products = []
    this.cart = JSON.parse(localStorage.getItem("acaucab_cart")) || []
    this.favorites = JSON.parse(localStorage.getItem("acaucab_favorites")) || []
    this.orders = JSON.parse(localStorage.getItem("acaucab_orders")) || []
    this.currentUser = null
    this.init()
  }

  init() {
    this.checkAuth()
    this.initializeProducts()
    this.bindEvents()
    this.loadProducts()
    this.updateCartUI()
    this.loadUserData()
  }

  checkAuth() {
    const userData = localStorage.getItem("acaucab_current_user") || sessionStorage.getItem("acaucab_current_user")

    if (!userData) {
      window.location.href = "login.html"
      return
    }

    this.currentUser = JSON.parse(userData)
    this.updateUserUI()
  }

  updateUserUI() {
    const userNameElements = document.querySelectorAll("#userName")
    const profileNameElements = document.querySelectorAll("#profileName")
    const profileEmailElements = document.querySelectorAll("#profileEmail")

    if (this.currentUser) {
      const fullName = `${this.currentUser.firstName} ${this.currentUser.lastName}`

      userNameElements.forEach((el) => {
        if (el) el.textContent = this.currentUser.firstName
      })

      profileNameElements.forEach((el) => {
        if (el) el.textContent = fullName
      })

      profileEmailElements.forEach((el) => {
        if (el) el.textContent = this.currentUser.email
      })
    }
  }

  initializeProducts() {
    this.products = [
      {
        id: 1,
        name: "Destilo Amber Ale",
        category: "ale",
        price: 25.99,
        image: "/placeholder.svg?height=300&width=250",
        description:
          "Primera cerveza genuina ultra Premium tipo Ale hecha en Venezuela. Con un sabor único y balanceado.",
        rating: 4.8,
        reviews: 124,
        alcohol: "5.2%",
        ibu: 35,
        badge: "Premium",
      },
      {
        id: 2,
        name: "Benitz Pale Ale",
        category: "ale",
        price: 22.5,
        image: "/placeholder.svg?height=300&width=250",
        description: "Balance perfecto entre el sabor dulce de las maltas y el suave amargor del lúpulo.",
        rating: 4.6,
        reviews: 89,
        alcohol: "4.8%",
        ibu: 28,
        badge: "Popular",
      },
      {
        id: 3,
        name: "Mito Candileja",
        category: "ale",
        price: 28.75,
        image: "/placeholder.svg?height=300&width=250",
        description: "Inspirada en técnicas monásticas, con intenso aroma a caramelo y frutas.",
        rating: 4.9,
        reviews: 156,
        alcohol: "6.5%",
        ibu: 22,
        badge: "Artesanal",
      },
      {
        id: 4,
        name: "Caracas Lager",
        category: "lager",
        price: 18.99,
        image: "/placeholder.svg?height=300&width=250",
        description: "Cerveza ligera y refrescante, perfecta para el clima tropical venezolano.",
        rating: 4.3,
        reviews: 203,
        alcohol: "4.2%",
        ibu: 18,
        badge: "Refrescante",
      },
      {
        id: 5,
        name: "Maracaibo Stout",
        category: "stout",
        price: 32.0,
        image: "/placeholder.svg?height=300&width=250",
        description: "Cerveza oscura con notas de chocolate y café, inspirada en el cacao venezolano.",
        rating: 4.7,
        reviews: 78,
        alcohol: "7.2%",
        ibu: 45,
        badge: "Especial",
      },
      {
        id: 6,
        name: "Valencia IPA",
        category: "ipa",
        price: 29.99,
        image: "/placeholder.svg?height=300&width=250",
        description: "India Pale Ale con lúpulos tropicales y un amargor pronunciado.",
        rating: 4.5,
        reviews: 112,
        alcohol: "6.8%",
        ibu: 65,
        badge: "Lupulada",
      },
      {
        id: 7,
        name: "Andes Golden",
        category: "lager",
        price: 21.25,
        image: "/placeholder.svg?height=300&width=250",
        description: "Lager dorada con maltas especiales y un acabado suave y limpio.",
        rating: 4.4,
        reviews: 167,
        alcohol: "4.5%",
        ibu: 20,
        badge: "Suave",
      },
      {
        id: 8,
        name: "Orinoco Porter",
        category: "stout",
        price: 26.5,
        image: "/placeholder.svg?height=300&width=250",
        description: "Porter robusta con sabores tostados y un final ligeramente dulce.",
        rating: 4.6,
        reviews: 94,
        alcohol: "5.8%",
        ibu: 38,
        badge: "Tostada",
      },
    ]
  }

  bindEvents() {
    // Search
    const searchInput = document.getElementById("searchInput")
    if (searchInput) {
      searchInput.addEventListener("input", (e) => this.handleSearch(e.target.value))
    }

    // Filters
    const categoryFilter = document.getElementById("categoryFilter")
    const priceFilter = document.getElementById("priceFilter")
    const sortFilter = document.getElementById("sortFilter")

    if (categoryFilter) categoryFilter.addEventListener("change", () => this.applyFilters())
    if (priceFilter) priceFilter.addEventListener("change", () => this.applyFilters())
    if (sortFilter) sortFilter.addEventListener("change", () => this.applyFilters())

    // Cart
    const cartBtn = document.getElementById("cartBtn")
    const closeCart = document.getElementById("closeCart")
    const checkoutBtn = document.getElementById("checkoutBtn")

    if (cartBtn) cartBtn.addEventListener("click", () => this.toggleCart())
    if (closeCart) closeCart.addEventListener("click", () => this.toggleCart())
    if (checkoutBtn) checkoutBtn.addEventListener("click", () => this.goToCheckout())

    // Modal
    const closeModal = document.getElementById("closeModal")
    const modal = document.getElementById("productModal")

    if (closeModal) closeModal.addEventListener("click", () => this.closeModal())
    if (modal) {
      modal.addEventListener("click", (e) => {
        if (e.target === modal) this.closeModal()
      })
    }

    // Profile tabs
    document.querySelectorAll(".profile-nav-item").forEach((item) => {
      item.addEventListener("click", (e) => this.switchProfileTab(e))
    })

    // Profile forms
    const profileForm = document.getElementById("profileForm")
    const passwordForm = document.getElementById("passwordForm")

    if (profileForm) profileForm.addEventListener("submit", (e) => this.updateProfile(e))
    if (passwordForm) passwordForm.addEventListener("submit", (e) => this.changePassword(e))

    // Checkout
    const checkoutForm = document.getElementById("checkoutForm")
    const placeOrderBtn = document.getElementById("placeOrderBtn")

    if (checkoutForm) {
      const paymentMethods = checkoutForm.querySelectorAll('input[name="paymentMethod"]')
      paymentMethods.forEach((method) => {
        method.addEventListener("change", () => this.toggleCardDetails())
      })
    }

    if (placeOrderBtn) placeOrderBtn.addEventListener("click", () => this.placeOrder())

    // Logout
    document.querySelectorAll("#logoutBtn").forEach((btn) => {
      btn.addEventListener("click", (e) => this.handleLogout(e))
    })
  }

  loadProducts() {
    const productsGrid = document.getElementById("productsGrid")
    if (!productsGrid) return

    productsGrid.innerHTML = ""

    this.products.forEach((product) => {
      const productCard = this.createProductCard(product)
      productsGrid.appendChild(productCard)
    })
  }

  createProductCard(product) {
    const isFavorite = this.favorites.includes(product.id)

    const card = document.createElement("div")
    card.className = "product-card"
    card.innerHTML = `
            <div class="product-image">
                <img src="${product.image}" alt="${product.name}">
                <div class="product-badge">${product.badge}</div>
                <button class="favorite-btn ${isFavorite ? "active" : ""}" data-id="${product.id}">
                    <i class="fas fa-heart"></i>
                </button>
            </div>
            <div class="product-info">
                <div class="product-category">${product.category.toUpperCase()}</div>
                <h3 class="product-name">${product.name}</h3>
                <p class="product-description">${product.description}</p>
                <div class="product-rating">
                    <div class="stars">
                        ${this.generateStars(product.rating)}
                    </div>
                    <span class="rating-text">${product.rating} (${product.reviews} reseñas)</span>
                </div>
                <div class="product-footer">
                    <span class="product-price">$${product.price}</span>
                    <button class="add-to-cart" data-id="${product.id}">
                        <i class="fas fa-cart-plus"></i>
                    </button>
                </div>
            </div>
        `

    // Add event listeners
    card.addEventListener("click", (e) => {
      if (!e.target.closest(".favorite-btn") && !e.target.closest(".add-to-cart")) {
        this.showProductModal(product)
      }
    })

    card.querySelector(".favorite-btn").addEventListener("click", (e) => {
      e.stopPropagation()
      this.toggleFavorite(product.id)
    })

    card.querySelector(".add-to-cart").addEventListener("click", (e) => {
      e.stopPropagation()
      this.addToCart(product.id)
    })

    return card
  }

  generateStars(rating) {
    const fullStars = Math.floor(rating)
    const hasHalfStar = rating % 1 !== 0
    let stars = ""

    for (let i = 0; i < fullStars; i++) {
      stars += '<i class="fas fa-star star"></i>'
    }

    if (hasHalfStar) {
      stars += '<i class="fas fa-star-half-alt star"></i>'
    }

    const emptyStars = 5 - Math.ceil(rating)
    for (let i = 0; i < emptyStars; i++) {
      stars += '<i class="far fa-star star"></i>'
    }

    return stars
  }

  showProductModal(product) {
    const modal = document.getElementById("productModal")
    const modalBody = document.getElementById("modalBody")

    if (!modal || !modalBody) return

    modalBody.innerHTML = `
            <div class="product-modal-content">
                <div class="modal-image">
                    <img src="${product.image}" alt="${product.name}">
                </div>
                <div class="modal-info">
                    <div class="product-category">${product.category.toUpperCase()}</div>
                    <h2>${product.name}</h2>
                    <div class="product-rating">
                        <div class="stars">${this.generateStars(product.rating)}</div>
                        <span class="rating-text">${product.rating} (${product.reviews} reseñas)</span>
                    </div>
                    <p class="product-description">${product.description}</p>
                    <div class="product-specs">
                        <div class="spec">
                            <strong>Alcohol:</strong> ${product.alcohol}
                        </div>
                        <div class="spec">
                            <strong>IBU:</strong> ${product.ibu}
                        </div>
                    </div>
                    <div class="modal-footer">
                        <span class="product-price">$${product.price}</span>
                        <button class="btn-primary" onclick="productsSystem.addToCart(${product.id})">
                            <i class="fas fa-cart-plus"></i>
                            Agregar al Carrito
                        </button>
                    </div>
                </div>
            </div>
        `

    modal.style.display = "block"
  }

  closeModal() {
    const modal = document.getElementById("productModal")
    if (modal) {
      modal.style.display = "none"
    }
  }

  addToCart(productId) {
    const product = this.products.find((p) => p.id === productId)
    if (!product) return

    const existingItem = this.cart.find((item) => item.id === productId)

    if (existingItem) {
      existingItem.quantity += 1
    } else {
      this.cart.push({
        ...product,
        quantity: 1,
      })
    }

    this.saveCart()
    this.updateCartUI()
    this.showNotification(`${product.name} agregado al carrito`, "success")
  }

  removeFromCart(productId) {
    this.cart = this.cart.filter((item) => item.id !== productId)
    this.saveCart()
    this.updateCartUI()
  }

  updateQuantity(productId, quantity) {
    const item = this.cart.find((item) => item.id === productId)
    if (item) {
      if (quantity <= 0) {
        this.removeFromCart(productId)
      } else {
        item.quantity = quantity
        this.saveCart()
        this.updateCartUI()
      }
    }
  }

  saveCart() {
    localStorage.setItem("acaucab_cart", JSON.stringify(this.cart))
  }

  updateCartUI() {
    const cartCount = document.getElementById("cartCount")
    const cartItems = document.getElementById("cartItems")
    const cartTotal = document.getElementById("cartTotal")

    if (cartCount) {
      const totalItems = this.cart.reduce((sum, item) => sum + item.quantity, 0)
      cartCount.textContent = totalItems
    }

    if (cartItems) {
      cartItems.innerHTML = ""

      if (this.cart.length === 0) {
        cartItems.innerHTML =
          '<p style="text-align: center; color: var(--gray-color); padding: 2rem;">Tu carrito está vacío</p>'
      } else {
        this.cart.forEach((item) => {
          const cartItem = document.createElement("div")
          cartItem.className = "cart-item"
          cartItem.innerHTML = `
                        <div class="cart-item-image">
                            <img src="${item.image}" alt="${item.name}">
                        </div>
                        <div class="cart-item-info">
                            <div class="cart-item-name">${item.name}</div>
                            <div class="cart-item-price">$${item.price}</div>
                            <div class="cart-item-controls">
                                <button class="quantity-btn" onclick="productsSystem.updateQuantity(${item.id}, ${item.quantity - 1})">
                                    <i class="fas fa-minus"></i>
                                </button>
                                <input type="number" class="quantity" value="${item.quantity}" min="1" 
                                       onchange="productsSystem.updateQuantity(${item.id}, parseInt(this.value))">
                                <button class="quantity-btn" onclick="productsSystem.updateQuantity(${item.id}, ${item.quantity + 1})">
                                    <i class="fas fa-plus"></i>
                                </button>
                                <button class="remove-item" onclick="productsSystem.removeFromCart(${item.id})">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </div>
                        </div>
                    `
          cartItems.appendChild(cartItem)
        })
      }
    }

    if (cartTotal) {
      const total = this.cart.reduce((sum, item) => sum + item.price * item.quantity, 0)
      cartTotal.textContent = total.toFixed(2)
    }
  }

  toggleCart() {
    const cartSidebar = document.getElementById("cartSidebar")
    if (cartSidebar) {
      cartSidebar.classList.toggle("open")
    }
  }

  toggleFavorite(productId) {
    const index = this.favorites.indexOf(productId)

    if (index > -1) {
      this.favorites.splice(index, 1)
    } else {
      this.favorites.push(productId)
    }

    localStorage.setItem("acaucab_favorites", JSON.stringify(this.favorites))
    this.loadProducts() // Reload to update favorite buttons
  }

  handleSearch(query) {
    const filteredProducts = this.products.filter(
      (product) =>
        product.name.toLowerCase().includes(query.toLowerCase()) ||
        product.description.toLowerCase().includes(query.toLowerCase()) ||
        product.category.toLowerCase().includes(query.toLowerCase()),
    )

    this.displayProducts(filteredProducts)
  }

  applyFilters() {
    const categoryFilter = document.getElementById("categoryFilter")?.value
    const priceFilter = document.getElementById("priceFilter")?.value
    const sortFilter = document.getElementById("sortFilter")?.value

    let filteredProducts = [...this.products]

    // Category filter
    if (categoryFilter) {
      filteredProducts = filteredProducts.filter((p) => p.category === categoryFilter)
    }

    // Price filter
    if (priceFilter) {
      const [min, max] = priceFilter.split("-").map((p) => p.replace("+", ""))
      filteredProducts = filteredProducts.filter((p) => {
        if (max) {
          return p.price >= Number.parseFloat(min) && p.price <= Number.parseFloat(max)
        } else {
          return p.price >= Number.parseFloat(min)
        }
      })
    }

    // Sort
    if (sortFilter) {
      switch (sortFilter) {
        case "name":
          filteredProducts.sort((a, b) => a.name.localeCompare(b.name))
          break
        case "price-low":
          filteredProducts.sort((a, b) => a.price - b.price)
          break
        case "price-high":
          filteredProducts.sort((a, b) => b.price - a.price)
          break
        case "rating":
          filteredProducts.sort((a, b) => b.rating - a.rating)
          break
      }
    }

    this.displayProducts(filteredProducts)
  }

  displayProducts(products) {
    const productsGrid = document.getElementById("productsGrid")
    if (!productsGrid) return

    productsGrid.innerHTML = ""

    products.forEach((product) => {
      const productCard = this.createProductCard(product)
      productsGrid.appendChild(productCard)
    })
  }

  goToCheckout() {
    if (this.cart.length === 0) {
      this.showNotification("Tu carrito está vacío", "error")
      return
    }
    window.location.href = "checkout.html"
  }

  loadUserData() {
    if (window.location.pathname.includes("profile.html")) {
      this.loadProfileData()
      this.loadOrdersData()
      this.loadFavoritesData()
    }

    if (window.location.pathname.includes("checkout.html")) {
      this.loadCheckoutData()
    }
  }

  loadProfileData() {
    if (!this.currentUser) return

    const form = document.getElementById("profileForm")
    if (form) {
      form.firstName.value = this.currentUser.firstName || ""
      form.lastName.value = this.currentUser.lastName || ""
      form.email.value = this.currentUser.email || ""
      form.phone.value = this.currentUser.phone || ""
      form.address.value = this.currentUser.address || ""
    }
  }

  loadOrdersData() {
    const ordersList = document.getElementById("ordersList")
    if (!ordersList) return

    const userOrders = this.orders.filter((order) => order.userId === this.currentUser.id)

    if (userOrders.length === 0) {
      ordersList.innerHTML =
        '<p style="text-align: center; color: var(--gray-color); padding: 2rem;">No tienes pedidos aún</p>'
    } else {
      ordersList.innerHTML = userOrders
        .map(
          (order) => `
                <div class="order-item">
                    <div class="order-header">
                        <h4>Pedido #${order.id}</h4>
                        <span class="order-date">${new Date(order.date).toLocaleDateString()}</span>
                    </div>
                    <div class="order-status">Estado: ${order.status}</div>
                    <div class="order-total">Total: $${order.total}</div>
                </div>
            `,
        )
        .join("")
    }
  }

  loadFavoritesData() {
    const favoritesGrid = document.getElementById("favoritesGrid")
    if (!favoritesGrid) return

    const favoriteProducts = this.products.filter((p) => this.favorites.includes(p.id))

    if (favoriteProducts.length === 0) {
      favoritesGrid.innerHTML =
        '<p style="text-align: center; color: var(--gray-color); padding: 2rem;">No tienes productos favoritos</p>'
    } else {
      favoritesGrid.innerHTML = ""
      favoriteProducts.forEach((product) => {
        const productCard = this.createProductCard(product)
        favoritesGrid.appendChild(productCard)
      })
    }
  }

  loadCheckoutData() {
    if (!this.currentUser) return

    // Load user data into checkout form
    const form = document.getElementById("checkoutForm")
    if (form) {
      form.firstName.value = this.currentUser.firstName || ""
      form.lastName.value = this.currentUser.lastName || ""
      form.email.value = this.currentUser.email || ""
      form.phone.value = this.currentUser.phone || ""
      form.address.value = this.currentUser.address || ""
    }

    // Load order items
    this.updateCheckoutUI()
  }

  updateCheckoutUI() {
    const orderItems = document.getElementById("orderItems")
    const subtotalEl = document.getElementById("subtotal")
    const taxEl = document.getElementById("tax")
    const totalEl = document.getElementById("total")

    if (orderItems) {
      orderItems.innerHTML = this.cart
        .map(
          (item) => `
                <div class="order-item">
                    <div class="item-info">
                        <h4>${item.name}</h4>
                        <p>Cantidad: ${item.quantity}</p>
                    </div>
                    <div class="item-price">$${(item.price * item.quantity).toFixed(2)}</div>
                </div>
            `,
        )
        .join("")
    }

    const subtotal = this.cart.reduce((sum, item) => sum + item.price * item.quantity, 0)
    const shipping = 5.0
    const tax = subtotal * 0.16 // 16% IVA
    const total = subtotal + shipping + tax

    if (subtotalEl) subtotalEl.textContent = subtotal.toFixed(2)
    if (taxEl) taxEl.textContent = tax.toFixed(2)
    if (totalEl) totalEl.textContent = total.toFixed(2)
  }

  switchProfileTab(e) {
    e.preventDefault()

    const tabName = e.target.closest(".profile-nav-item").dataset.tab

    // Update active nav item
    document.querySelectorAll(".profile-nav-item").forEach((item) => {
      item.classList.remove("active")
    })
    e.target.closest(".profile-nav-item").classList.add("active")

    // Show corresponding tab
    document.querySelectorAll(".profile-tab").forEach((tab) => {
      tab.classList.remove("active")
    })

    const targetTab = document.getElementById(tabName)
    if (targetTab) {
      targetTab.classList.add("active")
    }
  }

  updateProfile(e) {
    e.preventDefault()

    const formData = new FormData(e.target)
    const userData = {
      firstName: formData.get("firstName"),
      lastName: formData.get("lastName"),
      email: formData.get("email"),
      phone: formData.get("phone"),
      address: formData.get("address"),
    }

    if (window.authSystem && window.authSystem.updateUser(userData)) {
      this.currentUser = { ...this.currentUser, ...userData }
      this.updateUserUI()
      this.showNotification("Perfil actualizado exitosamente", "success")
    } else {
      this.showNotification("Error al actualizar el perfil", "error")
    }
  }

  changePassword(e) {
    e.preventDefault()

    const formData = new FormData(e.target)
    const currentPassword = formData.get("currentPassword")
    const newPassword = formData.get("newPassword")
    const confirmPassword = formData.get("confirmNewPassword")

    if (currentPassword !== this.currentUser.password) {
      this.showNotification("La contraseña actual es incorrecta", "error")
      return
    }

    if (newPassword !== confirmPassword) {
      this.showNotification("Las nuevas contraseñas no coinciden", "error")
      return
    }

    if (window.authSystem && window.authSystem.updateUser({ password: newPassword })) {
      this.currentUser.password = newPassword
      this.showNotification("Contraseña cambiada exitosamente", "success")
      e.target.reset()
    } else {
      this.showNotification("Error al cambiar la contraseña", "error")
    }
  }

  toggleCardDetails() {
    const cardDetails = document.getElementById("cardDetails")
    const paymentMethod = document.querySelector('input[name="paymentMethod"]:checked')?.value

    if (cardDetails) {
      cardDetails.style.display = paymentMethod === "card" ? "block" : "none"
    }
  }

  placeOrder() {
    if (this.cart.length === 0) {
      this.showNotification("Tu carrito está vacío", "error")
      return
    }

    const form = document.getElementById("checkoutForm")
    if (!form.checkValidity()) {
      this.showNotification("Por favor, completa todos los campos requeridos", "error")
      return
    }

    // Create order
    const order = {
      id: Date.now(),
      userId: this.currentUser.id,
      items: [...this.cart],
      total:
        this.cart.reduce((sum, item) => sum + item.price * item.quantity, 0) +
        5 +
        this.cart.reduce((sum, item) => sum + item.price * item.quantity, 0) * 0.16,
      status: "Procesando",
      date: new Date().toISOString(),
    }

    this.orders.push(order)
    localStorage.setItem("acaucab_orders", JSON.stringify(this.orders))

    // Clear cart
    this.cart = []
    this.saveCart()

    this.showNotification("¡Pedido realizado exitosamente!", "success")

    setTimeout(() => {
      window.location.href = "products.html"
    }, 2000)
  }

  handleLogout(e) {
    e.preventDefault()

    if (window.authSystem) {
      window.authSystem.handleLogout(e)
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
}

// Initialize products system
const productsSystem = new ProductsSystem()

// Make it globally available
window.productsSystem = productsSystem
