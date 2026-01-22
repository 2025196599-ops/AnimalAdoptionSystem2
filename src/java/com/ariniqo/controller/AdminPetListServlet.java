/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ariniqo.controller;

import com.ariniqo.dao.PetDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/pets")
public class AdminPetListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("pets", new PetDAO().getAllAvailable()); // or create a listAll() if you want all
        request.getRequestDispatcher("/admin/pet-list.jsp").forward(request, response);
    }
}
