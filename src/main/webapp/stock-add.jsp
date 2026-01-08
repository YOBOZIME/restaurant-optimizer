<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %> <!-- ADD THIS LINE -->

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ajouter du Stock | Restaurant Supply Chain Optimizer</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* Apply the same base styles as the first page */
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
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }

        /* Header Navigation - Same as first page */
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

        /* Card Styling - Same as other pages */
        .card {
            background: rgba(20, 20, 20, 0.9);
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(255, 255, 255, 0.05);
            transition: transform 0.3s ease;
        }

        .card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(220, 0, 0, 0.15);
        }

        /* Form Styles - Updated for dark theme */
        .form-control {
            width: 100%;
            padding: 12px 15px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            color: #ffffff;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            outline: none;
            border-color: rgba(255, 0, 0, 0.3);
            box-shadow: 0 0 0 3px rgba(255, 0, 0, 0.1);
            background: rgba(255, 255, 255, 0.08);
        }

        .form-control::placeholder {
            color: #888888;
        }

        select.form-control {
            cursor: pointer;
        }

        select.form-control option {
            background: rgba(30, 30, 30, 0.95);
            color: #ffffff;
            padding: 10px;
        }

        /* Buttons - Same styles */
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
            justify-content: center;
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

        .btn-secondary {
            background: linear-gradient(135deg, #666666 0%, #444444 100%);
            color: white;
        }

        .btn-secondary:hover {
            background: linear-gradient(135deg, #888888 0%, #666666 100%);
        }

        /* Labels */
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #cccccc;
        }

        label span {
            color: #ff5252;
        }

        /* Loading animation */
        .loading {
            display: none;
            text-align: center;
            padding: 20px;
            color: #ff9800;
            font-size: 14px;
        }

        .loading i {
            margin-right: 8px;
        }

        /* Error message - Updated for dark theme */
        .error-message {
            color: #ff5252;
            background: rgba(255, 82, 82, 0.1);
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: none;
            border: 1px solid rgba(255, 82, 82, 0.2);
            font-size: 14px;
        }

        /* Value estimate display */
        #valueEstimate {
            color: #00bcd4;
            font-weight: 600;
        }

        /* Page title */
        h2 {
            color: #ffffff;
            font-size: 24px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        h2 i {
            color: #ff3333;
        }

        /* Form group spacing */
        .form-group {
            margin-bottom: 20px;
        }

        /* Helper text */
        .helper-text {
            font-size: 12px;
            color: #888888;
            margin-top: 5px;
        }

        /* Quantity input container */
        .quantity-container {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 5px;
        }

        .quantity-container .form-control {
            flex: 1;
        }

        #unitDisplay {
            color: #00bcd4;
            min-width: 60px;
            font-weight: 500;
            background: rgba(0, 188, 212, 0.1);
            padding: 6px 12px;
            border-radius: 6px;
            text-align: center;
            border: 1px solid rgba(0, 188, 212, 0.2);
        }

        /* Animation */
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
    </style>
</head>
<body>
<div class="container">
    <header class="header">
        <h1><i class="fas fa-chart-network"></i> Restaurant Supply Chain Optimizer</h1>
        <nav>
            <a href="dashboard"><i class="fas fa-home"></i> Dashboard</a>
            <a href="ingredients"><i class="fas fa-carrot"></i> Ingrédients</a>
            <a href="restaurants"><i class="fas fa-store"></i> Restaurants</a>
            <a href="stock" class="active"><i class="fas fa-boxes"></i> Stocks</a>
            <a href="waste"><i class="fas fa-trash"></i> Pertes</a>
        </nav>
    </header>

    <div style="max-width: 600px; margin: 30px auto;">
        <div class="card">
            <h2>
                <i class="fas fa-plus-circle"></i> Ajouter du Stock
            </h2>

            <div id="errorMessage" class="error-message"></div>

            <!-- CHANGE: Remove form action and handle everything in JavaScript -->
            <form id="stockForm" method="POST">
                <div class="form-group">
                    <label for="restaurant">
                        Restaurant <span>*</span>
                    </label>
                    <select id="restaurant" name="restaurantId" class="form-control" required>
                        <option value="">Sélectionner un restaurant</option>
                        <c:forEach var="restaurant" items="${restaurants}">
                            <option value="${restaurant.id}">${restaurant.name} - ${restaurant.address}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="ingredient">
                        Ingrédient <span>*</span>
                    </label>
                    <select id="ingredient" name="ingredientId" class="form-control" required>
                        <option value="">Sélectionner un ingrédient</option>
                        <c:forEach var="ingredient" items="${ingredients}">
                            <option value="${ingredient.id}" data-unit="${ingredient.unit}"
                                    data-price="${ingredient.currentPrice}">
                                    ${ingredient.name} (${ingredient.category}) -
                                <fmt:formatNumber value="${ingredient.currentPrice}" type="currency" currencyCode="EUR"/>
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="quantity">
                        Quantité <span>*</span>
                    </label>
                    <div class="quantity-container">
                        <input type="number" id="quantity" name="quantity" class="form-control"
                               step="0.01" min="0.01" value="1.00" required>
                        <span id="unitDisplay">-</span>
                    </div>
                    <div class="helper-text">
                        Valeur estimée: <span id="valueEstimate">0.00 €</span>
                    </div>
                </div>

                <div class="form-group">
                    <label for="expirationDate">
                        Date d'expiration
                    </label>
                    <input type="date" id="expirationDate" name="expirationDate" class="form-control">
                    <div class="helper-text">
                        Format: AAAA-MM-JJ
                    </div>
                </div>

                <div class="form-group">
                    <label for="batchNumber">
                        Numéro de lot
                    </label>
                    <input type="text" id="batchNumber" name="batchNumber" class="form-control"
                           placeholder="Ex: LOT-2024-001">
                </div>

                <div style="display: flex; gap: 10px; margin-top: 30px;">
                    <button type="submit" class="btn btn-success" style="flex: 1;" id="submitBtn">
                        <i class="fas fa-save"></i> Enregistrer
                    </button>
                    <a href="stock" class="btn btn-secondary" style="flex: 1;">
                        <i class="fas fa-times"></i> Annuler
                    </a>
                </div>

                <div id="loading" class="loading">
                    <i class="fas fa-spinner fa-spin"></i> Enregistrement en cours...
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Fonction pour obtenir la date de demain au format YYYY-MM-DD
    function getTomorrowDate() {
        const tomorrow = new Date();
        tomorrow.setDate(tomorrow.getDate() + 1);
        return tomorrow.toISOString().split('T')[0];
    }

    // Set minimum date for expiration
    document.addEventListener('DOMContentLoaded', function() {
        const expirationDateInput = document.getElementById('expirationDate');
        expirationDateInput.min = getTomorrowDate();

        // Initialize value estimate
        updateValueEstimate();
    });

    // Mettre à jour l'unité quand l'ingrédient change
    document.getElementById('ingredient').addEventListener('change', function() {
        const selectedOption = this.options[this.selectedIndex];
        const unit = selectedOption.getAttribute('data-unit');
        const price = selectedOption.getAttribute('data-price');
        document.getElementById('unitDisplay').textContent = unit || '-';
        updateValueEstimate();
    });

    // Mettre à jour la valeur estimée
    document.getElementById('quantity').addEventListener('input', function(e) {
        let value = e.target.value;
        // Replace comma with dot as user types
        if (value.includes(',')) {
            e.target.value = value.replace(',', '.');
        }
        updateValueEstimate();
    });

    function updateValueEstimate() {
        const ingredientSelect = document.getElementById('ingredient');
        const quantityInput = document.getElementById('quantity');
        const valueEstimate = document.getElementById('valueEstimate');

        if (ingredientSelect.value && quantityInput.value) {
            const selectedOption = ingredientSelect.options[ingredientSelect.selectedIndex];
            const price = parseFloat(selectedOption.getAttribute('data-price')) || 0;
            const quantity = parseFloat(quantityInput.value) || 0;
            const value = price * quantity;
            valueEstimate.textContent = value.toFixed(2) + ' €';
        } else {
            valueEstimate.textContent = '0.00 €';
        }
    }

    // Gestion de la soumission du formulaire - CORRECTED VERSION
    document.getElementById('stockForm').addEventListener('submit', async function(e) {
        e.preventDefault();

        const submitBtn = document.getElementById('submitBtn');
        const loadingDiv = document.getElementById('loading');
        const errorDiv = document.getElementById('errorMessage');
        const quantityInput = document.getElementById('quantity');
        let quantityValue = quantityInput.value;
        quantityValue = quantityValue.replace(',', '.');
        quantityInput.value = quantityValue;

        // Masquer les erreurs précédentes
        errorDiv.style.display = 'none';
        errorDiv.textContent = '';

        // Validation simple
        const restaurantId = document.getElementById('restaurant').value;
        const ingredientId = document.getElementById('ingredient').value;
        const quantity = document.getElementById('quantity').value;

        if (!restaurantId || !ingredientId || !quantity) {
            showError('Tous les champs obligatoires doivent être remplis');
            return;
        }

        if (parseFloat(quantity) <= 0) {
            showError('La quantité doit être positive');
            return;
        }

        // Désactiver le bouton et afficher le loader
        submitBtn.disabled = true;
        loadingDiv.style.display = 'block';

        try {
            // Créer l'objet DTO
            const stockData = {
                restaurantId: parseInt(restaurantId),
                ingredientId: parseInt(ingredientId),
                quantity: parseFloat(quantity),
                batchNumber: document.getElementById('batchNumber').value || null
            };

            // Gérer la date d'expiration - FORMAT IMPORTANT
            const expirationDate = document.getElementById('expirationDate').value;
            if (expirationDate) {
                // Envoyer la date comme chaîne ISO - le serveur la convertira
                stockData.expirationDate = expirationDate + 'T00:00:00'; // Ajouter l'heure
            }

            console.log('Données envoyées:', stockData);
            console.log('URL:', '${pageContext.request.contextPath}/api/stock');

            // Appel API
            const response = await fetch('${pageContext.request.contextPath}/api/stock', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                body: JSON.stringify(stockData)
            });

            console.log('Statut de la réponse:', response.status);

            // Lire la réponse
            const responseText = await response.text();
            console.log('Réponse brute:', responseText);

            if (response.ok) {
                try {
                    const result = JSON.parse(responseText);
                    alert(result.message || 'Stock ajouté avec succès !');
                    window.location.href = '${pageContext.request.contextPath}/stock';
                } catch (e) {
                    alert('Stock ajouté avec succès !');
                    window.location.href = '${pageContext.request.contextPath}/stock';
                }
            } else {
                // Gérer les erreurs
                let errorMessage = 'Erreur serveur: ' + response.status;
                try {
                    const errorJson = JSON.parse(responseText);
                    errorMessage = errorJson.error || errorJson.message || errorMessage;
                } catch (e) {
                    errorMessage = responseText || errorMessage;
                }
                showError(errorMessage);
            }

        } catch (error) {
            console.error('Erreur réseau:', error);
            showError('Erreur de connexion au serveur: ' + error.message);
        } finally {
            // Réactiver le bouton et cacher le loader
            submitBtn.disabled = false;
            loadingDiv.style.display = 'none';
        }
    });

    function showError(message) {
        const errorDiv = document.getElementById('errorMessage');
        errorDiv.textContent = message;
        errorDiv.style.display = 'block';
        // Scroll vers l'erreur
        errorDiv.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
</script>
</body>
</html>