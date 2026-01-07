package org.example.rest;

import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.logging.Logger;

@Path("/test")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class DebugResource {

    private static final Logger LOGGER = Logger.getLogger(DebugResource.class.getName());

    @POST
    @Path("/echo")
    public Response echo(String body) {
        LOGGER.info("Test endpoint appelé avec body: " + body);
        return Response.ok("{\"message\": \"Received: " + body + "\"}").build();
    }

    @POST
    @Path("/stock-test")
    public Response stockTest() {
        LOGGER.info("Test stock endpoint");
        return Response.ok("{\"success\": true, \"message\": \"Stock test endpoint works\"}").build();
    }
}