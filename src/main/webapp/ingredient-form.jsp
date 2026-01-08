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
            <c:when test="${isEdit}">Modifier Ingrédient</c:when>
            <c:otherwise>Nouvel Ingrédient</c:otherwise>
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

        .page-header h2 {
            color: #ffffff;
            font-size: 28px;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .page-header h2 i {
            color: #ff3333;
        }

        .page-header p {
            color: #aaaaaa;
            margin-top: 8px;
            font-size: 15px;
        }

        /* Buttons */
        .btn {
            padding: 12px 24px;
            border-radius: 8px;
            border: none;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
        }

        .btn-success {
            background: linear-gradient(135deg, #00c853 0%, #007e33 100%);
            color: white;
        }

        .btn-success:hover {
            background: linear-gradient(135deg, #00e676 0%, #008f40 100%);
        }

        .btn-warning {
            background: linear-gradient(135deg, #ff9800 0%, #f57c00 100%);
            color: white;
        }

        .btn-warning:hover {
            background: linear-gradient(135deg, #ffb74d 0%, #ff9800 100%);
        }

        .btn-outline {
            background: transparent;
            color: #cccccc;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .btn-outline:hover {
            background: rgba(255, 255, 255, 0.05);
            color: #ffffff;
            border-color: rgba(255, 0, 0, 0.3);
        }

        /* Card Styling */
        .card {
            background: rgba(20, 20, 20, 0.9);
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 25px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(255, 255, 255, 0.05);
            transition: transform 0.3s ease;
        }

        .card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(220, 0, 0, 0.15);
        }

        /* Form Container */
        .form-container {
            max-width: 800px;
            margin: 0 auto;
        }

        /* Form Sections */
        .form-section {
            margin-bottom: 30px;
        }

        .form-section h3 {
            color: #ffffff;
            font-size: 20px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
            padding-bottom: 15px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }

        .form-section h3 i {
            color: #ff0000;
        }

        /* Form Grid */
        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
            margin-bottom: 25px;
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
        }

        .form-group label i {
            color: #ff3333;
        }

        .form-group .helper-text {
            font-size: 12px;
            color: #888888;
            margin-top: 5px;
            font-style: italic;
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

        .required::after {
            content: " *";
            color: #ff3333;
        }

        /* Price Input */
        .price-input {
            position: relative;
        }

        .price-input::after {
            content: "€";
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #888888;
            font-weight: 500;
        }

        /* Category Selector */
        .category-selector {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
            gap: 12px;
            margin-top: 10px;
        }

        .category-option {
            padding: 15px;
            border: 2px solid rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 10px;
            background: rgba(255, 255, 255, 0.03);
        }

        .category-option:hover {
            border-color: rgba(255, 0, 0, 0.3);
            background: rgba(255, 0, 0, 0.05);
            transform: translateY(-2px);
        }

        .category-option.active {
            border-color: #ff0000;
            background: rgba(255, 0, 0, 0.1);
            box-shadow: 0 4px 15px rgba(255, 0, 0, 0.1);
        }

        .category-option i {
            font-size: 28px;
            margin-bottom: 5px;
        }

        .category-option span {
            font-size: 14px;
            font-weight: 500;
            color: #ffffff;
        }

        /* Unit Selector */
        .unit-selector {
            display: flex;
            gap: 10px;
            margin-top: 10px;
            flex-wrap: wrap;
        }

        .unit-option {
            padding: 10px 20px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 14px;
            color: #cccccc;
            background: rgba(255, 255, 255, 0.03);
        }

        .unit-option:hover {
            background: rgba(255, 0, 0, 0.1);
            border-color: rgba(255, 0, 0, 0.3);
            color: #ffffff;
        }

        .unit-option.active {
            background: linear-gradient(135deg, #ff0000 0%, #cc0000 100%);
            color: white;
            border-color: #ff0000;
            box-shadow: 0 4px 10px rgba(255, 0, 0, 0.2);
        }

        /* Range Input */
        input[type="range"] {
            width: 100%;
            height: 8px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 4px;
            outline: none;
            -webkit-appearance: none;
            margin: 15px 0;
        }

        input[type="range"]::-webkit-slider-thumb {
            -webkit-appearance: none;
            width: 20px;
            height: 20px;
            background: #ff0000;
            border-radius: 50%;
            cursor: pointer;
            box-shadow: 0 0 10px rgba(255, 0, 0, 0.5);
        }

        /* Shelf Life Indicator */
        .shelf-life-indicator {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-top: 15px;
        }

        .indicator-bar {
            flex: 1;
            height: 8px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 4px;
            overflow: hidden;
        }

        .indicator-fill {
            height: 100%;
            background: linear-gradient(90deg, #ff0000, #ff6666);
            transition: width 0.3s ease;
            border-radius: 4px;
        }

        .indicator-label {
            font-size: 14px;
            color: #ffffff;
            font-weight: 500;
            min-width: 80px;
            text-align: center;
            background: rgba(255, 0, 0, 0.1);
            padding: 6px 12px;
            border-radius: 6px;
        }

        /* Preview Card */
        .preview-card {
            border: 1px solid rgba(255, 0, 0, 0.2);
            border-radius: 12px;
            padding: 25px;
            margin-top: 30px;
            background: rgba(255, 0, 0, 0.05);
            display: none;
        }

        .preview-header {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 20px;
        }

        .preview-icon {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            color: white;
            background: linear-gradient(135deg, #ff0000, #ff6666);
        }

        .preview-header-content h4 {
            color: #ffffff;
            font-size: 20px;
            margin-bottom: 5px;
        }

        .preview-header-tags {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .preview-category {
            padding: 4px 12px;
            background: rgba(255, 0, 0, 0.2);
            border-radius: 20px;
            font-size: 12px;
            color: #ff9999;
            font-weight: 500;
        }

        .preview-price {
            font-weight: 600;
            color: #ffffff;
            font-size: 14px;
        }

        .preview-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 20px;
        }

        .preview-item {
            background: rgba(255, 255, 255, 0.03);
            padding: 15px;
            border-radius: 8px;
            border: 1px solid rgba(255, 255, 255, 0.05);
        }

        .preview-label {
            font-size: 12px;
            color: #888888;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .preview-value {
            font-weight: 600;
            color: #ffffff;
            font-size: 16px;
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

        /* Range Labels */
        .range-labels {
            display: flex;
            justify-content: space-between;
            margin-top: 5px;
        }

        .range-label {
            font-size: 12px;
            color: #888888;
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

            .page-header {
                flex-direction: column;
                gap: 20px;
                text-align: center;
            }

            .form-row {
                grid-template-columns: 1fr;
            }

            .category-selector {
                grid-template-columns: repeat(2, 1fr);
            }

            .unit-selector {
                justify-content: center;
            }

            .form-actions {
                flex-direction: column;
            }

            .form-actions .btn {
                width: 100%;
                justify-content: center;
            }
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

        .card {
            animation: fadeIn 0.5s ease-out;
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
    </style>
</head>
<body>
<div class="container">
    <!-- Header -->
    <header class="header">
        <h1><i class="fas fa-chart-network"></i> Restaurant Supply Chain Optimizer</h1>
        <nav>
            <a href="dashboard"><i class="fas fa-home"></i> Dashboard</a>
            <a href="ingredients" class="active"><i class="fas fa-carrot"></i> Ingrédients</a>
            <a href="restaurants"><i class="fas fa-store"></i> Restaurants</a>
            <a href="stock"><i class="fas fa-boxes"></i> Stocks</a>
            <a href="waste"><i class="fas fa-trash"></i> Pertes</a>
        </nav>
    </header>

    <!-- Page Header -->
    <div class="page-header">
        <div>
            <h2>
                <i class="fas ${isEdit ? 'fa-edit' : 'fa-plus-circle'}"></i>
                <c:choose>
                    <c:when test="${isEdit}">Modifier l'ingrédient</c:when>
                    <c:otherwise>Nouvel Ingrédient</c:otherwise>
                </c:choose>
            </h2>
            <p>
                <c:choose>
                    <c:when test="${isEdit}">Modifiez les informations de l'ingrédient</c:when>
                    <c:otherwise>Ajoutez un nouvel ingrédient à votre base</c:otherwise>
                </c:choose>
            </p>
        </div>
        <a href="ingredients" class="btn btn-outline">
            <i class="fas fa-arrow-left"></i> Retour à la liste
        </a>
    </div>

    <!-- Main Form -->
    <div class="card form-container">
        <form id="ingredientForm" action="ingredients" method="POST">
            <!-- Hidden fields -->
            <input type="hidden" name="action" value="${isEdit ? 'update' : 'add'}">
            <c:if test="${isEdit && not empty ingredient}">
                <input type="hidden" name="id" value="${ingredient.id}">
            </c:if>

            <!-- Basic Information -->
            <div class="form-section">
                <h3><i class="fas fa-info-circle"></i> Informations de base</h3>

                <div class="form-row">
                    <div class="form-group">
                        <label for="name" class="required">
                            <i class="fas fa-tag"></i> Nom de l'ingrédient
                        </label>
                        <input type="text"
                               id="name"
                               name="name"
                               class="form-control"
                               value="${not empty ingredient ? ingredient.name : ''}"
                               required
                               placeholder="Ex: Tomate, Poulet, Farine...">
                        <div class="helper-text">
                            Nom unique qui identifie l'ingrédient
                        </div>
                        <div id="name-error" class="error-message"></div>
                    </div>

                    <div class="form-group">
                        <label for="category" class="required">
                            <i class="fas fa-layer-group"></i> Catégorie
                        </label>
                        <div class="category-selector">
                            <div class="category-option" data-value="Viandes" onclick="window.selectCategory('Viandes')">
                                <i class="fas fa-drumstick-bite" style="color: #ff3333;"></i>
                                <span>Viandes</span>
                            </div>
                            <div class="category-option" data-value="Légumes" onclick="window.selectCategory('Légumes')">
                                <i class="fas fa-leaf" style="color: #00cc44;"></i>
                                <span>Légumes</span>
                            </div>
                            <div class="category-option" data-value="Produits laitiers" onclick="window.selectCategory('Produits laitiers')">
                                <i class="fas fa-cheese" style="color: #ffcc00;"></i>
                                <span>Produits laitiers</span>
                            </div>
                            <div class="category-option" data-value="Épicerie" onclick="window.selectCategory('Épicerie')">
                                <i class="fas fa-wheat-awn" style="color: #ff6600;"></i>
                                <span>Épicerie</span>
                            </div>
                            <div class="category-option" data-value="Boissons" onclick="window.selectCategory('Boissons')">
                                <i class="fas fa-wine-bottle" style="color: #3399ff;"></i>
                                <span>Boissons</span>
                            </div>
                        </div>
                        <input type="hidden"
                               id="category"
                               name="category"
                               value="${not empty ingredient ? ingredient.category : ''}"
                               required>
                        <div class="helper-text">
                            Sélectionnez la catégorie principale
                        </div>
                        <div id="category-error" class="error-message"></div>
                    </div>
                </div>

                <!-- Pricing and Units -->
                <div class="form-row">
                    <div class="form-group">
                        <label for="currentPrice" class="required">
                            <i class="fas fa-euro-sign"></i> Prix unitaire
                        </label>
                        <div class="price-input">
                            <input type="number"
                                   id="currentPrice"
                                   name="currentPrice"
                                   class="form-control"
                                   value="${not empty ingredient ? ingredient.currentPrice : ''}"
                                   step="0.01"
                                   min="0"
                                   max="1000"
                                   required
                                   placeholder="0.00">
                        </div>
                        <div class="helper-text">
                            Prix d'achat par unité
                        </div>
                        <div id="price-error" class="error-message"></div>
                    </div>

                    <div class="form-group">
                        <label class="required">
                            <i class="fas fa-balance-scale"></i> Unité de mesure
                        </label>
                        <div class="unit-selector">
                            <span class="unit-option" data-unit="kg" onclick="window.selectUnit('kg')">kg</span>
                            <span class="unit-option" data-unit="g" onclick="window.selectUnit('g')">g</span>
                            <span class="unit-option" data-unit="L" onclick="window.selectUnit('L')">L</span>
                            <span class="unit-option" data-unit="mL" onclick="window.selectUnit('mL')">mL</span>
                            <span class="unit-option" data-unit="unité" onclick="window.selectUnit('unité')">Unité</span>
                            <span class="unit-option" data-unit="pièce" onclick="window.selectUnit('pièce')">Pièce</span>
                        </div>
                        <input type="hidden"
                               id="unit"
                               name="unit"
                               value="${not empty ingredient ? ingredient.unit : ''}"
                               required>
                        <div class="helper-text">
                            Sélectionnez l'unité standard
                        </div>
                        <div id="unit-error" class="error-message"></div>
                    </div>
                </div>

                <!-- Shelf Life -->
                <div class="form-row">
                    <div class="form-group">
                        <label for="shelfLifeRange" class="required">
                            <i class="fas fa-clock"></i> Durée de conservation (jours)
                        </label>
                        <input type="range"
                               id="shelfLifeRange"
                               min="1"
                               max="365"
                               step="1"
                               value="${not empty ingredient && ingredient.shelfLifeDays != null ? ingredient.shelfLifeDays : 7}"
                               oninput="window.updateShelfLife(this.value)">
                        <div class="range-labels">
                            <span class="range-label">1 jour</span>
                            <span class="range-label">1 an</span>
                        </div>
                        <div class="shelf-life-indicator">
                            <div class="indicator-bar">
                                <div id="shelfLifeFill" class="indicator-fill"></div>
                            </div>
                            <div class="indicator-label">
                                <span id="shelfLifeValue">
                                    ${not empty ingredient && ingredient.shelfLifeDays != null ? ingredient.shelfLifeDays : 7}
                                </span> jours
                            </div>
                        </div>
                        <input type="hidden"
                               id="shelfLifeDays"
                               name="shelfLifeDays"
                               value="${not empty ingredient && ingredient.shelfLifeDays != null ? ingredient.shelfLifeDays : 7}"
                               required>
                        <div id="shelfLife-error" class="error-message"></div>
                    </div>
                </div>

                <!-- Preview Card -->
                <div class="preview-card" id="previewCard">
                    <div class="preview-header">
                        <div id="previewIcon" class="preview-icon">
                            <i class="fas fa-carrot"></i>
                        </div>
                        <div class="preview-header-content">
                            <h4 id="previewName">Nouvel Ingrédient</h4>
                            <div class="preview-header-tags">
                                <span id="previewCategory" class="preview-category"></span>
                                <span id="previewPrice" class="preview-price"></span>
                            </div>
                        </div>
                    </div>
                    <div class="preview-content">
                        <div class="preview-item">
                            <div class="preview-label">Unité</div>
                            <div class="preview-value" id="previewUnit"></div>
                        </div>
                        <div class="preview-item">
                            <div class="preview-label">Conservation</div>
                            <div class="preview-value" id="previewShelfLife"></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Form Actions -->
            <div class="form-actions">
                <button type="button" class="btn btn-outline" onclick="window.location.href='ingredients'">
                    <i class="fas fa-times"></i> Annuler
                </button>
                <button type="submit" class="btn ${isEdit ? 'btn-warning' : 'btn-success'}">
                    <i class="fas fa-save"></i>
                    <c:choose>
                        <c:when test="${isEdit}">Modifier</c:when>
                        <c:otherwise>Créer</c:otherwise>
                    </c:choose> l'ingrédient
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    // Déclare toutes les fonctions GLOBALEMENT (attache à window)
    console.log("JavaScript chargé");

    // Fonction de sélection de catégorie
    window.selectCategory = function(category) {
        console.log("Sélection catégorie:", category);
        if (!category) return;

        // Enlève la classe active de toutes les options
        const options = document.querySelectorAll('.category-option');
        for (let i = 0; i < options.length; i++) {
            options[i].classList.remove('active');
        }

        // Ajoute la classe active à l'option sélectionnée
        for (let i = 0; i < options.length; i++) {
            if (options[i].getAttribute('data-value') === category) {
                options[i].classList.add('active');
                break;
            }
        }

        // Met à jour le champ caché
        const categoryField = document.getElementById('category');
        if (categoryField) {
            categoryField.value = category;
        }

        // Met à jour la prévisualisation
        if (typeof window.updatePreview === 'function') {
            window.updatePreview();
        }
    }

    // Fonction de sélection d'unité
    window.selectUnit = function(unit) {
        console.log("Sélection unité:", unit);
        if (!unit) return;

        // Enlève la classe active de toutes les options
        const options = document.querySelectorAll('.unit-option');
        for (let i = 0; i < options.length; i++) {
            options[i].classList.remove('active');
        }

        // Ajoute la classe active à l'option sélectionnée
        for (let i = 0; i < options.length; i++) {
            if (options[i].getAttribute('data-unit') === unit) {
                options[i].classList.add('active');
                break;
            }
        }

        // Met à jour le champ caché
        const unitField = document.getElementById('unit');
        if (unitField) {
            unitField.value = unit;
        }

        // Met à jour la prévisualisation
        if (typeof window.updatePreview === 'function') {
            window.updatePreview();
        }
    }

    // Fonction de mise à jour de la durée de conservation
    window.updateShelfLife = function(days) {
        console.log("Mise à jour conservation:", days);
        const daysInt = parseInt(days) || 7;

        // Met à jour l'affichage
        const shelfLifeValue = document.getElementById('shelfLifeValue');
        if (shelfLifeValue) {
            shelfLifeValue.textContent = daysInt;
        }

        // Met à jour le champ caché
        const shelfLifeDays = document.getElementById('shelfLifeDays');
        if (shelfLifeDays) {
            shelfLifeDays.value = daysInt;
        }

        // Met à jour la barre de progression
        const percentage = (daysInt / 365) * 100;
        const shelfLifeFill = document.getElementById('shelfLifeFill');
        if (shelfLifeFill) {
            shelfLifeFill.style.width = percentage + '%';
        }

        // Met à jour la prévisualisation
        if (typeof window.updatePreview === 'function') {
            window.updatePreview();
        }
    }

    // Fonction de mise à jour de la prévisualisation
    window.updatePreview = function() {
        console.log("Mise à jour prévisualisation");

        // Récupère les valeurs
        const name = document.getElementById('name') ? document.getElementById('name').value : '';
        const category = document.getElementById('category') ? document.getElementById('category').value : '';
        const price = document.getElementById('currentPrice') ? document.getElementById('currentPrice').value : '0.00';
        const unit = document.getElementById('unit') ? document.getElementById('unit').value : 'unité';
        const shelfLife = document.getElementById('shelfLifeDays') ? document.getElementById('shelfLifeDays').value : '7';

        // Met à jour les éléments de prévisualisation
        const previewName = document.getElementById('previewName');
        const previewCategory = document.getElementById('previewCategory');
        const previewPrice = document.getElementById('previewPrice');
        const previewUnit = document.getElementById('previewUnit');
        const previewShelfLife = document.getElementById('previewShelfLife');
        const previewIcon = document.getElementById('previewIcon');

        if (previewName) previewName.textContent = name || 'Nouvel Ingrédient';
        if (previewCategory) previewCategory.textContent = category || 'Non défini';
        if (previewPrice) previewPrice.textContent = parseFloat(price || 0).toFixed(2) + '€/' + unit;
        if (previewUnit) previewUnit.textContent = unit || 'unité';
        if (previewShelfLife) previewShelfLife.textContent = shelfLife + ' jours';

        // Met à jour l'icône et la couleur de catégorie
        const iconMap = {
            'Viandes': { icon: 'fa-drumstick-bite', color: '#ff3333' },
            'Légumes': { icon: 'fa-leaf', color: '#00cc44' },
            'Produits laitiers': { icon: 'fa-cheese', color: '#ffcc00' },
            'Épicerie': { icon: 'fa-wheat-awn', color: '#ff6600' },
            'Boissons': { icon: 'fa-wine-bottle', color: '#3399ff' }
        };

        const categoryData = iconMap[category] || { icon: 'fa-carrot', color: '#ff0000' };
        if (previewIcon) {
            previewIcon.innerHTML = '<i class="fas ' + categoryData.icon + '"></i>';
            previewIcon.style.background = 'linear-gradient(135deg, ' + categoryData.color + ', ' + categoryData.color + 'dd)';
        }

        // Affiche la carte de prévisualisation si on a des données
        const previewCard = document.getElementById('previewCard');
        if (previewCard) {
            previewCard.style.display = name.trim() !== '' ? 'block' : 'none';
        }
    }

    // Fonction de validation du formulaire
    window.validateForm = function(event) {
        console.log("Validation du formulaire...");

        let isValid = true;
        const requiredFields = [
            {id: 'name', label: 'Nom'},
            {id: 'unit', label: 'Unité'},
            {id: 'category', label: 'Catégorie'},
            {id: 'currentPrice', label: 'Prix'},
            {id: 'shelfLifeDays', label: 'Durée de conservation'}
        ];

        for (let i = 0; i < requiredFields.length; i++) {
            const field = requiredFields[i];
            const element = document.getElementById(field.id);
            if (!element || !element.value || element.value.trim() === '') {
                alert('Le champ "' + field.label + '" est obligatoire');
                if (element && element.style) {
                    element.style.borderColor = '#ff3333';
                }
                if (element) element.focus();
                isValid = false;
                break;
            }
        }

        if (!isValid) {
            event.preventDefault();
            return false;
        }

        // Formatte le prix à 2 décimales
        const priceField = document.getElementById('currentPrice');
        if (priceField && priceField.value) {
            priceField.value = parseFloat(priceField.value).toFixed(2);
        }

        console.log("Formulaire valide, soumission...");
        return true;
    }

    // Fonction d'initialisation (appelée quand le DOM est chargé)
    window.initForm = function() {
        console.log("Initialisation du formulaire");

        // Définit les valeurs par défaut
        const unitField = document.getElementById('unit');
        const categoryField = document.getElementById('category');

        // Si pas d'unité, définir "unité" par défaut
        if (!unitField.value || unitField.value.trim() === '') {
            unitField.value = 'unité';
            window.selectUnit('unité');
        } else {
            window.selectUnit(unitField.value);
        }

        // Si pas de catégorie, définir "Viandes" par défaut
        if (!categoryField.value || categoryField.value.trim() === '') {
            categoryField.value = 'Viandes';
            window.selectCategory('Viandes');
        } else {
            window.selectCategory(categoryField.value);
        }

        // Initialise la durée de conservation
        const shelfLifeValue = document.getElementById('shelfLifeDays').value || '7';
        window.updateShelfLife(shelfLifeValue);

        // Initialise la prévisualisation
        window.updatePreview();

        // Attache les événements
        const nameField = document.getElementById('name');
        const priceField = document.getElementById('currentPrice');

        if (nameField) {
            nameField.addEventListener('input', window.updatePreview);
        }
        if (priceField) {
            priceField.addEventListener('input', window.updatePreview);
        }

        // Attache la validation au formulaire
        const form = document.getElementById('ingredientForm');
        if (form) {
            form.addEventListener('submit', window.validateForm);
        }
    }

    // Quand le DOM est chargé, initialise le formulaire
    document.addEventListener('DOMContentLoaded', window.initForm);
</script>
</body>
</html>