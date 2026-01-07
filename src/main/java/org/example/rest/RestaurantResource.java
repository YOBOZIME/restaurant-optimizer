package org.example.rest;

import org.example.entity.core.Restaurant;
import org.example.service.core.RestaurantService;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.List;

@Path("/restaurants")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class RestaurantResource {

    @Inject
    private RestaurantService restaurantService;

    @GET
    public List<Restaurant> getAll() {
        return restaurantService.getAllRestaurants();
    }

    @GET
    @Path("/{id}")
    public Response getById(@PathParam("id") Long id) {
        Restaurant restaurant = restaurantService.getRestaurantById(id);
        if (restaurant == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity("Restaurant not found with id: " + id)
                    .build();
        }
        return Response.ok(restaurant).build();
    }

    @POST
    public Response add(@Valid Restaurant restaurant) {
        restaurantService.addRestaurant(restaurant);
        return Response.status(Response.Status.CREATED).entity(restaurant).build();
    }

    @PUT
    @Path("/{id}")
    public Response update(@PathParam("id") Long id, @Valid Restaurant updatedRestaurant) {
        try {
            restaurantService.updateRestaurant(id, updatedRestaurant);
            Restaurant updated = restaurantService.getRestaurantById(id);
            return Response.ok(updated).build();
        } catch (IllegalArgumentException e) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(e.getMessage())
                    .build();
        }
    }

    @DELETE
    @Path("/{id}")
    public Response delete(@PathParam("id") Long id) {
        try {
            restaurantService.deleteRestaurant(id);
            return Response.noContent().build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("Error deleting restaurant: " + e.getMessage())
                    .build();
        }
    }

    @GET
    @Path("/city/{city}")
    public List<Restaurant> getByCity(@PathParam("city") String city) {
        return restaurantService.getRestaurantsByCity(city);
    }
}