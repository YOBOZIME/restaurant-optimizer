<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier le Stock | Restaurant Supply Chain Optimizer</title>
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

        .btn-danger {
            background: linear-gradient(135deg, #ff5252 0%, #d32f2f 100%);
            color: white;
        }

        .btn-danger:hover {
            background: linear-gradient(135deg, #ff867f 0%, #ff5252 100%);
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

        /* Message styles - Updated for dark theme */
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

        .success-message {
            color: #00c853;
            background: rgba(0, 200, 83, 0.1);
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: none;
            border: 1px solid rgba(0, 200, 83, 0.2);
            font-size: 14px;
        }

        /* Uneditable info section - Updated for dark theme */
        .uneditable-info {
            background: rgba(255, 255, 255, 0.03);
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            border-left: 4px solid rgba(33, 150, 243, 0.5);
        }

        .uneditable-info > div:first-child {
            font-weight: 600;
            margin-bottom: 15px;
            color: #2196F3;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .info-item {
            display: flex;
            margin-bottom: 10px;
            padding-bottom: 10px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }

        .info-item:last-child {
            margin-bottom: 0;
            padding-bottom: 0;
            border-bottom: none;
        }

        .info-label {
            font-weight: 500;
            min-width: 120px;
            color: #888888;
        }

        .info-value {
            flex: 1;
            color: #ffffff;
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

        .unit-display {
            color: #00bcd4;
            min-width: 60px;
            font-weight: 500;
            background: rgba(0, 188, 212, 0.1);
            padding: 6px 12px;
            border-radius: 6px;
            text-align: center;
            border: 1px solid rgba(0, 188, 212, 0.2);
        }

        /* Value estimate display */
        #valueEstimate {
            color: #00bcd4;
            font-weight: 600;
        }

        /* Helper text */
        .helper-text {
            font-size: 12px;
            color: #888888;
            margin-top: 5px;
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
        </nav>
    </header>

    <div style="max-width: 600px; margin: 30px auto;">
        <div class="card">
            <h2>
                <i class="fas fa-edit"></i> Modifier le Stock #${stock.id}
            </h2>

            <div id="errorMessage" class="error-message"></div>
            <div id="successMessage" class="success-message"></div>

            <!-- Stock information (uneditable) -->
            <div class="uneditable-info">
                <div>
                    <i class="fas fa-info-circle"></i> Informations (non modifiables)
                </div>
                <div class="info-item">
                    <span class="info-label">Restaurant:</span>
                    <span class="info-value">${restaurant.name}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">Ingrédient:</span>
                    <span class="info-value">
                        ${ingredient.name} (${ingredient.category})
                        - <fmt:formatNumber value="${ingredient.currentPrice}" type="currency" currencyCode="EUR"/>
                    </span>
                </div>
                <div class="info-item">
                    <span class="info-label">Unité:</span>
                    <span class="info-value">${ingredient.unit}</span>
                </div>
            </div>

            <!-- Editable fields -->
            <form id="stockForm">
                <input type="hidden" id="stockId" value="${stock.id}">

                <div class="form-group">
                    <label for="quantity">
                        Quantité <span>*</span>
                    </label>
                    <div class="quantity-container">
                        <input type="number" id="quantity" name="quantity" class="form-control"
                               step="0.01" min="0.01" value="${stock.quantity}" required>
                        <span class="unit-display">${ingredient.unit}</span>
                    </div>
                    <div class="helper-text">
                        Valeur actuelle: <span id="valueEstimate">
                            <fmt:formatNumber value="${stock.quantity * ingredient.currentPrice}"
                                              type="currency" currencyCode="EUR"/>
                        </span>
                    </div>
                </div>

                <div class="form-group">
                    <label for="expirationDate">
                        Date d'expiration
                    </label>
                    <c:choose>
                        <c:when test="${not empty expirationDateStr}">
                            <input type="date" id="expirationDate" name="expirationDate" class="form-control"
                                   value="${expirationDateStr}">
                        </c:when>
                        <c:otherwise>
                            <input type="date" id="expirationDate" name="expirationDate" class="form-control">
                        </c:otherwise>
                    </c:choose>
                    <div class="helper-text">
                        Format: AAAA-MM-JJ
                    </div>
                </div>

                <div class="form-group">
                    <label for="batchNumber">
                        Numéro de lot
                    </label>
                    <input type="text" id="batchNumber" name="batchNumber" class="form-control"
                           value="${stock.batchNumber != null ? stock.batchNumber : ''}"
                           placeholder="Ex: LOT-2024-001">
                </div>

                <div style="display: flex; gap: 10px; margin-top: 30px;">
                    <button type="button" class="btn btn-success" style="flex: 1;" id="submitBtn" onclick="updateStock()">
                        <i class="fas fa-save"></i> Mettre à jour
                    </button>
                    <a href="stock" class="btn btn-secondary" style="flex: 1;">
                        <i class="fas fa-times"></i> Annuler
                    </a>
                    <button type="button" class="btn btn-danger" style="flex: 1;" onclick="deleteStock()">
                        <i class="fas fa-trash"></i> Supprimer
                    </button>
                </div>

                <div id="loading" class="loading">
                    <i class="fas fa-spinner fa-spin"></i> Mise à jour en cours...
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Mettre à jour la valeur estimée quand la quantité change
    document.getElementById('quantity').addEventListener('input', function(e) {
        let value = e.target.value;
        // Replace comma with dot as user types
        if (value.includes(',')) {
            e.target.value = value.replace(',', '.');
        }
        updateValueEstimate();
    });

    function updateValueEstimate() {
        const quantity = parseFloat(document.getElementById('quantity').value) || 0;
        const price = ${ingredient.currentPrice}; // Prix direct depuis JSP
        const value = price * quantity;
        document.getElementById('valueEstimate').textContent = value.toFixed(2) + ' €';
    }

    // Fonction pour mettre à jour le stock
    async function updateStock() {
        const submitBtn = document.getElementById('submitBtn');
        const loadingDiv = document.getElementById('loading');
        const errorDiv = document.getElementById('errorMessage');
        const successDiv = document.getElementById('successMessage');

        // Masquer les messages précédents
        errorDiv.style.display = 'none';
        successDiv.style.display = 'none';

        // Validation
        const quantity = document.getElementById('quantity').value;
        if (!quantity || parseFloat(quantity) <= 0) {
            showError('La quantité doit être positive');
            return;
        }

        submitBtn.disabled = true;
        loadingDiv.style.display = 'block';

        try {
            const stockData = {
                quantity: parseFloat(quantity.replace(',', '.')),
                batchNumber: document.getElementById('batchNumber').value || null,
                expirationDate: document.getElementById('expirationDate').value || null
            };

            // Ajouter l'heure pour la date d'expiration
            if (stockData.expirationDate) {
                stockData.expirationDate += 'T00:00:00';
            }

            const stockId = document.getElementById('stockId').value;
            console.log('Updating stock ID:', stockId);
            console.log('Data:', stockData);

            const response = await fetch('${pageContext.request.contextPath}/api/stock/' + stockId, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                body: JSON.stringify(stockData)
            });

            console.log('Response status:', response.status);

            if (response.ok) {
                const result = await response.json();
                console.log('Update success:', result);
                showSuccess('Stock mis à jour avec succès !');
                // Redirection après 2 secondes
                setTimeout(() => {
                    window.location.href = '${pageContext.request.contextPath}/stock';
                }, 2000);
            } else {
                const errorText = await response.text();
                console.error('Update error:', errorText);
                let errorMessage = 'Erreur serveur lors de la mise à jour';
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
    }

    // Fonction pour supprimer le stock
    async function deleteStock() {
        if (confirm('Êtes-vous sûr de vouloir supprimer ce stock ? Cette action est irréversible.')) {
            try {
                const stockId = document.getElementById('stockId').value;
                console.log('Deleting stock ID:', stockId);

                const response = await fetch('${pageContext.request.contextPath}/api/stock/' + stockId, {
                    method: 'DELETE',
                    headers: {
                        'Accept': 'application/json'
                    }
                });

                console.log('Delete response status:', response.status);

                if (response.ok) {
                    const result = await response.json();
                    console.log('Delete success:', result);
                    alert('Stock supprimé avec succès');
                    window.location.href = '${pageContext.request.contextPath}/stock';
                } else {
                    const error = await response.text();
                    console.error('Delete error:', error);
                    let errorMessage = 'Erreur lors de la suppression';
                    try {
                        const errorJson = JSON.parse(error);
                        errorMessage = errorJson.error || errorJson.message || errorMessage;
                    } catch (e) {
                        errorMessage = error;
                    }
                    alert(errorMessage);
                }
            } catch (error) {
                console.error('Erreur réseau:', error);
                alert('Erreur de connexion au serveur: ' + error.message);
            }
        }
    }

    function showError(message) {
        const errorDiv = document.getElementById('errorMessage');
        errorDiv.textContent = message;
        errorDiv.style.display = 'block';
        errorDiv.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }

    function showSuccess(message) {
        const successDiv = document.getElementById('successMessage');
        successDiv.textContent = message;
        successDiv.style.display = 'block';
        successDiv.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }

    // Initialiser la valeur estimée
    document.addEventListener('DOMContentLoaded', function() {
        updateValueEstimate();
    });
</script>
</body>
</html>