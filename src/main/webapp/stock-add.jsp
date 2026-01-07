<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %> <!-- ADD THIS LINE -->

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ajouter du Stock | Restaurant Supply Chain Optimizer</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .loading {
            display: none;
            text-align: center;
            padding: 20px;
        }
        .error-message {
            color: #F44336;
            background: #ffebee;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 15px;
            display: none;
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
            <a href="stock"><i class="fas fa-boxes"></i> Stocks</a>
            <a href="waste"><i class="fas fa-trash"></i> Pertes</a>
        </nav>
    </header>

    <div style="max-width: 600px; margin: 30px auto;">
        <div class="card">
            <h2 style="margin-bottom: 20px;">
                <i class="fas fa-plus-circle"></i> Ajouter du Stock
            </h2>

            <div id="errorMessage" class="error-message"></div>

            <!-- CHANGE: Remove form action and handle everything in JavaScript -->
            <form id="stockForm" method="POST">
                <div style="margin-bottom: 15px;">
                    <label for="restaurant" style="display: block; margin-bottom: 5px; font-weight: 500;">
                        Restaurant <span style="color: #F44336;">*</span>
                    </label>
                    <select id="restaurant" name="restaurantId" class="form-control" required>
                        <option value="">Sélectionner un restaurant</option>
                        <c:forEach var="restaurant" items="${restaurants}">
                            <option value="${restaurant.id}">${restaurant.name} - ${restaurant.address}</option>
                        </c:forEach>
                    </select>
                </div>

                <div style="margin-bottom: 15px;">
                    <label for="ingredient" style="display: block; margin-bottom: 5px; font-weight: 500;">
                        Ingrédient <span style="color: #F44336;">*</span>
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

                <div style="margin-bottom: 15px;">
                    <label for="quantity" style="display: block; margin-bottom: 5px; font-weight: 500;">
                        Quantité <span style="color: #F44336;">*</span>
                    </label>
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <input type="number" id="quantity" name="quantity" class="form-control"
                               step="0.01" min="0.01" value="1.00" required style="flex: 1;">
                        <span id="unitDisplay" style="color: #666; min-width: 60px;">-</span>
                    </div>
                    <div style="font-size: 12px; color: #666; margin-top: 5px;">
                        Valeur estimée: <span id="valueEstimate">0.00 €</span>
                    </div>
                </div>

                <div style="margin-bottom: 15px;">
                    <label for="expirationDate" style="display: block; margin-bottom: 5px; font-weight: 500;">
                        Date d'expiration
                    </label>
                    <input type="date" id="expirationDate" name="expirationDate" class="form-control"
                           min="${pageContext.request.contextPath}/getTomorrowDate()">
                    <div style="font-size: 12px; color: #666; margin-top: 5px;">
                        Format: AAAA-MM-JJ
                    </div>
                </div>

                <div style="margin-bottom: 20px;">
                    <label for="batchNumber" style="display: block; margin-bottom: 5px; font-weight: 500;">
                        Numéro de lot
                    </label>
                    <input type="text" id="batchNumber" name="batchNumber" class="form-control"
                           placeholder="Ex: LOT-2024-001">
                </div>

                <div style="display: flex; gap: 10px;">
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