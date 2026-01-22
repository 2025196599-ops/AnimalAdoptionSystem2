package com.ariniqo.dao;

import com.ariniqo.model.Article;
import com.ariniqo.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ArticleDAO {

    public int insertPending(Article a) throws SQLException {
        String sql = "INSERT INTO ARTICLES (TITLE, CATEGORY, AUTHOR_NAME, AUTHOR_EMAIL, EXCERPT, CONTENT, IMAGE_URL, STATUS, SUBMITTED_DATE) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, 'PENDING', CURRENT_TIMESTAMP)";

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            ps.setString(1, a.getTitle());
            ps.setString(2, a.getCategory());
            ps.setString(3, a.getAuthorName());
            ps.setString(4, a.getAuthorEmail());
            ps.setString(5, a.getExcerpt());
            ps.setString(6, a.getContent());

            String img = a.getImageUrl();
            if (img == null || img.trim().length() == 0) {
                ps.setNull(7, Types.VARCHAR);
            } else {
                ps.setString(7, img.trim());
            }

            ps.executeUpdate();

            rs = ps.getGeneratedKeys();
            if (rs != null && rs.next()) {
                return rs.getInt(1);
            }

            return -1;

        } catch (SQLException e) {
            throw e;
        } catch (Exception e) {
            throw new SQLException("insertPending failed: " + e.getMessage(), e);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }

        public List<Article> listApproved() throws SQLException {
            String sql = "SELECT * FROM ARTICLES WHERE TRIM(UPPER(STATUS))='APPROVED' ORDER BY SUBMITTED_DATE DESC";
            return list(sql);
        }

        public List<Article> listPending() throws SQLException {
            String sql = "SELECT * FROM ARTICLES WHERE TRIM(UPPER(STATUS))='PENDING' ORDER BY SUBMITTED_DATE DESC";
            return list(sql);
        }


    public Article getById(int id) throws SQLException {
        String sql = "SELECT * FROM ARTICLES WHERE ARTICLE_ID=?";

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);

            rs = ps.executeQuery();
            if (rs.next()) return map(rs);

            return null;

        } catch (SQLException e) {
            throw e;
        } catch (Exception e) {
            throw new SQLException("getById failed: " + e.getMessage(), e);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }

    public void updateStatus(int id, String status) throws SQLException {
        if (status == null) throw new SQLException("Status is null");

        String s = status.trim().toUpperCase();
        if (!s.equals("APPROVED") && !s.equals("REJECTED") && !s.equals("PENDING")) {
            throw new SQLException("Invalid status: " + status);
        }

        String sql = "UPDATE ARTICLES SET STATUS=?, REVIEWED_DATE=CURRENT_TIMESTAMP WHERE ARTICLE_ID=?";

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, s);
            ps.setInt(2, id);
            ps.executeUpdate();

        } catch (SQLException e) {
            throw e;
        } catch (Exception e) {
            throw new SQLException("updateStatus failed: " + e.getMessage(), e);
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }

    private List<Article> list(String sql) throws SQLException {
        List<Article> out = new ArrayList<Article>();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                out.add(map(rs));
            }

            return out;

        } catch (SQLException e) {
            throw e;
        } catch (Exception e) {
            throw new SQLException("list failed: " + e.getMessage(), e);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }

    private Article map(ResultSet rs) throws SQLException {
        Article a = new Article();
        a.setArticleId(rs.getInt("ARTICLE_ID"));
        a.setTitle(rs.getString("TITLE"));
        a.setCategory(rs.getString("CATEGORY"));
        a.setAuthorName(rs.getString("AUTHOR_NAME"));
        a.setAuthorEmail(rs.getString("AUTHOR_EMAIL"));
        a.setExcerpt(rs.getString("EXCERPT"));
        a.setContent(rs.getString("CONTENT"));
        a.setImageUrl(rs.getString("IMAGE_URL"));
        a.setStatus(rs.getString("STATUS"));
        a.setSubmittedDate(rs.getTimestamp("SUBMITTED_DATE"));
        a.setReviewedDate(rs.getTimestamp("REVIEWED_DATE"));
        return a;
    }
    public int deleteById(int id) throws SQLException {
        String sql = "DELETE FROM ARTICLES WHERE ARTICLE_ID = ?";

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate();

        } catch (SQLException e) {
            throw e;
        } catch (Exception e) {
            throw new SQLException("deleteById failed: " + e.getMessage(), e);
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }

}

        
