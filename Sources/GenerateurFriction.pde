class GenerateurFriction implements GenerateurDeForce {

  float k1; // coefficient de friction linéaire
  float k2; // coefficient de friction quadratique

  GenerateurFriction(float k1, float k2) {
    this.k1 = k1;
    this.k2 = k2;
  }

  void appliquer_force(Particule particule, float duree) {
    float norme = particule.velocite.norme();
    if (norme == 0) return;

    // copie de la vélocité (mult(1.0) retourne un nouveau vecteur) avant de la
    // rendre unitaire, pour ne pas modifier particule.velocite
    Vecteur3D direction = particule.velocite.mult(1.0);
    direction.normaliser();

    float magnitude = k1 * norme + k2 * norme * norme;
    particule.ajouter_force(direction.mult(-magnitude));
  }
}
