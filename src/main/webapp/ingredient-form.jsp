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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <!-- METS TOUT LE JAVASCRIPT ICI DANS HEAD -->
    <script>
        // Déclare toutes les fonctions GLOBALEMENT au début
        console.log("JavaScript chargé dans head");

        // Fonction de sélection de catégorie
        function selectCategory(category) {
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
            if (typeof updatePreview === 'function') {
                updatePreview();
            }
        }

        // Fonction de sélection d'unité
        function selectUnit(unit) {
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
            if (typeof updatePreview === 'function') {
                updatePreview();
            }
        }

        // Fonction de mise à jour de la durée de conservation
        function updateShelfLife(days) {
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

            // Met à jour le type et la couleur
            const typeDiv = document.getElementById('shelfLifeType');
            const typeText = document.getElementById('typeText');
            const typeDesc = document.getElementById('typeDescription');

            let type = '';
            let description = '';
            let color = '';

            if (daysInt < 7) {
                type = 'Très périssable';
                description = 'À consommer rapidement';
                color = '#F44336';
            } else if (daysInt < 14) {
                type = 'Périssable';
                description = 'À consommer sous 2 semaines';
                color = '#FF9800';
            } else if (daysInt < 30) {
                type = 'Moyenne conservation';
                description = 'À consommer sous 1 mois';
                color = '#FFC107';
            } else {
                type = 'Longue conservation';
                description = 'Stockable plusieurs mois';
                color = '#4CAF50';
            }

            if (typeText) typeText.textContent = type;
            if (typeDesc) typeDesc.textContent = description;
            if (typeDiv) typeDiv.style.borderLeft = '4px solid ' + color;

            // Met à jour la prévisualisation
            if (typeof updatePreview === 'function') {
                updatePreview();
            }
        }

        // Fonction de mise à jour de la prévisualisation
        function updatePreview() {
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
            const previewType = document.getElementById('previewType');
            const previewIcon = document.getElementById('previewIcon');

            if (previewName) previewName.textContent = name || 'Nouvel Ingrédient';
            if (previewCategory) previewCategory.textContent = category || 'Non défini';
            if (previewPrice) previewPrice.textContent = parseFloat(price || 0).toFixed(2) + '€/' + unit;
            if (previewUnit) previewUnit.textContent = unit || 'unité';
            if (previewShelfLife) previewShelfLife.textContent = shelfLife + ' jours';

            // Met à jour l'icône et la couleur de catégorie
            const iconMap = {
                'Viandes': { icon: 'fa-drumstick-bite', color: '#FF6B6B' },
                'Légumes': { icon: 'fa-leaf', color: '#51CF66' },
                'Produits laitiers': { icon: 'fa-cheese', color: '#FFD93D' },
                'Épicerie': { icon: 'fa-wheat-awn', color: '#FF922B' },
                'Boissons': { icon: 'fa-wine-bottle', color: '#339AF0' }
            };

            const categoryData = iconMap[category] || { icon: 'fa-carrot', color: '#4CAF50' };
            if (previewIcon) {
                previewIcon.innerHTML = '<i class="fas ' + categoryData.icon + '"></i>';
                previewIcon.style.backgroundColor = categoryData.color;
            }

            // Met à jour le type de conservation
            const daysInt = parseInt(shelfLife) || 7;
            let typeText = '';
            if (daysInt < 7) typeText = 'Très périssable';
            else if (daysInt < 14) typeText = 'Périssable';
            else if (daysInt < 30) typeText = 'Moyenne conservation';
            else typeText = 'Longue conservation';

            if (previewType) previewType.textContent = typeText;

            // Affiche la carte de prévisualisation si on a des données
            const previewCard = document.getElementById('previewCard');
            if (previewCard) {
                previewCard.style.display = name.trim() !== '' ? 'block' : 'none';
            }
        }

        // Fonction de validation du formulaire
        function validateForm(event) {
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
                        element.style.borderColor = '#F44336';
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
        function initForm() {
            console.log("Initialisation du formulaire");

            // Définit les valeurs par défaut
            const unitField = document.getElementById('unit');
            const categoryField = document.getElementById('category');

            // Si pas d'unité, définir "unité" par défaut
            if (!unitField.value || unitField.value.trim() === '') {
                unitField.value = 'unité';
                selectUnit('unité');
            } else {
                selectUnit(unitField.value);
            }

            // Si pas de catégorie, définir "Viandes" par défaut
            if (!categoryField.value || categoryField.value.trim() === '') {
                categoryField.value = 'Viandes';
                selectCategory('Viandes');
            } else {
                selectCategory(categoryField.value);
            }

            // Initialise la durée de conservation
            const shelfLifeValue = document.getElementById('shelfLifeDays').value || '7';
            updateShelfLife(shelfLifeValue);

            // Initialise la prévisualisation
            updatePreview();

            // Attache les événements
            const nameField = document.getElementById('name');
            const priceField = document.getElementById('currentPrice');

            if (nameField) {
                nameField.addEventListener('input', updatePreview);
            }
            if (priceField) {
                priceField.addEventListener('input', updatePreview);
            }

            // Attache la validation au formulaire
            const form = document.getElementById('ingredientForm');
            if (form) {
                form.addEventListener('submit', validateForm);
            }
        }

        // Quand le DOM est chargé, initialise le formulaire
        document.addEventListener('DOMContentLoaded', initForm);
    </script>

    <style>
        /* Ton CSS reste inchangé */
        .form-container {
            max-width: 800px;
            margin: 0 auto;
        }

        .form-header {
            margin-bottom: 30px;
        }

        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }

        .price-input {
            position: relative;
        }

        .price-input::after {
            content: "€";
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            color: #666;
        }

        .unit-selector {
            display: flex;
            gap: 10px;
            margin-top: 8px;
        }

        .unit-option {
            padding: 8px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 14px;
        }

        .unit-option:hover {
            background: #f5f5f5;
        }

        .unit-option.active {
            background: #2196F3;
            color: white;
            border-color: #2196F3;
        }

        .category-selector {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: 10px;
            margin-top: 8px;
        }

        .category-option {
            padding: 12px;
            border: 2px solid #eee;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
        }

        .category-option:hover {
            border-color: #2196F3;
            transform: translateY(-2px);
        }

        .category-option.active {
            border-color: #2196F3;
            background: rgba(33, 150, 243, 0.1);
        }

        .category-option i {
            font-size: 24px;
            margin-bottom: 5px;
        }

        .shelf-life-indicator {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-top: 15px;
        }

        .indicator-bar {
            flex: 1;
            height: 8px;
            background: #eee;
            border-radius: 4px;
            overflow: hidden;
        }

        .indicator-fill {
            height: 100%;
            transition: width 0.3s;
        }

        .indicator-label {
            font-size: 12px;
            color: #666;
        }

        .preview-card {
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 20px;
            margin-top: 20px;
            background: #f9f9f9;
        }

        .preview-header {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 15px;
        }

        .preview-icon {
            width: 50px;
            height: 50px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: white;
        }

        .preview-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
        }

        .preview-item {
            background: white;
            padding: 10px;
            border-radius: 5px;
        }

        .preview-label {
            font-size: 12px;
            color: #666;
            margin-bottom: 5px;
        }

        .preview-value {
            font-weight: 500;
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
    <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
        <div>
            <h2><i class="fas ${isEdit ? 'fa-edit' : 'fa-plus-circle'}"></i>
                <c:choose>
                    <c:when test="${isEdit}">Modifier l'ingrédient</c:when>
                    <c:otherwise>Nouvel Ingrédient</c:otherwise>
                </c:choose>
            </h2>
            <p style="color: #666; margin-top: 5px;">
                <c:choose>
                    <c:when test="${isEdit}">Modifiez les informations de l'ingrédient</c:when>
                    <c:otherwise>Ajoutez un nouvel ingrédient à votre base</c:otherwise>
                </c:choose>
            </p>
        </div>
        <a href="ingredients" class="btn">
            <i class="fas fa-arrow-left"></i> Retour à la liste
        </a>
    </div>

    <!-- Main Form -->
    <div class="card form-container">
        <form id="ingredientForm" action="ingredients" method="POST">
            <!-- Hidden fields -->
            <c:if test="${isEdit && not empty ingredient}">
                <input type="hidden" name="id" value="${ingredient.id}">
            </c:if>

            <!-- Basic Information -->
            <div class="form-section">
                <h3 style="margin-bottom: 20px; color: #333;">
                    <i class="fas fa-info-circle"></i> Informations de base
                </h3>

                <div class="form-row">
                    <div class="form-group">
                        <label for="name">
                            <i class="fas fa-tag"></i> Nom de l'ingrédient *
                        </label>
                        <input type="text"
                               id="name"
                               name="name"
                               class="form-control"
                               value="<c:if test='${not empty ingredient}'>${ingredient.name}</c:if>"
                               required
                               placeholder="Ex: Tomate, Poulet, Farine...">
                        <div style="font-size: 12px; color: #666; margin-top: 5px;">
                            Nom unique qui identifie l'ingrédient
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="category">
                            <i class="fas fa-layer-group"></i> Catégorie *
                        </label>
                        <div class="category-selector">
                            <div class="category-option" data-value="Viandes" onclick="selectCategory('Viandes')">
                                <i class="fas fa-drumstick-bite" style="color: #FF6B6B;"></i>
                                <span>Viandes</span>
                            </div>
                            <div class="category-option" data-value="Légumes" onclick="selectCategory('Légumes')">
                                <i class="fas fa-leaf" style="color: #51CF66;"></i>
                                <span>Légumes</span>
                            </div>
                            <div class="category-option" data-value="Produits laitiers" onclick="selectCategory('Produits laitiers')">
                                <i class="fas fa-cheese" style="color: #FFD93D;"></i>
                                <span>Produits laitiers</span>
                            </div>
                            <div class="category-option" data-value="Épicerie" onclick="selectCategory('Épicerie')">
                                <i class="fas fa-wheat-awn" style="color: #FF922B;"></i>
                                <span>Épicerie</span>
                            </div>
                            <div class="category-option" data-value="Boissons" onclick="selectCategory('Boissons')">
                                <i class="fas fa-wine-bottle" style="color: #339AF0;"></i>
                                <span>Boissons</span>
                            </div>
                        </div>
                        <input type="hidden"
                               id="category"
                               name="category"
                               value="<c:if test='${not empty ingredient}'>${ingredient.category}</c:if>"
                               required>
                        <div style="font-size: 12px; color: #666; margin-top: 5px;">
                            Sélectionnez la catégorie principale
                        </div>
                    </div>
                </div>

                <!-- Pricing and Units -->
                <div class="form-row">
                    <div class="form-group">
                        <label for="currentPrice">
                            <i class="fas fa-euro-sign"></i> Prix unitaire (€) *
                        </label>
                        <div class="price-input">
                            <input type="number"
                                   id="currentPrice"
                                   name="currentPrice"
                                   class="form-control"
                                   value="<c:if test='${not empty ingredient}'>${ingredient.currentPrice}</c:if>"
                                   step="0.01"
                                   min="0"
                                   max="1000"
                                   required
                                   oninput="updatePreview()"
                                   placeholder="0.00">
                        </div>
                        <div style="font-size: 12px; color: #666; margin-top: 5px;">
                            Prix d'achat par unité
                        </div>
                    </div>

                    <div class="form-group">
                        <label>
                            <i class="fas fa-balance-scale"></i> Unité de mesure *
                        </label>
                        <div class="unit-selector">
                            <span class="unit-option" data-unit="kg" onclick="selectUnit('kg')">kg</span>
                            <span class="unit-option" data-unit="g" onclick="selectUnit('g')">g</span>
                            <span class="unit-option" data-unit="L" onclick="selectUnit('L')">L</span>
                            <span class="unit-option" data-unit="mL" onclick="selectUnit('mL')">mL</span>
                            <span class="unit-option" data-unit="unité" onclick="selectUnit('unité')">Unité</span>
                            <span class="unit-option" data-unit="pièce" onclick="selectUnit('pièce')">Pièce</span>
                        </div>
                        <input type="hidden" id="unit" name="unit" value="<c:if test='${not empty ingredient}'>${ingredient.unit}</c:if>"
                               required>
                        <div style="font-size: 12px; color: #666; margin-top: 5px;">
                            Sélectionnez l'unité standard
                        </div>
                    </div>
                </div>

                <!-- Shelf Life -->
                <div class="form-row">
                    <div class="form-group">
                        <label for="shelfLifeDays">
                            <i class="fas fa-clock"></i> Durée de conservation (jours) *
                        </label>
                        <input type="range"
                               id="shelfLifeRange"
                               min="1"
                               max="365"
                               step="1"
                               value="<c:choose><c:when test='${not empty ingredient && ingredient.shelfLifeDays != null}'>${ingredient.shelfLifeDays}</c:when><c:otherwise>7</c:otherwise></c:choose>"
                               oninput="updateShelfLife(this.value)">
                        <div style="display: flex; justify-content: space-between; margin-top: 5px;">
                            <span style="font-size: 12px; color: #666;">1 jour</span>
                            <span style="font-size: 12px; color: #666;">1 an</span>
                        </div>
                        <div class="shelf-life-indicator">
                            <div class="indicator-bar">
                                <div id="shelfLifeFill" class="indicator-fill" style="width: <c:choose><c:when test='${not empty ingredient && ingredient.shelfLifeDays != null}'>${(ingredient.shelfLifeDays / 365) * 100}</c:when><c:otherwise>2</c:otherwise></c:choose>%;"></div>
                            </div>
                            <div class="indicator-label">
                                <span id="shelfLifeValue"><c:choose><c:when test='${not empty ingredient && ingredient.shelfLifeDays != null}'>${ingredient.shelfLifeDays}</c:when><c:otherwise>7</c:otherwise></c:choose></span> jours
                            </div>
                        </div>
                        <input type="hidden"
                               id="shelfLifeDays"
                               name="shelfLifeDays"
                               value="<c:choose><c:when test='${not empty ingredient && ingredient.shelfLifeDays != null}'>${ingredient.shelfLifeDays}</c:when><c:otherwise>7</c:otherwise></c:choose>"
                               required>
                    </div>

                    <div class="form-group">
                        <label>
                            <i class="fas fa-exclamation-triangle"></i> Type de conservation
                        </label>
                        <div id="shelfLifeType" style="padding: 12px; border-radius: 5px; background: #f5f5f5; margin-top: 8px;">
                            <div style="font-weight: 500;" id="typeText"></div>
                            <div style="font-size: 12px; color: #666; margin-top: 5px;" id="typeDescription"></div>
                        </div>
                    </div>
                </div>

                <!-- Preview Card -->
                <div class="preview-card" id="previewCard" style="display: none;">
                    <div class="preview-header">
                        <div id="previewIcon" class="preview-icon" style="background: #4CAF50;">
                            <i class="fas fa-carrot"></i>
                        </div>
                        <div>
                            <h4 style="margin: 0;" id="previewName">Nouvel Ingrédient</h4>
                            <div style="display: flex; gap: 10px; margin-top: 5px;">
                                <span id="previewCategory" style="padding: 2px 10px; background: #eee; border-radius: 12px; font-size: 12px;"></span>
                                <span id="previewPrice" style="font-weight: 500;"></span>
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
                        <div class="preview-item">
                            <div class="preview-label">Type</div>
                            <div class="preview-value" id="previewType"></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Form Actions -->
            <div class="form-actions">
                <button type="button" class="btn" onclick="window.location.href='ingredients'">
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

<!-- SUPPRIME TOUT LE JAVASCRIPT D'ICI - IL EST DÉJÀ DANS HEAD -->
</body>
</html>