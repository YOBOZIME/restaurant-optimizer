// Configuration de l'application
const AppConfig = {
    API_BASE_URL: '/api',
    DEBOUNCE_DELAY: 300,
    TOAST_DURATION: 3000
};

// Gestionnaire de notifications
class NotificationManager {
    constructor() {
        this.notificationContainer = this.createNotificationContainer();
    }

    createNotificationContainer() {
        const container = document.createElement('div');
        container.className = 'notification-container';
        container.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
            display: flex;
            flex-direction: column;
            gap: 10px;
        `;
        document.body.appendChild(container);
        return container;
    }

    show(message, type = 'info') {
        const notification = document.createElement('div');
        notification.className = `notification notification-${type}`;
        notification.style.cssText = `
            background: ${this.getBackgroundColor(type)};
            color: white;
            padding: 15px 20px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            animation: slideIn 0.3s ease;
            display: flex;
            align-items: center;
            gap: 10px;
            min-width: 300px;
        `;

        const icon = this.getIcon(type);
        notification.innerHTML = `
            <i class="fas ${icon}"></i>
            <span>${message}</span>
        `;

        this.notificationContainer.appendChild(notification);

        // Auto-remove after duration
        setTimeout(() => {
            notification.style.animation = 'slideOut 0.3s ease';
            setTimeout(() => notification.remove(), 300);
        }, AppConfig.TOAST_DURATION);

        // Add CSS animations
        this.addAnimations();
    }

    getBackgroundColor(type) {
        const colors = {
            success: '#4CAF50',
            error: '#F44336',
            warning: '#FF9800',
            info: '#2196F3'
        };
        return colors[type] || colors.info;
    }

    getIcon(type) {
        const icons = {
            success: 'fa-check-circle',
            error: 'fa-exclamation-circle',
            warning: 'fa-exclamation-triangle',
            info: 'fa-info-circle'
        };
        return icons[type] || icons.info;
    }

    addAnimations() {
        if (!document.getElementById('notification-animations')) {
            const style = document.createElement('style');
            style.id = 'notification-animations';
            style.textContent = `
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
            document.head.appendChild(style);
        }
    }
}

// Gestionnaire de formulaires
class FormManager {
    constructor(formId) {
        this.form = document.getElementById(formId);
        this.init();
    }

    init() {
        if (this.form) {
            this.form.addEventListener('submit', this.handleSubmit.bind(this));
            this.setupValidation();
        }
    }

    setupValidation() {
        const inputs = this.form.querySelectorAll('input[required], select[required], textarea[required]');
        inputs.forEach(input => {
            input.addEventListener('blur', () => this.validateField(input));
            input.addEventListener('input', () => this.clearError(input));
        });
    }

    validateField(field) {
        if (!field.value.trim()) {
            this.showError(field, 'Ce champ est obligatoire');
            return false;
        }

        if (field.type === 'email' && !this.isValidEmail(field.value)) {
            this.showError(field, 'Veuillez entrer un email valide');
            return false;
        }

        if (field.type === 'number' && field.min && parseFloat(field.value) < parseFloat(field.min)) {
            this.showError(field, `La valeur doit être supérieure ou égale à ${field.min}`);
            return false;
        }

        this.clearError(field);
        return true;
    }

    isValidEmail(email) {
        return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
    }

    showError(field, message) {
        this.clearError(field);

        const error = document.createElement('div');
        error.className = 'error-message';
        error.style.cssText = `
            color: #F44336;
            font-size: 12px;
            margin-top: 5px;
        `;
        error.textContent = message;

        field.parentNode.appendChild(error);
        field.style.borderColor = '#F44336';
    }

    clearError(field) {
        const error = field.parentNode.querySelector('.error-message');
        if (error) error.remove();
        field.style.borderColor = '';
    }

    async handleSubmit(event) {
        event.preventDefault();

        const inputs = this.form.querySelectorAll('input[required], select[required], textarea[required]');
        let isValid = true;

        inputs.forEach(input => {
            if (!this.validateField(input)) {
                isValid = false;
            }
        });

        if (!isValid) {
            notifications.show('Veuillez corriger les erreurs dans le formulaire', 'error');
            return;
        }

        const formData = new FormData(this.form);
        const data = Object.fromEntries(formData.entries());

        try {
            await this.submitData(data);
        } catch (error) {
            console.error('Form submission error:', error);
            notifications.show('Erreur lors de l\'envoi du formulaire', 'error');
        }
    }

    async submitData(data) {
        // Override this method in child classes
        console.log('Form data:', data);
        notifications.show('Formulaire soumis avec succès', 'success');
        return Promise.resolve();
    }
}

// Gestionnaire de tableaux
class TableManager {
    constructor(tableId, options = {}) {
        this.table = document.getElementById(tableId);
        this.options = options;
        this.init();
    }

    init() {
        if (this.table) {
            this.setupSorting();
            this.setupPagination();
        }
    }

    setupSorting() {
        const headers = this.table.querySelectorAll('th[data-sort]');
        headers.forEach(header => {
            header.style.cursor = 'pointer';
            header.addEventListener('click', () => this.sortTable(header));
        });
    }

    sortTable(header) {
        const columnIndex = Array.from(header.parentNode.children).indexOf(header);
        const isAscending = header.getAttribute('data-sort') === 'asc';
        const newSortOrder = isAscending ? 'desc' : 'asc';

        // Update sort indicators
        headers.forEach(h => {
            h.removeAttribute('data-sort');
            h.querySelector('.sort-indicator')?.remove();
        });

        header.setAttribute('data-sort', newSortOrder);

        const indicator = document.createElement('span');
        indicator.className = 'sort-indicator';
        indicator.textContent = newSortOrder === 'asc' ? ' ↑' : ' ↓';
        header.appendChild(indicator);

        // Sort table rows
        const tbody = this.table.querySelector('tbody');
        const rows = Array.from(tbody.querySelectorAll('tr'));

        rows.sort((a, b) => {
            const aValue = a.children[columnIndex].textContent.trim();
            const bValue = b.children[columnIndex].textContent.trim();

            // Try to convert to numbers if possible
            const aNum = parseFloat(aValue.replace(/[^\d.-]/g, ''));
            const bNum = parseFloat(bValue.replace(/[^\d.-]/g, ''));

            if (!isNaN(aNum) && !isNaN(bNum)) {
                return isAscending ? bNum - aNum : aNum - bNum;
            }

            return isAscending
                ? bValue.localeCompare(aValue)
                : aValue.localeCompare(bValue);
        });

        // Reorder rows
        rows.forEach(row => tbody.appendChild(row));
    }

    setupPagination() {
        if (this.options.pagination) {
            this.createPaginationControls();
        }
    }

    createPaginationControls() {
        const rows = this.table.querySelectorAll('tbody tr');
        const itemsPerPage = this.options.itemsPerPage || 10;
        const pageCount = Math.ceil(rows.length / itemsPerPage);

        if (pageCount <= 1) return;

        const pagination = document.createElement('div');
        pagination.className = 'pagination';
        pagination.style.cssText = `
            display: flex;
            justify-content: center;
            gap: 5px;
            margin-top: 20px;
        `;

        for (let i = 1; i <= pageCount; i++) {
            const button = document.createElement('button');
            button.textContent = i;
            button.className = 'page-btn';
            if (i === 1) button.classList.add('active');

            button.addEventListener('click', () => this.showPage(i, rows, itemsPerPage));
            pagination.appendChild(button);
        }

        this.table.parentNode.appendChild(pagination);
        this.showPage(1, rows, itemsPerPage);
    }

    showPage(pageNumber, rows, itemsPerPage) {
        const start = (pageNumber - 1) * itemsPerPage;
        const end = start + itemsPerPage;

        rows.forEach((row, index) => {
            row.style.display = (index >= start && index < end) ? '' : 'none';
        });

        // Update active page button
        document.querySelectorAll('.page-btn').forEach((btn, index) => {
            btn.classList.toggle('active', index === pageNumber - 1);
        });
    }
}

// Gestionnaire d'API
class ApiClient {
    static async get(endpoint) {
        try {
            const response = await fetch(`${AppConfig.API_BASE_URL}${endpoint}`);
            if (!response.ok) throw new Error(`HTTP ${response.status}`);
            return await response.json();
        } catch (error) {
            console.error('GET request failed:', error);
            throw error;
        }
    }

    static async post(endpoint, data) {
        try {
            const response = await fetch(`${AppConfig.API_BASE_URL}${endpoint}`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(data)
            });
            if (!response.ok) throw new Error(`HTTP ${response.status}`);
            return await response.json();
        } catch (error) {
            console.error('POST request failed:', error);
            throw error;
        }
    }

    static async put(endpoint, data) {
        try {
            const response = await fetch(`${AppConfig.API_BASE_URL}${endpoint}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(data)
            });
            if (!response.ok) throw new Error(`HTTP ${response.status}`);
            return await response.json();
        } catch (error) {
            console.error('PUT request failed:', error);
            throw error;
        }
    }

    static async delete(endpoint) {
        try {
            const response = await fetch(`${AppConfig.API_BASE_URL}${endpoint}`, {
                method: 'DELETE'
            });
            if (!response.ok) throw new Error(`HTTP ${response.status}`);
            return await response.json();
        } catch (error) {
            console.error('DELETE request failed:', error);
            throw error;
        }
    }
}

// Initialisation de l'application
document.addEventListener('DOMContentLoaded', function() {
    // Initialize notification manager
    window.notifications = new NotificationManager();

    // Initialize table managers
    document.querySelectorAll('table[data-sortable]').forEach(table => {
        new TableManager(table.id, {
            pagination: table.hasAttribute('data-pagination'),
            itemsPerPage: parseInt(table.getAttribute('data-items-per-page')) || 10
        });
    });

    // Initialize form managers
    document.querySelectorAll('form[data-validate]').forEach(form => {
        new FormManager(form.id);
    });

    // Add debounce to search inputs
    document.querySelectorAll('input[type="search"]').forEach(input => {
        let timeout;
        input.addEventListener('input', function() {
            clearTimeout(timeout);
            timeout = setTimeout(() => {
                // Trigger search functionality
                if (typeof window.filterTable === 'function') {
                    window.filterTable();
                }
            }, AppConfig.DEBOUNCE_DELAY);
        });
    });

    // Add confirmation to delete buttons
    document.querySelectorAll('.btn-delete').forEach(button => {
        button.addEventListener('click', function(e) {
            if (!confirm('Êtes-vous sûr de vouloir supprimer cet élément ?')) {
                e.preventDefault();
                e.stopPropagation();
            }
        });
    });

    // Theme toggle (example feature)
    const themeToggle = document.getElementById('themeToggle');
    if (themeToggle) {
        themeToggle.addEventListener('click', function() {
            document.body.classList.toggle('dark-mode');
            const isDark = document.body.classList.contains('dark-mode');
            localStorage.setItem('theme', isDark ? 'dark' : 'light');
            notifications.show(`Thème ${isDark ? 'sombre' : 'clair'} activé`, 'info');
        });

        // Load saved theme
        const savedTheme = localStorage.getItem('theme');
        if (savedTheme === 'dark') {
            document.body.classList.add('dark-mode');
        }
    }
});

// Fonctions utilitaires
const Utils = {
    debounce(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    },



    formatCurrency(amount) {
        return new Intl.NumberFormat('fr-FR', {
            style: 'currency',
            currency: 'EUR'
        }).format(amount);
    },

    formatNumber(number) {
        return new Intl.NumberFormat('fr-FR').format(number);
    },

    generateId() {
        return Date.now().toString(36) + Math.random().toString(36).substr(2);
    }
};

// Export global
window.AppConfig = AppConfig;
window.ApiClient = ApiClient;
window.Utils = Utils;
window.FormManager = FormManager;
window.TableManager = TableManager;