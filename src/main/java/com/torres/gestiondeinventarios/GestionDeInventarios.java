/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */

package com.torres.gestiondeinventarios;
import login.LoginJFrame;
/**
 *
 * @author waldi
 */
public class GestionDeInventarios {

    public static void main(String[] args) {
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new LoginJFrame().setVisible(true);//Abre el LoginJFrame
                //No hay método main y es para cerrar sesion en el programa
            }
        });
    }
}
