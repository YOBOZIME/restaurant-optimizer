package org.example.rest;

import org.example.entity.waste.WasteLog;
import org.example.service.core.WasteService;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.util.Date;
import java.util.List;

@Path("/waste")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class WasteResource {

    @Inject
    private WasteService wasteService;

    @GET
    public List<WasteLog> getAll() {
        return wasteService.getAllWasteLogs();
    }

    @GET
    @Path("/restaurant/{id}")
    public List<WasteLog> getByRestaurant(@PathParam("id") Long restaurantId) {
        return wasteService.getWasteLogsByRestaurant(restaurantId);
    }

    @GET
    @Path("/reason/{reason}")
    public List<WasteLog> getByReason(@PathParam("reason") String reason) {
        return wasteService.getWasteLogsByReason(reason);
    }

    @POST
    public Response logWaste(WasteLog wasteLog) {
        if (wasteLog.getDate() == null) {
            wasteLog.setDate(new Date());
        }
        wasteService.addWasteLog(wasteLog);
        return Response.status(Response.Status.CREATED).entity(wasteLog).build();
    }
}