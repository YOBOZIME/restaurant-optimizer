package org.example.util;

import java.lang.reflect.Field;
import java.util.*;
import java.text.SimpleDateFormat;

public class JsonConverter {

    private static final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

    public static String toJson(Object obj) {
        if (obj == null) {
            return "null";
        }

        if (obj instanceof Map) {
            return mapToJson((Map<?, ?>) obj);
        } else if (obj instanceof List) {
            return listToJson((List<?>) obj);
        } else if (obj instanceof String) {
            return "\"" + escapeJson((String) obj) + "\"";
        } else if (obj instanceof Number || obj instanceof Boolean) {
            return obj.toString();
        } else if (obj instanceof Date) {
            return "\"" + dateFormat.format((Date) obj) + "\"";
        } else {
            return objectToJson(obj);
        }
    }

    private static String mapToJson(Map<?, ?> map) {
        StringBuilder sb = new StringBuilder("{");
        boolean first = true;

        for (Map.Entry<?, ?> entry : map.entrySet()) {
            if (!first) {
                sb.append(",");
            }
            first = false;

            sb.append("\"")
                    .append(escapeJson(entry.getKey().toString()))
                    .append("\":")
                    .append(toJson(entry.getValue()));
        }

        sb.append("}");
        return sb.toString();
    }

    private static String listToJson(List<?> list) {
        StringBuilder sb = new StringBuilder("[");
        boolean first = true;

        for (Object item : list) {
            if (!first) {
                sb.append(",");
            }
            first = false;

            sb.append(toJson(item));
        }

        sb.append("]");
        return sb.toString();
    }

    private static String objectToJson(Object obj) {
        try {
            StringBuilder sb = new StringBuilder("{");
            Field[] fields = obj.getClass().getDeclaredFields();
            boolean first = true;

            for (Field field : fields) {
                field.setAccessible(true);
                Object value = field.get(obj);

                if (value != null) {
                    if (!first) {
                        sb.append(",");
                    }
                    first = false;

                    sb.append("\"")
                            .append(field.getName())
                            .append("\":")
                            .append(toJson(value));
                }
            }

            sb.append("}");
            return sb.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return "{}";
        }
    }

    private static String escapeJson(String str) {
        if (str == null) return "";

        return str.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t")
                .replace("\b", "\\b")
                .replace("\f", "\\f");
    }
}