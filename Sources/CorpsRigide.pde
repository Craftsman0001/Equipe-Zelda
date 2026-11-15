// Corps rigide en forme de boîte (pavé droit), avec physique linéaire et rotationnelle
class CorpsRigide {
    public Vecteur3D position;
    public Vecteur3D velocite = new Vecteur3D();
    public Vecteur3D acceleration = new Vecteur3D();
    public Quaternion orientation = new Quaternion();
    public Vecteur3D velocite_angulaire = new Vecteur3D();
    public Vecteur3D dimensions; // Taille complète de la boîte (largeur, hauteur, profondeur)

    // Facteurs d'amortissement dans [0, 1] : 1 = aucun amortissement
    public float damping_lineaire;
    public float damping_angulaire;

    public Vecteur3D accumulateur_force = new Vecteur3D();
    public Vecteur3D accumulateur_torque = new Vecteur3D();

    private float masse;
    private float inverse_masse;
    private Matrix3 inverse_tenseur_inertie_local = new Matrix3();
    private Matrix3 inverse_tenseur_inertie_monde = new Matrix3();
    private Matrix4 transformation = new Matrix4();

    CorpsRigide(Vecteur3D position_initiale, Vecteur3D dimensions, float masse,
                float damping_lineaire, float damping_angulaire) {
        this.position = position_initiale;
        this.dimensions = dimensions; // Doit être défini avant set_masse (tenseur d'inertie)
        this.damping_lineaire = damping_lineaire;
        this.damping_angulaire = damping_angulaire;

        set_masse(masse);
        calculer_donnees_derivees();
    }

    // Met à jour la masse et l'inverse du tenseur d'inertie local de la boîte
    void set_masse(float nouvelle_masse) {
        this.masse = nouvelle_masse;

        // Masse nulle ou négative : objet immobile (masse infinie)
        if (nouvelle_masse <= 0) {
            this.inverse_masse = 0.0;
            this.inverse_tenseur_inertie_local = new Matrix3(0, 0, 0,  0, 0, 0,  0, 0, 0);
            return;
        }
        this.inverse_masse = 1.0 / nouvelle_masse;

        // Tenseur d'inertie d'une boîte : I = m/12 * (a² + b²) sur chaque axe
        float w2 = dimensions.x * dimensions.x;
        float h2 = dimensions.y * dimensions.y;
        float d2 = dimensions.z * dimensions.z;
        float ixx = nouvelle_masse / 12.0 * (h2 + d2);
        float iyy = nouvelle_masse / 12.0 * (w2 + d2);
        float izz = nouvelle_masse / 12.0 * (w2 + h2);

        // Le tenseur est diagonal : son inverse est l'inverse de chaque terme
        this.inverse_tenseur_inertie_local = new Matrix3(
        1.0 / ixx, 0, 0,
        0, 1.0 / iyy, 0,
        0, 0, 1.0 / izz
        );
    }

    // Ajoute une force appliquée au centre de masse (aucun torque)
    void ajouter_force(Vecteur3D force) {
        accumulateur_force = accumulateur_force.add(force);
    }

    // Ajoute une force appliquée à un point (coordonnées monde) : génère un torque
    void ajouter_force_au_point(Vecteur3D force, Vecteur3D point_monde) {
        accumulateur_force = accumulateur_force.add(force);

        // torque = r x F, avec r le bras de levier depuis le centre de masse
        Vecteur3D bras_de_levier = point_monde.sub(position);
        accumulateur_torque = accumulateur_torque.add(bras_de_levier.produit_vectoriel(force));
    }

    // Vide les accumulateurs à la fin de chaque pas d'intégration
    void vider_accumulateurs() {
        accumulateur_force = new Vecteur3D();
        accumulateur_torque = new Vecteur3D();
    }

    // Intégration d'Euler (semi-implicite) des mouvements linéaire et rotationnel
    void integrer_euler(float dt) {
        // Éviter qu'un objet de masse infinie ne subisse des calculs inutiles
        if (inverse_masse <= 0) {
            vider_accumulateurs();
            return;
        }

        // a = F / m  et  alpha = I^-1 (monde) * torque
        acceleration = accumulateur_force.mult(inverse_masse);
        Vecteur3D acceleration_angulaire = inverse_tenseur_inertie_monde.mult(accumulateur_torque);

        // v1 = v0 + a * dt  et  w1 = w0 + alpha * dt
        velocite = velocite.add(acceleration.mult(dt));
        velocite_angulaire = velocite_angulaire.add(acceleration_angulaire.mult(dt));

        // Amortissement indépendant du pas de temps : v *= d^dt
        velocite = velocite.mult(pow(damping_lineaire, dt));
        velocite_angulaire = velocite_angulaire.mult(pow(damping_angulaire, dt));

        // p1 = p0 + v1 * dt  et  q1 = q0 + dt/2 * w1 * q0 (normalisé)
        position = position.add(velocite.mult(dt));
        orientation.mettre_a_jour_orientation(velocite_angulaire, dt);

        calculer_donnees_derivees();
        vider_accumulateurs();
    }

    // Recalcule la matrice de transformation et le tenseur d'inertie inverse en coordonnées monde
    void calculer_donnees_derivees() {
        transformation.depuis_orientation_et_position(orientation, position);

        // I^-1 (monde) = R * I^-1 (local) * R^T
        Matrix3 rotation = new Matrix3();
        rotation.depuis_quaternion(orientation);
        inverse_tenseur_inertie_monde = rotation.mult(inverse_tenseur_inertie_local).mult(rotation.transposer());
    }

    float get_masse() {
        return this.masse;
    }

    float get_inverse_masse() {
        return this.inverse_masse;
    }

    Matrix4 get_transformation() {
        return this.transformation;
    }

    Matrix3 get_inverse_tenseur_inertie_monde() {
        return this.inverse_tenseur_inertie_monde;
    }
}
