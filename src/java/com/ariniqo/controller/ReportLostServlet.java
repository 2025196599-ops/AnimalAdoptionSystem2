package com.ariniqo.controller;

import com.ariniqo.dao.LostFoundReportDAO;
import com.ariniqo.model.LostFoundReport;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;

@WebServlet("/reports/lost")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024)
public class ReportLostServlet extends HttpServlet {

    // ✅ SAME folder as AddPet
    private static final String UPLOAD_BASE_DIR =
            System.getProperty("user.home") + File.separator + "AnimalAdoptionSystem" + File.separator + "uploads";

    private String safe(String s) { return (s == null) ? "" : s.trim(); }

    private String saveUpload(Part part) throws IOException {
        if (part == null || part.getSize() == 0) return null;

        String submitted = part.getSubmittedFileName();
        if (submitted == null) submitted = "photo.jpg";

        submitted = submitted.replace("\\", "/");
        if (submitted.indexOf('/') >= 0) submitted = submitted.substring(submitted.lastIndexOf('/') + 1);
        submitted = submitted.replaceAll("[^a-zA-Z0-9._-]", "_");

        String fileName = System.currentTimeMillis() + "_" + submitted;

        File dir = new File(UPLOAD_BASE_DIR);
        if (!dir.exists()) dir.mkdirs();

        File dest = new File(dir, fileName);

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

        // ✅ store same style as AddPet
        return "uploads/" + fileName;
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            LostFoundReport r = new LostFoundReport();
            r.setReportType("LOST");
            r.setStatus("ACTIVE");

            r.setPetName(safe(req.getParameter("petName")));
            r.setPetType(safe(req.getParameter("petType")));
            r.setBreed(safe(req.getParameter("breed")));
            r.setAgeDesc(safe(req.getParameter("age")));
            r.setGender(safe(req.getParameter("gender")));
            r.setColorMarkings(safe(req.getParameter("color")));
            r.setDescription(safe(req.getParameter("description")));
            r.setDistinctiveFeatures(safe(req.getParameter("distinctiveFeatures")));
            r.setCollarDetails(safe(req.getParameter("collarDetails")));
            r.setReward(safe(req.getParameter("reward")));
            r.setLocationText(safe(req.getParameter("lostLocation")));
            r.setCity(safe(req.getParameter("city")));

            r.setState(safe(req.getParameter("state")));
            r.setPostcode(safe(req.getParameter("postcode")));

            r.setReporterName(safe(req.getParameter("ownerName")));
            r.setReporterEmail(safe(req.getParameter("email")));
            r.setReporterPhone(safe(req.getParameter("phone")));
            r.setReporterPhone2(safe(req.getParameter("alternatePhone")));

            String d = safe(req.getParameter("lostDate"));
            String t = safe(req.getParameter("lostTime"));
            if (d.length() > 0) r.setEventDate(java.sql.Date.valueOf(d));
            if (t.length() > 0) r.setEventTime(java.sql.Time.valueOf(t + ":00"));

            try {
                Part photo = req.getPart("petPhoto");
                r.setPhotoPath(saveUpload(photo)); // ✅ "uploads/xxx.jpg"
            } catch (Exception ex) {
                r.setPhotoPath(null);
            }

            int newId = new LostFoundReportDAO().insert(r);
            resp.sendRedirect(req.getContextPath() + "/reports?ui=user&submitted=1&id=" + newId);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
