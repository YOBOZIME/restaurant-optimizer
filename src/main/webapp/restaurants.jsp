<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.TreeSet" %>

<%
    // Calculer les villes uniques en Java pur (pas Stream API)
    Set<String> uniqueCities = new TreeSet<>();
    if (request.getAttribute("restaurants") != null) {
        java.util.List<org.example.entity.core.Restaurant> restaurants =
                (java.util.List<org.example.entity.core.Restaurant>) request.getAttribute("restaurants");
        for (org.example.entity.core.Restaurant r : restaurants) {
            if (r.getCity() != null) {
                uniqueCities.add(r.getCity());
            }
        }
    }
    request.setAttribute("uniqueCities", uniqueCities);

    // Calculer le nombre de villes
    request.setAttribute("uniqueCitiesCount", uniqueCities.size());

    // Calculer les alertes
    int alertsCount = 0;
    if (request.getAttribute("restaurants") != null) {
        java.util.List<org.example.entity.core.Restaurant> restaurants =
                (java.util.List<org.example.entity.core.Restaurant>) request.getAttribute("restaurants");
        for (org.example.entity.core.Restaurant r : restaurants) {
            if (r.getId() != null) {
                alertsCount += (r.getId() % 3);
            }
        }
    }
    request.setAttribute("alertsCount", alertsCount);
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Restaurants | Restaurant Supply Chain Optimizer</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .restaurant-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin: 20px 0;
        }

        .restaurant-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: all 0.3s;
            border: 1px solid #eee;
            position: relative;
        }

        .restaurant-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        /* Ajoute ces styles à la section <style> existante */
        .btn-info {
            background: #17a2b8;
            color: white;
            border: none;
        }

        .btn-info:hover {
            background: #138496;
        }

        .restaurant-card .map-preview:hover {
            background: #f0f0f0;
            transition: background 0.3s;
        }

        .restaurant-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }


        .btn-warning {
            background: #ffc107;
            color: #212529;
            border: none;
        }

        .btn-warning:hover {
            background: #e0a800;
        }

        /* Pour les petits boutons */
        .btn-sm {
            padding: 5px 10px;
            font-size: 12px;
            border-radius: 4px;
        }


        .restaurant-icon {
            width: 50px;
            height: 50px;
            border-radius: 10px;
            background: linear-gradient(135deg, #2196F3 0%, #21CBF3 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
        }

        .restaurant-status {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }

        .status-open { background: #d4edda; color: #155724; }
        .status-closed { background: #f8d7da; color: #721c24; }
        .status-busy { background: #fff3cd; color: #856404; }

        .restaurant-stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
            margin: 15px 0;
        }

        .stat-item {
            text-align: center;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 8px;
        }

        .stat-value {
            font-size: 20px;
            font-weight: bold;
            color: #2196F3;
        }

        .stat-label {
            font-size: 11px;
            color: #666;
            margin-top: 5px;
        }

        .restaurant-actions {
            display: flex;
            gap: 8px;
            margin-top: 15px;
            justify-content: flex-end;
        }

        .city-filter {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            flex-wrap: wrap;
            align-items: center;
        }

        .city-badge {
            padding: 8px 15px;
            background: #f0f0f0;
            border-radius: 20px;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 14px;
        }

        .city-badge:hover, .city-badge.active {
            background: #2196F3;
            color: white;
        }

        .map-preview {
            width: 100%;
            height: 150px;
            background: #f0f0f0;
            border-radius: 8px;
            margin-top: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #666;
        }

        .restaurant-id {
            position: absolute;
            top: 10px;
            right: 10px;
            background: #f0f0f0;
            color: #666;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 11px;
        }

        .opening-hours {
            font-size: 12px;
            color: #666;
            margin-top: 10px;
            padding-top: 10px;
            border-top: 1px solid #eee;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .no-restaurants {
            text-align: center;
            padding: 40px;
            color: #666;
        }

        .no-restaurants i {
            font-size: 48px;
            margin-bottom: 20px;
            color: #ddd;
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
            <a href="ingredients"><i class="fas fa-carrot"></i> Ingrédients</a>
            <a href="restaurants" class="active"><i class="fas fa-store"></i> Restaurants</a>
            <a href="stock"><i class="fas fa-boxes"></i> Stocks</a>
            <a href="waste"><i class="fas fa-trash"></i> Pertes</a>
        </nav>
    </header>

    <!-- Page Header -->
    <div class="page-header">
        <div>
            <h2><i class="fas fa-store"></i> Gestion des Restaurants</h2>
            <p style="color: #666; margin-top: 5px;">Gérez vos restaurants et leurs caractéristiques</p>
        </div>
        <a href="restaurants?action=add" class="btn btn-success">
            <i class="fas fa-plus-circle"></i> Nouveau Restaurant
        </a>
    </div>
    <!-- Messages d'erreur/succès -->
    <c:if test="${not empty success}">
        <div class="alert alert-success" style="background-color: #d4edda; color: #155724;
            padding: 15px; border-radius: 8px; margin: 20px 0; border: 1px solid #c3e6cb;">
            <i class="fas fa-check-circle"></i> ${success}
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger" style="background-color: #f8d7da; color: #721c24;
            padding: 15px; border-radius: 8px; margin: 20px 0; border: 1px solid #f5c6cb;">
            <i class="fas fa-exclamation-circle"></i> ${error}
        </div>
    </c:if>

    <!-- Quick Stats -->
    <div class="card">
        <h3 style="margin-bottom: 15px;"><i class="fas fa-chart-bar"></i> Vue d'ensemble</h3>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px;">
            <div style="text-align: center;">
                <div style="font-size: 32px; font-weight: bold; color: #2196F3;">
                    ${restaurants.size()}
                </div>
                <div style="color: #666;">Restaurants gérés</div>
            </div>
            <div style="text-align: center;">
                <div style="font-size: 32px; font-weight: bold; color: #4CAF50;">
                    ${uniqueCitiesCount}
                </div>
                <div style="color: #666;">Villes desservies</div>
            </div>
            <div style="text-align: center;">
                <div style="font-size: 32px; font-weight: bold; color: #FF9800;">
                    ${alertsCount}
                </div>
                <div style="color: #666;">Alertes actives</div>
            </div>
        </div>
    </div>

    <!-- City Filter -->
    <div class="card">
        <h3 style="margin-bottom: 15px;"><i class="fas fa-filter"></i> Filtrer par ville</h3>
        <div class="city-filter">
            <span class="city-badge active" onclick="filterByCity('all')">Toutes les villes</span>
            <c:forEach var="city" items="${uniqueCities}">
                <span class="city-badge" onclick="filterByCity('${city}')">
                    <i class="fas fa-city"></i> ${city}
                </span>
            </c:forEach>
        </div>
    </div>

    <!-- Restaurants Grid -->
    <c:choose>
        <c:when test="${not empty restaurants && restaurants.size() > 0}">
            <div class="restaurant-grid">
                <c:forEach var="restaurant" items="${restaurants}">
                    <div class="restaurant-card" data-city="${restaurant.city}">
                        <!-- En-tête avec ID et statut -->
                        <div class="restaurant-header">
                            <div class="restaurant-icon">
                                <i class="fas fa-utensils"></i>
                            </div>
                            <div>
                <span class="restaurant-status ${restaurant.isActive ? 'status-open' : 'status-closed'}">
                    <i class="fas fa-circle" style="font-size: 8px;"></i>
                    ${restaurant.isActive ? 'Ouvert' : 'Fermé'}
                </span>
                            </div>
                        </div>

                        <!-- ID et badge -->
                        <div class="restaurant-id">
                            #${restaurant.id}
                            <c:if test="${not restaurant.isActive}">
                <span style="background: #dc3545; color: white; padding: 1px 6px; border-radius: 10px; font-size: 10px; margin-left: 5px;">
                    Inactif
                </span>
                            </c:if>
                        </div>

                        <!-- Nom et ville -->
                        <h3 style="margin: 10px 0;">${restaurant.name}</h3>
                        <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 10px;">
                            <i class="fas fa-map-marker-alt" style="color: #F44336;"></i>
                            <span style="color: #666;">${restaurant.city}</span>
                            <c:if test="${not empty restaurant.address}">
                                <span style="color: #999; font-size: 12px;">• ${restaurant.address}</span>
                            </c:if>
                        </div>

                        <!-- Informations de contact (si disponibles) -->
                        <c:if test="${not empty restaurant.phone or not empty restaurant.email}">
                            <div style="background: #f8f9fa; padding: 10px; border-radius: 8px; margin-bottom: 15px;">
                                <c:if test="${not empty restaurant.phone}">
                                    <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 5px; font-size: 13px;">
                                        <i class="fas fa-phone" style="color: #2196F3; font-size: 12px;"></i>
                                        <span style="color: #666;">${restaurant.phone}</span>
                                    </div>
                                </c:if>
                                <c:if test="${not empty restaurant.email}">
                                    <div style="display: flex; align-items: center; gap: 8px; font-size: 13px;">
                                        <i class="fas fa-envelope" style="color: #2196F3; font-size: 12px;"></i>
                                        <span style="color: #666;">${restaurant.email}</span>
                                    </div>
                                </c:if>
                            </div>
                        </c:if>

                        <!-- Statistiques RÉELLES -->
                        <div class="restaurant-stats">
                            <!-- Capacité -->
                            <div class="stat-item">
                                <div class="stat-value">
                                        ${restaurant.capacity != null ? restaurant.capacity : '50'}
                                </div>
                                <div class="stat-label">Places</div>
                            </div>

                            <!-- Horaires -->
                            <div class="stat-item">
                                <div class="stat-value">
                                    <c:choose>
                                        <c:when test="${restaurant.openingTime != null && restaurant.closingTime != null}">
                                            ${restaurant.openingTime}<br>${restaurant.closingTime}
                                        </c:when>
                                        <c:otherwise>
                                            11:00<br>22:00
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="stat-label">Horaires</div>
                            </div>

                            <!-- Informations supplémentaires (à compléter plus tard) -->
                            <div class="stat-item">
                                <div class="stat-value">
                                    <!-- À remplacer par vraie donnée -->
                                        ${restaurant.id != null ? restaurant.id % 50 + 20 : '0'}
                                </div>
                                <div class="stat-label">Stock</div>
                            </div>
                        </div>

                        <!-- Aperçu du stock (placeholder pour l'instant) -->
                        <div class="map-preview" style="cursor: pointer;" onclick="viewRestaurant(${restaurant.id})">
                            <i class="fas fa-chart-pie" style="font-size: 40px; color: #2196F3;"></i>
                            <div style="margin-top: 10px; font-size: 14px;">Voir le stock</div>
                        </div>

                        <!-- Horaires d'ouverture -->
                        <div class="opening-hours">
                            <i class="far fa-clock"></i>
                            <c:choose>
                                <c:when test="${restaurant.openingTime != null && restaurant.closingTime != null}">
                                    ${restaurant.openingTime} - ${restaurant.closingTime}
                                </c:when>
                                <c:otherwise>
                                    11:00 - 22:00
                                </c:otherwise>
                            </c:choose>
                            • Lundi - Dimanche
                        </div>

                        <!-- Boutons d'action -->
                        <div class="restaurant-actions">
                            <button class="btn btn-sm btn-info" onclick="viewRestaurant(${restaurant.id})">
                                <i class="fas fa-eye"></i> Détails
                            </button>
                            <button class="btn btn-sm btn-warning" onclick="editRestaurant(${restaurant.id})">
                                <i class="fas fa-edit"></i> Modifier
                            </button>
                            <button class="btn btn-sm btn-danger" onclick="deleteRestaurant(${restaurant.id})">
                                <i class="fas fa-trash"></i> Supprimer
                            </button>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="card no-restaurants">
                <i class="fas fa-store-slash"></i>
                <h3>Aucun restaurant trouvé</h3>
                <p style="color: #666; margin-top: 10px;">
                    Commencez par ajouter votre premier restaurant.
                </p>
                <a href="restaurants?action=add" class="btn btn-success" style="margin-top: 20px;">
                    <i class="fas fa-plus-circle"></i> Ajouter un Restaurant
                </a>
            </div>
        </c:otherwise>
    </c:choose>

    <!-- Add Restaurant Button (Mobile) -->
    <div style="text-align: center; margin-top: 30px; display: none;" id="mobileAddBtn">
        <a href="restaurants?action=add" class="btn btn-success" style="padding: 15px 30px; font-size: 16px;">
            <i class="fas fa-plus-circle"></i> Ajouter un Restaurant
        </a>
    </div>
</div>

<script>
    // Filter functions
    function filterByCity(city) {
        // Update active filter
        document.querySelectorAll('.city-badge').forEach(badge => {
            badge.classList.remove('active');
        });
        event.target.classList.add('active');

        const cards = document.querySelectorAll('.restaurant-card');
        cards.forEach(card => {
            if (city === 'all' || card.getAttribute('data-city') === city) {
                card.style.display = 'block';
            } else {
                card.style.display = 'none';
            }
        });
    }

    // Action functions
    // Modifier la fonction viewRestaurant
    function viewRestaurant(id) {
        window.location.href = "view-restaurant?id=" + id;
    }

    function editRestaurant(id) {
        window.location.href = "edit-restaurant?id=" + id;
    }

    function deleteRestaurant(id) {
        if (confirm('Êtes-vous sûr de vouloir supprimer ce restaurant ?')) {
            window.location.href = "delete-restaurant?id=" + id;
        }
    }

    // Mobile detection for add button
    window.addEventListener('resize', function() {
        const mobileBtn = document.getElementById('mobileAddBtn');
        if (window.innerWidth < 768) {
            mobileBtn.style.display = 'block';
        } else {
            mobileBtn.style.display = 'none';
        }
    });

    // Initialize on load
    document.addEventListener('DOMContentLoaded', function() {
        window.dispatchEvent(new Event('resize'));

        // Afficher un message si pas de restaurants
        const restaurantCount = ${restaurants.size()};
        if (restaurantCount === 0) {
            console.log('Aucun restaurant à afficher');
        } else {
            console.log(`${restaurantCount} restaurants à afficher`);
        }
    });
</script>
</body>
</html>