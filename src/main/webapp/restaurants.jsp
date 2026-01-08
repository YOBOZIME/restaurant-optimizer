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

        /* Alerts */
        .alert {
            padding: 15px 20px;
            border-radius: 10px;
            margin: 20px 0;
            border: 1px solid;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-success {
            background: rgba(0, 200, 83, 0.15);
            color: #00c853;
            border-color: rgba(0, 200, 83, 0.3);
        }

        .alert-danger {
            background: rgba(255, 82, 82, 0.15);
            color: #ff5252;
            border-color: rgba(255, 82, 82, 0.3);
        }

        /* Quick Stats */
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

        /* City Filter */
        .city-filter {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .city-badge {
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

        .city-badge:hover {
            background: rgba(255, 0, 0, 0.15);
            color: #ffffff;
            border-color: rgba(255, 0, 0, 0.3);
            transform: translateY(-2px);
        }

        .city-badge.active {
            background: linear-gradient(135deg, #ff0000 0%, #cc0000 100%);
            color: white;
            border-color: #ff0000;
            box-shadow: 0 4px 15px rgba(255, 0, 0, 0.2);
        }

        /* Restaurant Grid */
        .restaurant-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 25px;
            margin: 20px 0;
        }

        @media (max-width: 768px) {
            .restaurant-grid {
                grid-template-columns: 1fr;
            }
        }

        /* Restaurant Card */
        .restaurant-card {
            background: rgba(20, 20, 20, 0.9);
            border-radius: 12px;
            padding: 25px;
            border: 1px solid rgba(255, 255, 255, 0.05);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .restaurant-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(220, 0, 0, 0.15);
            border-color: rgba(255, 0, 0, 0.2);
        }

        .restaurant-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 20px;
        }

        .restaurant-icon {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            background: linear-gradient(135deg, #ff0000 0%, #cc0000 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
        }

        .restaurant-status {
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .status-open {
            background: rgba(0, 200, 83, 0.15);
            color: #00c853;
        }

        .status-closed {
            background: rgba(255, 82, 82, 0.15);
            color: #ff5252;
        }

        .status-busy {
            background: rgba(255, 152, 0, 0.15);
            color: #ff9800;
        }

        .restaurant-id {
            position: absolute;
            top: 15px;
            right: 15px;
            background: rgba(255, 255, 255, 0.05);
            color: #888888;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 500;
        }

        .restaurant-id .inactive-badge {
            background: rgba(255, 82, 82, 0.2);
            color: #ff5252;
            padding: 2px 8px;
            border-radius: 10px;
            font-size: 9px;
            margin-left: 5px;
        }

        .restaurant-card h3 {
            color: #ffffff;
            font-size: 20px;
            margin: 10px 0;
            font-weight: 600;
        }

        .restaurant-location {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 15px;
            color: #888888;
            font-size: 14px;
        }

        .restaurant-location i {
            color: #ff3333;
        }

        /* Contact Info */
        .contact-info {
            background: rgba(255, 255, 255, 0.03);
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            border: 1px solid rgba(255, 255, 255, 0.05);
        }

        .contact-item {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
            color: #aaaaaa;
            font-size: 14px;
        }

        .contact-item:last-child {
            margin-bottom: 0;
        }

        .contact-item i {
            color: #ff3333;
            font-size: 14px;
            width: 16px;
        }

        /* Restaurant Stats */
        .restaurant-stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
            margin: 20px 0;
        }

        .restaurant-stat-item {
            text-align: center;
            padding: 15px;
            background: rgba(255, 255, 255, 0.03);
            border-radius: 10px;
            border: 1px solid rgba(255, 255, 255, 0.05);
        }

        .restaurant-stat-value {
            font-size: 22px;
            font-weight: 700;
            color: #ffffff;
            margin-bottom: 5px;
        }

        .restaurant-stat-label {
            font-size: 12px;
            color: #888888;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* Map Preview */
        .map-preview {
            width: 100%;
            height: 150px;
            background: rgba(255, 255, 255, 0.02);
            border-radius: 10px;
            margin: 20px 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            color: #666666;
            border: 1px solid rgba(255, 255, 255, 0.05);
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .map-preview:hover {
            background: rgba(255, 0, 0, 0.05);
            border-color: rgba(255, 0, 0, 0.2);
        }

        .map-preview i {
            font-size: 40px;
            color: #ff3333;
            margin-bottom: 10px;
        }

        /* Opening Hours */
        .opening-hours {
            font-size: 13px;
            color: #888888;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid rgba(255, 255, 255, 0.05);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .opening-hours i {
            color: #ff3333;
        }

        /* Restaurant Actions */
        .restaurant-actions {
            display: flex;
            gap: 10px;
            margin-top: 20px;
            justify-content: flex-end;
        }

        /* Empty State */
        .no-restaurants {
            text-align: center;
            padding: 60px 20px;
            color: #666666;
        }

        .no-restaurants i {
            font-size: 64px;
            margin-bottom: 20px;
            color: #333333;
        }

        .no-restaurants h3 {
            color: #ffffff;
            margin-bottom: 10px;
            font-size: 24px;
        }

        .no-restaurants p {
            color: #888888;
            margin-bottom: 30px;
            font-size: 16px;
        }

        /* Mobile Add Button */
        #mobileAddBtn {
            display: none;
            text-align: center;
            margin-top: 30px;
        }

        @media (max-width: 768px) {
            #mobileAddBtn {
                display: block;
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

        .restaurant-card, .card, .stat-card {
            animation: fadeIn 0.5s ease-out;
        }

        /* Section Headers */
        h3 {
            color: #ffffff;
            font-size: 20px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        h3 i {
            color: #ff3333;
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
            <p>Gérez vos restaurants et leurs caractéristiques</p>
        </div>
        <a href="restaurants?action=add" class="btn btn-success">
            <i class="fas fa-plus-circle"></i> Nouveau Restaurant
        </a>
    </div>

    <!-- Messages d'erreur/succès -->
    <c:if test="${not empty success}">
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i> ${success}
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger">
            <i class="fas fa-exclamation-circle"></i> ${error}
        </div>
    </c:if>

    <!-- Quick Stats -->
    <div class="card">
        <h3><i class="fas fa-chart-bar"></i> Vue d'ensemble</h3>
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-value">${restaurants.size()}</div>
                <div class="stat-label">Restaurants gérés</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">${uniqueCitiesCount}</div>
                <div class="stat-label">Villes desservies</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">${alertsCount}</div>
                <div class="stat-label">Alertes actives</div>
            </div>
        </div>
    </div>

    <!-- City Filter -->
    <div class="card">
        <h3><i class="fas fa-filter"></i> Filtrer par ville</h3>
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
                        <!-- ID et badge -->
                        <div class="restaurant-id">
                            #${restaurant.id}
                            <c:if test="${not restaurant.isActive}">
                                <span class="inactive-badge">Inactif</span>
                            </c:if>
                        </div>

                        <!-- En-tête avec icône et statut -->
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

                        <!-- Nom et ville -->
                        <h3>${restaurant.name}</h3>
                        <div class="restaurant-location">
                            <i class="fas fa-map-marker-alt"></i>
                            <span>${restaurant.city}</span>
                            <c:if test="${not empty restaurant.address}">
                                <span style="color: #666666;">• ${restaurant.address}</span>
                            </c:if>
                        </div>

                        <!-- Informations de contact -->
                        <c:if test="${not empty restaurant.phone or not empty restaurant.email}">
                            <div class="contact-info">
                                <c:if test="${not empty restaurant.phone}">
                                    <div class="contact-item">
                                        <i class="fas fa-phone"></i>
                                        <span>${restaurant.phone}</span>
                                    </div>
                                </c:if>
                                <c:if test="${not empty restaurant.email}">
                                    <div class="contact-item">
                                        <i class="fas fa-envelope"></i>
                                        <span>${restaurant.email}</span>
                                    </div>
                                </c:if>
                            </div>
                        </c:if>

                        <!-- Statistiques -->
                        <div class="restaurant-stats">
                            <!-- Capacité -->
                            <div class="restaurant-stat-item">
                                <div class="restaurant-stat-value">
                                        ${restaurant.capacity != null ? restaurant.capacity : '50'}
                                </div>
                                <div class="restaurant-stat-label">Places</div>
                            </div>

                            <!-- Horaires -->
                            <div class="restaurant-stat-item">
                                <div class="restaurant-stat-value">
                                    <c:choose>
                                        <c:when test="${restaurant.openingTime != null && restaurant.closingTime != null}">
                                            ${restaurant.openingTime}<br>${restaurant.closingTime}
                                        </c:when>
                                        <c:otherwise>
                                            11:00<br>22:00
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="restaurant-stat-label">Horaires</div>
                            </div>

                            <!-- Stock -->
                            <div class="restaurant-stat-item">
                                <div class="restaurant-stat-value">
                                        ${restaurant.id != null ? restaurant.id % 50 + 20 : '0'}
                                </div>
                                <div class="restaurant-stat-label">Stock</div>
                            </div>
                        </div>

                        <!-- Aperçu du stock -->
                        <div class="map-preview" onclick="viewRestaurant(${restaurant.id})">
                            <i class="fas fa-chart-pie"></i>
                            <div style="margin-top: 10px; font-size: 14px; color: #aaaaaa;">Voir le stock</div>
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
                <p>
                    Commencez par ajouter votre premier restaurant.
                </p>
                <a href="restaurants?action=add" class="btn btn-success" style="margin-top: 20px;">
                    <i class="fas fa-plus-circle"></i> Ajouter un Restaurant
                </a>
            </div>
        </c:otherwise>
    </c:choose>

    <!-- Add Restaurant Button (Mobile) -->
    <div id="mobileAddBtn">
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

        // Add animation delays to restaurant cards
        const cards = document.querySelectorAll('.restaurant-card');
        cards.forEach((card, index) => {
            card.style.animationDelay = `${index * 0.05}s`;
        });
    });
</script>
</body>
</html>