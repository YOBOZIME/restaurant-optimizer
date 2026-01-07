<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Erreur | Restaurant Supply Chain Optimizer</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
<div class="container">
    <header class="header">
        <h1><i class="fas fa-chart-network"></i> Restaurant Supply Chain Optimizer</h1>
    </header>

    <div class="card" style="max-width: 800px; margin: 50px auto; text-align: center;">
        <div style="font-size: 72px; color: #F44336; margin-bottom: 20px;">
            <i class="fas fa-exclamation-triangle"></i>
        </div>

        <h2 style="color: #F44336; margin-bottom: 20px;">Erreur</h2>

        <div style="background: #f8d7da; padding: 20px; border-radius: 8px; margin-bottom: 20px;">
            <c:choose>
                <c:when test="${not empty error}">
                    <p>${error}</p>
                </c:when>
                <c:when test="${not empty errorMessage}">
                    <p>${errorMessage}</p>
                </c:when>
                <c:otherwise>
                    <p>Une erreur inattendue s'est produite.</p>
                </c:otherwise>
            </c:choose>
        </div>

        <div style="margin-top: 30px;">
            <a href="dashboard" class="btn btn-primary">
                <i class="fas fa-home"></i> Retour au Dashboard
            </a>
            <button onclick="window.history.back()" class="btn">
                <i class="fas fa-arrow-left"></i> Retour
            </button>
        </div>
    </div>
</div>
</body>
</html>