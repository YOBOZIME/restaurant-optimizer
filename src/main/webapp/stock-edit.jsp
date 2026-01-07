<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier le Stock | Restaurant Supply Chain Optimizer</title>
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
        .stock-info {
            background: #f5f5f5;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .info-item {
            display: flex;
            margin-bottom: 8px;
        }
        .info-label {
            font-weight: 500;
            min-width: 120px;
            color: #666;
        }
        .info-value {
            flex: 1;
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
                <i class="fas fa-edit"></i> Modifier le Stock
            </h2>

            <div id="errorMessage" class="error-message"></div>

            <!-- Stock information -->
            <div id="stockInfo" class="stock-info" style="display: none;">
                <div class="info-item">
                    <span class="info-label">Restaurant:</span>
                    <span id="infoRestaurant" class="info-value"></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Ingrédient:</span>
                    <span id="infoIngredient" class="info-value"></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Prix unitaire:</span>
                    <span id="infoPrice" class="info-value"></span>
                </div>
            </div>

            <form id="stockForm" method="POST">
                <input type="hidden" id="stockId">

                <div style="margin-bottom: 15px;">
                    <label for="quantity" style="display: block; margin-bottom: 5px; font-weight: 500;">
                        Quantité <span style="color: #F44336;">*</span>
                    </label>
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <input type="number" id="quantity" name="quantity" class="form-control"
                               step="0.01" min="0.01" required style="flex: 1;">
                        <span id="unitDisplay" style="color: #666; min-width: 60px;">-</span>
                    </div>
                    <div style="font-size: 12px; color: #666; margin-top: 5px;">
                        Valeur: <span id="valueEstimate">0.00 €</span>
                    </div>
                </div>

                <div style="margin-bottom: 15px;">
                    <label for="expirationDate" style="display: block; margin-bottom: 5px; font-weight: 500;">
                        Date d'expiration
                    </label>
                    <input type="date" id="expirationDate" name="expirationDate" class="form-control">
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
                        <i class="fas fa-save"></i> Mettre à jour
                    </button>
                    <a href="stock" class="btn btn-secondary" style="flex: 1;">
                        <i class="fas fa-times"></i> Annuler
                    </a>
                </div>

                <div id="loading" class="loading">
                    <i class="fas fa-spinner fa-spin"></i> Mise à jour en cours...
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Get stock ID from URL
    const urlParams = new URLSearchParams(window.location.search);
    const stockId = urlParams.get('id');

    document.addEventListener('DOMContentLoaded', function() {
        if (!stockId) {
            showError('ID de stock manquant');
            return;
        }

        loadStockData(stockId);
    });

    async function loadStockData(id) {
        try {
            const response = await fetch(`${pageContext.request.contextPath}/api/stock/${id}`);

            if (response.ok) {
                const stock = await response.json();
                populateForm(stock);
            } else {
                showError('Erreur lors du chargement du stock');
            }
        } catch (error) {
            console.error('Erreur:', error);
            showError('Erreur de connexion au serveur');
        }
    }

    function populateForm(stock) {
        document.getElementById('stockId').value = stock.id;
        document.getElementById('quantity').value = stock.quantity;
        document.getElementById('batchNumber').value = stock.batchNumber || '';

        if (stock.expirationDate) {
            const date = new Date(stock.expirationDate);
            document.getElementById('expirationDate').value = date.toISOString().split('T')[0];
        }

        // Display stock information
        if (stock.ingredient) {
            document.getElementById('unitDisplay').textContent = stock.ingredient.unit || '-';
            document.getElementById('infoIngredient').textContent =
                `${stock.ingredient.name} (${stock.ingredient.category || 'Non catégorisé'})`;
            document.getElementById('infoPrice').textContent =
                `${stock.ingredient.currentPrice.toFixed(2)} €`;
            updateValueEstimate();
        }

        if (stock.restaurant) {
            document.getElementById('infoRestaurant').textContent =
                `${stock.restaurant.name} - ${stock.restaurant.address || 'Adresse non définie'}`;
        }

        document.getElementById('stockInfo').style.display = 'block';
    }

    function updateValueEstimate() {
        const quantity = parseFloat(document.getElementById('quantity').value) || 0;
        const stockInfo = document.getElementById('stockInfo');

        if (stockInfo.style.display !== 'none') {
            // Extract price from info text
            const priceText = document.getElementById('infoPrice').textContent;
            const priceMatch = priceText.match(/(\d+\.?\d*)/);
            const price = priceMatch ? parseFloat(priceMatch[0]) : 0;

            const value = price * quantity;
            document.getElementById('valueEstimate').textContent = value.toFixed(2) + ' €';
        }
    }

    // Update value estimate when quantity changes
    document.getElementById('quantity').addEventListener('input', updateValueEstimate);

    // Form submission
    document.getElementById('stockForm').addEventListener('submit', async function(e) {
        e.preventDefault();

        const submitBtn = document.getElementById('submitBtn');
        const loadingDiv = document.getElementById('loading');
        const errorDiv = document.getElementById('errorMessage');

        errorDiv.style.display = 'none';
        errorDiv.textContent = '';

        const quantity = document.getElementById('quantity').value;

        if (!quantity || parseFloat(quantity) <= 0) {
            showError('La quantité doit être positive');
            return;
        }

        submitBtn.disabled = true;
        loadingDiv.style.display = 'block';

        try {
            const stockData = {
                id: parseInt(document.getElementById('stockId').value),
                quantity: parseFloat(quantity),
                batchNumber: document.getElementById('batchNumber').value || null,
                expirationDate: document.getElementById('expirationDate').value || null
            };

            if (stockData.expirationDate) {
                stockData.expirationDate += 'T00:00:00';
            }

            const response = await fetch(`${pageContext.request.contextPath}/api/stock/${stockData.id}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                body: JSON.stringify(stockData)
            });

            if (response.ok) {
                alert('Stock mis à jour avec succès !');
                window.location.href = '${pageContext.request.contextPath}/stock';
            } else {
                const errorText = await response.text();
                let errorMessage = 'Erreur serveur';
                try {
                    const errorJson = JSON.parse(errorText);
                    errorMessage = errorJson.error || errorJson.message || errorMessage;
                } catch (e) {
                    errorMessage = errorText || errorMessage;
                }
                showError(errorMessage);
            }

        } catch (error) {
            console.error('Erreur réseau:', error);
            showError('Erreur de connexion au serveur: ' + error.message);
        } finally {
            submitBtn.disabled = false;
            loadingDiv.style.display = 'none';
        }
    });

    function showError(message) {
        const errorDiv = document.getElementById('errorMessage');
        errorDiv.textContent = message;
        errorDiv.style.display = 'block';
        errorDiv.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
</script>
</body>
</html>