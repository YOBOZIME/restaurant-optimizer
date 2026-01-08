<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${isEdit}">Modifier Restaurant</c:when>
            <c:otherwise>Nouveau Restaurant</c:otherwise>
        </c:choose>
        | Restaurant Supply Chain Optimizer
    </title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* Base Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #0a0a0a 0%, #1a1a1a 100%);
            color: #ffffff;
            min-height: 100vh;
            line-height: 1.6;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        /* Header Navigation */
        .header {
            background: rgba(15, 15, 15, 0.95);
            border-radius: 12px;
            padding: 20px 30px;
            margin-bottom: 30px;
            box-shadow: 0 8px 32px rgba(220, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }

        .header h1 {
            color: #ff0000;
            font-size: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 600;
        }

        .header h1 i {
            color: #ff3333;
            font-size: 28px;
        }

        .header nav {
            display: flex;
            gap: 5px;
            flex-wrap: wrap;
        }

        .header nav a {
            color: #cccccc;
            text-decoration: none;
            padding: 12px 20px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            border: 1px solid transparent;
        }

        .header nav a:hover {
            color: #ffffff;
            background: rgba(255, 0, 0, 0.1);
            border-color: rgba(255, 0, 0, 0.2);
            transform: translateY(-2px);
        }

        .header nav a.active {
            color: #ff0000;
            background: rgba(255, 0, 0, 0.15);
            border-color: rgba(255, 0, 0, 0.3);
            font-weight: 600;
        }

        /* Page Header */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid rgba(255, 0, 0, 0.3);
        }

        /* Form Container */
        .form-container {
            max-width: 800px;
            margin: 0 auto;
            background: rgba(20, 20, 20, 0.9);
            border-radius: 12px;
            padding: 40px;
            box-shadow: 0 8px 32px rgba(220, 0, 0, 0.15);
            border: 1px solid rgba(255, 255, 255, 0.05);
            transition: transform 0.3s ease;
        }

        .form-container:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 40px rgba(220, 0, 0, 0.2);
        }

        .form-title {
            color: #ffffff;
            font-size: 28px;
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 10px;
        }

        .form-title i {
            color: #ff3333;
        }

        .form-subtitle {
            color: #888888;
            font-size: 15px;
            margin-bottom: 30px;
        }

        /* Form Sections */
        .form-section {
            margin-bottom: 35px;
            padding-bottom: 25px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }

        .form-section:last-child {
            border-bottom: none;
        }

        .form-section h3 {
            color: #ffffff;
            font-size: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 25px;
        }

        .form-section h3 i {
            color: #ff3333;
        }

        /* Form Grid */
        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
            margin-bottom: 20px;
        }

        /* Form Groups */
        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #ffffff;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 15px;
        }

        .form-group label i {
            color: #ff3333;
            width: 20px;
        }

        .form-group .helper-text {
            font-size: 12px;
            color: #888888;
            margin-top: 5px;
            font-style: italic;
        }

        .required::after {
            content: " *";
            color: #ff3333;
        }

        /* Form Controls */
        .form-control {
            width: 100%;
            padding: 14px 16px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            color: #ffffff;
            font-size: 15px;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            outline: none;
            border-color: #ff0000;
            box-shadow: 0 0 0 2px rgba(255, 0, 0, 0.2);
            background: rgba(255, 255, 255, 0.08);
        }

        .form-control::placeholder {
            color: #666666;
        }

        /* Time Inputs */
        .time-inputs {
            display: flex;
            gap: 20px;
            align-items: center;
            margin-top: 10px;
        }

        .time-inputs .form-group {
            flex: 1;
            margin-bottom: 0;
        }

        .time-separator {
            color: #666666;
            font-size: 18px;
            font-weight: 500;
            margin-top: 25px;
        }

        /* Checkbox */
        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 15px;
            background: rgba(255, 255, 255, 0.03);
            border-radius: 10px;
            border: 1px solid rgba(255, 255, 255, 0.05);
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .checkbox-group:hover {
            background: rgba(255, 0, 0, 0.05);
            border-color: rgba(255, 0, 0, 0.2);
        }

        .checkbox-group input[type="checkbox"] {
            width: 20px;
            height: 20px;
            accent-color: #ff0000;
            cursor: pointer;
        }

        .checkbox-label {
            color: #ffffff;
            font-weight: 500;
            font-size: 15px;
            cursor: pointer;
        }

        /* Buttons */
        .btn {
            padding: 14px 28px;
            border-radius: 8px;
            border: none;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
        }

        .btn-success {
            background: linear-gradient(135deg, #00c853 0%, #007e33 100%);
            color: white;
        }

        .btn-success:hover {
            background: linear-gradient(135deg, #00e676 0%, #008f40 100%);
            box-shadow: 0 6px 20px rgba(0, 200, 83, 0.3);
        }

        .btn-warning {
            background: linear-gradient(135deg, #ff9800 0%, #f57c00 100%);
            color: white;
        }

        .btn-warning:hover {
            background: linear-gradient(135deg, #ffb74d 0%, #ff9800 100%);
            box-shadow: 0 6px 20px rgba(255, 152, 0, 0.3);
        }

        .btn-secondary {
            background: rgba(255, 255, 255, 0.05);
            color: #cccccc;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .btn-secondary:hover {
            background: rgba(255, 255, 255, 0.1);
            color: #ffffff;
            border-color: rgba(255, 0, 0, 0.3);
        }

        /* Form Actions */
        .form-actions {
            display: flex;
            gap: 15px;
            justify-content: flex-end;
            margin-top: 40px;
            padding-top: 25px;
            border-top: 1px solid rgba(255, 255, 255, 0.05);
        }

        /* Error Styling */
        .error {
            border-color: #ff3333 !important;
        }

        .error-message {
            color: #ff3333;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }

        /* Animations */
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .form-container {
            animation: fadeIn 0.5s ease-out;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                text-align: center;
            }

            .header nav {
                justify-content: center;
            }

            .form-row {
                grid-template-columns: 1fr;
            }

            .time-inputs {
                flex-direction: column;
                gap: 15px;
            }

            .time-separator {
                margin: 0;
                transform: rotate(90deg);
            }

            .form-actions {
                flex-direction: column;
            }

            .form-actions .btn {
                width: 100%;
                justify-content: center;
            }

            .form-container {
                padding: 25px;
            }
        }

        /* Input Types */
        input[type="number"]::-webkit-inner-spin-button,
        input[type="number"]::-webkit-outer-spin-button {
            opacity: 1;
        }

        input[type="time"] {
            appearance: none;
            -webkit-appearance: none;
            padding: 14px 16px;
        }
    </style>
</head>
<body>
<div class="container">
    <!-- Header -->
    <header class="header">
        <h1><i class="fas fa-chart-network"></i> Restaurant Supply Chain Optimizer</h1>
        <nav>
            <a href="dashboard"><i class="fas fa-home"></i> Dashboard</a>
            <a href="ingredients"><i class="fas fa-carrot"></i> Ingrédients</a>
            <a href="restaurants" class="active"><i class="fas fa-store"></i> Restaurants</a>
            <a href="stock"><i class="fas fa-boxes"></i> Stocks</a>
            <a href="waste"><i class="fas fa-trash"></i> Pertes</a>
        </nav>
    </header>

    <!-- Formulaire -->
    <div class="form-container">
        <div class="form-header">
            <h2 class="form-title">
                <i class="fas ${isEdit ? 'fa-edit' : 'fa-plus-circle'}"></i>
                <c:choose>
                    <c:when test="${isEdit}">Modifier le Restaurant</c:when>
                    <c:otherwise>Nouveau Restaurant</c:otherwise>
                </c:choose>
            </h2>
            <c:if test="${isEdit && not empty restaurant}">
                <p class="form-subtitle">ID: #${restaurant.id}</p>
            </c:if>
        </div>

        <form id="restaurantForm" action="restaurants" method="POST">
            <c:if test="${isEdit && not empty restaurant}">
                <input type="hidden" name="id" value="${restaurant.id}">
            </c:if>

            <!-- Section Informations de base -->
            <div class="form-section">
                <h3><i class="fas fa-info-circle"></i> Informations de base</h3>
                <div class="form-row">
                    <div class="form-group">
                        <label for="name" class="required">
                            <i class="fas fa-store"></i> Nom du restaurant
                        </label>
                        <input type="text"
                               id="name"
                               name="name"
                               class="form-control"
                               required
                               value="${not empty restaurant ? restaurant.name : ''}"
                               placeholder="Ex: La Belle Époque, Chez Pierre...">
                        <div class="helper-text">
                            Nom officiel du restaurant
                        </div>
                        <div id="name-error" class="error-message"></div>
                    </div>

                    <div class="form-group">
                        <label for="city" class="required">
                            <i class="fas fa-city"></i> Ville
                        </label>
                        <input type="text"
                               id="city"
                               name="city"
                               class="form-control"
                               required
                               value="${not empty restaurant ? restaurant.city : ''}"
                               placeholder="Ex: Paris, Lyon, Marseille...">
                        <div class="helper-text">
                            Ville où est situé le restaurant
                        </div>
                        <div id="city-error" class="error-message"></div>
                    </div>
                </div>
            </div>

            <!-- Section Contact -->
            <div class="form-section">
                <h3><i class="fas fa-address-book"></i> Informations de contact</h3>
                <div class="form-row">
                    <div class="form-group">
                        <label for="address">
                            <i class="fas fa-map-marker-alt"></i> Adresse
                        </label>
                        <input type="text"
                               id="address"
                               name="address"
                               class="form-control"
                               value="${not empty restaurant ? restaurant.address : ''}"
                               placeholder="Numéro, rue, code postal...">
                        <div class="helper-text">
                            Adresse complète du restaurant
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="phone">
                            <i class="fas fa-phone"></i> Téléphone
                        </label>
                        <input type="tel"
                               id="phone"
                               name="phone"
                               class="form-control"
                               value="${not empty restaurant ? restaurant.phone : ''}"
                               placeholder="01 23 45 67 89">
                        <div class="helper-text">
                            Numéro de téléphone principal
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="email">
                            <i class="fas fa-envelope"></i> Email
                        </label>
                        <input type="email"
                               id="email"
                               name="email"
                               class="form-control"
                               value="${not empty restaurant ? restaurant.email : ''}"
                               placeholder="contact@restaurant.com">
                        <div class="helper-text">
                            Adresse email de contact
                        </div>
                        <div id="email-error" class="error-message"></div>
                    </div>
                </div>
            </div>

            <!-- Section Horaires et capacité -->
            <div class="form-section">
                <h3><i class="fas fa-clock"></i> Horaires et capacité</h3>
                <div class="form-row">
                    <div class="form-group">
                        <label for="capacity">
                            <i class="fas fa-users"></i> Capacité (nombre de places)
                        </label>
                        <input type="number"
                               id="capacity"
                               name="capacity"
                               class="form-control"
                               min="1"
                               value="${not empty restaurant ? restaurant.capacity : '50'}"
                               placeholder="50">
                        <div class="helper-text">
                            Nombre maximum de clients simultanés
                        </div>
                    </div>

                    <div class="time-inputs">
                        <div class="form-group">
                            <label for="openingTime">
                                <i class="fas fa-door-open"></i> Heure d'ouverture
                            </label>
                            <input type="time"
                                   id="openingTime"
                                   name="openingTime"
                                   class="form-control"
                                   value="${not empty restaurant && restaurant.openingTime != null ? restaurant.openingTime : '11:00'}">
                        </div>

                        <div class="time-separator">à</div>

                        <div class="form-group">
                            <label for="closingTime">
                                <i class="fas fa-door-closed"></i> Heure de fermeture
                            </label>
                            <input type="time"
                                   id="closingTime"
                                   name="closingTime"
                                   class="form-control"
                                   value="${not empty restaurant && restaurant.closingTime != null ? restaurant.closingTime : '22:00'}">
                        </div>
                    </div>
                    <div id="time-error" class="error-message"></div>
                </div>
            </div>

            <!-- Section Statut -->
            <div class="form-section">
                <h3><i class="fas fa-toggle-on"></i> Statut</h3>
                <div class="checkbox-group">
                    <input type="checkbox"
                           id="isActive"
                           name="isActive"
                           value="true"
                    ${not empty restaurant && restaurant.isActive ? 'checked' : 'checked'}>
                    <label for="isActive" class="checkbox-label">Restaurant actif</label>
                </div>
                <div class="helper-text">
                    Un restaurant inactif n'apparaîtra pas dans les listes de commandes et de stocks
                </div>
            </div>

            <div class="form-actions">
                <a href="restaurants" class="btn btn-secondary">
                    <i class="fas fa-times"></i> Annuler
                </a>
                <button type="submit" class="btn ${isEdit ? 'btn-warning' : 'btn-success'}">
                    <i class="fas fa-save"></i>
                    <c:choose>
                        <c:when test="${isEdit}">Mettre à jour</c:when>
                        <c:otherwise>Créer le restaurant</c:otherwise>
                    </c:choose>
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    // Validation du formulaire
    function validateForm(event) {
        // Masquer les erreurs précédentes
        document.querySelectorAll('.error-message').forEach(el => {
            el.style.display = 'none';
            el.textContent = '';
        });

        document.querySelectorAll('.error').forEach(el => {
            el.classList.remove('error');
        });

        let isValid = true;

        // Validation des champs requis
        const requiredFields = [
            {id: 'name', label: 'Nom du restaurant'},
            {id: 'city', label: 'Ville'}
        ];

        for (const field of requiredFields) {
            const element = document.getElementById(field.id);
            const errorElement = document.getElementById(`${field.id}-error`);

            if (!element?.value?.trim()) {
                if (element) {
                    element.classList.add('error');
                }
                if (errorElement) {
                    errorElement.textContent = `Le champ "${field.label}" est obligatoire`;
                    errorElement.style.display = 'block';
                }
                isValid = false;
            }
        }

        // Validation de l'email si rempli
        const emailField = document.getElementById('email');
        const emailError = document.getElementById('email-error');
        if (emailField?.value?.trim()) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(emailField.value)) {
                emailField.classList.add('error');
                if (emailError) {
                    emailError.textContent = 'Format d\'email invalide';
                    emailError.style.display = 'block';
                }
                isValid = false;
            }
        }

        // Validation des heures
        const openingTime = document.getElementById('openingTime').value;
        const closingTime = document.getElementById('closingTime').value;
        const timeError = document.getElementById('time-error');

        if (openingTime && closingTime && openingTime >= closingTime) {
            if (timeError) {
                timeError.textContent = 'L\'heure d\'ouverture doit être avant l\'heure de fermeture';
                timeError.style.display = 'block';
            }
            document.getElementById('openingTime').classList.add('error');
            document.getElementById('closingTime').classList.add('error');
            isValid = false;
        }

        if (!isValid) {
            event.preventDefault();
            return false;
        }

        return true;
    }

    // Initialisation
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('restaurantForm');
        if (form) {
            form.addEventListener('submit', validateForm);
        }

        // Réinitialise les bordures en cas d'erreur
        const formControls = document.querySelectorAll('.form-control');
        formControls.forEach(control => {
            control.addEventListener('input', function() {
                this.classList.remove('error');
                const errorId = this.id + '-error';
                const errorElement = document.getElementById(errorId);
                if (errorElement) {
                    errorElement.style.display = 'none';
                }
            });
        });

        // Initialisation des champs time
        const timeInputs = document.querySelectorAll('input[type="time"]');
        timeInputs.forEach(input => {
            if (!input.value) {
                if (input.id === 'openingTime') {
                    input.value = '11:00';
                } else if (input.id === 'closingTime') {
                    input.value = '22:00';
                }
            }
        });

        // Initialisation de la capacité
        const capacityField = document.getElementById('capacity');
        if (capacityField && !capacityField.value) {
            capacityField.value = '50';
        }
    });
</script>
</body>
</html>