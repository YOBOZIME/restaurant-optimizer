package org.example.exception;

import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.ext.ExceptionMapper;
import jakarta.ws.rs.ext.Provider;

@Provider
public class CustomExceptionMapper implements ExceptionMapper<Exception> {

    @Override
    public Response toResponse(Exception exception) {
        ErrorResponse error = new ErrorResponse(
                exception.getMessage(),
                Response.Status.INTERNAL_SERVER_ERROR.getStatusCode()
        );

        return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(error)
                .build();
    }

    public static class ErrorResponse {
        private String message;
        private int status;

        public ErrorResponse(String message, int status) {
            this.message = message;
            this.status = status;
        }
        // getters and setters
    }
}