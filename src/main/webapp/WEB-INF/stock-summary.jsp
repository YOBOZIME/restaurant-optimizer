<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rapport Stocks | Restaurant Supply Chain Optimizer</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .summary-card {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .summary-value {
            font-size: 24px;
            font-weight: bold;
            margin: 10px 0;
        }
        .chart-container {
            background: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .report-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .report-table th, .report-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        .report-table th {
            background: #f5f5f5;
            font-weight: 500;
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
            <a href="stock?action=summary"><i class="fas fa-chart-pie"></i> Rapport</a>
            <a href="waste"><i class="fas fa-trash"></i> Pertes</a>
        </nav>
    </header>

    <div class="stock-header">
        <div>
            <h2><i class="fas fa-chart-pie"></i> Rapport des Stocks</h2>
            <p style="color: #666; margin-top: 5px;">Analytique et statistiques des stocks</p>
        </div>
        <div>
            <button class="btn btn-success" onclick="printReport()">
                <i class="fas fa-print"></i> Imprimer
            </button>
            <button class="btn btn-info" onclick="exportFullReport()">
                <i class="fas fa-file-excel"></i> Exporter Excel
            </button>
        </div>
    </div>

    <!-- Summary Cards -->
    <div class="summary-grid">
        <div class="summary-card">
            <div style="color: #666;">
                <i class="fas fa-euro-sign"></i> Valeur Totale
            </div>
            <div class="summary-value" id="totalValue">Chargement...</div>
        </div>
        <div class="summary-card">
            <div style="color: #666;">
                <i class="fas fa-boxes"></i> Items en Stock
            </div>
            <div class="summary-value" id="totalItems">Chargement...</div>
        </div>
        <div class="summary-card">
            <div style="color: #666;">
                <i class="fas fa-exclamation-triangle"></i> Stocks Bas
            </div>
            <div class="summary-value" id="lowStockCount">Chargement...</div>
        </div>
        <div class="summary-card">
            <div style="color: #666;">
                <i class="fas fa-clock"></i> Expirent Bientôt
            </div>
            <div class="summary-value" id="expiringCount">Chargement...</div>
        </div>
    </div>

    <!-- Charts -->
    <div class="chart-container">
        <h3><i class="fas fa-chart-bar"></i> Distribution par Catégorie</h3>
        <canvas id="categoryChart" height="100"></canvas>
    </div>

    <div class="chart-container">
        <h3><i class="fas fa-store"></i> Valeur par Restaurant</h3>
        <canvas id="restaurantChart" height="100"></canvas>
    </div>

    <!-- Detailed Reports -->
    <div class="card">
        <h3><i class="fas fa-list"></i> Stocks Bas</h3>
        <table class="report-table" id="lowStockTable">
            <thead>
            <tr>
                <th>Ingrédient</th>
                <th>Restaurant</th>
                <th>Quantité</th>
                <th>Niveau</th>
                <th>Expiration</th>
            </tr>
            </thead>
            <tbody id="lowStockBody">
            <!-- Will be populated by JavaScript -->
            </tbody>
        </table>
    </div>

    <div class="card" style="margin-top: 20px;">
        <h3><i class="fas fa-clock"></i> Expirent dans 3 Jours</h3>
        <table class="report-table" id="expiringTable">
            <thead>
            <tr>
                <th>Ingrédient</th>
                <th>Restaurant</th>
                <th>Quantité</th>
                <th>Expiration</th>
                <th>Jours Restants</th>
            </tr>
            </thead>
            <tbody id="expiringBody">
            <!-- Will be populated by JavaScript -->
            </tbody>
        </table>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        loadStockSummary();
        loadLowStock();
        loadExpiringStock();
    });

    async function loadStockSummary() {
        try {
            const response = await fetch('${pageContext.request.contextPath}/api/stock/summary');
            if (response.ok) {
                const summary = await response.json();

                // Update summary cards
                document.getElementById('totalValue').textContent =
                    summary.totalValue ? summary.totalValue.toFixed(2) + ' €' : '0 €';
                document.getElementById('totalItems').textContent =
                    summary.totalItems || 0;
                document.getElementById('lowStockCount').textContent =
                    summary.lowStockCount || 0;
                document.getElementById('expiringCount').textContent =
                    summary.expiringCount || 0;

                // Create charts
                createCategoryChart(summary.byCategory);
                createRestaurantChart(summary.byRestaurant);
            }
        } catch (error) {
            console.error('Error loading summary:', error);
        }
    }

    async function loadLowStock() {
        try {
            const response = await fetch('${pageContext.request.contextPath}/api/stock/search?maxQuantity=5');
            if (response.ok) {
                const lowStock = await response.json();
                populateLowStockTable(lowStock);
            }
        } catch (error) {
            console.error('Error loading low stock:', error);
        }
    }

    async function loadExpiringStock() {
        try {
            const today = new Date();
            const threeDaysLater = new Date(today);
            threeDaysLater.setDate(today.getDate() + 3);

            const response = await fetch(
                `${pageContext.request.contextPath}/api/stock/search?expirationTo=${threeDaysLater.toISOString().split('T')[0]}`
            );

            if (response.ok) {
                const expiringStock = await response.json();
                populateExpiringTable(expiringStock);
            }
        } catch (error) {
            console.error('Error loading expiring stock:', error);
        }
    }

    function populateLowStockTable(stockItems) {
        const tbody = document.getElementById('lowStockBody');
        tbody.innerHTML = '';

        stockItems.forEach(stock => {
            if (stock.ingredient && stock.restaurant) {
                const row = document.createElement('tr');

                // Calculate days until expiration
                const now = new Date();
                const expirationDate = stock.expirationDate ? new Date(stock.expirationDate) : null;
                const daysDiff = expirationDate ?
                    Math.floor((expirationDate - now) / (1000 * 60 * 60 * 24)) : null;

                row.innerHTML = `
                    <td>${stock.ingredient.name}</td>
                    <td>${stock.restaurant.name}</td>
                    <td>${stock.quantity.toFixed(2)} ${stock.ingredient.unit}</td>
                    <td>
                        <span class="stock-level ${stock.quantity < 2 ? 'level-critical' : 'level-low'}">
                            ${stock.quantity < 2 ? 'Critique' : 'Bas'}
                        </span>
                    </td>
                    <td>
                        ${expirationDate ?
                            `${expirationDate.toLocaleDateString('fr-FR')} (${daysDiff}j)` :
                            'Non défini'}
                    </td>
                `;

                tbody.appendChild(row);
            }
        });
    }

    function populateExpiringTable(stockItems) {
        const tbody = document.getElementById('expiringBody');
        tbody.innerHTML = '';

        stockItems.forEach(stock => {
            if (stock.ingredient && stock.restaurant && stock.expirationDate) {
                const row = document.createElement('tr');

                const expirationDate = new Date(stock.expirationDate);
                const now = new Date();
                const daysDiff = Math.floor((expirationDate - now) / (1000 * 60 * 60 * 24));

                row.innerHTML = `
                    <td>${stock.ingredient.name}</td>
                    <td>${stock.restaurant.name}</td>
                    <td>${stock.quantity.toFixed(2)} ${stock.ingredient.unit}</td>
                    <td>${expirationDate.toLocaleDateString('fr-FR')}</td>
                    <td>
                        <span class="${daysDiff <= 0 ? 'expiration-soon' : 'expiration-warning'}">
                            ${daysDiff} jours
                        </span>
                    </td>
                `;

                tbody.appendChild(row);
            }
        });
    }

    function createCategoryChart(categoryData) {
        const ctx = document.getElementById('categoryChart').getContext('2d');

        const labels = categoryData.map(item => item[0]);
        const values = categoryData.map(item => item[3] || 0);

        new Chart(ctx, {
            type: 'pie',
            data: {
                labels: labels,
                datasets: [{
                    data: values,
                    backgroundColor: [
                        '#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0',
                        '#9966FF', '#FF9F40', '#8AC926', '#1982C4'
                    ]
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'right'
                    }
                }
            }
        });
    }

    function createRestaurantChart(restaurantData) {
        const ctx = document.getElementById('restaurantChart').getContext('2d');

        const labels = restaurantData.map(item => item[0]);
        const values = restaurantData.map(item => item[2] || 0);

        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Valeur (€)',
                    data: values,
                    backgroundColor: '#36A2EB'
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    }

    function printReport() {
        window.print();
    }

    function exportFullReport() {
        alert('Export Excel en développement');
        // In a real implementation, you would generate an Excel file
        // using a library like SheetJS or make a server request
    }
</script>
</body>
</html>