class GenerateurRessortAncreParticule extends GenerateurRessort {

  Vecteur3D position_ancre;

  GenerateurRessortAncreParticule(Vecteur3D position_ancre, float longueur_repos, float k) {
    super(longueur_repos, k);
    this.position_ancre = position_ancre;
  }

  void appliquer_force(Particule particule, float duree) {
    Vecteur3D force_ressort = new Vecteur3D(position_ancre);
    force_ressort = force_ressort.sub(particule.position);

    float stretch = force_ressort.norme() - longueur_repos;

    force_ressort.normaliser();
    force_ressort = force_ressort.mult(k * stretch);

    particule.ajouter_force(force_ressort);
  }

  void dessiner(Particule p) {
    stroke(255);
    line(position_ancre.x, position_ancre.y, p.position.x, p.position.y);
  }
}
