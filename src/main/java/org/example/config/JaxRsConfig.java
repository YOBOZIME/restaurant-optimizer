package org.example.config;

import jakarta.ws.rs.ApplicationPath;
import jakarta.ws.rs.core.Application;
import java.util.Set;

@ApplicationPath("/api")
public class JaxRsConfig extends Application {
    // Vide = scan automatique de tous les @Path
}