package com.ariniqo.controller;

import com.ariniqo.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/admin/pets/add")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024)
public class AdminAddPetServlet extends HttpServlet {

    // ✅ change this if you want a specific folder
    private static final String UPLOAD_BASE_DIR =
            System.getProperty("user.home") + File.separator + "AnimalAdoptionSystem" + File.separator + "uploads";

    private String safe(String s) { return (s == null) ? "" : s.trim(); }

    private String getSubmittedFileNameSafe(Part part) {
        if (part == null) return null;

        try {
            String fn = part.getSubmittedFileName();
            if (fn != null) return fn;
        } catch (Throwable ignore) { }

        String cd = part.getHeader("content-disposition");
        if (cd == null) return null;

        String[] tokens = cd.split(";");
        for (int i = 0; i < tokens.length; i++) {
            String t = tokens[i].trim();
            if (t.startsWith("filename")) {
                String fileName = t.substring(t.indexOf('=') + 1).trim().replace("\"", "");
                return fileName;
            }
        }
        return null;
    }

    private String saveUpload(Part part) throws IOException {
        if (part == null || part.getSize() == 0) return null;

        String submitted = getSubmittedFileNameSafe(part);
        if (submitted == null || submitted.trim().length() == 0) submitted = "photo.jpg";

        String clean = submitted.replaceAll("[^a-zA-Z0-9._-]", "_");
        String fileName = System.currentTimeMillis() + "_" + clean;

        File baseDir = new File(UPLOAD_BASE_DIR);
        if (!baseDir.exists()) baseDir.mkdirs();

        File dest = new File(baseDir, fileName);

        InputStream in = null;
        OutputStream out = null;
        try {
            in = part.getInputStream();
            out = new FileOutputStream(dest);

            byte[] buf = new byte[8192];
            int len;
            while ((len = in.read(buf)) > 0) out.write(buf, 0, len);
        } finally {
            try { if (in != null) in.close(); } catch (Exception e) {}
            try { if (out != null) out.close(); } catch (Exception e) {}
        }

        // ✅ store a web-accessible path via a new servlet (see below)
        return "uploads/" + fileName;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = safe(request.getParameter("petName"));
        String type = safe(request.getParameter("petType"));
        String breed = safe(request.getParameter("breed"));

        String status = safe(request.getParameter("status"));
        if (status.length() == 0) status = "AVAILABLE";
        status = status.toUpperCase();

        String description = safe(request.getParameter("description"));

        int age = 0;
        try {
            String ageStr = safe(request.getParameter("age"));
            if (ageStr.length() > 0) age = (int) Double.parseDouble(ageStr);
        } catch (Exception ignore) { age = 0; }

        Part img = null;
        try { img = request.getPart("petImage"); } catch (Exception ignore) {}

        String imagePath = null;
        try {
            if (img != null && img.getSize() > 0) {
                imagePath = saveUpload(img);   // ✅ now works on GlassFish
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }

        if (name.length() == 0 || type.length() == 0) {
            response.sendRedirect(request.getContextPath() + "/admin/add-pet.jsp?error=1");
            return;
        }

        String sql = (imagePath == null)
                ? "INSERT INTO PETS (NAME, TYPE, BREED, AGE, STATUS, DESCRIPTION) VALUES (?, ?, ?, ?, ?, ?)"
                : "INSERT INTO PETS (NAME, TYPE, BREED, AGE, STATUS, DESCRIPTION, IMAGE_PATH) VALUES (?, ?, ?, ?, ?, ?, ?)";

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);

            ps.setString(1, name);
            ps.setString(2, type);
            ps.setString(3, (breed.length() == 0 ? null : breed));
            ps.setInt(4, age);
            ps.setString(5, status);
            ps.setString(6, (description.length() == 0 ? null : description));

            if (imagePath != null) ps.setString(7, imagePath);

            ps.executeUpdate();

        } catch (Exception e) {
            throw new ServletException(e);
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        response.sendRedirect(request.getContextPath() + "/admin/add-pet.jsp?added=1");

    }
}
