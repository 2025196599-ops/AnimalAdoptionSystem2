package com.ariniqo.dao;

import com.ariniqo.model.Pet;
import com.ariniqo.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PetDAO {

        public List<Pet> getAllAvailable() {
            List<Pet> list = new ArrayList<>();

            String sql =
                "SELECT * FROM PETS " +
                "WHERE STATUS IS NULL " +
                "   OR TRIM(STATUS) = '' " +
                "   OR UPPER(STATUS) = 'AVAILABLE'";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    Pet p = new Pet();
                    p.setPetId(rs.getInt("PET_ID"));
                    p.setName(rs.getString("NAME"));
                    p.setType(rs.getString("TYPE"));
                    p.setBreed(rs.getString("BREED"));
                    p.setAge(rs.getInt("AGE"));
                    p.setStatus(rs.getString("STATUS"));
                    p.setImagePath(rs.getString("IMAGE_PATH"));
                    p.setDescription(rs.getString("DESCRIPTION"));
                    list.add(p);
                }

            } catch (Exception e) {
                e.printStackTrace();
            }

            return list;
        }


    public Pet getById(int petId) {
        String sql = "SELECT * FROM PETS WHERE PET_ID = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, petId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private Pet map(ResultSet rs) throws SQLException {
        Pet p = new Pet();
        p.setPetId(rs.getInt("PET_ID"));
        p.setName(rs.getString("NAME"));
        p.setType(rs.getString("TYPE"));
        p.setBreed(rs.getString("BREED"));
        p.setAge(rs.getInt("AGE"));
        p.setStatus(rs.getString("STATUS"));
        p.setImagePath(rs.getString("IMAGE_PATH"));
        p.setDescription(rs.getString("DESCRIPTION"));
        return p;
    }
}
