// DOM Elements
const menuToggle = document.getElementById("menuToggle")
const navMenu = document.getElementById("navMenu")
const searchBtn = document.getElementById("searchBtn")
const searchOverlay = document.getElementById("searchOverlay")
const searchClose = document.getElementById("searchClose")
const userBtn = document.getElementById("userBtn")
const cartBtn = document.getElementById("cartBtn")

// Mobile Menu Toggle
menuToggle.addEventListener("click", () => {
  navMenu.classList.toggle("active")

  // Animate hamburger menu
  const spans = menuToggle.querySelectorAll("span")
  if (navMenu.classList.contains("active")) {
    spans[0].style.transform = "rotate(45deg) translate(5px, 5px)"
    spans[1].style.opacity = "0"
    spans[2].style.transform = "rotate(-45deg) translate(7px, -6px)"
  } else {
    spans[0].style.transform = "none"
    spans[1].style.opacity = "1"
    spans[2].style.transform = "none"
  }
})

// Search Overlay
searchBtn.addEventListener("click", () => {
  searchOverlay.style.display = "flex"
  setTimeout(() => {
    searchOverlay.querySelector(".search-input").focus()
  }, 100)
})

// User button functionality
userBtn.addEventListener("click", () => {
  // Check if user is logged in
  const userData = localStorage.getItem("acaucab_user") || sessionStorage.getItem("acaucab_user")

  if (userData) {
    // User is logged in, go to dashboard
    window.location.href = "dashboard.html"
  } else {
    // User is not logged in, go to login
    window.location.href = "login.html"
  }
})

searchClose.addEventListener("click", () => {
  searchOverlay.style.display = "none"
})

searchOverlay.addEventListener("click", (e) => {
  if (e.target === searchOverlay) {
    searchOverlay.style.display = "none"
  }
})

// Close mobile menu when clicking on a link
navMenu.querySelectorAll("a").forEach((link) => {
  link.addEventListener("click", () => {
    navMenu.classList.remove("active")
    const spans = menuToggle.querySelectorAll("span")
    spans[0].style.transform = "none"
    spans[1].style.opacity = "1"
    spans[2].style.transform = "none"
  })
})

// Smooth scrolling for anchor links
document.querySelectorAll('a[href^="#"]').forEach((anchor) => {
  anchor.addEventListener("click", function (e) {
    e.preventDefault()
    const target = document.querySelector(this.getAttribute("href"))
    if (target) {
      target.scrollIntoView({
        behavior: "smooth",
        block: "start",
      })
    }
  })
})

// Header scroll effect
let lastScrollTop = 0
const header = document.querySelector(".header")

window.addEventListener("scroll", () => {
  const scrollTop = window.pageYOffset || document.documentElement.scrollTop

  if (scrollTop > lastScrollTop && scrollTop > 100) {
    // Scrolling down
    header.style.transform = "translateY(-100%)"
  } else {
    // Scrolling up
    header.style.transform = "translateY(0)"
  }

  lastScrollTop = scrollTop
})

// Intersection Observer for animations
const observerOptions = {
  threshold: 0.1,
  rootMargin: "0px 0px -50px 0px",
}

const observer = new IntersectionObserver((entries) => {
  entries.forEach((entry) => {
    if (entry.isIntersecting) {
      entry.target.style.opacity = "1"
      entry.target.style.transform = "translateY(0)"
    }
  })
}, observerOptions)

// Observe elements for animation
document.querySelectorAll(".feature-card, .product-card").forEach((el) => {
  el.style.opacity = "0"
  el.style.transform = "translateY(30px)"
  el.style.transition = "opacity 0.6s ease, transform 0.6s ease"
  observer.observe(el)
})

// Newsletter form
const newsletterForm = document.querySelector(".newsletter-form")
const newsletterInput = document.querySelector(".newsletter-input")

newsletterForm.addEventListener("submit", (e) => {
  e.preventDefault()
  const email = newsletterInput.value.trim()

  if (email && isValidEmail(email)) {
    // Simulate API call
    showNotification("¡Gracias por suscribirte! Recibirás nuestro DiarioDeUnaCerveza.", "success")
    newsletterInput.value = ""
  } else {
    showNotification("Por favor, ingresa un email válido.", "error")
  }
})

// Email validation
function isValidEmail(email) {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  return emailRegex.test(email)
}

// Notification system
function showNotification(message, type = "info") {
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
      document.body.removeChild(notification)
    }, 300)
  }, 4000)
}

// Cart functionality (basic)
let cartCount = 0
const cartCountElement = document.querySelector(".cart-count")

function updateCartCount() {
  cartCountElement.textContent = cartCount
  cartCountElement.style.display = cartCount > 0 ? "block" : "none"
}

// Product card interactions
document.querySelectorAll(".product-card .btn").forEach((btn) => {
  btn.addEventListener("click", (e) => {
    e.preventDefault()
    cartCount++
    updateCartCount()
    showNotification("Producto agregado al carrito", "success")
  })
})

// Hero buttons functionality
document.querySelectorAll(".hero-buttons .btn").forEach((btn) => {
  btn.addEventListener("click", (e) => {
    e.preventDefault()
    const text = btn.textContent.trim()
    if (text.includes("Explorar")) {
      document.querySelector(".products-preview")?.scrollIntoView({ behavior: "smooth" })
    } else if (text.includes("Miembros")) {
      showNotification("Sección de miembros en desarrollo", "info")
    }
  })
})

// Initialize cart count
updateCartCount()

// Keyboard navigation
document.addEventListener("keydown", (e) => {
  if (e.key === "Escape") {
    if (searchOverlay.style.display === "flex") {
      searchOverlay.style.display = "none"
    }
    if (navMenu.classList.contains("active")) {
      navMenu.classList.remove("active")
    }
  }
})

// Performance optimization: Lazy loading for images
if ("IntersectionObserver" in window) {
  const imageObserver = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        const img = entry.target
        if (img.dataset.src) {
          img.src = img.dataset.src
          img.removeAttribute("data-src")
          imageObserver.unobserve(img)
        }
      }
    })
  })

  document.querySelectorAll("img[data-src]").forEach((img) => {
    imageObserver.observe(img)
  })
}

console.log("ACAUCAB Website loaded successfully! 🍺")
