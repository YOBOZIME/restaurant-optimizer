package org.example.rest;

import org.example.entity.core.Supplier;
import org.example.service.core.SupplierService;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.List;

@Path("/suppliers")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class SupplierResource {

    @Inject
    private SupplierService supplierService;

    @GET
    public List<Supplier> getAll() {
        return supplierService.getAllSuppliers();
    }

    @GET
    @Path("/{id}")
    public Response getById(@PathParam("id") Long id) {
        Supplier supplier = supplierService.getSupplierById(id);
        if (supplier == null) {
            return Response.status(Response.Status.NOT_FOUND).build();
        }
        return Response.ok(supplier).build();
    }

    @POST
    public Response create(Supplier supplier) {
        supplierService.addSupplier(supplier);
        return Response.status(Response.Status.CREATED).entity(supplier).build();
    }

    @PUT
    @Path("/{id}")
    public Response update(@PathParam("id") Long id, Supplier updatedSupplier) {
        try {
            supplierService.updateSupplier(id, updatedSupplier);
            return Response.ok().build();
        } catch (IllegalArgumentException e) {
            return Response.status(Response.Status.NOT_FOUND).entity(e.getMessage()).build();
        }
    }

    @DELETE
    @Path("/{id}")
    public Response delete(@PathParam("id") Long id) {
        supplierService.deleteSupplier(id);
        return Response.noContent().build();
    }
}