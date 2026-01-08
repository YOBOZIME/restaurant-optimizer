<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Ingrédients | Restaurant Supply Chain Optimizer</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* Reset and Base Styles */
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

        /* Container */
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

        .header nav a i {
            font-size: 16px;
        }

        /* Card Styling */
        .card {
            background: rgba(20, 20, 20, 0.9);
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(255, 255, 255, 0.05);
            transition: transform 0.3s ease;
        }

        .card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(220, 0, 0, 0.15);
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

        .btn-sm {
            padding: 8px 16px;
            font-size: 13px;
        }

        .btn-success {
            background: linear-gradient(135deg, #00c853 0%, #007e33 100%);
            color: white;
        }

        .btn-success:hover {
            background: linear-gradient(135deg, #00e676 0%, #008f40 100%);
        }

        .btn-primary {
            background: linear-gradient(135deg, #ff0000 0%, #cc0000 100%);
            color: white;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #ff3333 0%, #e60000 100%);
        }

        .btn-info {
            background: linear-gradient(135deg, #00bcd4 0%, #00838f 100%);
            color: white;
        }

        .btn-info:hover {
            background: linear-gradient(135deg, #26c6da 0%, #0097a7 100%);
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

        /* Search Bar */
        .search-bar {
            display: flex;
            gap: 12px;
            margin-bottom: 20px;
        }

        .search-bar input {
            flex: 1;
            padding: 14px 20px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            color: #ffffff;
            font-size: 15px;
            transition: all 0.3s ease;
        }

        .search-bar input:focus {
            outline: none;
            border-color: #ff0000;
            box-shadow: 0 0 0 2px rgba(255, 0, 0, 0.2);
            background: rgba(255, 255, 255, 0.08);
        }

        .search-bar input::placeholder {
            color: #777777;
        }

        /* Filter Badges */
        .filter-badges {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .filter-badge {
            padding: 10px 20px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 20px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 14px;
            color: #cccccc;
            border: 1px solid transparent;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .filter-badge:hover {
            background: rgba(255, 0, 0, 0.15);
            color: #ffffff;
            border-color: rgba(255, 0, 0, 0.3);
            transform: translateY(-2px);
        }

        .filter-badge.active {
            background: linear-gradient(135deg, #ff0000 0%, #cc0000 100%);
            color: white;
            border-color: #ff0000;
            box-shadow: 0 4px 15px rgba(255, 0, 0, 0.2);
        }

        /* Category Colors */
        .category-color {
            width: 12px;
            height: 12px;
            border-radius: 50%;
        }

        .viande-color { background: #ff3333; }
        .legume-color { background: #00cc44; }
        .produit-laitier-color { background: #ffcc00; }
        .epicerie-color { background: #ff6600; }
        .boisson-color { background: #3399ff; }

        /* Table Styling */
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }

        thead {
            background: rgba(255, 0, 0, 0.1);
        }

        th {
            padding: 16px;
            text-align: left;
            font-weight: 600;
            color: #ffffff;
            border-bottom: 2px solid rgba(255, 0, 0, 0.3);
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        tbody tr {
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            transition: all 0.3s ease;
        }

        tbody tr:hover {
            background: rgba(255, 0, 0, 0.05);
            transform: translateX(4px);
        }

        td {
            padding: 16px;
            color: #cccccc;
            font-size: 14px;
        }

        /* Ingredient Image */
        .ingredient-image {
            width: 48px;
            height: 48px;
            border-radius: 10px;
            background: rgba(255, 0, 0, 0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ff3333;
            font-size: 20px;
        }

        /* Category Badge */
        .category-badge {
            display: inline-block;
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* Conservation Status */
        .conservation-status {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .conservation-low {
            background: rgba(255, 51, 51, 0.15);
            color: #ff3333;
        }

        .conservation-medium {
            background: rgba(255, 204, 0, 0.15);
            color: #ffcc00;
        }

        .conservation-high {
            background: rgba(0, 204, 68, 0.15);
            color: #00cc44;
        }

        /* Action Buttons */
        .ingredient-actions {
            display: flex;
            gap: 8px;
        }

        /* Statistics Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.03);
            border-radius: 10px;
            padding: 25px;
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.05);
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            background: rgba(255, 0, 0, 0.05);
            border-color: rgba(255, 0, 0, 0.2);
            transform: translateY(-3px);
        }

        .stat-value {
            font-size: 36px;
            font-weight: 700;
            margin: 15px 0;
            background: linear-gradient(135deg, #ff0000 0%, #ff6666 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .stat-label {
            color: #aaaaaa;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* Pagination */
        .pagination-info {
            color: #777777;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .pagination-info i {
            color: #ff0000;
        }

        /* Action Buttons Container */
        .action-buttons {
            display: flex;
            gap: 12px;
            align-items: center;
        }

        /* Responsive Design */
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

            .search-bar {
                flex-direction: column;
            }

            .filter-badges {
                justify-content: center;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            table {
                display: block;
                overflow-x: auto;
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

        /* Scrollbar Styling */
        ::-webkit-scrollbar {
            width: 10px;
            height: 10px;
        }

        ::-webkit-scrollbar-track {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 5px;
        }

        ::-webkit-scrollbar-thumb {
            background: rgba(255, 0, 0, 0.3);
            border-radius: 5px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: rgba(255, 0, 0, 0.5);
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
        </nav>
    </header>

    <!-- Page Header -->
    <div class="page-header">
        <div>
            <h2><i class="fas fa-carrot"></i> Gestion des Ingrédients</h2>
            <p>Gérez votre base d'ingrédients et leurs caractéristiques</p>
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
            <button class="btn btn-outline" onclick="clearFilters()">
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
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Ingrédient</th>
                    <th>Catégorie</th>
                    <th>Prix</th>
                    <th>Unité</th>
                    <th>Conservation</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="ing" items="${ingredients}">
                    <tr data-category="${ing.category}">
                        <td>#${ing.id}</td>
                        <td>
                            <div style="display: flex; align-items: center; gap: 15px;">
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
                                    <strong style="color: #ffffff;">${ing.name}</strong>
                                </div>
                            </div>
                        </td>
                        <td>
                            <span class="category-badge" style="
                            <c:choose>
                            <c:when test="${ing.category eq 'Viandes'}">background: rgba(255, 51, 51, 0.15); color: #ff3333;</c:when>
                            <c:when test="${ing.category eq 'Légumes'}">background: rgba(0, 204, 68, 0.15); color: #00cc44;</c:when>
                            <c:when test="${ing.category eq 'Produits laitiers'}">background: rgba(255, 204, 0, 0.15); color: #ffcc00;</c:when>
                            <c:when test="${ing.category eq 'Épicerie'}">background: rgba(255, 102, 0, 0.15); color: #ff6600;</c:when>
                            <c:otherwise>background: rgba(51, 153, 255, 0.15); color: #3399ff;</c:otherwise>
                            </c:choose>
                                    ">
                                    ${ing.category}
                            </span>
                        </td>
                        <td>
                            <strong style="color: #ffffff;">
                                <fmt:formatNumber value="${ing.currentPrice}" type="currency" currencyCode="EUR"/>
                            </strong>
                        </td>
                        <td>${ing.unit}</td>
                        <td>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <i class="far fa-clock" style="color: #777777;"></i>
                                <span>${ing.shelfLifeDays} jours</span>
                                <span class="conservation-status
                                    <c:choose>
                                    <c:when test="${ing.shelfLifeDays < 7}">conservation-low</c:when>
                                    <c:when test="${ing.shelfLifeDays < 14}">conservation-medium</c:when>
                                    <c:otherwise>conservation-high</c:otherwise>
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
                        <td>
                            <div class="ingredient-actions">
                                <button class="btn btn-sm btn-info" onclick="viewIngredient(${ing.id})" title="Voir détails">
                                    <i class="fas fa-eye"></i>
                                </button>
                                <button class="btn btn-sm btn-warning" onclick="editIngredient(${ing.id})" title="Modifier">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <button class="btn btn-sm btn-danger" onclick="deleteIngredient(${ing.id})" title="Supprimer">
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
        <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 25px;">
            <div class="pagination-info">
                <i class="fas fa-list"></i>
                Affichage de ${ingredients.size()} ingrédients
            </div>
        </div>
    </div>

    <!-- Stats Summary -->
    <div class="card">
        <h3 style="margin-bottom: 20px; color: #ffffff; display: flex; align-items: center; gap: 10px;">
            <i class="fas fa-chart-bar" style="color: #ff0000;"></i> Statistiques des Ingrédients
        </h3>
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-value">${ingredients.size()}</div>
                <div class="stat-label">Total ingrédients</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">
                    <c:set var="totalPrice" value="0" />
                    <c:forEach var="ing" items="${ingredients}">
                        <c:set var="totalPrice" value="${totalPrice + ing.currentPrice}" />
                    </c:forEach>
                    <fmt:formatNumber value="${ingredients.size() > 0 ? totalPrice / ingredients.size() : 0}"
                                      type="currency" currencyCode="EUR" maxFractionDigits="2"/>
                </div>
                <div class="stat-label">Prix moyen</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">
                    <c:set var="perishableCount" value="0" />
                    <c:forEach var="ing" items="${ingredients}">
                        <c:if test="${ing.shelfLifeDays < 7}">
                            <c:set var="perishableCount" value="${perishableCount + 1}" />
                        </c:if>
                    </c:forEach>
                    ${perishableCount}
                </div>
                <div class="stat-label">Ingrédients périssables</div>
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

    // Add some interactive effects
    document.addEventListener('DOMContentLoaded', function() {
        // Add hover effects to cards
        const cards = document.querySelectorAll('.card');
        cards.forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-4px)';
            });
            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
            });
        });

        // Add animation to table rows
        const tableRows = document.querySelectorAll('tbody tr');
        tableRows.forEach((row, index) => {
            row.style.animationDelay = `${index * 0.05}s`;
        });
    });
</script>
</body>
</html>