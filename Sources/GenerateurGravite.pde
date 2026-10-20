// Force constante de gravité, appliquée proportionnellement à la masse (F = m*g).
class GenerateurGravite implements GenerateurDeForce {

  Vecteur3D gravite;

  GenerateurGravite(Vecteur3D gravite) {
    this.gravite = gravite;
  }

  void appliquer_force(Particule particule, float duree) {
    if (particule.get_inverse_masse() == 0) return;
    particule.ajouter_force(gravite.mult(particule.get_masse()));
  }
}
