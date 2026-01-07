package org.example.rest;

import org.example.entity.core.MenuItem;
import org.example.service.core.MenuService;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.List;

@Path("/menu-items")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class MenuItemResource {

    @Inject
    private MenuService menuService;

    @GET
    public List<MenuItem> getAll() {
        return menuService.getAllMenuItems();
    }

    @GET
    @Path("/{id}")
    public Response getById(@PathParam("id") Long id) {
        MenuItem menuItem = menuService.getMenuItemById(id);
        if (menuItem == null) {
            return Response.status(Response.Status.NOT_FOUND).build();
        }
        return Response.ok(menuItem).build();
    }

    @POST
    public Response create(@Valid MenuItem menuItem) {
        menuService.saveMenuItem(menuItem);
        return Response.status(Response.Status.CREATED).entity(menuItem).build();
    }

    @PUT
    @Path("/{id}")
    public Response update(@PathParam("id") Long id, @Valid MenuItem updatedItem) {
        MenuItem existing = menuService.getMenuItemById(id);
        if (existing == null) {
            return Response.status(Response.Status.NOT_FOUND).build();
        }

        // Update fields
        existing.setName(updatedItem.getName());
        existing.setDescription(updatedItem.getDescription());
        existing.setCategory(updatedItem.getCategory());
        existing.setSellingPrice(updatedItem.getSellingPrice());
        existing.setPreparationTime(updatedItem.getPreparationTime());

        // Only update recipe items if provided
        if (updatedItem.getRecipeItems() != null && !updatedItem.getRecipeItems().isEmpty()) {
            existing.getRecipeItems().clear();
            existing.getRecipeItems().addAll(updatedItem.getRecipeItems());
            // Set back-reference
            existing.getRecipeItems().forEach(ri -> ri.setMenuItem(existing));
        }

        menuService.saveMenuItem(existing);
        return Response.ok(existing).build();
    }

    @DELETE
    @Path("/{id}")
    public Response delete(@PathParam("id") Long id) {
        menuService.deleteMenuItem(id);
        return Response.noContent().build();
    }

    @GET
    @Path("/restaurant/{restaurantId}")
    public List<MenuItem> getByRestaurant(@PathParam("restaurantId") Long restaurantId) {
        return menuService.getMenuItemsByRestaurant(restaurantId);
    }

    @GET
    @Path("/most-profitable")
    public List<MenuItem> getMostProfitable(@QueryParam("limit") @DefaultValue("10") int limit) {
        return menuService.getMostProfitableItems(limit);
    }

    @GET
    @Path("/needing-optimization")
    public List<MenuItem> getNeedingOptimization() {
        return menuService.getItemsNeedingOptimization();
    }
}