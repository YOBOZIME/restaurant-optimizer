<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${isEdit}">Modifier Restaurant</c:when>
            <c:otherwise>Nouveau Restaurant</c:otherwise>
        </c:choose>
        | Restaurant Supply Chain Optimizer
    </title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .form-container {
            max-width: 800px;
            margin: 30px auto;
            padding: 30px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .form-section {
            margin-bottom: 25px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }

        .form-section h3 {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #333;
            margin-bottom: 15px;
        }

        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 15px;
        }

        .time-inputs {
            display: flex;
            gap: 15px;
            align-items: center;
        }

        .time-inputs .form-group {
            flex: 1;
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

    <!-- Formulaire -->
    <div class="form-container">
        <div style="margin-bottom: 25px;">
            <h2 style="margin: 0; color: #333; display: flex; align-items: center; gap: 10px;">
                <i class="fas ${isEdit ? 'fa-edit' : 'fa-plus-circle'}"></i>
                <c:choose>
                    <c:when test="${isEdit}">Modifier le Restaurant</c:when>
                    <c:otherwise>Nouveau Restaurant</c:otherwise>
                </c:choose>
            </h2>
            <c:if test="${isEdit && not empty restaurant}">
                <p style="margin: 5px 0 0 0; color: #666;">ID: #${restaurant.id}</p>
            </c:if>
        </div>

        <form action="restaurants" method="POST">
            <c:if test="${isEdit && not empty restaurant}">
                <input type="hidden" name="id" value="${restaurant.id}">
            </c:if>

            <!-- Section Informations de base -->
            <div class="form-section">
                <h3><i class="fas fa-info-circle"></i> Informations de base</h3>
                <div class="form-row">
                    <div class="form-group">
                        <label for="name">
                            <i class="fas fa-store"></i> Nom du restaurant *
                        </label>
                        <input type="text" id="name" name="name" class="form-control" required
                               value="${not empty restaurant ? restaurant.name : ''}"
                               placeholder="Ex: La Belle Époque, Chez Pierre...">
                    </div>

                    <div class="form-group">
                        <label for="city">
                            <i class="fas fa-city"></i> Ville *
                        </label>
                        <input type="text" id="city" name="city" class="form-control" required
                               value="${not empty restaurant ? restaurant.city : ''}"
                               placeholder="Ex: Paris, Lyon, Marseille...">
                    </div>
                </div>
            </div>

            <!-- Section Contact -->
            <div class="form-section">
                <h3><i class="fas fa-address-book"></i> Informations de contact</h3>
                <div class="form-row">
                    <div class="form-group">
                        <label for="address">
                            <i class="fas fa-map-marker-alt"></i> Adresse
                        </label>
                        <input type="text" id="address" name="address" class="form-control"
                               value="${not empty restaurant ? restaurant.address : ''}"
                               placeholder="Numéro, rue, code postal...">
                    </div>

                    <div class="form-group">
                        <label for="phone">
                            <i class="fas fa-phone"></i> Téléphone
                        </label>
                        <input type="tel" id="phone" name="phone" class="form-control"
                               value="${not empty restaurant ? restaurant.phone : ''}"
                               placeholder="01 23 45 67 89">
                    </div>

                    <div class="form-group">
                        <label for="email">
                            <i class="fas fa-envelope"></i> Email
                        </label>
                        <input type="email" id="email" name="email" class="form-control"
                               value="${not empty restaurant ? restaurant.email : ''}"
                               placeholder="contact@restaurant.com">
                    </div>
                </div>
            </div>

            <!-- Section Horaires et capacité -->
            <div class="form-section">
                <h3><i class="fas fa-clock"></i> Horaires et capacité</h3>
                <div class="form-row">
                    <div class="form-group">
                        <label for="capacity">
                            <i class="fas fa-users"></i> Capacité (nombre de places)
                        </label>
                        <input type="number" id="capacity" name="capacity" class="form-control" min="1"
                               value="${not empty restaurant ? restaurant.capacity : '50'}"
                               placeholder="50">
                    </div>

                    <div class="time-inputs">
                        <div class="form-group">
                            <label for="openingTime">
                                <i class="fas fa-door-open"></i> Heure d'ouverture
                            </label>
                            <input type="time" id="openingTime" name="openingTime" class="form-control"
                                   value="${not empty restaurant && restaurant.openingTime != null ? restaurant.openingTime : '11:00'}">
                        </div>

                        <div style="align-self: center; font-size: 20px; color: #666;">à</div>

                        <div class="form-group">
                            <label for="closingTime">
                                <i class="fas fa-door-closed"></i> Heure de fermeture
                            </label>
                            <input type="time" id="closingTime" name="closingTime" class="form-control"
                                   value="${not empty restaurant && restaurant.closingTime != null ? restaurant.closingTime : '22:00'}">
                        </div>
                    </div>
                </div>
            </div>

            <!-- Section Statut -->
            <div class="form-section">
                <h3><i class="fas fa-toggle-on"></i> Statut</h3>
                <div class="form-group">
                    <label style="display: flex; align-items: center; gap: 10px; cursor: pointer;">
                        <input type="checkbox" id="isActive" name="isActive" value="true"
                        ${not empty restaurant && restaurant.isActive ? 'checked' : 'checked'}
                               style="width: auto;">
                        <span>Restaurant actif</span>
                    </label>
                    <small style="color: #666; display: block; margin-top: 5px;">
                        Un restaurant inactif n'apparaîtra pas dans les listes de commandes
                    </small>
                </div>
            </div>

            <div class="form-actions" style="display: flex; gap: 10px; margin-top: 30px;">
                <a href="restaurants" class="btn btn-secondary">
                    <i class="fas fa-times"></i> Annuler
                </a>
                <button type="submit" class="btn ${isEdit ? 'btn-warning' : 'btn-success'}">
                    <i class="fas fa-save"></i>
                    <c:choose>
                        <c:when test="${isEdit}">Mettre à jour</c:when>
                        <c:otherwise>Créer le restaurant</c:otherwise>
                    </c:choose>
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    // Validation des heures
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.querySelector('form');
        form.addEventListener('submit', function(e) {
            const openingTime = document.getElementById('openingTime').value;
            const closingTime = document.getElementById('closingTime').value;

            if (openingTime && closingTime && openingTime >= closingTime) {
                e.preventDefault();
                alert('L\'heure d\'ouverture doit être avant l\'heure de fermeture');
                return false;
            }
        });
    });
</script>
</body>
</html>