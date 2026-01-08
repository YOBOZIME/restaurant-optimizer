<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${ingredient.name} | Détails Ingrédient</title>
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
            max-width: 1400px;
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

        /* Ingredient Header */
        .ingredient-header {
            background: rgba(20, 20, 20, 0.9);
            border-radius: 12px;
            padding: 40px;
            margin-bottom: 30px;
            box-shadow: 0 8px 32px rgba(220, 0, 0, 0.15);
            border: 1px solid rgba(255, 0, 0, 0.2);
            position: relative;
            overflow: hidden;
        }

        .ingredient-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent 30%, rgba(255, 0, 0, 0.05) 50%, transparent 70%);
            transform: rotate(30deg);
            animation: shimmer 3s infinite;
        }

        @keyframes shimmer {
            0% { transform: translateX(-100%) rotate(30deg); }
            100% { transform: translateX(100%) rotate(30deg); }
        }

        .header-content {
            position: relative;
            z-index: 1;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
        }

        .ingredient-info {
            display: flex;
            align-items: center;
            gap: 25px;
        }

        .ingredient-icon {
            width: 100px;
            height: 100px;
            border-radius: 20px;
            background: linear-gradient(135deg, #ff0000 0%, #cc0000 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 48px;
            color: white;
            box-shadow: 0 8px 25px rgba(255, 0, 0, 0.3);
        }

        .ingredient-details h2 {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 15px;
            color: #ffffff;
        }

        .ingredient-tags {
            display: flex;
            gap: 15px;
            margin-top: 10px;
        }

        .ingredient-tag {
            background: rgba(255, 255, 255, 0.1);
            padding: 8px 20px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .price-display {
            text-align: right;
            padding: 20px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            min-width: 200px;
        }

        .price-value {
            font-size: 32px;
            font-weight: 700;
            color: #ffffff;
            background: linear-gradient(135deg, #ff0000 0%, #ff6666 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .price-unit {
            font-size: 16px;
            color: #888888;
            margin-top: 5px;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            position: relative;
            z-index: 1;
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

        .btn-sm {
            padding: 8px 16px;
            font-size: 13px;
        }

        .btn-secondary {
            background: rgba(255, 255, 255, 0.05);
            color: #cccccc;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .btn-secondary:hover {
            background: rgba(255, 255, 255, 0.1);
            color: #ffffff;
        }

        .btn-warning {
            background: linear-gradient(135deg, #ff9800 0%, #f57c00 100%);
            color: white;
        }

        .btn-warning:hover {
            background: linear-gradient(135deg, #ffb74d 0%, #ff9800 100%);
        }

        .btn-danger {
            background: linear-gradient(135deg, #ff5252 0%, #d32f2f 100%);
            color: white;
        }

        .btn-danger:hover {
            background: linear-gradient(135deg, #ff867f 0%, #ff5252 100%);
        }

        .btn-primary {
            background: linear-gradient(135deg, #ff0000 0%, #cc0000 100%);
            color: white;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #ff3333 0%, #e60000 100%);
        }

        /* Info Grid */
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }

        /* Card Styling */
        .card {
            background: rgba(20, 20, 20, 0.9);
            border-radius: 12px;
            padding: 30px;
            border: 1px solid rgba(255, 255, 255, 0.05);
            transition: transform 0.3s ease;
        }

        .card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(220, 0, 0, 0.15);
            border-color: rgba(255, 0, 0, 0.2);
        }

        .card h3 {
            color: #ffffff;
            font-size: 20px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
            padding-bottom: 15px;
            border-bottom: 2px solid rgba(255, 0, 0, 0.3);
        }

        .card h3 i {
            color: #ff3333;
        }

        /* Info Rows */
        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 15px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }

        .info-row:last-child {
            border-bottom: none;
        }

        .info-label {
            color: #888888;
            font-weight: 500;
            font-size: 14px;
        }

        .info-value {
            color: #ffffff;
            font-weight: 600;
            font-size: 16px;
        }

        /* Badges */
        .badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
        }

        .badge-primary {
            background: rgba(255, 0, 0, 0.15);
            color: #ff6666;
            border: 1px solid rgba(255, 0, 0, 0.2);
        }

        .badge-success {
            background: rgba(0, 200, 83, 0.15);
            color: #00c853;
            border: 1px solid rgba(0, 200, 83, 0.2);
        }

        .badge-warning {
            background: rgba(255, 152, 0, 0.15);
            color: #ff9800;
            border: 1px solid rgba(255, 152, 0, 0.2);
        }

        .badge-danger {
            background: rgba(255, 82, 82, 0.15);
            color: #ff5252;
            border: 1px solid rgba(255, 82, 82, 0.2);
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 20px;
            margin: 25px 0;
        }

        .stat-item {
            text-align: center;
            padding: 20px;
            background: rgba(255, 255, 255, 0.03);
            border-radius: 10px;
            border: 1px solid rgba(255, 255, 255, 0.05);
            transition: all 0.3s ease;
        }

        .stat-item:hover {
            background: rgba(255, 0, 0, 0.05);
            border-color: rgba(255, 0, 0, 0.2);
            transform: translateY(-3px);
        }

        .stat-value {
            font-size: 28px;
            font-weight: 700;
            color: #ffffff;
            margin-bottom: 8px;
            background: linear-gradient(135deg, #ff0000 0%, #ff6666 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .stat-label {
            font-size: 13px;
            color: #888888;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* Shelf Life Meter */
        .shelf-life-meter {
            margin-top: 20px;
            padding: 20px;
            background: rgba(255, 255, 255, 0.02);
            border-radius: 10px;
            border: 1px solid rgba(255, 255, 255, 0.05);
        }

        .meter-bar {
            height: 12px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 6px;
            overflow: hidden;
            margin: 15px 0;
            position: relative;
        }

        .meter-fill {
            height: 100%;
            border-radius: 6px;
            transition: width 0.3s ease;
        }

        .meter-labels {
            display: flex;
            justify-content: space-between;
            font-size: 12px;
            color: #666666;
            margin-top: 10px;
        }

        /* Stock Table */
        .stock-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 20px;
        }

        .stock-table th {
            background: rgba(255, 0, 0, 0.1);
            padding: 16px;
            text-align: left;
            font-weight: 600;
            color: #ffffff;
            border-bottom: 2px solid rgba(255, 0, 0, 0.3);
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .stock-table td {
            padding: 16px;
            color: #cccccc;
            font-size: 14px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }

        .stock-table tr:hover {
            background: rgba(255, 0, 0, 0.05);
        }

        /* Progress Bar */
        .progress-bar {
            height: 6px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 3px;
            overflow: hidden;
            margin-top: 8px;
        }

        .progress-fill {
            height: 100%;
            border-radius: 3px;
            transition: width 0.3s ease;
        }

        /* Restaurant Cell */
        .restaurant-cell {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .restaurant-icon-small {
            width: 36px;
            height: 36px;
            border-radius: 8px;
            background: rgba(255, 0, 0, 0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ff3333;
            font-size: 16px;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #666666;
        }

        .empty-state i {
            font-size: 64px;
            margin-bottom: 20px;
            color: #333333;
        }

        .empty-state h3 {
            color: #ffffff;
            margin-bottom: 10px;
            font-size: 24px;
        }

        .empty-state p {
            color: #888888;
            margin-bottom: 30px;
            font-size: 16px;
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

        .card, .stat-item, .ingredient-header {
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

            .header-content {
                flex-direction: column;
                gap: 30px;
                text-align: center;
            }

            .ingredient-info {
                flex-direction: column;
                text-align: center;
            }

            .ingredient-tags {
                justify-content: center;
                flex-wrap: wrap;
            }

            .price-display {
                text-align: center;
                width: 100%;
            }

            .action-buttons {
                flex-direction: column;
            }

            .action-buttons .btn {
                width: 100%;
                justify-content: center;
            }

            .info-grid {
                grid-template-columns: 1fr;
            }

            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .stock-table {
                display: block;
                overflow-x: auto;
            }
        }

        @media (max-width: 480px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }

            .ingredient-icon {
                width: 80px;
                height: 80px;
                font-size: 36px;
            }

            .ingredient-details h2 {
                font-size: 24px;
            }
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

    <!-- Ingredient Header -->
    <div class="ingredient-header">
        <div class="header-content">
            <div class="ingredient-info">
                <div class="ingredient-icon">
                    <i class="fas
                        <c:choose>
                            <c:when test="${ingredient.category eq 'Viandes'}">fa-drumstick-bite</c:when>
                            <c:when test="${ingredient.category eq 'Légumes'}">fa-leaf</c:when>
                            <c:when test="${ingredient.category eq 'Produits laitiers'}">fa-cheese</c:when>
                            <c:when test="${ingredient.category eq 'Épicerie'}">fa-wheat-awn</c:when>
                            <c:when test="${ingredient.category eq 'Boissons'}">fa-wine-bottle</c:when>
                            <c:otherwise>fa-carrot</c:otherwise>
                        </c:choose>">
                    </i>
                </div>
                <div class="ingredient-details">
                    <h2>${ingredient.name}</h2>
                    <div class="ingredient-tags">
                        <span class="ingredient-tag">
                            <i class="fas fa-layer-group"></i> ${ingredient.category}
                        </span>
                        <span class="ingredient-tag">
                            <i class="fas fa-box"></i> ${ingredient.unit}
                        </span>
                        <span class="ingredient-tag">
                            <i class="fas fa-clock"></i> ${ingredient.shelfLifeDays} jours
                        </span>
                    </div>
                </div>
            </div>
            <div class="price-display">
                <div class="price-value">
                    <fmt:formatNumber value="${ingredient.currentPrice}" type="currency" currencyCode="EUR"/>
                </div>
                <div class="price-unit">/ ${ingredient.unit}</div>
            </div>
        </div>

        <div class="action-buttons">
            <a href="ingredients" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Retour à la liste
            </a>
            <a href="edit-ingredient?id=${ingredient.id}" class="btn btn-warning">
                <i class="fas fa-edit"></i> Modifier
            </a>
            <button class="btn btn-danger" onclick="deleteIngredient(${ingredient.id})">
                <i class="fas fa-trash"></i> Supprimer
            </button>
        </div>
    </div>

    <!-- Statistiques -->
    <div class="card">
        <h3><i class="fas fa-chart-bar"></i> Statistiques globales</h3>
        <div class="stats-grid">
            <div class="stat-item">
                <div class="stat-value">
                    <fmt:formatNumber value="${totalQuantity}" maxFractionDigits="2"/>
                </div>
                <div class="stat-label">Quantité totale</div>
            </div>
            <div class="stat-item">
                <div class="stat-value">
                    <fmt:formatNumber value="${totalValue}" type="currency" currencyCode="EUR" maxFractionDigits="2"/>
                </div>
                <div class="stat-label">Valeur totale</div>
            </div>
            <div class="stat-item">
                <div class="stat-value">
                    ${stocks.size()}
                </div>
                <div class="stat-label">Restaurants utilisateurs</div>
            </div>
            <div class="stat-item">
                <div class="stat-value">
                    ${ingredient.shelfLifeDays}
                </div>
                <div class="stat-label">Jours conservation</div>
            </div>
        </div>
    </div>

    <!-- Information Grid -->
    <div class="info-grid">
        <!-- Détails de l'ingrédient -->
        <div class="card">
            <h3><i class="fas fa-info-circle"></i> Détails de l'ingrédient</h3>
            <div class="info-row">
                <span class="info-label">ID</span>
                <span class="info-value">#${ingredient.id}</span>
            </div>
            <div class="info-row">
                <span class="info-label">Nom</span>
                <span class="info-value">${ingredient.name}</span>
            </div>
            <div class="info-row">
                <span class="info-label">Catégorie</span>
                <span class="info-value">
                    <span class="badge badge-primary">
                        <i class="fas fa-layer-group"></i> ${ingredient.category}
                    </span>
                </span>
            </div>
            <div class="info-row">
                <span class="info-label">Unité</span>
                <span class="info-value">${ingredient.unit}</span>
            </div>
            <div class="info-row">
                <span class="info-label">Prix unitaire</span>
                <span class="info-value">
                    <strong><fmt:formatNumber value="${ingredient.currentPrice}" type="currency" currencyCode="EUR"/></strong>
                    <span style="font-size: 13px; color: #888888;">/ ${ingredient.unit}</span>
                </span>
            </div>
        </div>

        <!-- Conservation -->
        <div class="card">
            <h3><i class="fas fa-clock"></i> Conservation</h3>
            <div class="info-row">
                <span class="info-label">Durée</span>
                <span class="info-value">${ingredient.shelfLifeDays} jours</span>
            </div>
            <div class="info-row">
                <span class="info-label">Type</span>
                <span class="info-value">
                    <c:choose>
                        <c:when test="${ingredient.shelfLifeDays < 7}">
                            <span class="badge badge-danger">Très périssable</span>
                        </c:when>
                        <c:when test="${ingredient.shelfLifeDays < 14}">
                            <span class="badge badge-warning">Périssable</span>
                        </c:when>
                        <c:when test="${ingredient.shelfLifeDays < 30}">
                            <span class="badge badge-warning">Moyenne conservation</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge badge-success">Longue conservation</span>
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>

            <div class="shelf-life-meter">
                <div class="meter-bar">
                    <div class="meter-fill" style="
                            width: ${(ingredient.shelfLifeDays / 365) * 100}%;
                            background:
                    <c:choose>
                    <c:when test="${ingredient.shelfLifeDays < 7}">linear-gradient(90deg, #ff3333, #ff6666)</c:when>
                    <c:when test="${ingredient.shelfLifeDays < 14}">linear-gradient(90deg, #ff9800, #ffb74d)</c:when>
                    <c:when test="${ingredient.shelfLifeDays < 30}">linear-gradient(90deg, #ffc107, #ffd54f)</c:when>
                    <c:otherwise>linear-gradient(90deg, #00c853, #00e676)</c:otherwise>
                    </c:choose>;
                            "></div>
                </div>
                <div class="meter-labels">
                    <span>1 jour</span>
                    <span>1 mois</span>
                    <span>1 an</span>
                </div>
            </div>
        </div>

        <!-- Informations de stock -->
        <div class="card">
            <h3><i class="fas fa-boxes"></i> Disponibilité globale</h3>
            <div class="info-row">
                <span class="info-label">Restaurants utilisateurs</span>
                <span class="info-value">${stocks.size()}</span>
            </div>
            <div class="info-row">
                <span class="info-label">Quantité totale</span>
                <span class="info-value">
                    <fmt:formatNumber value="${totalQuantity}" maxFractionDigits="2"/> ${ingredient.unit}
                </span>
            </div>
            <div class="info-row">
                <span class="info-label">Valeur totale</span>
                <span class="info-value">
                    <strong><fmt:formatNumber value="${totalValue}" type="currency" currencyCode="EUR"/></strong>
                </span>
            </div>
        </div>
    </div>

    <!-- Stock dans les restaurants -->
    <div class="card">
        <h3><i class="fas fa-store"></i> Répartition par restaurant</h3>

        <c:choose>
            <c:when test="${not empty stocks && stocks.size() > 0}">
                <table class="stock-table">
                    <thead>
                    <tr>
                        <th>Restaurant</th>
                        <th>Ville</th>
                        <th>Quantité</th>
                        <th>Valeur</th>
                        <th>Expiration</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="stock" items="${stocks}">
                        <c:if test="${stock.restaurant != null}">
                            <tr>
                                <td>
                                    <div class="restaurant-cell">
                                        <div class="restaurant-icon-small">
                                            <i class="fas fa-store"></i>
                                        </div>
                                        <div>
                                            <strong style="color: #ffffff;">${stock.restaurant.name}</strong>
                                        </div>
                                    </div>
                                </td>
                                <td>${stock.restaurant.city}</td>
                                <td style="min-width: 150px;">
                                    <div>
                                        <fmt:formatNumber value="${stock.quantity}" maxFractionDigits="2"/>
                                        <span style="font-size: 12px; color: #888888;">${ingredient.unit}</span>
                                    </div>
                                    <div class="progress-bar">
                                        <div class="progress-fill" style="
                                                width: <c:choose>
                                        <c:when test="${stock.quantity > 20}">100%</c:when>
                                        <c:otherwise>${stock.quantity * 5}%</c:otherwise>
                                        </c:choose>;
                                                background: <c:choose>
                                        <c:when test="${stock.quantity < 2}">linear-gradient(90deg, #ff3333, #ff6666)</c:when>
                                        <c:when test="${stock.quantity < 5}">linear-gradient(90deg, #ff9800, #ffb74d)</c:when>
                                        <c:otherwise>linear-gradient(90deg, #00c853, #00e676)</c:otherwise>
                                        </c:choose>;
                                                "></div>
                                    </div>
                                </td>
                                <td>
                                    <strong>
                                        <fmt:formatNumber value="${stock.quantity * ingredient.currentPrice}"
                                                          type="currency" currencyCode="EUR" maxFractionDigits="2"/>
                                    </strong>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${stock.expirationDate != null}">
                                            <fmt:formatDate value="${stock.expirationDate}" pattern="dd/MM/yyyy"/>
                                            <c:set var="now" value="<%= new java.util.Date() %>" />
                                            <c:set var="daysDiff" value="${(stock.expirationDate.time - now.time) / (1000 * 60 * 60 * 24)}" />
                                            <c:if test="${daysDiff < 3}">
                                                    <span class="badge badge-danger" style="margin-left: 10px; font-size: 11px;">
                                                        <i class="fas fa-exclamation-circle"></i> ${Math.round(daysDiff)}j
                                                    </span>
                                            </c:if>
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <button class="btn btn-sm btn-primary" onclick="viewStock(${stock.id})" title="Voir détails">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:if>
                    </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-store-slash"></i>
                    <h3>Aucun stock trouvé</h3>
                    <p>
                        Cet ingrédient n'est actuellement présent dans aucun restaurant.
                    </p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    function deleteIngredient(id) {
        if (confirm('Êtes-vous sûr de vouloir supprimer cet ingrédient ? Cette action supprimera également toutes les références dans les stocks.')) {
            window.location.href = 'delete-ingredient?id=' + id;
        }
    }

    function viewStock(stockId) {
        alert('Visualisation du stock #' + stockId + ' - En construction');
        // À implémenter: redirection vers la page de détails du stock
    }

    // Add animation delays to table rows
    document.addEventListener('DOMContentLoaded', function() {
        const tableRows = document.querySelectorAll('.stock-table tbody tr');
        tableRows.forEach((row, index) => {
            row.style.animationDelay = `${index * 0.05}s`;
        });
    });
</script>
</body>
</html>