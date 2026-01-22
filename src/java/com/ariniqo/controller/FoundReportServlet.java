package com.ariniqo.controller;

import com.ariniqo.dao.LostFoundReportDAO;
import com.ariniqo.model.LostFoundReport;
import com.ariniqo.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.sql.Date;
import java.sql.Time;

@WebServlet("/reports/found")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024)
public class FoundReportServlet extends HttpServlet {

    private static final String UPLOAD_BASE_DIR =
            System.getProperty("user.home") + File.separator + "AnimalAdoptionSystem" + File.separator + "uploads";

    private String safe(String s) { return (s == null) ? "" : s.trim(); }

    private boolean isLoggedIn(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return false;
        Object u = session.getAttribute("user");
        if (u instanceof User) return true;
        return session.getAttribute("userEmail") != null;
    }

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

        return "uploads/" + fileName; // ✅ same as AddPet
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isLoggedIn(req)) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try {
            LostFoundReport r = new LostFoundReport();
            r.setReportType("FOUND");
            r.setStatus("ACTIVE");

            r.setPetType(safe(req.getParameter("animalType")));
            r.setBreed(safe(req.getParameter("breed")));
            r.setGender(safe(req.getParameter("gender")));
            r.setColorMarkings(safe(req.getParameter("color")));

            r.setPetName("");
            r.setAgeDesc("");

            String condition = safe(req.getParameter("condition"));
            String injuries = safe(req.getParameter("injuries"));
            String circumstances = safe(req.getParameter("foundCircumstances"));

            StringBuilder desc = new StringBuilder();
            if (condition.length() > 0) desc.append("Condition: ").append(condition).append("\n");
            if (injuries.length() > 0) desc.append("Injuries/Issues: ").append(injuries).append("\n");
            if (circumstances.length() > 0) desc.append("Circumstances: ").append(circumstances).append("\n");

            if ("1".equals(req.getParameter("hasCollar"))) desc.append("Has collar/tags: Yes\n");
            if ("1".equals(req.getParameter("isFriendly"))) desc.append("Friendly/approachable: Yes\n");
            if ("1".equals(req.getParameter("needsVet"))) desc.append("Needs vet attention: Yes\n");
            if ("1".equals(req.getParameter("animalSafe"))) desc.append("Animal in safe location: Yes\n");
            if ("1".equals(req.getParameter("canFoster"))) desc.append("Finder can foster: Yes\n");

            r.setDescription(desc.toString().trim());
            r.setDistinctiveFeatures(safe(req.getParameter("contactNotes")));

            String foundAddress = safe(req.getParameter("foundAddress"));
            String area = safe(req.getParameter("area"));
            r.setLocationText((foundAddress + " " + area).trim());

            r.setCity(safe(req.getParameter("city")));
            r.setState(safe(req.getParameter("state")));
            r.setPostcode(safe(req.getParameter("postcode")));

            String foundDate = safe(req.getParameter("foundDate"));
            if (foundDate.length() > 0) r.setEventDate(Date.valueOf(foundDate));

            String foundTime = safe(req.getParameter("foundTime"));
            if (foundTime.length() > 0) r.setEventTime(Time.valueOf(foundTime + ":00"));

            r.setReporterName(safe(req.getParameter("finderName")));
            r.setReporterEmail(safe(req.getParameter("finderEmail")));
            r.setReporterPhone(safe(req.getParameter("finderPhone")));
            r.setReporterPhone2(safe(req.getParameter("finderPhone2")));

            Part firstPhoto = null;
            for (Part p : req.getParts()) {
                if ("photos".equals(p.getName()) && p.getSize() > 0) {
                    firstPhoto = p;
                    break;
                }
            }

            try {
                r.setPhotoPath(saveUpload(firstPhoto)); // ✅ uploads/xxx.jpg
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
