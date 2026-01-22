package com.ariniqo.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;

@WebServlet("/file")
public class UploadViewServlet extends HttpServlet {

    // ✅ SAME folder style as AddPet
    private static final String UPLOAD_BASE_DIR =
            System.getProperty("user.home") + File.separator + "AnimalAdoptionSystem" + File.separator + "uploads";

    private String pickFileName(HttpServletRequest req) {
        String name = req.getParameter("name");
        String path = req.getParameter("path");

        String v = (name != null && name.trim().length() > 0) ? name.trim()
                : (path != null ? path.trim() : "");

        if (v.length() == 0) return null;

        v = v.replace("\\", "/");
        if (v.indexOf("..") >= 0) return null;

        // allow "uploads/xxx.jpg" or "/uploads/xxx.jpg" or "xxx.jpg"
        if (v.startsWith("/")) v = v.substring(1);
        if (v.startsWith("uploads/")) v = v.substring("uploads/".length());

        // keep filename only
        if (v.indexOf("/") >= 0) v = v.substring(v.lastIndexOf('/') + 1);

        return v;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String fileName = pickFileName(req);
        if (fileName == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        File f = new File(UPLOAD_BASE_DIR, fileName);
        if (!f.exists() || !f.isFile()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String lower = fileName.toLowerCase();
        if (lower.endsWith(".png")) resp.setContentType("image/png");
        else if (lower.endsWith(".gif")) resp.setContentType("image/gif");
        else resp.setContentType("image/jpeg");

        resp.setHeader("Cache-Control", "no-store");

        InputStream in = null;
        OutputStream out = null;
        try {
            in = new FileInputStream(f);
            out = resp.getOutputStream();

            byte[] buf = new byte[8192];
            int len;
            while ((len = in.read(buf)) > 0) {
                out.write(buf, 0, len);
            }
        } finally {
            try { if (in != null) in.close(); } catch (Exception e) {}
        }
    }
}
