<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Ingrédients | Restaurant Supply Chain Optimizer</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }

        /* Dans le style de ingredients.jsp, ajoute */
        .btn-info {
            background: #17a2b8;
            color: white;
            border: none;
        }

        .btn-info:hover {
            background: #138496;
        }

        .search-bar {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        .search-bar input {
            flex: 1;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }

        .filter-badges {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .filter-badge {
            padding: 8px 15px;
            background: #f0f0f0;
            border-radius: 20px;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 14px;
        }

        .filter-badge:hover, .filter-badge.active {
            background: #2196F3;
            color: white;
        }

        .ingredient-actions {
            display: flex;
            gap: 8px;
        }

        .quantity-indicator {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }

        .quantity-low { background: #f8d7da; color: #721c24; }
        .quantity-medium { background: #fff3cd; color: #856404; }
        .quantity-high { background: #d4edda; color: #155724; }

        .price-change {
            font-size: 12px;
            margin-left: 5px;
        }

        .price-up { color: #F44336; }
        .price-down { color: #4CAF50; }

        .action-buttons {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .ingredient-image {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            object-fit: cover;
            background: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #666;
        }

        .category-colors {
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .category-color {
            width: 12px;
            height: 12px;
            border-radius: 50%;
        }

        .viande-color { background: #FF6B6B; }
        .legume-color { background: #51CF66; }
        .produit-laitier-color { background: #FFD93D; }
        .epicerie-color { background: #FF922B; }
        .boisson-color { background: #339AF0; }
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
            <h2><i class="fas fa-carrot"></i> Gestion des Ingrédients</h2>
            <p style="color: #666; margin-top: 5px;">Gérez votre base d'ingrédients et leurs caractéristiques</p>
        </div>
        <div class="action-buttons">
            <a href="ingredients?action=add" class="btn btn-success">
                <i class="fas fa-plus-circle"></i> Nouvel Ingrédient
            </a>
        </div>
    </div>

    <!-- Search and Filters -->
    <div class="card">
        <div class="search-bar">
            <input type="text" id="searchInput" placeholder="Rechercher un ingrédient..."
                   onkeyup="filterIngredients()">
            <button class="btn btn-primary" onclick="filterIngredients()">
                <i class="fas fa-search"></i> Rechercher
            </button>
            <button class="btn" onclick="clearFilters()">
                <i class="fas fa-times"></i> Effacer
            </button>
        </div>

        <div class="filter-badges">
            <span class="filter-badge active" data-category="all" onclick="filterByCategory('all')">Tous</span>
            <span class="filter-badge" data-category="Viandes" onclick="filterByCategory('Viandes')">
                <span class="category-color viande-color"></span> Viandes
            </span>
            <span class="filter-badge" data-category="Légumes" onclick="filterByCategory('Légumes')">
                <span class="category-color legume-color"></span> Légumes
            </span>
            <span class="filter-badge" data-category="Produits laitiers" onclick="filterByCategory('Produits laitiers')">
                <span class="category-color produit-laitier-color"></span> Produits laitiers
            </span>
            <span class="filter-badge" data-category="Épicerie" onclick="filterByCategory('Épicerie')">
                <span class="category-color epicerie-color"></span> Épicerie
            </span>
            <span class="filter-badge" data-category="Boissons" onclick="filterByCategory('Boissons')">
                <span class="category-color boisson-color"></span> Boissons
            </span>
        </div>
    </div>

    <!-- Ingredients Table -->
    <div class="card">
        <div style="overflow-x: auto;">
            <table style="width: 100%; border-collapse: collapse;">
                <thead>
                <tr style="background: #f4f4f4;">
                    <th style="padding: 12px; text-align: left; border-bottom: 2px solid #ddd;">ID</th>
                    <th style="padding: 12px; text-align: left; border-bottom: 2px solid #ddd;">Ingrédient</th>
                    <th style="padding: 12px; text-align: left; border-bottom: 2px solid #ddd;">Catégorie</th>
                    <th style="padding: 12px; text-align: left; border-bottom: 2px solid #ddd;">Prix</th>
                    <th style="padding: 12px; text-align: left; border-bottom: 2px solid #ddd;">Unité</th>
                    <th style="padding: 12px; text-align: left; border-bottom: 2px solid #ddd;">Conservation</th>
                    <th style="padding: 12px; text-align: left; border-bottom: 2px solid #ddd;">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="ing" items="${ingredients}">
                    <tr data-category="${ing.category}" style="border-bottom: 1px solid #eee;">
                        <td style="padding: 12px;">#${ing.id}</td>
                        <td style="padding: 12px;">
                            <div style="display: flex; align-items: center; gap: 12px;">
                                <div class="ingredient-image">
                                    <i class="fas
                                        <c:choose>
                                            <c:when test="${ing.category eq 'Viandes'}">fa-drumstick-bite</c:when>
                                            <c:when test="${ing.category eq 'Légumes'}">fa-leaf</c:when>
                                            <c:when test="${ing.category eq 'Produits laitiers'}">fa-cheese</c:when>
                                            <c:when test="${ing.category eq 'Épicerie'}">fa-wheat-awn</c:when>
                                            <c:when test="${ing.category eq 'Boissons'}">fa-wine-bottle</c:when>
                                            <c:otherwise>fa-carrot</c:otherwise>
                                        </c:choose>">
                                    </i>
                                </div>
                                <div>
                                    <strong>${ing.name}</strong>
                                </div>
                            </div>
                        </td>
                        <td style="padding: 12px;">
                            <span style="
                                    display: inline-block;
                                    padding: 4px 12px;
                                    border-radius: 12px;
                                    font-size: 12px;
                                    font-weight: 500;
                            <c:choose>
                            <c:when test="${ing.category eq 'Viandes'}">background: #f8d7da; color: #721c24;</c:when>
                            <c:when test="${ing.category eq 'Légumes'}">background: #d4edda; color: #155724;</c:when>
                            <c:when test="${ing.category eq 'Produits laitiers'}">background: #fff3cd; color: #856404;</c:when>
                            <c:when test="${ing.category eq 'Épicerie'}">background: #d1ecf1; color: #0c5460;</c:when>
                            <c:otherwise>background: #cce5ff; color: #004085;</c:otherwise>
                            </c:choose>
                                    ">
                                    ${ing.category}
                            </span>
                        </td>
                        <td style="padding: 12px;">
                            <strong><fmt:formatNumber value="${ing.currentPrice}" type="currency" currencyCode="EUR"/></strong>
                        </td>
                        <td style="padding: 12px;">${ing.unit}</td>
                        <td style="padding: 12px;">
                            <div style="display: flex; align-items: center; gap: 8px;">
                                <i class="far fa-clock"></i>
                                <span>${ing.shelfLifeDays} jours</span>
                                <span style="
                                        display: inline-block;
                                        padding: 2px 8px;
                                        border-radius: 12px;
                                        font-size: 11px;
                                <c:choose>
                                <c:when test="${ing.shelfLifeDays < 7}">background: #f8d7da; color: #721c24;</c:when>
                                <c:when test="${ing.shelfLifeDays < 14}">background: #fff3cd; color: #856404;</c:when>
                                <c:otherwise>background: #d4edda; color: #155724;</c:otherwise>
                                </c:choose>
                                        ">
                                    <c:choose>
                                        <c:when test="${ing.shelfLifeDays < 7}">Périssable</c:when>
                                        <c:when test="${ing.shelfLifeDays < 14}">Moyenne</c:when>
                                        <c:otherwise>Longue</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </td>
                        <!-- Modifie la dernière colonne dans ingredients.jsp -->
                        <td style="padding: 12px;">
                            <div class="ingredient-actions">
                                <button class="btn btn-sm btn-info" onclick="viewIngredient(${ing.id})"
                                        style="padding: 6px 12px;" title="Voir détails">
                                    <i class="fas fa-eye"></i>
                                </button>
                                <button class="btn btn-sm btn-warning" onclick="editIngredient(${ing.id})"
                                        style="padding: 6px 12px;" title="Modifier">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <button class="btn btn-sm btn-danger" onclick="deleteIngredient(${ing.id})"
                                        style="padding: 6px 12px;" title="Supprimer">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 20px;">
            <div style="color: #666; font-size: 14px;">
                Affichage de ${ingredients.size()} ingrédients
            </div>
        </div>
    </div>

    <!-- Stats Summary -->
    <div class="card">
        <h3 style="margin-bottom: 15px;"><i class="fas fa-chart-bar"></i> Statistiques des Ingrédients</h3>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px;">
            <div style="text-align: center;">
                <div style="font-size: 32px; font-weight: bold; color: #2196F3;">
                    ${ingredients.size()}
                </div>
                <div style="color: #666;">Total ingrédients</div>
            </div>
            <div style="text-align: center;">
                <div style="font-size: 32px; font-weight: bold; color: #4CAF50;">
                    <!-- Calcul du prix moyen -->
                    <c:set var="totalPrice" value="0" />
                    <c:forEach var="ing" items="${ingredients}">
                        <c:set var="totalPrice" value="${totalPrice + ing.currentPrice}" />
                    </c:forEach>
                    <fmt:formatNumber value="${ingredients.size() > 0 ? totalPrice / ingredients.size() : 0}"
                                      type="currency" currencyCode="EUR" maxFractionDigits="2"/>
                </div>
                <div style="color: #666;">Prix moyen</div>
            </div>
            <div style="text-align: center;">
                <div style="font-size: 32px; font-weight: bold; color: #FF9800;">
                    <!-- Compte des ingrédients périssables -->
                    <c:set var="perishableCount" value="0" />
                    <c:forEach var="ing" items="${ingredients}">
                        <c:if test="${ing.shelfLifeDays < 7}">
                            <c:set var="perishableCount" value="${perishableCount + 1}" />
                        </c:if>
                    </c:forEach>
                    ${perishableCount}
                </div>
                <div style="color: #666;">Ingrédients périssables</div>
            </div>
        </div>
    </div>
</div>

<script>
    // Filter functions
    function filterIngredients() {
        const searchTerm = document.getElementById('searchInput').value.toLowerCase();
        const rows = document.querySelectorAll('table tbody tr');
        let visibleCount = 0;

        rows.forEach(row => {
            const text = row.textContent.toLowerCase();
            if (text.includes(searchTerm)) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
            }
        });
    }

    function filterByCategory(category) {
        // Update active filter
        document.querySelectorAll('.filter-badge').forEach(badge => {
            badge.classList.remove('active');
        });
        event.target.classList.add('active');

        const rows = document.querySelectorAll('table tbody tr');
        rows.forEach(row => {
            if (category === 'all' || row.getAttribute('data-category') === category) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    function clearFilters() {
        document.getElementById('searchInput').value = '';
        document.querySelectorAll('.filter-badge').forEach(badge => {
            badge.classList.remove('active');
        });
        document.querySelector('.filter-badge[data-category="all"]').classList.add('active');

        const rows = document.querySelectorAll('table tbody tr');
        rows.forEach(row => row.style.display = '');
    }

    // Action functions
    function viewIngredient(id) {
        window.location.href = "view-ingredient?id=" + id;
    }

    function editIngredient(id) {
        window.location.href = "edit-ingredient?id=" + id;
    }

    function deleteIngredient(id) {
        if (confirm('Êtes-vous sûr de vouloir supprimer cet ingrédient ?')) {
            window.location.href = "delete-ingredient?id=" + id;
        }
    }
</script>
</body>
</html>