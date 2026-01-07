package org.example.rest;

import jakarta.transaction.Transactional;
import jakarta.validation.Valid;
import org.example.entity.core.Ingredient;
import org.example.entity.core.Restaurant;
import org.example.entity.inventory.RestaurantStock;
import org.example.service.core.InventoryService;
import org.example.service.core.RestaurantService;
import org.example.service.core.StockService;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import org.example.dto.StockCreateDTO;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@Path("/stock")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class StockResource {

    private static final Logger LOGGER = Logger.getLogger(StockResource.class.getName());

    @Inject
    private StockService stockService;

    @Inject
    private RestaurantService restaurantService;

    @Inject
    private InventoryService inventoryService;

    @POST
    @Transactional
    public Response addStock(StockCreateDTO stockDTO) {
        LOGGER.info("========== DÉBUT addStock ==========");
        LOGGER.info("URL appelée: POST /stock");

        try {
            // Log du DTO
            LOGGER.info("DTO complet: " + stockDTO);
            LOGGER.info("restaurantId: " + stockDTO.getRestaurantId());
            LOGGER.info("ingredientId: " + stockDTO.getIngredientId());
            LOGGER.info("quantity: " + stockDTO.getQuantity());
            LOGGER.info("expirationDate: " + stockDTO.getExpirationDate());
            LOGGER.info("batchNumber: " + stockDTO.getBatchNumber());

            // Validation
            if (stockDTO == null) {
                LOGGER.severe("ERROR: DTO est null");
                return Response.status(Response.Status.BAD_REQUEST)
                        .entity("{\"error\": \"Données manquantes\"}")
                        .build();
            }

            if (stockDTO.getRestaurantId() == null) {
                LOGGER.severe("ERROR: RestaurantId est null");
                return Response.status(Response.Status.BAD_REQUEST)
                        .entity("{\"error\": \"ID restaurant manquant\"}")
                        .build();
            }

            if (stockDTO.getIngredientId() == null) {
                LOGGER.severe("ERROR: IngredientId est null");
                return Response.status(Response.Status.BAD_REQUEST)
                        .entity("{\"error\": \"ID ingrédient manquant\"}")
                        .build();
            }

            if (stockDTO.getQuantity() == null) {
                LOGGER.severe("ERROR: Quantity est null");
                return Response.status(Response.Status.BAD_REQUEST)
                        .entity("{\"error\": \"Quantité manquante\"}")
                        .build();
            }

            if (stockDTO.getQuantity() <= 0) {
                LOGGER.severe("ERROR: Quantity <= 0: " + stockDTO.getQuantity());
                return Response.status(Response.Status.BAD_REQUEST)
                        .entity("{\"error\": \"Quantité doit être positive\"}")
                        .build();
            }

            LOGGER.info("Recherche restaurant ID: " + stockDTO.getRestaurantId());
            Restaurant restaurant = restaurantService.getRestaurantById(stockDTO.getRestaurantId());

            if (restaurant == null) {
                LOGGER.severe("ERROR: Restaurant non trouvé pour ID: " + stockDTO.getRestaurantId());
                return Response.status(Response.Status.BAD_REQUEST)
                        .entity("{\"error\": \"Restaurant non trouvé: ID " + stockDTO.getRestaurantId() + "\"}")
                        .build();
            }
            LOGGER.info("SUCCESS: Restaurant trouvé: " + restaurant.getName() + " (ID: " + restaurant.getId() + ")");

            LOGGER.info("Recherche ingrédient ID: " + stockDTO.getIngredientId());
            Ingredient ingredient = inventoryService.getIngredientById(stockDTO.getIngredientId());

            if (ingredient == null) {
                LOGGER.severe("ERROR: Ingredient non trouvé pour ID: " + stockDTO.getIngredientId());
                return Response.status(Response.Status.BAD_REQUEST)
                        .entity("{\"error\": \"Ingrédient non trouvé: ID " + stockDTO.getIngredientId() + "\"}")
                        .build();
            }
            LOGGER.info("SUCCESS: Ingredient trouvé: " + ingredient.getName() + " (ID: " + ingredient.getId() + ")");

            // Créer le stock
            LOGGER.info("Création de RestaurantStock...");
            RestaurantStock stock = new RestaurantStock();
            stock.setRestaurant(restaurant);
            stock.setIngredient(ingredient);
            stock.setQuantity(stockDTO.getQuantity());
            stock.setExpirationDate(stockDTO.getExpirationDate());
            stock.setBatchNumber(stockDTO.getBatchNumber());

            LOGGER.info("Stock créé - Vérification:");
            LOGGER.info("  restaurant ID: " + stock.getRestaurant().getId());
            LOGGER.info("  ingredient ID: " + stock.getIngredient().getId());
            LOGGER.info("  quantity: " + stock.getQuantity());
            LOGGER.info("  expirationDate: " + stock.getExpirationDate());
            LOGGER.info("  batchNumber: " + stock.getBatchNumber());

            LOGGER.info("Appel de stockService.addStock()...");
            stockService.addStock(stock);

            LOGGER.info("SUCCESS: Stock sauvegardé avec ID: " + stock.getId());
            LOGGER.info("========== FIN addStock - SUCCÈS ==========");

            return Response.status(Response.Status.CREATED)
                    .entity("{\"success\": true, \"message\": \"Stock ajouté avec succès\", \"id\": " + stock.getId() + "}")
                    .build();

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "========== ERREUR FATALE dans addStock ==========", e);
            LOGGER.severe("Message d'erreur: " + e.getMessage());
            LOGGER.severe("Type d'erreur: " + e.getClass().getName());
            LOGGER.severe("Cause: " + (e.getCause() != null ? e.getCause().getMessage() : "null"));

            // Log stack trace
            for (StackTraceElement element : e.getStackTrace()) {
                LOGGER.severe("  at " + element);
            }

            String errorMessage = e.getMessage() != null ? e.getMessage() : "Erreur inconnue";
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"success\": false, \"error\": \"" + escapeJson(errorMessage) + "\"}")
                    .build();
        }
    }

    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    @GET
    public List<RestaurantStock> getAll() {
        LOGGER.info("GET /stock - Récupération de tous les stocks");
        return stockService.getAllStock();
    }

    @GET
    @Path("/{id}")
    public Response getById(@PathParam("id") Long id) {
        LOGGER.info("GET /stock/" + id);
        RestaurantStock stock = stockService.getStockById(id);
        if (stock == null) {
            return Response.status(Response.Status.NOT_FOUND).build();
        }
        return Response.ok(stock).build();
    }

    @PUT
    @Path("/{id}")
    @Transactional
    public Response updateStock(@PathParam("id") Long id, RestaurantStock stockData) {
        try {
            LOGGER.info("PUT /stock/" + id + " - Mise à jour du stock");
            LOGGER.info("Données reçues: " + stockData);

            RestaurantStock existing = stockService.getStockById(id);
            if (existing == null) {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity("{\"error\": \"Stock non trouvé avec l'ID: " + id + "\"}")
                        .build();
            }

            // Update only allowed fields
            if (stockData.getQuantity() != null) {
                existing.setQuantity(stockData.getQuantity());
            }
            if (stockData.getExpirationDate() != null) {
                existing.setExpirationDate(stockData.getExpirationDate());
            }
            if (stockData.getBatchNumber() != null) {
                existing.setBatchNumber(stockData.getBatchNumber());
            }

            stockService.updateStock(existing);

            return Response.ok()
                    .entity("{\"success\": true, \"message\": \"Stock mis à jour avec succès\"}")
                    .build();

        } catch (Exception e) {
            LOGGER.severe("Erreur lors de la mise à jour du stock ID " + id + ": " + e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"" + escapeJson(e.getMessage()) + "\"}")
                    .build();
        }
    }

    @DELETE
    @Path("/{id}")
    public Response deleteStock(@PathParam("id") Long id) {
        try {
            LOGGER.info("DELETE /stock/" + id + " - Suppression du stock");
            stockService.deleteStock(id);
            return Response.ok()
                    .entity("{\"success\": true, \"message\": \"Stock supprimé avec succès\"}")
                    .build();
        } catch (Exception e) {
            LOGGER.severe("Erreur lors de la suppression du stock ID " + id + ": " + e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"success\": false, \"error\": \"" + escapeJson(e.getMessage()) + "\"}")
                    .build();
        }
    }

    @GET
    @Path("/summary")
    public Response getStockSummary() {
        try {
            Map<String, Object> summary = stockService.getStockSummary();
            return Response.ok(summary).build();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting summary", e);
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"Erreur serveur: " + e.getMessage() + "\"}")
                    .build();
        }
    }

    @GET
    @Path("/categories")
    public Response getUniqueCategories() {
        try {
            List<String> categories = stockService.getUniqueCategories();
            return Response.ok(categories).build();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting categories", e);
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"Erreur serveur: " + e.getMessage() + "\"}")
                    .build();
        }
    }

    @GET
    @Path("/analytics")
    public Response getAnalytics() {
        Map<String, Object> analytics = stockService.getStockAnalytics();
        return Response.ok(analytics).build();
    }

    @GET
    @Path("/value")
    public Response getTotalStockValue() {
        Double totalValue = stockService.calculateTotalStockValue();
        return Response.ok().entity(Map.of("totalValue", totalValue)).build();
    }
}