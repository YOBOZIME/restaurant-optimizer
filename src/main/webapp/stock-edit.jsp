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
        .success-message {
            color: #4CAF50;
            background: #d4edda;
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
        .uneditable-info {
            background: #f9f9f9;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 15px;
            border-left: 4px solid #2196F3;
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
                <i class="fas fa-edit"></i> Modifier le Stock #${stock.id}
            </h2>

            <div id="errorMessage" class="error-message"></div>
            <div id="successMessage" class="success-message"></div>

            <!-- Stock information (uneditable) -->
            <div class="uneditable-info">
                <div style="font-weight: 500; margin-bottom: 10px; color: #2196F3;">
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

                <div style="margin-bottom: 15px;">
                    <label for="quantity" style="display: block; margin-bottom: 5px; font-weight: 500;">
                        Quantité <span style="color: #F44336;">*</span>
                    </label>
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <input type="number" id="quantity" name="quantity" class="form-control"
                               step="0.01" min="0.01" value="${stock.quantity}" required style="flex: 1;">
                        <span style="color: #666; min-width: 60px;">${ingredient.unit}</span>
                    </div>
                    <div style="font-size: 12px; color: #666; margin-top: 5px;">
                        Valeur actuelle: <span id="valueEstimate">
                            <fmt:formatNumber value="${stock.quantity * ingredient.currentPrice}"
                                              type="currency" currencyCode="EUR"/>
                        </span>
                    </div>
                </div>

                <div style="margin-bottom: 15px;">
                    <label for="expirationDate" style="display: block; margin-bottom: 5px; font-weight: 500;">
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
                    <div style="font-size: 12px; color: #666; margin-top: 5px;">
                        Format: AAAA-MM-JJ
                    </div>
                </div>

                <div style="margin-bottom: 20px;">
                    <label for="batchNumber" style="display: block; margin-bottom: 5px; font-weight: 500;">
                        Numéro de lot
                    </label>
                    <input type="text" id="batchNumber" name="batchNumber" class="form-control"
                           value="${stock.batchNumber != null ? stock.batchNumber : ''}"
                           placeholder="Ex: LOT-2024-001">
                </div>

                <div style="display: flex; gap: 10px;">
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
    document.getElementById('quantity').addEventListener('input', function() {
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