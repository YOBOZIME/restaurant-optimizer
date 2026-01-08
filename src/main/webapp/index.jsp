<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | Restaurant Supply Chain Optimizer</title>
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

        /* Header */
        .header {
            background: rgba(15, 15, 15, 0.95);
            border-radius: 12px;
            padding: 20px 30px;
            margin-bottom: 30px;
            box-shadow: 0 8px 32px rgba(220, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.05);
        }

        .header-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .brand-logo {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #ff0000 0%, #cc0000 100%);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: white;
        }

        .brand-text {
            display: flex;
            flex-direction: column;
        }

        .brand-title {
            color: #ff0000;
            font-size: 24px;
            font-weight: 700;
            margin: 0;
        }

        .brand-subtitle {
            color: #888888;
            font-size: 14px;
            margin: 0;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 15px;
            background: rgba(255, 255, 255, 0.03);
            border-radius: 10px;
            border: 1px solid rgba(255, 255, 255, 0.05);
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            background: rgba(255, 0, 0, 0.1);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ff3333;
            font-size: 20px;
        }

        .user-info {
            display: flex;
            flex-direction: column;
        }

        .user-name {
            color: #ffffff;
            font-weight: 600;
            font-size: 14px;
        }

        .user-role {
            color: #888888;
            font-size: 12px;
        }

        /* Navigation */
        .main-nav {
            display: flex;
            gap: 2px;
            background: rgba(255, 255, 255, 0.02);
            border-radius: 10px;
            padding: 5px;
            border: 1px solid rgba(255, 255, 255, 0.05);
        }

        .nav-link {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px 20px;
            color: #888888;
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s ease;
            position: relative;
        }

        .nav-link:hover {
            background: rgba(255, 0, 0, 0.05);
            color: #ffffff;
        }

        .nav-link.active {
            background: linear-gradient(135deg, rgba(255, 0, 0, 0.15) 0%, rgba(204, 0, 0, 0.15) 100%);
            color: #ff0000;
            border: 1px solid rgba(255, 0, 0, 0.2);
        }

        .nav-link.active .nav-icon {
            color: #ff0000;
        }

        .nav-icon {
            font-size: 18px;
        }

        .nav-text {
            font-weight: 500;
            font-size: 14px;
        }

        /* Dashboard Content */
        .dashboard-content {
            margin-bottom: 30px;
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

        .page-title h2 {
            color: #ffffff;
            font-size: 28px;
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 5px;
        }

        .page-title h2 i {
            color: #ff3333;
        }

        .page-subtitle {
            color: #888888;
            font-size: 15px;
        }

        /* Buttons */
        .btn {
            padding: 10px 20px;
            border-radius: 8px;
            border: none;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-refresh {
            background: rgba(255, 255, 255, 0.05);
            color: #ffffff;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .btn-refresh:hover {
            background: rgba(255, 0, 0, 0.1);
            border-color: rgba(255, 0, 0, 0.3);
            transform: translateY(-2px);
        }

        .btn-refresh.refreshing {
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .btn-export {
            background: linear-gradient(135deg, #ff0000 0%, #cc0000 100%);
            color: white;
        }

        .btn-export:hover {
            background: linear-gradient(135deg, #ff3333 0%, #e60000 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(255, 0, 0, 0.2);
        }

        /* Metrics Section */
        .metrics-section {
            margin-bottom: 30px;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .section-title {
            color: #ffffff;
            font-size: 20px;
        }

        .time-filter {
            display: flex;
            gap: 10px;
            background: rgba(255, 255, 255, 0.03);
            border-radius: 8px;
            padding: 4px;
            border: 1px solid rgba(255, 255, 255, 0.05);
        }

        .time-filter span {
            padding: 6px 15px;
            border-radius: 6px;
            font-size: 13px;
            cursor: pointer;
            color: #888888;
            transition: all 0.3s ease;
        }

        .time-filter span:hover {
            color: #ffffff;
            background: rgba(255, 255, 255, 0.05);
        }

        .time-filter .filter-active {
            background: linear-gradient(135deg, #ff0000 0%, #cc0000 100%);
            color: white;
        }

        /* Metrics Grid */
        .metrics-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
        }

        .metric-card {
            background: rgba(20, 20, 20, 0.9);
            border-radius: 12px;
            padding: 25px;
            border: 1px solid rgba(255, 255, 255, 0.05);
            transition: all 0.3s ease;
        }

        .metric-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(220, 0, 0, 0.15);
            border-color: rgba(255, 0, 0, 0.2);
        }

        .metric-card-primary {
            border-top: 4px solid #ff0000;
        }

        .metric-card-secondary {
            border-top: 4px solid #00c853;
        }

        .metric-card-warning {
            border-top: 4px solid #ff9800;
        }

        .metric-card-danger {
            border-top: 4px solid #ff5252;
        }

        .metric-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .metric-icon {
            width: 50px;
            height: 50px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
        }

        .metric-card-primary .metric-icon {
            background: rgba(255, 0, 0, 0.15);
            color: #ff3333;
        }

        .metric-card-secondary .metric-icon {
            background: rgba(0, 200, 83, 0.15);
            color: #00c853;
        }

        .metric-card-warning .metric-icon {
            background: rgba(255, 152, 0, 0.15);
            color: #ff9800;
        }

        .metric-card-danger .metric-icon {
            background: rgba(255, 82, 82, 0.15);
            color: #ff5252;
        }

        .metric-trend {
            font-size: 13px;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 20px;
        }

        .metric-trend.positive {
            background: rgba(0, 200, 83, 0.15);
            color: #00c853;
        }

        .metric-trend.negative {
            background: rgba(255, 82, 82, 0.15);
            color: #ff5252;
        }

        .metric-body {
            margin-bottom: 20px;
        }

        .metric-value {
            font-size: 36px;
            font-weight: 700;
            color: #ffffff;
            margin-bottom: 5px;
        }

        .metric-label {
            color: #888888;
            font-size: 14px;
            margin-bottom: 10px;
        }

        .metric-detail {
            display: flex;
            gap: 10px;
            font-size: 13px;
        }

        .detail-label {
            color: #666666;
        }

        .detail-value {
            color: #ffffff;
            font-weight: 500;
        }

        .progress-bar {
            height: 6px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 3px;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            border-radius: 3px;
            transition: width 0.3s ease;
        }

        .metric-card-primary .progress-fill {
            background: linear-gradient(90deg, #ff0000, #ff6666);
        }

        .metric-card-secondary .progress-fill {
            background: linear-gradient(90deg, #00c853, #00e676);
        }

        .metric-card-warning .progress-fill {
            background: linear-gradient(90deg, #ff9800, #ffb74d);
        }

        .metric-card-danger .progress-fill {
            background: linear-gradient(90deg, #ff5252, #ff867f);
        }

        /* Content Grid */
        .content-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }

        @media (max-width: 1200px) {
            .content-grid {
                grid-template-columns: 1fr;
            }
        }

        /* Cards */
        .card {
            background: rgba(20, 20, 20, 0.9);
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.05);
            margin-bottom: 30px;
            overflow: hidden;
            transition: transform 0.3s ease;
        }

        .card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(220, 0, 0, 0.15);
        }

        .card-header {
            padding: 25px 25px 15px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }

        .card-title {
            color: #ffffff;
            font-size: 18px;
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 5px;
        }

        .card-title i {
            color: #ff3333;
        }

        .card-subtitle {
            color: #888888;
            font-size: 13px;
        }

        .card-badge {
            position: absolute;
            top: 25px;
            right: 25px;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .badge-danger {
            background: rgba(255, 82, 82, 0.15);
            color: #ff5252;
        }

        .card-body {
            padding: 25px;
        }

        .card-footer {
            padding: 20px 25px;
            border-top: 1px solid rgba(255, 255, 255, 0.05);
            background: rgba(255, 255, 255, 0.02);
        }

        /* Quick Actions */
        .actions-grid {
            display: grid;
            gap: 15px;
        }

        .action-button {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 20px;
            background: rgba(255, 255, 255, 0.02);
            border-radius: 10px;
            border: 1px solid rgba(255, 255, 255, 0.05);
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .action-button:hover {
            background: rgba(255, 0, 0, 0.05);
            border-color: rgba(255, 0, 0, 0.2);
            transform: translateX(5px);
        }

        .action-icon {
            width: 50px;
            height: 50px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
        }

        .action-primary .action-icon {
            background: rgba(255, 0, 0, 0.15);
            color: #ff3333;
        }

        .action-secondary .action-icon {
            background: rgba(0, 200, 83, 0.15);
            color: #00c853;
        }

        .action-accent .action-icon {
            background: rgba(255, 152, 0, 0.15);
            color: #ff9800;
        }

        .action-content {
            flex: 1;
        }

        .action-title {
            color: #ffffff;
            font-weight: 600;
            font-size: 16px;
            margin-bottom: 5px;
            display: block;
        }

        .action-description {
            color: #888888;
            font-size: 13px;
            display: block;
        }

        .action-arrow {
            color: #666666;
            font-size: 14px;
        }

        /* Alerts */
        .alerts-list {
            display: grid;
            gap: 15px;
        }

        .alert-item {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 15px;
            background: rgba(255, 255, 255, 0.02);
            border-radius: 10px;
            border: 1px solid rgba(255, 255, 255, 0.05);
            transition: all 0.3s ease;
        }

        .alert-item:hover {
            background: rgba(255, 0, 0, 0.05);
            border-color: rgba(255, 0, 0, 0.2);
        }

        .alert-icon {
            width: 45px;
            height: 45px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
        }

        .alert-high {
            background: rgba(255, 82, 82, 0.15);
            color: #ff5252;
        }

        .alert-medium {
            background: rgba(255, 152, 0, 0.15);
            color: #ff9800;
        }

        .alert-low {
            background: rgba(255, 193, 7, 0.15);
            color: #ffc107;
        }

        .alert-content {
            flex: 1;
        }

        .alert-title {
            color: #ffffff;
            font-weight: 600;
            font-size: 15px;
            margin-bottom: 3px;
        }

        .alert-subtitle {
            color: #888888;
            font-size: 13px;
            margin-bottom: 5px;
        }

        .alert-meta {
            display: flex;
            gap: 15px;
            font-size: 12px;
            color: #666666;
        }

        .alert-meta i {
            margin-right: 5px;
        }

        .btn-icon {
            background: none;
            border: none;
            color: #888888;
            font-size: 16px;
            cursor: pointer;
            padding: 5px;
            border-radius: 5px;
            transition: all 0.3s ease;
        }

        .btn-icon:hover {
            color: #ffffff;
            background: rgba(255, 255, 255, 0.05);
        }

        .empty-state {
            text-align: center;
            padding: 40px 20px;
        }

        .empty-icon {
            font-size: 48px;
            color: #00c853;
            margin-bottom: 15px;
        }

        .empty-content h4 {
            color: #ffffff;
            margin-bottom: 5px;
        }

        .empty-content p {
            color: #888888;
        }

        .view-all-link {
            color: #ff3333;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }

        .view-all-link:hover {
            color: #ff6666;
            gap: 12px;
        }

        /* Stats */
        .stats-list {
            display: grid;
            gap: 20px;
        }

        .stat-item {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 20px;
            background: rgba(255, 255, 255, 0.02);
            border-radius: 10px;
            border: 1px solid rgba(255, 255, 255, 0.05);
        }

        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
        }

        .stat-icon.success {
            background: rgba(0, 200, 83, 0.15);
            color: #00c853;
        }

        .stat-icon.info {
            background: rgba(33, 150, 243, 0.15);
            color: #2196F3;
        }

        .stat-icon.accent {
            background: rgba(255, 152, 0, 0.15);
            color: #ff9800;
        }

        .stat-icon.warning {
            background: rgba(255, 193, 7, 0.15);
            color: #ffc107;
        }

        .stat-content {
            flex: 1;
        }

        .stat-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .stat-title {
            color: #ffffff;
            font-weight: 500;
            font-size: 15px;
        }

        .stat-change {
            font-size: 12px;
            font-weight: 600;
            padding: 2px 8px;
            border-radius: 12px;
        }

        .stat-change.positive {
            background: rgba(0, 200, 83, 0.15);
            color: #00c853;
        }

        .stat-change.negative {
            background: rgba(255, 82, 82, 0.15);
            color: #ff5252;
        }

        .stat-value {
            font-size: 28px;
            font-weight: 700;
            color: #ffffff;
            margin-bottom: 10px;
        }

        .stat-progress {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .stat-progress .progress-bar {
            flex: 1;
        }

        .progress-label {
            color: #888888;
            font-size: 12px;
            min-width: 80px;
            text-align: right;
        }

        /* System Status */
        .system-status {
            display: grid;
            gap: 15px;
        }

        .status-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px;
            background: rgba(255, 255, 255, 0.02);
            border-radius: 10px;
            border: 1px solid rgba(255, 255, 255, 0.05);
        }

        .status-label {
            color: #888888;
            font-size: 14px;
        }

        .status-value {
            color: #ffffff;
            font-weight: 500;
            font-size: 14px;
        }

        .status-value.online {
            color: #00c853;
        }

        .status-indicator {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 500;
        }

        .status-indicator.online {
            background: rgba(0, 200, 83, 0.15);
            color: #00c853;
        }

        .status-indicator i {
            font-size: 8px;
        }

        /* Footer */
        .dashboard-footer {
            background: rgba(15, 15, 15, 0.95);
            border-radius: 12px;
            padding: 20px 30px;
            border: 1px solid rgba(255, 255, 255, 0.05);
        }

        .footer-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .copyright, .version, .update-status {
            color: #888888;
            font-size: 13px;
        }

        .update-status {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .header-top {
                flex-direction: column;
                gap: 20px;
                text-align: center;
            }

            .brand {
                justify-content: center;
            }

            .metrics-grid {
                grid-template-columns: 1fr;
            }

            .section-header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }

            .page-header {
                flex-direction: column;
                gap: 20px;
                text-align: center;
            }

            .footer-content {
                flex-direction: column;
                gap: 10px;
                text-align: center;
            }

            .main-nav {
                flex-wrap: wrap;
                justify-content: center;
            }

            .nav-link {
                padding: 10px 15px;
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

        .metric-card, .card {
            animation: fadeIn 0.5s ease-out;
        }
    </style>
</head>
<body>
<div class="container">
    <!-- Header -->
    <header class="header">
        <div class="header-top">
            <div class="brand">
                <div class="brand-logo">
                    <i class="fas fa-chart-network"></i>
                </div>
                <div class="brand-text">
                    <h1 class="brand-title">Restaurant Supply Chain Optimizer</h1>
                    <p class="brand-subtitle">Système de gestion optimisée</p>
                </div>
            </div>
        </div>

        <nav class="main-nav">
            <a href="dashboard" class="nav-link active">
                <div class="nav-icon">
                    <i class="fas fa-tachometer-alt"></i>
                </div>
                <span class="nav-text">Dashboard</span>
            </a>

            <a href="ingredients" class="nav-link">
                <div class="nav-icon">
                    <i class="fas fa-carrot"></i>
                </div>
                <span class="nav-text">Ingrédients</span>
            </a>

            <a href="restaurants" class="nav-link">
                <div class="nav-icon">
                    <i class="fas fa-store"></i>
                </div>
                <span class="nav-text">Restaurants</span>
            </a>

            <a href="stock" class="nav-link">
                <div class="nav-icon">
                    <i class="fas fa-boxes"></i>
                </div>
                <span class="nav-text">Stocks</span>
            </a>

            <a href="waste" class="nav-link">
                <div class="nav-icon">
                    <i class="fas fa-chart-pie"></i>
                </div>
                <span class="nav-text">Analytics</span>
            </a>
        </nav>
    </header>

    <!-- Dashboard Content -->
    <main class="dashboard-content">
        <!-- Page Header -->
        <div class="page-header">
            <div class="page-title">
                <h2><i class="fas fa-tachometer-alt"></i> Tableau de Bord</h2>
                <p class="page-subtitle">Surveillance en temps réel de votre chaîne d'approvisionnement</p>
            </div>
            <div class="page-actions">
                <button class="btn btn-refresh">
                    <i class="fas fa-sync-alt"></i>
                    Actualiser
                </button>

            </div>
        </div>

        <!-- Key Metrics -->
        <div class="metrics-section">
            <div class="section-header">
                <h3 class="section-title">Aperçu des Performances</h3>

            </div>

            <div class="metrics-grid">
                <div class="metric-card metric-card-primary">
                    <div class="metric-header">
                        <div class="metric-icon">
                            <i class="fas fa-carrot"></i>
                        </div>
                        <div class="metric-trend positive">
                            <i class="fas fa-arrow-up"></i> 12.5%
                        </div>
                    </div>
                    <div class="metric-body">
                        <div class="metric-value">${ingredientsCount}</div>
                        <div class="metric-label">Ingrédients Actifs</div>

                    </div>
                    <div class="metric-footer">
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: 85%"></div>
                        </div>
                    </div>
                </div>

                <div class="metric-card metric-card-secondary">
                    <div class="metric-header">
                        <div class="metric-icon">
                            <i class="fas fa-store"></i>
                        </div>
                        <div class="metric-trend positive">
                            <i class="fas fa-arrow-up"></i> 5.2%
                        </div>
                    </div>
                    <div class="metric-body">
                        <div class="metric-value">${restaurantsCount}</div>
                        <div class="metric-label">Restaurants Gérés</div>

                    </div>
                    <div class="metric-footer">
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: 92%"></div>
                        </div>
                    </div>
                </div>

                <div class="metric-card metric-card-warning">
                    <div class="metric-header">
                        <div class="metric-icon">
                            <i class="fas fa-exclamation-triangle"></i>
                        </div>
                        <div class="metric-trend negative">
                            <i class="fas fa-arrow-down"></i> 8.3%
                        </div>
                    </div>
                    <div class="metric-body">
                        <div class="metric-value">${expiringSoonCount}</div>
                        <div class="metric-label">Alertes Expiration</div>

                    </div>
                    <div class="metric-footer">
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: 65%"></div>
                        </div>
                    </div>
                </div>

                <div class="metric-card metric-card-danger">
                    <div class="metric-header">
                        <div class="metric-icon">
                            <i class="fas fa-euro-sign"></i>
                        </div>
                        <div class="metric-trend negative">
                            <i class="fas fa-arrow-up"></i> 3.7%
                        </div>
                    </div>
                    <div class="metric-body">
                        <div class="metric-value">
                            <fmt:formatNumber value="${totalWasteCost}" type="currency" currencyCode="EUR" maxFractionDigits="0"/>
                        </div>
                        <div class="metric-label">Pertes Hebdomadaires</div>

                    </div>
                    <div class="metric-footer">
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: 45%"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Two Column Content -->
        <div class="content-grid">
            <!-- Left Column -->
            <div class="content-column">
                <!-- Quick Actions -->
                <div class="card quick-actions-card">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-bolt"></i>
                            Actions Rapides
                        </h3>
                        <span class="card-subtitle">Accès direct aux fonctions principales</span>
                    </div>
                    <div class="card-body">
                        <div class="actions-grid">
                            <a href="ingredients?action=add" class="action-button action-primary">
                                <div class="action-icon">
                                    <i class="fas fa-plus-circle"></i>
                                </div>
                                <div class="action-content">
                                    <span class="action-title">Nouvel Ingrédient</span>
                                    <span class="action-description">Ajouter un nouvel ingrédient au catalogue</span>
                                </div>
                                <div class="action-arrow">
                                    <i class="fas fa-chevron-right"></i>
                                </div>
                            </a>

                            <a href="restaurants" class="action-button action-secondary">
                                <div class="action-icon">
                                    <i class="fas fa-store-alt"></i>
                                </div>
                                <div class="action-content">
                                    <span class="action-title">Gérer Restaurants</span>
                                    <span class="action-description">Gérer les informations des restaurants</span>
                                </div>
                                <div class="action-arrow">
                                    <i class="fas fa-chevron-right"></i>
                                </div>
                            </a>

                            <a href="stock" class="action-button action-accent">
                                <div class="action-icon">
                                    <i class="fas fa-box-open"></i>
                                </div>
                                <div class="action-content">
                                    <span class="action-title">Contrôle Stock</span>
                                    <span class="action-description">Surveiller et ajuster les niveaux de stock</span>
                                </div>
                                <div class="action-arrow">
                                    <i class="fas fa-chevron-right"></i>
                                </div>
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Recent Alerts -->
                <div class="card alerts-card">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-bell"></i>
                            Alertes Récentes
                        </h3>
                        <div class="card-badge badge-danger">${expiringSoonCount}</div>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty expiringSoonDetails}">
                                <div class="alerts-list">
                                    <c:forEach var="stock" items="${expiringSoonDetails}" varStatus="status" end="4">
                                        <div class="alert-item">
                                            <div class="alert-icon ${status.index % 3 == 0 ? 'alert-high' : status.index % 3 == 1 ? 'alert-medium' : 'alert-low'}">
                                                <i class="fas fa-clock"></i>
                                            </div>
                                            <div class="alert-content">
                                                <div class="alert-title">${stock.ingredient.name}</div>
                                                <div class="alert-subtitle">${stock.restaurant.name}</div>
                                                <div class="alert-meta">
                                                    <span class="alert-date">
                                                        <i class="far fa-calendar"></i>
                                                        <fmt:formatDate value="${stock.expirationDate}" pattern="dd/MM/yyyy"/>
                                                    </span>
                                                    <span class="alert-quantity">
                                                        <i class="fas fa-weight"></i>
                                                        ${stock.quantity} ${stock.ingredient.unit}
                                                    </span>
                                                </div>
                                            </div>
                                            <div class="alert-actions">
                                                <button class="btn-icon">
                                                    <i class="fas fa-ellipsis-v"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <div class="empty-icon">
                                        <i class="fas fa-check-circle"></i>
                                    </div>
                                    <div class="empty-content">
                                        <h4>Aucune alerte active</h4>
                                        <p>Tous les stocks sont à jour</p>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="card-footer">
                        <a href="#" class="view-all-link">
                            Voir toutes les alertes
                            <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>
                </div>
            </div>

            <!-- Right Column -->
            <div class="content-column">
                <!-- Performance Stats -->
                <div class="card stats-card">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-chart-line"></i>
                            Statistiques de Performance
                        </h3>
                        <span class="card-subtitle">Indicateurs clés de performance</span>
                    </div>
                    <div class="card-body">
                        <div class="stats-list">
                            <div class="stat-item">
                                <div class="stat-icon success">
                                    <i class="fas fa-coins"></i>
                                </div>
                                <div class="stat-content">
                                    <div class="stat-header">
                                        <span class="stat-title">Valeur Stock Total</span>
                                        <span class="stat-change positive">
                                            <i class="fas fa-arrow-up"></i> 8.2%
                                        </span>
                                    </div>
                                    <div class="stat-value">
                                        <fmt:formatNumber value="${stockValue}" type="currency" currencyCode="EUR"/>
                                    </div>
                                    <div class="stat-progress">
                                        <div class="progress-bar">
                                            <div class="progress-fill" style="width: 75%"></div>
                                        </div>
                                        <span class="progress-label">75% capacité</span>
                                    </div>
                                </div>
                            </div>

                            <div class="stat-item">
                                <div class="stat-icon info">
                                    <i class="fas fa-chart-pie"></i>
                                </div>
                                <div class="stat-content">
                                    <div class="stat-header">
                                        <span class="stat-title">Réduction Pertes</span>
                                        <span class="stat-change positive">
                                            <i class="fas fa-arrow-up"></i> 15.3%
                                        </span>
                                    </div>
                                    <div class="stat-value">${wasteReduction}%</div>
                                    <div class="stat-progress">
                                        <div class="progress-bar">
                                            <div class="progress-fill" style="width: ${wasteReduction}%"></div>
                                        </div>
                                        <span class="progress-label">Objectif: 90%</span>
                                    </div>
                                </div>
                            </div>

                            <div class="stat-item">
                                <div class="stat-icon accent">
                                    <i class="fas fa-brain"></i>
                                </div>
                                <div class="stat-content">
                                    <div class="stat-header">
                                        <span class="stat-title">Précision Prédictive</span>
                                        <span class="stat-change positive">
                                            <i class="fas fa-arrow-up"></i> 4.1%
                                        </span>
                                    </div>
                                    <div class="stat-value">${predictionAccuracy}%</div>
                                    <div class="stat-progress">
                                        <div class="progress-bar">
                                            <div class="progress-fill" style="width: ${predictionAccuracy}%"></div>
                                        </div>
                                        <span class="progress-label">IA performance</span>
                                    </div>
                                </div>
                            </div>

                            <div class="stat-item">
                                <div class="stat-icon warning">
                                    <i class="fas fa-sync-alt"></i>
                                </div>
                                <div class="stat-content">
                                    <div class="stat-header">
                                        <span class="stat-title">Rotation Stocks</span>
                                        <span class="stat-change negative">
                                            <i class="fas fa-arrow-down"></i> 2.8%
                                        </span>
                                    </div>
                                    <div class="stat-value">${inventoryTurnover}</div>
                                    <div class="stat-progress">
                                        <div class="progress-bar">
                                            <div class="progress-fill" style="width: 68%"></div>
                                        </div>
                                        <span class="progress-label">Moyenne mensuelle</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- System Status -->
                <div class="card status-card">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-server"></i>
                            État du Système
                        </h3>
                        <div class="status-indicator online">
                            <i class="fas fa-circle"></i>
                            En ligne
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="system-status">
                            <div class="status-item">
                                <div class="status-label">API Services</div>
                                <div class="status-value online">Opérationnel</div>
                            </div>
                            <div class="status-item">
                                <div class="status-label">Base de données</div>
                                <div class="status-value online">Connectée</div>
                            </div>
                            <div class="status-item">
                                <div class="status-label">Temps réponse</div>
                                <div class="status-value">124ms</div>
                            </div>
                            <div class="status-item">
                                <div class="status-label">Mise à jour</div>
                                <div class="status-value">Il y a 5 min</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="dashboard-footer">
        <div class="footer-content">
            <div class="footer-left">
                <span class="copyright">© 2024 Restaurant Supply Chain Optimizer. Tous droits réservés.</span>
            </div>
            <div class="footer-right">
                <span class="version">Version 2.1.4</span>
                <span class="update-status">
                    <i class="fas fa-cloud"></i>
                    Synchronisé il y a 2 min
                </span>
            </div>
        </div>
    </footer>
</div>

<script>
    // Refresh button functionality
    document.querySelector('.btn-refresh').addEventListener('click', function() {
        this.classList.add('refreshing');
        setTimeout(() => {
            location.reload();
        }, 1000);
    });
</script>
</body>
</html>