// Ördin Landing Page JavaScript

// Tab Switching for Installation Guide
document.addEventListener('DOMContentLoaded', function() {
    const tabButtons = document.querySelectorAll('.tab-btn');
    const tabContents = document.querySelectorAll('.tab-content');
    
    tabButtons.forEach(button => {
        button.addEventListener('click', function() {
            const targetTab = this.getAttribute('data-tab');
            
            // Remove active class from all buttons and contents
            tabButtons.forEach(btn => btn.classList.remove('active'));
            tabContents.forEach(content => content.classList.remove('active'));
            
            // Add active class to clicked button and corresponding content
            this.classList.add('active');
            document.getElementById(targetTab).classList.add('active');
        });
    });
});

// Smooth Scroll for Navigation Links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    });
});

// Navbar Background on Scroll
window.addEventListener('scroll', function() {
    const navbar = document.querySelector('.navbar');
    if (window.scrollY > 50) {
        navbar.style.background = 'rgba(37, 37, 38, 0.95)';
    } else {
        navbar.style.background = 'var(--bg-light)';
    }
});

// Download Button Click Tracking (Optional - for analytics)
document.querySelectorAll('.btn-download').forEach(button => {
    button.addEventListener('click', function() {
        const os = this.closest('.download-card').querySelector('h3').textContent;
        console.log('Download initiated for:', os);
        // You can add analytics tracking here (e.g., Google Analytics)
    });
});

// Lazy Load Images (Performance Optimization)
if ('IntersectionObserver' in window) {
    const imageObserver = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const img = entry.target;
                if (img.dataset.src) {
                    img.src = img.dataset.src;
                    img.removeAttribute('data-src');
                }
                observer.unobserve(img);
            }
        });
    });

    document.querySelectorAll('img[data-src]').forEach(img => {
        imageObserver.observe(img);
    });
}

// Copy Code Block on Click
document.querySelectorAll('.code-block code').forEach(codeBlock => {
    codeBlock.style.cursor = 'pointer';
    codeBlock.title = 'Click to copy';
    
    codeBlock.addEventListener('click', function() {
        const text = this.textContent.replace(/<br>/g, '\n');
        navigator.clipboard.writeText(text).then(() => {
            // Show feedback
            const originalTitle = this.title;
            this.title = 'Copied!';
            setTimeout(() => {
                this.title = originalTitle;
            }, 2000);
        });
    });
});

// Mobile Menu Toggle (for future responsive menu)
const menuToggle = document.querySelector('.menu-toggle');
const navLinks = document.querySelector('.nav-links');

if (menuToggle) {
    menuToggle.addEventListener('click', function() {
        navLinks.classList.toggle('active');
    });
}

// Detect OS and highlight appropriate download
function detectOS() {
    const userAgent = window.navigator.userAgent.toLowerCase();
    const platform = window.navigator.platform.toLowerCase();
    
    let os = 'unknown';
    
    if (platform.indexOf('win') !== -1) {
        os = 'windows';
    } else if (platform.indexOf('mac') !== -1) {
        os = 'macos';
    } else if (platform.indexOf('linux') !== -1) {
        os = 'linux';
    }
    
    // Highlight the appropriate download card
    const downloadCards = document.querySelectorAll('.download-card');
    downloadCards.forEach(card => {
        const cardTitle = card.querySelector('h3').textContent.toLowerCase();
        if (cardTitle.includes(os)) {
            card.style.borderColor = 'var(--primary-color)';
            card.style.boxShadow = '0 0 20px rgba(46, 139, 87, 0.3)';
            
            // Add "Recommended" badge
            const badge = document.createElement('div');
            badge.textContent = 'Recommended for your system';
            badge.style.cssText = `
                background: var(--primary-color);
                color: white;
                padding: 6px 12px;
                border-radius: 4px;
                font-size: 12px;
                font-weight: 600;
                text-align: center;
                margin-top: 10px;
            `;
            card.appendChild(badge);
        }
    });
}

// Run OS detection when page loads
window.addEventListener('load', detectOS);

// Animate elements on scroll
function animateOnScroll() {
    const elements = document.querySelectorAll('.feature-card, .download-card, .doc-card, .screenshot-item');
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '0';
                entry.target.style.transform = 'translateY(30px)';
                entry.target.style.transition = 'all 0.6s ease';
                
                setTimeout(() => {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }, 100);
                
                observer.unobserve(entry.target);
            }
        });
    }, { threshold: 0.1 });
    
    elements.forEach(element => {
        observer.observe(element);
    });
}

// Run animations when page loads
window.addEventListener('load', animateOnScroll);

// External Link Icon
document.querySelectorAll('a[target="_blank"]').forEach(link => {
    if (!link.querySelector('i')) {
        link.innerHTML += ' <i class="fas fa-external-link-alt" style="font-size: 0.8em; margin-left: 4px;"></i>';
    }
});

// Version Check (Optional - check for updates)
async function checkLatestVersion() {
    try {
        const response = await fetch('https://api.github.com/repos/jm0535/0rdin/releases/latest');
        const data = await response.json();
        const latestVersion = data.tag_name || data.name;
        
        // Update version badges if needed
        const versionBadges = document.querySelectorAll('.version-badge');
        versionBadges.forEach(badge => {
            if (latestVersion && latestVersion !== badge.textContent) {
                badge.textContent = latestVersion;
            }
        });
    } catch (error) {
        console.log('Could not check for updates:', error);
    }
}

// Check version on load (optional)
// window.addEventListener('load', checkLatestVersion);
