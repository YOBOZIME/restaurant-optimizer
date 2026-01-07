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
    public Response updateStock(@PathParam("id") Long id, @Valid RestaurantStock updatedStock) {
        try {
            RestaurantStock existing = stockService.getStockById(id);
            if (existing == null) {
                return Response.status(Response.Status.NOT_FOUND).build();
            }

            // Update fields
            existing.setQuantity(updatedStock.getQuantity());
            existing.setExpirationDate(updatedStock.getExpirationDate());
            existing.setBatchNumber(updatedStock.getBatchNumber());

            stockService.updateStock(existing);
            return Response.ok(existing).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("Error updating stock: " + e.getMessage())
                    .build();
        }
    }

    @DELETE
    @Path("/{id}")
    public Response deleteStock(@PathParam("id") Long id) {
        stockService.deleteStock(id);
        return Response.noContent().build();
    }

    @POST
    @Path("/adjust/{id}")
    public Response adjustQuantity(@PathParam("id") Long id,
                                   @QueryParam("delta") Double delta) {
        try {
            RestaurantStock stock = stockService.getStockById(id);
            if (stock == null) {
                return Response.status(Response.Status.NOT_FOUND).build();
            }

            Double newQuantity = stock.getQuantity() + delta;
            if (newQuantity < 0) {
                return Response.status(Response.Status.BAD_REQUEST)
                        .entity("La quantité ne peut pas être négative")
                        .build();
            }

            stock.setQuantity(newQuantity);
            stockService.updateStock(stock);

            return Response.ok(Map.of(
                    "id", stock.getId(),
                    "newQuantity", newQuantity,
                    "message", "Quantité mise à jour"
            )).build();

        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("Erreur: " + e.getMessage())
                    .build();
        }
    }

    @GET
    @Path("/restaurants")
    public Response getAllRestaurantsForStock() {
        // Vous devrez injecter RestaurantService dans StockResource
        // List<Restaurant> restaurants = restaurantService.getAllRestaurants();
        // return Response.ok(restaurants).build();

        // Pour l'instant, retourner une liste vide
        return Response.ok(List.of()).build();
    }

    @GET
    @Path("/restaurants/list")
    public Response getRestaurantsForStock() {
        try {
            List<Restaurant> restaurants = restaurantService.getAllRestaurants();
            return Response.ok(restaurants).build();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting restaurants", e);
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"Erreur serveur: " + e.getMessage() + "\"}")
                    .build();
        }
    }

    @GET
    @Path("/ingredients")
    public Response getAllIngredientsForStock() {
        // Vous devrez injecter InventoryService dans StockResource
        // List<Ingredient> ingredients = InventoryService.getAllIngredients();
        // return Response.ok(ingredients).build();

        // Pour l'instant, retourner une liste vide
        return Response.ok(List.of()).build();
    }

    // In StockResource class, add these endpoints:
    @GET
    @Path("/restaurants")
    public Response getAllRestaurants() {
        try {
            // You need to inject RestaurantService or use inventoryService
            // For now, return a simple response
            return Response.ok()
                    .entity("{\"message\": \"Please implement this endpoint\"}")
                    .build();
        } catch (Exception e) {
            return Response.serverError()
                    .entity("{\"error\": \"" + e.getMessage() + "\"}")
                    .build();
        }
    }

    // Add these endpoints to StockResource.java

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
    @Path("/search")
    public Response searchStock(
            @QueryParam("restaurantId") Long restaurantId,
            @QueryParam("ingredientId") Long ingredientId,
            @QueryParam("expirationFrom") String expirationFrom,
            @QueryParam("expirationTo") String expirationTo,
            @QueryParam("minQuantity") String minQuantityStr,
            @QueryParam("maxQuantity") String maxQuantityStr,
            @QueryParam("category") String category) {

        try {
            LOGGER.info("=== StockResource.searchStock() ===");
            LOGGER.info("Request parameters:");
            LOGGER.info("  restaurantId: " + restaurantId);
            LOGGER.info("  ingredientId: " + ingredientId);
            LOGGER.info("  expirationFrom: " + expirationFrom);
            LOGGER.info("  expirationTo: " + expirationTo);
            LOGGER.info("  minQuantity: " + minQuantityStr);
            LOGGER.info("  maxQuantity: " + maxQuantityStr);
            LOGGER.info("  category: " + category);

            // Use the method that handles String quantity parameters
            List<RestaurantStock> filteredStock = stockService.searchStockWithStringParams(
                    restaurantId, ingredientId, expirationFrom, expirationTo,
                    minQuantityStr, maxQuantityStr, category);

            LOGGER.info("Found " + filteredStock.size() + " items");
            return Response.ok(filteredStock).build();

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error searching stock", e);
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"Erreur lors de la recherche: " +
                            e.getMessage().replace("\"", "\\\"") + "\"}")
                    .build();
        }
    }

    @GET
    @Path("/ingredients/list")
    public Response getIngredientsForStock() {
        try {
            List<Ingredient> ingredients = inventoryService.getAllIngredients();
            return Response.ok(ingredients).build();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting ingredients", e);
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"Erreur serveur: " + e.getMessage() + "\"}")
                    .build();
        }
    }

    @GET
    @Path("/ingredients")
    public Response getAllIngredients() {
        try {
            // You need to inject InventoryService or similar
            // For now, return a simple response
            return Response.ok()
                    .entity("{\"message\": \"Please implement this endpoint\"}")
                    .build();
        } catch (Exception e) {
            return Response.serverError()
                    .entity("{\"error\": \"" + e.getMessage() + "\"}")
                    .build();
        }
    }


    @GET
    @Path("/analytics")
    public Response getAnalytics() {
        // You'll need to add getAnalytics() method to StockService
        Map<String, Object> analytics = stockService.getStockAnalytics();
        return Response.ok(analytics).build();
    }

    @GET
    @Path("/value")
    public Response getTotalStockValue() {
        Double totalValue = stockService.calculateTotalStockValue();
        return Response.ok().entity(Map.of("totalValue", totalValue)).build();
    }

    // Create a utility class or add this method to StockResource:

    private Double parseQuantity(String quantityStr) {
        if (quantityStr == null || quantityStr.trim().isEmpty()) {
            return null;
        }
        try {
            // Handle both comma and dot decimal separators
            quantityStr = quantityStr.replace(',', '.');
            return Double.parseDouble(quantityStr);
        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid quantity format: " + quantityStr);
            return null;
        }
    }

}