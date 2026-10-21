class GenerateurAmortissement implements GenerateurDeForce {

  float c = 20.0;

  GenerateurAmortissement(float c) {
    this.c = c;
  }

  void appliquer_force(Particule particule, float duree) {
    Vecteur3D force = particule.velocite.mult(-c);

    particule.ajouter_force(force);
  }
}
