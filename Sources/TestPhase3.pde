class TestPhase3 {
  void executerTests() {
    println("--- TESTS UNITAIRES MATHS PHASE 3 (QUATERNION, MATRIX3, MATRIX4) ---");

    // Tests Quaternion
    tester_quaternion_normalisation();
    tester_quaternion_multiplication();
    tester_quaternion_mise_a_jour_orientation();

    // Tests Matrix3
    tester_matrix3_operations_base();
    tester_matrix3_transposee_et_determinant();
    tester_matrix3_inversion();
    tester_matrix3_depuis_quaternion();

    // Tests Matrix4
    tester_matrix4_operations_base();
    tester_matrix4_position_vs_direction();
    tester_matrix4_inversion();
    tester_matrix4_depuis_orientation_et_position();

    println("\n--- FIN DES TESTS ---");
  }

  void tester_quaternion_normalisation() {
    println("\n>> Quaternion : Normalisation");

    // Cas standard : Quaternion avec composantes positives
    Quaternion q = new Quaternion(0, 0, 3, 4);
    q.normaliser();
    valider_test("Normalisation simple", abs(q.w - 0.0) < 0.001 && abs(q.x - 0.0) < 0.001 && abs(q.y - 0.6) < 0.001 && abs(q.z - 0.8) < 0.001);

    // Edge case : Valeurs négatives
    Quaternion q_neg = new Quaternion(-2, 0, 0, 0);
    q_neg.normaliser();
    valider_test("Normalisation avec valeurs negatives", q_neg.w == -1 && q_neg.x == 0 && q_neg.y == 0 && q_neg.z == 0);

    // Edge case : Très petites valeurs
    Quaternion q_petit = new Quaternion(0, 0.0005, 0, 0);
    q_petit.normaliser();
    valider_test("Normalisation avec valeurs minuscules", abs(q_petit.x - 1.0) < 0.001);

    // Edge case : Quaternion nul
    Quaternion q_nul = new Quaternion(0, 0, 0, 0);
    q_nul.normaliser();
    valider_test("Normalisation du quaternion nul", q_nul.w == 1 && q_nul.x == 0 && q_nul.y == 0 && q_nul.z == 0);
  }

  void tester_quaternion_multiplication() {
    println("\n>> Quaternion : Multiplication");

    // Cas standard : Multiplication par un scalaire
    Quaternion q_base = new Quaternion(1, -2, 3, -4);
    Quaternion q_scal = q_base.mult(2.0);
    valider_test("Multiplication par un scalaire positif", q_scal.w == 2 && q_scal.x == -4 && q_scal.y == 6 && q_scal.z == -8);

    // Edge case : Multiplication par zéro
    Quaternion q_zero = q_base.mult(0.0);
    valider_test("Multiplication par zero", q_zero.w == 0 && q_zero.x == 0 && q_zero.y == 0 && q_zero.z == 0);

    // Cas standard : Produit de Hamilton
    Quaternion qi = new Quaternion(0, 1, 0, 0);
    Quaternion qj = new Quaternion(0, 0, 1, 0);
    Quaternion qk = qi.mult(qj);
    valider_test("Produit de Hamilton", qk.w == 0 && qk.x == 0 && qk.y == 0 && qk.z == 1);

    // Edge case : Non-commutativité du produit de Hamilton
    Quaternion q_inv = qj.mult(qi);
    valider_test("Non-commutativite de Hamilton", q_inv.w == 0 && q_inv.x == 0 && q_inv.y == 0 && q_inv.z == -1);

    // Edge case : Multiplication par le quaternion identité
    Quaternion q1 = new Quaternion(0.5, 0.5, 0.5, 0.5);
    Quaternion res_id = q1.mult(new Quaternion(1, 0, 0, 0));
    valider_test("Multiplication par identite", res_id.w == 0.5 && res_id.x == 0.5 && res_id.y == 0.5 && res_id.z == 0.5);
  }

  void tester_quaternion_mise_a_jour_orientation() {
    println("\n>> Quaternion : Mise a jour de l orientation");

    // Cas standard : Rotation autour de l'axe Y pendant dt = 0.1s
    Quaternion q = new Quaternion(1, 0, 0, 0);
    Vecteur3D omega = new Vecteur3D(0, 2.0, 0);
    q.mettre_a_jour_orientation(omega, 0.1);
    float norme = sqrt(q.w*q.w + q.x*q.x + q.y*q.y + q.z*q.z);
    valider_test("Mise a jour orientation et maintien de la norme a 1", q.y > 0 && abs(norme - 1.0) < 0.001);

    // Edge case : Vitesse angulaire nulle
    Quaternion q_fixe = new Quaternion(1, 0, 0, 0);
    q_fixe.mettre_a_jour_orientation(new Vecteur3D(0, 0, 0), 0.1);
    valider_test("Mise a jour avec vitesse angulaire nulle", q_fixe.w == 1 && q_fixe.x == 0 && q_fixe.y == 0 && q_fixe.z == 0);

    // Edge case : Temps écoulé nul
    Quaternion q_dt_zero = new Quaternion(1, 0, 0, 0);
    q_dt_zero.mettre_a_jour_orientation(new Vecteur3D(5, 5, 5), 0.0);
    valider_test("Mise a jour avec dt = 0", q_dt_zero.w == 1 && q_dt_zero.x == 0 && q_dt_zero.y == 0 && q_dt_zero.z == 0);
  }

  void tester_matrix3_operations_base() {
    println("\n>> Matrix3 : Operations de base");

    // Cas standard : Addition de deux matrices identité
    Matrix3 m1 = new Matrix3();
    Matrix3 m_add = m1.add(new Matrix3());
    valider_test("Addition de deux Matrix3", m_add.m[0] == 2 && m_add.m[4] == 2 && m_add.m[8] == 2 && m_add.m[1] == 0);

    // Edge case : Multiplication par scalaire négatif et zéro
    Matrix3 m_neg = m1.mult(-3.0);
    Matrix3 m_zero = m1.mult(0.0);
    valider_test("Multiplication Matrix3 par un scalaire negatif", m_neg.m[0] == -3 && m_neg.m[4] == -3 && m_neg.m[1] == 0);
    valider_test("Multiplication Matrix3 par zero", m_zero.m[0] == 0 && m_zero.m[4] == 0 && m_zero.m[8] == 0);

    // Cas standard : Multiplication d'un vecteur par une matrice diagonale
    Matrix3 m_diag = new Matrix3(2, 0, 0,  0, 3, 0,  0, 0, 4);
    Vecteur3D v_res = m_diag.mult(new Vecteur3D(1, 2, 3));
    valider_test("Multiplication Matrix3 par Vecteur3D", v_res.x == 2 && v_res.y == 6 && v_res.z == 12);

    // Edge case : Multiplication Matrix3 par le vecteur nul
    Vecteur3D v_nul = m_diag.mult(new Vecteur3D(0, 0, 0));
    valider_test("Multiplication Matrix3 par Vecteur nul", v_nul.x == 0 && v_nul.y == 0 && v_nul.z == 0);

    // Edge case : Multiplication d'une Matrix3 par la matrice identité
    Matrix3 m_prod = m_diag.mult(new Matrix3());
    valider_test("Produit Matrix3 par Identite", m_prod.m[0] == 2 && m_prod.m[4] == 3 && m_prod.m[8] == 4);
  }

  void tester_matrix3_transposee_et_determinant() {
    println("\n>> Matrix3 : Transposee et Determinant");

    // Cas standard : Transposée
    Matrix3 m = new Matrix3(1, 2, 3,  4, 5, 6,  7, 8, 9);
    Matrix3 mt = m.transposer();
    valider_test("Transposee Matrix3", mt.m[1] == 4 && mt.m[3] == 2 && mt.m[2] == 7 && mt.m[6] == 3);

    // Edge case : Double transposée
    Matrix3 mtt = mt.transposer();
    valider_test("Double transposee", mtt.m[1] == 2 && mtt.m[3] == 4 && mtt.m[2] == 3);

    // Cas standard : Déterminant d'une matrice diagonale
    Matrix3 m_diag = new Matrix3(2, 0, 0,  0, 3, 0,  0, 0, 4);
    valider_test("Determinant Matrix3", m_diag.determinant() == 24.0);

    // Edge case : Déterminant d'une matrice avec deux lignes identiques
    Matrix3 m_lignes_egales = new Matrix3(1, 2, 3,  1, 2, 3,  4, 5, 6);
    valider_test("Determinant nul", m_lignes_egales.determinant() == 0.0);
  }

  void tester_matrix3_inversion() {
    println("\n>> Matrix3 : Inversion");

    // Cas standard : Inverse d'une matrice diagonale
    Matrix3 m = new Matrix3(2, 0, 0,  0, 4, 0,  0, 0, 5);
    Matrix3 inv = m.inverser();
    valider_test("Inversion Matrix3", abs(inv.m[0] - 0.5) < 0.001 && abs(inv.m[4] - 0.25) < 0.001 && abs(inv.m[8] - 0.2) < 0.001);

    // Edge case : Matrice nulle
    Matrix3 m_zero = new Matrix3(0, 0, 0,  0, 0, 0,  0, 0, 0);
    Matrix3 inv_secours = m_zero.inverser();
    valider_test("Inversion Matrix3 nulle", inv_secours.m[0] == 1 && inv_secours.m[4] == 1 && inv_secours.m[8] == 1);

    // Edge case : Déterminant minuscule sous le seuil
    Matrix3 m_presque_zero = new Matrix3(0.001, 0, 0,  0, 0.001, 0,  0, 0, 0.0001); // det = 10^-10
    Matrix3 inv_presque_zero = m_presque_zero.inverser();
    valider_test("Inversion Matrix3 sous le seuil epsilon (securite identite)", inv_presque_zero.m[0] == 1 && inv_presque_zero.m[4] == 1);
  }

  void tester_matrix3_depuis_quaternion() {
    println("\n>> Matrix3 : Conversion depuis Quaternion");

    // Cas standard : Quaternion de rotation de 180 degrés autour de Z
    Matrix3 m = new Matrix3();
    m.depuis_quaternion(new Quaternion(0, 0, 0, 1));
    valider_test("Matrix3 depuis Quaternion", abs(m.m[0] - (-1)) < 0.001 && abs(m.m[4] - (-1)) < 0.001 && abs(m.m[8] - 1) < 0.001);

    // Edge case : Quaternion identité
    m.depuis_quaternion(new Quaternion(1, 0, 0, 0));
    valider_test("Matrix3 depuis Quaternion identite", m.m[0] == 1 && m.m[4] == 1 && m.m[8] == 1 && m.m[1] == 0);
  }

  void tester_matrix4_operations_base() {
    println("\n>> Matrix4 : Operations de base et Produit");

    // Cas standard : Produit de deux matrices de translation pure
    Matrix4 t1 = new Matrix4(1, 0, 0, 10,   0, 1, 0, 20,   0, 0, 1, 30);
    Matrix4 t2 = new Matrix4(1, 0, 0, 5,    0, 1, 0, -5,   0, 0, 1, 10);
    Matrix4 t_comb = t1.mult(t2);
    valider_test("Produit Matrix4", t_comb.m[3] == 15 && t_comb.m[7] == 15 && t_comb.m[11] == 40);

    // Edge case : Produit par la matrice identité
    Matrix4 t_id = t1.mult(new Matrix4());
    valider_test("Produit Matrix4 * Identite", t_id.m[3] == 10 && t_id.m[7] == 20 && t_id.m[11] == 30);

    // Cas standard : Copie indépendante
    Matrix4 copie = new Matrix4(t1);
    t1.m[3] = 999;
    valider_test("Constructeur de copie Matrix4", copie.m[3] == 10);
  }

  void tester_matrix4_position_vs_direction() {
    println("\n>> Matrix4 : Transformation Position vs Direction");

    // Matrice avec translation et sans rotation
    Matrix4 mat = new Matrix4(1, 0, 0, 10,   0, 1, 0, -20,   0, 0, 1, 30);
    Vecteur3D v = new Vecteur3D(1, 2, 3);

    // Cas standard : transformation d'une position
    Vecteur3D pos_trans = mat.transformer_position(v);
    valider_test("Transformation d'une position", pos_trans.x == 11 && pos_trans.y == -18 && pos_trans.z == 33);

    // Cas standard : transformation d'une direction
    Vecteur3D dir_trans = mat.transformer_direction(v);
    valider_test("Transformation d'une direction", dir_trans.x == 1 && dir_trans.y == 2 && dir_trans.z == 3);

    // Edge case : Vecteur nul transformé en position vs direction
    Vecteur3D pos_origine = mat.transformer_position(new Vecteur3D(0, 0, 0));
    Vecteur3D dir_nulle = mat.transformer_direction(new Vecteur3D(0, 0, 0));
    valider_test("Vecteur nul transformé en position", pos_origine.x == 10 && pos_origine.y == -20 && pos_origine.z == 30);
    valider_test("Vecteur nul transformé en direction", dir_nulle.x == 0 && dir_nulle.y == 0 && dir_nulle.z == 0);
  }

  void tester_matrix4_inversion() {
    println("\n>> Matrix4 : Inversion");

    // Cas standard : Matrice avec échelle x2 et translation
    Matrix4 m = new Matrix4(2, 0, 0, 4,   0, 2, 0, -6,   0, 0, 2, 8);
    Matrix4 inv = m.inverser();
    valider_test("Inversion Matrix4", abs(inv.m[0] - 0.5) < 0.001 && abs(inv.m[3] - (-2.0)) < 0.001 && abs(inv.m[7] - 3.0) < 0.001 && abs(inv.m[11] - (-4.0)) < 0.001);

    // Cas standard : Vérification que M * M^-1 = Identité
    Matrix4 prod_id = m.mult(inv);
    valider_test("Vérification M * M^-1 = Identité", abs(prod_id.m[0] - 1.0) < 0.001 && abs(prod_id.m[3] - 0.0) < 0.001 && abs(prod_id.m[7] - 0.0) < 0.001 && abs(prod_id.m[11] - 0.0) < 0.001);

    // Edge case : Matrice 3x4 singulière
    Matrix4 m_sing = new Matrix4(0, 0, 0, 10,   0, 0, 0, 20,   0, 0, 0, 30);
    Matrix4 inv_secours = m_sing.inverser();
    valider_test("Inversion Matrix4 singuliere", inv_secours.m[0] == 1 && inv_secours.m[5] == 1 && inv_secours.m[10] == 1 && inv_secours.m[3] == 0);
  }

  void tester_matrix4_depuis_orientation_et_position() {
    println("\n>> Matrix4 : Construction depuis Orientation et Position");

    // Cas standard : Quaternion identité et position avec valeurs négatives
    Matrix4 m = new Matrix4();
    Quaternion q = new Quaternion(1, 0, 0, 0);
    Vecteur3D pos = new Vecteur3D(-5, 12, 42);
    m.depuis_orientation_et_position(q, pos);

    valider_test("Construction depuis Orientation et Position", m.m[0] == 1 && m.m[5] == 1 && m.m[10] == 1 && m.m[3] == -5 && m.m[7] == 12 && m.m[11] == 42);
  }

  void valider_test(String nom_test, boolean condition) {
    if (condition) {
      println(nom_test + " : [OK]");
    } else {
      println(nom_test + " : [RATE]");
    }
  }
}