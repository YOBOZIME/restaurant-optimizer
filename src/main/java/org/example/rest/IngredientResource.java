package org.example.rest;

import org.example.entity.core.Ingredient;
import org.example.service.core.InventoryService;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.List;

@Path("/ingredients")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class IngredientResource {

    @Inject
    private InventoryService inventoryService;

    @GET
    public List<Ingredient> getAll() {
        return inventoryService.getAllIngredients();
    }

    @GET
    @Path("/{id}")
    public Response getById(@PathParam("id") Long id) {
        Ingredient ingredient = inventoryService.getIngredientById(id);
        if (ingredient == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity("Ingredient not found with id: " + id)
                    .build();
        }
        return Response.ok(ingredient).build();
    }

    @POST
    public Response create(@Valid Ingredient ingredient) {
        try {
            inventoryService.addIngredient(ingredient);
            return Response.status(Response.Status.CREATED).entity(ingredient).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("Error creating ingredient: " + e.getMessage())
                    .build();
        }
    }

    @PUT
    @Path("/{id}")
    public Response update(@PathParam("id") Long id, @Valid Ingredient updatedIngredient) {
        try {
            inventoryService.updateIngredient(id, updatedIngredient);
            return Response.ok().entity("Ingredient updated successfully").build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("Error updating ingredient: " + e.getMessage())
                    .build();
        }
    }

    @DELETE
    @Path("/{id}")
    public Response delete(@PathParam("id") Long id) {
        try {
            inventoryService.deleteIngredient(id);
            return Response.noContent().build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("Error deleting ingredient: " + e.getMessage())
                    .build();
        }
    }

    // Optional: Search endpoint
    @GET
    @Path("/search")
    public Response search(
            @QueryParam("name") String name,
            @QueryParam("category") String category) {

        List<Ingredient> results = inventoryService.searchIngredients(name, category);
        return Response.ok(results).build();
    }
}