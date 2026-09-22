class TestVecteur3D {
  void executerTests() {
    println("--- TESTS UNITAIRES VECTEUR 3D ---");

    tester_addition();
    tester_soustraction();
    tester_multiplication_scalaire();
    tester_multiplication_composantes();
    tester_produit_scalaire();
    tester_produit_vectoriel();
    tester_normes();
    tester_normalisation();

    println("\n--- FIN DES TESTS ---");
  }

  void tester_addition() {
    println("\n>> Addition");
    
    // Cas standard
    Vecteur3D v1 = new Vecteur3D(1, 2, 3);
    Vecteur3D res_add = v1.add(new Vecteur3D(4, 5, 6));
    valider_test("Addition de deux vecteurs positifs", res_add.x == 5 && res_add.y == 7 && res_add.z == 9);
    
    // Edge case : Addition avec des nombres négatifs
    Vecteur3D res_add_neg = v1.add(new Vecteur3D(-1, -4, 0));
    valider_test("Addition avec valeurs negatives", res_add_neg.x == 0 && res_add_neg.y == -2 && res_add_neg.z == 3);

    // Edge case : Addition avec le vecteur nul
    Vecteur3D res_add_nul = v1.add(new Vecteur3D(0, 0, 0));
    valider_test("Addition avec vecteur nul", res_add_nul.x == 1 && res_add_nul.y == 2 && res_add_nul.z == 3);
  }

  void tester_soustraction() {
    println("\n>> Soustraction");
    
    // Cas standard
    Vecteur3D v3 = new Vecteur3D(5, 7, 9);
    v3.sub(new Vecteur3D(1, 2, 3));
    valider_test("Soustraction entre deux vecteurs positifs", v3.x == 4 && v3.y == 5 && v3.z == 6);

    // Edge case : Soustraction de nombres négatifs
    Vecteur3D v4 = new Vecteur3D(5, 7, 9);
    v4.sub(new Vecteur3D(-2, -3, -4));
    valider_test("Soustraction avec valeurs negatives", v4.x == 7 && v4.y == 10 && v4.z == 13);

    // Edge case : Soustraction avec le vecteur nul
    // Edge case : Soustraction avec le vecteur nul
    Vecteur3D v5 = new Vecteur3D(1, 2, 3);
    v5.sub(new Vecteur3D(0, 0, 0));
    valider_test("Soustraction avec vecteur nul", v5.x == 1 && v5.y == 2 && v5.z == 3);
  }

  void tester_multiplication_scalaire() {
    println("\n>> Multiplication scalaire");
    
    // Cas standard
    Vecteur3D v6 = new Vecteur3D(2, -3, 4);
    Vecteur3D res_mult = v6.mult(2.0);
    valider_test("Multiplication par un scalaire positif", res_mult.x == 4 && res_mult.y == -6 && res_mult.z == 8);
    
    // Edge case : Multiplication par zéro
    Vecteur3D res_zero = v6.mult(0);
    valider_test("Multiplication par zero (vecteur nul)", res_zero.x == 0 && res_zero.y == 0 && res_zero.z == 0);

    // Edge case : Multiplication par un nombre négatif
    Vecteur3D res_negatif = v6.mult(-1.5);
    valider_test("Multiplication par un scalaire negatif", res_negatif.x == -3.0 && res_negatif.y == 4.5 && res_negatif.z == -6.0);
  }

  void tester_multiplication_composantes() {
    println("\n>> Multiplication par composantes");
    
    // Cas standard
    Vecteur3D v7 = new Vecteur3D(2, 3, 4);
    Vecteur3D multiplicateur = new Vecteur3D(2, 0, -1);
    v7.mult(multiplicateur);
    String nom_du_test = "Multiplication par composantes (" + multiplicateur.x + ", " + multiplicateur.y + ", " + multiplicateur.z + ")";
    valider_test(nom_du_test, v7.x == 4 && v7.y == 0 && v7.z == -4);
  }

  void tester_produit_scalaire() {
    println("\n>> Produit Scalaire");
    
    // Cas standard
    Vecteur3D v8 = new Vecteur3D(1, 2, 3);
    Vecteur3D v9 = new Vecteur3D(4, -5, 6);
    float res_scalaire = v8.produit_scalaire(v9);
    valider_test("Produit scalaire simple", res_scalaire == 12.0);

    // Edge case : Vecteurs perpendiculaires
    Vecteur3D axe_x = new Vecteur3D(1, 0, 0);
    Vecteur3D axe_y = new Vecteur3D(0, 1, 0);
    float res_perp = axe_x.produit_scalaire(axe_y);
    valider_test("Vecteurs perpendiculaires", res_perp == 0.0);
  }

  void tester_produit_vectoriel() {
    println("\n>> Produit Vectoriel");
    
    // Cas standard
    Vecteur3D axe_x = new Vecteur3D(1, 0, 0);
    Vecteur3D axe_y = new Vecteur3D(0, 1, 0);
    Vecteur3D res_vectoriel = axe_x.produit_vectoriel(axe_y);
    valider_test("Produit vectoriel simple", res_vectoriel.x == 0 && res_vectoriel.y == 0 && res_vectoriel.z == 1);
    
    // Edge case : Vecteurs parallèles
    Vecteur3D res_parallele = axe_x.produit_vectoriel(new Vecteur3D(5, 0, 0));
    valider_test("Vecteurs paralleles", res_parallele.x == 0 && res_parallele.y == 0 && res_parallele.z == 0);

    // Edge case : Vecteur nul
    Vecteur3D res_nul = axe_x.produit_vectoriel(new Vecteur3D(0, 0, 0));
    valider_test("Produit avec vecteur nul", res_nul.x == 0 && res_nul.y == 0 && res_nul.z == 0);
  }

  void tester_normes() {
    println("\n>> Norme et Norme au carre");
    
    // Cas standard
    Vecteur3D v10 = new Vecteur3D(2, 3, 6);
    valider_test("Norme au carre", v10.norme_carree() == 49.0);
    valider_test("Norme", v10.norme() == 7.0);

    // Edge case : Valeurs négatives
    Vecteur3D v_negatif = new Vecteur3D(-2, -3, -6);
    valider_test("Norme avec valeurs negatives", v_negatif.norme() == 7.0);
    
    // Edge case : Vecteur nul
    Vecteur3D v_zero = new Vecteur3D(0, 0, 0);
    valider_test("Norme du vecteur nul", v_zero.norme() == 0.0);
  }

  void tester_normalisation() {
    println("\n>> Normalisation");

    // Cas standard
    Vecteur3D v11 = new Vecteur3D(0, 3, 4);
    v11.normaliser();
    valider_test("Normalisation simple", abs(v11.y - 0.6) < 0.001 && abs(v11.z - 0.8) < 0.001);

    // Edge Case : Vecteur nul
    Vecteur3D v_zero = new Vecteur3D(0, 0, 0);
    v_zero.normaliser();
    valider_test("Vecteur nul", v_zero.x == 0 && v_zero.y == 0 && v_zero.z == 0);

    // Edge Case : Valeurs négatives
    Vecteur3D v_neg = new Vecteur3D(-5, 0, 0);
    v_neg.normaliser();
    valider_test("Valeurs negatives", v_neg.x == -1 && v_neg.y == 0 && v_neg.z == 0);
    
    // Edge Case : Très petites valeurs
    Vecteur3D v_petit = new Vecteur3D(0.0001, 0, 0);
    v_petit.normaliser();
    valider_test("Valeurs minuscules", v_petit.x == 1 && v_petit.y == 0 && v_petit.z == 0);
  }

  void valider_test(String nom_test, boolean condition) {
    if (condition) {
      println(nom_test + " : [OK]");
    } else {
      println(nom_test + " : [RATE]");
    }
  }
}